Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755598AbaBUUdh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Feb 2014 15:33:37 -0500
Received: from terminus.zytor.com ([198.137.202.10]:58589 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755211AbaBUUde (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Feb 2014 15:33:34 -0500
Date: Fri, 21 Feb 2014 12:32:59 -0800
From: tip-bot for Kirill Tkhai <tipbot@zytor.com>
Message-ID: <tip-995b9ea440862def83e8fcb1b498e68f93d4af59@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, mingo@redhat.com, hpa@zytor.com,
        mingo@kernel.org, peterz@infradead.org, tkhai@yandex.ru,
        tglx@linutronix.de, juri.lelli@gmail.com
Reply-To: mingo@kernel.org, hpa@zytor.com, mingo@redhat.com,
        linux-kernel@vger.kernel.org, peterz@infradead.org, tkhai@yandex.ru,
        tglx@linutronix.de, juri.lelli@gmail.com
In-Reply-To: <368631392675853@web20h.yandex.ru>
References: <368631392675853@web20h.yandex.ru>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/urgent] sched/deadline: Remove useless dl_nr_total
Git-Commit-ID: 995b9ea440862def83e8fcb1b498e68f93d4af59
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  995b9ea440862def83e8fcb1b498e68f93d4af59
Gitweb:     http://git.kernel.org/tip/995b9ea440862def83e8fcb1b498e68f93d4af59
Author:     Kirill Tkhai <tkhai@yandex.ru>
AuthorDate: Tue, 18 Feb 2014 02:24:13 +0400
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Fri, 21 Feb 2014 21:27:10 +0100

sched/deadline: Remove useless dl_nr_total

In deadline class we do not have group scheduling like in RT.

dl_nr_total is the same as dl_nr_running. So, one of them should
be removed.

Cc: Ingo Molnar <mingo@redhat.com>
Cc: Juri Lelli <juri.lelli@gmail.com>
Signed-off-by: Kirill Tkhai <tkhai@yandex.ru>
Signed-off-by: Peter Zijlstra <peterz@infradead.org>
Link: http://lkml.kernel.org/r/368631392675853@web20h.yandex.ru
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 kernel/sched/deadline.c | 4 +---
 kernel/sched/sched.h    | 1 -
 2 files changed, 1 insertion(+), 4 deletions(-)

diff --git a/kernel/sched/deadline.c b/kernel/sched/deadline.c
index b819577..15cbc17 100644
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
index c2119fd..f964add 100644
--- a/kernel/sched/sched.h
+++ b/kernel/sched/sched.h
@@ -462,7 +462,6 @@ struct dl_rq {
 	} earliest_dl;
 
 	unsigned long dl_nr_migratory;
-	unsigned long dl_nr_total;
 	int overloaded;
 
 	/*
