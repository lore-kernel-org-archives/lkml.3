Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752582AbbAUJal (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jan 2015 04:30:41 -0500
Received: from www.linutronix.de ([62.245.132.108]:53193 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751506AbbAUJac (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jan 2015 04:30:32 -0500
Date: Wed, 21 Jan 2015 10:30:07 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
cc: Calvin Owens <calvinowens@fb.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Joe Perches <joe@perches.com>, Peter Zijlstra <peterz@infradead.org>,
        linux-kernel@vger.kernel.org, kernel-team@fb.com
Subject: Re: [PATCH] ksoftirqd: Enable IRQs and call cond_resched() before
 poking RCU
In-Reply-To: <20150120203022.GR9719@linux.vnet.ibm.com>
Message-ID: <alpine.DEB.2.11.1501211027540.5526@nanos>
References: <20150107014906.GA27996@mail.thefacebook.com> <20150107021926.GT5280@linux.vnet.ibm.com> <20150107165223.GA21555@linux.vnet.ibm.com> <20150108043329.GB27996@mail.thefacebook.com> <20150108045306.GJ5280@linux.vnet.ibm.com>
 <20150108214644.GC27996@mail.thefacebook.com> <alpine.DEB.2.11.1501131215380.5526@nanos> <20150113184301.GO9719@linux.vnet.ibm.com> <20150113211618.GA21498@mail.thefacebook.com> <alpine.DEB.2.11.1501201419550.5526@nanos>
 <20150120203022.GR9719@linux.vnet.ibm.com>
User-Agent: Alpine 2.11 (DEB 23 2013-08-11)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 20 Jan 2015, Paul E. McKenney wrote:
> On Tue, Jan 20, 2015 at 02:21:51PM +0100, Thomas Gleixner wrote:
> > The whole rcu_note_context_switch() in run_ksoftirqd() is silly.
> > 
> >     cond_resched()
> > 	__preempt_count_add(PREEMPT_ACTIVE);
> > 
> > 	__schedule();
> > 	     preempt_disable();
> > 	     rcu_note_context_switch();
> > 	     ....
> > 
> > 	__preempt_count_sub(PREEMPT_ACTIVE);
> 
> I agree that if should_resched() returns true as assumed above, then there
> is no point to invoking rcu_note_context_switch().  However, the case that
> this code applies to is when should_resched() returns false, but RCU is
> waiting for a quiescent state from the current CPU.  In that case,
> cond_resched() won't do anything for RCU, and we do need the
> rcu_note_context_switch().

So this should be:

   if (!cond_resched())
      rcu_note_context_switch();

Hmm?
 
> Of course, it would be better to avoid the extra RCU work in the common
> case where cond_resched() does inovke the scheduler.  And that is the
> point of the following patch, which uses cond_resched_rcu_qs().
> However, this use of cond_resched_rcu_qs() doesn't work in older
> kernels.  So Calvin's patch is for backporting, and the follow-up
> patch for future kernels.

I see.

Thanks,

	tglx
