Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752114AbaJFK7s (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Oct 2014 06:59:48 -0400
Received: from e35.co.us.ibm.com ([32.97.110.153]:43261 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751090AbaJFK7r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Oct 2014 06:59:47 -0400
Date: Mon, 6 Oct 2014 03:59:40 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Oleg Nesterov <oleg@redhat.com>, Fengguang Wu <fengguang.wu@intel.com>,
        Jet Chen <jet.chen@intel.com>, Su Tao <tao.su@intel.com>,
        Yuanhan Liu <yuanhan.liu@intel.com>, LKP <lkp@01.org>,
        linux-kernel@vger.kernel.org, Marcel Holtmann <marcel@holtmann.org>,
        Peter Hurley <peter@hurleysoftware.com>
Subject: Re: [rfcomm_run] WARNING: CPU: 1 PID: 79 at kernel/sched/core.c:7156
 __might_sleep()
Message-ID: <20141006105940.GY5015@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20141002110927.GE2849@worktop.programming.kicks-ass.net>
 <20141002123150.GC6324@worktop.programming.kicks-ass.net>
 <20141002124247.GD6324@worktop.programming.kicks-ass.net>
 <20141002201020.GA8907@redhat.com>
 <20141003115020.GG10583@worktop.programming.kicks-ass.net>
 <20141003175654.GA14952@redhat.com>
 <20141003193029.GA24399@redhat.com>
 <20141004084241.GT10583@worktop.programming.kicks-ass.net>
 <20141006002509.GA23955@redhat.com>
 <20141006091915.GC6758@twins.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141006091915.GC6758@twins.programming.kicks-ass.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14100610-6688-0000-0000-00000552EEA1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 06, 2014 at 11:19:15AM +0200, Peter Zijlstra wrote:
> On Mon, Oct 06, 2014 at 02:25:09AM +0200, Oleg Nesterov wrote:
> > Yes, and the comments ;)
> > 
> > I showed this patch only to complete the discussion, I am not going to
> > send it now.
> 
> Fair enough :-)
> 
> > But thanks for the review!
> > 
> > > > +static void kthread_kill(struct task_struct *k, struct kthread *kthread)
> > > > +{
> > > > +	smp_mb__before_atomic();
> > >
> > > test_bit isn't actually an atomic op so this barrier is 'wrong'. If you
> > > need an MB there smp_mb() it is.
> > 
> > Hmm. I specially checked Documentation/memory-barriers.txt,
> > 
> >  (*) smp_mb__before_atomic();
> >  (*) smp_mb__after_atomic();
> > 
> >      These are for use with atomic (such as add, subtract, increment and
> >      decrement) functions that don't return a value, especially when used for
> >      reference counting.  These functions do not imply memory barriers.
> > 
> >      These are also used for atomic bitop functions that do not return a
> >      value (such as set_bit and clear_bit).
> >                     ^^^^^^^^^^^^^^^^^^^^^
> > 
> > Either you or memory-barriers.txt should be fixed ;)
> 
> Its in there, just not explicitly. All those functions listed are
> read-modify-write ops, test_bit() is not, its just a read. But yes I
> suppose we could make that more explicit.
> 
> Also test_bit() obviously does return a value, so it doesn't fall in the
> {set,clear}_bit() class.
> 
> Does the change below clarify things?
> 
> > > > +	if (test_bit(KTHREAD_WANTS_SIGNAL, &kthread->flags)) {
> > > > +		unsigned long flags;
> > > > +		bool kill = true;
> > > > +
> > > > +		if (lock_task_sighand(k, &flags)) {
> > >
> > > Since we do the double test thing here, with the set side also done
> > > under the lock, so we really need a barrier above?
> > 
> > Yes, otherwise set_kthread_wants_signal() can miss a signal. And note
> > that the 2nd check is only needed to ensure that we can not race
> > with set_kthread_wants_signal(false).
> > 
> > BUT!!! I have to admit that I simply do not know if there is any arch
> > 
> > 	set_bit(&word, X);
> > 	test_bit(&word, Y);
> > 
> > which actually needs mb() in between, the word is the same. Probably
> > not.
> 
> DEC Alpha? Wasn't it the problem there that dependencies didn't actually
> work as expected?

This looks to me to be an issue of cache coherence rather than
dependency ordering, so I would expect that DEC Alpha would respect
the ordering.

							Thanx, Paul

> Added Paul to Cc.
> 
> ---
>  Documentation/memory-barriers.txt | 9 +++------
>  1 file changed, 3 insertions(+), 6 deletions(-)
> 
> diff --git a/Documentation/memory-barriers.txt b/Documentation/memory-barriers.txt
> index 22a969cdd476..0d97c99ad957 100644
> --- a/Documentation/memory-barriers.txt
> +++ b/Documentation/memory-barriers.txt
> @@ -1594,12 +1594,9 @@ CPU from reordering them.
>   (*) smp_mb__before_atomic();
>   (*) smp_mb__after_atomic();
> 
> -     These are for use with atomic (such as add, subtract, increment and
> -     decrement) functions that don't return a value, especially when used for
> -     reference counting.  These functions do not imply memory barriers.
> -
> -     These are also used for atomic bitop functions that do not return a
> -     value (such as set_bit and clear_bit).
> +     These are for use with atomic/bitop (r-m-w) functions that don't return
> +     a value (eg. atomic_{add,sub,inc,dec}(), {set,clear}_bit()). These
> +     functions do not imply memory barriers.
> 
>       As an example, consider a piece of code that marks an object as being dead
>       and then decrements the object's reference count:
> 

