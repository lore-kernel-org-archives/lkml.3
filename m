Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752540AbaI2MQH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Sep 2014 08:16:07 -0400
Received: from mail-wi0-f169.google.com ([209.85.212.169]:41979 "EHLO
	mail-wi0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751403AbaI2MQF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Sep 2014 08:16:05 -0400
Date: Mon, 29 Sep 2014 14:15:59 +0200
From: Ingo Molnar <mingo@kernel.org>
To: "Bryan O'Donoghue" <pure.logic@nexus-software.ie>
Cc: tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com, x86@kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] x86: Quark: Enable correct cache size/type reporting
Message-ID: <20140929121559.GA18328@gmail.com>
References: <1411956372-16469-1-git-send-email-pure.logic@nexus-software.ie>
 <1411956372-16469-2-git-send-email-pure.logic@nexus-software.ie>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1411956372-16469-2-git-send-email-pure.logic@nexus-software.ie>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Bryan O'Donoghue <pure.logic@nexus-software.ie> wrote:

> Quark X1000 lacks cpuid(4). It has cpuid(2) but returns no cache
> descriptors we can work with i.e. cpuid(2) returns
> eax=0x00000001 ebx=0x00000000 ecx=0x00000000 edx=0x00000000
> 
> Quark X1000 contains a 16k 4-way set associative unified L1 cache
> with 256 sets
> 
> This patch emulates cpuid(4) in a similar way to other x86
> processors like AMDs which don't support cpuid(4). The Quark code
> is based on the existing AMD code.
> 
> Signed-off-by: Bryan O'Donoghue <pure.logic@nexus-software.ie>
> ---
>  arch/x86/kernel/cpu/intel_cacheinfo.c | 78 +++++++++++++++++++++++++++++++++--
>  1 file changed, 75 insertions(+), 3 deletions(-)
> 
> diff --git a/arch/x86/kernel/cpu/intel_cacheinfo.c b/arch/x86/kernel/cpu/intel_cacheinfo.c
> index c703507..2bee2c7 100644
> --- a/arch/x86/kernel/cpu/intel_cacheinfo.c
> +++ b/arch/x86/kernel/cpu/intel_cacheinfo.c
> @@ -291,6 +291,70 @@ amd_cpuid4(int leaf, union _cpuid4_leaf_eax *eax,
>  		(ebx->split.ways_of_associativity + 1) - 1;
>  }
>  
> +/*
> + * Emulate cpuid4 behaviour on Intel Quark X1000
> + *
> + * Quark X1000 doesn't support CPUID(4), so this function enumerates
> + * eax, ebx and ecx for cpuid4_cache_lookup_regs
> + *
> + * Documentation states that the X1000 contains a 4-way set associative
> + * 16K cache with a 16 byte cache line and 256 lines per tag
> + *
> + * Data sources:
> + * Intel Processor Identification and the CPUID Instruction App Note 485
> + * Intel Quark SoC X1000 Core Developer's Manual 001
> + *
> + * @leaf:	Cache index
> + * @eax:	Output value for CPUID4 consistent EAX data
> + * @ebx:	Output value for CPUID4 consistent EBX data
> + * @ecx:	Output value for CPUID4 consistent ECX data
> + *
> + * @return: 0 on success, error status on failure
> + */
> +static void
> +intel_quark_emulate_cpuid4(int leaf, union _cpuid4_leaf_eax *eax,
> +				     union _cpuid4_leaf_ebx *ebx,
> +				     union _cpuid4_leaf_ecx *ecx)
> +{
> +	if (leaf > 0) {
> +		eax->split.type = CACHE_TYPE_NULL;
> +		return;
> +	}
> +
> +	/*
> +	 * Emulate CPUID4 : EAX = 0x00000123
> +	 * EAX[31:26]	Num processors = 0. Implicit + 1
> +	 * EAX[25:14]	Num threads sharing this cache = 0. Implicit + 1
> +	 * EAX[13:10]	Reserved
> +	 * EAX[9]	Fully associative cache = 0
> +	 * EAX[8]	Self Initializing cache level = 1
> +	 * EAX[7:5]	Cache Level = 1 - L1 cache
> +	 * EAX[4:0]	Cache Type = 3 - Unified cache
> +	 */
> +	eax->split.num_cores_on_die = 0;
> +	eax->split.num_threads_sharing = 0;
> +	eax->split.is_fully_associative = 0;
> +	eax->split.is_self_initializing = 1;
> +	eax->split.type = CACHE_TYPE_UNIFIED;
> +	eax->split.level = 1;

Such initialization blocks are easier to read if they are 
vertically aligned:

	eax->split.num_cores_on_die		= 0;
	eax->split.num_threads_sharing		= 0;
	eax->split.is_fully_associative		= 0;
	eax->split.is_self_initializing		= 1;
	eax->split.type				= CACHE_TYPE_UNIFIED;
	eax->split.level			= 1;


> +	/*
> +	 * Emulate CPUID4 : EBX = 0x00C0000F
> +	 * EBX[31:22]	Ways of Associativity = 3. Implicit + 1
> +	 * EBX[21:12]	Physical Line partitions = 0. Implicit + 1
> +	 * EBX[11:0]	System Coherency Line Size = 15. Implicit +1
> +	 */
> +	ebx->split.ways_of_associativity = 3;
> +	ebx->split.physical_line_partition = 0;
> +	ebx->split.coherency_line_size = 15;
> +
> +	/*
> +	 * Emulate CPUID4 : ECX 0x000000FF
> +	 * ECX[31:0]	Number of sets = 255. Implicit +1
> +	 */
> +	ecx->split.number_of_sets = 255;
> +}
> +
>  struct _cache_attr {
>  	struct attribute attr;
>  	ssize_t (*show)(struct _cpuid4_info *, char *, unsigned int);
> @@ -543,9 +607,12 @@ cpuid4_cache_lookup_regs(int index, struct _cpuid4_info_regs *this_leaf)
>  			amd_cpuid4(index, &eax, &ebx, &ecx);
>  		amd_init_l3_cache(this_leaf, index);
>  	} else {
> -		cpuid_count(4, index, &eax.full, &ebx.full, &ecx.full, &edx);
> +		if (boot_cpu_data.x86 == 5 && boot_cpu_data.x86_model == 9)
> +			intel_quark_emulate_cpuid4(index, &eax, &ebx, &ecx);
> +		else
> +			cpuid_count(4, index, &eax.full, &ebx.full,
> +				    &ecx.full, &edx);

Please keep it on a single line, don't break it if it makes the 
code worse, even if checkpatch complains.

Also, what happens with edx in the Quark case? It's filled in by 
the real cpuid4 I suppose.

Plus, the '== 5 && == 9' pattern has come up a couple of times 
already, please stick it into a x86_model_quark() helper inline, 
so it becomes self-documenting.

>  	}
> -
>  	if (eax.split.type == CACHE_TYPE_NULL)
>  		return -EIO; /* better error ? */
>  
> @@ -569,13 +636,16 @@ static int find_num_cache_leaves(struct cpuinfo_x86 *c)
>  		op = 0x8000001d;
>  	else
>  		op = 4;
> -
>  	do {

That line removal looks spurious.

>  		++i;
>  		/* Do cpuid(op) loop to find out num_cache_leaves */
>  		cpuid_count(op, i, &eax, &ebx, &ecx, &edx);
>  		cache_eax.full = eax;
>  	} while (cache_eax.split.type != CACHE_TYPE_NULL);
> +
> +	if (c->x86 == 5 && c->x86_model == 9)
> +		i = 1;

This code isn't obvious and isn't explained.

> +
>  	return i;
>  }
>  
> @@ -630,6 +700,8 @@ unsigned int init_intel_cacheinfo(struct cpuinfo_x86 *c)
>  					new_l1d = this_leaf.size/1024;
>  				else if (this_leaf.eax.split.type == CACHE_TYPE_INST)
>  					new_l1i = this_leaf.size/1024;
> +				else if (this_leaf.eax.split.type == CACHE_TYPE_UNIFIED)
> +					new_l1d = new_l1i = this_leaf.size/1024/2;

This too needs a comment I guess - the /2 I suppose comes from 
splitting the size of the unified cache into two?

Thanks,

	Ingo
