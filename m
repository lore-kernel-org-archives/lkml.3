Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751821AbaJPJv6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Oct 2014 05:51:58 -0400
Received: from relay.parallels.com ([195.214.232.42]:41476 "EHLO
	relay.parallels.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751241AbaJPJv5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Oct 2014 05:51:57 -0400
Message-ID: <1413453115.24793.73.camel@tkhai>
Subject: Re: [PATCH RFC] sched: Revert delayed_put_task_struct() and fix use
 after free
From: Kirill Tkhai <ktkhai@parallels.com>
To: Peter Zijlstra <peterz@infradead.org>
CC: Kirill Tkhai <tkhai@yandex.ru>, Oleg Nesterov <oleg@redhat.com>,
        <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@redhat.com>,
        "Vladimir Davydov" <vdavydov@parallels.com>
Date: Thu, 16 Oct 2014 13:51:55 +0400
In-Reply-To: <1413453002.24793.72.camel@tkhai>
References: <1413376300.24793.55.camel@tkhai>
	 <20141015150641.GA2755@redhat.com> <20141015194044.GA4557@redhat.com>
	 <543EEB1F.3040900@yandex.ru> <20141016075950.GC7369@worktop.fdxtended.com>
	 <1413447404.24793.67.camel@tkhai>
	 <20141016094333.GJ7369@worktop.fdxtended.com>
	 <1413453002.24793.72.camel@tkhai>
Organization: Parallels
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.8.5-2+b3 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.30.26.172]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

В Чт, 16/10/2014 в 13:50 +0400, Kirill Tkhai пишет:
> В Чт, 16/10/2014 в 11:43 +0200, Peter Zijlstra пишет:
> > On Thu, Oct 16, 2014 at 12:16:44PM +0400, Kirill Tkhai wrote:
> > > В Чт, 16/10/2014 в 09:59 +0200, Peter Zijlstra пишет:
> > > > On Thu, Oct 16, 2014 at 01:46:07AM +0400, Kirill Tkhai wrote:
> > > > > > --- x/kernel/sched/fair.c
> > > > > > +++ x/kernel/sched/fair.c
> > > > > > @@ -1165,7 +1165,7 @@ static void task_numa_compare(struct tas
> > > > > >  
> > > > > >  	rcu_read_lock();
> > > > > >  	cur = ACCESS_ONCE(dst_rq->curr);
> > > > > > -	if (cur->pid == 0) /* idle */
> > > > > > +	if (is_idle_task(cur) || (curr->flags & PF_EXITING))
> > > > > >  		cur = NULL;
> > > > > >  
> > > > > >  	/*
> > > > > > 
> > > > > 
> > > > > Looks like, we have to use the same fix for task_numa_group().
> > > > 
> > > > Don't think so, task_numa_group() is only called from task_numa_fault()
> > > > which is on 'current' and neither idle and PF_EXITING should be
> > > > faulting.
> > > 
> > > Isn't task_numa_group() fully preemptible?
> > 
> > Not seeing how that is relevant.
> > 
> > > It seems cpu_rq(cpu)->curr is not always equal to p.
> > 
> > It should be afaict:
> > 
> >  task_numa_fault()
> >   p = current;
> > 
> >   task_numa_group(p, ..);
> > 
> > And like said, idle tasks and PF_EXITING task should never get (numa)
> > faults for they should never be touching userspace.
> 
> I mean p can be moved to other cpu.
> 
> tsk = ACCESS_ONCE(cpu_rq(cpu)->curr);
> 
> tsk is not p, (i.e current) here.

Maybe I undestand wrong and preemption is disabled in memory fault?


