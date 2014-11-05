Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755305AbaKEQXG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Nov 2014 11:23:06 -0500
Received: from mga11.intel.com ([192.55.52.93]:52778 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754655AbaKEQXF convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Nov 2014 11:23:05 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,862,1389772800"; 
   d="scan'208";a="411894229"
From: "Liang, Kan" <kan.liang@intel.com>
To: Peter Zijlstra <peterz@infradead.org>
CC: "eranian@google.com" <eranian@google.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "paulus@samba.org" <paulus@samba.org>,
        "acme@kernel.org" <acme@kernel.org>,
        "jolsa@redhat.com" <jolsa@redhat.com>,
        "ak@linux.intel.com" <ak@linux.intel.com>
Subject: RE: [PATCH V7 00/17] perf, x86: Haswell LBR call stack support
Thread-Topic: [PATCH V7 00/17] perf, x86: Haswell LBR call stack support
Thread-Index: AQHP+KX2mQc4+JvE8EymwJ/+bhfdO5xRQPaAgADzn3A=
Date: Wed, 5 Nov 2014 16:22:09 +0000
Message-ID: <37D7C6CF3E00A74B8858931C1DB2F0770165410A@SHSMSX103.ccr.corp.intel.com>
References: <1415156173-10035-1-git-send-email-kan.liang@intel.com>
 <20141105093759.GQ10501@worktop.programming.kicks-ass.net>
In-Reply-To: <20141105093759.GQ10501@worktop.programming.kicks-ass.net>
Accept-Language: zh-CN, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.239.127.40]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


>> 
> 
> So if I take all except 11,13,16,17 but instead do something like the below,
> everything will work just fine, right?
> 
> Or am I missing something?
> 

Yes, it should work.  Then LBR callstack will rely on user to enable it.
But user never get the LBR callstack data if it's available.  
I'm not sure why you do that? 


> ---
>  arch/x86/kernel/cpu/perf_event.h           |    8 --------
>  arch/x86/kernel/cpu/perf_event_intel_lbr.c |    8 ++++----
>  include/uapi/linux/perf_event.h            |   16 ++++++++--------
>  3 files changed, 12 insertions(+), 20 deletions(-)
> 
> --- a/arch/x86/kernel/cpu/perf_event.h
> +++ b/arch/x86/kernel/cpu/perf_event.h
> @@ -521,14 +521,6 @@ struct x86_perf_task_context {
>  	int lbr_stack_state;
>  };
> 
> -enum {
> -	PERF_SAMPLE_BRANCH_CALL_STACK_SHIFT =
> PERF_SAMPLE_BRANCH_MAX_SHIFT,
> -	PERF_SAMPLE_BRANCH_SELECT_MAP_SIZE,
> -
> -	PERF_SAMPLE_BRANCH_CALL_STACK =
> -				1U <<
> PERF_SAMPLE_BRANCH_CALL_STACK_SHIFT,
> -};
> -
>  #define x86_add_quirk(func_)						\
>  do {									\
>  	static struct x86_pmu_quirk __quirk __initdata = {		\
> --- a/arch/x86/kernel/cpu/perf_event_intel_lbr.c
> +++ b/arch/x86/kernel/cpu/perf_event_intel_lbr.c
> @@ -537,7 +537,7 @@ static int intel_pmu_setup_hw_lbr_filter
>  	u64 mask = 0, v;
>  	int i;
> 
> -	for (i = 0; i < PERF_SAMPLE_BRANCH_SELECT_MAP_SIZE; i++) {
> +	for (i = 0; i < PERF_SAMPLE_BRANCH_MAX_SHIFT; i++) {
>  		if (!(br_type & (1ULL << i)))
>  			continue;
> 
> @@ -808,7 +808,7 @@ intel_pmu_lbr_filter(struct cpu_hw_event
>  /*
>   * Map interface branch filters onto LBR filters
>   */
> -static const int
> nhm_lbr_sel_map[PERF_SAMPLE_BRANCH_SELECT_MAP_SIZE] = {
> +static const int nhm_lbr_sel_map[PERF_SAMPLE_BRANCH_MAX_SHIFT]
> = {
>  	[PERF_SAMPLE_BRANCH_ANY_SHIFT]		= LBR_ANY,
>  	[PERF_SAMPLE_BRANCH_USER_SHIFT]		= LBR_USER,
>  	[PERF_SAMPLE_BRANCH_KERNEL_SHIFT]	= LBR_KERNEL,
> @@ -827,7 +827,7 @@ static const int nhm_lbr_sel_map[PERF_SA
>  	[PERF_SAMPLE_BRANCH_COND_SHIFT]     = LBR_JCC,
>  };
> 
> -static const int
> snb_lbr_sel_map[PERF_SAMPLE_BRANCH_SELECT_MAP_SIZE] = {
> +static const int snb_lbr_sel_map[PERF_SAMPLE_BRANCH_MAX_SHIFT] =
> {
>  	[PERF_SAMPLE_BRANCH_ANY_SHIFT]		= LBR_ANY,
>  	[PERF_SAMPLE_BRANCH_USER_SHIFT]		= LBR_USER,
>  	[PERF_SAMPLE_BRANCH_KERNEL_SHIFT]	= LBR_KERNEL,
> @@ -839,7 +839,7 @@ static const int snb_lbr_sel_map[PERF_SA
>  	[PERF_SAMPLE_BRANCH_COND_SHIFT]		= LBR_JCC,
>  };
> 
> -static const int
> hsw_lbr_sel_map[PERF_SAMPLE_BRANCH_SELECT_MAP_SIZE] = {
> +static const int hsw_lbr_sel_map[PERF_SAMPLE_BRANCH_MAX_SHIFT] =
> {
>  	[PERF_SAMPLE_BRANCH_ANY_SHIFT]		= LBR_ANY,
>  	[PERF_SAMPLE_BRANCH_USER_SHIFT]		= LBR_USER,
>  	[PERF_SAMPLE_BRANCH_KERNEL_SHIFT]	= LBR_KERNEL,
> --- a/include/uapi/linux/perf_event.h
> +++ b/include/uapi/linux/perf_event.h
> @@ -166,6 +166,8 @@ enum perf_branch_sample_type_shift {
>  	PERF_SAMPLE_BRANCH_NO_TX_SHIFT		= 9, /* not
> in transaction */
>  	PERF_SAMPLE_BRANCH_COND_SHIFT		= 10, /* conditional
> branches */
> 
> +	PERF_SAMPLE_BRANCH_CALL_STACK_SHIFT	= 11, /* call/ret
> stack */
> +
>  	PERF_SAMPLE_BRANCH_MAX_SHIFT		/* non-ABI */
>  };
> 
> @@ -175,18 +177,16 @@ enum perf_branch_sample_type {
>  	PERF_SAMPLE_BRANCH_HV		= 1U <<
> PERF_SAMPLE_BRANCH_HV_SHIFT,
> 
>  	PERF_SAMPLE_BRANCH_ANY		= 1U <<
> PERF_SAMPLE_BRANCH_ANY_SHIFT,
> -	PERF_SAMPLE_BRANCH_ANY_CALL	=
> -				1U <<
> PERF_SAMPLE_BRANCH_ANY_CALL_SHIFT,
> -	PERF_SAMPLE_BRANCH_ANY_RETURN	=
> -				1U <<
> PERF_SAMPLE_BRANCH_ANY_RETURN_SHIFT,
> -	PERF_SAMPLE_BRANCH_IND_CALL	=
> -				1U <<
> PERF_SAMPLE_BRANCH_IND_CALL_SHIFT,
> -	PERF_SAMPLE_BRANCH_ABORT_TX	=
> -				1U <<
> PERF_SAMPLE_BRANCH_ABORT_TX_SHIFT,
> +	PERF_SAMPLE_BRANCH_ANY_CALL	= 1U <<
> PERF_SAMPLE_BRANCH_ANY_CALL_SHIFT,
> +	PERF_SAMPLE_BRANCH_ANY_RETURN	= 1U <<
> PERF_SAMPLE_BRANCH_ANY_RETURN_SHIFT,
> +	PERF_SAMPLE_BRANCH_IND_CALL	= 1U <<
> PERF_SAMPLE_BRANCH_IND_CALL_SHIFT,
> +	PERF_SAMPLE_BRANCH_ABORT_TX	= 1U <<
> PERF_SAMPLE_BRANCH_ABORT_TX_SHIFT,
>  	PERF_SAMPLE_BRANCH_IN_TX	= 1U <<
> PERF_SAMPLE_BRANCH_IN_TX_SHIFT,
>  	PERF_SAMPLE_BRANCH_NO_TX	= 1U <<
> PERF_SAMPLE_BRANCH_NO_TX_SHIFT,
>  	PERF_SAMPLE_BRANCH_COND		= 1U <<
> PERF_SAMPLE_BRANCH_COND_SHIFT,
> 
> +	PERF_SAMPLE_BRANCH_CALL_STACK	= 1U <<
> PERF_SAMPLE_BRANCH_CALL_STACK_SHIFT,
> +
>  	PERF_SAMPLE_BRANCH_MAX		= 1U <<
> PERF_SAMPLE_BRANCH_MAX_SHIFT,
>  };
> 
