Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753117AbaAQPXS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Jan 2014 10:23:18 -0500
Received: from merlin.infradead.org ([205.233.59.134]:37595 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753091AbaAQPXP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Jan 2014 10:23:15 -0500
Date: Fri, 17 Jan 2014 16:23:10 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Daniel Lezcano <daniel.lezcano@linaro.org>
Cc: mingo@kernel.org, linux-kernel@vger.kernel.org,
        linaro-kernel@lists.linaro.org, alex.shi@linaro.org
Subject: Re: [PATCH 4/4] sched: Idle task shortcut optimization
Message-ID: <20140117152310.GK11314@laptop.programming.kicks-ass.net>
References: <1389949444-14821-1-git-send-email-daniel.lezcano@linaro.org>
 <1389949444-14821-4-git-send-email-daniel.lezcano@linaro.org>
 <20140117142644.GI11314@laptop.programming.kicks-ass.net>
 <52D94705.1000407@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <52D94705.1000407@linaro.org>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 17, 2014 at 04:06:45PM +0100, Daniel Lezcano wrote:
> >I suppose we could write something like:
> >
> >struct task_struct *pick_next_task(struct rq *rq, struct task_struct *prev)
> >{
> >	const struct sched_class *class;
> >	struct task_struct *p;
> >
> >again:
> >	if (likely(rq->nr_running)) {
> >
> >		if (likely(rq->nr_running == rq->cfs.h_nr_running))
> >			return fair_sched_class.pick_next_task(rq, prev);
> >
> >		for_each_class(class) {
> >			p = class->pick_next_task(rq, prev);
> >			if (p)
> >				return p;
> >		}
> >	}
> >
> >	if (idle_balance(rq))
> >		goto again;
> >
> >	rq->idle_stamp = rq_clock(rq);
> >
> >	return idle_sched_class.pick_next_task(rq, prev);
> >}
> >
> >Which keeps idle_balance() before put_prev_task(), and by using
> >idle_sched_clas.pick_next_task() doesn't rape the idle class interface
> >like you did :-)
> 
> But put_prev_task is called before pick_next_task, so idle_balance() is
> called after now, no  ?

No, put_prev_task() is called by the pick_next_task() that returns a
task. So in the idle case above, the idle_sched_class.pick_next_task()
will do the required put_prev_task().
