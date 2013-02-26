Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759401Ab3BZAJI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Feb 2013 19:09:08 -0500
Received: from mail-oa0-f46.google.com ([209.85.219.46]:34194 "EHLO
	mail-oa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758168Ab3BZAJF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Feb 2013 19:09:05 -0500
MIME-Version: 1.0
In-Reply-To: <1361191939-21260-3-git-send-email-Varun.Sethi@freescale.com>
References: <1361191939-21260-1-git-send-email-Varun.Sethi@freescale.com>
	<1361191939-21260-3-git-send-email-Varun.Sethi@freescale.com>
Date: Mon, 25 Feb 2013 18:09:04 -0600
Message-ID: <CALRxmdDc9TuxH7HgAF3_iLgatoaOUML6fUt8SU+sxHyz6ZVjfw@mail.gmail.com>
Subject: Re: [PATCH 2/6] powerpc/fsl_pci: Store the platform device
 information corresponding to the pci controller.
From: Stuart Yoder <b08248@gmail.com>
To: Varun Sethi <Varun.Sethi@freescale.com>
Cc: iommu@lists.linux-foundation.org, linuxppc-dev@lists.ozlabs.org,
        linux-kernel@vger.kernel.org, Scott Wood <scottwood@freescale.com>,
        Joerg Roedel <joro@8bytes.org>,
        Stuart Yoder <stuart.yoder@freescale.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch was submitted separately to linuxppc-dev (and was already
applied).  You don't need it in this patch set, right?

Stuart

On Mon, Feb 18, 2013 at 6:52 AM, Varun Sethi <Varun.Sethi@freescale.com> wrote:
> The pci controller structure has a provision to store the device strcuture
> pointer of the corresponding platform device. Currently this information is
> not stored during fsl pci controller initialization. This information is
> required while dealing with iommu groups for pci devices connected to the fsl
> pci controller. For the case where the pci devices can't be paritioned, they
> would fall under the same device group as the pci controller.
>
> This patch stores the platform device information in the pci controller
> structure during initialization.
>
> Signed-off-by: Varun Sethi <Varun.Sethi@freescale.com>
> ---
>  arch/powerpc/sysdev/fsl_pci.c |    9 +++++++--
>  arch/powerpc/sysdev/fsl_pci.h |    2 +-
>  2 files changed, 8 insertions(+), 3 deletions(-)
>
> diff --git a/arch/powerpc/sysdev/fsl_pci.c b/arch/powerpc/sysdev/fsl_pci.c
> index 92a5915..b393ae7 100644
> --- a/arch/powerpc/sysdev/fsl_pci.c
> +++ b/arch/powerpc/sysdev/fsl_pci.c
> @@ -421,13 +421,16 @@ void fsl_pcibios_fixup_bus(struct pci_bus *bus)
>         }
>  }
>
> -int __init fsl_add_bridge(struct device_node *dev, int is_primary)
> +int __init fsl_add_bridge(struct platform_device *pdev, int is_primary)
>  {
>         int len;
>         struct pci_controller *hose;
>         struct resource rsrc;
>         const int *bus_range;
>         u8 hdr_type, progif;
> +       struct device_node *dev;
> +
> +       dev = pdev->dev.of_node;
>
>         if (!of_device_is_available(dev)) {
>                 pr_warning("%s: disabled\n", dev->full_name);
> @@ -453,6 +456,8 @@ int __init fsl_add_bridge(struct device_node *dev, int is_primary)
>         if (!hose)
>                 return -ENOMEM;
>
> +       /* set platform device as the parent */
> +       hose->parent = &pdev->dev;
>         hose->first_busno = bus_range ? bus_range[0] : 0x0;
>         hose->last_busno = bus_range ? bus_range[1] : 0xff;
>
> @@ -880,7 +885,7 @@ static int fsl_pci_probe(struct platform_device *pdev)
>  #endif
>
>         node = pdev->dev.of_node;
> -       ret = fsl_add_bridge(node, fsl_pci_primary == node);
> +       ret = fsl_add_bridge(pdev, fsl_pci_primary == node);
>
>  #ifdef CONFIG_SWIOTLB
>         if (ret == 0) {
> diff --git a/arch/powerpc/sysdev/fsl_pci.h b/arch/powerpc/sysdev/fsl_pci.h
> index d078537..c495c00 100644
> --- a/arch/powerpc/sysdev/fsl_pci.h
> +++ b/arch/powerpc/sysdev/fsl_pci.h
> @@ -91,7 +91,7 @@ struct ccsr_pci {
>         __be32  pex_err_cap_r3;         /* 0x.e34 - PCIE error capture register 0 */
>  };
>
> -extern int fsl_add_bridge(struct device_node *dev, int is_primary);
> +extern int fsl_add_bridge(struct platform_device *pdev, int is_primary);
>  extern void fsl_pcibios_fixup_bus(struct pci_bus *bus);
>  extern int mpc83xx_add_bridge(struct device_node *dev);
>  u64 fsl_pci_immrbar_base(struct pci_controller *hose);
> --
> 1.7.4.1
>
>
> _______________________________________________
> iommu mailing list
> iommu@lists.linux-foundation.org
> https://lists.linuxfoundation.org/mailman/listinfo/iommu
