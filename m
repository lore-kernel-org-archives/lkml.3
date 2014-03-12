Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754225AbaCLMYD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Mar 2014 08:24:03 -0400
Received: from forward17.mail.yandex.net ([95.108.253.142]:45155 "EHLO
	forward17.mail.yandex.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753120AbaCLMYB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Mar 2014 08:24:01 -0400
From: Kirill Tkhai <tkhai@yandex.ru>
To: Nicholas Mc Guire <der.herr@hofr.at>, Steven Rostedt <rostedt@goodmis.org>
Cc: Peter Zijlstra <peterz@infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@kernel.org>,
        linux-rt-users <linux-rt-users@vger.kernel.org>
In-Reply-To: <20140312103942.GB5321@opentech.at>
References: <4451359470707@web16g.yandex.ru> <20140312061833.3a43aa64@gandalf.local.home> <20140312103942.GB5321@opentech.at>
Subject: Re: [PATCH]sched/rt: Do not try to push tasks if pinned task switches to RT
MIME-Version: 1.0
Message-Id: <3618231394627028@web10g.yandex.ru>
X-Mailer: Yamail [ http://yandex.ru ] 5.0
Date: Wed, 12 Mar 2014 16:23:48 +0400
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=koi8-r
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

12.03.2014, 14:39, "Nicholas Mc Guire" <der.herr@hofr.at>:
> On Wed, 12 Mar 2014, Steven Rostedt wrote:
>
>> šPeter,
>>
>> šI'm going through my inbox (over a year old), and found this patch from
>> šKirill. It looks fine to me. You can apply it with my
>>
>> šššAcked-by: Steven Rostedt <rostedt@goodmis.org>
>>
>> š-- Steve
>>
>> š[PATCH]sched/rt: Do not try to push tasks if pinned task switches to RT
>>
>> šJust switched pinned task is not able to be pushed. If the rq had had
>> šseveral RT tasks before they have already been considered as candidates
>> što be pushed (or pulled).
>>
>> šSigned-off-by: Kirill V Tkhai <tkhai@yandex.ru>
>> šCC: Steven Rostedt <rostedt@goodmis.org>
>> šCC: Ingo Molnar <mingo@kernel.org>
>> šCC: Peter Zijlstra <peterz@infradead.org>
>> šCC: linux-rt-users <linux-rt-users@vger.kernel.org>
>> š---
>> šškernel/sched/rt.c | ššš4 ++--
>> šš1 files changed, 2 insertions(+), 2 deletions(-)
>> šdiff --git a/kernel/sched/rt.c b/kernel/sched/rt.c
>> šindex 4e8f0f4..5aab032 100644
>> š--- a/kernel/sched/rt.c
>> š+++ b/kernel/sched/rt.c
>> š@@ -1925,9 +1925,9 @@ static void switched_to_rt(struct rq *rq, struct task_struct *p)
>> ššššššššššš*/
>> ššššššššššif (p->on_rq && rq->curr != p) {
>> šš#ifdef CONFIG_SMP
>> š- if (rq->rt.overloaded && push_rt_task(rq) &&
>> š+ if (p->nr_cpus_allowed > 1 && rq->rt.overloaded &&
>> šššššššššššššššššššššš/* Don't resched if we changed runqueues */
>> š- šššrq != task_rq(p))
>> š+ šššpush_rt_task(rq) && rq != task_rq(p))
>> ššššššššššššššššššššššššššcheck_resched = 0;
>> šš#endif /* CONFIG_SMP */
>> ššššššššššššššššššif (check_resched && p->prio < rq->curr->prio)
>
> would there not need to be a check for p->migrate_disable ?
> push_rt_task() is not checking and so a high prio RT task
> preemting a low prio RT task in a migrate_disable() section
> would actually push it off this cpu ? atleast I did not
> find why that would not happen.

Hi, Nicholas!

p is not rq->curr, so its p->migrate_disable state is already updated and
it can't be pushed (nr_cpus_allowed == 1 and it's not pushable).

(If I understand right, that you worry about this).

Kirill

> thx!
> hofrat
