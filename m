Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756573Ab3FESIi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Jun 2013 14:08:38 -0400
Received: from smarthost04.mail.zen.net.uk ([212.23.1.4]:36320 "EHLO
	smarthost04.mail.zen.net.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753657Ab3FESIg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Jun 2013 14:08:36 -0400
X-Greylist: delayed 5763 seconds by postgrey-1.27 at vger.kernel.org; Wed, 05 Jun 2013 14:08:36 EDT
Message-ID: <1370455713.3496.22.camel@linaro1.home>
Subject: Re: [RFC PATCH v2 2/2] drivers: mfd: vexpress: add Serial Power
 Controller (SPC) support
From: "Jon Medhurst (Tixy)" <tixy@linaro.org>
To: Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        devicetree-discuss@lists.ozlabs.org,
        Nicolas Pitre <nicolas.pitre@linaro.org>,
        Samuel Ortiz <sameo@linux.intel.com>, Pawel Moll <pawel.moll@arm.com>,
        Sudeep KarkadaNagesha <Sudeep.KarkadaNagesha@arm.com>,
        Achin Gupta <achin.gupta@arm.com>,
        Amit Kucheria <amit.kucheria@linaro.org>
Date: Wed, 05 Jun 2013 19:08:33 +0100
In-Reply-To: <1370432767-6620-3-git-send-email-lorenzo.pieralisi@arm.com>
References: <1370432767-6620-1-git-send-email-lorenzo.pieralisi@arm.com>
	 <1370432767-6620-3-git-send-email-lorenzo.pieralisi@arm.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4-3 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Originating-Smarthost04-IP: [82.69.122.217]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2013-06-05 at 12:46 +0100, Lorenzo Pieralisi wrote:
[...]
> +static const struct of_device_id vexpress_spc_ids[] __initconst = {
> +	{ .compatible = "arm,vexpress-spc,v2p-ca15_a7" },
> +	{ .compatible = "arm,vexpress-spc" },
> +	{},
> +};
> +
> +static int __init vexpress_spc_init(void)
> +{
> +	int ret;
> +	struct device_node *node = of_find_matching_node(NULL,
> +							 vexpress_spc_ids);

To allow for devices without an SPC we should check for !node here and
bail out, otherwise we get an ugly message from the WARN_ON further
down. I see this on RTSM, and multiplatform kernels would suffer this as
well.

Even if the ugly warning wasn't there, it still seems cleaner to me to
have a proper check for an absent spc node.

> +	info = kzalloc(sizeof(*info), GFP_KERNEL);
> +	if (!info) {
> +		pr_err("%s: unable to allocate mem\n", __func__);
> +		return -ENOMEM;
> +	}
> +	info->cur_req_type = INVALID_TYPE;
> +
> +	info->baseaddr = of_iomap(node, 0);
> +	if (WARN_ON(!info->baseaddr)) {
> +		ret = -ENXIO;
> +		goto mem_free;
> +	}
> +
> +	info->irq = irq_of_parse_and_map(node, 0);
> +
> +	if (WARN_ON(!info->irq)) {
> +		ret = -ENXIO;
> +		goto unmap;
> +	}
> +
> +	readl_relaxed(info->baseaddr + PWC_STATUS);
> +
> +	ret = request_irq(info->irq, vexpress_spc_irq_handler,
> +		IRQF_DISABLED | IRQF_TRIGGER_HIGH | IRQF_ONESHOT,
> +		"arm-spc", info);
> +
> +	if (ret) {
> +		pr_err("IRQ %d request failed\n", info->irq);
> +		ret = -ENODEV;
> +		goto unmap;
> +	}
> +
> +	info->a15_clusid = readl_relaxed(info->baseaddr + A15_CONF) & 0xf;
> +
> +	vexpress_spc_config_bridge = vexpress_config_bridge_register(
> +			node, &vexpress_spc_config_bridge_info);
> +
> +	if (WARN_ON(!vexpress_spc_config_bridge)) {
> +		ret = -ENODEV;
> +		goto unmap;
> +	}
> +
> +	opp_func = vexpress_config_func_get(vexpress_spc_config_bridge, "opp");
> +	perf_func =
> +		vexpress_config_func_get(vexpress_spc_config_bridge, "perf");
> +
> +	if (!opp_func || !perf_func) {
> +		ret = -ENODEV;
> +		goto unmap;
> +	}
> +
> +	if (vexpress_spc_populate_opps(0) || vexpress_spc_populate_opps(1)) {
> +		if (info->irq)
> +			free_irq(info->irq, info);
> +		pr_err("failed to build OPP table\n");
> +		ret = -ENODEV;
> +		goto unmap;
> +	}
> +	/*
> +	 * Multi-cluster systems may need this data when non-coherent, during
> +	 * cluster power-up/power-down. Make sure it reaches main memory:
> +	 */
> +	sync_cache_w(info);
> +	sync_cache_w(&info);
> +	pr_info("vexpress-spc loaded at %p\n", info->baseaddr);
> +	return 0;
> +
> +unmap:
> +	iounmap(info->baseaddr);
> +
> +mem_free:
> +	kfree(info);
> +	return ret;
> +}
> +
> +static bool __init __vexpress_spc_check_loaded(void);
> +static bool (*spc_check_loaded)(void) = &__vexpress_spc_check_loaded;
> +
> +static bool __init __vexpress_spc_check_loaded(void)
> +{
> +	if (vexpress_spc_load_result == -EAGAIN)
> +		vexpress_spc_load_result = vexpress_spc_init();
> +	spc_check_loaded = &vexpress_spc_initialized;
> +	return vexpress_spc_initialized();
> +}
> +
> +/*
> + * Function exported to manage early_initcall ordering.
> + * SPC code is needed very early in the boot process
> + * to bring CPUs out of reset and initialize power
> + * management back-end. After boot swap pointers to
> + * make the functionality check available to loadable
> + * modules, when early boot init functions have been
> + * already freed from kernel address space.
> + */
> +bool vexpress_spc_check_loaded(void)
> +{
> +	return spc_check_loaded();
> +}
> +EXPORT_SYMBOL_GPL(vexpress_spc_check_loaded);
> +
> +static int __init vexpress_spc_early_init(void)
> +{
> +	__vexpress_spc_check_loaded();
> +	return vexpress_spc_load_result;
> +}
> +early_initcall(vexpress_spc_early_init);
> +MODULE_LICENSE("GPL");
> +MODULE_DESCRIPTION("Serial Power Controller (SPC) support");
[...]

-- 
Tixy


