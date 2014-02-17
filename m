Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752191AbaBQLYg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Feb 2014 06:24:36 -0500
Received: from merlin.infradead.org ([205.233.59.134]:38305 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751254AbaBQLYf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Feb 2014 06:24:35 -0500
Date: Mon, 17 Feb 2014 12:24:20 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Michael wang <wangyun@linux.vnet.ibm.com>
Cc: Ingo Molnar <mingo@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Juri Lelli <juri.lelli@gmail.com>
Subject: Re: [RFC PATCH] sched: make sure sched-priority after invoke
 idle_balance()
Message-ID: <20140217112420.GD15586@twins.programming.kicks-ass.net>
References: <52FDA18D.40100@linux.vnet.ibm.com>
 <20140214123845.GI27965@twins.programming.kicks-ass.net>
 <53018284.5070408@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <53018284.5070408@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 17, 2014 at 11:31:16AM +0800, Michael wang wrote:
> >  pick_next_task(struct rq *rq, struct task_struct *prev)
> >  {
> > -	const struct sched_class *class;
> > +	const struct sched_class *class = &fair_sched_class;
> >  	struct task_struct *p;
> > 
> >  	/*
> >  	 * Optimization: we know that if all tasks are in
> >  	 * the fair class we can call that function directly:
> >  	 */
> > -	if (likely(prev->sched_class == &fair_sched_class &&
> > +	if (likely(prev->sched_class == class &&
> >  		   rq->nr_running == rq->cfs.h_nr_running)) {
> >  		p = fair_sched_class.pick_next_task(rq, prev);
> >  		if (likely(p))
> > -			return p;
> > +			goto got_task;
> 
> Since idle_balance() won't happen in the loop, may be we could use:
> 
> 	if p && p->sched_class == class
> 		return p
> 
> in here, let it fall down into the loop if p is idle, since that means
> we got RT/DL and will do this anyway, could save two jump work may be?
> (and may could combine some code below if so?)

Maybe; we'd have to look at whatever GCC does with it. But yes I think I
like the code better that way.

