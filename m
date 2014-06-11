Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755620AbaFKNPp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jun 2014 09:15:45 -0400
Received: from e23smtp08.au.ibm.com ([202.81.31.141]:56827 "EHLO
	e23smtp08.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753256AbaFKNPo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jun 2014 09:15:44 -0400
Date: Wed, 11 Jun 2014 18:45:36 +0530
From: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
To: Kirill Tkhai <tkhai@yandex.ru>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@kernel.org>,
        Tkhai Kirill <ktkhai@parallels.com>
Subject: Re: [PATCH 1/2] sched: Rework migrate_tasks()
Message-ID: <20140611131536.GB21191@linux.vnet.ibm.com>
Reply-To: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
References: <20140611093417.27807.2288.stgit@tkhai>
 <1402480330.32126.14.camel@tkhai>
 <20140611112411.GA21191@linux.vnet.ibm.com>
 <3732251402489254@web2m.yandex.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <3732251402489254@web2m.yandex.ru>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14061113-5140-0000-0000-00000548D518
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > * Kirill Tkhai <ktkhai@parallels.com> [2014-06-11 13:52:10]:
> >>  Currently migrate_tasks() skips throttled tasks,
> >>  because they are not pickable by pick_next_task().
> >
> > Before migrate_tasks() is called, we do call set_rq_offline(), in
> > migration_call().
> >
> > Shouldnt this take care of unthrottling the tasks and making sure that
> > they can be picked by pick_next_task().
>
> If we do this separate for every class, we'll have to do this 3 times.
> Furthermore, deadline class does not have a list of throttled tasks.
> So we'll have to the same as I did: to lock tasklist_lock and to iterate
> throw all of the tasks in the system just to found deadline tasks.
>

I think you misread my comment.

Currently migrate_task() gets called from migration_call() and in the
migration_call() before migrate_tasks(), set_rq_offline() should put
tasks back using unthrottle_cfs_rq().

So my question is: Why are these tasks not getting unthrottled
through we are calling set_rq_offline? To me set_rq_offline is
calling the actual sched class routines to do the needful.

I can understand about deadline tasks, because we don't have a deadline
But thats the only tasks that we need to fix.

> >>  These tasks stay on dead cpu even after they
> >>  becomes unthrottled. They are not schedulable
> >>  till user manually changes their affinity or till
> >>  cpu becomes alive again.
> >
> > If we are still seeing tasks not being picked by pick_next_task(), then
> > can it probably mean that rq->rd was NULL?
>
> Unthrottle functions dl_task_timer() and unthrottle_cfs_rq() put tasks and
> queues back. They do not look at rq->rd.

What I meant was only if rq->rd isn't set, then we don't call
set_rq_offline, which seems very reasonable.
--
Thanks and Regards
Srikar Dronamraju

