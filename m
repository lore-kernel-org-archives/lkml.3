Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755515AbaFKNn5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jun 2014 09:43:57 -0400
Received: from forward4m.mail.yandex.net ([37.140.138.4]:49606 "EHLO
	forward4m.mail.yandex.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751328AbaFKNn4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jun 2014 09:43:56 -0400
From: Kirill Tkhai <tkhai@yandex.ru>
To: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@kernel.org>,
        Tkhai Kirill <ktkhai@parallels.com>
In-Reply-To: <20140611131536.GB21191@linux.vnet.ibm.com>
References: <20140611093417.27807.2288.stgit@tkhai>
	 <1402480330.32126.14.camel@tkhai>
	 <20140611112411.GA21191@linux.vnet.ibm.com>
	 <3732251402489254@web2m.yandex.ru> <20140611131536.GB21191@linux.vnet.ibm.com>
Subject: Re: [PATCH 1/2] sched: Rework migrate_tasks()
MIME-Version: 1.0
Message-Id: <4032471402494232@web2m.yandex.ru>
X-Mailer: Yamail [ http://yandex.ru ] 5.0
Date: Wed, 11 Jun 2014 17:43:52 +0400
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=koi8-r
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



11.06.2014, 17:15, "Srikar Dronamraju" <srikar@linux.vnet.ibm.com>:
>>> š* Kirill Tkhai <ktkhai@parallels.com> [2014-06-11 13:52:10]:
>>>> ššCurrently migrate_tasks() skips throttled tasks,
>>>> ššbecause they are not pickable by pick_next_task().
>>> šBefore migrate_tasks() is called, we do call set_rq_offline(), in
>>> šmigration_call().
>>>
>>> šShouldnt this take care of unthrottling the tasks and making sure that
>>> šthey can be picked by pick_next_task().
>> šIf we do this separate for every class, we'll have to do this 3 times.
>> šFurthermore, deadline class does not have a list of throttled tasks.
>> šSo we'll have to the same as I did: to lock tasklist_lock and to iterate
>> šthrow all of the tasks in the system just to found deadline tasks.
>
> I think you misread my comment.
>
> Currently migrate_task() gets called from migration_call() and in the
> migration_call() before migrate_tasks(), set_rq_offline() should put
> tasks back using unthrottle_cfs_rq().
>
> So my question is: Why are these tasks not getting unthrottled
> through we are calling set_rq_offline? To me set_rq_offline is
> calling the actual sched class routines to do the needful.
>
> I can understand about deadline tasks, because we don't have a deadline
> But thats the only tasks that we need to fix.

Hm, I tested that on fair class tasks. They used to disappear from
/proc/sched_debug and used to hang. I'll check all once again.

I'm agree with you, if set_rq_offline() already presents, we should use it.

/me went to clarify why it does not work in my test.

>>>> ššThese tasks stay on dead cpu even after they
>>>> ššbecomes unthrottled. They are not schedulable
>>>> šštill user manually changes their affinity or till
>>>> ššcpu becomes alive again.
>>> šIf we are still seeing tasks not being picked by pick_next_task(), then
>>> šcan it probably mean that rq->rd was NULL?
>> šUnthrottle functions dl_task_timer() and unthrottle_cfs_rq() put tasks and
>> šqueues back. They do not look at rq->rd.
>
> What I meant was only if rq->rd isn't set, then we don't call
> set_rq_offline, which seems very reasonable.
> --
> Thanks and Regards
> Srikar Dronamraju
