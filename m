Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755583Ab3GQOam (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Jul 2013 10:30:42 -0400
Received: from mail-qe0-f48.google.com ([209.85.128.48]:60884 "EHLO
	mail-qe0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755155Ab3GQOaO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Jul 2013 10:30:14 -0400
Date: Wed, 17 Jul 2013 10:30:10 -0400 (EDT)
From: Nicolas Pitre <nicolas.pitre@linaro.org>
To: Sudeep.KarkadaNagesha@arm.com
cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        cpufreq@vger.kernel.org, linux-pm@vger.kernel.org,
        devicetree-discuss@lists.ozlabs.org,
        Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
        Russell King <linux@arm.linux.org.uk>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Rob Herring <rob.herring@calxeda.com>,
        "Rafael J. Wysocki" <rjw@sisk.pl>,
        Grant Likely <grant.likely@linaro.org>,
        Viresh Kumar <viresh.kumar@linaro.org>
Subject: Re: [RFC PATCH v2 01/15] of: add support for retrieving cpu node
 for a given logical cpu index
In-Reply-To: <1374069984-20567-2-git-send-email-Sudeep.KarkadaNagesha@arm.com>
Message-ID: <alpine.LFD.2.03.1307171023410.14924@syhkavp.arg>
References: <1374069984-20567-1-git-send-email-Sudeep.KarkadaNagesha@arm.com> <1374069984-20567-2-git-send-email-Sudeep.KarkadaNagesha@arm.com>
User-Agent: Alpine 2.03 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 17 Jul 2013, Sudeep.KarkadaNagesha@arm.com wrote:

> From: Sudeep KarkadaNagesha <sudeep.karkadanagesha@arm.com>
> 
> Currently different drivers requiring to access cpu device node are
> parsing the device tree themselves. Since the ordering in the DT need
> not match the logical cpu ordering, the parsing logic needs to consider
> that. However, this has resulted in lots of code duplication and in some
> cases even incorrect logic.
> 
> It's better to consolidate them by adding support for getting cpu
> device node for a given logical cpu index in DT core library. However
> logical to physical index mapping can be architecture specific.
> 
> This patch adds of_get_cpu_node to retrieve a cpu device node for a
> given logical cpu index. The default matching of the physical id to the
> logical cpu index can be overridden by architecture specific code.
> 
> It is recommended to use these helper function only in pre-SMP/early
> initialisation stages to retrieve CPU device node pointers in logical
> ordering. Once the cpu devices are registered, it can be retrieved easily
> from cpu device of_node which avoids unnecessary parsing and matching.
> 
> Cc: Rob Herring <rob.herring@calxeda.com>
> Signed-off-by: Sudeep KarkadaNagesha <sudeep.karkadanagesha@arm.com>
> ---
>  drivers/of/base.c  | 66 ++++++++++++++++++++++++++++++++++++++++++++++++++++++
>  include/linux/of.h |  5 +++++
>  2 files changed, 71 insertions(+)
> 
> diff --git a/drivers/of/base.c b/drivers/of/base.c
> index 5c54279..363b8f9 100644
> --- a/drivers/of/base.c
> +++ b/drivers/of/base.c
> @@ -230,6 +230,72 @@ const void *of_get_property(const struct device_node *np, const char *name,
>  }
>  EXPORT_SYMBOL(of_get_property);
>  
> +/*
> + * arch_match_cpu_phys_id - Match the given logical CPU and physical id
> + *
> + * @cpu: logical index of a cpu
> + * @phys_id: physical identifier of a cpu
> + *
> + * CPU logical to physical index mapping is architecure specific.

Typo.

> + * However this __weak function provides a default match of physical
> + * id to logical cpu index.
> + *
> + * Returns 1 if the physical identifier and the logical index correspond
> + * to the same cpu, 0 otherwise.
> + */
> +int __weak arch_match_cpu_phys_id(int cpu, u64 phys_id)

Please use a bool return type, and use true/false rather than 1/0 in the 
comment.

> +{
> +	return (u32)phys_id == cpu;
> +}
> +
> +/**
> + * of_get_cpu_node - Get device node associated with the given logical CPU
> + *
> + * @cpu: CPU number(logical index) for which device node is required
> + *
> + * The main purpose of this function is to retrieve the device node for the
> + * given logical CPU index. It should be used to intialise the of_node in

Typo.

> + * cpu device. Once of_node in cpu device is populated, all the further
> + * references can use that instead.
> + *
> + * CPU logical to physical index mapping is architecure specific and is built

Typo.

> + * before booting secondary cores. This function uses arch_match_cpu_phys_id
> + * which can be overridden by architecture specific implementation.
> + *
> + * Returns a node pointer for the logical cpu if found, else NULL.
> + */
> +struct device_node *of_get_cpu_node(int cpu)
> +{
> +	struct device_node *cpun, *cpus;
> +	const u32 *cell;
> +	u64 hwid;
> +	int ac, prop_len;
> +
> +	cpus = of_find_node_by_path("/cpus");
> +	if (WARN(!cpus, "Missing cpus node, bailing out\n"))
> +		return NULL;
> +
> +	if (WARN_ON(of_property_read_u32(cpus, "#address-cells", &ac)))
> +		ac = of_n_addr_cells(cpus);
> +
> +	for_each_child_of_node(cpus, cpun) {
> +		if (of_node_cmp(cpun->type, "cpu"))
> +			continue;
> +		cell = of_get_property(cpun, "reg", &prop_len);
> +		if (WARN(!cell, "%s: missing reg property\n", cpun->full_name))
> +			continue;
> +
> +		while (prop_len) {
> +			hwid = of_read_number(cell, ac);
> +			prop_len -= ac;
> +			if (arch_match_cpu_phys_id(cpu, hwid))
> +				return cpun;
> +		}
> +	}
> +
> +	return NULL;
> +}
> +
>  /** Checks if the given "compat" string matches one of the strings in
>   * the device's "compatible" property
>   */
> diff --git a/include/linux/of.h b/include/linux/of.h
> index 1fd08ca..150b48e 100644
> --- a/include/linux/of.h
> +++ b/include/linux/of.h
> @@ -266,6 +266,7 @@ extern int of_device_is_available(const struct device_node *device);
>  extern const void *of_get_property(const struct device_node *node,
>  				const char *name,
>  				int *lenp);
> +extern struct device_node *of_get_cpu_node(int cpu);
>  #define for_each_property_of_node(dn, pp) \
>  	for (pp = dn->properties; pp != NULL; pp = pp->next)
>  
> @@ -458,6 +459,10 @@ static inline const void *of_get_property(const struct device_node *node,
>  {
>  	return NULL;
>  }
> +static inline struct device_node *of_get_cpu_node(int cpu)
> +{
> +	return NULL;
> +}
>  
>  static inline int of_property_read_u64(const struct device_node *np,
>  				       const char *propname, u64 *out_value)
> -- 
> 1.8.1.2
> 
> 
> _______________________________________________
> devicetree-discuss mailing list
> devicetree-discuss@lists.ozlabs.org
> https://lists.ozlabs.org/listinfo/devicetree-discuss
> 
