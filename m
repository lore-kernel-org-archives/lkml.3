Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751704Ab3LLLpF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Dec 2013 06:45:05 -0500
Received: from merlin.infradead.org ([205.233.59.134]:59024 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751464Ab3LLLpC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Dec 2013 06:45:02 -0500
Date: Thu, 12 Dec 2013 12:44:47 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Paul Gortmaker <paul.gortmaker@windriver.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@kernel.org>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Steven Rostedt <rostedt@goodmis.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] wait-simple: Introduce the simple waitqueue
 implementation
Message-ID: <20131212114447.GH21999@twins.programming.kicks-ass.net>
References: <1386810399-8973-1-git-send-email-paul.gortmaker@windriver.com>
 <1386810399-8973-2-git-send-email-paul.gortmaker@windriver.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1386810399-8973-2-git-send-email-paul.gortmaker@windriver.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 11, 2013 at 08:06:37PM -0500, Paul Gortmaker wrote:
> +/* Adds w to head->task_list. Must be called with head->lock locked. */
> +static inline void __swait_enqueue(struct swait_queue_head *head,
> +				   struct swaiter *w)
> +{
> +	list_add(&w->node, &head->task_list);
> +	/* We can't let the condition leak before the setting of head */
> +	smp_mb();
> +}

> +unsigned int
> +__swake_up_locked(struct swait_queue_head *head, unsigned int state,
> +		  unsigned int num)
> +{
> +	struct swaiter *curr, *next;
> +	int woken = 0;
> +
> +	list_for_each_entry_safe(curr, next, &head->task_list, node) {
> +		if (wake_up_state(curr->task, state)) {
> +			__swait_dequeue(curr);
> +			/*
> +			 * The waiting task can free the waiter as
> +			 * soon as curr->task = NULL is written,
> +			 * without taking any locks. A memory barrier
> +			 * is required here to prevent the following
> +			 * store to curr->task from getting ahead of
> +			 * the dequeue operation.
> +			 */
> +			smp_wmb();
> +			curr->task = NULL;
> +			if (++woken == num)
> +				break;
> +		}
> +	}
> +	return woken;
> +}

Are these two barriers matched or are they both unmatched and thus
probabyl wrong?

In any case the comments need updating to be more explicit.
