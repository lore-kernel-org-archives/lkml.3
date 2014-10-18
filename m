Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751682AbaJRXNi (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Oct 2014 19:13:38 -0400
Received: from forward1o.mail.yandex.net ([37.140.190.30]:49414 "EHLO
	forward1o.mail.yandex.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751576AbaJRXNh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Oct 2014 19:13:37 -0400
From: Kirill Tkhai <tkhai@yandex.ru>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Kirill Tkhai <ktkhai@parallels.com>, Peter Zijlstra <peterz@infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@redhat.com>,
        Vladimir Davydov <vdavydov@parallels.com>
In-Reply-To: <20141018205614.GA15934@redhat.com>
References: <1413376300.24793.55.camel@tkhai> <20141017213641.GB32576@redhat.com> <4323181413620101@web21o.yandex.ru> <20141018205614.GA15934@redhat.com>
Subject: Re: [PATCH] sched/numa: fix unsafe get_task_struct() in task_numa_assign()
MIME-Version: 1.0
Message-Id: <33631413674011@web7o.yandex.ru>
X-Mailer: Yamail [ http://yandex.ru ] 5.0
Date: Sun, 19 Oct 2014 03:13:31 +0400
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=koi8-r
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

19.10.2014, 00:59, "Oleg Nesterov" <oleg@redhat.com>:
> šOn 10/18, Kirill Tkhai wrote:
>> šš18.10.2014, 01:40, "Oleg Nesterov" <oleg@redhat.com>:
>>> šš...
>>> ššThe
>>> šštask_struct itself can't go away,
>>> šš...
>>> šš--- a/kernel/sched/fair.c
>>> šš+++ b/kernel/sched/fair.c
>>> šš@@ -1158,7 +1158,13 @@ static void task_numa_compare(struct task_numa_env *env,
>>>
>>> šššššššššššrcu_read_lock();
>>> šššššššššššcur = ACCESS_ONCE(dst_rq->curr);
>>> šš- if (cur->pid == 0) /* idle */
>>> šš+ /*
>>> šš+ * No need to move the exiting task, and this ensures that ->curr
>>> šš+ * wasn't reaped and thus get_task_struct() in task_numa_assign()
>>> šš+ * is safe; note that rcu_read_lock() can't protect from the final
>>> šš+ * put_task_struct() after the last schedule().
>>> šš+ */
>>> šš+ if (is_idle_task(cur) || (cur->flags & PF_EXITING))
>>> šššššššššššššššššššcur = NULL;
>>>
>>> ššššššššššš/*
>> ššOleg, I've looked once again, and now it's not good for me.
> šAh. Thanks a lot Kirill for correcting me!
>
> šI was looking at this rcu_read_lock() and I didn't even try to think
> šwhat it can actually protect. Nothing.

<snip>

> šNo, I don't think this can work. Let's look at the current code:
>
> šššššššššrcu_read_lock();
> šššššššššcur = ACCESS_ONCE(dst_rq->curr);
> šššššššššif (cur->pid == 0) /* idle */
>
> šAnd any dereference, even reading ->pid is not safe. This memory can be
> šfreed, unmapped, reused, etc.
>
> šLooks like, task_numa_compare() needs to take dst_rq->lock and get the
> šrefernce first.

Yeah, detection of idle is not save. If we reorder the checks almost all
problems will be gone. All except unmapping. JFI, is it possible with
such kernel structures as task_struct? I.e. do mem caches use high memory
in their bosoms?
Thanks!

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index b78280c..114ec33 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -1165,7 +1165,30 @@ static void task_numa_compare(struct task_numa_env *env,
 
 	rcu_read_lock();
 	cur = ACCESS_ONCE(dst_rq->curr);
-	if (cur->pid == 0) /* idle */
+	/*
+	 * No need to move the exiting task, and this ensures that ->curr
+	 * wasn't reaped and thus get_task_struct() in task_numa_assign()
+	 * is safe; note that rcu_read_lock() can't protect from the final
+	 * put_task_struct() after the last schedule().
+	 */
+	if (cur->flags & PF_EXITING)
+		cur = NULL;
+	smp_rmb(); /* Pairs with dst_rq->lock unlocking which implies smp_wmb */
+	/*
+	 * Check once again to be sure curr is still on dst_rq. Three situations
+	 * are possible here:
+	 * 1)cur has gone and been freed, and dst_rq->curr is pointing on other
+	 *   memory. In this case the check will fail;
+	 * 2)cur is pointing to a new task, which is using the memory of just
+	 *   freed cur (and it is new dst_rq->curr). It's OK, because we've
+	 *   locked RCU before the new task has been even created
+	 *   (so delayed_put_task_struct() hasn't been called);
+	 * 3)we've taken not exiting task (likely case). No need to worry.
+	 */
+	if (cur != ACCESS_ONCE(dst_rq->curr))
+		cur = NULL;
+
+	if (is_idle_task(cur))
 		cur = NULL;
 
 	/*


> šOr, perhaps, we need to change the rules to ensure that any "task_struct *"
> špointer is rcu-safe. Perhaps we have more similar problems... I'd like to
> šavoid this if possible.

RT tree has:

https://git.kernel.org/cgit/linux/kernel/git/paulg/3.10-rt-patches.git/tree/patches/sched-delay-put-task.patch

But other problem was decided there..

> šHmm. I'll try to think more.
>
> šThanks!

Kirill
