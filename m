Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752583AbaBLIPw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Feb 2014 03:15:52 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:50367 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752297AbaBLIOP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Feb 2014 03:14:15 -0500
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "Li Zefan" <lizefan@huawei.com>,
        "Ingo Molnar" <mingo@kernel.org>, "Paul Turner" <pjt@google.com>,
        "Peter Zijlstra" <a.p.zijlstra@chello.nl>,
        "Peter Boonstoppel" <pboonstoppel@nvidia.com>
Date: Wed, 12 Feb 2014 08:10:12 +0000
Message-ID: <lsq.1392192612.420623688@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [PATCH 3.2 78/79] sched: Unthrottle rt runqueues in
 __disable_runtime()
In-Reply-To: <lsq.1392192611.998273004@decadent.org.uk>
X-SA-Exim-Connect-IP: 91.84.160.45
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.55-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Peter Boonstoppel <pboonstoppel@nvidia.com>

commit a4c96ae319b8047f62dedbe1eac79e321c185749 upstream.

migrate_tasks() uses _pick_next_task_rt() to get tasks from the
real-time runqueues to be migrated. When rt_rq is throttled
_pick_next_task_rt() won't return anything, in which case
migrate_tasks() can't move all threads over and gets stuck in an
infinite loop.

Instead unthrottle rt runqueues before migrating tasks.

Additionally: move unthrottle_offline_cfs_rqs() to rq_offline_fair()

Signed-off-by: Peter Boonstoppel <pboonstoppel@nvidia.com>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Paul Turner <pjt@google.com>
Link: http://lkml.kernel.org/r/5FBF8E85CA34454794F0F7ECBA79798F379D3648B7@HQMAIL04.nvidia.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
[ lizf: backported to 3.4: adjust context ]
Signed-off-by: Li Zefan <lizefan@huawei.com>
[bwh: Backported to 3.2:
 - Adjust filenames
 - unthrottle_offline_cfs_rqs() is already static, but defined in sched.c
   after including sched_fair.c, so add forward declaration
 - unthrottle_offline_cfs_rqs() also needs to be defined for all CONFIG_SMP
   configurations now]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -2189,6 +2189,10 @@ static int irqtime_account_si_update(voi
 
 #endif
 
+#ifdef CONFIG_SMP
+static void unthrottle_offline_cfs_rqs(struct rq *rq);
+#endif
+
 #include "sched_idletask.c"
 #include "sched_fair.c"
 #include "sched_rt.c"
@@ -6566,8 +6570,6 @@ static void unthrottle_offline_cfs_rqs(s
 			unthrottle_cfs_rq(cfs_rq);
 	}
 }
-#else
-static void unthrottle_offline_cfs_rqs(struct rq *rq) {}
 #endif
 
 /*
@@ -6595,9 +6597,6 @@ static void migrate_tasks(unsigned int d
 	 */
 	rq->stop = NULL;
 
-	/* Ensure any throttled groups are reachable by pick_next_task */
-	unthrottle_offline_cfs_rqs(rq);
-
 	for ( ; ; ) {
 		/*
 		 * There's this thread running, bail when that's the only
@@ -6624,6 +6623,10 @@ static void migrate_tasks(unsigned int d
 
 #endif /* CONFIG_HOTPLUG_CPU */
 
+#if !defined(CONFIG_HOTPLUG_CPU) || !defined(CONFIG_CFS_BANDWIDTH)
+static void unthrottle_offline_cfs_rqs(struct rq *rq) {}
+#endif
+
 #if defined(CONFIG_SCHED_DEBUG) && defined(CONFIG_SYSCTL)
 
 static struct ctl_table sd_ctl_dir[] = {
--- a/kernel/sched_fair.c
+++ b/kernel/sched_fair.c
@@ -4848,6 +4848,9 @@ static void rq_online_fair(struct rq *rq
 static void rq_offline_fair(struct rq *rq)
 {
 	update_sysctl();
+
+	/* Ensure any throttled groups are reachable by pick_next_task */
+	unthrottle_offline_cfs_rqs(rq);
 }
 
 #else	/* CONFIG_SMP */
--- a/kernel/sched_rt.c
+++ b/kernel/sched_rt.c
@@ -509,6 +509,7 @@ balanced:
 		 * runtime - in which case borrowing doesn't make sense.
 		 */
 		rt_rq->rt_runtime = RUNTIME_INF;
+		rt_rq->rt_throttled = 0;
 		raw_spin_unlock(&rt_rq->rt_runtime_lock);
 		raw_spin_unlock(&rt_b->rt_runtime_lock);
 	}

