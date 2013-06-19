Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933187Ab3FSEly (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Jun 2013 00:41:54 -0400
Received: from ozlabs.org ([203.10.76.45]:49875 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750884Ab3FSElv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Jun 2013 00:41:51 -0400
From: Michael Neuling <mikey@neuling.org>
To: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
cc: mingo@kernel.org, Paul Mackerras <paulus@samba.org>,
        linuxppc-dev@ozlabs.org, Anton Blanchard <anton@au1.ibm.com>,
        linux-kernel@vger.kernel.org, Stephane Eranian <eranian@google.com>
Subject: Re: [PATCH 1/2] perf/Power7: Save dcache_src fields in sample record.
In-reply-to: <20130607204008.GA3281@us.ibm.com>
References: <20130607204008.GA3281@us.ibm.com>
Comments: In-reply-to Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
   message dated "Fri, 07 Jun 2013 13:40:08 -0700."
X-Mailer: MH-E 8.2; nmh 1.5; GNU Emacs 23.4.1
Date: Wed, 19 Jun 2013 14:41:50 +1000
Message-ID: <23819.1371616910@ale.ozlabs.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Suka,

One of these two patches breaks pmac32_defconfig and I suspect all other
32 bit configs (against mainline)

arch/powerpc/perf/core-book3s.c: In function 'record_and_restart':
arch/powerpc/perf/core-book3s.c:1632:4: error: passing argument 1 of 'ppmu->get_mem_data_src' from incompatible pointer type [-Werror]
arch/powerpc/perf/core-book3s.c:1632:4: note: expected 'struct perf_sample_data *' but argument is of type 'struct perf_sample_data *'

benh is busy enough without this junk.  Please check the simple things
like white space and compile errors!

Mikey

Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com> wrote:
> From: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
> Date: Wed, 8 May 2013 22:59:29 -0700
> Subject: [PATCH 1/2] perf/Power7: Save dcache_src fields in sample record.
> 
> Power7 saves the "perf-event vector" information in the mmcra register.
> Included in this event vector is a "data-cache source" field which
> identifies where in the memory-hierarchy the data for an instruction
> was found.
> 
> Use the 'struct perf_mem_data_source' to export the "data-cache source"
> field to user space.
> 
> The mapping between the Power7 hierarchy levels and the arch-neutral
> levels is, unfortunately, not trivial.
> 
> 	Arch-neutral levels     Power7 levels
> 	---------------------------------------------------------
> 	local 	LVL_L2		local (same core) L2 (FROM_L2)
> 	local 	LVL_L3		local (same core) L3 (FROM_L3)
> 
> 	1-hop	REM_CCE1	different core on same chip (FROM_L2.1, _L3.1)
> 	2-hops	REM_CCE2	remote (different chip, same node) (FROM_RL2L3)
> 	3-hops	REM_CCE3*	distant (different node)  (FROM_DL2L3)
> 
> 	1-hop   REM_MEM1	unused
> 	2-hops 	REM_MEM2	remote (different chip, same node) (FROM_RMEM)
> 	3-hops 	REM_MEM3*	distant (different node) (FROM_DMEM)
> 
> * proposed "extended" levels.
> 
> AFAICT, Power7 supports one extra level in the cache-hierarchy, so we propose
> to add a new cache level, REM_CCE3 shown above.
> 
> To maintain consistency in terminology (i.e 2-hops = remote, 3-hops = distant),
> I propose leaving the REM_MEM1 unused and adding another level, REM_MEM3.
> 
> Further, in the above REM_CCE1 case, Power7 can also identify if the data came
> from the L2 or L3 cache of another core on the same chip. To describe this to
> user space, we propose to set ->mem_lvl to:
> 
> 	PERF_MEM_LVL_REM_CCE1|PERF_MEM_LVL_L2
> 
> 	PERF_MEM_LVL_REM_CCE1|PERF_MEM_LVL_L3
> 
> Either that or we could leave REM_CCE1 unused in Power and add two more levels:
> 
> 	PERF_MEM_XLVL_REM_L2_CCE1
> 	PERF_MEM_XLVL_REM_L3_CCE1
> 
> The former approach seems less confusing and this patch uses that approach.
> 
> Signed-off-by: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
> ---
>  arch/powerpc/include/asm/perf_event_server.h |    2 +
>  arch/powerpc/perf/core-book3s.c              |    4 +
>  arch/powerpc/perf/power7-pmu.c               |   81 ++++++++++++++++++++++++++
>  include/uapi/linux/perf_event.h              |   12 +++-
>  4 files changed, 97 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/powerpc/include/asm/perf_event_server.h b/arch/powerpc/include/asm/perf_event_server.h
> index f265049..f2d162b 100644
> --- a/arch/powerpc/include/asm/perf_event_server.h
> +++ b/arch/powerpc/include/asm/perf_event_server.h
> @@ -37,6 +37,8 @@ struct power_pmu {
>  	void            (*config_bhrb)(u64 pmu_bhrb_filter);
>  	void		(*disable_pmc)(unsigned int pmc, unsigned long mmcr[]);
>  	int		(*limited_pmc_event)(u64 event_id);
> +	void		(*get_mem_data_src)(struct perf_sample_data *data,
> +				struct pt_regs *regs);
>  	u32		flags;
>  	const struct attribute_group	**attr_groups;
>  	int		n_generic;
> diff --git a/arch/powerpc/perf/core-book3s.c b/arch/powerpc/perf/core-book3s.c
> index 426180b..7778fa9 100644
> --- a/arch/powerpc/perf/core-book3s.c
> +++ b/arch/powerpc/perf/core-book3s.c
> @@ -1632,6 +1632,10 @@ static void record_and_restart(struct perf_event *event, unsigned long val,
>  			data.br_stack = &cpuhw->bhrb_stack;
>  		}
>  
> +		if (event->attr.sample_type & PERF_SAMPLE_DATA_SRC &&
> +						ppmu->get_mem_data_src)
> +			ppmu->get_mem_data_src(&data, regs);
> +
>  		if (perf_event_overflow(event, &data, regs))
>  			power_pmu_stop(event, 0);
>  	}
> diff --git a/arch/powerpc/perf/power7-pmu.c b/arch/powerpc/perf/power7-pmu.c
> index 3c475d6..af92bfe 100644
> --- a/arch/powerpc/perf/power7-pmu.c
> +++ b/arch/powerpc/perf/power7-pmu.c
> @@ -209,6 +209,85 @@ static int power7_get_alternatives(u64 event, unsigned int flags, u64 alt[])
>  	return nalt;
>  }
>  
> +#define	POWER7_MMCRA_PEMPTY		(0x1L << 63)
> +#define	POWER7_MMCRA_FIN_STALL		(0x1L << 62)
> +#define	POWER7_MMCRA_CMPL_STALL		(0x1L << 61)
> +#define	POWER7_MMCRA_STALL_REASON_MASK	(0xFL << 60)
> +
> +#define	POWER7_MMCRA_DCACHE_MISS	(0x1L << 55)
> +
> +#define	POWER7_MMCRA_DCACHE_SRC_SHIFT	51
> +#define	POWER7_MMCRA_DCACHE_SRC_MASK	(0xFL << POWER7_MMCRA_DCACHE_SRC_SHIFT)
> +
> +#define	POWER7_MMCRA_MDTLB_MISS		(0x1L << 50)
> +
> +#define	POWER7_MMCRA_MDTLB_SRC_SHIFT	46
> +#define	POWER7_MMCRA_MDTLB_SRC_MASK	(0xFL << POWER7_MMCRA_MDTLB_SRC_SHIFT)
> +
> +#define	POWER7_MMCRA_MDERAT_MISS	(0x1L<< 45)
> +#define	POWER7_MMCRA_MLSU_REJ		(0x1L<< 44)
> +
> +/* and so on */
> +
> +/*
> + * Map DCACHE_SRC fields to the Linux memory hierarchy levels.
> + *
> + * Bits 9..12 in the MMCRA indicate the source of a data-cache entry, with
> + * each of the 16 possible values referring to a specific source. Eg: if
> + * the 4-bits have the value 1 (0b0001), the dcache entry was found local
> + * L3 cache.
> + *
> + * We use the table, dcache_src_map, to map this value 1 to PERF_MEM_LVL_L3,
> + * the arch-neutral representation of the L3 cache.
> + *
> + * Similarly, in case of marked data TLB miss, bits 14..17 of the MMCRA
> + * indicate the load source of a marked DTLB  entry. dtlb_src_map[] gives
> + * the mapping to the arch-neutral values of the TLB source.
> + *
> + * Architecture neutral to Power7 hierarchy levels:
> + * 	1-hop  = different core on same chip (L2.1 or L3.1)
> + * 	2-hops = remote (different chip on same node)
> + *	3-hops = distant (different node)
> + */
> +static u64 dcache_src_map[] = {
> +	PERF_MEM_S(LVL, L2),			 /* 00: FROM_L2 */
> +	PERF_MEM_S(LVL, L3),			 /* 01: FROM_L3 */
> +	PERF_MEM_S(LVL, NA),			 /* 02: Reserved */
> +	PERF_MEM_S(LVL, NA),			 /* 03: Reserved */
> +
> +	PERF_MEM_LVL_L2|PERF_MEM_LVL_REM_CCE1,   /* 04: FROM_L2.1_SHR */
> +	PERF_MEM_LVL_L2|PERF_MEM_LVL_REM_CCE1,   /* 05: FROM_L3.1_MOD */
> +	PERF_MEM_LVL_L3|PERF_MEM_LVL_REM_CCE1,   /* 06: FROM_L2.1_SHR */
> +	PERF_MEM_LVL_L3|PERF_MEM_LVL_REM_CCE1,   /* 07: FROM_L3.1_MOD */
> +
> +	PERF_MEM_S(LVL, REM_CCE2),		 /* 08: FROM_RL2L3_SHR */
> +	PERF_MEM_S(LVL, REM_CCE2),		 /* 09: FROM_RL2L3_MOD */
> +	PERF_MEM_S(XLVL, REM_CCE3),		 /* 10: FROM_DL2L3_SHR */
> +	PERF_MEM_S(XLVL, REM_CCE3),		 /* 11: FROM_DL2L3_MOD */
> +
> +	PERF_MEM_S(LVL, LOC_RAM),		 /* 12: FROM_LMEM */
> +	PERF_MEM_S(LVL, REM_RAM2),		 /* 13: FROM_RMEM */
> +	PERF_MEM_S(XLVL, REM_RAM3),		 /* 14: FROM_DMEM */
> +
> +	PERF_MEM_S(LVL, NA),			 /* 15: Reserved */
> +};
> +
> +
> +static void power7_get_mem_data_src(struct perf_sample_data *data,
> +				struct pt_regs *regs)
> +{
> +	unsigned long idx;
> +	unsigned long mmcra = regs->dsisr;
> +	union perf_mem_data_src *dsrc = &data->data_src;
> +
> +	if (mmcra & POWER7_MMCRA_DCACHE_MISS) {
> +		idx = mmcra & POWER7_MMCRA_DCACHE_SRC_MASK;
> +		idx >>= POWER7_MMCRA_DCACHE_SRC_SHIFT;
> +
> +		dsrc->val |= dcache_src_map[idx];
> +	}
> +}
> +
>  /*
>   * Returns 1 if event counts things relating to marked instructions
>   * and thus needs the MMCRA_SAMPLE_ENABLE bit set, or 0 if not.
> @@ -438,6 +517,7 @@ static const struct attribute_group *power7_pmu_attr_groups[] = {
>  	NULL,
>  };
>  
> +
>  static struct power_pmu power7_pmu = {
>  	.name			= "POWER7",
>  	.n_counter		= 6,
> @@ -447,6 +527,7 @@ static struct power_pmu power7_pmu = {
>  	.compute_mmcr		= power7_compute_mmcr,
>  	.get_constraint		= power7_get_constraint,
>  	.get_alternatives	= power7_get_alternatives,
> +	.get_mem_data_src	= power7_get_mem_data_src,
>  	.disable_pmc		= power7_disable_pmc,
>  	.flags			= PPMU_ALT_SIPR,
>  	.attr_groups		= power7_pmu_attr_groups,
> diff --git a/include/uapi/linux/perf_event.h b/include/uapi/linux/perf_event.h
> index fb104e5..f8d3269 100644
> --- a/include/uapi/linux/perf_event.h
> +++ b/include/uapi/linux/perf_event.h
> @@ -627,7 +627,8 @@ union perf_mem_data_src {
>  			mem_snoop:5,	/* snoop mode */
>  			mem_lock:2,	/* lock instr */
>  			mem_dtlb:7,	/* tlb access */
> -			mem_rsvd:31;
> +			mem_xlvl:2,     /* extended memory levels */
> +			mem_rsvd:29;
>  	};
>  };
>  
> @@ -654,7 +655,7 @@ union perf_mem_data_src {
>  #define PERF_MEM_LVL_REM_CCE2	0x800 /* Remote Cache (2 hops) */
>  #define PERF_MEM_LVL_IO		0x1000 /* I/O memory */
>  #define PERF_MEM_LVL_UNC	0x2000 /* Uncached memory */
> -#define PERF_MEM_LVL_SHIFT	5
> +#define PERF_MEM_LVL_SHIFT	5      /* see also extended levels below */
>  
>  /* snoop mode */
>  #define PERF_MEM_SNOOP_NA	0x01 /* not available */
> @@ -679,6 +680,13 @@ union perf_mem_data_src {
>  #define PERF_MEM_TLB_OS		0x40 /* OS fault handler */
>  #define PERF_MEM_TLB_SHIFT	26
>  
> +#define PERF_MEM_XLVL_REM_RAM3	0x01 /* Remote memory (3 hops) */
> +#define PERF_MEM_XLVL_REM_CCE3	0x02 /* Remote cache (3 hops) */
> +#define PERF_MEM_XLVL_SHIFT	33
> +
> +/* Miscellaneous flags */
> +#define PERF_MEM_MISC_CCE_MOD	0x4000 /* cache-hit, but entry was modified */
> +
>  #define PERF_MEM_S(a, s) \
>  	(((u64)PERF_MEM_##a##_##s) << PERF_MEM_##a##_SHIFT)
>  
> -- 
> 1.7.1
> 
> _______________________________________________
> Linuxppc-dev mailing list
> Linuxppc-dev@lists.ozlabs.org
> https://lists.ozlabs.org/listinfo/linuxppc-dev
> 
