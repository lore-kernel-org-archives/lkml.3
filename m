Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932468AbaEEN1g (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2014 09:27:36 -0400
Received: from mx1.redhat.com ([209.132.183.28]:24782 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932272AbaEEN1f (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2014 09:27:35 -0400
Date: Mon, 5 May 2014 15:26:59 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>,
        linux-kernel@vger.kernel.org
Subject: Re: lock_task_sighand() && rcu_boost()
Message-ID: <20140505132659.GA17996@redhat.com>
References: <20140503161133.GA8838@redhat.com> <20140504180145.GC8754@linux.vnet.ibm.com> <20140504191757.GA11319@redhat.com> <20140504223804.GF8754@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140504223804.GF8754@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/04, Paul E. McKenney wrote:
>
> --- a/include/linux/rcupdate.h
> +++ b/include/linux/rcupdate.h
> @@ -884,6 +884,27 @@ static inline void rcu_read_lock(void)
>  /**
>   * rcu_read_unlock() - marks the end of an RCU read-side critical section.
>   *
> + * In most situations, rcu_read_unlock() is immune from deadlock.
> + * However, in kernels built with CONFIG_RCU_BOOST, rcu_read_unlock()
> + * is responsible for deboosting, which it does via rt_mutex_unlock().
> + * However, this function acquires the scheduler's runqueue and
> + * priority-inheritance spinlocks.  Thus, deadlock could result if the
> + * caller of rcu_read_unlock() already held one of these locks or any lock
> + * acquired while holding them.
> + *
> + * That said, RCU readers are never priority boosted unless they were
> + * preempted.  Therefore, one way to avoid deadlock is to make sure
> + * that preemption never happens within any RCU read-side critical
> + * section whose outermost rcu_read_unlock() is called with one of
> + * rt_mutex_unlock()'s locks held.
> + *
> + * Given that the set of locks acquired by rt_mutex_unlock() might change
> + * at any time, a somewhat more future-proofed approach is to make sure that
> + * that preemption never happens within any RCU read-side critical
> + * section whose outermost rcu_read_unlock() is called with one of
> + * irqs disabled.  This approach relies on the fact that rt_mutex_unlock()
> + * currently only acquires irq-disabled locks.
> + *
>   * See rcu_read_lock() for more information.
>   */
>  static inline void rcu_read_unlock(void)

Great! And I agree with "might change at any time" part.

I'll update lock_task_sighand() after you push this change (or please feel
free to do this yourself). Cleanup is not that important, of course, but a
short comment referring the documentation above can help another reader to
understand the "unnecessary" local_irq_save/preempt_disable calls.

Thanks Paul.

Oleg.

