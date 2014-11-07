Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751813AbaKGLXQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Nov 2014 06:23:16 -0500
Received: from bombadil.infradead.org ([198.137.202.9]:55911 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751325AbaKGLXN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Nov 2014 06:23:13 -0500
Date: Fri, 7 Nov 2014 12:22:55 +0100
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
Message-ID: <20141107112255.GB29390@twins.programming.kicks-ass.net>
References: <1415276602-10337-1-git-send-email-matt@console-pimps.org>
 <1415276602-10337-10-git-send-email-matt@console-pimps.org>
 <20141107090804.GA3337@twins.programming.kicks-ass.net>
 <20141107100959.GK3592@console-pimps.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141107100959.GK3592@console-pimps.org>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 07, 2014 at 10:09:59AM +0000, Matt Fleming wrote:
> On Fri, 07 Nov, at 10:08:04AM, Peter Zijlstra wrote:
> > 
> > How is that supposed to work? You call __intel_cqm_event_count() on the
> > one cpu per socket, but then you use a local_add, not an atomic_add,
> > even though these adds can happen concurrently as per IPI broadcast.
>  
> Ouch, right. That's broken.
> 
> > Also, I think smp_call_function_many() ignores the current cpu, if this
> > cpu happens to be the cpu for this socket, you're up some creek without
> > no paddle, right?
>  
> OK, I didn't realise that. Yeah that sounds very problematic. I think my
> eyes skipped over the word "other" in the smp_call_function_many() docs,
> 
>  * smp_call_function_many(): Run a function on a set of other CPUs.
> 
> So, the correct way to do this is to iterate over cqm_cpumask and invoke
> smp_call_function_single(), right?
> 
> > Thirdly, there is no serialization around calling perf_event_count() [or
> > your pmu::count method] so you cannot temporarily put it to 0.
> 
> Urgh, thanks. Good spot. I'm gonna have to think of a suitable
> serialisation mechanism because all the current ones are pretty
> heavy-handed. And of course, there's the added fun that it needs to be
> held across the IPIs.
> 
> Perhaps a per-cache-group mutex?

struct rmid_read {
	unsigned int rmid;
	atomic64_t value;
}

static void __remote_rmid_read(void *arg)
{
	struct rmid_read *rr = arg;
	u64 val = __rmid_read(rr->rmid);

	if (val & (RMID_VAL_ERROR | RMID_VAL_UNAVAIL))
		return;

	atomic64_add(val, &rr->value);
}

static void task_rmid_read(struct perf_event *event)
{
	struct rmid_read rr = {
		.rmid = ...,
		.value = ATOMIC64_INIT(0),
	};
	int cpu;

	...


	cpu = get_cpu();
	smp_call_function_many(&cqm_cpumask, __remote_rmid_read, &rr);
	if (cpumask_test(cpu, &cqm_cpumask)) {
		local_irq_disable();
		__remote_rmid_read(&rr);
		local_irq_enable();
	}
	put_cpu();

	local64_set(&event->count, atomic64_read(&rr->value));
}

