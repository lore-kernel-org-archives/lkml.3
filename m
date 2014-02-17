Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754657AbaBQWXD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Feb 2014 17:23:03 -0500
Received: from e35.co.us.ibm.com ([32.97.110.153]:45001 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753846AbaBQWNT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Feb 2014 17:13:19 -0500
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@kernel.org, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@efficios.com,
        josh@joshtriplett.org, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, dhowells@redhat.com,
        edumazet@google.com, darren@dvhart.com, fweisbec@gmail.com,
        oleg@redhat.com, sbw@mit.edu,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH tip/core/rcu 34/55] rcutorture: Announce task creation
Date: Mon, 17 Feb 2014 14:12:38 -0800
Message-Id: <1392675179-11560-34-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.8.1.5
In-Reply-To: <1392675179-11560-1-git-send-email-paulmck@linux.vnet.ibm.com>
References: <20140217221231.GA8419@linux.vnet.ibm.com>
 <1392675179-11560-1-git-send-email-paulmck@linux.vnet.ibm.com>
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14021722-6688-0000-0000-000006AEB01D
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>

A few "stealth-start rcutorture kthreads" have accumulated over the years,
so this commit adds console-log announcements (but only if the torture
tests are running verbose).

Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---
 kernel/rcu/rcutorture.c | 4 ++++
 kernel/torture.c        | 4 ++++
 2 files changed, 8 insertions(+)

diff --git a/kernel/rcu/rcutorture.c b/kernel/rcu/rcutorture.c
index 4402b95b376b..aaca2350e0e4 100644
--- a/kernel/rcu/rcutorture.c
+++ b/kernel/rcu/rcutorture.c
@@ -1119,6 +1119,7 @@ static int __init rcu_torture_stall_init(void)
 
 	if (stall_cpu <= 0)
 		return 0;
+	VERBOSE_TOROUT_STRING("Creating rcu_torture_stall task");
 	stall_task = kthread_run(rcu_torture_stall, NULL, "rcu_torture_stall");
 	if (IS_ERR(stall_task)) {
 		ret = PTR_ERR(stall_task);
@@ -1241,6 +1242,7 @@ static int rcu_torture_barrier_init(void)
 		return -ENOMEM;
 	for (i = 0; i < n_barrier_cbs; i++) {
 		init_waitqueue_head(&barrier_cbs_wq[i]);
+		VERBOSE_TOROUT_STRING("Creating rcu_torture_barrier_cbs task");
 		barrier_cbs_tasks[i] = kthread_run(rcu_torture_barrier_cbs,
 						   (void *)(long)i,
 						   "rcu_torture_barrier_cbs");
@@ -1252,6 +1254,7 @@ static int rcu_torture_barrier_init(void)
 		}
 		torture_shuffle_task_register(barrier_cbs_tasks[i]);
 	}
+	VERBOSE_TOROUT_STRING("Creating rcu_torture_barrier task");
 	barrier_task = kthread_run(rcu_torture_barrier, NULL,
 				   "rcu_torture_barrier");
 	if (IS_ERR(barrier_task)) {
@@ -1605,6 +1608,7 @@ rcu_torture_init(void)
 		fqs_duration = 0;
 	if (fqs_duration) {
 		/* Create the fqs thread */
+		VERBOSE_TOROUT_STRING("Creating rcu_torture_fqs task");
 		fqs_task = kthread_run(rcu_torture_fqs, NULL,
 				       "rcu_torture_fqs");
 		if (IS_ERR(fqs_task)) {
diff --git a/kernel/torture.c b/kernel/torture.c
index 217baffcaa66..12a5807fb4e9 100644
--- a/kernel/torture.c
+++ b/kernel/torture.c
@@ -187,6 +187,7 @@ int torture_onoff_init(long ooholdoff, long oointerval)
 	onoff_interval = oointerval;
 	if (onoff_interval <= 0)
 		return 0;
+	VERBOSE_TOROUT_STRING("Creating torture_onoff task");
 	onoff_task = kthread_run(torture_onoff, NULL, "torture_onoff");
 	if (IS_ERR(onoff_task)) {
 		ret = PTR_ERR(onoff_task);
@@ -390,6 +391,7 @@ int torture_shuffle_init(long shuffint)
 	}
 
 	/* Create the shuffler thread */
+	VERBOSE_TOROUT_STRING("Creating torture_shuffle task");
 	shuffler_task = kthread_run(torture_shuffle, NULL, "torture_shuffle");
 	if (IS_ERR(shuffler_task)) {
 		ret = PTR_ERR(shuffler_task);
@@ -486,6 +488,7 @@ int torture_shutdown_init(int ssecs, void (*cleanup)(void))
 	shutdown_secs = ssecs;
 	torture_shutdown_hook = cleanup;
 	if (shutdown_secs > 0) {
+		VERBOSE_TOROUT_STRING("Creating torture_shutdown task");
 		shutdown_time = jiffies + shutdown_secs * HZ;
 		shutdown_task = kthread_create(torture_shutdown, NULL,
 					       "torture_shutdown");
@@ -592,6 +595,7 @@ int torture_stutter_init(int s)
 	int ret;
 
 	stutter = s;
+	VERBOSE_TOROUT_STRING("Creating torture_stutter task");
 	stutter_task = kthread_run(torture_stutter, NULL, "torture_stutter");
 	if (IS_ERR(stutter_task)) {
 		ret = PTR_ERR(stutter_task);
-- 
1.8.1.5

