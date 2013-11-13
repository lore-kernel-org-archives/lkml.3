Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758153Ab3KMREn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Nov 2013 12:04:43 -0500
Received: from fw-tnat.cambridge.arm.com ([217.140.96.21]:53938 "EHLO
	cam-smtp0.cambridge.arm.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1757197Ab3KMREf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Nov 2013 12:04:35 -0500
Date: Wed, 13 Nov 2013 17:03:58 +0000
From: Catalin Marinas <catalin.marinas@arm.com>
To: Martin Schwidefsky <schwidefsky@de.ibm.com>
Cc: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/2] sched/mm: add finish_switch_mm function
Message-ID: <20131113170358.GG18837@arm.com>
References: <1384330574-18418-1-git-send-email-schwidefsky@de.ibm.com>
 <1384330574-18418-2-git-send-email-schwidefsky@de.ibm.com>
 <20131113114143.GJ21461@twins.programming.kicks-ass.net>
 <20131113121909.GA18837@arm.com>
 <20131113170556.7e170e89@mschwide>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131113170556.7e170e89@mschwide>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 13, 2013 at 04:05:56PM +0000, Martin Schwidefsky wrote:
> On Wed, 13 Nov 2013 12:19:09 +0000
> Catalin Marinas <catalin.marinas@arm.com> wrote:
> > On Wed, Nov 13, 2013 at 11:41:43AM +0000, Peter Zijlstra wrote:
> > > On Wed, Nov 13, 2013 at 09:16:13AM +0100, Martin Schwidefsky wrote:
> > > >  	fire_sched_in_preempt_notifiers(current);
> > > >  	if (mm)
> > > > @@ -4140,8 +4141,10 @@ void idle_task_exit(void)
> > > >  
> > > >  	BUG_ON(cpu_online(smp_processor_id()));
> > > >  
> > > > -	if (mm != &init_mm)
> > > > +	if (mm != &init_mm) {
> > > >  		switch_mm(mm, &init_mm, current);
> > > > +		finish_switch_mm(&init_mm, current);
> > > > +	}
> > > >  	mmdrop(mm);
> > > >  }
> > 
> > Here finish_switch_mm() is called in the same context with switch_mm().
> > What we have on ARM via switch_mm() is to check for irqs_disabled() and
> > if yes, defer the actual switching via a flag until the
> > finish_arch_post_lock_switch() hook. But on ARM we only cared about the
> > interrupts being enabled.
> 
> The guarantee s390 needs is that the rq-lock is not taken. What I have
> seen with the wait loop in switch_mm is a dead lock because one CPU #0
> was looping in switch_mm to wait for the TLB flush of another CPU #1.
> CPU #1 got an interrupt that tried to wake-up a task which happened to
> be on the run-queue of CPU #0.

I'm not familiar with the s390 code, so how's the waiting done? Is it
part of an on_each_cpu() call (that's what I got from smp_ptlb_all)?

-- 
Catalin
