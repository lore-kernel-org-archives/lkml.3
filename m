Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751519AbaKGJIT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Nov 2014 04:08:19 -0500
Received: from casper.infradead.org ([85.118.1.10]:33758 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750974AbaKGJIO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Nov 2014 04:08:14 -0500
Date: Fri, 7 Nov 2014 10:08:04 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Matt Fleming <matt@console-pimps.org>
Cc: Ingo Molnar <mingo@kernel.org>, Jiri Olsa <jolsa@redhat.com>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Andi Kleen <andi@firstfloor.org>, Thomas Gleixner <tglx@linutronix.de>,
        linux-kernel@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        Kanaka Juvva <kanaka.d.juvva@intel.com>,
        Matt Fleming <matt.fleming@intel.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: Re: [PATCH 09/11] perf/x86/intel: Support task events with Intel CQM
Message-ID: <20141107090804.GA3337@twins.programming.kicks-ass.net>
References: <1415276602-10337-1-git-send-email-matt@console-pimps.org>
 <1415276602-10337-10-git-send-email-matt@console-pimps.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1415276602-10337-10-git-send-email-matt@console-pimps.org>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 06, 2014 at 12:23:20PM +0000, Matt Fleming wrote:
> +static void __intel_cqm_event_count(void *info)
> +{
> +	struct perf_event *event = info;
> +	u64 val;
> +
> +	val = __rmid_read(event->hw.cqm_rmid);
> +
> +	if (val & (RMID_VAL_ERROR | RMID_VAL_UNAVAIL))
> +		return;
> +
> +	local64_add(val, &event->count);
> +}
> +
> +static inline bool cqm_group_leader(struct perf_event *event)
> +{
> +	return !list_empty(&event->hw.cqm_groups_entry);
> +}
> +
> +static u64 intel_cqm_event_count(struct perf_event *event)
> +{
> +	/*
> +	 * We only need to worry about task events. System-wide events
> +	 * are handled like usual, i.e. entirely with
> +	 * intel_cqm_event_read().
> +	 */
> +	if (event->cpu != -1)
> +		return __perf_event_count(event);
> +
> +	/*
> +	 * Only the group leader gets to report values. This stops us
> +	 * reporting duplicate values to userspace, and gives us a clear
> +	 * rule for which task gets to report the values.
> +	 *
> +	 * Note that it is impossible to attribute these values to
> +	 * specific packages - we forfeit that ability when we create
> +	 * task events.
> +	 */
> +	if (!cqm_group_leader(event))
> +		return 0;
> +
> +	local64_set(&event->count, 0);
> +
> +	preempt_disable()
> +	smp_call_function_many(&cqm_cpumask, __intel_cqm_event_count, event, 1);
> +	preempt_enable();
> +
> +	return __perf_event_count(event);
> +}

How is that supposed to work? You call __intel_cqm_event_count() on the
one cpu per socket, but then you use a local_add, not an atomic_add,
even though these adds can happen concurrently as per IPI broadcast.

Also, I think smp_call_function_many() ignores the current cpu, if this
cpu happens to be the cpu for this socket, you're up some creek without
no paddle, right?

Thirdly, there is no serialization around calling perf_event_count() [or
your pmu::count method] so you cannot temporarily put it to 0.
