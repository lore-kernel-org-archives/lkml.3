Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752239Ab3FJID7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Jun 2013 04:03:59 -0400
Received: from e28smtp06.in.ibm.com ([122.248.162.6]:59374 "EHLO
	e28smtp06.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751824Ab3FJID5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Jun 2013 04:03:57 -0400
Message-ID: <51B58843.5020809@linux.vnet.ibm.com>
Date: Mon, 10 Jun 2013 13:33:15 +0530
From: Anshuman Khandual <khandual@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
CC: mingo@kernel.org, Paul Mackerras <paulus@samba.org>,
        linuxppc-dev@ozlabs.org, Anton Blanchard <anton@au1.ibm.com>,
        linux-kernel@vger.kernel.org, Stephane Eranian <eranian@google.com>
Subject: Re: [PATCH 1/2] perf/Power7: Save dcache_src fields in sample record.
References: <20130607204008.GA3281@us.ibm.com>
In-Reply-To: <20130607204008.GA3281@us.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13061007-9574-0000-0000-00000839EDE8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> 
> AFAICT, Power7 supports one extra level in the cache-hierarchy, so we propose
> to add a new cache level, REM_CCE3 shown above.
> 
> To maintain consistency in terminology (i.e 2-hops = remote, 3-hops = distant),
> I propose leaving the REM_MEM1 unused and adding another level, REM_MEM3.
> 

Agreed.

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

Yeah, the former approach is simpler and makes sense.


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


Where did you define dtlb_src_map[] ?

