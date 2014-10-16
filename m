Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751531AbaJPJni (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Oct 2014 05:43:38 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:39830 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750966AbaJPJng (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Oct 2014 05:43:36 -0400
Date: Thu, 16 Oct 2014 11:43:33 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Kirill Tkhai <ktkhai@parallels.com>
Cc: Kirill Tkhai <tkhai@yandex.ru>, Oleg Nesterov <oleg@redhat.com>,
        linux-kernel@vger.kernel.org, Ingo Molnar <mingo@redhat.com>,
        Vladimir Davydov <vdavydov@parallels.com>
Subject: Re: [PATCH RFC] sched: Revert delayed_put_task_struct() and fix use
 after free
Message-ID: <20141016094333.GJ7369@worktop.fdxtended.com>
References: <1413376300.24793.55.camel@tkhai>
 <20141015150641.GA2755@redhat.com>
 <20141015194044.GA4557@redhat.com>
 <543EEB1F.3040900@yandex.ru>
 <20141016075950.GC7369@worktop.fdxtended.com>
 <1413447404.24793.67.camel@tkhai>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1413447404.24793.67.camel@tkhai>
User-Agent: Mutt/1.5.22.1 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 16, 2014 at 12:16:44PM +0400, Kirill Tkhai wrote:
> В Чт, 16/10/2014 в 09:59 +0200, Peter Zijlstra пишет:
> > On Thu, Oct 16, 2014 at 01:46:07AM +0400, Kirill Tkhai wrote:
> > > > --- x/kernel/sched/fair.c
> > > > +++ x/kernel/sched/fair.c
> > > > @@ -1165,7 +1165,7 @@ static void task_numa_compare(struct tas
> > > >  
> > > >  	rcu_read_lock();
> > > >  	cur = ACCESS_ONCE(dst_rq->curr);
> > > > -	if (cur->pid == 0) /* idle */
> > > > +	if (is_idle_task(cur) || (curr->flags & PF_EXITING))
> > > >  		cur = NULL;
> > > >  
> > > >  	/*
> > > > 
> > > 
> > > Looks like, we have to use the same fix for task_numa_group().
> > 
> > Don't think so, task_numa_group() is only called from task_numa_fault()
> > which is on 'current' and neither idle and PF_EXITING should be
> > faulting.
> 
> Isn't task_numa_group() fully preemptible?

Not seeing how that is relevant.

> It seems cpu_rq(cpu)->curr is not always equal to p.

It should be afaict:

 task_numa_fault()
  p = current;

  task_numa_group(p, ..);

And like said, idle tasks and PF_EXITING task should never get (numa)
faults for they should never be touching userspace.
