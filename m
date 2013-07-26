Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759010Ab3GZRWQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Jul 2013 13:22:16 -0400
Received: from mail-ob0-f171.google.com ([209.85.214.171]:58996 "EHLO
	mail-ob0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756816Ab3GZRWO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Jul 2013 13:22:14 -0400
MIME-Version: 1.0
In-Reply-To: <003f01ce89f3$56ce9340$046bb9c0$@samsung.com>
References: <003f01ce89f3$56ce9340$046bb9c0$@samsung.com>
Date: Fri, 26 Jul 2013 10:22:13 -0700
X-Google-Sender-Auth: ct3U01x-o-lj9-XqdNWnR18OdB4
Message-ID: <CANEJEGvcbUXMcb+4Qvu99ULJJEZ8GoHdkH4_nnayt1YzFEF-Jg@mail.gmail.com>
Subject: Re: [PATCH v8 09/12] iommu/exynos: remove custom fault handler
From: Grant Grundler <grundler@chromium.org>
To: Cho KyongHo <pullip.cho@samsung.com>
Cc: Linux ARM Kernel <linux-arm-kernel@lists.infradead.org>,
        Linux IOMMU <iommu@lists.linux-foundation.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Linux Samsung SOC <linux-samsung-soc@vger.kernel.org>,
        Hyunwoong Kim <khw0178.kim@samsung.com>,
        Joerg Roedel <joro@8bytes.org>, Kukjin Kim <kgene.kim@samsung.com>,
        Prathyush <prathyush.k@samsung.com>,
        Rahul Sharma <rahul.sharma@samsung.com>,
        Subash Patel <supash.ramaswamy@linaro.org>,
        Keyyoung Park <keyyoung.park@samsung.com>,
        Grant Grundler <grundler@chromium.org>,
        Antonios Motakis <a.motakis@virtualopensystems.com>,
        kvmarm@lists.cs.columbia.edu, Sachin Kamat <sachin.kamat@linaro.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 26, 2013 at 4:29 AM, Cho KyongHo <pullip.cho@samsung.com> wrote:
> This commit removes custom fault handler. The device drivers that
> need to register fault handler can register
> with iommu_set_fault_handler().
>
> Signed-off-by: Cho KyongHo <pullip.cho@samsung.com>


Reviewed-by: Grant Grundler <grundler@chromium.org>

cheers
grant

> ---
>  drivers/iommu/exynos-iommu.c |   71 ++++++++++--------------------------------
>  1 files changed, 17 insertions(+), 54 deletions(-)
>
> diff --git a/drivers/iommu/exynos-iommu.c b/drivers/iommu/exynos-iommu.c
> index 87f6bb7..f9853fe 100644
> --- a/drivers/iommu/exynos-iommu.c
> +++ b/drivers/iommu/exynos-iommu.c
> @@ -131,16 +131,6 @@ enum exynos_sysmmu_inttype {
>         SYSMMU_FAULTS_NUM
>  };
>
> -/*
> - * @itype: type of fault.
> - * @pgtable_base: the physical address of page table base. This is 0 if @itype
> - *                is SYSMMU_BUSERROR.
> - * @fault_addr: the device (virtual) address that the System MMU tried to
> - *             translated. This is 0 if @itype is SYSMMU_BUSERROR.
> - */
> -typedef int (*sysmmu_fault_handler_t)(enum exynos_sysmmu_inttype itype,
> -                       unsigned long pgtable_base, unsigned long fault_addr);
> -
>  static unsigned short fault_reg_offset[SYSMMU_FAULTS_NUM] = {
>         REG_PAGE_FAULT_ADDR,
>         REG_AR_FAULT_ADDR,
> @@ -181,7 +171,6 @@ struct sysmmu_drvdata {
>         int activations;
>         rwlock_t lock;
>         struct iommu_domain *domain;
> -       sysmmu_fault_handler_t fault_handler;
>         unsigned long pgtable;
>         void __iomem *sfrbases[0];
>  };
> @@ -313,34 +302,17 @@ finish:
>         read_unlock_irqrestore(&data->lock, flags);
>  }
>
> -static void __set_fault_handler(struct sysmmu_drvdata *data,
> -                                       sysmmu_fault_handler_t handler)
> -{
> -       unsigned long flags;
> -
> -       write_lock_irqsave(&data->lock, flags);
> -       data->fault_handler = handler;
> -       write_unlock_irqrestore(&data->lock, flags);
> -}
> -
> -void exynos_sysmmu_set_fault_handler(struct device *dev,
> -                                       sysmmu_fault_handler_t handler)
> -{
> -       struct sysmmu_drvdata *data = dev_get_drvdata(dev->archdata.iommu);
> -
> -       __set_fault_handler(data, handler);
> -}
> -
> -static int default_fault_handler(enum exynos_sysmmu_inttype itype,
> -                    unsigned long pgtable_base, unsigned long fault_addr)
> +static void show_fault_information(const char *name,
> +               enum exynos_sysmmu_inttype itype,
> +               unsigned long pgtable_base, unsigned long fault_addr)
>  {
>         unsigned long *ent;
>
>         if ((itype >= SYSMMU_FAULTS_NUM) || (itype < SYSMMU_PAGEFAULT))
>                 itype = SYSMMU_FAULT_UNKNOWN;
>
> -       pr_err("%s occurred at 0x%lx(Page table base: 0x%lx)\n",
> -                       sysmmu_fault_name[itype], fault_addr, pgtable_base);
> +       pr_err("%s occurred at 0x%lx by %s(Page table base: 0x%lx)\n",
> +               sysmmu_fault_name[itype], fault_addr, name, pgtable_base);
>
>         ent = section_entry(__va(pgtable_base), fault_addr);
>         pr_err("\tLv1 entry: 0x%lx\n", *ent);
> @@ -353,16 +325,12 @@ static int default_fault_handler(enum exynos_sysmmu_inttype itype,
>         pr_err("Generating Kernel OOPS... because it is unrecoverable.\n");
>
>         BUG();
> -
> -       return 0;
>  }
>
>  static irqreturn_t exynos_sysmmu_irq(int irq, void *dev_id)
>  {
>         /* SYSMMU is in blocked when interrupt occurred. */
>         struct sysmmu_drvdata *data = dev_id;
> -       struct resource *irqres;
> -       struct platform_device *pdev;
>         enum exynos_sysmmu_inttype itype;
>         unsigned long addr = -1;
>
> @@ -372,14 +340,15 @@ static irqreturn_t exynos_sysmmu_irq(int irq, void *dev_id)
>
>         WARN_ON(!is_sysmmu_active(data));
>
> -       pdev = to_platform_device(data->sysmmu);
> -       for (i = 0; i < (pdev->num_resources / 2); i++) {
> -               irqres = platform_get_resource(pdev, IORESOURCE_IRQ, i);
> +       for (i = 0; i < data->nsfrs; i++) {
> +               struct resource *irqres;
> +               irqres = platform_get_resource(to_platform_device(data->sysmmu),
> +                                               IORESOURCE_IRQ, i);
>                 if (irqres && ((int)irqres->start == irq))
>                         break;
>         }
>
> -       if (i == pdev->num_resources) {
> +       if (i == data->nsfrs) {
>                 itype = SYSMMU_FAULT_UNKNOWN;
>         } else {
>                 itype = (enum exynos_sysmmu_inttype)
> @@ -395,19 +364,15 @@ static irqreturn_t exynos_sysmmu_irq(int irq, void *dev_id)
>                 ret = report_iommu_fault(data->domain, data->dev,
>                                 addr, itype);
>
> -       if ((ret == -ENOSYS) && data->fault_handler) {
> -               unsigned long base = data->pgtable;
> -               if (itype != SYSMMU_FAULT_UNKNOWN)
> -                       base = __raw_readl(
> -                                       data->sfrbases[i] + REG_PT_BASE_ADDR);
> -               ret = data->fault_handler(itype, base, addr);
> -       }
> -
>         if (!ret && (itype != SYSMMU_FAULT_UNKNOWN))
>                 __raw_writel(1 << itype, data->sfrbases[i] + REG_INT_CLEAR);
> -       else
> -               dev_dbg(data->sysmmu, "%s is not handled.\n",
> -                               sysmmu_fault_name[itype]);
> +       else {
> +               unsigned long ba = data->pgtable;
> +               if (itype != SYSMMU_FAULT_UNKNOWN)
> +                       ba = __raw_readl(data->sfrbases[i] + REG_PT_BASE_ADDR);
> +               show_fault_information(dev_name(data->sysmmu),
> +                                       itype, ba, addr);
> +       }
>
>         if (itype != SYSMMU_FAULT_UNKNOWN)
>                 sysmmu_unblock(data->sfrbases[i]);
> @@ -644,8 +609,6 @@ static int __init exynos_sysmmu_probe(struct platform_device *pdev)
>
>         pm_runtime_enable(dev);
>
> -       __set_fault_handler(data, &default_fault_handler);
> -
>         data->sysmmu = dev;
>         data->clk = devm_clk_get(dev, "sysmmu");
>         if (IS_ERR(data->clk)) {
> --
> 1.7.2.5
>
>
