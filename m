Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752129AbaFJLxs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jun 2014 07:53:48 -0400
Received: from mail-ob0-f178.google.com ([209.85.214.178]:47932 "EHLO
	mail-ob0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751101AbaFJLxq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jun 2014 07:53:46 -0400
MIME-Version: 1.0
In-Reply-To: <20140605082935.GI3213@twins.programming.kicks-ass.net>
References: <1401917658-26065-1-git-send-email-eranian@google.com>
	<1401917658-26065-5-git-send-email-eranian@google.com>
	<20140605082935.GI3213@twins.programming.kicks-ass.net>
Date: Tue, 10 Jun 2014 13:53:45 +0200
Message-ID: <CABPqkBQG=SMvtdvpBMnZx4Etf5rRoy3=K81RLNRcPEgBh7Yqdg@mail.gmail.com>
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

On Thu, Jun 5, 2014 at 10:29 AM, Peter Zijlstra <peterz@infradead.org> wrote:
> On Wed, Jun 04, 2014 at 11:34:13PM +0200, Stephane Eranian wrote:
>> @@ -2020,12 +2050,29 @@ static void intel_pmu_cpu_starting(int cpu)
>>
>>       if (x86_pmu.lbr_sel_map)
>>               cpuc->lbr_sel = &cpuc->shared_regs->regs[EXTRA_REG_LBR];
>> +
>> +     if (x86_pmu.flags & PMU_FL_EXCL_CNTRS) {
>> +             for_each_cpu(i, topology_thread_cpumask(cpu)) {
>> +                     struct intel_excl_cntrs *c;
>> +
>> +                     c = per_cpu(cpu_hw_events, i).excl_cntrs;
>> +                     if (c && c->core_id == core_id) {
>> +                             cpuc->kfree_on_online[1] = cpuc->excl_cntrs;
>> +                             cpuc->excl_cntrs = c;
>> +                             cpuc->excl_thread_id = 1;
>> +                             break;
>> +                     }
>> +             }
>> +             cpuc->excl_cntrs->core_id = core_id;
>> +             cpuc->excl_cntrs->refcnt++;
>> +     }
>>  }
>
> This hard assumes theres only ever 2 threads, which is true and I
> suppose more in arch/x86 will come apart the moment Intel makes a chip
> with more, still, do we have topology_thread_id() or so to cure this?

I assume your comment is relative to kfree_on_online[].
This code is specific to the HT bug, so yes, it assumes 2 threads and that
only one entry of the two excl_cntrs structs needs to be freed.
Doing otherwise, would require a list and will never be used to its full
potential.
