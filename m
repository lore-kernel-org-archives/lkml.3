Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754579Ab3K0SAl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Nov 2013 13:00:41 -0500
Received: from mail-qe0-f42.google.com ([209.85.128.42]:43971 "EHLO
	mail-qe0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752136Ab3K0SAj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Nov 2013 13:00:39 -0500
Date: Wed, 27 Nov 2013 13:00:33 -0500 (EST)
From: Nicolas Pitre <nicolas.pitre@linaro.org>
To: Vyacheslav Tyrtov <v.tyrtov@samsung.com>
cc: linux-kernel@vger.kernel.org, Rob Herring <rob.herring@calxeda.com>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Rob Landley <rob@landley.net>, Kukjin Kim <kgene.kim@samsung.com>,
        Russell King <linux@arm.linux.org.uk>, Ben Dooks <ben-linux@fluff.org>,
        Mike Turquette <mturquette@linaro.org>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>, Heiko Stuebner <heiko@sntech.de>,
        Naour Romain <romain.naour@openwide.fr>, devicetree@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org,
        Tarek Dakhran <t.dakhran@samsung.com>,
        Dave Martin <Dave.Martin@arm.com>, tomasz.figa@gmail.com
Subject: Re: [PATCH v4 4/4] ARM: EXYNOS: add Exynos Dual Cluster Support
In-Reply-To: <1385456288-20398-5-git-send-email-v.tyrtov@samsung.com>
Message-ID: <alpine.LFD.2.10.1311271246010.9667@knanqh.ubzr>
References: <1385456288-20398-1-git-send-email-v.tyrtov@samsung.com> <1385456288-20398-5-git-send-email-v.tyrtov@samsung.com>
User-Agent: Alpine 2.10 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 26 Nov 2013, Vyacheslav Tyrtov wrote:

> From: Tarek Dakhran <t.dakhran@samsung.com>
> 
> Add EDCS(Exynos Dual Cluster Support) for Samsung Exynos5410 SoC.
> This enables all 8 cores, 4 x A7 and 4 x A15 run at the same time.
> 
> Signed-off-by: Tarek Dakhran <t.dakhran@samsung.com>
> Signed-off-by: Vyacheslav Tyrtov <v.tyrtov@samsung.com>

Just some minor comments in addition to those Dave already provided.

[...]
> +/*
> + * Enable cluster-level coherency, in preparation for turning on the MMU.
> + */
> +static void __naked edcs_power_up_setup(unsigned int affinity_level)
> +{
> +	asm volatile ("\n"
> +	"b	cci_enable_port_for_self");
> +}

You should need to turn on the CCI port only for the first CPU to power 
up a cluster.  This is indicated by the affinity level passed into r0.  
See tc2_pm_power_up_setup for example.

> +static int __init edcs_init(void)
> +{
> +	int ret;
> +	struct device_node *node;
> +
> +	node = of_find_compatible_node(NULL, NULL, "samsung,exynos5410");
> +	if (!node)
> +		return -ENODEV;
> +
> +	if (!cci_probed())
> +		return -ENODEV;
> +
> +	/*
> +	 * Future entries into the kernel can now go
> +	 * through the cluster entry vectors.
> +	 */
> +	writel_relaxed(virt_to_phys(mcpm_entry_point), REG_ENTRY_ADDR);
> +
> +	edcs_data_init();
> +	mcpm_smp_set_ops();
> +
> +	ret = mcpm_platform_register(&edcs_power_ops);
> +	if (!ret) {
> +		mcpm_sync_init(edcs_power_up_setup);
> +		pr_info("EDCS power management initialized\n");
> +	}
> +	return ret;
> +}

Here I'd suggest initializing EG_ENTRY_ADDR only after mcpm_sync_init() 
is done.  If ever a secondary CPU, seeing that the address is no longer 
zero, decides to enter the kernel while the state machine is not 
initialized yet, might lead to all sorts of funny behaviors.


Nicolas
