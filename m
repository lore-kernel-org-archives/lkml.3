Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753995Ab3EFKeT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 May 2013 06:34:19 -0400
Received: from mail-lb0-f180.google.com ([209.85.217.180]:41641 "EHLO
	mail-lb0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753767Ab3EFKeR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 May 2013 06:34:17 -0400
MIME-Version: 1.0
In-Reply-To: <20130506101936.GE13861@dyad.programming.kicks-ass.net>
References: <1367804711-30308-1-git-send-email-alex.shi@intel.com>
 <1367804711-30308-6-git-send-email-alex.shi@intel.com> <CAPM31RLJe19FH+RYipwm4kwtzmFHoS2xGTx4iZ9+qwDJZ_pf3A@mail.gmail.com>
 <20130506101936.GE13861@dyad.programming.kicks-ass.net>
From: Paul Turner <pjt@google.com>
Date: Mon, 6 May 2013 03:33:45 -0700
Message-ID: <CAPM31RJg87C0nO_tAaOGLaDCUAB+QmfV4LkNcwnk9j9voNocfg@mail.gmail.com>
Subject: Re: [PATCH v5 5/7] sched: compute runnable load avg in cpu_load and cpu_avg_load_per_task
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Alex Shi <alex.shi@intel.com>, Ingo Molnar <mingo@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Borislav Petkov <bp@alien8.de>, Namhyung Kim <namhyung@kernel.org>,
        Mike Galbraith <efault@gmx.de>,
        Morten Rasmussen <morten.rasmussen@arm.com>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        Preeti U Murthy <preeti@linux.vnet.ibm.com>,
        Viresh Kumar <viresh.kumar@linaro.org>,
        LKML <linux-kernel@vger.kernel.org>, Mel Gorman <mgorman@suse.de>,
        Rik van Riel <riel@redhat.com>,
        Michael Wang <wangyun@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 6, 2013 at 3:19 AM, Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:
> On Mon, May 06, 2013 at 01:46:19AM -0700, Paul Turner wrote:
>> On Sun, May 5, 2013 at 6:45 PM, Alex Shi <alex.shi@intel.com> wrote:
>> > @@ -2536,7 +2536,7 @@ static void __update_cpu_load(struct rq *this_rq, unsigned long this_load,
>> >  void update_idle_cpu_load(struct rq *this_rq)
>> >  {
>> >         unsigned long curr_jiffies = ACCESS_ONCE(jiffies);
>> > -       unsigned long load = this_rq->load.weight;
>> > +       unsigned long load = (unsigned long)this_rq->cfs.runnable_load_avg;
>>
>> We should be minimizing:
>>   Variance[ for all i ]{ cfs_rq[i]->runnable_load_avg +
>> cfs_rq[i]->blocked_load_avg }
>>
>> blocked_load_avg is the expected "to wake" contribution from tasks
>> already assigned to this rq.
>>
>> e.g. this could be:
>>   load = this_rq->cfs.runnable_load_avg + this_rq->cfs.blocked_load_avg;
>>
>> Although, in general I have a major concern with the current implementation:
>>
>> The entire reason for stability with the bottom up averages is that
>> when load migrates between cpus we are able to migrate it between the
>> tracked sums.
>>
>> Stuffing observed averages of these into the load_idxs loses that
>> mobility; we will have to stall (as we do today for idx > 0) before we
>> can recognize that a cpu's load has truly left it; this is a very
>> similar problem to the need to stably track this for group shares
>> computation.
>
> Ah indeed. I overlooked that.
>
>> To that end, I would rather see the load_idx disappear completely:
>>  (a) We can calculate the imbalance purely from delta (runnable_avg +
>> blocked_avg)
>>  (b) It eliminates a bad tunable.
>
> So I suspect (haven't gone back in history to verify) that load_idx mostly
> comes from the fact that our balance passes happen more and more slowly the
> bigger the domains get.
>
> In that respect it makes sense to equate load_idx to sched_domain::level;
> higher domains balance slower and would thus want a longer-term average to base
> decisions on.
>
> So what we would want is means to get sane longer term averages.

Yeah, most of the rationale is super hand-wavy; especially the fairly
arbitrary choice of periods (e.g. busy_idx vs newidle).

I think the other rationale is:
  For smaller indicies (e.g. newidle) we speed up response time by
also cutting motion out of the averages.

The runnable_avgs themselves actually have a fair bit of history in
them already (50% is last 32ms); but given that they don't need to be
cut-off to respond to load being migrated I'm guessing we could
actually potentially get by with just "instaneous" and "use averages"
where appropriate?

We always end up having to re-pick/tune them based on a variety of
workloads; if we can eliminate them I think it would be a win.
