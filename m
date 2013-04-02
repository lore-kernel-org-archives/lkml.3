Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932708Ab3DBPsX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Apr 2013 11:48:23 -0400
Received: from erley.org ([97.107.129.9]:34824 "EHLO remote.erley.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760348Ab3DBPsW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Apr 2013 11:48:22 -0400
Message-ID: <515AFDAF.2020604@erley.org>
Date: Tue, 02 Apr 2013 11:47:59 -0400
From: Pat Erley <pat-lkml@erley.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130401 Thunderbird/17.0.4
MIME-Version: 1.0
To: Andrew Cooks <acooks@gmail.com>
CC: "open list:INTEL IOMMU, (VT-d)" <iommu@lists.linux-foundation.org>,
        "bhelgaas@google.com" <bhelgaas@google.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Gaudenz Steinlin <gaudenz@soziologie.ch>,
        "David Woodhouse (supporter:INTEL IOMMU (VT-d))" 
	<dwmw2@infradead.org>,
        "list@remote.erley.org:PCI SUBSYSTEM" <linux-pci@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        Justin Piszcz <jpiszcz@lucidpixels.com>
Subject: Re: [PATCH v4] Quirk for buggy dma source tags with Intel IOMMU.
References: <1362710133-25168-1-git-send-email-acooks@gmail.com> <515A8A95.1080806@erley.org> <CAJtEV7aDaMkBmLevccGoRvm1YPEQPAwN1ZZnKHNN_FO2ex8F-Q@mail.gmail.com>
In-Reply-To: <CAJtEV7aDaMkBmLevccGoRvm1YPEQPAwN1ZZnKHNN_FO2ex8F-Q@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/02/2013 10:50 AM, Andrew Cooks wrote:
> On 2 Apr 2013 15:37, "Pat Erley" <pat-lkml@erley.org
> <mailto:pat-lkml@erley.org>> wrote:
>  >
>  > On 03/07/2013 09:35 PM, Andrew Cooks wrote:
>  >>
>  >> --- a/drivers/pci/quirks.c
>  >> +++ b/drivers/pci/quirks.c
>  >>
>  >> +/* Table of multiple (ghost) source functions. This is similar to the
>  >> + * translated sources above, but with the following differences:
>  >> + * 1. the device may use multiple functions as DMA sources,
>  >> + * 2. these functions cannot be assumed to be actual devices,
> they're simply
>  >> + * incorrect DMA tags.
>  >> + * 3. the specific ghost function for a request can not always be
> predicted.
>  >> + * For example, the actual device could be xx:yy.1 and it could use
>  >> + * both 0 and 1 for different requests, with no obvious way to tell
> when
>  >> + * DMA will be tagged as comming from xx.yy.0 and and when it will
> be tagged
>  >> + * as comming from xx.yy.1.
>  >> + * The bitmap contains all of the functions used in DMA tags,
> including the
>  >> + * actual device.
>  >> + * See https://bugzilla.redhat.com/show_bug.cgi?id=757166,
>  >> + * https://bugzilla.kernel.org/show_bug.cgi?id=42679
>  >> + * https://bugs.launchpad.net/ubuntu/+source/linux/+bug/1089768
>  >> + */
>  >> +static const struct pci_dev_dma_multi_func_sources {
>  >> +       u16 vendor;
>  >> +       u16 device;
>  >> +       u8 func_map;    /* bit map. lsb is fn 0. */
>  >> +} pci_dev_dma_multi_func_sources[] = {
>  >> +       { PCI_VENDOR_ID_MARVELL_2, 0x9123, (1<<0)|(1<<1)},
>  >> +       { PCI_VENDOR_ID_MARVELL_2, 0x9125, (1<<0)|(1<<1)},
>  >> +       { PCI_VENDOR_ID_MARVELL_2, 0x9128, (1<<0)|(1<<1)},
>  >> +       { PCI_VENDOR_ID_MARVELL_2, 0x9130, (1<<0)|(1<<1)},
>  >> +       { PCI_VENDOR_ID_MARVELL_2, 0x9143, (1<<0)|(1<<1)},
>  >> +       { PCI_VENDOR_ID_MARVELL_2, 0x9172, (1<<0)|(1<<1)},
>  >> +       { 0 }
>  >> +};
>  >
>  >
>  > Adding another buggy device.  I have a Ricoh multifunction device:
>  >
>  > 17:00.0 SD Host controller: Ricoh Co Ltd MMC/SD Host Controller (rev 01)
>  > 17:00.3 FireWire (IEEE 1394): Ricoh Co Ltd R5C832 PCIe IEEE 1394
>  >         Controller (rev 01)
>  >
>  > 17:00.0 0805: 1180:e822 (rev 01)
>  > 17:00.3 0c00: 1180:e832 (rev 01)
>  >
>
> The Ricoh device issue has been known for some time and a quirk has been
> available since commit 12ea6cad1c7d046 in June 2012.  It's slightly
> different than the problem this patch tries to work around [1].

Hmm, I've had this problem with many recent (vanilla) kernels, up to and 
including 3.9-rc5

>  > that adding entries for also fixed booting.  I don't have any SD
> cards or firewire devices handy to test that they work, but the system
> now boots, which was not the case without your patch and IOMMU/DMAR enabled.
>
> That is really strange. Could you tell us what kernel version you tested
> and provide dmesg output?

I'll capture a vanilla 3.8.5 boot without any patches and iommu=off, 
then try to find another machine to catch what I can of a netconsole 
boot with iommu=on.  What's the preferred way to send these?  pastebin 
links?

I'd been running the 'dirty' fix that's in the redhat bugzilla entry.  I 
checked my .config and have CONFIG_PCI_QUIRKS=y, and verified my devices 
are in the quirks table for the pci_func_0_dma_source fixup.

>  >  Here's a previous patch used for similar hardware that may also be
> fixed by this:
>  >
>  >
> http://lists.fedoraproject.org/pipermail/scm-commits/2010-October/510785.html
>  >
>  > and another thread/bug report this may solve:
>  >
>  > https://bugzilla.redhat.com/show_bug.cgi?id=605888
>
> I believe this is referenced in drivers/pci/quirks.c for versions newer
> than 3.5.
>
>
>  > Feel free to include me in any future iterations of this patch you'd
> like tested.
>  >
>  > Tested-By: Pat Erley <pat-lkml@erley.org <mailto:pat-lkml@erley.org>>
>  >
>
> Thanks for testing!
>
> [1] In the Ricoh case, multiple functions are used for real devices and
> the bug is that these devices all use function 0 during DMA. In this
> particular case, I'd expect the FireWire device 17:00.3 to issue DMA
> from the SD Host Controller address 17:00.0. The quirk is not too much
> of a terrible hack - it's a fairly simple translation.
>
> In the Marvell case, the real device uses DMA source tags that don't
> actually belong to any visible devices. The quirk to make this work is
> more invasive, not nearly as elegant and has not attracted much
> enthusiasm from subsystem maintainers, though I'm still hopeful that a
> quirk will be merged in some form or another.
>

Thanks for explaining the difference!

Pat
