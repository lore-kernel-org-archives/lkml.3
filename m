Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752290AbaKQLQ2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Nov 2014 06:16:28 -0500
Received: from foss-mx-na.foss.arm.com ([217.140.108.86]:59160 "EHLO
	foss-mx-na.foss.arm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751057AbaKQLQ1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Nov 2014 06:16:27 -0500
Date: Mon, 17 Nov 2014 11:16:25 +0000
From: Will Deacon <will.deacon@arm.com>
To: Mark Rutland <mark.rutland@arm.com>
Cc: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "grant.likely@linaro.org" <grant.likely@linaro.org>,
        Rob Herring <rob.herring@kernel.org>
Subject: Re: [PATCH 08/11] arm: perf: add functions to parse affinity from dt
Message-ID: <20141117111625.GE18061@arm.com>
References: <1415377536-12841-1-git-send-email-mark.rutland@arm.com>
 <1415377536-12841-9-git-send-email-mark.rutland@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1415377536-12841-9-git-send-email-mark.rutland@arm.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 07, 2014 at 04:25:33PM +0000, Mark Rutland wrote:
> Depending on hardware configuration, some devices may only be accessible
> from certain CPUs, may have interrupts wired up to a subset of CPUs, or
> may have operations which affect subsets of CPUs. To handle these
> devices it is necessary to describe this affinity information in
> devicetree.
> 
> This patch adds functions to handle parsing the CPU affinity of
> properties from devicetree, based on Lorenzo's topology binding,
> allowing subsets of CPUs to be associated with interrupts, hardware
> ports, etc. The functions can be used to build cpumasks and also to test
> whether an affinity property only targets one CPU independent of the
> current configuration (e.g. when the kernel supports fewer CPUs than are
> physically present). This is useful for dealing with mixed SPI/PPI
> devices.
> 
> A device may have an arbitrary number of affinity properties, the
> meaning of which is device-specific and should be specified in a given
> device's binding document.
> 
> For example, an affinity property describing interrupt routing may
> consist of a phandle pointing to a subtree of the topology nodes,
> indicating the set of CPUs an interrupt originates from or may be taken
> on. Bindings may have restrictions on the topology nodes referenced -
> for describing coherency controls an affinity property may indicate a
> whole cluster (including any non-CPU logic it contains) is affected by
> some configuration.
> 
> Signed-off-by: Mark Rutland <mark.rutland@arm.com>
> Cc: Grant Likely <grant.likely@linaro.org>
> Cc: Rob Herring <rob.herring@kernel.org>
> ---
>  arch/arm/kernel/perf_event_cpu.c | 127 +++++++++++++++++++++++++++++++++++++++
>  1 file changed, 127 insertions(+)
> 
> diff --git a/arch/arm/kernel/perf_event_cpu.c b/arch/arm/kernel/perf_event_cpu.c
> index ce35149..dfcaba5 100644
> --- a/arch/arm/kernel/perf_event_cpu.c
> +++ b/arch/arm/kernel/perf_event_cpu.c
> @@ -22,6 +22,7 @@
>  #include <linux/export.h>
>  #include <linux/kernel.h>
>  #include <linux/of.h>
> +#include <linux/of_device.h>
>  #include <linux/platform_device.h>
>  #include <linux/slab.h>
>  #include <linux/spinlock.h>
> @@ -294,6 +295,132 @@ static int probe_current_pmu(struct arm_pmu *pmu)
>  	return ret;
>  }
>  
> +/*
> + * Test if the node is within the topology tree.
> + * Walk up to the root, keeping refcounts balanced.
> + */
> +static bool is_topology_node(struct device_node *node)
> +{
> +	struct device_node *np, *cpu_map;
> +	bool ret = false;
> +
> +	cpu_map = of_find_node_by_path("/cpus/cpu-map");
> +	if (!cpu_map)
> +		return false;
> +
> +	/*
> +	 * of_get_next_parent decrements the refcount of the provided node.
> +	 * Increment it first to keep things balanced.
> +	 */
> +	for (np = of_node_get(node); np; np = of_get_next_parent(np)) {
> +		if (np != cpu_map)
> +			continue;
> +
> +		ret = true;
> +		break;
> +	}
> +
> +	of_node_put(np);
> +	of_node_put(cpu_map);
> +	return ret;
> +}

Wouldn't this be more at home in topology.c, or somewhere where others can
make use of it?

Will
