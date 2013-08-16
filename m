Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751095Ab3HPEzp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Aug 2013 00:55:45 -0400
Received: from gate.crashing.org ([63.228.1.57]:48832 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751163Ab3HPEzi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Aug 2013 00:55:38 -0400
Message-ID: <1376628563.4255.137.camel@pasglop>
Subject: Re: [RFC PATCH 3/4] powerpc: refactor of_get_cpu_node to support
 other architectures
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Sudeep KarkadaNagesha <Sudeep.KarkadaNagesha@arm.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-pm@vger.kernel.org, devicetree@vger.kernel.org,
        microblaze-uclinux@itee.uq.edu.au, linux@openrisc.net,
        linuxppc-dev@lists.ozlabs.org, Jonas Bonn <jonas@southpole.se>,
        Michal Simek <monstr@monstr.eu>, "Rafael J. Wysocki" <rjw@sisk.pl>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <rob.herring@calxeda.com>
Date: Fri, 16 Aug 2013 14:49:23 +1000
In-Reply-To: <1376586580-5409-4-git-send-email-Sudeep.KarkadaNagesha@arm.com>
References: <1374492747-13879-1-git-send-email-Sudeep.KarkadaNagesha@arm.com>
	 <1376586580-5409-1-git-send-email-Sudeep.KarkadaNagesha@arm.com>
	 <1376586580-5409-4-git-send-email-Sudeep.KarkadaNagesha@arm.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2013-08-15 at 18:09 +0100, Sudeep KarkadaNagesha wrote:
> From: Sudeep KarkadaNagesha <sudeep.karkadanagesha@arm.com>
> 
> Currently different drivers requiring to access cpu device node are
> parsing the device tree themselves. Since the ordering in the DT need
> not match the logical cpu ordering, the parsing logic needs to consider
> that. However, this has resulted in lots of code duplication and in some
> cases even incorrect logic.

 .../...

>  
> +bool arch_match_cpu_phys_id(int cpu, u64 phys_id)
> +{
> +	return (int)phys_id == get_hard_smp_processor_id(cpu);
> +}

Naming is a bit gross. You might want to make it clearer that
we are talking about CPU IDs in the device-tree here.

> +static bool __of_find_n_match_cpu_property(struct device_node *cpun,
> +			const char *prop_name, int cpu, unsigned int *thread)
> +{
> +	const __be32 *cell;
> +	int ac, prop_len, tid;
> +	u64 hwid;
> +
> +	ac = of_n_addr_cells(cpun);
> +	cell = of_get_property(cpun, prop_name, &prop_len);
> +	if (!cell)
> +		return false;
> +	prop_len /= sizeof(*cell);
> +	for (tid = 0; tid < prop_len; tid++) {
> +		hwid = of_read_number(cell, ac);
> +		if (arch_match_cpu_phys_id(cpu, hwid)) {
> +			if (thread)
> +				*thread = tid;
> +			return true;
> +		}

Missing:          cell += ac;

> +	}
> +	return false;
> +}
> +
>  /* Find the device node for a given logical cpu number, also returns the cpu
>   * local thread number (index in ibm,interrupt-server#s) if relevant and
>   * asked for (non NULL)
>   */
>  struct device_node *of_get_cpu_node(int cpu, unsigned int *thread)
>  {
> -	int hardid;
> -	struct device_node *np;
> +	struct device_node *cpun, *cpus;
>  
> -	hardid = get_hard_smp_processor_id(cpu);
> +	cpus = of_find_node_by_path("/cpus");
> +	if (!cpus) {
> +		pr_warn("Missing cpus node, bailing out\n");
> +		return NULL;
> +	}
>  
> -	for_each_node_by_type(np, "cpu") {
> -		const u32 *intserv;
> -		unsigned int plen, t;
> +	for_each_child_of_node(cpus, cpun) {
> +		if (of_node_cmp(cpun->type, "cpu"))
> +			continue;
>  
>  		/* Check for ibm,ppc-interrupt-server#s. If it doesn't exist
>  		 * fallback to "reg" property and assume no threads
>  		 */
> -		intserv = of_get_property(np, "ibm,ppc-interrupt-server#s",
> -				&plen);
> -		if (intserv == NULL) {
> -			const u32 *reg = of_get_property(np, "reg", NULL);
> -			if (reg == NULL)
> -				continue;
> -			if (*reg == hardid) {
> -				if (thread)
> -					*thread = 0;
> -				return np;
> -			}
> -		} else {
> -			plen /= sizeof(u32);
> -			for (t = 0; t < plen; t++) {
> -				if (hardid == intserv[t]) {
> -					if (thread)
> -						*thread = t;
> -					return np;
> -				}
> -			}
> -		}
> +		if (__of_find_n_match_cpu_property(cpun,
> +				"ibm,ppc-interrupt-server#s", cpu, thread))
> +			return cpun;
> +
> +		if (__of_find_n_match_cpu_property(cpun, "reg", cpu, thread))
> +			return cpun;
>  	}
>  	return NULL;
>  }

Cheers,
Ben.


