Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753906AbaGHUfJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jul 2014 16:35:09 -0400
Received: from e33.co.us.ibm.com ([32.97.110.151]:50706 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753541AbaGHUfH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jul 2014 16:35:07 -0400
Date: Tue, 8 Jul 2014 13:35:00 -0700
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
Message-ID: <20140708203459.GU4603@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20140707223756.GA7187@linux.vnet.ibm.com>
 <1404772701-8804-1-git-send-email-paulmck@linux.vnet.ibm.com>
 <1404772701-8804-6-git-send-email-paulmck@linux.vnet.ibm.com>
 <CAJhHMCBnctjpo1Kdi71-6mEiTEnBfOhMTZC1gTsEx42z-UL=Bw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAJhHMCBnctjpo1Kdi71-6mEiTEnBfOhMTZC1gTsEx42z-UL=Bw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14070820-0928-0000-0000-000003369863
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 08, 2014 at 12:59:46PM -0400, Pranith Kumar wrote:
> Hi Paul,
> 
> On Mon, Jul 7, 2014 at 6:38 PM, Paul E. McKenney
> <paulmck@linux.vnet.ibm.com> wrote:
> > From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
> >
> > RCU contains code of the following forms:
> >
> >         ACCESS_ONCE(x)++;
> >         ACCESS_ONCE(x) += y;
> >         ACCESS_ONCE(x) -= y;
> >
> > Now these constructs do operate correctly, but they really result in a
> > pair of volatile accesses, one to do the load and another to do the store.
> > This can be confusing, as the casual reader might well assume that (for
> > example) gcc might generate a memory-to-memory add instruction for each
> > of these three cases.  In fact, gcc will do no such thing.  Also, there
> > is a good chance that the kernel will move to separate load and store
> > variants of ACCESS_ONCE(), and constructs like the above could easily
> > confuse both people and scripts attempting to make that sort of change.
> > Finally, most of RCU's read-modify-write uses of ACCESS_ONCE() really
> > only need the store to be volatile, so that the read-modify-write form
> > might be misleading.
> >
> > This commit therefore changes the above forms in RCU so that each instance
> > of ACCESS_ONCE() either does a load or a store, but not both.  In a few
> > cases, ACCESS_ONCE() was not critical, for example, for maintaining
> > statisitics.  In these cases, ACCESS_ONCE() has been dispensed with
> > entirely.
> >
> 
> Is there any reason why |=, &= cannot be replaced similarly? Also
> there are a few more in tree_plugin.h. Please find patch below:

Good catch, I clearly didn't include enough patterns in my search.

But please see below.  And please rebase onto branch rcu/dev in
git://git.kernel.org/pub/scm/linux/kernel/git/paulmck/linux-rcu.git,
as this patch set does not apply.

							Thanx, Paul

> Signed-off-by: Pranith Kumar <bobby.prani@gmail.com>
> ---
> diff --git a/kernel/rcu/tree.c b/kernel/rcu/tree.c
> index dac6d20..f500395 100644
> --- a/kernel/rcu/tree.c
> +++ b/kernel/rcu/tree.c
> @@ -1700,7 +1700,7 @@ static int rcu_gp_fqs(struct rcu_state *rsp, int
> fqs_state_in)
>         if (ACCESS_ONCE(rsp->gp_flags) & RCU_GP_FLAG_FQS) {
>                 raw_spin_lock_irq(&rnp->lock);
>                 smp_mb__after_unlock_lock();
> -               ACCESS_ONCE(rsp->gp_flags) &= ~RCU_GP_FLAG_FQS;
> +               ACCESS_ONCE(rsp->gp_flags) = rsp->gp_flags & ~RCU_GP_FLAG_FQS;

Here we need ACCESS_ONCE() around both instances of rsp->gp_flags.

>                 raw_spin_unlock_irq(&rnp->lock);
>         }
>         return fqs_state;
> @@ -2514,7 +2514,7 @@ static void force_quiescent_state(struct rcu_state *rsp)
>                 raw_spin_unlock_irqrestore(&rnp_old->lock, flags);
>                 return;  /* Someone beat us to it. */
>         }
> -       ACCESS_ONCE(rsp->gp_flags) |= RCU_GP_FLAG_FQS;
> +       ACCESS_ONCE(rsp->gp_flags) = rsp->gp_flags | RCU_GP_FLAG_FQS;

Same here.

>         raw_spin_unlock_irqrestore(&rnp_old->lock, flags);
>         wake_up(&rsp->gp_wq);  /* Memory barrier implied by wake_up() path. */
>  }
> diff --git a/kernel/rcu/tree_plugin.h b/kernel/rcu/tree_plugin.h
> index 1a4ab26..752d382 100644
> --- a/kernel/rcu/tree_plugin.h
> +++ b/kernel/rcu/tree_plugin.h
> @@ -897,7 +897,8 @@ void synchronize_rcu_expedited(void)
> 
>         /* Clean up and exit. */
>         smp_mb(); /* ensure expedited GP seen before counter increment. */
> -       ACCESS_ONCE(sync_rcu_preempt_exp_count)++;
> +       ACCESS_ONCE(sync_rcu_preempt_exp_count) =
> +                                       sync_rcu_preempt_exp_count + 1;

This one is OK as is because this code path is the only thing that
updates sync_rcu_preempt_exp_count.

>  unlock_mb_ret:
>         mutex_unlock(&sync_rcu_preempt_exp_mutex);
>  mb_ret:
> @@ -2307,8 +2308,9 @@ static int rcu_nocb_kthread(void *arg)
>                         list = next;
>                 }
>                 trace_rcu_batch_end(rdp->rsp->name, c, !!list, 0, 0, 1);
> -               ACCESS_ONCE(rdp->nocb_p_count) -= c;
> -               ACCESS_ONCE(rdp->nocb_p_count_lazy) -= cl;
> +               ACCESS_ONCE(rdp->nocb_p_count) = rdp->nocb_p_count - c;
> +               ACCESS_ONCE(rdp->nocb_p_count_lazy) =
> +                                               rdp->nocb_p_count_lazy - cl;

Same here, no other code path updates ->nocb_p_count_lazy.

>                 rdp->n_nocbs_invoked += c;
>         }
>         return 0;
> 
> -- 
> Pranith
> 

