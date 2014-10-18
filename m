Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751497AbaJRIdj (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Oct 2014 04:33:39 -0400
Received: from forward15.mail.yandex.net ([95.108.130.119]:43454 "EHLO
	forward15.mail.yandex.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750915AbaJRIdf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Oct 2014 04:33:35 -0400
From: Kirill Tkhai <tkhai@yandex.ru>
To: Oleg Nesterov <oleg@redhat.com>, Kirill Tkhai <ktkhai@parallels.com>,
        Peter Zijlstra <peterz@infradead.org>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@redhat.com>,
        Vladimir Davydov <vdavydov@parallels.com>
In-Reply-To: <4323181413620101@web21o.yandex.ru>
References: <1413376300.24793.55.camel@tkhai> <20141017213641.GB32576@redhat.com> <4323181413620101@web21o.yandex.ru>
Subject: Re: [PATCH] sched/numa: fix unsafe get_task_struct() in task_numa_assign()
MIME-Version: 1.0
Message-Id: <1011271413621207@web30j.yandex.ru>
X-Mailer: Yamail [ http://yandex.ru ] 5.0
Date: Sat, 18 Oct 2014 12:33:27 +0400
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=koi8-r
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

18.10.2014, 12:15, "Kirill Tkhai" <tkhai@yandex.ru>:
> 18.10.2014, 01:40, "Oleg Nesterov" <oleg@redhat.com>:
>> šThe lockless get_task_struct(tsk) is only safe if tsk == current
>> šand didn't pass exit_notify(), or if this tsk was found on a rcu
>> šprotected list (say, for_each_process() or find_task_by_vpid()).
>> šIOW, it is only safe if release_task() was not called before we
>> štake rcu_read_lock(), in this case we can rely on the fact that
>> šdelayed_put_pid() can not drop the (potentially) last reference
>> šuntil rcu_read_unlock().
>>
>> šAnd as Kirill pointed out task_numa_compare()->task_numa_assign()
>> špath does get_task_struct(dst_rq->curr) and this is not safe. The
>> štask_struct itself can't go away, but rcu_read_lock() can't save
>> šus from the final put_task_struct() in finish_task_switch(); this
>> šreference goes away without rcu gp.
>>
>> šReported-by: Kirill Tkhai <ktkhai@parallels.com>
>> šSigned-off-by: Oleg Nesterov <oleg@redhat.com>
>> š---
>> šškernel/sched/fair.c | ššš8 +++++++-
>> šš1 files changed, 7 insertions(+), 1 deletions(-)
>>
>> šdiff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
>> šindex 0090e8c..52049b9 100644
>> š--- a/kernel/sched/fair.c
>> š+++ b/kernel/sched/fair.c
>> š@@ -1158,7 +1158,13 @@ static void task_numa_compare(struct task_numa_env *env,
>>
>> ššššššššššrcu_read_lock();
>> ššššššššššcur = ACCESS_ONCE(dst_rq->curr);
>> š- if (cur->pid == 0) /* idle */
>> š+ /*
>> š+ * No need to move the exiting task, and this ensures that ->curr
>> š+ * wasn't reaped and thus get_task_struct() in task_numa_assign()
>> š+ * is safe; note that rcu_read_lock() can't protect from the final
>> š+ * put_task_struct() after the last schedule().
>> š+ */
>> š+ if (is_idle_task(cur) || (cur->flags & PF_EXITING))
>> ššššššššššššššššššcur = NULL;
>>
>> šššššššššš/*
>
> Oleg, I've looked once again, and now it's not good for me.
> Where is the guarantee this memory hasn't been allocated again?
> If so, PF_EXITING is not of the task we are interesting, but it's
> not a task's even.
>
> rcu_read_lock() šššššššššššššššššš... šššššššššššššššššššššššššš...
> cur = ACCESS_ONCE(dst_rq->curr); š... šššššššššššššššššššššššššš...
> <interrupt> ššššššššššššššššššššššrq->curr = next; ššššššššššššš...
> <interrupt> ššššššššššššššššššššššššššput_prev_task() šššššššššš...
> <interrupt> šššššššššššššššššššššššššššššš__put_prev_task šššššš...
> <interrupt> ššššššššššššššššššššššššššššššššškmem_cache_free() š...
> <interrupt> ššššššššššššššššššššššššššššššššš... ššššššššššššššš<alocated again>
> <interrupt> ššššššššššššššššššššššššššššššššš... šššššššššššššššmemset(, 0, )
> <interrupt> ššššššššššššššššššššššššššššššššš... ššššššššššššššš...
> if (cur->flags & PF_EXITING) šššššššššššššššš... ššššššššššššššš...
> šššš<no> šššššššššššššššššššššššššššššššššššš... ššššššššššššššš...
> get_task_struct() ššššššššššššššššššššššššššš... ššššššššššššššš...

How about this?

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index b78280c..d46427e 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -1165,7 +1165,21 @@ static void task_numa_compare(struct task_numa_env *env,
 
 	rcu_read_lock();
 	cur = ACCESS_ONCE(dst_rq->curr);
-	if (cur->pid == 0) /* idle */
+	/*
+	 * No need to move the exiting task, and this ensures that ->curr
+	 * wasn't reaped and thus get_task_struct() in task_numa_assign()
+	 * is safe; note that rcu_read_lock() can't protect from the final
+	 * put_task_struct() after the last schedule().
+	 */
+	if (is_idle_task(cur) || (cur->flags & PF_EXITING))
+		cur = NULL;
+	/*
+	 * Check once again to be sure curr is still on dst_rq. Even if
+	 * it points on a new task, which is using the memory of freed
+	 * cur, it's OK, because we've locked RCU before
+	 * delayed_put_task_struct() callback is called to put its struct.
+	 */
+	if (cur != ACCESS_ONCE(dst_rq->curr))
 		cur = NULL;
 
 	/*
