Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752515AbaI0IlJ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Sep 2014 04:41:09 -0400
Received: from forward1l.mail.yandex.net ([84.201.143.144]:58467 "EHLO
	forward1l.mail.yandex.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751885AbaI0IlD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Sep 2014 04:41:03 -0400
X-Yandex-Uniq: 9c25fd92-2837-4a2e-b9ab-ba2f183b845d
Authentication-Results: smtp3o.mail.yandex.net; dkim=pass header.i=@yandex.ru
Subject: [PATCH 1/2] sched/dl: Implement cancel_dl_timer() to use in
 switched_from_dl()
From: Kirill Tkhai <tkhai@yandex.ru>
To: linux-kernel@vger.kernel.org
Cc: Peter Zijlstra <peterz@infradead.org>, Kirill Tkhai <ktkhai@parallels.com>,
        Ingo Molnar <mingo@redhat.com>, Juri Lelli <juri.lelli@gmail.com>
Date: Sat, 27 Sep 2014 12:40:58 +0400
Message-ID: <20140927084044.1634.60573.stgit@localhost>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Kirill Tkhai <ktkhai@parallels.com>

hrtimer_try_to_cancel() may bring a suprise, and even two its calls
may fail.

So, let's implement 100% guaranteed way to cancel the timer and let's
be sure we are safe even in very unlikely situations.

We do not create any problem with rq unlocking, because it already
may happed below in pull_dl_task(). No problem with deadline tasks
balancing too.

Signed-off-by: Kirill Tkhai <ktkhai@parallels.com>
---
 kernel/sched/deadline.c |   33 ++++++++++++++++++++++++++-------
 1 file changed, 26 insertions(+), 7 deletions(-)

diff --git a/kernel/sched/deadline.c b/kernel/sched/deadline.c
index abfaf3d..63f8b4a 100644
--- a/kernel/sched/deadline.c
+++ b/kernel/sched/deadline.c
@@ -555,11 +555,6 @@ void init_dl_task_timer(struct sched_dl_entity *dl_se)
 {
 	struct hrtimer *timer = &dl_se->dl_timer;
 
-	if (hrtimer_active(timer)) {
-		hrtimer_try_to_cancel(timer);
-		return;
-	}
-
 	hrtimer_init(timer, CLOCK_MONOTONIC, HRTIMER_MODE_REL);
 	timer->function = dl_task_timer;
 }
@@ -1567,10 +1562,34 @@ void init_sched_dl_class(void)
 
 #endif /* CONFIG_SMP */
 
+/*
+ *  Surely cancel task's dl_timer. May drop rq->lock.
+ */
+static void cancel_dl_timer(struct rq *rq, struct task_struct *p)
+{
+	struct hrtimer *dl_timer = &p->dl.dl_timer;
+
+	/* Nobody will change task's class if pi_lock is held */
+	lockdep_assert_held(&p->pi_lock);
+
+	if (hrtimer_active(dl_timer)) {
+		int ret = hrtimer_try_to_cancel(dl_timer);
+
+		if (unlikely(ret == -1)) {
+			/*
+			 * Note, p may migrate OR new deadline tasks
+			 * may appear in rq when we are unlocking it.
+			 */
+			raw_spin_unlock(&rq->lock);
+			hrtimer_cancel(dl_timer);
+			raw_spin_lock(&rq->lock);
+		}
+	}
+}
+
 static void switched_from_dl(struct rq *rq, struct task_struct *p)
 {
-	if (hrtimer_active(&p->dl.dl_timer) && !dl_policy(p->policy))
-		hrtimer_try_to_cancel(&p->dl.dl_timer);
+	cancel_dl_timer(rq, p);
 
 	__dl_clear_params(p);
 

