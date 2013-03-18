Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754222Ab3CRSYA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Mar 2013 14:24:00 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:3907 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753945Ab3CRSX6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Mar 2013 14:23:58 -0400
X-Authority-Analysis: v=2.0 cv=adbjbGUt c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=nGpB3NLV4dgA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=meVymXHHAAAA:8 a=xnoB05DE7xsA:10 a=O2MldzYM4ScL2vw4TpgA:9 a=PUjeQqilurYA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-ID: <1363631036.25967.193.camel@gandalf.local.home>
Subject: Re: workqueue code needing preemption disabled
From: Steven Rostedt <rostedt@goodmis.org>
To: Tejun Heo <tj@kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>, RT <linux-rt-users@vger.kernel.org>,
        Clark Williams <clark@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Date: Mon, 18 Mar 2013 14:23:56 -0400
In-Reply-To: <20130318164351.GA21516@mtj.dyndns.org>
References: <1363617383.25967.152.camel@gandalf.local.home>
	 <20130318160652.GA20133@mtj.dyndns.org>
	 <1363623799.25967.172.camel@gandalf.local.home>
	 <1363624020.25967.175.camel@gandalf.local.home>
	 <1363624243.25967.178.camel@gandalf.local.home>
	 <20130318164351.GA21516@mtj.dyndns.org>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.4.4-2 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2013-03-18 at 09:43 -0700, Tejun Heo wrote:
> Hello, Steven.
> 
> On Mon, Mar 18, 2013 at 12:30:43PM -0400, Steven Rostedt wrote:
> > If you happen to know the critical areas that require preemption to be
> > disabled for real, we can encapsulate them with:
> > 
> > 	preempt_disable_rt();
> > 
> > 	preempt_enable_rt();
> > 
> > These are currently only in the -rt patch, but it annotates locations
> > that require preemption to be disabled even when -rt converts spin_locks
> > into mutexes. These obviously can not contain spin_locks() as
> > spin_locks() can block and schedule out.
> 
> Making gcwq locks disable preemption would be much safer / easier, but
> if that's not desirable, anything touching gcwq->idle_list would be a
> good place to start - worker_enter_idle() and worker_leave_idle().
> Hmmm... ignoring CPU hotplug, I think those two might just do it.
> Give it a try?  How reproducible is the problem?
> 

Hmm, the issue is that a "use to be" idle thread got migrated, and is
now being woken up by another worker. What can cause an established
worker to migrate without HOTPLUG being active?

Thomas,

I'm thinking that we should also modify the scheduler for -rt:

        if (prev->state && !(preempt_count() & PREEMPT_ACTIVE)) {
                if (unlikely(signal_pending_state(prev->state, prev))) {
                        prev->state = TASK_RUNNING;
                } else {
                        deactivate_task(rq, prev, DEQUEUE_SLEEP);
                        prev->on_rq = 0;

                        /*
                         * If a worker went to sleep, notify and ask workqueue
                         * whether it wants to wake up a task to maintain
                         * concurrency.
                         */
                        if (prev->flags & PF_WQ_WORKER) {
                                struct task_struct *to_wakeup;

                                to_wakeup = wq_worker_sleeping(prev, cpu);
                                if (to_wakeup)
                                        try_to_wake_up_local(to_wakeup);
                        }
                }
                switch_count = &prev->nvcsw;
        }


The code calls another worker when the previous worker sleeps,
presumably on IO or something. But in -rt, it could be sleeping on the
gcwq->lock itself, and this could cause many more wakeups. Easily where
the task being woken up will try to grab the same lock and sleep again.

Perhaps we should check:

	if (prev->flags & PF_WQ_WORKER && !prev->saved_state)

To keep the worker thread from waking up other workers just because it
blocked on a sleeping spin lock.

-- Steve


