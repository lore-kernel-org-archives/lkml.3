Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754717AbaGHVkW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jul 2014 17:40:22 -0400
Received: from e38.co.us.ibm.com ([32.97.110.159]:59866 "EHLO
	e38.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754652AbaGHVkS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jul 2014 17:40:18 -0400
Date: Tue, 8 Jul 2014 14:40:11 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Pranith Kumar <bobby.prani@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>, mingo@kernel.org,
        laijs@cn.fujitsu.com, Dipankar Sarma <dipankar@in.ibm.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Josh Triplett <josh@joshtriplett.org>, niv@us.ibm.com,
        tglx@linutronix.de, Peter Zijlstra <peterz@infradead.org>,
        rostedt@goodmis.org, dhowells@redhat.com,
        Eric Dumazet <edumazet@google.com>
Subject: Re: [PATCH tip/core/rcu 06/17] rcu: Eliminate read-modify-write
 ACCESS_ONCE() calls
Message-ID: <20140708214011.GY4603@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20140707223756.GA7187@linux.vnet.ibm.com>
 <1404772701-8804-1-git-send-email-paulmck@linux.vnet.ibm.com>
 <1404772701-8804-6-git-send-email-paulmck@linux.vnet.ibm.com>
 <CAJhHMCBnctjpo1Kdi71-6mEiTEnBfOhMTZC1gTsEx42z-UL=Bw@mail.gmail.com>
 <20140708203459.GU4603@linux.vnet.ibm.com>
 <CAJhHMCDcKB7sOwW3fp2gu20ot4V913kbZYQfN7T1we_choWLLw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAJhHMCDcKB7sOwW3fp2gu20ot4V913kbZYQfN7T1we_choWLLw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14070821-1344-0000-0000-000002B03E70
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 08, 2014 at 04:43:37PM -0400, Pranith Kumar wrote:
> On Tue, Jul 8, 2014 at 4:35 PM, Paul E. McKenney
> <paulmck@linux.vnet.ibm.com> wrote:
> >
> > Good catch, I clearly didn't include enough patterns in my search.
> >
> > But please see below.  And please rebase onto branch rcu/dev in
> > git://git.kernel.org/pub/scm/linux/kernel/git/paulmck/linux-rcu.git,
> > as this patch set does not apply.
> 
> OK, I will resend the patch. One question below:
> 
> >
> >                                                         Thanx, Paul
> >
> >> Signed-off-by: Pranith Kumar <bobby.prani@gmail.com>
> >> ---
> >> diff --git a/kernel/rcu/tree.c b/kernel/rcu/tree.c
> >> index dac6d20..f500395 100644
> >> --- a/kernel/rcu/tree.c
> >> +++ b/kernel/rcu/tree.c
> >> @@ -1700,7 +1700,7 @@ static int rcu_gp_fqs(struct rcu_state *rsp, int
> >> fqs_state_in)
> >>         if (ACCESS_ONCE(rsp->gp_flags) & RCU_GP_FLAG_FQS) {
> >>                 raw_spin_lock_irq(&rnp->lock);
> >>                 smp_mb__after_unlock_lock();
> >> -               ACCESS_ONCE(rsp->gp_flags) &= ~RCU_GP_FLAG_FQS;
> >> +               ACCESS_ONCE(rsp->gp_flags) = rsp->gp_flags & ~RCU_GP_FLAG_FQS;
> >
> > Here we need ACCESS_ONCE() around both instances of rsp->gp_flags.
> 
> I see that all accesses of gp_flags are wrapped with ACCESS_ONCE(). Is
> there any reason why we can't declare it as 'volatile' and not use
> ACCESS_ONCE everywhere?

The explicit ACCESS_ONCE() serves as a good documentation aid.

							Thanx, Paul

