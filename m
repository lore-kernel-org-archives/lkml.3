Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752560AbaEZOqJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 May 2014 10:46:09 -0400
Received: from mail-ie0-f169.google.com ([209.85.223.169]:44885 "EHLO
	mail-ie0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751588AbaEZOqG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 May 2014 10:46:06 -0400
MIME-Version: 1.0
In-Reply-To: <20140508204907.17877.4848.stgit@bhelgaas-glaptop.roam.corp.google.com>
References: <20140508204257.17877.4639.stgit@bhelgaas-glaptop.roam.corp.google.com>
	<20140508204907.17877.4848.stgit@bhelgaas-glaptop.roam.corp.google.com>
Date: Mon, 26 May 2014 16:46:06 +0200
X-Google-Sender-Auth: SnW9mdpZcLfDBbXeC9JB_59_4gs
Message-ID: <CAMuHMdWp-dUFwSgw30SYqXxAtAsrXDgaxcgfBZwV=1pEVN3B=A@mail.gmail.com>
Subject: Re: [PATCH v3 3/4] sh/PCI: Pass GAPSPCI_DMA_BASE CPU & bus address to dma_declare_coherent_memory()
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Bjorn Helgaas <bhelgaas@google.com>
Cc: Arnd Bergmann <arnd@arndb.de>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        Linux-sh list <linux-sh@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Joerg Roedel <joro@8bytes.org>, Randy Dunlap <rdunlap@infradead.org>,
        Liviu Dudau <Liviu.Dudau@arm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        James Bottomley <jbottomley@parallels.com>,
        Magnus Damm <damm@opensource.se>,
        linux-pci <linux-pci@vger.kernel.org>,
        David Woodhouse <dwmw2@infradead.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 8, 2014 at 10:49 PM, Bjorn Helgaas <bhelgaas@google.com> wrote:
> --- a/arch/sh/drivers/pci/fixups-dreamcast.c
> +++ b/arch/sh/drivers/pci/fixups-dreamcast.c
> @@ -31,6 +31,8 @@
>  static void gapspci_fixup_resources(struct pci_dev *dev)
>  {
>         struct pci_channel *p = dev->sysdata;
> +       struct resource res;
> +       struct pci_bus_region region;
>
>         printk(KERN_NOTICE "PCI: Fixing up device %s\n", pci_name(dev));
>
> @@ -50,11 +52,21 @@ static void gapspci_fixup_resources(struct pci_dev *dev)
>
>                 /*
>                  * Redirect dma memory allocations to special memory window.
> +                *
> +                * If this GAPSPCI region were mapped by a BAR, the CPU
> +                * phys_addr_t would be pci_resource_start(), and the bus
> +                * address would be pci_bus_address(pci_resource_start()).
> +                * But apparently there's no BAR mapping it, so we just
> +                * "know" its CPU address is GAPSPCI_DMA_BASE.
>                  */
> +               res.start = GAPSPCI_DMA_BASE;
> +               res.end = GAPSPCI_DMA_BASE + GAPSPCI_DMA_SIZE - 1;
> +               res.flags = IORESOURCE_MEM;
> +               pcibios_resource_to_bus(dev, &region, &resource);

In response to http://kisskb.ellerman.id.au/kisskb/buildresult/11212250/

| /scratch/kisskb/src/arch/sh/drivers/pci/fixups-dreamcast.c: In
function 'gapspci_fixup_resources':
| /scratch/kisskb/src/arch/sh/drivers/pci/fixups-dreamcast.c:65:42:
error: 'resource' undeclared (first use in this function)
| /scratch/kisskb/src/arch/sh/drivers/pci/fixups-dreamcast.c:65:42:
note: each undeclared identifier is reported only once for each
function it appears in

"resource" seem to have been replaced by "res", but this warning still happens:

| /scratch/kisskb/src/arch/sh/drivers/pci/fixups-dreamcast.c:65:3:
warning: passing argument 1 of 'pcibios_resource_to_bus' from
incompatible pointer type [enabled by default]
| /scratch/kisskb/src/include/linux/pci.h:737:6: note: expected
'struct pci_bus *' but argument is of type 'struct pci_dev *'

>                 BUG_ON(!dma_declare_coherent_memory(&dev->dev,
> -                                               GAPSPCI_DMA_BASE,
> -                                               GAPSPCI_DMA_BASE,
> -                                               GAPSPCI_DMA_SIZE,
> +                                               res.start,
> +                                               region.start,
> +                                               resource_size(&res),
>                                                 DMA_MEMORY_MAP |
>                                                 DMA_MEMORY_EXCLUSIVE));
>                 break;

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
