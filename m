Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754729Ab3AYJCH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2013 04:02:07 -0500
Received: from mail-ea0-f178.google.com ([209.85.215.178]:41844 "EHLO
	mail-ea0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751519Ab3AYJCD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2013 04:02:03 -0500
Date: Fri, 25 Jan 2013 10:01:58 +0100
From: Ingo Molnar <mingo@kernel.org>
To: Stephane Eranian <eranian@google.com>,
        Michael Ellerman <michael@ellerman.id.au>,
        Paul Mackerras <paulus@samba.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>,
        Maynard Johnson <mpjohn@us.ibm.com>, Anton Blanchard <anton@samba.org>
Cc: linux-kernel@vger.kernel.org, peterz@infradead.org, mingo@elte.hu,
        ak@linux.intel.com, acme@redhat.com, jolsa@redhat.com,
        namhyung.kim@lge.com
Subject: Re: [PATCH v7 07/18] perf: add generic memory sampling interface
Message-ID: <20130125090158.GB31478@gmail.com>
References: <1359040242-8269-1-git-send-email-eranian@google.com>
 <1359040242-8269-8-git-send-email-eranian@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1359040242-8269-8-git-send-email-eranian@google.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Stephane Eranian <eranian@google.com> wrote:

> This patch adds PERF_SAMPLE_DSRC.
> 
> PERF_SAMPLE_DSRC collects the data source, i.e., where
> did the data associated with the sampled instruction
> come from. Information is stored in a perf_mem_dsrc
> structure. It contains opcode, mem level, tlb, snoop,
> lock information, subject to availability in hardware.
> 
> Signed-off-by: Stephane Eranian <eranian@google.com>
> ---
>  include/linux/perf_event.h      |    2 ++
>  include/uapi/linux/perf_event.h |   68 +++++++++++++++++++++++++++++++++++++--
>  kernel/events/core.c            |    6 ++++
>  3 files changed, 74 insertions(+), 2 deletions(-)
> 
> diff --git a/include/linux/perf_event.h b/include/linux/perf_event.h
> index bb2429d..8fe4610 100644
> --- a/include/linux/perf_event.h
> +++ b/include/linux/perf_event.h
> @@ -579,6 +579,7 @@ struct perf_sample_data {
>  		u32	reserved;
>  	}				cpu_entry;
>  	u64				period;
> +	union  perf_mem_dsrc		dsrc;
>  	struct perf_callchain_entry	*callchain;
>  	struct perf_raw_record		*raw;
>  	struct perf_branch_stack	*br_stack;
> @@ -599,6 +600,7 @@ static inline void perf_sample_data_init(struct perf_sample_data *data,
>  	data->regs_user.regs = NULL;
>  	data->stack_user_size = 0;
>  	data->weight = 0;
> +	data->dsrc.val = 0;
>  }
>  
>  extern void perf_output_sample(struct perf_output_handle *handle,
> diff --git a/include/uapi/linux/perf_event.h b/include/uapi/linux/perf_event.h
> index 3e6c394..3e4844c 100644
> --- a/include/uapi/linux/perf_event.h
> +++ b/include/uapi/linux/perf_event.h
> @@ -133,9 +133,9 @@ enum perf_event_sample_format {
>  	PERF_SAMPLE_REGS_USER			= 1U << 12,
>  	PERF_SAMPLE_STACK_USER			= 1U << 13,
>  	PERF_SAMPLE_WEIGHT			= 1U << 14,
> +	PERF_SAMPLE_DSRC			= 1U << 15,
>  
> -	PERF_SAMPLE_MAX = 1U << 15,		/* non-ABI */
> -
> +	PERF_SAMPLE_MAX = 1U << 16,		/* non-ABI */
>  };
>  
>  /*
> @@ -591,6 +591,7 @@ enum perf_event_type {
>  	 * 	  u64			dyn_size; } && PERF_SAMPLE_STACK_USER
>  	 *
>  	 *	{ u64			weight;   } && PERF_SAMPLE_WEIGHT
> +	 *	{ u64			dsrc;     } && PERF_SAMPLE_DSRC
>  	 * };
>  	 */
>  	PERF_RECORD_SAMPLE			= 9,
> @@ -616,4 +617,67 @@ enum perf_callchain_context {
>  #define PERF_FLAG_FD_OUTPUT		(1U << 1)
>  #define PERF_FLAG_PID_CGROUP		(1U << 2) /* pid=cgroup id, per-cpu mode only */
>  
> +union perf_mem_dsrc {
> +	__u64 val;
> +	struct {
> +		__u64   mem_op:5,	/* type of opcode */
> +			mem_lvl:14,	/* memory hierarchy level */
> +			mem_snoop:5,	/* snoop mode */
> +			mem_lock:2,	/* lock instr */
> +			mem_dtlb:7,	/* tlb access */
> +			mem_rsvd:31;
> +	};
> +};
> +
> +/* type of opcode (load/store/prefetch,code) */
> +#define PERF_MEM_OP_NA		0x01 /* not available */
> +#define PERF_MEM_OP_LOAD	0x02 /* load instruction */
> +#define PERF_MEM_OP_STORE	0x04 /* store instruction */
> +#define PERF_MEM_OP_PFETCH	0x08 /* prefetch */
> +#define PERF_MEM_OP_EXEC	0x10 /* code (execution) */
> +#define PERF_MEM_OP_SHIFT	0
> +
> +/* memory hierarchy (memory level, hit or miss) */
> +#define PERF_MEM_LVL_NA		0x01  /* not available */
> +#define PERF_MEM_LVL_HIT	0x02  /* hit level */
> +#define PERF_MEM_LVL_MISS	0x04  /* miss level  */
> +#define PERF_MEM_LVL_L1		0x08  /* L1 */
> +#define PERF_MEM_LVL_LFB	0x10  /* Line Fill Buffer */
> +#define PERF_MEM_LVL_L2		0x20  /* L2 hit */
> +#define PERF_MEM_LVL_L3		0x40  /* L3 hit */
> +#define PERF_MEM_LVL_LOC_RAM	0x80  /* Local DRAM */
> +#define PERF_MEM_LVL_REM_RAM1	0x100 /* Remote DRAM (1 hop) */
> +#define PERF_MEM_LVL_REM_RAM2	0x200 /* Remote DRAM (2 hops) */
> +#define PERF_MEM_LVL_REM_CCE1	0x400 /* Remote Cache (1 hop) */
> +#define PERF_MEM_LVL_REM_CCE2	0x800 /* Remote Cache (2 hops) */
> +#define PERF_MEM_LVL_IO		0x1000 /* I/O memory */
> +#define PERF_MEM_LVL_UNC	0x2000 /* Uncached memory */
> +#define PERF_MEM_LVL_SHIFT	5
> +
> +/* snoop mode */
> +#define PERF_MEM_SNOOP_NA	0x01 /* not available */
> +#define PERF_MEM_SNOOP_NONE	0x02 /* no snoop */
> +#define PERF_MEM_SNOOP_HIT	0x04 /* snoop hit */
> +#define PERF_MEM_SNOOP_MISS	0x08 /* snoop miss */
> +#define PERF_MEM_SNOOP_HITM	0x10 /* snoop hit modified */
> +#define PERF_MEM_SNOOP_SHIFT	19
> +
> +/* locked instruction */
> +#define PERF_MEM_LOCK_NA	0x01 /* not available */
> +#define PERF_MEM_LOCK_LOCKED	0x02 /* locked transaction */
> +#define PERF_MEM_LOCK_SHIFT	24
> +
> +/* TLB access */
> +#define PERF_MEM_TLB_NA		0x01 /* not available */
> +#define PERF_MEM_TLB_HIT	0x02 /* hit level */
> +#define PERF_MEM_TLB_MISS	0x04 /* miss level */
> +#define PERF_MEM_TLB_L1		0x08 /* L1 */
> +#define PERF_MEM_TLB_L2		0x10 /* L2 */
> +#define PERF_MEM_TLB_WK		0x20 /* Hardware Walker*/
> +#define PERF_MEM_TLB_OS		0x40 /* OS fault handler */
> +#define PERF_MEM_TLB_SHIFT	26
> +
> +#define PERF_MEM_S(a, s) \
> +	(((u64)PERF_MEM_##a##_##s) << PERF_MEM_##a##_SHIFT)
> +

Would be nice to get feedback from PowerPC folks to see how well 
this matches their memory profiling hw capabilities?

I suspect there's a lot of differences, but one can always hope 
...

If there's some hope for unification we could at least shape it 
in a way that they could pick up and extend.

Thanks,

	Ingo
