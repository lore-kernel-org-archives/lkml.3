Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754834AbaBQW3c (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Feb 2014 17:29:32 -0500
Received: from forward2h.mail.yandex.net ([84.201.187.147]:45812 "EHLO
	forward2h.mail.yandex.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753869AbaBQW3Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Feb 2014 17:29:25 -0500
X-Greylist: delayed 307 seconds by postgrey-1.27 at vger.kernel.org; Mon, 17 Feb 2014 17:29:25 EST
From: Kirill Tkhai <tkhai@yandex.ru>
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Cc: Juri Lelli <juri.lelli@gmail.com>, Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@redhat.com>
Subject: [PATCH]sched/deadline: Remove useless dl_nr_total
MIME-Version: 1.0
Message-Id: <368631392675853@web20h.yandex.ru>
X-Mailer: Yamail [ http://yandex.ru ] 5.0
Date: Tue, 18 Feb 2014 02:24:13 +0400
Content-Transfer-Encoding: 7bit
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In deadline class we do not have group scheduling like in RT.

dl_nr_total is the same as dl_nr_running. So, one of them should
be removed.

Signed-off-by: Kirill Tkhai <tkhai@yandex.ru>
CC: Juri Lelli <juri.lelli@gmail.com> 
CC: Peter Zijlstra <peterz@infradead.org>
CC: Ingo Molnar <mingo@redhat.com>
---
 kernel/sched/deadline.c | 4 +---
 kernel/sched/sched.h    | 1 -
 2 files changed, 1 insertion(+), 4 deletions(-)
diff --git a/kernel/sched/deadline.c b/kernel/sched/deadline.c
index ed31ef6..7a0db95 100644
--- a/kernel/sched/deadline.c
+++ b/kernel/sched/deadline.c
@@ -121,7 +121,7 @@ static inline void dl_clear_overload(struct rq *rq)
 
 static void update_dl_migration(struct dl_rq *dl_rq)
 {
-	if (dl_rq->dl_nr_migratory && dl_rq->dl_nr_total > 1) {
+	if (dl_rq->dl_nr_migratory && dl_rq->dl_nr_running > 1) {
 		if (!dl_rq->overloaded) {
 			dl_set_overload(rq_of_dl_rq(dl_rq));
 			dl_rq->overloaded = 1;
@@ -137,7 +137,6 @@ static void inc_dl_migration(struct sched_dl_entity *dl_se, struct dl_rq *dl_rq)
 	struct task_struct *p = dl_task_of(dl_se);
 	dl_rq = &rq_of_dl_rq(dl_rq)->dl;
 
-	dl_rq->dl_nr_total++;
 	if (p->nr_cpus_allowed > 1)
 		dl_rq->dl_nr_migratory++;
 
@@ -149,7 +148,6 @@ static void dec_dl_migration(struct sched_dl_entity *dl_se, struct dl_rq *dl_rq)
 	struct task_struct *p = dl_task_of(dl_se);
 	dl_rq = &rq_of_dl_rq(dl_rq)->dl;
 
-	dl_rq->dl_nr_total--;
 	if (p->nr_cpus_allowed > 1)
 		dl_rq->dl_nr_migratory--;
 
diff --git a/kernel/sched/sched.h b/kernel/sched/sched.h
index 1bf34c2..6a00804 100644
--- a/kernel/sched/sched.h
+++ b/kernel/sched/sched.h
@@ -444,7 +444,6 @@ struct dl_rq {
 	} earliest_dl;
 
 	unsigned long dl_nr_migratory;
-	unsigned long dl_nr_total;
 	int overloaded;
 
 	/*
