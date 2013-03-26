Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756617Ab3CZWxk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Mar 2013 18:53:40 -0400
Received: from mail-oa0-f43.google.com ([209.85.219.43]:59427 "EHLO
	mail-oa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756583Ab3CZWxa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Mar 2013 18:53:30 -0400
MIME-Version: 1.0
In-Reply-To: <1364333156-4530-1-git-send-email-matthew.garrett@nebula.com>
References: <CAPM=9tyYMSsK_2eCNRTx5EsgAQtnvmHxhgPHP3GHPxKUn+wo5w@mail.gmail.com>
 <1364333156-4530-1-git-send-email-matthew.garrett@nebula.com>
From: Bjorn Helgaas <bhelgaas@google.com>
Date: Tue, 26 Mar 2013 16:53:09 -0600
Message-ID: <CAErSpo7fy+MVxDoLe6w+4noH5X2xJw_Lfdg6fVvgcbhgvUyAaw@mail.gmail.com>
Subject: Re: [PATCH 1/3] pci: Add PCI ROM helper for platform-provided ROM images
To: Matthew Garrett <matthew.garrett@nebula.com>
Cc: Dave Airlie <airlied@gmail.com>, Alex Deucher <alexander.deucher@amd.com>,
        skeggsb@gmail.com,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Seth Forshee <seth.forshee@canonical.com>, grawity@gmail.com,
        Linus Torvalds <torvalds@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 26, 2013 at 3:25 PM, Matthew Garrett
<matthew.garrett@nebula.com> wrote:
> It turns out that some UEFI systems provide apparently an apparently valid
> PCI ROM BAR that turns out to contain garbage, so the attempt in f4eb5ff05
> to prefer the ROM from the BAR actually breaks a different set of machines.
> As Linus pointed out, the graphics drivers are probably in the best
> position to make this judgement, so this basically reverts f4eb5ff05 and
> f9a37be0f and adds a new helper function. Followup patches will add support
> to nouveau and radeon for probing this ROM source if they can't find a ROM
> from some other source.

I've been on vacation and didn't follow this closely, but it seems
like this fixes a regression and should be merged before v3.9, right?
Can you include a reference to a bugzilla or the mailing list
discussion in the changelog?  I can just fold it in if you want.

> Signed-off-by: Matthew Garrett <matthew.garrett@nebula.com>
> ---
>  drivers/pci/rom.c   | 67 +++++++++++++++++++++++++----------------------------
>  include/linux/pci.h |  1 +
>  2 files changed, 32 insertions(+), 36 deletions(-)
>
> diff --git a/drivers/pci/rom.c b/drivers/pci/rom.c
> index b41ac77..c5d0a08 100644
> --- a/drivers/pci/rom.c
> +++ b/drivers/pci/rom.c
> @@ -100,27 +100,6 @@ size_t pci_get_rom_size(struct pci_dev *pdev, void __iomem *rom, size_t size)
>         return min((size_t)(image - rom), size);
>  }
>
> -static loff_t pci_find_rom(struct pci_dev *pdev, size_t *size)
> -{
> -       struct resource *res = &pdev->resource[PCI_ROM_RESOURCE];
> -       loff_t start;
> -
> -       /* assign the ROM an address if it doesn't have one */
> -       if (res->parent == NULL && pci_assign_resource(pdev, PCI_ROM_RESOURCE))
> -               return 0;
> -       start = pci_resource_start(pdev, PCI_ROM_RESOURCE);
> -       *size = pci_resource_len(pdev, PCI_ROM_RESOURCE);
> -
> -       if (*size == 0)
> -               return 0;
> -
> -       /* Enable ROM space decodes */
> -       if (pci_enable_rom(pdev))
> -               return 0;
> -
> -       return start;
> -}
> -
>  /**
>   * pci_map_rom - map a PCI ROM to kernel space
>   * @pdev: pointer to pci device struct
> @@ -135,7 +114,7 @@ static loff_t pci_find_rom(struct pci_dev *pdev, size_t *size)
>  void __iomem *pci_map_rom(struct pci_dev *pdev, size_t *size)
>  {
>         struct resource *res = &pdev->resource[PCI_ROM_RESOURCE];
> -       loff_t start = 0;
> +       loff_t start;
>         void __iomem *rom;
>
>         /*
> @@ -154,21 +133,21 @@ void __iomem *pci_map_rom(struct pci_dev *pdev, size_t *size)
>                         return (void __iomem *)(unsigned long)
>                                 pci_resource_start(pdev, PCI_ROM_RESOURCE);
>                 } else {
> -                       start = pci_find_rom(pdev, size);
> -               }
> -       }
> +                       /* assign the ROM an address if it doesn't have one */
> +                       if (res->parent == NULL &&
> +                           pci_assign_resource(pdev,PCI_ROM_RESOURCE))
> +                               return NULL;
> +                       start = pci_resource_start(pdev, PCI_ROM_RESOURCE);
> +                       *size = pci_resource_len(pdev, PCI_ROM_RESOURCE);
> +                       if (*size == 0)
> +                               return NULL;
>
> -       /*
> -        * Some devices may provide ROMs via a source other than the BAR
> -        */
> -       if (!start && pdev->rom && pdev->romlen) {
> -               *size = pdev->romlen;
> -               return phys_to_virt(pdev->rom);
> +                       /* Enable ROM space decodes */
> +                       if (pci_enable_rom(pdev))
> +                               return NULL;
> +               }
>         }
>
> -       if (!start)
> -               return NULL;
> -
>         rom = ioremap(start, *size);
>         if (!rom) {
>                 /* restore enable if ioremap fails */
> @@ -202,8 +181,7 @@ void pci_unmap_rom(struct pci_dev *pdev, void __iomem *rom)
>         if (res->flags & (IORESOURCE_ROM_COPY | IORESOURCE_ROM_BIOS_COPY))
>                 return;
>
> -       if (!pdev->rom || !pdev->romlen)
> -               iounmap(rom);
> +       iounmap(rom);
>
>         /* Disable again before continuing, leave enabled if pci=rom */
>         if (!(res->flags & (IORESOURCE_ROM_ENABLE | IORESOURCE_ROM_SHADOW)))
> @@ -227,7 +205,24 @@ void pci_cleanup_rom(struct pci_dev *pdev)
>         }
>  }
>
> +/**
> + * pci_platform_rom - provides a pointer to any ROM image provided by the
> + * platform
> + * @pdev: pointer to pci device struct
> + * @size: pointer to receive size of pci window over ROM
> + */
> +void __iomem *pci_platform_rom(struct pci_dev *pdev, size_t *size)
> +{
> +       if (pdev->rom && pdev->romlen) {
> +               *size = pdev->romlen;
> +               return phys_to_virt((phys_addr_t)pdev->rom);
> +       }
> +
> +       return NULL;
> +}
> +
>  EXPORT_SYMBOL(pci_map_rom);
>  EXPORT_SYMBOL(pci_unmap_rom);
>  EXPORT_SYMBOL_GPL(pci_enable_rom);
>  EXPORT_SYMBOL_GPL(pci_disable_rom);
> +EXPORT_SYMBOL(pci_platform_rom);
> diff --git a/include/linux/pci.h b/include/linux/pci.h
> index 2461033a..710067f 100644
> --- a/include/linux/pci.h
> +++ b/include/linux/pci.h
> @@ -916,6 +916,7 @@ void pci_disable_rom(struct pci_dev *pdev);
>  void __iomem __must_check *pci_map_rom(struct pci_dev *pdev, size_t *size);
>  void pci_unmap_rom(struct pci_dev *pdev, void __iomem *rom);
>  size_t pci_get_rom_size(struct pci_dev *pdev, void __iomem *rom, size_t size);
> +void __iomem __must_check *pci_platform_rom(struct pci_dev *pdev, size_t *size);
>
>  /* Power management related routines */
>  int pci_save_state(struct pci_dev *dev);
> --
> 1.8.1.2
>
