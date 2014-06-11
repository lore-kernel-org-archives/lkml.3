Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755366AbaFKMVA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jun 2014 08:21:00 -0400
Received: from forward3m.mail.yandex.net ([37.140.138.3]:37416 "EHLO
	forward3m.mail.yandex.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751328AbaFKMU7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jun 2014 08:20:59 -0400
From: Kirill Tkhai <tkhai@yandex.ru>
To: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@kernel.org>,
        Tkhai Kirill <ktkhai@parallels.com>
In-Reply-To: <20140611112411.GA21191@linux.vnet.ibm.com>
References: <20140611093417.27807.2288.stgit@tkhai>
	 <1402480330.32126.14.camel@tkhai> <20140611112411.GA21191@linux.vnet.ibm.com>
Subject: Re: [PATCH 1/2] sched: Rework migrate_tasks()
MIME-Version: 1.0
Message-Id: <3732251402489254@web2m.yandex.ru>
X-Mailer: Yamail [ http://yandex.ru ] 5.0
Date: Wed, 11 Jun 2014 16:20:54 +0400
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=koi8-r
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

11.06.2014, 15:24, "Srikar Dronamraju" <srikar@linux.vnet.ibm.com>:
> * Kirill Tkhai <ktkhai@parallels.com> [2014-06-11 13:52:10]:
>> šCurrently migrate_tasks() skips throttled tasks,
>> šbecause they are not pickable by pick_next_task().
>
> Before migrate_tasks() is called, we do call set_rq_offline(), in
> migration_call().
>
> Shouldnt this take care of unthrottling the tasks and making sure that
> they can be picked by pick_next_task().

If we do this separate for every class, we'll have to do this 3 times.
Furthermore, deadline class does not have a list of throttled tasks.
So we'll have to the same as I did: to lock tasklist_lock and to iterate
throw all of the tasks in the system just to found deadline tasks.

>> šThese tasks stay on dead cpu even after they
>> šbecomes unthrottled. They are not schedulable
>> štill user manually changes their affinity or till
>> šcpu becomes alive again.
>
> If we are still seeing tasks not being picked by pick_next_task(), then
> can it probably mean that rq->rd was NULL?

Unthrottle functions dl_task_timer() and unthrottle_cfs_rq() put tasks and
queues back. They do not look at rq->rd.

do_sched_rt_period_timer() does not unthrottle dead queue at all (they
are excluded from rd).

Thanks,
Kirill
