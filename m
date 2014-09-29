Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753971AbaI2PSr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Sep 2014 11:18:47 -0400
Received: from forward13.mail.yandex.net ([95.108.130.120]:48913 "EHLO
	forward13.mail.yandex.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751521AbaI2PSq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Sep 2014 11:18:46 -0400
X-Greylist: delayed 319 seconds by postgrey-1.27 at vger.kernel.org; Mon, 29 Sep 2014 11:18:45 EDT
From: Kirill Tkhai <tkhai@yandex.ru>
To: Juri Lelli <juri.lelli@arm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>, Kirill Tkhai <ktkhai@parallels.com>,
        Ingo Molnar <mingo@redhat.com>, Juri Lelli <juri.lelli@gmail.com>
In-Reply-To: <542974DE.8050203@arm.com>
References: <20140927084044.1634.60573.stgit@localhost> <20140927084104.1634.88783.stgit@localhost> <542974DE.8050203@arm.com>
Subject: Re: [PATCH 2/2] sched/dl: Cleanup prio_changed_dl()
MIME-Version: 1.0
Message-Id: <5425501412003601@web12j.yandex.ru>
X-Mailer: Yamail [ http://yandex.ru ] 5.0
Date: Mon, 29 Sep 2014 19:13:21 +0400
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=koi8-r
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



29.09.2014, 19:03, "Juri Lelli" <juri.lelli@arm.com>:
> Hi Kirill,
>
> On 27/09/14 09:41, Kirill Tkhai wrote:
>> šFrom: Kirill Tkhai <ktkhai@parallels.com>
>>
>> šNow rq->curr task can't be dequeued in this function
>> š(it's possible only in __schedule()).
>
> Could you please detail about "before", with a reference to the commit
> that made this further change necessary?

I wrote about unlocked context switching, but I've looked one more time
and found that it used to be impossible before too.

We set "rq->curr = next" before prepare_lock_switch(),
so dequeued task wasn't able to be curr.

I'll update both descriptions in v2.

Thanks,
Kirill

>
> Thanks a lot,
>
> - Juri
>> šAlso, delete "else" branch which is dead code.
>>
>> šSigned-off-by: Kirill Tkhai <ktkhai@parallels.com>
>> š---
>> šškernel/sched/deadline.c | šš50 +++++++++++++++++++++++------------------------
>> šš1 file changed, 24 insertions(+), 26 deletions(-)
>>
>> šdiff --git a/kernel/sched/deadline.c b/kernel/sched/deadline.c
>> šindex 63f8b4a..38b4f19 100644
>> š--- a/kernel/sched/deadline.c
>> š+++ b/kernel/sched/deadline.c
>> š@@ -1638,35 +1638,33 @@ static void switched_to_dl(struct rq *rq, struct task_struct *p)
>> ššstatic void prio_changed_dl(struct rq *rq, struct task_struct *p,
>> ššššššššššššššššššššššššššššššint oldprio)
>> šš{
>> š- if (task_on_rq_queued(p) || rq->curr == p) {
>> š+ if (!task_on_rq_queued(p))
>> š+ return;
>> šš#ifdef CONFIG_SMP
>> š- /*
>> š- * This might be too much, but unfortunately
>> š- * we don't have the old deadline value, and
>> š- * we can't argue if the task is increasing
>> š- * or lowering its prio, so...
>> š- */
>> š- if (!rq->dl.overloaded)
>> š- pull_dl_task(rq);
>> š-
>> š- /*
>> š- * If we now have a earlier deadline task than p,
>> š- * then reschedule, provided p is still on this
>> š- * runqueue.
>> š- */
>> š- if (dl_time_before(rq->dl.earliest_dl.curr, p->dl.deadline) &&
>> š- šššrq->curr == p)
>> š- resched_curr(rq);
>> š-#else
>> š- /*
>> š- * Again, we don't know if p has a earlier
>> š- * or later deadline, so let's blindly set a
>> š- * (maybe not needed) rescheduling point.
>> š- */
>> š+ /*
>> š+ * This might be too much, but unfortunately
>> š+ * we don't have the old deadline value, and
>> š+ * we can't argue if the task is increasing
>> š+ * or lowering its prio, so...
>> š+ */
>> š+ if (!rq->dl.overloaded)
>> š+ pull_dl_task(rq);
>> š+ /*
>> š+ * If we now have a earlier deadline task than p,
>> š+ * then reschedule, provided p is still on this
>> š+ * runqueue.
>> š+ */
>> š+ if (dl_time_before(rq->dl.earliest_dl.curr, p->dl.deadline) &&
>> š+ šššrq->curr == p)
>> ššššššššššššššššššresched_curr(rq);
>> š+#else
>> š+ /*
>> š+ * Again, we don't know if p has a earlier
>> š+ * or later deadline, so let's blindly set a
>> š+ * (maybe not needed) rescheduling point.
>> š+ */
>> š+ resched_curr(rq);
>> šš#endif /* CONFIG_SMP */
>> š- } else
>> š- switched_to_dl(rq, p);
>> šš}
>>
>> ššconst struct sched_class dl_sched_class = {
