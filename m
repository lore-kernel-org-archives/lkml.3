Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751254AbaJRVeb (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Oct 2014 17:34:31 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:38131 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750906AbaJRVea (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Oct 2014 17:34:30 -0400
Date: Sat, 18 Oct 2014 23:34:17 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Paul Gortmaker <paul.gortmaker@windriver.com>
Cc: linux-rt-users@vger.kernel.org, linux-kernel@vger.kernel.org,
        Thomas Gleixner <tglx@linutronix.de>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [PATCH 3/7] wait.[ch]: Introduce the simple waitqueue (swait)
 implementation
Message-ID: <20141018213417.GE23531@worktop.programming.kicks-ass.net>
References: <1413591782-23453-1-git-send-email-paul.gortmaker@windriver.com>
 <1413591782-23453-4-git-send-email-paul.gortmaker@windriver.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1413591782-23453-4-git-send-email-paul.gortmaker@windriver.com>
User-Agent: Mutt/1.5.22.1 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 17, 2014 at 08:22:58PM -0400, Paul Gortmaker wrote:
> @@ -75,6 +123,32 @@ static void __cwake_up_common(struct cwait_head *q, unsigned int mode,
>  	}
>  }
>  
> +static void __swake_up_common(struct swait_head *q, unsigned int mode,
> +			      int nr_exclusive)
> +{
> +	struct swait *curr, *next;
> +	int woken = 0;
> +
> +	list_for_each_entry_safe(curr, next, &q->task_list, node) {
> +		if (wake_up_state(curr->task, mode)) { /* <-- calls ttwu() */
> +			__remove_swait(q, curr);
> +			curr->task = NULL;
> +			/*
> +			 * The waiting task can free the waiter as
> +			 * soon as curr->task = NULL is written,
> +			 * without taking any locks. A memory barrier
> +			 * is required here to prevent the following
> +			 * store to curr->task from getting ahead of
> +			 * the dequeue operation.
> +			 */
> +			smp_wmb();
> +			if (++woken == nr_exclusive)
> +				break;
> +		}
> +
> +	}
> +}
> +
>  /**
>   * __cwake_up - wake up threads blocked on a waitqueue.
>   * @q: the complex waitqueue
> @@ -96,6 +170,19 @@ void __cwake_up(struct cwait_head *q, unsigned int mode, int nr_exclusive,
>  }
>  EXPORT_SYMBOL(__cwake_up);
>  
> +void __swake_up(struct swait_head *q, unsigned int mode, int nr_exclusive)
> +{
> +	unsigned long flags;
> +
> +	if (!swait_active(q))
> +		return;
> +
> +	raw_spin_lock_irqsave(&q->lock, flags);
> +	__swake_up_common(q, mode, nr_exclusive);
> +	raw_spin_unlock_irqrestore(&q->lock, flags);
> +}
> +EXPORT_SYMBOL(__swake_up);

Same comment as before, that is an unbounded loop in a non preemptible
section and therefore violates RT design principles.

We actually did talk about ways of fixing that.

Also, I'm not entirely sure we want to do the cwait thing, it looks
painful.
