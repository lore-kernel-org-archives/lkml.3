Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752710AbaETJdv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2014 05:33:51 -0400
Received: from forward20.mail.yandex.net ([95.108.253.145]:52455 "EHLO
	forward20.mail.yandex.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750789AbaETJdt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2014 05:33:49 -0400
From: Kirill Tkhai <tkhai@yandex.ru>
To: Juri Lelli <juri.lelli@gmail.com>, Peter Zijlstra <peterz@infradead.org>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
In-Reply-To: <20140520101730.ab593e41d5ee5949740de52e@gmail.com>
References: <20140516213003.10384.7946.stgit@localhost>
	<20140519151233.5043b749361e1b384f1e5562@gmail.com>
	<783871400527879@web2j.yandex.ru>
	<20140520000026.GD11096@twins.programming.kicks-ass.net>
	<1413311400562533@web30m.yandex.ru>
	<20140520075315.GQ2485@laptop.programming.kicks-ass.net> <20140520101730.ab593e41d5ee5949740de52e@gmail.com>
Subject: Re: [PATCH] sched/dl: Fix race between dl_task_timer() and sched_setaffinity()
MIME-Version: 1.0
Message-Id: <3056991400578422@web14g.yandex.ru>
X-Mailer: Yamail [ http://yandex.ru ] 5.0
Date: Tue, 20 May 2014 13:33:42 +0400
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=koi8-r
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

20.05.2014, 12:16, "Juri Lelli" <juri.lelli@gmail.com>:
> Hi,
>
> On Tue, 20 May 2014 09:53:15 +0200
> Peter Zijlstra <peterz@infradead.org> wrote:
>
>> šOn Tue, May 20, 2014 at 09:08:53AM +0400, Kirill Tkhai wrote:
>>> š20.05.2014, 04:00, "Peter Zijlstra" <peterz@infradead.org>:
>>>> šOn Mon, May 19, 2014 at 11:31:19PM +0400, Kirill Tkhai wrote:
>>>>> šš@@ -513,9 +513,17 @@ static enum hrtimer_restart dl_task_timer(struct hrtimer *timer)
>>>>> ššššššššššššššššššššššššššššššššššššššššššššššššššššššššstruct sched_dl_entity,
>>>>> ššššššššššššššššššššššššššššššššššššššššššššššššššššššššdl_timer);
>>>>> šššššššššššstruct task_struct *p = dl_task_of(dl_se);
>>>>> šš- struct rq *rq = task_rq(p);
>>>>> šš+ struct rq *rq;
>>>>> šš+again:
>>>>> šš+ rq = task_rq(p);
>>>>> šššššššššššraw_spin_lock(&rq->lock);
>>>>>
>>>>> šš+ if (unlikely(rq != task_rq(p))) {
>>>>> šš+ /* Task was moved, retrying. */
>>>>> šš+ raw_spin_unlock(&rq->lock);
>>>>> šš+ goto again;
>>>>> šš+ }
>>>>> šš+
>>>> šThat thing is called: rq = __task_rq_lock(p);
>>> šBut p->pi_lock is not held. The problem is __task_rq_lock() has lockdep assert.
>>> šShould we change it?
>> šOk, so now that I'm awake ;-)
>>
>> šSo the trivial problem as described by your initial changelog isn't
>> šright, because we cannot call sched_setaffinity() on deadline tasks, or
>> šrather we can, but we can't actually change the affinity mask.
>
> Well, if we disable AC we can. And I was able to recreate that race in
> that case.
>
>> šNow I suppose the problem can still actually happen when you change the
>> šroot domain and trigger a effective affinity change that way.
>
> Yeah, I think here too.
>
>> šThat said, no leave it as you proposed, adding a *task_rq_lock() variant
>> šwithout lockdep assert in will only confuse things, as normally we
>> šreally should be also taking ->pi_lock.
>>
>> šThe only reason we don't strictly need ->pi_lock now is because we're
>> šguaranteed to have p->state == TASK_RUNNING here and are thus free of
>> šttwu races.
>
> Maybe we could add this as part of the comment.

Peter, Juri, thanks for comment. Hope, I understood you right :)

[PATCH] sched/dl: Fix race in dl_task_timer()

Throttled task is still on rq, and it may be moved to other cpu
if user is playing with sched_setaffinity(). Therefore, unlocked
task_rq() access makes the race.

Juri Lelli reports he got this race when dl_bandwidth_enabled()
was not set.

Other thing, pointed by Peter Zijlstra:

   "Now I suppose the problem can still actually happen when
    you change the root domain and trigger a effective affinity
    change that way".

To fix that we do the same as made in __task_rq_lock(). We do not
use __task_rq_lock() itself, because it has a useful lockdep check,
which is not correct in case of dl_task_timer(). We do not need
pi_lock locked here. This case is an exception (PeterZ):

   "The only reason we don't strictly need ->pi_lock now is because
    we're guaranteed to have p->state == TASK_RUNNING here and are
    thus free of ttwu races".

Signed-off-by: Kirill Tkhai <tkhai@yandex.ru>
CC: Juri Lelli <juri.lelli@gmail.com>
CC: Peter Zijlstra <peterz@infradead.org>
CC: Ingo Molnar <mingo@redhat.com>
Cc: <stable@vger.kernel.org> # v3.14
---
 kernel/sched/deadline.c | 10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff --git a/kernel/sched/deadline.c b/kernel/sched/deadline.c
index 800e99b..14bc348 100644
--- a/kernel/sched/deadline.c
+++ b/kernel/sched/deadline.c
@@ -513,9 +513,17 @@ static enum hrtimer_restart dl_task_timer(struct hrtimer *timer)
 						     struct sched_dl_entity,
 						     dl_timer);
 	struct task_struct *p = dl_task_of(dl_se);
-	struct rq *rq = task_rq(p);
+	struct rq *rq;
+again:
+	rq = task_rq(p);
 	raw_spin_lock(&rq->lock);
 
+	if (rq != task_rq(p)) {
+		/* Task was moved, retrying. */
+		raw_spin_unlock(&rq->lock);
+		goto again;
+	}
+
 	/*
 	 * We need to take care of a possible races here. In fact, the
 	 * task might have changed its scheduling policy to something
