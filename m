Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753904Ab3J3LT5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Oct 2013 07:19:57 -0400
Received: from e39.co.us.ibm.com ([32.97.110.160]:55916 "EHLO
	e39.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751644Ab3J3LTz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Oct 2013 07:19:55 -0400
Date: Wed, 30 Oct 2013 04:18:49 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: Steven Rostedt <rostedt@goodmis.org>,
        Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org,
        Dipankar Sarma <dipankar@in.ibm.com>
Subject: Re: [PATCH 2/8] rcu: remove irq/softirq context check in
 rcu_read_unlock_special()
Message-ID: <20131030111849.GB19599@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <1375871104-10688-1-git-send-email-laijs@cn.fujitsu.com>
 <1375871104-10688-3-git-send-email-laijs@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1375871104-10688-3-git-send-email-laijs@cn.fujitsu.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13103011-9332-0000-0000-000001F984E9
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 07, 2013 at 06:24:58PM +0800, Lai Jiangshan wrote:
> After patch 10f39bb1, "special & RCU_READ_UNLOCK_BLOCKED" can't be true
> in irq nor softirq.(due to RCU_READ_UNLOCK_BLOCKED can only be set
> when preemption)
> 
> Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
> ---
>  kernel/rcutree_plugin.h |    6 ------
>  1 files changed, 0 insertions(+), 6 deletions(-)
> 
> diff --git a/kernel/rcutree_plugin.h b/kernel/rcutree_plugin.h
> index 8fd947e..54f7e45 100644
> --- a/kernel/rcutree_plugin.h
> +++ b/kernel/rcutree_plugin.h
> @@ -361,12 +361,6 @@ void rcu_read_unlock_special(struct task_struct *t)
>  		rcu_preempt_qs(smp_processor_id());
>  	}
> 
> -	/* Hardware IRQ handlers cannot block. */
> -	if (in_irq() || in_serving_softirq()) {
> -		local_irq_restore(flags);
> -		return;
> -	}
> -

Good point, it is time to relax the redundant checking.  Paranoid that
I am, I took an intermediate position, wrapping a WARN_ON_ONCE() around
the check as follows:

	if (WARN_ON_ONCE(in_irq() || in_serving_softirq())) {
		local_irq_restore(flags);
		return;
	}

If this warning never triggers over a period of some time, we can remove
it entirely.

I have queued this for 3.14 with your Signed-off-by.  Please let me know
if you have any objections.

							Thanx, Paul

>  	/* Clean up if blocked during RCU read-side critical section. */
>  	if (special & RCU_READ_UNLOCK_BLOCKED) {
>  		t->rcu_read_unlock_special &= ~RCU_READ_UNLOCK_BLOCKED;
> -- 
> 1.7.4.4
> 

