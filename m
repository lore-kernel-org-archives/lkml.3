Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752298AbaBLKXG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Feb 2014 05:23:06 -0500
Received: from merlin.infradead.org ([205.233.59.134]:60395 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751226AbaBLKXB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Feb 2014 05:23:01 -0500
Date: Wed, 12 Feb 2014 11:22:51 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Michael wang <wangyun@linux.vnet.ibm.com>
Cc: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        tglx@linutronix.de, linux-tip-commits@vger.kernel.org
Subject: Re: [tip:sched/core] sched: Push down pre_schedule() and
 idle_balance ()
Message-ID: <20140212102251.GD3545@laptop.programming.kicks-ass.net>
References: <tip-a8k6vvaebtn64nie345kx1je@git.kernel.org>
 <52FB1411.1040305@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <52FB1411.1040305@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 12, 2014 at 02:26:25PM +0800, Michael wang wrote:
> Hi, Peter
> 
> On 02/11/2014 08:17 PM, tip-bot for Peter Zijlstra wrote:
> [snip]
> > +
> > +idle:
> > +#ifdef CONFIG_SMP
> > +	idle_enter_fair(rq);
> > +	/*
> > +	 * We must set idle_stamp _before_ calling idle_balance(), such that we
> > +	 * measure the duration of idle_balance() as idle time.
> > +	 */
> > +	rq->idle_stamp = rq_clock(rq);
> > +	if (idle_balance(rq)) { /* drops rq->lock */
> 
> Since idle_balance() will release the rq lock, will it happen that some
> rt or dl tasks was waken up and enqueued before it hold the lock again?
> 
> Should we recheck 'rq->nr_running == rq->cfs.h_nr_running' here before
> goto pick fair entity to make sure the priority?
> 
> May be like:
> 
> if (idle_balance(rq) &&
> 	rq->nr_running == rq->cfs.h_nr_running)

Yes I think there might be a problem here because of how we re-arranged
things. Let me brew of pot of tea and try to actually wake up.

I suspect we might be good if we clear the need_resched flags before
calling pick_next_task. Then any RT/DL task that gets moved here will
set need resched, and we'll retry the pick_next_task loop.
