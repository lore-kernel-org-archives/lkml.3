Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754827AbaIBS6u (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Sep 2014 14:58:50 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:51174 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753889AbaIBS6s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Sep 2014 14:58:48 -0400
Date: Tue, 2 Sep 2014 19:58:07 +0100
From: Mark Rutland <mark.rutland@arm.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Yan@leverpostej.cambridge.arm.com" 
	<Yan@leverpostej.cambridge.arm.com>,
        Zheng <zheng.z.yan@intel.com>, Stephane Eranian <eranian@google.com>,
        Ingo Molnar <mingo@kernel.org>
Subject: Re: Possible race between CPU hotplug and perf_pmu_migrate_context
Message-ID: <20140902185807.GA7434@leverpostej>
References: <20140901181808.GA6427@leverpostej>
 <20140901190534.GC5806@worktop.ger.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140901190534.GC5806@worktop.ger.corp.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 01, 2014 at 08:05:34PM +0100, Peter Zijlstra wrote:
> On Mon, Sep 01, 2014 at 07:18:08PM +0100, Mark Rutland wrote:
> > Hi all,
> 
> > [   66.780759]  [<ffffffff8109dd33>] rcu_process_callbacks+0x1e3/0x540
> 
> > Has anything seen anything like this before? Is this a known issue?
> 
> I've not seen it reported.. sounds like 'fun' though.
> 

This has been a tremendous source of 'fun' so far...

The rcu_process_callbacks line is a red herring. What seems to be
happening is:

A CPU goes down, and perf_pmu_migrate_context removes all events from
per_cpu_ptr(pmu->pmu_cpu_context, src_cpu)->ctx. The events are in a
state of limbo, with their ctx pointers pointing at the old context,
whose refcount is 1. The src_ctx->mutex is unlocked.

Concurrently on another CPU the fds are closed, and perf_event_release
goes and removes each event from their event->ctx. We skip the double
detach in list_del_event and carry on to __free_event where we put_ctx
the old context for a second time for each event. The refcount goes to 0
and we queue a kfree_rcu of the context (inside the PMU's percpu
perf_event_cpu_context, allocated with alloc_percpu).

We run the queued kfree_rcu, and explode trying to kfree something we
didn't k*alloc. I'm not sure when exactly we run the queued kfree_rcu
w.r.t. everything else.

So the problem here seems to be a race between the
perf_pmu_migrate_context and something down the perf_event_release
callchain.

Any ideas?

Thanks,
Mark.
