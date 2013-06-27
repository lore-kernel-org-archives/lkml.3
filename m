Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753567Ab3F0JDD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Jun 2013 05:03:03 -0400
Received: from terminus.zytor.com ([198.137.202.10]:46049 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753649Ab3F0JC5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Jun 2013 05:02:57 -0400
Date: Thu, 27 Jun 2013 02:02:24 -0700
From: tip-bot for Alex Shi <tipbot@zytor.com>
Message-ID: <tip-a003a25b227d59ded9197ced109517f037d01c27@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        peterz@infradead.org, alex.shi@intel.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        peterz@infradead.org, tglx@linutronix.de, alex.shi@intel.com
In-Reply-To: <1371694737-29336-8-git-send-email-alex.shi@intel.com>
References: <1371694737-29336-8-git-send-email-alex.shi@intel.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/core] sched:
  Consider runnable load average in move_tasks()
Git-Commit-ID: a003a25b227d59ded9197ced109517f037d01c27
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Thu, 27 Jun 2013 02:02:30 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  a003a25b227d59ded9197ced109517f037d01c27
Gitweb:     http://git.kernel.org/tip/a003a25b227d59ded9197ced109517f037d01c27
Author:     Alex Shi <alex.shi@intel.com>
AuthorDate: Thu, 20 Jun 2013 10:18:51 +0800
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Thu, 27 Jun 2013 10:07:36 +0200

sched: Consider runnable load average in move_tasks()

Aside from using runnable load average in background, move_tasks is
also the key function in load balance. We need consider the runnable
load average in it in order to make it an apple to apple load
comparison.

Morten had caught a div u64 bug on ARM, thanks!

Thanks-to: Morten Rasmussen <morten.rasmussen@arm.com>
Signed-off-by: Alex Shi <alex.shi@intel.com>
Signed-off-by: Peter Zijlstra <peterz@infradead.org>
Link: http://lkml.kernel.org/r/1371694737-29336-8-git-send-email-alex.shi@intel.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 kernel/sched/fair.c | 18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index e6d82ca..7948bb8 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -4179,11 +4179,14 @@ static int tg_load_down(struct task_group *tg, void *data)
 	long cpu = (long)data;
 
 	if (!tg->parent) {
-		load = cpu_rq(cpu)->load.weight;
+		load = cpu_rq(cpu)->avg.load_avg_contrib;
 	} else {
+		unsigned long tmp_rla;
+		tmp_rla = tg->parent->cfs_rq[cpu]->runnable_load_avg + 1;
+
 		load = tg->parent->cfs_rq[cpu]->h_load;
-		load *= tg->se[cpu]->load.weight;
-		load /= tg->parent->cfs_rq[cpu]->load.weight + 1;
+		load *= tg->se[cpu]->avg.load_avg_contrib;
+		load /= tmp_rla;
 	}
 
 	tg->cfs_rq[cpu]->h_load = load;
@@ -4209,12 +4212,9 @@ static void update_h_load(long cpu)
 static unsigned long task_h_load(struct task_struct *p)
 {
 	struct cfs_rq *cfs_rq = task_cfs_rq(p);
-	unsigned long load;
-
-	load = p->se.load.weight;
-	load = div_u64(load * cfs_rq->h_load, cfs_rq->load.weight + 1);
 
-	return load;
+	return div64_ul(p->se.avg.load_avg_contrib * cfs_rq->h_load,
+			cfs_rq->runnable_load_avg + 1);
 }
 #else
 static inline void update_blocked_averages(int cpu)
@@ -4227,7 +4227,7 @@ static inline void update_h_load(long cpu)
 
 static unsigned long task_h_load(struct task_struct *p)
 {
-	return p->se.load.weight;
+	return p->se.avg.load_avg_contrib;
 }
 #endif
 
