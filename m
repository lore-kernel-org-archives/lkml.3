Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761247AbbA1CS5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2015 21:18:57 -0500
Received: from mail-we0-f174.google.com ([74.125.82.174]:61533 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760583AbbA1CSu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2015 21:18:50 -0500
MIME-Version: 1.0
In-Reply-To: <1422392405-32196-2-git-send-email-m-karicheri2@ti.com>
References: <1422392405-32196-1-git-send-email-m-karicheri2@ti.com> <1422392405-32196-2-git-send-email-m-karicheri2@ti.com>
From: Rob Herring <robherring2@gmail.com>
Date: Tue, 27 Jan 2015 20:18:28 -0600
Message-ID: <CAL_JsqLSxzWt6JiKbzpPPZEygU07AJ+oj24zcPmnhUXoLTnQjA@mail.gmail.com>
Subject: Re: [PATCH v5 1/8] of: iommu: add ptr to OF node arg to of_iommu_configure()
To: Murali Karicheri <m-karicheri2@ti.com>
Cc: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Linux IOMMU <iommu@lists.linux-foundation.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        Joerg Roedel <joro@8bytes.org>, Grant Likely <grant.likely@linaro.org>,
        Rob Herring <robh+dt@kernel.org>, Will Deacon <will.deacon@arm.com>,
        Russell King <linux@arm.linux.org.uk>, Arnd Bergmann <arnd@arndb.de>,
        Suravee Suthikulpanit <Suravee.Suthikulpanit@amd.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 27, 2015 at 2:59 PM, Murali Karicheri <m-karicheri2@ti.com> wrote:
> Function of_iommu_configure() is called from of_dma_configure() to
> setup iommu ops using DT property. This API is currently used for
> platform devices for which DMA configuration (including iommu ops)
> may come from device's parent. To extend this functionality for PCI
> devices, this API need to take a parent node ptr as an argument
> instead of assuming device's parent. This is needed since for PCI, the
> dma configuration may be defined in the DT node of the root bus bridge's
> parent device. Currently only dma-range is used for PCI and iommu is not
> supported. So return error if the device is PCI.
>
> Cc: Joerg Roedel <joro@8bytes.org>
> Cc: Grant Likely <grant.likely@linaro.org>
> Cc: Rob Herring <robh+dt@kernel.org>

Acked-by: Rob Herring <robh@kernel.org>

> Cc: Will Deacon <will.deacon@arm.com>
> Cc: Russell King <linux@arm.linux.org.uk>
> Cc: Arnd Bergmann <arnd@arndb.de>
> Cc: Suravee Suthikulpanit <Suravee.Suthikulpanit@amd.com>
>
> Acked-by: Bjorn Helgaas <bhelgaas@google.com>
> Signed-off-by: Murali Karicheri <m-karicheri2@ti.com>
> ---
>  drivers/iommu/of_iommu.c |   10 ++++++++--
>  drivers/of/platform.c    |    2 +-
>  include/linux/of_iommu.h |    6 ++++--
>  3 files changed, 13 insertions(+), 5 deletions(-)
>
> diff --git a/drivers/iommu/of_iommu.c b/drivers/iommu/of_iommu.c
> index af1dc6a..439235b 100644
> --- a/drivers/iommu/of_iommu.c
> +++ b/drivers/iommu/of_iommu.c
> @@ -133,19 +133,25 @@ struct iommu_ops *of_iommu_get_ops(struct device_node *np)
>         return ops;
>  }
>
> -struct iommu_ops *of_iommu_configure(struct device *dev)
> +struct iommu_ops *of_iommu_configure(struct device *dev,
> +                                    struct device_node *iommu_np)
>  {
>         struct of_phandle_args iommu_spec;
>         struct device_node *np;
>         struct iommu_ops *ops = NULL;
>         int idx = 0;
>
> +       if (dev_is_pci(dev)) {
> +               dev_err(dev, "iommu is currently not supported for PCI\n");
> +               return NULL;
> +       }
> +
>         /*
>          * We don't currently walk up the tree looking for a parent IOMMU.
>          * See the `Notes:' section of
>          * Documentation/devicetree/bindings/iommu/iommu.txt
>          */
> -       while (!of_parse_phandle_with_args(dev->of_node, "iommus",
> +       while (!of_parse_phandle_with_args(iommu_np, "iommus",
>                                            "#iommu-cells", idx,
>                                            &iommu_spec)) {
>                 np = iommu_spec.np;
> diff --git a/drivers/of/platform.c b/drivers/of/platform.c
> index b0d50d7..d3f3988 100644
> --- a/drivers/of/platform.c
> +++ b/drivers/of/platform.c
> @@ -196,7 +196,7 @@ static void of_dma_configure(struct device *dev)
>         dev_dbg(dev, "device is%sdma coherent\n",
>                 coherent ? " " : " not ");
>
> -       iommu = of_iommu_configure(dev);
> +       iommu = of_iommu_configure(dev, dev->of_node);
>         dev_dbg(dev, "device is%sbehind an iommu\n",
>                 iommu ? " " : " not ");
>
> diff --git a/include/linux/of_iommu.h b/include/linux/of_iommu.h
> index 16c7554..a97e5bd 100644
> --- a/include/linux/of_iommu.h
> +++ b/include/linux/of_iommu.h
> @@ -12,7 +12,8 @@ extern int of_get_dma_window(struct device_node *dn, const char *prefix,
>                              size_t *size);
>
>  extern void of_iommu_init(void);
> -extern struct iommu_ops *of_iommu_configure(struct device *dev);
> +extern struct iommu_ops *of_iommu_configure(struct device *dev,
> +                                       struct device_node *iommu_np);
>
>  #else
>
> @@ -24,7 +25,8 @@ static inline int of_get_dma_window(struct device_node *dn, const char *prefix,
>  }
>
>  static inline void of_iommu_init(void) { }
> -static inline struct iommu_ops *of_iommu_configure(struct device *dev)
> +static inline struct iommu_ops *of_iommu_configure(struct device *dev,
> +                                        struct device_node *iommu_np)
>  {
>         return NULL;
>  }
> --
> 1.7.9.5
>
