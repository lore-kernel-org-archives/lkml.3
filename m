Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754843AbbATNUY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jan 2015 08:20:24 -0500
Received: from mga09.intel.com ([134.134.136.24]:2801 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753388AbbATNUX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jan 2015 08:20:23 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.09,434,1418112000"; 
   d="scan'208";a="664619212"
From: Alexander Shishkin <alexander.shishkin@linux.intel.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@redhat.com>, linux-kernel@vger.kernel.org,
        Robert Richter <rric@kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Mike Galbraith <efault@gmx.de>, Paul Mackerras <paulus@samba.org>,
        Stephane Eranian <eranian@google.com>, Andi Kleen <ak@linux.intel.com>,
        kan.liang@intel.com, adrian.hunter@intel.com,
        markus.t.metzger@intel.com, mathieu.poirier@linaro.org,
        Kaixu Xia <kaixu.xia@linaro.org>, acme@infradead.org
Subject: Re: [PATCH v9 12/14] x86: perf: intel_pt: Intel PT PMU driver
In-Reply-To: <87egqwmdhe.fsf@ashishki-desk.ger.corp.intel.com>
References: <1421237903-181015-1-git-send-email-alexander.shishkin@linux.intel.com> <1421237903-181015-13-git-send-email-alexander.shishkin@linux.intel.com> <20150115090659.GQ23965@worktop.programming.kicks-ass.net> <87egqwmdhe.fsf@ashishki-desk.ger.corp.intel.com>
User-Agent: Notmuch/0.17+49~gaa57e9d (http://notmuchmail.org) Emacs/24.4.1 (x86_64-pc-linux-gnu)
Date: Tue, 20 Jan 2015 15:20:00 +0200
Message-ID: <87twzllhbz.fsf@ashishki-desk.ger.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alexander Shishkin <alexander.shishkin@linux.intel.com> writes:

> Peter Zijlstra <peterz@infradead.org> writes:
>
>> On Wed, Jan 14, 2015 at 02:18:21PM +0200, Alexander Shishkin wrote:
>>> +static __init int pt_init(void)
>>> +{
>>
>>> +	pt_pmu.pmu.attr_groups	= pt_attr_groups;
>>> +	pt_pmu.pmu.task_ctx_nr	= perf_hw_context;
>>
>> I just noticed this one, how can this ever work? We want the PT thing to
>> always get programmed, right? -- because we disallow creating more than
>> 1?
>>
>> Which reminds me; does that exclusive thing you did not allow you to
>> create one cpu wide and one per task (they're separate contexts) events?
>> At which point we're not schedulable at all.
>>
>> By sticking it on the HW context list it can end up not being programed
>> because its stuck after a bunch of hardware events that don't all fit on
>> the PMU.
>>
>> Would not the SW list be more appropriate; the SW list is a list of
>> events that's guaranteed to be schedulable.
>
> You're right, of course.
>
> As for the exclusive events, how about something like the code below (on
> top of the previous exclusive event patch)? The only remaining issue
> that I see is creating cpu-wide events in the presence of per-thread
> (event->cpu==-1) events. Both would still work, but only one of them
> will actually get scheduled at a time. I'm thinking about adding a
> counter for per-thread events to struct pmu for this purpose, so that if
> any are present, we can disallow creating cpu-wide events. Or, we can
> leave it as it is.
>
> What do you think?
>
> ---
>  kernel/events/core.c | 52 +++++++++++++++++++++++++++++++++++++++++++++++-----
>  1 file changed, 47 insertions(+), 5 deletions(-)
>
> diff --git a/kernel/events/core.c b/kernel/events/core.c
> index cf0bf99f53..e8c86530e2 100644
> --- a/kernel/events/core.c
> +++ b/kernel/events/core.c
> @@ -7688,14 +7688,11 @@ static bool exclusive_event_match(struct perf_event *e1, struct perf_event *e2)
>  	return false;
>  }
>  
> -static bool exclusive_event_ok(struct perf_event *event,
> -			      struct perf_event_context *ctx)
> +static bool __exclusive_event_ok(struct perf_event *event,
> +				 struct perf_event_context *ctx)
>  {
>  	struct perf_event *iter_event;
>  
> -	if (!(event->pmu->capabilities & PERF_PMU_CAP_EXCLUSIVE))
> -		return true;
> -
>  	list_for_each_entry(iter_event, &ctx->event_list, event_entry) {
>  		if (exclusive_event_match(iter_event, event))
>  			return false;
> @@ -7704,6 +7701,51 @@ static bool exclusive_event_ok(struct perf_event *event,
>  	return true;
>  }
>  
> +static bool __exclusive_event_ok_on_cpu(struct perf_event *event, int cpu)
> +{
> +	struct perf_event_context *cpuctx;
> +	bool ret;
> +
> +	cpuctx = find_get_context(event->pmu, NULL, cpu);
> +	mutex_lock(&cpuctx->mutex);
> +	ret = __exclusive_event_ok(event, cpuctx);
> +	perf_unpin_context(cpuctx);
> +	put_ctx(cpuctx);
> +	mutex_unlock(&cpuctx->mutex);

Actually, find_get_context() is not needed here, the following should be
sufficient:

	cpuctx = &per_cpu_ptr(event->pmu->pmu_cpu_context, cpu)->ctx;

	mutex_lock(&cpuctx->mutex);
	ret = __exclusive_event_ok(event, cpuctx);
	mutex_unlock(&cpuctx->mutex);

Regards,
--
Alex
