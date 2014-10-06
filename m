Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752154AbaJFA2f (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Oct 2014 20:28:35 -0400
Received: from mx1.redhat.com ([209.132.183.28]:59507 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751809AbaJFA2e (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Oct 2014 20:28:34 -0400
Date: Mon, 6 Oct 2014 02:25:09 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Fengguang Wu <fengguang.wu@intel.com>, Jet Chen <jet.chen@intel.com>,
        Su Tao <tao.su@intel.com>, Yuanhan Liu <yuanhan.liu@intel.com>,
        LKP <lkp@01.org>, linux-kernel@vger.kernel.org,
        Marcel Holtmann <marcel@holtmann.org>,
        Peter Hurley <peter@hurleysoftware.com>
Subject: Re: [rfcomm_run] WARNING: CPU: 1 PID: 79 at
	kernel/sched/core.c:7156 __might_sleep()
Message-ID: <20141006002509.GA23955@redhat.com>
References: <20140930080228.GD9561@wfg-t540p.sh.intel.com> <20141002110927.GE2849@worktop.programming.kicks-ass.net> <20141002123150.GC6324@worktop.programming.kicks-ass.net> <20141002124247.GD6324@worktop.programming.kicks-ass.net> <20141002201020.GA8907@redhat.com> <20141003115020.GG10583@worktop.programming.kicks-ass.net> <20141003175654.GA14952@redhat.com> <20141003193029.GA24399@redhat.com> <20141004084241.GT10583@worktop.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141004084241.GT10583@worktop.programming.kicks-ass.net>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/04, Peter Zijlstra wrote:
>
> On Fri, Oct 03, 2014 at 09:30:29PM +0200, Oleg Nesterov wrote:
> > > Or. perhaps we can change wait_woken
> > >
> > > 	-	set_current_state(mode);
> > > 	+	if (mode)
> > > 	+		set_current_state(mode);
> > >
> > >
> > > then rfcomm_run() can do
> > >
> > > 	for (;;) {
> > > 		rfcomm_process_sessions();
> > >
> > > 		set_current_state(TASK_INTERRUPTIBLE);
> > > 		if (kthread_should_stop())
> > > 			break;
> > > 		wait_woken(0);
> > > 	}
>
> > probably this makes more sense in this particular case...
>
> Right, in which case the below needs a different justification, but you
> said you were already thinking about it, so there must be something.
>
> And clearly it needs a changelog to begin with :-)

Yes, and the comments ;)

I showed this patch only to complete the discussion, I am not going to
send it now.

But thanks for the review!

> > +static void kthread_kill(struct task_struct *k, struct kthread *kthread)
> > +{
> > +	smp_mb__before_atomic();
>
> test_bit isn't actually an atomic op so this barrier is 'wrong'. If you
> need an MB there smp_mb() it is.

Hmm. I specially checked Documentation/memory-barriers.txt,

 (*) smp_mb__before_atomic();
 (*) smp_mb__after_atomic();

     These are for use with atomic (such as add, subtract, increment and
     decrement) functions that don't return a value, especially when used for
     reference counting.  These functions do not imply memory barriers.

     These are also used for atomic bitop functions that do not return a
     value (such as set_bit and clear_bit).
                    ^^^^^^^^^^^^^^^^^^^^^

Either you or memory-barriers.txt should be fixed ;)

> Again, comment is missing.

Yes, yes, we need the comments in set_kthread_wants_signal() and kthread_kill()
to explain that they set/check KTHREAD_WANTS_SIGNAL/KTHREAD_SHOULD_STOP in
opposite order, and we need mb's to separate STORE/LOAD.

And probably set_bit(KTHREAD_SHOULD_STOP) should be moved into kthread_kill()
to make this more clear. (along with __kthread_unpark(), but this reminds me
that __kthread_unpark() should die imho).

>
> > +	if (test_bit(KTHREAD_WANTS_SIGNAL, &kthread->flags)) {
> > +		unsigned long flags;
> > +		bool kill = true;
> > +
> > +		if (lock_task_sighand(k, &flags)) {
>
> Since we do the double test thing here, with the set side also done
> under the lock, so we really need a barrier above?

Yes, otherwise set_kthread_wants_signal() can miss a signal. And note
that the 2nd check is only needed to ensure that we can not race
with set_kthread_wants_signal(false).

BUT!!! I have to admit that I simply do not know if there is any arch

	set_bit(&word, X);
	test_bit(&word, Y);

which actually needs mb() in between, the word is the same. Probably
not.

Oleg.

