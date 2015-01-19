Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752302AbbASStA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jan 2015 13:49:00 -0500
Received: from mail-qc0-f170.google.com ([209.85.216.170]:51854 "EHLO
	mail-qc0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752086AbbASSs6 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jan 2015 13:48:58 -0500
MIME-Version: 1.0
In-Reply-To: <1421657600-31561-1-git-send-email-michel@daenzer.net>
References: <CAFUqUc6JPgSK4tTP7KuJ8TmVLZR6Abaf9uHUTRZA+OJhv8DoBA@mail.gmail.com>
	<1421657600-31561-1-git-send-email-michel@daenzer.net>
Date: Mon, 19 Jan 2015 13:48:57 -0500
Message-ID: <CADnq5_O7ok+OtHxuPWgu2J-LxhqrJGJ0H9cinWLV8toGcCXdsQ@mail.gmail.com>
Subject: Re: [PATCH v2] pci: Fix infinite loop with ROM image of size 0
From: Alex Deucher <alexdeucher@gmail.com>
To: =?UTF-8?Q?Michel_D=C3=A4nzer?= <michel@daenzer.net>
Cc: Bjorn Helgaas <bhelgaas@google.com>, Linux PCI <linux-pci@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Maling list - DRI developers 
	<dri-devel@lists.freedesktop.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 19, 2015 at 3:53 AM, Michel Dänzer <michel@daenzer.net> wrote:
> From: Michel Dänzer <michel.daenzer@amd.com>
>
> If the image size would ever read as 0, pci_get_rom_size could keep
> processing the same image over and over again.
>
> Reported-by: Federico <federicotg@gmail.com>
> Cc: stable@vger.kernel.org
> Signed-off-by: Michel Dänzer <michel.daenzer@amd.com>

Reviewed-by: Alex Deucher <alexander.deucher@amd.com>

> ---
>
> v2:
> * Use unsigned instead of u16 for the local length variable (not sure if
>   the multiplication by 512 could overflow otherwise)
> * Integrate length condition into while statement
> * Add stable tag
>
>  drivers/pci/rom.c | 7 ++++---
>  1 file changed, 4 insertions(+), 3 deletions(-)
>
> diff --git a/drivers/pci/rom.c b/drivers/pci/rom.c
> index f955edb..eb0ad53 100644
> --- a/drivers/pci/rom.c
> +++ b/drivers/pci/rom.c
> @@ -71,6 +71,7 @@ size_t pci_get_rom_size(struct pci_dev *pdev, void __iomem *rom, size_t size)
>  {
>         void __iomem *image;
>         int last_image;
> +       unsigned length;
>
>         image = rom;
>         do {
> @@ -93,9 +94,9 @@ size_t pci_get_rom_size(struct pci_dev *pdev, void __iomem *rom, size_t size)
>                 if (readb(pds + 3) != 'R')
>                         break;
>                 last_image = readb(pds + 21) & 0x80;
> -               /* this length is reliable */
> -               image += readw(pds + 16) * 512;
> -       } while (!last_image);
> +               length = readw(pds + 16);
> +               image += length * 512;
> +       } while (length && !last_image);
>
>         /* never return a size larger than the PCI resource window */
>         /* there are known ROMs that get the size wrong */
> --
> 2.1.4
>
> _______________________________________________
> dri-devel mailing list
> dri-devel@lists.freedesktop.org
> http://lists.freedesktop.org/mailman/listinfo/dri-devel
