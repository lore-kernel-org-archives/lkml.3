Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753911Ab3J3LCw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Oct 2013 07:02:52 -0400
Received: from e35.co.us.ibm.com ([32.97.110.153]:56739 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753501Ab3J3LCu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Oct 2013 07:02:50 -0400
Date: Wed, 30 Oct 2013 04:02:44 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: Steven Rostedt <rostedt@goodmis.org>,
        Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org,
        Dipankar Sarma <dipankar@in.ibm.com>
Subject: Re: [PATCH 1/8] rcu: add a warn to rcu_preempt_note_context_switch()
Message-ID: <20131030110244.GA19599@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <1375871104-10688-1-git-send-email-laijs@cn.fujitsu.com>
 <1375871104-10688-2-git-send-email-laijs@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1375871104-10688-2-git-send-email-laijs@cn.fujitsu.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13103011-6688-0000-0000-000002FD4BB4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 07, 2013 at 06:24:57PM +0800, Lai Jiangshan wrote:
> It is expected that _nesting == INT_MIN if _nesting < 0.
> Add a warning to it if something unexpected happen.
> 
> Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
> ---
>  kernel/rcutree_plugin.h |    1 +
>  1 files changed, 1 insertions(+), 0 deletions(-)
> 
> diff --git a/kernel/rcutree_plugin.h b/kernel/rcutree_plugin.h
> index 63098a5..8fd947e 100644
> --- a/kernel/rcutree_plugin.h
> +++ b/kernel/rcutree_plugin.h
> @@ -243,6 +243,7 @@ static void rcu_preempt_note_context_switch(int cpu)
>  				       : rnp->gpnum + 1);
>  		raw_spin_unlock_irqrestore(&rnp->lock, flags);
>  	} else if (t->rcu_read_lock_nesting < 0 &&
> +		   !WARN_ON_ONCE(t->rcu_read_lock_nesting != INT_MIN) &&

Finally getting back to this...

>From what I can see, this is safe right now because
->rcu_read_lock_nesting is incremented only in case of an interrupt, NMI,
or softirq interrupting the rcu_read_unlock() code path on the one hand,
and because the functions called from rcu_read_unlock_special() currently
disable interrupts before doing any rcu_read_lock()s.  With this in
mind, it is currently impossible to have a context switch occur within
an RCU read-side critical section that is invoked (either directly or
indirectly) from the portion of __rcu_read_unlock() that has negative
->rcu_read_lock_nesting.

But this could change should any part of the rt_mutex_unlock() code
called from rcu_read_unlock_special() were to do rcu_read_lock() before
disabling interrupts.  Is there any reason we should prohibit such a
pattern in rt_mutex_unlock()?

(For the record, I am currently OK prohibiting this pattern in
rcu_report_exp_rnp(), which is also called from rcu_read_unlock_special()
-- it seems unlikely that someone would use RCU to protect RCU's
expedited-grace-period data structures.)

							Thanx, Paul


>  		   t->rcu_read_unlock_special) {
> 
>  		/*
> -- 
> 1.7.4.4
> 

