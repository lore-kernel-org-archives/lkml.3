Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754730AbaCNM7L (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Mar 2014 08:59:11 -0400
Received: from mailout4.w1.samsung.com ([210.118.77.14]:35678 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754382AbaCNM7G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Mar 2014 08:59:06 -0400
X-AuditID: cbfec7f4-b7f796d000005a13-b6-5322fd167519
Message-id: <5322FD14.5090602@samsung.com>
Date: Fri, 14 Mar 2014 13:59:00 +0100
From: Tomasz Figa <t.figa@samsung.com>
Organization: Samsung R&D Institute Poland
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101
 Thunderbird/24.3.0
MIME-version: 1.0
To: Cho KyongHo <pullip.cho@samsung.com>,
        Linux ARM Kernel <linux-arm-kernel@lists.infradead.org>,
        Linux DeviceTree <devicetree@vger.kernel.org>,
        Linux IOMMU <iommu@lists.linux-foundation.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Linux Samsung SOC <linux-samsung-soc@vger.kernel.org>
Cc: Antonios Motakis <a.motakis@virtualopensystems.com>,
        Grant Grundler <grundler@chromium.org>, Joerg Roedel <joro@8bytes.org>,
        Kukjin Kim <kgene.kim@samsung.com>,
        Prathyush <prathyush.k@samsung.com>,
        Rahul Sharma <rahul.sharma@samsung.com>,
        Sachin Kamat <sachin.kamat@linaro.org>,
        Sylwester Nawrocki <s.nawrocki@samsung.com>,
        Varun Sethi <Varun.Sethi@freescale.com>
Subject: Re: [PATCH v11 17/27] iommu/exynos: remove calls to Runtime PM API
 functions
References: <20140314140843.ba055f28dd7ed59c46088029@samsung.com>
In-reply-to: <20140314140843.ba055f28dd7ed59c46088029@samsung.com>
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmpjkeLIzCtJLcpLzFFi42I5/e/4ZV2xv0rBBsvuKlrcuXuO1WL+ESDx
	6sgPJosF+60tOmdvYLfoXXCVzWLT42usFpd3zWGzmHF+H5PFhRUb2S3+9R5ktJiy6DCrxeE3
	7awWJ//0MlrMvLWGxYHf48nBeUwesxsusnj8O9zP5HHn2h42j81L6j0m31jO6NG3ZRWjx+dN
	ch5Xjp5hCuCM4rJJSc3JLEst0rdL4Mq482chU8GDBYwVVw+fZ2tgfF7fxcjJISFgInH930Ym
	CFtM4sK99WxdjFwcQgJLGSXWNGxlh3A+M0rM6V3C0sXIwcEroCUxodMapIFFQFVi87FlrCA2
	m4CaxOeGR2wgNj9QyZqm6ywgtqhAhMTciZvB4rwCghI/Jt9jAZkpIrCOSeLYkZ1gDrPAbyaJ
	Z+8eM4NUCQuES5y68RGsW0jAUWL95C1g53EKOEk0tG9kBLGZBawlVk7aBmXLS2xe85Z5AqPg
	LCRLZiEpm4WkbAEj8ypG0dTS5ILipPRcQ73ixNzi0rx0veT83E2MkLj7soNx8TGrQ4wCHIxK
	PLwn3ysGC7EmlhVX5h5ilOBgVhLhPflYKViINyWxsiq1KD++qDQntfgQIxMHp1QDo6/FHa3J
	QSfnznF6xzpJYU9ZxjzGzgcf172/1fTavKnc4Bj/PcesrlmHlAREl4qoPjzKH90d5mMe0SP3
	zXl1VMCJwhNBS9LLX8V9Nt6y/sKimuqQeo+yXavM/nw7WB7teGQdt/bdaeFVOd+dN/LyP+/M
	Vtjc+f3fUzWj9RsZKmo9Ki3u984wUGIpzkg01GIuKk4EAEC2j+SZAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi KyongHo,

On 14.03.2014 06:08, Cho KyongHo wrote:
> Runtime power management by exynos-iommu driver independently from
> master H/W's runtime pm is not useful for power saving since attaching
> master H/W in probing time turns on its local power endlessly.
> Thus this removes runtime pm API calls.
> Runtime PM support is added in the following commits to exynos-iommu
> driver.

The patch seems to be doing something completely different than the 
commit description suggests. Please rewrite the description to describe 
the patch correctly.

>
> Signed-off-by: Cho KyongHo <pullip.cho@samsung.com>
> ---
>   drivers/iommu/exynos-iommu.c |  369 +++++++++++++++++++++++++++---------------
>   1 file changed, 238 insertions(+), 131 deletions(-)
>
> diff --git a/drivers/iommu/exynos-iommu.c b/drivers/iommu/exynos-iommu.c
> index 3458349..6834556 100644
> --- a/drivers/iommu/exynos-iommu.c
> +++ b/drivers/iommu/exynos-iommu.c
> @@ -27,6 +27,8 @@
>   #include <linux/memblock.h>
>   #include <linux/export.h>
>   #include <linux/of.h>
> +#include <linux/of_platform.h>
> +#include <linux/notifier.h>
>
>   #include <asm/cacheflush.h>
>   #include <asm/pgtable.h>
> @@ -111,6 +113,8 @@
>   #define __master_clk_enable(data)	__clk_gate_ctrl(data, clk_master, en)
>   #define __master_clk_disable(data)	__clk_gate_ctrl(data, clk_master, dis)
>
> +#define has_sysmmu(dev)		(dev->archdata.iommu != NULL)
> +
>   static struct kmem_cache *lv2table_kmem_cache;
>
>   static unsigned long *section_entry(unsigned long *pgtable, unsigned long iova)
> @@ -159,6 +163,16 @@ static char *sysmmu_fault_name[SYSMMU_FAULTS_NUM] = {
>   	"UNKNOWN FAULT"
>   };
>
> +/* attached to dev.archdata.iommu of the master device */
> +struct exynos_iommu_owner {
> +	struct list_head client; /* entry of exynos_iommu_domain.clients */
> +	struct device *dev;
> +	struct device *sysmmu;
> +	struct iommu_domain *domain;
> +	void *vmm_data;         /* IO virtual memory manager's data */
> +	spinlock_t lock;        /* Lock to preserve consistency of System MMU */

Please don't use spaces for alignment.

> +};
> +
>   struct exynos_iommu_domain {
>   	struct list_head clients; /* list of sysmmu_drvdata.node */
>   	unsigned long *pgtable; /* lv1 page table, 16KB */
> @@ -168,9 +182,8 @@ struct exynos_iommu_domain {
>   };
>
>   struct sysmmu_drvdata {
> -	struct list_head node; /* entry of exynos_iommu_domain.clients */
>   	struct device *sysmmu;	/* System MMU's device descriptor */
> -	struct device *dev;	/* Owner of system MMU */
> +	struct device *master;	/* Owner of system MMU */
>   	void __iomem *sfrbase;
>   	struct clk *clk;
>   	struct clk *clk_master;
> @@ -239,7 +252,6 @@ static void __sysmmu_tlb_invalidate_entry(void __iomem *sfrbase,
>   static void __sysmmu_set_ptbase(void __iomem *sfrbase,
>   				       unsigned long pgd)
>   {
> -	__raw_writel(0x1, sfrbase + REG_MMU_CFG); /* 16KB LV1, LRU */
>   	__raw_writel(pgd, sfrbase + REG_PT_BASE_ADDR);
>
>   	__sysmmu_tlb_invalidate(sfrbase);
> @@ -299,7 +311,7 @@ static irqreturn_t exynos_sysmmu_irq(int irq, void *dev_id)
>   					itype, base, addr);
>   		if (data->domain)
>   			ret = report_iommu_fault(data->domain,
> -					data->dev, addr, itype);
> +					data->master, addr, itype);
>   	}
>
>   	/* fault is not recovered by fault handler */
> @@ -316,116 +328,148 @@ static irqreturn_t exynos_sysmmu_irq(int irq, void *dev_id)
>   	return IRQ_HANDLED;
>   }
>
> -static bool __exynos_sysmmu_disable(struct sysmmu_drvdata *data)
> +static void __sysmmu_disable_nocount(struct sysmmu_drvdata *data)

If you are changing the names anyway, it would be probably a good idea 
to reduce code obfuscation a bit and drop the underscores from 
beginnings of function names. Also I'd suggest keeping the "exynos_" prefix.

>   {
> -	unsigned long flags;
> -	bool disabled = false;
> -
> -	write_lock_irqsave(&data->lock, flags);
> -
> -	if (!set_sysmmu_inactive(data))
> -		goto finish;
> -
> -	__master_clk_enable(data);
> +	clk_enable(data->clk_master);
>
>   	__raw_writel(CTRL_DISABLE, data->sfrbase + REG_MMU_CTRL);
> +	__raw_writel(0, data->sfrbase + REG_MMU_CFG);
>
>   	__sysmmu_clk_disable(data);
>   	__master_clk_disable(data);
> +}
>
> -	disabled = true;
> -	data->pgtable = 0;
> -	data->domain = NULL;
> -finish:
> -	write_unlock_irqrestore(&data->lock, flags);
> +static bool __sysmmu_disable(struct sysmmu_drvdata *data)
> +{
> +	bool disabled;
> +	unsigned long flags;
> +
> +	write_lock_irqsave(&data->lock, flags);
> +
> +	disabled = set_sysmmu_inactive(data);
> +
> +	if (disabled) {
> +		data->pgtable = 0;
> +		data->domain = NULL;
> +
> +		__sysmmu_disable_nocount(data);
>
> -	if (disabled)
>   		dev_dbg(data->sysmmu, "Disabled\n");
> -	else
> -		dev_dbg(data->sysmmu, "%d times left to be disabled\n",
> +	} else  {
> +		dev_dbg(data->sysmmu, "%d times left to disable\n",
>   					data->activations);
> +	}
> +
> +	write_unlock_irqrestore(&data->lock, flags);
>
>   	return disabled;
>   }
>
> -/* __exynos_sysmmu_enable: Enables System MMU
> - *
> - * returns -error if an error occurred and System MMU is not enabled,
> - * 0 if the System MMU has been just enabled and 1 if System MMU was already
> - * enabled before.
> - */
> -static int __exynos_sysmmu_enable(struct sysmmu_drvdata *data,
> +static void __sysmmu_init_config(struct sysmmu_drvdata *data)
> +{
> +	unsigned long cfg = 0;
> +
> +	__raw_writel(cfg, data->sfrbase + REG_MMU_CFG);
> +}
> +
> +static void __sysmmu_enable_nocount(struct sysmmu_drvdata *data)
> +{
> +	__master_clk_enable(data);
> +	__sysmmu_clk_enable(data);
> +
> +	__raw_writel(CTRL_BLOCK, data->sfrbase + REG_MMU_CTRL);
> +
> +	__sysmmu_init_config(data);
> +
> +	__sysmmu_set_ptbase(data->sfrbase, data->pgtable);
> +
> +	__raw_writel(CTRL_ENABLE, data->sfrbase + REG_MMU_CTRL);
> +
> +	__master_clk_disable(data);
> +}
> +
> +static int __sysmmu_enable(struct sysmmu_drvdata *data,
>   			unsigned long pgtable, struct iommu_domain *domain)
>   {
>   	int ret = 0;
>   	unsigned long flags;
>
>   	write_lock_irqsave(&data->lock, flags);
> +	if (set_sysmmu_active(data)) {
> +		data->pgtable = pgtable;
> +		data->domain = domain;
>
> -	if (!set_sysmmu_active(data)) {
> -		if (WARN_ON(pgtable != data->pgtable)) {
> -			ret = -EBUSY;
> -			set_sysmmu_inactive(data);
> -		} else {
> -			ret = 1;
> -		}
> +		__sysmmu_enable_nocount(data);
>
> -		dev_dbg(data->sysmmu, "Already enabled\n");
> -		goto finish;
> +		dev_dbg(data->sysmmu, "Enabled\n");
> +	} else {
> +		ret = (pgtable == data->pgtable) ? 1 : -EBUSY;
> +
> +		dev_dbg(data->sysmmu, "already enabled\n");
>   	}
>
> -	data->pgtable = pgtable;
> +	if (WARN_ON(ret < 0))
> +		set_sysmmu_inactive(data); /* decrement count */
>
> -	__master_clk_enable(data);
> -	__sysmmu_clk_enable(data);
> +	write_unlock_irqrestore(&data->lock, flags);
>
> -	__sysmmu_set_ptbase(data->sfrbase, pgtable);
> +	return ret;
> +}
>
> -	__raw_writel(CTRL_ENABLE, data->sfrbase + REG_MMU_CTRL);
> +/* __exynos_sysmmu_enable: Enables System MMU
> + *
> + * returns -error if an error occurred and System MMU is not enabled,
> + * 0 if the System MMU has been just enabled and 1 if System MMU was already
> + * enabled before.
> + */
> +static int __exynos_sysmmu_enable(struct device *dev, unsigned long pgtable,
> +				  struct iommu_domain *domain)
> +{
> +	int ret = 0;
> +	unsigned long flags;
> +	struct exynos_iommu_owner *owner = dev->archdata.iommu;
> +	struct sysmmu_drvdata *data;
>
> -	__master_clk_disable(data);
> +	BUG_ON(!has_sysmmu(dev));
>
> -	data->domain = domain;
> +	spin_lock_irqsave(&owner->lock, flags);
>
> -	dev_dbg(data->sysmmu, "Enabled\n");
> -finish:
> -	write_unlock_irqrestore(&data->lock, flags);
> +	data = dev_get_drvdata(owner->sysmmu);
> +
> +	ret = __sysmmu_enable(data, pgtable, domain);
> +	if (ret >= 0)
> +		data->master = dev;
> +
> +	spin_unlock_irqrestore(&owner->lock, flags);
>
>   	return ret;
>   }
>
>   int exynos_sysmmu_enable(struct device *dev, unsigned long pgtable)
>   {
> -	struct sysmmu_drvdata *data = dev_get_drvdata(dev->archdata.iommu);
> -	int ret;
> -
>   	BUG_ON(!memblock_is_memory(pgtable));
>
> -	ret = pm_runtime_get_sync(data->sysmmu);
> -	if (ret < 0) {
> -		dev_dbg(data->sysmmu, "Failed to enable\n");
> -		return ret;
> -	}
> -
> -	ret = __exynos_sysmmu_enable(data, pgtable, NULL);
> -	if (WARN_ON(ret < 0)) {
> -		pm_runtime_put(data->sysmmu);
> -		dev_err(data->sysmmu, "Already enabled with page table %#lx\n",
> -			data->pgtable);
> -	} else {
> -		data->dev = dev;
> -	}
> -
> -	return ret;
> +	return __exynos_sysmmu_enable(dev, pgtable, NULL);
>   }
>
>   static bool exynos_sysmmu_disable(struct device *dev)
>   {
> -	struct sysmmu_drvdata *data = dev_get_drvdata(dev->archdata.iommu);
> -	bool disabled;
> +	unsigned long flags;
> +	bool disabled = true;
> +	struct exynos_iommu_owner *owner = dev->archdata.iommu;
> +	struct sysmmu_drvdata *data;
> +
> +	BUG_ON(!has_sysmmu(dev));
>
> -	disabled = __exynos_sysmmu_disable(data);
> -	pm_runtime_put(data->sysmmu);
> +	spin_lock_irqsave(&owner->lock, flags);
> +
> +	data = dev_get_drvdata(owner->sysmmu);
> +
> +	disabled = __sysmmu_disable(data);
> +	if (disabled)
> +		data->master = NULL;
> +
> +	spin_unlock_irqrestore(&owner->lock, flags);
>
>   	return disabled;
>   }
> @@ -433,11 +477,13 @@ static bool exynos_sysmmu_disable(struct device *dev)
>   static void sysmmu_tlb_invalidate_entry(struct device *dev, unsigned long iova,
>   					size_t size)
>   {
> +	struct exynos_iommu_owner *owner = dev->archdata.iommu;
>   	unsigned long flags;
> -	struct sysmmu_drvdata *data = dev_get_drvdata(dev->archdata.iommu);
> +	struct sysmmu_drvdata *data;
>
> -	read_lock_irqsave(&data->lock, flags);
> +	data = dev_get_drvdata(owner->sysmmu);
>
> +	read_lock_irqsave(&data->lock, flags);
>   	if (is_sysmmu_active(data)) {
>   		unsigned int maj;
>   		unsigned int num_inv = 1;
> @@ -465,19 +511,21 @@ static void sysmmu_tlb_invalidate_entry(struct device *dev, unsigned long iova,
>   		}
>   		__master_clk_disable(data);
>   	} else {
> -		dev_dbg(data->sysmmu, "Disabled. Skipping invalidating TLB.\n");
> +		dev_dbg(dev, "disabled. Skipping TLB invalidation @ %#lx\n",
> +			iova);
>   	}
> -
>   	read_unlock_irqrestore(&data->lock, flags);
>   }
>
>   void exynos_sysmmu_tlb_invalidate(struct device *dev)
>   {
> +	struct exynos_iommu_owner *owner = dev->archdata.iommu;
>   	unsigned long flags;
> -	struct sysmmu_drvdata *data = dev_get_drvdata(dev->archdata.iommu);
> +	struct sysmmu_drvdata *data;
>
> -	read_lock_irqsave(&data->lock, flags);
> +	data = dev_get_drvdata(owner->sysmmu);
>
> +	read_lock_irqsave(&data->lock, flags);
>   	if (is_sysmmu_active(data)) {
>   		__master_clk_enable(data);
>   		if (sysmmu_block(data->sfrbase)) {
> @@ -486,9 +534,8 @@ void exynos_sysmmu_tlb_invalidate(struct device *dev)
>   		}
>   		__master_clk_disable(data);
>   	} else {
> -		dev_dbg(data->sysmmu, "Disabled. Skipping invalidating TLB.\n");
> +		dev_dbg(dev, "disabled. Skipping TLB invalidation\n");
>   	}
> -
>   	read_unlock_irqrestore(&data->lock, flags);
>   }
>
> @@ -498,6 +545,7 @@ static int __init exynos_sysmmu_probe(struct platform_device *pdev)
>   	struct device *dev = &pdev->dev;
>   	struct sysmmu_drvdata *data;
>   	struct resource *res;
> +	struct device_node *node;
>
>   	data = devm_kzalloc(dev, sizeof(*data), GFP_KERNEL);
>   	if (!data)
> @@ -549,9 +597,32 @@ static int __init exynos_sysmmu_probe(struct platform_device *pdev)
>   		return ret;
>   	}
>
> +	/* Relation between master and System MMU is 1:1. */
> +	node = of_parse_phandle(dev->of_node, "mmu-masters", 0);
> +	if (node) {
> +		struct platform_device *master = of_find_device_by_node(node);
> +
> +		if (!master) {
> +			dev_err(dev, "%s: mmu-master '%s' not found\n",
> +				__func__, node->name);
> +			return -EINVAL;
> +		}
> +
> +		if (master->dev.archdata.iommu != NULL) {
> +			dev_err(dev, "%s: '%s' is master of other MMU\n",
> +				__func__, node->name);
> +			return -EINVAL;
> +		}
> +
> +		/*
> +		 * archdata.iommu will be initialized with exynos_iommu_client
> +		 * in sysmmu_hook_driver_register().
> +		 */
> +		master->dev.archdata.iommu = dev;
> +	}
> +
>   	data->sysmmu = dev;
>   	rwlock_init(&data->lock);
> -	INIT_LIST_HEAD(&data->node);
>
>   	platform_set_drvdata(pdev, data);
>
> @@ -629,7 +700,7 @@ err_pgtable:
>   static void exynos_iommu_domain_destroy(struct iommu_domain *domain)
>   {
>   	struct exynos_iommu_domain *priv = domain->priv;
> -	struct sysmmu_drvdata *data;
> +	struct exynos_iommu_owner *owner;
>   	unsigned long flags;
>   	int i;
>
> @@ -637,11 +708,14 @@ static void exynos_iommu_domain_destroy(struct iommu_domain *domain)
>
>   	spin_lock_irqsave(&priv->lock, flags);
>
> -	list_for_each_entry(data, &priv->clients, node) {
> -		while (!exynos_sysmmu_disable(data->dev))
> +	list_for_each_entry(owner, &priv->clients, client) {
> +		while (!exynos_sysmmu_disable(owner->dev))
>   			; /* until System MMU is actually disabled */

What about using list_for_each_entry_safe() and calling list_del_init() 
here directly?

>   	}
>
> +	while (!list_empty(&priv->clients))
> +		list_del_init(priv->clients.next);
> +
>   	spin_unlock_irqrestore(&priv->lock, flags);
>
>   	for (i = 0; i < NUM_LV1ENTRIES; i++)
> @@ -658,41 +732,28 @@ static void exynos_iommu_domain_destroy(struct iommu_domain *domain)
>   static int exynos_iommu_attach_device(struct iommu_domain *domain,
>   				   struct device *dev)
>   {
> -	struct sysmmu_drvdata *data = dev_get_drvdata(dev->archdata.iommu);
> +	struct exynos_iommu_owner *owner = dev->archdata.iommu;
>   	struct exynos_iommu_domain *priv = domain->priv;
>   	unsigned long flags;
>   	int ret;
>
> -	ret = pm_runtime_get_sync(data->sysmmu);
> -	if (ret < 0)
> -		return ret;
> -
> -	ret = 0;
> -
>   	spin_lock_irqsave(&priv->lock, flags);
>
> -	ret = __exynos_sysmmu_enable(data, __pa(priv->pgtable), domain);
> -
> +	ret = __exynos_sysmmu_enable(dev, __pa(priv->pgtable), domain);
>   	if (ret == 0) {
> -		/* 'data->node' must not be appeared in priv->clients */
> -		BUG_ON(!list_empty(&data->node));
> -		data->dev = dev;
> -		list_add_tail(&data->node, &priv->clients);
> +		list_add_tail(&owner->client, &priv->clients);
> +		owner->domain = domain;
>   	}
>
>   	spin_unlock_irqrestore(&priv->lock, flags);
>
> -	if (ret < 0) {
> -		dev_err(dev, "%s: Failed to attach IOMMU with pgtable %#lx\n",
> +	if (ret < 0)
> +		dev_err(dev, "%s: Failed to attach IOMMU with pgtable %#x\n",
>   				__func__, __pa(priv->pgtable));
> -		pm_runtime_put(data->sysmmu);
> -	} else if (ret > 0) {
> -		dev_dbg(dev, "%s: IOMMU with pgtable 0x%lx already attached\n",
> -					__func__, __pa(priv->pgtable));
> -	} else {
> -		dev_dbg(dev, "%s: Attached new IOMMU with pgtable 0x%lx\n",
> -					__func__, __pa(priv->pgtable));
> -	}
> +	else
> +		dev_dbg(dev, "%s: Attached IOMMU with pgtable 0x%x%s\n",
> +					__func__, __pa(priv->pgtable),
> +					(ret == 0) ? "" : ", again");
>
>   	return ret;
>   }
> @@ -700,39 +761,29 @@ static int exynos_iommu_attach_device(struct iommu_domain *domain,
>   static void exynos_iommu_detach_device(struct iommu_domain *domain,
>   				    struct device *dev)
>   {
> -	struct sysmmu_drvdata *data = dev_get_drvdata(dev->archdata.iommu);
> +	struct exynos_iommu_owner *owner;
>   	struct exynos_iommu_domain *priv = domain->priv;
> -	struct list_head *pos;
>   	unsigned long flags;
> -	bool found = false;
>
>   	spin_lock_irqsave(&priv->lock, flags);
>
> -	list_for_each(pos, &priv->clients) {
> -		if (list_entry(pos, struct sysmmu_drvdata, node) == data) {
> -			found = true;
> +	list_for_each_entry(owner, &priv->clients, client) {
> +		if (owner == dev->archdata.iommu) {
> +			if (exynos_sysmmu_disable(dev)) {
> +				list_del_init(&owner->client);
> +				owner->domain = NULL;
> +			}
>   			break;
>   		}
>   	}
>
> -	if (!found)
> -		goto finish;
> -
> -	if (__exynos_sysmmu_disable(data)) {
> -		dev_dbg(dev, "%s: Detached IOMMU with pgtable %#lx\n",
> -					__func__, __pa(priv->pgtable));
> -		list_del_init(&data->node);
> -
> -	} else {
> -		dev_dbg(dev, "%s: Detaching IOMMU with pgtable %#lx delayed",
> -					__func__, __pa(priv->pgtable));
> -	}
> -
> -finish:
>   	spin_unlock_irqrestore(&priv->lock, flags);
>
> -	if (found)
> -		pm_runtime_put(data->sysmmu);
> +	if (owner == dev->archdata.iommu)
> +		dev_dbg(dev, "%s: Detached IOMMU with pgtable %#x\n",
> +					__func__, __pa(priv->pgtable));
> +	else
> +		dev_dbg(dev, "%s: No IOMMU is attached\n", __func__);
>   }
>
>   static unsigned long *alloc_lv2entry(unsigned long *sent, unsigned long iova,
> @@ -862,7 +913,7 @@ static size_t exynos_iommu_unmap(struct iommu_domain *domain,
>   					       unsigned long iova, size_t size)
>   {
>   	struct exynos_iommu_domain *priv = domain->priv;
> -	struct sysmmu_drvdata *data;
> +	struct exynos_iommu_owner *owner;
>   	unsigned long flags;
>   	unsigned long *ent;
>   	size_t err_pgsize;
> @@ -923,8 +974,8 @@ done:
>   	spin_unlock_irqrestore(&priv->pgtablelock, flags);
>
>   	spin_lock_irqsave(&priv->lock, flags);
> -	list_for_each_entry(data, &priv->clients, node)
> -		sysmmu_tlb_invalidate_entry(data->dev, iova, size);
> +	list_for_each_entry(owner, &priv->clients, client)
> +		sysmmu_tlb_invalidate_entry(owner->dev, iova, size);
>   	spin_unlock_irqrestore(&priv->lock, flags);
>
>   	return size;
> @@ -1009,3 +1060,59 @@ err_reg_driver:
>   	return ret;
>   }
>   subsys_initcall(exynos_iommu_init);
> +
> +static int sysmmu_hook_driver_register(struct notifier_block *nb,
> +					unsigned long val,
> +					void *p)
> +{
> +	struct device *dev = p;
> +
> +	switch (val) {
> +	case BUS_NOTIFY_BIND_DRIVER:
> +	{
> +		struct exynos_iommu_owner *owner;

Please move this variable to the top of the function and drop the braces 
around case blocks.

> +
> +		/* No System MMU assigned. See exynos_sysmmu_probe(). */
> +		if (dev->archdata.iommu == NULL)
> +			break;

This looks strange... (see below)

Also this looks racy. There are no guarantees about device probing 
order, so you may end up with master devices being probed before the 
IOMMUs. Deferred probing should be used to handle this correctly.

> +
> +		owner = devm_kzalloc(dev, sizeof(*owner), GFP_KERNEL);
> +		if (!owner) {
> +			dev_err(dev, "No Memory for exynos_iommu_owner\n");
> +			return -ENOMEM;
> +		}
> +
> +		owner->dev = dev;
> +		INIT_LIST_HEAD(&owner->client);
> +		owner->sysmmu = dev->archdata.iommu;
> +
> +		dev->archdata.iommu = owner;

I don't understand what is happening here in this case statement. There 
is already something assigned to dev->archdata.iommu, but this code 
reassigns something else to this field. This means that you attempt to 
use the same field to store pointers to objects of different types, 
which I believe is broken, because you have no way to check what kind of 
object is currently pointed by such (void *) pointer.

> +		break;
> +	}
> +	case BUS_NOTIFY_UNBOUND_DRIVER:
> +	{
> +		struct exynos_iommu_owner *owner = dev->archdata.iommu;
> +		if (owner) {
> +			struct device *sysmmu = owner->sysmmu;
> +			/* if still attached to an iommu_domain. */
> +			if (WARN_ON(!list_empty(&owner->client)))
> +				iommu_detach_device(owner->domain, owner->dev);
> +			devm_kfree(dev, owner);
> +			dev->archdata.iommu = sysmmu;
> +		}
> +		break;
> +	}
> +	} /* switch (val) */
> +
> +	return 0;
> +}
> +
> +static struct notifier_block sysmmu_notifier = {
> +	.notifier_call = &sysmmu_hook_driver_register,
> +};
> +
> +static int __init exynos_iommu_prepare(void)
> +{
> +	return bus_register_notifier(&platform_bus_type, &sysmmu_notifier);
> +}
> +arch_initcall(exynos_iommu_prepare);

I don't think it is a good idea to use such initcalls in drivers, as it 
is not multiplatform friendly. On a multiplatform kernel with 
exynos-iommu driver simply compiled in this notifier will register on 
any platform, not only on Exynos.

Best regards,
Tomasz
