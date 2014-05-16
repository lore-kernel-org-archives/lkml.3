Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757303AbaEPQ5i (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 May 2014 12:57:38 -0400
Received: from mail-pb0-f51.google.com ([209.85.160.51]:53362 "EHLO
	mail-pb0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754536AbaEPQ5g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 May 2014 12:57:36 -0400
From: bsegall@google.com
To: Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] sched: fix exec_start/task_hot on migrated tasks
References: <20140515225920.7179.13924.stgit@sword-of-the-dawn.mtv.corp.google.com>
	<20140516102043.GT30445@twins.programming.kicks-ass.net>
Date: Fri, 16 May 2014 09:57:34 -0700
In-Reply-To: <20140516102043.GT30445@twins.programming.kicks-ass.net> (Peter
	Zijlstra's message of "Fri, 16 May 2014 12:20:43 +0200")
Message-ID: <xm268uq14q69.fsf@sword-of-the-dawn.mtv.corp.google.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Peter Zijlstra <peterz@infradead.org> writes:

> On Thu, May 15, 2014 at 03:59:20PM -0700, Ben Segall wrote:
>> task_hot checks exec_start on any runnable task, but if it has been
>> migrated since the it last ran, then exec_start is a clock_task from
>> another cpu. If the old cpu's clock_task was sufficiently far ahead of
>> this cpu's then the task will not be considered for another migration
>> until it has run. Instead reset exec_start whenever a task is migrated,
>> since it is presumably no longer hot anyway.
>> 
>> Signed-off-by: Ben Segall <bsegall@google.com>
>> ---
>>  kernel/sched/fair.c |    3 +++
>>  1 file changed, 3 insertions(+)
>> 
>> diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
>> index 28ccf50..9f8dfeb 100644
>> --- a/kernel/sched/fair.c
>> +++ b/kernel/sched/fair.c
>> @@ -4544,6 +4544,9 @@ migrate_task_rq_fair(struct task_struct *p, int next_cpu)
>>  		atomic_long_add(se->avg.load_avg_contrib,
>>  						&cfs_rq->removed_load);
>>  	}
>> +
>> +	/* We have migrated, no longer consider this task hot */
>> +	se.exec_start = 0;
>
> se->exec_start compiles loads better
Welp. Indeed it does.


From: Ben Segall <bsegall@google.com>
Date: Thu, 15 May 2014 15:38:10 -0700
Subject: [PATCH] sched: fix exec_start/task_hot on migrated tasks

task_hot checks exec_start on any runnable task, but if it has been
migrated since the it last ran, then exec_start is a clock_task from
another cpu. If the old cpu's clock_task was sufficiently far ahead of
this cpu's then the task will not be considered for another migration
until it has run. Instead reset exec_start whenever a task is migrated,
since it is presumably no longer hot anyway.

Signed-off-by: Ben Segall <bsegall@google.com>
---
 kernel/sched/fair.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index 28ccf50..dd3fa14 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -4544,6 +4544,9 @@ migrate_task_rq_fair(struct task_struct *p, int next_cpu)
                atomic_long_add(se->avg.load_avg_contrib,
                                                &cfs_rq->removed_load);
        }
+
+       /* We have migrated, no longer consider this task hot */
+       se->exec_start = 0;
 }
 #endif /* CONFIG_SMP */
 
