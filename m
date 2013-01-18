Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754816Ab3ARXGN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jan 2013 18:06:13 -0500
Received: from mga03.intel.com ([143.182.124.21]:21518 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753252Ab3ARXGM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jan 2013 18:06:12 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,495,1355126400"; 
   d="scan'208";a="192803624"
Date: Fri, 18 Jan 2013 15:06:04 -0800
From: Andi Kleen <ak@linux.intel.com>
To: Stephane Eranian <eranian@google.com>
Cc: linux-kernel@vger.kernel.org, peterz@infradead.org, mingo@elte.hu,
        acme@redhat.com, jolsa@redhat.com, namhyung.kim@lge.com
Subject: Re: [PATCH v6 07/18] perf: add generic memory sampling interface
Message-ID: <20130118230604.GJ4051@tassilo.jf.intel.com>
References: <1358264386-24633-1-git-send-email-eranian@google.com>
 <1358264386-24633-8-git-send-email-eranian@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1358264386-24633-8-git-send-email-eranian@google.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>  extern void perf_output_sample(struct perf_output_handle *handle,
> diff --git a/include/uapi/linux/perf_event.h b/include/uapi/linux/perf_event.h
> index 7e24641..8283218 100644
> --- a/include/uapi/linux/perf_event.h
> +++ b/include/uapi/linux/perf_event.h
> @@ -133,9 +133,9 @@ enum perf_event_sample_format {
>  	PERF_SAMPLE_REGS_USER			= 1U << 12,
>  	PERF_SAMPLE_STACK_USER			= 1U << 13,
>  	PERF_SAMPLE_WEIGHT			= 1U << 14,
> +	PERF_SAMPLE_DSRC			= 1U << 15,

This conflicts with similar extensions in the Haswell patchkit,
but that can be worked out by just moving some numbers (and making
sure the input/output calls are still in the right place)


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

Do we really need the shift? it's implicit in the bitfield right?

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

I would leave some free bits here, obviously this doesn't cover all
that may be possible in system architecture. Also why is this a bit mask, 
you can only hit one level right? So perhaps a number.

> +/* TLB access */
> +#define PERF_MEM_TLB_NA		0x01 /* not available */
> +#define PERF_MEM_TLB_HIT	0x02 /* hit level */
> +#define PERF_MEM_TLB_MISS	0x04 /* miss level */
> +#define PERF_MEM_TLB_L1		0x08 /* L1 */
> +#define PERF_MEM_TLB_L2		0x10 /* L2 */
> +#define PERF_MEM_TLB_WK		0x20 /* Hardware Walker*/
> +#define PERF_MEM_TLB_OS		0x40 /* OS fault handler */


Same


> +#define PERF_MEM_TLB_SHIFT	26
> +
> +#define PERF_MEM_S(a, s) \
> +	(((u64)PERF_MEM_##a##_##s) << PERF_MEM_##a##_SHIFT)

Is that used by anything?


-Andi
-- 
ak@linux.intel.com -- Speaking for myself only
