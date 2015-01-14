Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753119AbbANOSz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jan 2015 09:18:55 -0500
Received: from smtprelay0133.hostedemail.com ([216.40.44.133]:46312 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752504AbbANOSx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jan 2015 09:18:53 -0500
X-Session-Marker: 6E657665747340676F6F646D69732E6F7267
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,rostedt@goodmis.org,:::::::::::::,RULES_HIT:41:355:379:541:599:800:960:968:973:988:989:1260:1277:1311:1313:1314:1345:1359:1437:1515:1516:1518:1534:1542:1593:1594:1711:1730:1747:1777:1792:2198:2199:2393:2553:2559:2562:2731:2904:3138:3139:3140:3141:3142:3354:3622:3865:3867:3868:3870:3871:3872:3873:3874:4250:5007:6261:7875:8660:9010:10004:10400:10848:10967:11026:11232:11658:11914:12043:12050:12295:12296:12438:12517:12519:12740:13018:13019:13148:13161:13229:13230:13255:14096:14097:21080,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: kite72_12eb5a3973155
X-Filterd-Recvd-Size: 3342
Date: Wed, 14 Jan 2015 09:18:49 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Paul Gortmaker <paul.gortmaker@windriver.com>,
        linux-rt-users@vger.kernel.org, linux-kernel@vger.kernel.org,
        Thomas Gleixner <tglx@linutronix.de>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: Re: [PATCH 3/7] wait.[ch]: Introduce the simple waitqueue (swait)
 implementation
Message-ID: <20150114091849.501a0a72@gandalf.local.home>
In-Reply-To: <20150114103834.GN23965@worktop.programming.kicks-ass.net>
References: <1413591782-23453-1-git-send-email-paul.gortmaker@windriver.com>
	<1413591782-23453-4-git-send-email-paul.gortmaker@windriver.com>
	<20150114103834.GN23965@worktop.programming.kicks-ass.net>
X-Mailer: Claws Mail 3.11.1 (GTK+ 2.24.25; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 14 Jan 2015 11:38:34 +0100
Peter Zijlstra <peterz@infradead.org> wrote:

> 
> 
> So I had a look at this yesterday and came up with the below --
> completely untested etc.
> 
> Now in order to compile test I meant to convert the completion code and
> ran head first into complete_all; it uses spin_lock_irqsave() which
> means it can be used from IRQ context. Now if you look at
> __swake_up_all() you'll find a comment on how we cannot have this.
> 
> Now I can't remember how important that all was for RT but I figured I'd
> post it and let other people stare at it for a bit.
> 




> +/*
> + * Does not allow usage from IRQ disabled, since we must be able to
> + * release IRQs to guarantee bounded hold time.

Actually we (-rt people) don't care if it's done with irq disabled, as
long is it was disabled via spin_lock_irq*() and not
raw_spin_lock_irq() or local_irq_save/disable().

Because in that case, in -rt, irqs would not be disabled. We could add a
check in -rt that makes sure that's the case. I would think this is OK
to call from an interrupt handler as long as it is a thread in -rt.

But, we can keep this restriction for now and change it if we find that
the restriction is preventing us from using it someplace where its
needed for -rt.

> + */
> +void __swake_up_all(struct swait_queue_head *q, unsigned int state)
> +{
> +	struct swait_queue *curr, *next;
> +	LIST_HEAD(tmp);
> +
> +	__swait_wakeup_debug(q, state);
> +
> +	if (!swait_active(q))
> +		return;
> +
> +	raw_spin_lock_irq(&q->lock);
> +	list_splice_init(&q->task_list, &tmp);
> +	while (!list_empty(&tmp)) {
> +		curr = list_first_entry(&tmp, typeof(curr), task_list);
> +
> +		wake_up_state(curr->task, state);
> +		list_del_init(&curr->task_list);

What happens if curr->task does not match state? We just removed it
from the list and never woke it up, didn't we?

-- Steve

> +
> +		if (list_empty(&tmp))
> +			break;
> +
> +		raw_spin_unlock_irq(&q->lock);
> +		raw_spin_lock_irq(&q->lock);
> +	}
> +	raw_spin_unlock_irq(&q->lock);
> +}
> +EXPORT_SYMBOL(__swake_up_all);
> +
