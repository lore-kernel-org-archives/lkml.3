Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752247AbbAGLjQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jan 2015 06:39:16 -0500
Received: from foss-mx-na.foss.arm.com ([217.140.108.86]:56587 "EHLO
	foss-mx-na.foss.arm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750971AbbAGLjP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jan 2015 06:39:15 -0500
Date: Wed, 7 Jan 2015 11:39:03 +0000
From: Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>
To: "mathieu.poirier@linaro.org" <mathieu.poirier@linaro.org>
Cc: Liviu Dudau <Liviu.Dudau@arm.com>, Sudeep Holla <Sudeep.Holla@arm.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "patches@linaro.org" <patches@linaro.org>
Subject: Re: [PATCH 7/9] ARM: vexpress/TC2: Add generic power domain
 awareness to scp driver
Message-ID: <20150107113903.GA29630@red-moon>
References: <1420562233-2015-1-git-send-email-mathieu.poirier@linaro.org>
 <1420562233-2015-8-git-send-email-mathieu.poirier@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1420562233-2015-8-git-send-email-mathieu.poirier@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Mathieu,

On Tue, Jan 06, 2015 at 04:37:11PM +0000, mathieu.poirier@linaro.org wrote:

[...]

> diff --git a/arch/arm/mach-vexpress/spc.c b/arch/arm/mach-vexpress/spc.c
> index f61158c6ce71..4ff1009f2d16 100644
> --- a/arch/arm/mach-vexpress/spc.c
> +++ b/arch/arm/mach-vexpress/spc.c
> @@ -28,6 +28,8 @@
>  #include <linux/pm_opp.h>
>  #include <linux/slab.h>
>  #include <linux/semaphore.h>
> +#include <linux/of_platform.h>
> +#include <linux/pm_domain.h>
>  
>  #include <asm/cacheflush.h>
>  
> @@ -92,6 +94,9 @@
>  #define STAT_ERR(type)		((1 << 1) << (type << 2))
>  #define RESPONSE_MASK(type)	(STAT_COMPLETE(type) | STAT_ERR(type))
>  
> +static atomic_t gpd_A7_cluster_on = ATOMIC_INIT(0);
> +static atomic_t gpd_A15_cluster_on = ATOMIC_INIT(0);
> +
>  struct ve_spc_opp {
>  	unsigned long freq;
>  	unsigned long u_volt;
> @@ -209,12 +214,19 @@ void ve_spc_set_resume_addr(u32 cluster, u32 cpu, u32 addr)
>   */
>  void ve_spc_powerdown(u32 cluster, bool enable)
>  {
> +	bool is_a15;
>  	u32 pwdrn_reg;
>  
>  	if (cluster >= MAX_CLUSTERS)
>  		return;
>  
> -	pwdrn_reg = cluster_is_a15(cluster) ? A15_PWRDN_EN : A7_PWRDN_EN;
> +	is_a15 = cluster_is_a15(cluster);
> +	if (is_a15 && atomic_read(&gpd_A15_cluster_on))
> +		return;
> +	else if (!is_a15 && atomic_read(&gpd_A7_cluster_on))
> +		return;
> +
> +	pwdrn_reg = is_a15 ? A15_PWRDN_EN : A7_PWRDN_EN;
>  	writel_relaxed(enable, info->baseaddr + pwdrn_reg);

I do not like this, for multiple reasons.

(1) It might not do what you want. I am not sure that nuking the power
    down request is safe. I have to check the power controller behaviour
    when a core is going through power down sequence but the PWRDN_EN
    bit is not set. You might end up with cores that are just being
    reset on pending IRQ (defeating your purpose) or stuck forever.
(2) It must be done by attaching the power domains to CPUidle states.
    Idle states are automagically disabled when the domain is turned on, it
    is cleaner, and more robust than what you do here. On the downside,
    we have to work together to add power domain information to DT idle
    states specifications/bindings.

    (see pm_genpd_attach_cpuidle() drivers/base/power/domain.c)

(3) I do not like the is_a15 comparisons, I think this can be done with
    cluster indexing the atomic variable, but since you are removing
    this code ;-) it does not really matter.

>  }
>  
> @@ -447,6 +459,116 @@ static int ve_init_opp_table(struct device *cpu_dev)
>  	return ret;
>  }
>  
> +#ifdef CONFIG_PM_GENERIC_DOMAINS_OF
> +static int scp_power_on_pd_A7(struct generic_pm_domain *domain)
> +{
> +	/*
> +	 * Simply tell mcpm we need power.  Nothing else needs to be done
> +	 * as CPUs in the cluster are already powered when we reach this point.
> +	 */
> +	atomic_set(&gpd_A7_cluster_on, 1);
> +	return 0;
> +}
> +
> +static int scp_power_off_pd_A7(struct generic_pm_domain *domain)
> +{
> +	atomic_set(&gpd_A7_cluster_on, 0);
> +	return 0;
> +}
> +
> +static int scp_power_on_pd_A15(struct generic_pm_domain *domain)
> +{
> +	/*
> +	 * Simply tell mcpm we need power.  Nothing else needs to be done
> +	 * as CPUs in the cluster are already powered when we reach this point.
> +	 */
> +	atomic_set(&gpd_A15_cluster_on, 1);
> +	return 0;
> +}
> +
> +static int scp_power_off_pd_A15(struct generic_pm_domain *domain)
> +{
> +	atomic_set(&gpd_A15_cluster_on, 0);
> +	return 0;
> +}
> +
> +static int (*const scp_power_fct[MAX_CLUSTERS * 2])
> +		(struct generic_pm_domain *domain) = {
> +		scp_power_on_pd_A15, scp_power_off_pd_A15,
> +		scp_power_on_pd_A7, scp_power_off_pd_A7};

I think you can remove the functions above and the corresponding atomic
variables, see my comment above.

> +static void scp_init_pd(struct generic_pm_domain *pd,
> +			    struct device_node *np,
> +			    struct platform_device *pdev, int cluster)
> +{
> +	char name[50];
> +	int index = cluster * 2;
> +
> +	snprintf(name, sizeof(name), "%s-%d", np->name, cluster);
> +
> +	pd->name = kstrdup(name, GFP_KERNEL);
> +	pd->power_on = scp_power_fct[index];
> +	pd->power_off =  scp_power_fct[index + 1];
> +	platform_set_drvdata(pdev, pd);
> +
> +	pm_genpd_init(pd, NULL, true);
> +	pm_genpd_poweron(pd);
> +}
> +
> +static __init int ve_spc_gpd_init(void)
> +{
> +	struct genpd_onecell_data *data;
> +	struct generic_pm_domain *pd, **cluster_pds;
> +	struct platform_device *pdev;
> +	struct device *dev;
> +	struct device_node *np;
> +	int count;
> +
> +	np = of_find_compatible_node(NULL, NULL,
> +				     "arm,vexpress-power-controller");

See the bindings discussions, there is not such a thing as
vexpress-power-controller.

> +	if (!np)
> +		return -EINVAL;
> +
> +	cluster_pds = kzalloc(sizeof(struct generic_pm_domain *) * MAX_CLUSTERS,
> +			      GFP_KERNEL);
> +	if (!cluster_pds)
> +		goto err_cluster_kzalloc;

You are freeing a pointer that failed to be allocated.

> +
> +	data = kzalloc(sizeof(struct genpd_onecell_data), GFP_KERNEL);
> +	if (!data)
> +		goto err_data;

Mmm...is that the label you want to jump to ? it fails to put the OF
node.

> +
> +	pdev = of_find_device_by_node(np);
> +	dev = &pdev->dev;
> +
> +	for (count = 0; count < MAX_CLUSTERS; count++) {
> +		pd = kzalloc(sizeof(struct generic_pm_domain), GFP_KERNEL);
> +		if (!pd)
> +			goto err_pd_kzalloc;

This label does not free the data pointer. I think you should rework
the error exit paths.

> +		scp_init_pd(pd, np, pdev, count);
> +		cluster_pds[count] = pd;
> +	}
> +
> +	data->num_domains = count;
> +	data->domains = cluster_pds;
> +
> +	of_genpd_add_provider_onecell(np, data);
> +	return 0;
> +
> +err_pd_kzalloc:
> +	while (--count >= 0)
> +		kfree(cluster_pds[count]);
> +
> +err_cluster_kzalloc:
> +	of_node_put(np);
> +err_data:
> +	kfree(cluster_pds);
> +	return -ENOMEM;
> +
> +}
> +arch_initcall(ve_spc_gpd_init);

It should not be an arch initcall, call it from spc_init, and make it an
empty static inline if !CONFIG_PM_GENERIC_DOMAINS_OF, eg:

static inline int ve_spc_gpd_init(void)
{
	return -ENOTSUPP;
}

Lorenzo

> +#endif
> +
>  int __init ve_spc_init(void __iomem *baseaddr, u32 a15_clusid, int irq)
>  {
>  	int ret;
> -- 
> 1.9.1
> 
> 
