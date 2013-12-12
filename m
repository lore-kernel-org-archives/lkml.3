Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751968Ab3LLLUh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Dec 2013 06:20:37 -0500
Received: from merlin.infradead.org ([205.233.59.134]:58181 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751702Ab3LLLUf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Dec 2013 06:20:35 -0500
Date: Thu, 12 Dec 2013 12:20:20 +0100
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
Message-ID: <20131212112020.GO3694@twins.programming.kicks-ass.net>
References: <1386810399-8973-1-git-send-email-paul.gortmaker@windriver.com>
 <1386810399-8973-2-git-send-email-paul.gortmaker@windriver.com>
 <20131212111809.GF21999@twins.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131212111809.GF21999@twins.programming.kicks-ass.net>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 12, 2013 at 12:18:09PM +0100, Peter Zijlstra wrote:
> On Wed, Dec 11, 2013 at 08:06:37PM -0500, Paul Gortmaker wrote:
> > +unsigned int
> > +__swake_up_locked(struct swait_queue_head *head, unsigned int state,
> > +		  unsigned int num)
> > +{
> > +	struct swaiter *curr, *next;
> > +	int woken = 0;
> > +
> > +	list_for_each_entry_safe(curr, next, &head->task_list, node) {
> > +		if (wake_up_state(curr->task, state)) {
> > +			__swait_dequeue(curr);
> > +			/*
> > +			 * The waiting task can free the waiter as
> > +			 * soon as curr->task = NULL is written,
> > +			 * without taking any locks. A memory barrier
> > +			 * is required here to prevent the following
> > +			 * store to curr->task from getting ahead of
> > +			 * the dequeue operation.
> > +			 */
> > +			smp_wmb();
> > +			curr->task = NULL;
> > +			if (++woken == num)
> > +				break;
> > +		}
> > +	}
> > +	return woken;
> > +}
> > +
> > +unsigned int
> > +__swake_up(struct swait_queue_head *head, unsigned int state, unsigned int num)
> > +{
> > +	unsigned long flags;
> > +	int woken;
> > +
> > +	if (!swaitqueue_active(head))
> > +		return 0;
> > +
> > +	raw_spin_lock_irqsave(&head->lock, flags);
> > +	woken = __swake_up_locked(head, state, num);
> > +	raw_spin_unlock_irqrestore(&head->lock, flags);
> > +	return woken;
> > +}
> > +EXPORT_SYMBOL(__swake_up);
> 
> Urgh, fail. Do not put unbounded loops in raw_spin_lock.
> 
> I think I posted a patch a while back to cure this.

tada!

lkml.kernel.org/r/20131004145625.GN3081@twins.programming.kicks-ass.net
