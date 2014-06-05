Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751735AbaFEKvi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jun 2014 06:51:38 -0400
Received: from mail-ob0-f180.google.com ([209.85.214.180]:36649 "EHLO
	mail-ob0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751569AbaFEKvf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jun 2014 06:51:35 -0400
MIME-Version: 1.0
In-Reply-To: <20140605074753.GG3213@twins.programming.kicks-ass.net>
References: <1401917658-26065-1-git-send-email-eranian@google.com>
	<1401917658-26065-5-git-send-email-eranian@google.com>
	<20140605074753.GG3213@twins.programming.kicks-ass.net>
Date: Thu, 5 Jun 2014 12:51:35 +0200
Message-ID: <CABPqkBR=+xf-yT7+ouNzVp_TdBYpjeNYpCYc+H7fOMFxPuzyog@mail.gmail.com>
Subject: Re: [PATCH 4/9] perf/x86: add cross-HT counter exclusion infrastructure
From: Stephane Eranian <eranian@google.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: LKML <linux-kernel@vger.kernel.org>, "mingo@elte.hu" <mingo@elte.hu>,
        "ak@linux.intel.com" <ak@linux.intel.com>,
        Jiri Olsa <jolsa@redhat.com>, "Yan, Zheng" <zheng.z.yan@intel.com>,
        Maria Dimakopoulou <maria.n.dimakopoulou@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 5, 2014 at 9:47 AM, Peter Zijlstra <peterz@infradead.org> wrote:
> On Wed, Jun 04, 2014 at 11:34:13PM +0200, Stephane Eranian wrote:
>> From: Maria Dimakopoulou <maria.n.dimakopoulou@gmail.com>
>>
>> This patch adds a new shared_regs style structure to the
>> per-cpu x86 state (cpuc). It is used to coordinate access
>> between counters which must be used with exclusion across
>> HyperThreads on Intel processors. This new struct is not
>> needed on each PMU, thus is is allocated on demand.
>>
>> Reviewed-by: Stephane Eranian <eranian@google.com>
>> Signed-off-by: Maria Dimakopoulou <maria.n.dimakopoulou@gmail.com>
>> ---
>>  arch/x86/kernel/cpu/perf_event.h       |   40 ++++++++++++++++++--
>>  arch/x86/kernel/cpu/perf_event_intel.c |   63 +++++++++++++++++++++++++++++---
>>  2 files changed, 94 insertions(+), 9 deletions(-)
>>
>> diff --git a/arch/x86/kernel/cpu/perf_event.h b/arch/x86/kernel/cpu/perf_event.h
>> index 413799f..5da0a2b 100644
>> --- a/arch/x86/kernel/cpu/perf_event.h
>> +++ b/arch/x86/kernel/cpu/perf_event.h
>> @@ -65,10 +65,11 @@ struct event_constraint {
>>  /*
>>   * struct hw_perf_event.flags flags
>>   */
>> -#define PERF_X86_EVENT_PEBS_LDLAT    0x1 /* ld+ldlat data address sampling */
>> -#define PERF_X86_EVENT_PEBS_ST               0x2 /* st data address sampling */
>> -#define PERF_X86_EVENT_PEBS_ST_HSW   0x4 /* haswell style st data sampling */
>> -#define PERF_X86_EVENT_COMMITTED     0x8 /* event passed commit_txn */
>> +#define PERF_X86_EVENT_PEBS_LDLAT    0x01 /* ld+ldlat data address sampling */
>> +#define PERF_X86_EVENT_PEBS_ST               0x02 /* st data address sampling */
>> +#define PERF_X86_EVENT_PEBS_ST_HSW   0x04 /* haswell style st data sampling */
>> +#define PERF_X86_EVENT_COMMITTED     0x08 /* event passed commit_txn */
>> +#define PERF_X86_EVENT_EXCL          0x10 /* HT exclusivity on counter */
>>
>>  struct amd_nb {
>>       int nb_id;  /* NorthBridge id */
>> @@ -119,6 +120,27 @@ struct intel_shared_regs {
>>       unsigned                core_id;        /* per-core: core id */
>>  };
>>
>> +enum intel_excl_state_type {
>> +     INTEL_EXCL_UNUSED    = 0, /* counter is unused */
>> +     INTEL_EXCL_SHARED    = 1, /* counter can be used by both threads */
>> +     INTEL_EXCL_EXCLUSIVE = 2, /* counter can be used by one thread only */
>> +};
>> +
>> +struct intel_excl_states {
>> +     enum intel_excl_state_type init_state[X86_PMC_IDX_MAX];
>> +     enum intel_excl_state_type state[X86_PMC_IDX_MAX];
>> +};
>> +
>> +struct intel_excl_cntrs {
>> +     spinlock_t      lock;
>> +     unsigned long   lock_flags;
>> +
>> +     struct intel_excl_states states[2];
>> +
>> +     int             refcnt;         /* per-core: #HT threads */
>> +     unsigned        core_id;        /* per-core: core id */
>> +};
>
> This must be a raw_spin_lock_t, its taken from pmu::add() which is
> called under perf_event_context::lock, which is raw_spinlock_t, as its
> taken under rq::lock, which too is raw_spinlock_t.
>
Will fix this in V2.

> I should really get around to fixing these errors and include the
> lockdep infrastructure for this.
