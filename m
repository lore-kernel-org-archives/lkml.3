Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752277AbbAQRCQ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Jan 2015 12:02:16 -0500
Received: from mail-qg0-f50.google.com ([209.85.192.50]:53918 "EHLO
	mail-qg0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751255AbbAQRCP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Jan 2015 12:02:15 -0500
MIME-Version: 1.0
In-Reply-To: <CAFUqUc6PwX7hE29DUBigPXhZWMbz3FyJdRL+JptW8rkui5D6eA@mail.gmail.com>
References: <CAFUqUc6PwX7hE29DUBigPXhZWMbz3FyJdRL+JptW8rkui5D6eA@mail.gmail.com>
From: Bjorn Helgaas <bhelgaas@google.com>
Date: Sat, 17 Jan 2015 11:01:53 -0600
Message-ID: <CAErSpo4K1nfO18hw8H_Sw=8v4vNz6foJh1vAB3++VUOdB6i=4Q@mail.gmail.com>
Subject: Re: [PATCH] Avoid an infinite loop in pci_get_rom_size()
To: Federico <federicotg@gmail.com>
Cc: "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        =?UTF-8?Q?Michel_D=C3=A4nzer?= <michel@daenzer.net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[+cc Michel]

On Sat, Jan 17, 2015 at 7:50 AM, Federico <federicotg@gmail.com> wrote:
> There's a soft_lockup triggered on boot by the radeon driver when it calls
> pci_get_rom_size() on a certain AMD Radeon R7 250X PCIe discrete graphics
> card.
>
> Kernel does not boot as it loops forever unless nomodeset is used, but then
> radeon driver is not usable as it requires KMS.
>
> If we have a PCIR structure with a zero size length, the loop iterating
> through those structure does not advance. It simply does "image += readw(pds
> + 16) * 512;", but if that field is zero we're back analyzing the same
> structure on the next loop.
>
> This is a panic stack trace generated using softlockup_panic=1
> https://launchpadlibrarian.net/194940395/20150114_205715.png
>
> There are other panic screen shots and log files in this bug report
> https://bugs.launchpad.net/ubuntu/+source/linux/+bug/1386973
>
> The issue was discussed here
> http://lists.freedesktop.org/archives/dri-devel/2015-January/thread.html#75204
>
> And the solution was provided here:
> http://lists.freedesktop.org/archives/dri-devel/2015-January/075488.html
>
> This patch simple breaks the loop if the PCIR structure has zero length.
>
> As you can read in the mailing list discussion, I reported the bug, provided
> the screen shots, found the problem description online and tested the patch.
> The actual patch was provided by Michel Dänzer from the dri-devel mailing
> list.

Thanks for the fix.  It needs to be posted with a Signed-off-by
attribution before I can apply it; see
https://www.kernel.org/doc/Documentation/SubmittingPatches for
details.  It sounds like this should come from Michel.

Bjorn

> diff --git a/drivers/pci/rom.c b/drivers/pci/rom.c
> index f955edb..2fb5013 100644
> --- a/drivers/pci/rom.c
> +++ b/drivers/pci/rom.c
> @@ -75,6 +75,7 @@ size_t pci_get_rom_size(struct pci_dev *pdev, void __iomem
> *rom, size_t size)
>      image = rom;
>      do {
>          void __iomem *pds;
> +        u16 length;
>          /* Standard PCI ROMs start out with these bytes 55 AA */
>          if (readb(image) != 0x55) {
>              dev_err(&pdev->dev, "Invalid ROM contents\n");
> @@ -93,8 +94,10 @@ size_t pci_get_rom_size(struct pci_dev *pdev, void
> __iomem *rom, size_t size)
>          if (readb(pds + 3) != 'R')
>              break;
>          last_image = readb(pds + 21) & 0x80;
> -        /* this length is reliable */
> -        image += readw(pds + 16) * 512;
> +        length = readw(pds + 16);
> +        if (!length)
> +            break;
> +        image += length * 512;
>      } while (!last_image);
>
>      /* never return a size larger than the PCI resource window */
