Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752842AbaJBUNl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Oct 2014 16:13:41 -0400
Received: from mx1.redhat.com ([209.132.183.28]:8964 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751493AbaJBUNk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Oct 2014 16:13:40 -0400
Date: Thu, 2 Oct 2014 22:10:20 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Fengguang Wu <fengguang.wu@intel.com>, Jet Chen <jet.chen@intel.com>,
        Su Tao <tao.su@intel.com>, Yuanhan Liu <yuanhan.liu@intel.com>,
        LKP <lkp@01.org>, linux-kernel@vger.kernel.org,
        Marcel Holtmann <marcel@holtmann.org>,
        Peter Hurley <peter@hurleysoftware.com>
Subject: Re: [rfcomm_run] WARNING: CPU: 1 PID: 79 at
	kernel/sched/core.c:7156 __might_sleep()
Message-ID: <20141002201020.GA8907@redhat.com>
References: <20140930080228.GD9561@wfg-t540p.sh.intel.com> <20141002110927.GE2849@worktop.programming.kicks-ass.net> <20141002123150.GC6324@worktop.programming.kicks-ass.net> <20141002124247.GD6324@worktop.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141002124247.GD6324@worktop.programming.kicks-ass.net>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/02, Peter Zijlstra wrote:
>
> On Thu, Oct 02, 2014 at 02:31:50PM +0200, Peter Zijlstra wrote:
> > @@ -2086,24 +2086,22 @@ static void rfcomm_kill_listener(void)
> >
> >  static int rfcomm_run(void *unused)
> >  {
> > +	DEFINE_WAIT_FUNC(wait, woken_wake_function);
> >  	BT_DBG("");
> >
> >  	set_user_nice(current, -10);
> >
> >  	rfcomm_add_listener(BDADDR_ANY);
> >
> > -	while (1) {
> > -		set_current_state(TASK_INTERRUPTIBLE);
> > -
> > -		if (kthread_should_stop())
> > -			break;
> > +	add_wait_queue(&rfcomm_wq, &wait);
> > +	while (!kthread_should_stop()) {
> >
> >  		/* Process stuff */
> >  		rfcomm_process_sessions();
> >
> > -		schedule();
> > +		wait_woken(&wait, TASK_INTERRUPTIBLE, MAX_SCHEDULE_TIMEOUT);
> >  	}
> > -	__set_current_state(TASK_RUNNING);
> > +	remove_wait_queue(&rfcomm_wq, &wait);
> >
> >  	rfcomm_kill_listener();
> >
>
> Hmm, I think there's a problem there. If someone were to do
> kthread_stop() before wait_woken() we'd not actually stop, because
> wait_woken() doesn't test KTHREAD_SHOULD_STOP before calling schedule().
>
> We can't unconditionally put a kthread_should_stop() in because
> to_kthread() would explode on a !kthread. The other obvious solution is
> adding a second function, something like wait_woken_or_stop(), but that
> appears somewhat ugly to me.
>
> Oleg, do you see another solution?

You know, I already thought about the patch below for other reasons, it
can probably simplify other users of kthread_should_stop(). Because this
way we can rely on the signal checks in schedule(). (Just in case, the
patch is not complete, see TODO).

As for rfcomm_run(), perhaps it can ise it too?

	set_kthread_wants_signal(true);

	add_wait_queue(&rfcomm_wq, &wait);
	for (;;) {
		// This is only possible if kthread_should_stop() == T
		if (signal_pending(current))
			break;

		rfcomm_process_sessions();
		wait_woken(TASK_INTERRUPTIBLE);
	}

Of course, this assumes that rfcomm_process_sessions() can't do something
"really bad" if signal_pending() is true.

What do you think?

Oleg.

--- x/kernel/kthread.c
+++ x/kernel/kthread.c
@@ -49,6 +49,7 @@ struct kthread {
 enum KTHREAD_BITS {
 	KTHREAD_IS_PER_CPU = 0,
 	KTHREAD_SHOULD_STOP,
+	KTHREAD_WANTS_SIGNAL,
 	KTHREAD_SHOULD_PARK,
 	KTHREAD_IS_PARKED,
 };
@@ -442,6 +443,21 @@ int kthread_park(struct task_struct *k)
 	return ret;
 }
 
+void set_kthread_wants_signal(bool on)
+{
+	unsigned long *kflags = &to_kthread(current)->flags;
+	unsigned long irqflags;
+
+	if (on) {
+		set_bit(KTHREAD_WANTS_SIGNAL, kflags);
+	} else {
+		spin_lock_irqsave(&current->sighand->siglock, irqflags);
+		clear_bit(KTHREAD_WANTS_SIGNAL, kflags);
+		recalc_sigpending();
+		spin_unlock_irqrestore(&current->sighand->siglock, irqflags);
+	}
+}
+
 /**
  * kthread_stop - stop a thread created by kthread_create().
  * @k: thread created by kthread_create().
@@ -469,6 +485,9 @@ int kthread_stop(struct task_struct *k)
 	if (kthread) {
 		set_bit(KTHREAD_SHOULD_STOP, &kthread->flags);
 		__kthread_unpark(k, kthread);
+		// TODO: this is racy, we need ->siglock.
+		if (test_bit(KTHREAD_WANTS_SIGNAL, &to_kthread(k)->flags))
+			 set_tsk_thread_flag(k, TIF_SIGPENDING);
 		wake_up_process(k);
 		wait_for_completion(&kthread->exited);
 	}

