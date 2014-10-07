Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754394AbaJGPTY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Oct 2014 11:19:24 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:43197 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753862AbaJGPTX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Oct 2014 11:19:23 -0400
Date: Tue, 7 Oct 2014 17:19:19 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: "Liang, Kan" <kan.liang@intel.com>
Cc: "eranian@google.com" <eranian@google.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "paulus@samba.org" <paulus@samba.org>,
        "acme@kernel.org" <acme@kernel.org>,
        "ak@linux.intel.com" <ak@linux.intel.com>,
        "Yan, Zheng" <zheng.z.yan@intel.com>
Subject: Re: [PATCH V5 08/16] perf, x86: track number of events that use LBR
 callstack
Message-ID: <20141007151919.GB5850@twins.programming.kicks-ass.net>
References: <1410358153-421-1-git-send-email-kan.liang@intel.com>
 <1410358153-421-9-git-send-email-kan.liang@intel.com>
 <20140924125349.GB2805@worktop.programming.kicks-ass.net>
 <37D7C6CF3E00A74B8858931C1DB2F0770160F974@SHSMSX103.ccr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <37D7C6CF3E00A74B8858931C1DB2F0770160F974@SHSMSX103.ccr.corp.intel.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 07, 2014 at 02:59:20AM +0000, Liang, Kan wrote:
> > On Wed, Sep 10, 2014 at 10:09:05AM -0400, kan.liang@intel.com wrote:
> > > @@ -204,9 +204,15 @@ void intel_pmu_lbr_sched_task(struct
> > perf_event_context *ctx, bool sched_in)
> > >  	}
> > >  }
> > >
> > > +static inline bool branch_user_callstack(unsigned br_sel) {
> > > +	return (br_sel & X86_BR_USER) && (br_sel & X86_BR_CALL_STACK); }
> > > +
> > >  void intel_pmu_lbr_enable(struct perf_event *event)  {
> > >  	struct cpu_hw_events *cpuc = &__get_cpu_var(cpu_hw_events);
> > > +	struct x86_perf_task_context *task_ctx;
> > >
> > >  	if (!x86_pmu.lbr_nr)
> > >  		return;
> > > @@ -220,6 +226,10 @@ void intel_pmu_lbr_enable(struct perf_event
> > *event)
> > >  	}
> > >  	cpuc->br_sel = event->hw.branch_reg.reg;
> > >
> > > +	task_ctx = event->ctx ? event->ctx->task_ctx_data : NULL;
> > > +	if (task_ctx && branch_user_callstack(cpuc->br_sel))
> > > +		task_ctx->lbr_callstack_users++;
> > > +
> > 
> > Does it make sense to flip those conditions to avoid a potentially useless
> > dereference?
> 
> I'm not quite sure I understand your meaning here.
> But lbr_callstack_users is an indicator for save/restore the LBR stack on context switch.
> Here, we only change the lbr_callstack_users, when it's LBR call stack and has space for saving LBR stack.
> 
> Should I change the code as below?
> +       if (branch_user_callstack(cpuc->br_sel) && event->ctx &&
> +               (task_ctx = event->ctx->task_ctx_data))
> +               task_ctx->lbr_callstack_users++;

Yes, that avoids the ctx->task_ctx_data deref when
!branch_user_callstack().
