Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754261AbaJCSAS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Oct 2014 14:00:18 -0400
Received: from mx1.redhat.com ([209.132.183.28]:26554 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751290AbaJCSAO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Oct 2014 14:00:14 -0400
Date: Fri, 3 Oct 2014 19:56:54 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Fengguang Wu <fengguang.wu@intel.com>, Jet Chen <jet.chen@intel.com>,
        Su Tao <tao.su@intel.com>, Yuanhan Liu <yuanhan.liu@intel.com>,
        LKP <lkp@01.org>, linux-kernel@vger.kernel.org,
        Marcel Holtmann <marcel@holtmann.org>,
        Peter Hurley <peter@hurleysoftware.com>
Subject: Re: [rfcomm_run] WARNING: CPU: 1 PID: 79 at
	kernel/sched/core.c:7156 __might_sleep()
Message-ID: <20141003175654.GA14952@redhat.com>
References: <20140930080228.GD9561@wfg-t540p.sh.intel.com> <20141002110927.GE2849@worktop.programming.kicks-ass.net> <20141002123150.GC6324@worktop.programming.kicks-ass.net> <20141002124247.GD6324@worktop.programming.kicks-ass.net> <20141002201020.GA8907@redhat.com> <20141003115020.GG10583@worktop.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141003115020.GG10583@worktop.programming.kicks-ass.net>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/03, Peter Zijlstra wrote:
>
> On Thu, Oct 02, 2014 at 10:10:20PM +0200, Oleg Nesterov wrote:
>
> > As for rfcomm_run(), perhaps it can ise it too?
> >
> > 	set_kthread_wants_signal(true);
> >
> > 	add_wait_queue(&rfcomm_wq, &wait);
> > 	for (;;) {
> > 		// This is only possible if kthread_should_stop() == T
>
> True because kthreads SIG_IGN everything, right?

Yes,

> > 		if (signal_pending(current))
> > 			break;
> >
> > 		rfcomm_process_sessions();
> > 		wait_woken(TASK_INTERRUPTIBLE);
> > 	}
> >
> > Of course, this assumes that rfcomm_process_sessions() can't do something
> > "really bad" if signal_pending() is true.
>
> So from what I can think of, everything that does an INTERRUPTIBLE sleep
> will 'malfunction' after that, right? Which might be quite a lot
> actually.

Yes.

> > What do you think?
>
> Interesting approach, but somewhat risky I tihnk, due to that
> INTERRUPTIBLE thing.

OK, this is fixable.  rfcomm_run() can do

	add_wait_queue(&rfcomm_wq, &wait);
	while (!kthread_should_stop()) {
		rfcomm_process_sessions();

		set_kthread_wants_signal(true);
		wait_woken(TASK_INTERRUPTIBLE);
		set_kthread_wants_signal(false);
	}
	remove_wait_queue(&rfcomm_wq, &wait);

Or. perhaps we can change wait_woken

	-	set_current_state(mode);
	+	if (mode)
	+		set_current_state(mode);


then rfcomm_run() can do

	for (;;) {
		rfcomm_process_sessions();

		set_current_state(TASK_INTERRUPTIBLE);
		if (kthread_should_stop())
			break;
		wait_woken(0);
	}

Or perhaps we can split wait_woken() into 2 helpers,

	static inline long wait_woken(wq, mode, timeout)
	{
		set_current_state(mode);
		schedule_woken(wq, timeout); // does the rest
	}

to avoid "mode == 0" hack; rfcomm_run() should use schedule_woken().

What do you think?

Oleg.

