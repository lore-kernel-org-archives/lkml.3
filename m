Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754466AbaLKL6T (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Dec 2014 06:58:19 -0500
Received: from mail-qc0-f177.google.com ([209.85.216.177]:34031 "EHLO
	mail-qc0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752984AbaLKL6R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Dec 2014 06:58:17 -0500
MIME-Version: 1.0
In-Reply-To: <1418286387-9663-3-git-send-email-tfiga@chromium.org>
References: <1418286387-9663-1-git-send-email-tfiga@chromium.org>
	<1418286387-9663-3-git-send-email-tfiga@chromium.org>
Date: Thu, 11 Dec 2014 12:58:16 +0100
Message-ID: <CAPDyKFoBRxFh+BzHTakij6=NvLm0C-S8eX8+p2odpSwtdTrvoA@mail.gmail.com>
Subject: Re: [RFC PATCH 2/2] iommu: rockchip: Handle system-wide and runtime PM
From: Ulf Hansson <ulf.hansson@linaro.org>
To: Tomasz Figa <tfiga@chromium.org>
Cc: "open list:ARM/Rockchip SoC..." <linux-rockchip@lists.infradead.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        iommu@lists.linux-foundation.org,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Len Brown <len.brown@intel.com>, Pavel Machek <pavel@ucw.cz>,
        Heiko Stuebner <heiko@sntech.de>, Joerg Roedel <joro@8bytes.org>,
        Kevin Hilman <khilman@linaro.org>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Sylwester Nawrocki <s.nawrocki@samsung.com>,
        Daniel Kurtz <djkurtz@chromium.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11 December 2014 at 09:26, Tomasz Figa <tfiga@chromium.org> wrote:
> This patch modifies the rockchip-iommu driver to consider state of
> the power domain the IOMMU is located in. When the power domain
> is powered off, the IOMMU cannot be accessed and register programming
> must be deferred until the power domain becomes enabled.
>
> The solution implemented in this patch uses power domain notifications
> to perform necessary IOMMU initialization. Race with runtime PM core
> is avoided by protecting code accessing the hardware, including startup
> and shutdown functions, with a spinlock with a check for power state
> inside.
>
> Signed-off-by: Tomasz Figa <tfiga@chromium.org>
> ---
>  drivers/iommu/rockchip-iommu.c | 208 ++++++++++++++++++++++++++++++++++-------
>  1 file changed, 172 insertions(+), 36 deletions(-)
>
> diff --git a/drivers/iommu/rockchip-iommu.c b/drivers/iommu/rockchip-iommu.c
> index b2023af..9120655 100644
> --- a/drivers/iommu/rockchip-iommu.c
> +++ b/drivers/iommu/rockchip-iommu.c
> @@ -20,6 +20,8 @@
>  #include <linux/of.h>
>  #include <linux/of_platform.h>
>  #include <linux/platform_device.h>
> +#include <linux/pm_domain.h>
> +#include <linux/pm_runtime.h>
>  #include <linux/slab.h>
>  #include <linux/spinlock.h>
>
> @@ -88,6 +90,9 @@ struct rk_iommu {
>         int irq;
>         struct list_head node; /* entry in rk_iommu_domain.iommus */
>         struct iommu_domain *domain; /* domain to which iommu is attached */
> +       struct notifier_block genpd_nb;
> +       spinlock_t hw_lock; /* lock for register access */
> +       bool is_powered; /* power domain is on and register clock is enabled */
>  };
>
>  static inline void rk_table_flush(u32 *va, unsigned int count)
> @@ -283,6 +288,9 @@ static void rk_iommu_zap_lines(struct rk_iommu *iommu, dma_addr_t iova,
>                                size_t size)
>  {
>         dma_addr_t iova_end = iova + size;
> +
> +       assert_spin_locked(&iommu->hw_lock);
> +
>         /*
>          * TODO(djkurtz): Figure out when it is more efficient to shootdown the
>          * entire iotlb rather than iterate over individual iovas.
> @@ -293,11 +301,15 @@ static void rk_iommu_zap_lines(struct rk_iommu *iommu, dma_addr_t iova,
>
>  static bool rk_iommu_is_stall_active(struct rk_iommu *iommu)
>  {
> +       assert_spin_locked(&iommu->hw_lock);
> +
>         return rk_iommu_read(iommu, RK_MMU_STATUS) & RK_MMU_STATUS_STALL_ACTIVE;
>  }
>
>  static bool rk_iommu_is_paging_enabled(struct rk_iommu *iommu)
>  {
> +       assert_spin_locked(&iommu->hw_lock);
> +
>         return rk_iommu_read(iommu, RK_MMU_STATUS) &
>                              RK_MMU_STATUS_PAGING_ENABLED;
>  }
> @@ -306,6 +318,8 @@ static int rk_iommu_enable_stall(struct rk_iommu *iommu)
>  {
>         int ret;
>
> +       assert_spin_locked(&iommu->hw_lock);
> +
>         if (rk_iommu_is_stall_active(iommu))
>                 return 0;
>
> @@ -327,6 +341,8 @@ static int rk_iommu_disable_stall(struct rk_iommu *iommu)
>  {
>         int ret;
>
> +       assert_spin_locked(&iommu->hw_lock);
> +
>         if (!rk_iommu_is_stall_active(iommu))
>                 return 0;
>
> @@ -344,6 +360,8 @@ static int rk_iommu_enable_paging(struct rk_iommu *iommu)
>  {
>         int ret;
>
> +       assert_spin_locked(&iommu->hw_lock);
> +
>         if (rk_iommu_is_paging_enabled(iommu))
>                 return 0;
>
> @@ -361,6 +379,8 @@ static int rk_iommu_disable_paging(struct rk_iommu *iommu)
>  {
>         int ret;
>
> +       assert_spin_locked(&iommu->hw_lock);
> +
>         if (!rk_iommu_is_paging_enabled(iommu))
>                 return 0;
>
> @@ -379,6 +399,8 @@ static int rk_iommu_force_reset(struct rk_iommu *iommu)
>         int ret;
>         u32 dte_addr;
>
> +       assert_spin_locked(&iommu->hw_lock);
> +
>         /*
>          * Check if register DTE_ADDR is working by writing DTE_ADDR_DUMMY
>          * and verifying that upper 5 nybbles are read back.
> @@ -401,6 +423,50 @@ static int rk_iommu_force_reset(struct rk_iommu *iommu)
>         return ret;
>  }
>
> +static int rk_iommu_startup(struct rk_iommu *iommu)
> +{
> +       struct iommu_domain *domain = iommu->domain;
> +       struct rk_iommu_domain *rk_domain;
> +       phys_addr_t dte_addr;
> +       int ret;
> +
> +       assert_spin_locked(&iommu->hw_lock);
> +
> +       ret = rk_iommu_enable_stall(iommu);
> +       if (ret)
> +               return ret;
> +
> +       ret = rk_iommu_force_reset(iommu);
> +       if (ret)
> +               return ret;
> +
> +       rk_domain = domain->priv;
> +       dte_addr = virt_to_phys(rk_domain->dt);
> +       rk_iommu_write(iommu, RK_MMU_DTE_ADDR, dte_addr);
> +       rk_iommu_command(iommu, RK_MMU_CMD_ZAP_CACHE);
> +       rk_iommu_write(iommu, RK_MMU_INT_MASK, RK_MMU_IRQ_MASK);
> +
> +       ret = rk_iommu_enable_paging(iommu);
> +       if (ret)
> +               return ret;
> +
> +       rk_iommu_disable_stall(iommu);
> +
> +       return ret;
> +}
> +
> +static void rk_iommu_shutdown(struct rk_iommu *iommu)
> +{
> +       assert_spin_locked(&iommu->hw_lock);
> +
> +       /* Ignore error while disabling, just keep going */
> +       rk_iommu_enable_stall(iommu);
> +       rk_iommu_disable_paging(iommu);
> +       rk_iommu_write(iommu, RK_MMU_INT_MASK, 0);
> +       rk_iommu_write(iommu, RK_MMU_DTE_ADDR, 0);
> +       rk_iommu_disable_stall(iommu);
> +}
> +
>  static void log_iova(struct rk_iommu *iommu, dma_addr_t iova)
>  {
>         u32 dte_index, pte_index, page_offset;
> @@ -414,6 +480,8 @@ static void log_iova(struct rk_iommu *iommu, dma_addr_t iova)
>         phys_addr_t page_addr_phys = 0;
>         u32 page_flags = 0;
>
> +       assert_spin_locked(&iommu->hw_lock);
> +
>         dte_index = rk_iova_dte_index(iova);
>         pte_index = rk_iova_pte_index(iova);
>         page_offset = rk_iova_page_offset(iova);
> @@ -450,13 +518,22 @@ print_it:
>  static irqreturn_t rk_iommu_irq(int irq, void *dev_id)
>  {
>         struct rk_iommu *iommu = dev_id;
> +       irqreturn_t ret = IRQ_HANDLED;
> +       unsigned long flags;
>         u32 status;
>         u32 int_status;
>         dma_addr_t iova;
>
> +       spin_lock_irqsave(&iommu->hw_lock, flags);
> +
> +       if (!iommu->is_powered)
> +               goto done;
> +
>         int_status = rk_iommu_read(iommu, RK_MMU_INT_STATUS);
> -       if (int_status == 0)
> -               return IRQ_NONE;
> +       if (int_status == 0) {
> +               ret = IRQ_NONE;
> +               goto done;
> +       }
>
>         iova = rk_iommu_read(iommu, RK_MMU_PAGE_FAULT_ADDR);
>
> @@ -497,7 +574,10 @@ static irqreturn_t rk_iommu_irq(int irq, void *dev_id)
>
>         rk_iommu_write(iommu, RK_MMU_INT_CLEAR, int_status);
>
> -       return IRQ_HANDLED;
> +done:
> +       spin_unlock_irqrestore(&iommu->hw_lock, flags);
> +
> +       return ret;
>  }
>
>  static phys_addr_t rk_iommu_iova_to_phys(struct iommu_domain *domain,
> @@ -537,9 +617,15 @@ static void rk_iommu_zap_iova(struct rk_iommu_domain *rk_domain,
>         /* shootdown these iova from all iommus using this domain */
>         spin_lock_irqsave(&rk_domain->iommus_lock, flags);
>         list_for_each(pos, &rk_domain->iommus) {
> -               struct rk_iommu *iommu;
> -               iommu = list_entry(pos, struct rk_iommu, node);
> -               rk_iommu_zap_lines(iommu, iova, size);
> +               struct rk_iommu *iommu = list_entry(pos, struct rk_iommu, node);
> +
> +               spin_lock(&iommu->hw_lock);
> +
> +               /* Only zap TLBs of IOMMUs that are powered on. */
> +               if (iommu->is_powered)
> +                       rk_iommu_zap_lines(iommu, iova, size);
> +
> +               spin_unlock(&iommu->hw_lock);
>         }
>         spin_unlock_irqrestore(&rk_domain->iommus_lock, flags);
>  }
> @@ -729,7 +815,6 @@ static int rk_iommu_attach_device(struct iommu_domain *domain,
>         struct rk_iommu_domain *rk_domain = domain->priv;
>         unsigned long flags;
>         int ret;
> -       phys_addr_t dte_addr;
>
>         /*
>          * Allow 'virtual devices' (e.g., drm) to attach to domain.
> @@ -739,37 +824,22 @@ static int rk_iommu_attach_device(struct iommu_domain *domain,
>         if (!iommu)
>                 return 0;
>
> -       ret = rk_iommu_enable_stall(iommu);
> -       if (ret)
> -               return ret;
> -
> -       ret = rk_iommu_force_reset(iommu);
> -       if (ret)
> -               return ret;
> -
> -       iommu->domain = domain;
> -
>         ret = devm_request_irq(dev, iommu->irq, rk_iommu_irq,
>                                IRQF_SHARED, dev_name(dev), iommu);
>         if (ret)
>                 return ret;
>
> -       dte_addr = virt_to_phys(rk_domain->dt);
> -       rk_iommu_write(iommu, RK_MMU_DTE_ADDR, dte_addr);
> -       rk_iommu_command(iommu, RK_MMU_CMD_ZAP_CACHE);
> -       rk_iommu_write(iommu, RK_MMU_INT_MASK, RK_MMU_IRQ_MASK);
> -
> -       ret = rk_iommu_enable_paging(iommu);
> -       if (ret)
> -               return ret;
> -
>         spin_lock_irqsave(&rk_domain->iommus_lock, flags);
>         list_add_tail(&iommu->node, &rk_domain->iommus);
>         spin_unlock_irqrestore(&rk_domain->iommus_lock, flags);
>
> -       dev_info(dev, "Attached to iommu domain\n");
> +       spin_lock_irqsave(&iommu->hw_lock, flags);
> +       iommu->domain = domain;
> +       if (iommu->is_powered)
> +               rk_iommu_startup(iommu);
> +       spin_unlock_irqrestore(&iommu->hw_lock, flags);
>
> -       rk_iommu_disable_stall(iommu);
> +       dev_info(dev, "Attached to iommu domain\n");
>
>         return 0;
>  }
> @@ -790,17 +860,14 @@ static void rk_iommu_detach_device(struct iommu_domain *domain,
>         list_del_init(&iommu->node);
>         spin_unlock_irqrestore(&rk_domain->iommus_lock, flags);
>
> -       /* Ignore error while disabling, just keep going */
> -       rk_iommu_enable_stall(iommu);
> -       rk_iommu_disable_paging(iommu);
> -       rk_iommu_write(iommu, RK_MMU_INT_MASK, 0);
> -       rk_iommu_write(iommu, RK_MMU_DTE_ADDR, 0);
> -       rk_iommu_disable_stall(iommu);
> +       spin_lock_irqsave(&iommu->hw_lock, flags);
> +       if (iommu->is_powered)
> +               rk_iommu_shutdown(iommu);
> +       iommu->domain = NULL;
> +       spin_unlock_irqrestore(&iommu->hw_lock, flags);
>
>         devm_free_irq(dev, iommu->irq, iommu);
>
> -       iommu->domain = NULL;
> -
>         dev_info(dev, "Detached from iommu domain\n");
>  }
>
> @@ -964,6 +1031,57 @@ static const struct iommu_ops rk_iommu_ops = {
>         .pgsize_bitmap = RK_IOMMU_PGSIZE_BITMAP,
>  };
>
> +static int rk_iommu_power_on(struct rk_iommu *iommu)
> +{
> +       unsigned long flags;
> +       int ret;
> +
> +       spin_lock_irqsave(&iommu->hw_lock, flags);
> +
> +       iommu->is_powered = true;
> +       if (iommu->domain)
> +               ret = rk_iommu_startup(iommu);
> +
> +       spin_unlock_irqrestore(&iommu->hw_lock, flags);
> +
> +       return ret;
> +}
> +
> +static void rk_iommu_power_off(struct rk_iommu *iommu)
> +{
> +       unsigned long flags;
> +
> +       spin_lock_irqsave(&iommu->hw_lock, flags);
> +
> +       if (iommu->domain)
> +               rk_iommu_shutdown(iommu);
> +       iommu->is_powered = false;
> +
> +       spin_unlock_irqrestore(&iommu->hw_lock, flags);
> +}
> +
> +static int rk_iommu_genpd_notify(struct notifier_block *nb,
> +                                unsigned long action, void *data)
> +{
> +       struct rk_iommu *iommu = container_of(nb, struct rk_iommu, genpd_nb);
> +       int ret = 0;
> +
> +       switch (action) {
> +       case PM_GENPD_POST_POWER_ON:
> +               ret = rk_iommu_power_on(iommu);
> +               break;
> +
> +       case PM_GENPD_POWER_OFF_PREPARE:
> +               rk_iommu_power_off(iommu);
> +               break;
> +
> +       default:
> +               return NOTIFY_DONE;
> +       }
> +
> +       return notifier_from_errno(ret);
> +}
> +
>  static int rk_iommu_probe(struct platform_device *pdev)
>  {
>         struct device *dev = &pdev->dev;
> @@ -976,6 +1094,7 @@ static int rk_iommu_probe(struct platform_device *pdev)
>
>         platform_set_drvdata(pdev, iommu);
>         iommu->dev = dev;
> +       spin_lock_init(&iommu->hw_lock);
>
>         res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
>         iommu->base = devm_ioremap_resource(&pdev->dev, res);
> @@ -988,11 +1107,28 @@ static int rk_iommu_probe(struct platform_device *pdev)
>                 return -ENXIO;
>         }
>
> +       pm_runtime_no_callbacks(dev);
> +       pm_runtime_enable(dev);
> +
> +       /* Synchronize state of the domain with driver data. */
> +       pm_runtime_get_sync(dev);
> +       iommu->is_powered = true;

Doesn't the runtime PM status reflect the value of "is_powered", thus
why do you need to have a copy of it? Could it perpahps be that you
try to cope with the case when CONFIG_PM is unset?

> +
> +       iommu->genpd_nb.notifier_call = rk_iommu_genpd_notify;
> +       pm_genpd_register_notifier(dev, &iommu->genpd_nb);
> +
> +       pm_runtime_put(dev);
> +
>         return 0;
>  }
>
>  static int rk_iommu_remove(struct platform_device *pdev)
>  {
> +       struct rk_iommu *iommu = platform_get_drvdata(pdev);
> +
> +       pm_genpd_unregister_notifier(iommu->dev, &iommu->genpd_nb);
> +       pm_runtime_disable(&pdev->dev);
> +
>         return 0;
>  }
>
> --
> 2.2.0.rc0.207.ga3a616c
>

Kind regards
Uffe
