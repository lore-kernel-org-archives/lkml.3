Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753658Ab3FFRfi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Jun 2013 13:35:38 -0400
Received: from mail-qc0-f176.google.com ([209.85.216.176]:48327 "EHLO
	mail-qc0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753497Ab3FFRfg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Jun 2013 13:35:36 -0400
Date: Thu, 6 Jun 2013 13:35:31 -0400 (EDT)
From: Nicolas Pitre <nicolas.pitre@linaro.org>
To: James King <james.king@linaro.org>
cc: grant.likely@linaro.org, rob.herring@calxeda.com, rob@landley.net,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        lorenzo.pieralisi@arm.com, vincent.guittot@linaro.org,
        namhyung@kernel.org, a.p.zijlstra@chello.nl,
        devicetree-discuss@lists.ozlabs.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        patches@linaro.org, linaro-kernel@lists.linaro.org
Subject: Re: [PATCH] arm/dt: Don't add disabled CPUs to system topology
In-Reply-To: <1370538685-22386-1-git-send-email-james.king@linaro.org>
Message-ID: <alpine.LFD.2.03.1306061334250.18597@syhkavp.arg>
References: <1370538685-22386-1-git-send-email-james.king@linaro.org>
User-Agent: Alpine 2.03 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 6 Jun 2013, James King wrote:

> If CPUs are marked as disabled in the devicetree, make sure they do
> not exist in the system CPU information and CPU topology information.
> In this case these CPUs will not be able to be added to the system later
> using hot-plug. This allows a single chip with many CPUs to be easily
> used in a variety of hardware devices where they may have different
> actual processing requirements (eg for thermal/cost reasons).
> 
> - Change devicetree.c to ignore any cpu nodes marked as disabled,
>   this effectively limits the number of active cpu cores so no need
>   for the max_cpus=x in the chosen node.
> - Change topology.c to ignore any cpu nodes marked as disabled, this
>   is where the scheduler would learn about big/LITTLE cores so this
>   effectively keeps the scheduler in sync.
> 
> Signed-off-by: James King <james.king@linaro.org>

Acked-by: Nicolas Pitre <nico@linaro.org>


> ---
>  Documentation/devicetree/bindings/arm/cpus.txt | 5 +++++
>  arch/arm/kernel/devtree.c                      | 6 ++++++
>  arch/arm/kernel/topology.c                     | 4 ++++
>  3 files changed, 15 insertions(+)
> 
> diff --git a/Documentation/devicetree/bindings/arm/cpus.txt b/Documentation/devicetree/bindings/arm/cpus.txt
> index f32494d..9fbcbc5 100644
> --- a/Documentation/devicetree/bindings/arm/cpus.txt
> +++ b/Documentation/devicetree/bindings/arm/cpus.txt
> @@ -45,6 +45,10 @@ For the ARM architecture every CPU node must contain the following properties:
>  		"marvell,xsc3"
>  		"marvell,xscale"
>  
> +And optionally set the following properties:
> +
> +- status:	can be set to "disabled" to remove that CPU from the system CPU topology
> +
>  Example:
>  
>  	cpus {
> @@ -73,5 +77,6 @@ Example:
>  			device_type = "cpu";
>  			compatible = "arm,cortex-a7";
>  			reg = <0x101>;
> +			status = "disabled";
>  		};
>  	};
> diff --git a/arch/arm/kernel/devtree.c b/arch/arm/kernel/devtree.c
> index 5af04f6..f4ba8ee 100644
> --- a/arch/arm/kernel/devtree.c
> +++ b/arch/arm/kernel/devtree.c
> @@ -112,6 +112,12 @@ void __init arm_dt_init_cpu_maps(void)
>  			return;
>  
>  		/*
> +		 * Check if the cpu is marked as "disabled", if so ignore.
> +		 */
> +		if (!of_device_is_available(cpu))
> +			continue;
> +
> +		/*
>  		 * Duplicate MPIDRs are a recipe for disaster.
>  		 * Scan all initialized entries and check for
>  		 * duplicates. If any is found just bail out.
> diff --git a/arch/arm/kernel/topology.c b/arch/arm/kernel/topology.c
> index f10316b..90f8fb3 100644
> --- a/arch/arm/kernel/topology.c
> +++ b/arch/arm/kernel/topology.c
> @@ -116,6 +116,10 @@ static void __init parse_dt_topology(void)
>  		if (cpu_eff->compatible == NULL)
>  			continue;
>  
> +		/* Check if the cpu is marked as "disabled", if so ignore. */
> +		if (!of_device_is_available(cn))
> +			continue;
> +
>  		rate = of_get_property(cn, "clock-frequency", &len);
>  		if (!rate || len != 4) {
>  			pr_err("%s missing clock-frequency property\n",
> -- 
> 1.8.1.2
> 
