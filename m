Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754978Ab3A0AFw (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Jan 2013 19:05:52 -0500
Received: from e38.co.us.ibm.com ([32.97.110.159]:51586 "EHLO
	e38.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754749Ab3A0AFq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Jan 2013 19:05:46 -0500
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@polymtl.ca,
        josh@joshtriplett.org, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, Valdis.Kletnieks@vt.edu,
        dhowells@redhat.com, edumazet@google.com, darren@dvhart.com,
        fweisbec@gmail.com, sbw@mit.edu,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH tip/core/rcu 4/4] rcu: Make rcutorture's shuffler task shuffle recently added tasks
Date: Sat, 26 Jan 2013 16:05:20 -0800
Message-Id: <1359245120-2266-4-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.8
In-Reply-To: <1359245120-2266-1-git-send-email-paulmck@linux.vnet.ibm.com>
References: <20130127000435.GA1521@linux.vnet.ibm.com>
 <1359245120-2266-1-git-send-email-paulmck@linux.vnet.ibm.com>
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13012700-5518-0000-0000-00000B0B31C5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>

A number of kthreads have been added to rcutorture, but the shuffler
task was not informed of them, and thus did not shuffle them.  This
commit therefore adds the requisite shuffling.

Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---
 kernel/rcutorture.c |   24 ++++++++++++++++++++----
 1 files changed, 20 insertions(+), 4 deletions(-)

diff --git a/kernel/rcutorture.c b/kernel/rcutorture.c
index a583f1c..3ebc8bf 100644
--- a/kernel/rcutorture.c
+++ b/kernel/rcutorture.c
@@ -846,7 +846,7 @@ static int rcu_torture_boost(void *arg)
 		/* Wait for the next test interval. */
 		oldstarttime = boost_starttime;
 		while (ULONG_CMP_LT(jiffies, oldstarttime)) {
-			schedule_timeout_uninterruptible(1);
+			schedule_timeout_interruptible(oldstarttime - jiffies);
 			rcu_stutter_wait("rcu_torture_boost");
 			if (kthread_should_stop() ||
 			    fullstop != FULLSTOP_DONTSTOP)
@@ -1318,19 +1318,35 @@ static void rcu_torture_shuffle_tasks(void)
 				set_cpus_allowed_ptr(reader_tasks[i],
 						     shuffle_tmp_mask);
 	}
-
 	if (fakewriter_tasks) {
 		for (i = 0; i < nfakewriters; i++)
 			if (fakewriter_tasks[i])
 				set_cpus_allowed_ptr(fakewriter_tasks[i],
 						     shuffle_tmp_mask);
 	}
-
 	if (writer_task)
 		set_cpus_allowed_ptr(writer_task, shuffle_tmp_mask);
-
 	if (stats_task)
 		set_cpus_allowed_ptr(stats_task, shuffle_tmp_mask);
+	if (stutter_task)
+		set_cpus_allowed_ptr(stutter_task, shuffle_tmp_mask);
+	if (fqs_task)
+		set_cpus_allowed_ptr(fqs_task, shuffle_tmp_mask);
+	if (shutdown_task)
+		set_cpus_allowed_ptr(shutdown_task, shuffle_tmp_mask);
+#ifdef CONFIG_HOTPLUG_CPU
+	if (onoff_task)
+		set_cpus_allowed_ptr(onoff_task, shuffle_tmp_mask);
+#endif /* #ifdef CONFIG_HOTPLUG_CPU */
+	if (stall_task)
+		set_cpus_allowed_ptr(stall_task, shuffle_tmp_mask);
+	if (barrier_cbs_tasks)
+		for (i = 0; i < n_barrier_cbs; i++)
+			if (barrier_cbs_tasks[i])
+				set_cpus_allowed_ptr(barrier_cbs_tasks[i],
+						     shuffle_tmp_mask);
+	if (barrier_task)
+		set_cpus_allowed_ptr(barrier_task, shuffle_tmp_mask);
 
 	if (rcu_idle_cpu == -1)
 		rcu_idle_cpu = num_online_cpus() - 1;
-- 
1.7.8

