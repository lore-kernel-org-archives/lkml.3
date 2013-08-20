Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751252Ab3HTMQ6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Aug 2013 08:16:58 -0400
Received: from hydra.sisk.pl ([212.160.235.94]:51320 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750974Ab3HTMQ4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Aug 2013 08:16:56 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Sudeep KarkadaNagesha <Sudeep.KarkadaNagesha@arm.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-pm@vger.kernel.org, devicetree@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org, Viresh Kumar <viresh.kumar@linaro.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Jonas Bonn <jonas@southpole.se>, Michal Simek <monstr@monstr.eu>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <rob.herring@calxeda.com>,
        Sudeep KarkadaNagesha <sudeep.karkadanagesha@arm.com>
Subject: Re: [PATCH v4 03/19] powerpc: refactor of_get_cpu_node to support other architectures
Date: Tue, 20 Aug 2013 14:27:28 +0200
Message-ID: <3703987.W8AZjrDbn0@vostro.rjw.lan>
User-Agent: KMail/4.9.5 (Linux/3.11.0-rc5+; KDE/4.9.5; x86_64; ; )
In-Reply-To: <1376991021-12160-4-git-send-email-Sudeep.KarkadaNagesha@arm.com>
References: <1374492747-13879-1-git-send-email-Sudeep.KarkadaNagesha@arm.com> <1376991021-12160-1-git-send-email-Sudeep.KarkadaNagesha@arm.com> <1376991021-12160-4-git-send-email-Sudeep.KarkadaNagesha@arm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, August 20, 2013 10:30:05 AM Sudeep KarkadaNagesha wrote:
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
> PowerPC has it's own implementation to get the cpu node for a given
> logical index.
> 
> This patch refactors the current implementation of of_get_cpu_node.
> This in preparation to move the implementation to DT core library.
> It separates out the logical to physical mapping so that a default
> matching of the physical id to the logical cpu index can be added
> when moved to common code. Architecture specific code can override it.
> 
> Cc: Rob Herring <rob.herring@calxeda.com>
> Cc: Grant Likely <grant.likely@linaro.org>
> Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
> Signed-off-by: Sudeep KarkadaNagesha <sudeep.karkadanagesha@arm.com>

This needs an ACK from Ben to go anywhere.

Thanks,
Rafael


> ---
>  arch/powerpc/kernel/prom.c | 76 ++++++++++++++++++++++++++++------------------
>  1 file changed, 47 insertions(+), 29 deletions(-)
> 
> diff --git a/arch/powerpc/kernel/prom.c b/arch/powerpc/kernel/prom.c
> index eb23ac9..f7b8c0b 100644
> --- a/arch/powerpc/kernel/prom.c
> +++ b/arch/powerpc/kernel/prom.c
> @@ -865,45 +865,63 @@ static int __init prom_reconfig_setup(void)
>  __initcall(prom_reconfig_setup);
>  #endif
>  
> +bool arch_match_cpu_phys_id(int cpu, u64 phys_id)
> +{
> +	return (int)phys_id == get_hard_smp_processor_id(cpu);
> +}
> +
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
> +		cell += ac;
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
> -		/* Check for ibm,ppc-interrupt-server#s. If it doesn't exist
> -		 * fallback to "reg" property and assume no threads
> +		/* Check for non-standard "ibm,ppc-interrupt-server#s" property
> +		 * for thread ids on PowerPC. If it doesn't exist fallback to
> +		 * standard "reg" property.
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
> 
-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
