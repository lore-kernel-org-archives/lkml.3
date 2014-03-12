Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754815AbaCLO5z (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Mar 2014 10:57:55 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:49759 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753980AbaCLO5x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Mar 2014 10:57:53 -0400
Date: Wed, 12 Mar 2014 15:57:37 +0100
From: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Subject: Re: [PATCH 2/4] devfreq: exynos4: Use common ppmu driver and get ppmu
 address from dt data
In-reply-to: <1394624882-2989-3-git-send-email-cw00.choi@samsung.com>
To: Chanwoo Choi <cw00.choi@samsung.com>
Cc: myungjoo.ham@samsung.com, kyungmin.park@samsung.com,
        rafael.j.wysocki@intel.com, nm@ti.com, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@vger.kernel.org
Message-id: <3861973.HsqAMccY2S@amdc1032>
MIME-version: 1.0
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7Bit
X-AuditID: cbfee61a-b7fb26d00000724f-85-532075f0f65b
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrNLMWRmVeSWpSXmKPExsVy+t9jQd0PpQrBBpfvK1pc//Kc1eJs0xt2
	i+4f2RaXd81hs/jce4TR4nbjCjaLNz/OMlk8XvGW3YHDY/Gel0wefVtWMXocv7GdyePzJrkA
	ligum5TUnMyy1CJ9uwSujPffbzIV3E+qWHZlFksD41rfLkZODgkBE4kZByYyQdhiEhfurWfr
	YuTiEBKYziix6uwUdginhUlix/5zLCBVbAJWEhPbVzGC2CICGhIz/15hBCliFtjDKDG17xcr
	SEJYIFViz6s9YGNZBFQlLmzdxQxi8wpoSmzZ9pANxBYV8JTYsX0lmM0p4Cqx9+t7oG0cQNvq
	JX52h0KUC0r8mHwPbC+zgLzEvv1TWSFsHYn9rdPYJjAKzEJSNgtJ2SwkZQsYmVcxiqYWJBcU
	J6XnGuoVJ+YWl+al6yXn525iBAf5M6kdjCsbLA4xCnAwKvHwLtCUDxZiTSwrrsw9xCjBwawk
	wvu0UCFYiDclsbIqtSg/vqg0J7X4EKM0B4uSOO+BVutAIYH0xJLU7NTUgtQimCwTB6dUA6Pw
	lcjDsb/PBP/5dXRFp5qqQuiOe6rJLqWFXS35FuY7zCvu6u0XudPTuO7EJHe7di7//K7vLh2m
	cze3zP9VtjRXeSnv/nUlBsofpnAti5z+4p1ad/atiTs+ZbPIxHLae5yunSTzckpGw7Fmrdrb
	CdMDC45J6kwrmGwTsM2D40Des23JnnyT3JRYijMSDbWYi4oTAQ5nk+VuAgAA
References: <1394624882-2989-1-git-send-email-cw00.choi@samsung.com>
 <1394624882-2989-3-git-send-email-cw00.choi@samsung.com>
User-Agent: KMail/4.8.4 (Linux/3.2.0-54-generic-pae; KDE/4.8.5; i686; ; )
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi,

On Wednesday, March 12, 2014 08:48:00 PM Chanwoo Choi wrote:
> This patch use common ppmu driver of exynos_ppmu.c driver instead of individual
> function related to PPC block and get ppmu address from dt data by using dt
> helper function (of_iomap). And then this patch delete duplicate defined
> structure/enum.
> 
> For example,a
> busfreq@106A0000 {
> 	compatible = "samsung,exynos4x12-busfreq";
> 	reg = <0x106A0000 0x2000>, <0x106B0000 0x2000>;
> 	regs-name = "PPMU_DMC0", "PPMU_DMC1";
> };

DT bindings need to be documented in Documentation/devicetree/bindings/.

> Signed-off-by: Chanwoo Choi <cw00.choi@samsung.com>
> ---
>  drivers/devfreq/exynos/exynos4_bus.c | 237 +++++++++++++++++++----------------
>  1 file changed, 128 insertions(+), 109 deletions(-)
> 
> diff --git a/drivers/devfreq/exynos/exynos4_bus.c b/drivers/devfreq/exynos/exynos4_bus.c
> index 168a7c6..16fb3cb 100644
> --- a/drivers/devfreq/exynos/exynos4_bus.c
> +++ b/drivers/devfreq/exynos/exynos4_bus.c
> @@ -24,17 +24,19 @@
>  #include <linux/platform_device.h>
>  #include <linux/regulator/consumer.h>
>  #include <linux/of.h>
> +#include <linux/of_address.h>
>  #include <linux/module.h>
>  
> +#include <mach/map.h>
> +
> +#include "exynos_ppmu.h"
> +#include "exynos4_bus.h"
> +
>  /* Exynos4 ASV has been in the mailing list, but not upstreamed, yet. */
>  #ifdef CONFIG_EXYNOS_ASV
>  extern unsigned int exynos_result_of_asv;
>  #endif
>  
> -#include <mach/map.h>
> -
> -#include "exynos4_bus.h"
> -
>  #define MAX_SAFEVOLT	1200000 /* 1.2V */
>  
>  enum exynos4_busf_type {
> @@ -45,22 +47,6 @@ enum exynos4_busf_type {
>  /* Assume that the bus is saturated if the utilization is 40% */
>  #define BUS_SATURATION_RATIO	40
>  
> -enum ppmu_counter {
> -	PPMU_PMNCNT0 = 0,
> -	PPMU_PMCCNT1,
> -	PPMU_PMNCNT2,
> -	PPMU_PMNCNT3,
> -	PPMU_PMNCNT_MAX,
> -};
> -struct exynos4_ppmu {
> -	void __iomem *hw_base;
> -	unsigned int ccnt;
> -	unsigned int event;
> -	unsigned int count[PPMU_PMNCNT_MAX];
> -	bool ccnt_overflow;
> -	bool count_overflow[PPMU_PMNCNT_MAX];
> -};
> -
>  enum busclk_level_idx {
>  	LV_0 = 0,
>  	LV_1,
> @@ -69,6 +55,13 @@ enum busclk_level_idx {
>  	LV_4,
>  	_LV_END
>  };
> +
> +enum exynos_ppmu_idx {
> +	PPMU_DMC0,
> +	PPMU_DMC1,
> +	PPMU_END,
> +};
> +
>  #define EX4210_LV_MAX	LV_2
>  #define EX4x12_LV_MAX	LV_4
>  #define EX4210_LV_NUM	(LV_2 + 1)
> @@ -92,7 +85,7 @@ struct busfreq_data {
>  	struct regulator *vdd_int;
>  	struct regulator *vdd_mif; /* Exynos4412/4212 only */
>  	struct busfreq_opp_info curr_oppinfo;
> -	struct exynos4_ppmu dmc[2];
> +	struct exynos_ppmu ppmu[PPMU_END];
>  
>  	struct notifier_block pm_notifier;
>  	struct mutex lock;
> @@ -102,12 +95,6 @@ struct busfreq_data {
>  	unsigned int top_divtable[_LV_END];
>  };
>  
> -struct bus_opp_table {
> -	unsigned int idx;
> -	unsigned long clk;
> -	unsigned long volt;
> -};
> -
>  /* 4210 controls clock of mif and voltage of int */
>  static struct bus_opp_table exynos4210_busclk_table[] = {
>  	{LV_0, 400000, 1150000},
> @@ -525,27 +512,22 @@ static int exynos4x12_set_busclk(struct busfreq_data *data,
>  	return 0;
>  }
>  
> -
>  static void busfreq_mon_reset(struct busfreq_data *data)
>  {
>  	unsigned int i;
>  
> -	for (i = 0; i < 2; i++) {
> -		void __iomem *ppmu_base = data->dmc[i].hw_base;
> +	for (i = 0; i < PPMU_END; i++) {
> +		void __iomem *ppmu_base = data->ppmu[i].hw_base;
>  
> -		/* Reset PPMU */
> -		__raw_writel(0x8000000f, ppmu_base + 0xf010);
> -		__raw_writel(0x8000000f, ppmu_base + 0xf050);
> -		__raw_writel(0x6, ppmu_base + 0xf000);
> -		__raw_writel(0x0, ppmu_base + 0xf100);
> +		/* Reset the performance and cycle counters */
> +		exynos_ppmu_reset(ppmu_base);
>  
> -		/* Set PPMU Event */
> -		data->dmc[i].event = 0x6;
> -		__raw_writel(((data->dmc[i].event << 12) | 0x1),
> -			     ppmu_base + 0xfc);
> +		/* Setup count registers to monitor read/write transactions */
> +		data->ppmu[i].event[PPMU_PMNCNT3] = RDWR_DATA_COUNT;
> +		exynos_ppmu_setevent(ppmu_base, PPMU_PMNCNT3,
> +					data->ppmu[i].event[PPMU_PMNCNT3]);
>  
> -		/* Start PPMU */
> -		__raw_writel(0x1, ppmu_base + 0xf000);
> +		exynos_ppmu_start(ppmu_base);
>  	}
>  }
>  
> @@ -553,23 +535,20 @@ static void exynos4_read_ppmu(struct busfreq_data *data)
>  {
>  	int i, j;
>  
> -	for (i = 0; i < 2; i++) {
> -		void __iomem *ppmu_base = data->dmc[i].hw_base;
> -		u32 overflow;
> +	for (i = 0; i < PPMU_END; i++) {
> +		void __iomem *ppmu_base = data->ppmu[i].hw_base;
>  
> -		/* Stop PPMU */
> -		__raw_writel(0x0, ppmu_base + 0xf000);
> +		exynos_ppmu_stop(ppmu_base);
>  
>  		/* Update local data from PPMU */
> -		overflow = __raw_readl(ppmu_base + 0xf050);
> -
> -		data->dmc[i].ccnt = __raw_readl(ppmu_base + 0xf100);
> -		data->dmc[i].ccnt_overflow = overflow & (1 << 31);
> -
> -		for (j = 0; j < PPMU_PMNCNT_MAX; j++) {
> -			data->dmc[i].count[j] = __raw_readl(
> -					ppmu_base + (0xf110 + (0x10 * j)));
> -			data->dmc[i].count_overflow[j] = overflow & (1 << j);
> +		data->ppmu[i].ccnt = __raw_readl(ppmu_base + PPMU_CCNT);
> +
> +		for (j = PPMU_PMNCNT0; j < PPMU_PMNCNT_MAX; j++) {
> +			if (data->ppmu[i].event[j] == 0)
> +				data->ppmu[i].count[j] = 0;
> +			else
> +				data->ppmu[i].count[j] =
> +					exynos_ppmu_read(ppmu_base, j);
>  		}
>  	}
>  
> @@ -699,66 +678,42 @@ out:
>  	return err;
>  }
>  
> -static int exynos4_get_busier_dmc(struct busfreq_data *data)
> +static int exynos4_get_busier_ppmu(struct busfreq_data *data)
>  {
> -	u64 p0 = data->dmc[0].count[0];
> -	u64 p1 = data->dmc[1].count[0];
> -
> -	p0 *= data->dmc[1].ccnt;
> -	p1 *= data->dmc[0].ccnt;
> -
> -	if (data->dmc[1].ccnt == 0)
> -		return 0;
> +	int i, j;
> +	int busy = 0;
> +	unsigned int temp = 0;
> +
> +	for (i = 0; i < PPMU_END; i++) {
> +		for (j = PPMU_PMNCNT0; j < PPMU_PMNCNT_MAX; j++) {
> +			if (data->ppmu[i].count[j] > temp) {
> +				temp = data->ppmu[i].count[j];
> +				busy = i;
> +			}
> +		}
> +	}
>  
> -	if (p0 > p1)
> -		return 0;
> -	return 1;
> +	return busy;
>  }
>  
>  static int exynos4_bus_get_dev_status(struct device *dev,
>  				      struct devfreq_dev_status *stat)
>  {
>  	struct busfreq_data *data = dev_get_drvdata(dev);
> -	int busier_dmc;
> -	int cycles_x2 = 2; /* 2 x cycles */
> -	void __iomem *addr;
> -	u32 timing;
> -	u32 memctrl;
> +	int busier;
>  
>  	exynos4_read_ppmu(data);
> -	busier_dmc = exynos4_get_busier_dmc(data);
> +	busier = exynos4_get_busier_ppmu(data);
>  	stat->current_frequency = data->curr_oppinfo.rate;
>  
> -	if (busier_dmc)
> -		addr = S5P_VA_DMC1;
> -	else
> -		addr = S5P_VA_DMC0;
> -
> -	memctrl = __raw_readl(addr + 0x04); /* one of DDR2/3/LPDDR2 */
> -	timing = __raw_readl(addr + 0x38); /* CL or WL/RL values */
> -
> -	switch ((memctrl >> 8) & 0xf) {
> -	case 0x4: /* DDR2 */
> -		cycles_x2 = ((timing >> 16) & 0xf) * 2;
> -		break;
> -	case 0x5: /* LPDDR2 */
> -	case 0x6: /* DDR3 */
> -		cycles_x2 = ((timing >> 8) & 0xf) + ((timing >> 0) & 0xf);
> -		break;
> -	default:
> -		pr_err("%s: Unknown Memory Type(%d).\n", __func__,
> -		       (memctrl >> 8) & 0xf);
> -		return -EINVAL;
> -	}
> -
>  	/* Number of cycles spent on memory access */
> -	stat->busy_time = data->dmc[busier_dmc].count[0] / 2 * (cycles_x2 + 2);
> +	stat->busy_time = data->ppmu[busier].count[PPMU_PMNCNT3];

I believe that above change should be mentioned in the patch description.

>  	stat->busy_time *= 100 / BUS_SATURATION_RATIO;
> -	stat->total_time = data->dmc[busier_dmc].ccnt;
> +	stat->total_time = data->ppmu[busier].ccnt;
>  
>  	/* If the counters have overflown, retry */
> -	if (data->dmc[busier_dmc].ccnt_overflow ||
> -	    data->dmc[busier_dmc].count_overflow[0])
> +	if (data->ppmu[busier].ccnt_overflow ||
> +	    data->ppmu[busier].count_overflow[0])
>  		return -EAGAIN;
>  
>  	return 0;
> @@ -1028,6 +983,39 @@ static struct of_device_id exynos4_busfreq_id_match[] = {
>  	},
>  };
>  
> +static int exynos4_busfreq_parse_dt(struct busfreq_data *data)
> +{
> +	struct device *dev = data->dev;
> +	struct device_node *np = dev->of_node;
> +	int i, ret;
> +
> +	if (!np) {
> +		dev_err(dev, "Faild to find devicetree node\n");

Failed

> +		return -EINVAL;
> +	}
> +
> +	/* Maps the memory mapped IO to control PPMU register */
> +	for (i = 0; i < PPMU_END; i++) {
> +		data->ppmu[i].hw_base = of_iomap(np, i);
> +		if (IS_ERR_OR_NULL(data->ppmu[i].hw_base)) {
> +			dev_err(dev, "Failed to map memory region\n");
> +			data->ppmu[i].hw_base = NULL;
> +			ret = -EINVAL;
> +			goto err_iomap;
> +		}
> +	}
> +
> +	return 0;
> +
> +err_iomap:
> +	for (i = 0; i < PPMU_END; i++) {
> +		if (data->ppmu[i].hw_base)
> +			iounmap(data->ppmu[i].hw_base);
> +	}
> +
> +	return ret;
> +}
> +
>  static int exynos4_busfreq_get_driver_data(struct platform_device *pdev)
>  {
>  	struct device *dev = &pdev->dev;
> @@ -1045,7 +1033,7 @@ static int exynos4_busfreq_probe(struct platform_device *pdev)
>  	struct busfreq_data *data;
>  	struct dev_pm_opp *opp;
>  	struct device *dev = &pdev->dev;
> -	int err = 0;
> +	int i, err = 0;
>  
>  	data = devm_kzalloc(&pdev->dev, sizeof(struct busfreq_data), GFP_KERNEL);
>  	if (data == NULL) {
> @@ -1054,10 +1042,16 @@ static int exynos4_busfreq_probe(struct platform_device *pdev)
>  	}
>  
>  	data->type = exynos4_busfreq_get_driver_data(pdev);
> -	data->dmc[0].hw_base = S5P_VA_DMC0;
> -	data->dmc[1].hw_base = S5P_VA_DMC1;
>  	data->pm_notifier.notifier_call = exynos4_busfreq_pm_notifier_event;
>  	data->dev = dev;
> +
> +	/* Parse dt data to get register/regulator */
> +	err = exynos4_busfreq_parse_dt(data);
> +	if (err < 0) {
> +		dev_err(dev, "Failed to parse dt for resource\n");
> +		return err;
> +	}
> +
>  	mutex_init(&data->lock);
>  
>  	switch (data->type) {
> @@ -1102,23 +1096,48 @@ static int exynos4_busfreq_probe(struct platform_device *pdev)
>  
>  	platform_set_drvdata(pdev, data);
>  
> -	busfreq_mon_reset(data);
> -
> +	/* Reigster Exynos4's devfreq instance with 'simple_ondemand' gov */
>  	data->devfreq = devfreq_add_device(dev, &exynos4_devfreq_profile,
>  					   "simple_ondemand", NULL);
> -	if (IS_ERR(data->devfreq))
> -		return PTR_ERR(data->devfreq);
> +	if (IS_ERR(data->devfreq)) {
> +		dev_err(dev, "Failed to add devfreq device\n");
> +		err = PTR_ERR(data->devfreq);
> +		goto err_opp;
> +	}
>  
> -	devfreq_register_opp_notifier(dev, data->devfreq);
> +	/*
> +	 * Start PPMU(Performance Profiling Monitoring Unit) to check
> +	 * utilization of each IP in the Exynos4 SoC.
> +	 */
> +	busfreq_mon_reset(data);
>  
> +	/* Register opp_notifier for Exynos4 busfreq */
> +	err = devfreq_register_opp_notifier(dev, data->devfreq);
> +	if (err < 0) {

This patch adds devfreq_register_opp_notifier() return value checking,
this would be best done in a separate pre-patch.

> +		dev_err(dev, "Failed to register opp notifier\n");
> +		goto err_notifier_opp;
> +	}
> +
> +	/* Register pm_notifier for Exynos4 busfreq */
>  	err = register_pm_notifier(&data->pm_notifier);
>  	if (err) {
>  		dev_err(dev, "Failed to setup pm notifier\n");
> -		devfreq_remove_device(data->devfreq);

It also adds devfreq_unregister_opp_notifier() call on error which
is (again) best to be handled in separate pre-patch (together with
devfreq_register_opp_notifier() return value checking).

There is also another change in patch #3 which would be best to be
moved to afore-mentioned pre-patch:

- bugfix moving devfreq_unregister_opp_notifier() call from
  exynos4_bus_exit() to exynos4_busfreq_remove()

> -		return err;
> +		goto err_notifier_pm;
>  	}
>  
>  	return 0;
> +
> +err_notifier_pm:
> +	devfreq_unregister_opp_notifier(dev, data->devfreq);
> +err_notifier_opp:
> +	devfreq_remove_device(data->devfreq);
> +err_opp:
> +	for (i = 0; i < PPMU_END; i++) {
> +		if (data->ppmu[i].hw_base)
> +			iounmap(data->ppmu[i].hw_base);
> +	}

This covers iounmap in the failure path but for handling remove
handler (exynos4_busfreq_remove()) ioumap needs to be done also in
exynos4_bus_exit().  This is currently done in patch #3 and should
be done in this patch instead.

> +	return err;
>  }
>  
>  static int exynos4_busfreq_remove(struct platform_device *pdev)

Best regards,
--
Bartlomiej Zolnierkiewicz
Samsung R&D Institute Poland
Samsung Electronics

