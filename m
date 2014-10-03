Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752247AbaJCLud (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Oct 2014 07:50:33 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:45830 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751546AbaJCLub (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Oct 2014 07:50:31 -0400
Date: Fri, 3 Oct 2014 13:50:20 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Fengguang Wu <fengguang.wu@intel.com>, Jet Chen <jet.chen@intel.com>,
        Su Tao <tao.su@intel.com>, Yuanhan Liu <yuanhan.liu@intel.com>,
        LKP <lkp@01.org>, linux-kernel@vger.kernel.org,
        Marcel Holtmann <marcel@holtmann.org>,
        Peter Hurley <peter@hurleysoftware.com>
Subject: Re: [rfcomm_run] WARNING: CPU: 1 PID: 79 at kernel/sched/core.c:7156
 __might_sleep()
Message-ID: <20141003115020.GG10583@worktop.programming.kicks-ass.net>
References: <20140930080228.GD9561@wfg-t540p.sh.intel.com>
 <20141002110927.GE2849@worktop.programming.kicks-ass.net>
 <20141002123150.GC6324@worktop.programming.kicks-ass.net>
 <20141002124247.GD6324@worktop.programming.kicks-ass.net>
 <20141002201020.GA8907@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141002201020.GA8907@redhat.com>
User-Agent: Mutt/1.5.22.1 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 02, 2014 at 10:10:20PM +0200, Oleg Nesterov wrote:
> You know, I already thought about the patch below for other reasons, it
> can probably simplify other users of kthread_should_stop(). Because this
> way we can rely on the signal checks in schedule(). (Just in case, the
> patch is not complete, see TODO).
> 
> As for rfcomm_run(), perhaps it can ise it too?
> 
> 	set_kthread_wants_signal(true);
> 
> 	add_wait_queue(&rfcomm_wq, &wait);
> 	for (;;) {
> 		// This is only possible if kthread_should_stop() == T

True because kthreads SIG_IGN everything, right?

> 		if (signal_pending(current))
> 			break;
> 
> 		rfcomm_process_sessions();
> 		wait_woken(TASK_INTERRUPTIBLE);
> 	}
> 
> Of course, this assumes that rfcomm_process_sessions() can't do something
> "really bad" if signal_pending() is true.

So from what I can think of, everything that does an INTERRUPTIBLE sleep
will 'malfunction' after that, right? Which might be quite a lot
actually.

> What do you think?

Interesting approach, but somewhat risky I tihnk, due to that
INTERRUPTIBLE thing.

> --- x/kernel/kthread.c
> +++ x/kernel/kthread.c
> @@ -49,6 +49,7 @@ struct kthread {
>  enum KTHREAD_BITS {
>  	KTHREAD_IS_PER_CPU = 0,
>  	KTHREAD_SHOULD_STOP,
> +	KTHREAD_WANTS_SIGNAL,
>  	KTHREAD_SHOULD_PARK,
>  	KTHREAD_IS_PARKED,
>  };
> @@ -442,6 +443,21 @@ int kthread_park(struct task_struct *k)
>  	return ret;
>  }
>  
> +void set_kthread_wants_signal(bool on)
> +{
> +	unsigned long *kflags = &to_kthread(current)->flags;
> +	unsigned long irqflags;
> +
> +	if (on) {
> +		set_bit(KTHREAD_WANTS_SIGNAL, kflags);
> +	} else {
> +		spin_lock_irqsave(&current->sighand->siglock, irqflags);
> +		clear_bit(KTHREAD_WANTS_SIGNAL, kflags);
> +		recalc_sigpending();
> +		spin_unlock_irqrestore(&current->sighand->siglock, irqflags);
> +	}
> +}
> +
>  /**
>   * kthread_stop - stop a thread created by kthread_create().
>   * @k: thread created by kthread_create().
> @@ -469,6 +485,9 @@ int kthread_stop(struct task_struct *k)
>  	if (kthread) {
>  		set_bit(KTHREAD_SHOULD_STOP, &kthread->flags);
>  		__kthread_unpark(k, kthread);
> +		// TODO: this is racy, we need ->siglock.
> +		if (test_bit(KTHREAD_WANTS_SIGNAL, &to_kthread(k)->flags))
> +			 set_tsk_thread_flag(k, TIF_SIGPENDING);

Right, but taking that should not really be a problem afaict, this is a
slow path if ever there was one.

>  		wake_up_process(k);
>  		wait_for_completion(&kthread->exited);
>  	}
> 
