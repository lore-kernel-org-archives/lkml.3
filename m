Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966856Ab3HHWp1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Aug 2013 18:45:27 -0400
Received: from mail-bk0-f53.google.com ([209.85.214.53]:43675 "EHLO
	mail-bk0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966781Ab3HHWp0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Aug 2013 18:45:26 -0400
From: Tomasz Figa <tomasz.figa@gmail.com>
To: Cho KyongHo <pullip.cho@samsung.com>
Cc: "'Linux ARM Kernel'" <linux-arm-kernel@lists.infradead.org>,
        "'Linux IOMMU'" <iommu@lists.linux-foundation.org>,
        "'Linux Kernel'" <linux-kernel@vger.kernel.org>,
        "'Linux Samsung SOC'" <linux-samsung-soc@vger.kernel.org>,
        devicetree@vger.kernel.org, "'Joerg Roedel'" <joro@8bytes.org>,
        "'Kukjin Kim'" <kgene.kim@samsung.com>,
        "'Prathyush'" <prathyush.k@samsung.com>,
        "'Rahul Sharma'" <rahul.sharma@samsung.com>,
        "'Subash Patel'" <supash.ramaswamy@linaro.org>,
        "'Grant Grundler'" <grundler@chromium.org>,
        "'Antonios Motakis'" <a.motakis@virtualopensystems.com>,
        kvmarm@lists.cs.columbia.edu,
        "'Sachin Kamat'" <sachin.kamat@linaro.org>
Subject: Re: [PATCH v9 08/16] iommu/exynos: gating clocks of master H/W
Date: Fri, 09 Aug 2013 00:45:17 +0200
Message-ID: <7908536.azGeeOL56k@flatron>
User-Agent: KMail/4.10.5 (Linux/3.10.4-gentoo; KDE/4.10.5; x86_64; ; )
In-Reply-To: <002c01ce941b$1fd0ab80$5f720280$@samsung.com>
References: <002c01ce941b$1fd0ab80$5f720280$@samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi KyongHo,

On Thursday 08 of August 2013 18:39:05 Cho KyongHo wrote:
> This patch gates clocks of master H/W as well as clocks of System MMU
> if master clocks are specified.
> 
> Some Exynos SoCs (i.e. GScalers in Exynos5250) have dependencies in
> the gating clocks of master H/W and its System MMU. If a H/W is the
> case, accessing control registers of System MMU is prohibited unless
> both of the gating clocks of System MMU and its master H/W.
> 
> Signed-off-by: Cho KyongHo <pullip.cho@samsung.com>
> ---
>  drivers/iommu/exynos-iommu.c |   38
> ++++++++++++++++++++++++++++++++++---- 1 files changed, 34
> insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/iommu/exynos-iommu.c b/drivers/iommu/exynos-iommu.c
> index 0ee73e8..005a7ed 100644
> --- a/drivers/iommu/exynos-iommu.c
> +++ b/drivers/iommu/exynos-iommu.c
> @@ -173,6 +173,7 @@ struct sysmmu_drvdata {
>  	struct device *dev;	/* Owner of system MMU */
>  	int nsfrs;
>  	struct clk *clk;
> +	struct clk *clk_master;
>  	int activations;
>  	rwlock_t lock;
>  	struct iommu_domain *domain;
> @@ -263,6 +264,8 @@ void exynos_sysmmu_set_prefbuf(struct device *dev,
>  	if (!is_sysmmu_active(data))
>  		goto finish;
> 
> +	clk_enable(data->clk_master);
> +
>  	for (i = 0; i < data->nsfrs; i++) {
>  		if ((readl(data->sfrbases[i] + REG_MMU_VERSION) >> 28) == 
3) {
>  			if (!sysmmu_block(data->sfrbases[i]))
> @@ -288,6 +291,8 @@ void exynos_sysmmu_set_prefbuf(struct device *dev,
>  			sysmmu_unblock(data->sfrbases[i]);
>  		}
>  	}
> +
> +	clk_disable(data->clk_master);
>  finish:
>  	read_unlock_irqrestore(&data->lock, flags);
>  }
> @@ -358,6 +363,8 @@ static irqreturn_t exynos_sysmmu_irq(int irq, void
> *dev_id) break;
>  	}
> 
> +	clk_enable(data->clk_master);
> +
>  	if (i == pdev->num_resources) {
>  		itype = SYSMMU_FAULT_UNKNOWN;
>  	} else {
> @@ -391,6 +398,8 @@ static irqreturn_t exynos_sysmmu_irq(int irq, void
> *dev_id) if (itype != SYSMMU_FAULT_UNKNOWN)
>  		sysmmu_unblock(data->sfrbases[i]);
> 
> +	clk_disable(data->clk_master);
> +
>  	read_unlock(&data->lock);
> 
>  	return IRQ_HANDLED;
> @@ -407,11 +416,14 @@ static bool __exynos_sysmmu_disable(struct
> sysmmu_drvdata *data) if (!set_sysmmu_inactive(data))
>  		goto finish;
> 
> +	clk_enable(data->clk_master);
> +
>  	for (i = 0; i < data->nsfrs; i++)
>  		__raw_writel(CTRL_DISABLE, data->sfrbases[i] + 
REG_MMU_CTRL);
> 
> -	if (data->clk)
> -		clk_disable(data->clk);
> +	clk_disable(data->clk_master);
> +
> +	clk_disable(data->clk);
> 
>  	disabled = true;
>  	data->pgtable = 0;
> @@ -454,11 +466,12 @@ static int __exynos_sysmmu_enable(struct
> sysmmu_drvdata *data, goto finish;
>  	}
> 
> -	if (data->clk)
> -		clk_enable(data->clk);
> +	clk_enable(data->clk);
> 
>  	data->pgtable = pgtable;
> 
> +	clk_enable(data->clk_master);
> +
>  	for (i = 0; i < data->nsfrs; i++) {
>  		__sysmmu_set_ptbase(data->sfrbases[i], pgtable);
> 
> @@ -473,6 +486,8 @@ static int __exynos_sysmmu_enable(struct
> sysmmu_drvdata *data, __raw_writel(CTRL_ENABLE, data->sfrbases[i] +
> REG_MMU_CTRL); }
> 
> +	clk_disable(data->clk_master);
> +
>  	data->domain = domain;
> 
>  	dev_dbg(data->sysmmu, "Enabled\n");
> @@ -528,6 +543,7 @@ static void sysmmu_tlb_invalidate_entry(struct
> device *dev, unsigned long iova)
> 
>  	if (is_sysmmu_active(data)) {
>  		int i;
> +		clk_enable(data->clk_master);
>  		for (i = 0; i < data->nsfrs; i++) {
>  			if (sysmmu_block(data->sfrbases[i])) {
>  				__sysmmu_tlb_invalidate_entry(
> @@ -535,6 +551,7 @@ static void sysmmu_tlb_invalidate_entry(struct
> device *dev, unsigned long iova) sysmmu_unblock(data->sfrbases[i]);
>  			}
>  		}
> +		clk_disable(data->clk_master);
>  	} else {
>  		dev_dbg(data->sysmmu, "Disabled. Skipping invalidating 
TLB.\n");
>  	}
> @@ -551,12 +568,14 @@ void exynos_sysmmu_tlb_invalidate(struct device
> *dev)
> 
>  	if (is_sysmmu_active(data)) {
>  		int i;
> +		clk_enable(data->clk_master);
>  		for (i = 0; i < data->nsfrs; i++) {
>  			if (sysmmu_block(data->sfrbases[i])) {
>  				__sysmmu_tlb_invalidate(data-
>sfrbases[i]);
>  				sysmmu_unblock(data->sfrbases[i]);
>  			}
>  		}
> +		clk_disable(data->clk_master);
>  	} else {
>  		dev_dbg(data->sysmmu, "Disabled. Skipping invalidating 
TLB.\n");
>  	}
> @@ -637,6 +656,17 @@ static int __init exynos_sysmmu_probe(struct
> platform_device *pdev) return ret;
>  	}
> 
> +	data->clk_master = devm_clk_get(dev, "master");
> +	if (IS_ERR(data->clk_master))
> +		data->clk_master = NULL;
> +
> +	ret = clk_prepare(data->clk_master);
> +	if (ret) {
> +		clk_unprepare(data->clk);
> +		dev_err(dev, "Failed to prepare master's clk\n");
> +		return ret;
> +	}
> +
>  	rwlock_init(&data->lock);
>  	INIT_LIST_HEAD(&data->node);

This should be done in a more appropriate way, but at the moment the PM 
Core doesn't have any provision to implement any sane solution for this 
kind of problems, so this is fine.

Reviewed-by: Tomasz Figa <t.figa@samsung.com>

Best regards,
Tomasz

