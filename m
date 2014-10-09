Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757394AbaJIPBI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Oct 2014 11:01:08 -0400
Received: from mx1.redhat.com ([209.132.183.28]:13023 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752514AbaJIPA7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Oct 2014 11:00:59 -0400
Date: Thu, 9 Oct 2014 16:57:26 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Kirill Tkhai <tkhai@yandex.ru>
Cc: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>,
        Steven Rostedt <rostedt@goodmis.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 1/2] sched: schedule_tail() should disable preemption
Message-ID: <20141009145726.GA5604@redhat.com>
References: <20141007195046.GA28002@redhat.com> <20141008080016.GB10832@worktop.programming.kicks-ass.net> <20141008183302.GA17495@redhat.com> <20141008183326.GB17495@redhat.com> <20141008193644.GA32055@redhat.com> <1412804248.24248.1.camel@yandex.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1412804248.24248.1.camel@yandex.ru>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/09, Kirill Tkhai wrote:
>
> В Ср, 08/10/2014 в 21:36 +0200, Oleg Nesterov пишет:
> > @@ -2277,15 +2277,14 @@ static inline void post_schedule(struct rq *rq)
> >  asmlinkage __visible void schedule_tail(struct task_struct *prev)
> >  	__releases(rq->lock)
> >  {
> > -	struct rq *rq = this_rq();
> > +	struct rq *rq;
> >  
> > +	/* finish_task_switch() drops rq->lock and enables preemtion */
> > +	preempt_disable();
> 
> Maybe, the code would look simpler if we change
> init_task_preempt_count() and create new tasks
> with preempt_count() == 2, so this preempt_disable()
> won't be necessary. But it's more or less subjectively.

Yes, yes, I thought about the same.

Except I think we should kill init_task_preempt_count() and change
schedule_tail()

	-	preempt_disable();
	+	preempt_count_set(PREEMPT_DISABLED + 1);

but first we need to remove ->saved_preempt_count.

> Reviewed-by: Kirill Tkhai <ktkhai@parallels.com>

Thanks!

Oleg.

