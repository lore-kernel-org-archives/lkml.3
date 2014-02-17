Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754797AbaBQWUL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Feb 2014 17:20:11 -0500
Received: from e39.co.us.ibm.com ([32.97.110.160]:51066 "EHLO
	e39.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753913AbaBQWNU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Feb 2014 17:13:20 -0500
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@kernel.org, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@efficios.com,
        josh@joshtriplett.org, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, dhowells@redhat.com,
        edumazet@google.com, darren@dvhart.com, fweisbec@gmail.com,
        oleg@redhat.com, sbw@mit.edu,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH tip/core/rcu 35/55] rcutorture: Fix rcutorture shutdown races
Date: Mon, 17 Feb 2014 14:12:39 -0800
Message-Id: <1392675179-11560-35-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.8.1.5
In-Reply-To: <1392675179-11560-1-git-send-email-paulmck@linux.vnet.ibm.com>
References: <20140217221231.GA8419@linux.vnet.ibm.com>
 <1392675179-11560-1-git-send-email-paulmck@linux.vnet.ibm.com>
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14021722-9332-0000-0000-000003230136
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>

Not all of the rcutorture kthreads waited for kthread_should_stop()
before returning from their top-level functions, and none of them
used torture_shutdown_absorb() properly.  These problems can result in
segfaults and hangs at shutdown time, and some recent changes perturbed
timing sufficiently to make them much more probable.  This commit
therefore creates a torture_kthread_stopping() function that does the
proper kthread shutdown dance in one centralized location.

Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---
 include/linux/torture.h |  3 ++-
 kernel/rcu/rcutorture.c | 39 +++++++++++----------------------------
 kernel/torture.c        | 26 ++++++++++++++++++++++----
 3 files changed, 35 insertions(+), 33 deletions(-)

diff --git a/include/linux/torture.h b/include/linux/torture.h
index 513b85f98585..db9bc7756a32 100644
--- a/include/linux/torture.h
+++ b/include/linux/torture.h
@@ -45,7 +45,7 @@
 #define TOROUT_STRING(s) \
 	pr_alert("%s" TORTURE_FLAG s "\n", torture_type)
 #define VERBOSE_TOROUT_STRING(s) \
-	do { if (verbose) pr_alert("%s" TORTURE_FLAG s "\n", torture_type); } while (0)
+	do { if (verbose) pr_alert("%s" TORTURE_FLAG " %s\n", torture_type, s); } while (0)
 #define VERBOSE_TOROUT_ERRSTRING(s) \
 	do { if (verbose) pr_alert("%s" TORTURE_FLAG "!!! " s "\n", torture_type); } while (0)
 
@@ -88,5 +88,6 @@ void torture_init_end(void);
 bool torture_cleanup(void);
 bool torture_must_stop(void);
 bool torture_must_stop_irq(void);
+void torture_kthread_stopping(char *title);
 
 #endif /* __LINUX_TORTURE_H */
diff --git a/kernel/rcu/rcutorture.c b/kernel/rcu/rcutorture.c
index aaca2350e0e4..6d12fd18d97f 100644
--- a/kernel/rcu/rcutorture.c
+++ b/kernel/rcu/rcutorture.c
@@ -601,12 +601,13 @@ checkwait:	stutter_wait("rcu_torture_boost");
 	} while (!torture_must_stop());
 
 	/* Clean up and exit. */
-	VERBOSE_TOROUT_STRING("rcu_torture_boost task stopping");
-	torture_shutdown_absorb("rcu_torture_boost");
-	while (!kthread_should_stop() || rbi.inflight)
+	while (!kthread_should_stop() || rbi.inflight) {
+		torture_shutdown_absorb("rcu_torture_boost");
 		schedule_timeout_uninterruptible(1);
+	}
 	smp_mb(); /* order accesses to ->inflight before stack-frame death. */
 	destroy_rcu_head_on_stack(&rbi.rcu);
+	torture_kthread_stopping("rcu_torture_boost");
 	return 0;
 }
 
@@ -637,10 +638,7 @@ rcu_torture_fqs(void *arg)
 		}
 		stutter_wait("rcu_torture_fqs");
 	} while (!torture_must_stop());
-	VERBOSE_TOROUT_STRING("rcu_torture_fqs task stopping");
-	torture_shutdown_absorb("rcu_torture_fqs");
-	while (!kthread_should_stop())
-		schedule_timeout_uninterruptible(1);
+	torture_kthread_stopping("rcu_torture_fqs");
 	return 0;
 }
 
@@ -709,10 +707,7 @@ rcu_torture_writer(void *arg)
 		rcutorture_record_progress(++rcu_torture_current_version);
 		stutter_wait("rcu_torture_writer");
 	} while (!torture_must_stop());
-	VERBOSE_TOROUT_STRING("rcu_torture_writer task stopping");
-	torture_shutdown_absorb("rcu_torture_writer");
-	while (!kthread_should_stop())
-		schedule_timeout_uninterruptible(1);
+	torture_kthread_stopping("rcu_torture_writer");
 	return 0;
 }
 
@@ -747,10 +742,7 @@ rcu_torture_fakewriter(void *arg)
 		stutter_wait("rcu_torture_fakewriter");
 	} while (!torture_must_stop());
 
-	VERBOSE_TOROUT_STRING("rcu_torture_fakewriter task stopping");
-	torture_shutdown_absorb("rcu_torture_fakewriter");
-	while (!kthread_should_stop())
-		schedule_timeout_uninterruptible(1);
+	torture_kthread_stopping("rcu_torture_fakewriter");
 	return 0;
 }
 
@@ -891,12 +883,9 @@ rcu_torture_reader(void *arg)
 		schedule();
 		stutter_wait("rcu_torture_reader");
 	} while (!torture_must_stop());
-	VERBOSE_TOROUT_STRING("rcu_torture_reader task stopping");
-	torture_shutdown_absorb("rcu_torture_reader");
 	if (irqreader && cur_ops->irq_capable)
 		del_timer_sync(&t);
-	while (!kthread_should_stop())
-		schedule_timeout_uninterruptible(1);
+	torture_kthread_stopping("rcu_torture_reader");
 	return 0;
 }
 
@@ -1009,7 +998,7 @@ rcu_torture_stats(void *arg)
 		rcu_torture_stats_print();
 		torture_shutdown_absorb("rcu_torture_stats");
 	} while (!torture_must_stop());
-	VERBOSE_TOROUT_STRING("rcu_torture_stats task stopping");
+	torture_kthread_stopping("rcu_torture_stats");
 	return 0;
 }
 
@@ -1170,12 +1159,9 @@ static int rcu_torture_barrier_cbs(void *arg)
 		if (atomic_dec_and_test(&barrier_cbs_count))
 			wake_up(&barrier_wq);
 	} while (!torture_must_stop());
-	VERBOSE_TOROUT_STRING("rcu_torture_barrier_cbs task stopping");
-	torture_shutdown_absorb("rcu_torture_barrier_cbs");
-	while (!kthread_should_stop())
-		schedule_timeout_interruptible(1);
 	cur_ops->cb_barrier();
 	destroy_rcu_head_on_stack(&rcu);
+	torture_kthread_stopping("rcu_torture_barrier_cbs");
 	return 0;
 }
 
@@ -1206,10 +1192,7 @@ static int rcu_torture_barrier(void *arg)
 		n_barrier_successes++;
 		schedule_timeout_interruptible(HZ / 10);
 	} while (!torture_must_stop());
-	VERBOSE_TOROUT_STRING("rcu_torture_barrier task stopping");
-	torture_shutdown_absorb("rcu_torture_barrier");
-	while (!kthread_should_stop())
-		schedule_timeout_interruptible(1);
+	torture_kthread_stopping("rcu_torture_barrier");
 	return 0;
 }
 
diff --git a/kernel/torture.c b/kernel/torture.c
index 12a5807fb4e9..6f1c6600d183 100644
--- a/kernel/torture.c
+++ b/kernel/torture.c
@@ -169,7 +169,7 @@ torture_onoff(void *arg)
 		}
 		schedule_timeout_interruptible(onoff_interval);
 	}
-	VERBOSE_TOROUT_STRING("torture_onoff task stopping");
+	torture_kthread_stopping("torture_onoff");
 	return 0;
 }
 
@@ -370,7 +370,7 @@ static int torture_shuffle(void *arg)
 		torture_shuffle_tasks();
 		torture_shutdown_absorb("torture_shuffle");
 	} while (!torture_must_stop());
-	VERBOSE_TOROUT_STRING("torture_shuffle task stopping");
+	torture_kthread_stopping("torture_shuffle");
 	return 0;
 }
 
@@ -465,7 +465,7 @@ static int torture_shutdown(void *arg)
 		jiffies_snap = jiffies;
 	}
 	if (torture_must_stop()) {
-		VERBOSE_TOROUT_STRING("torture_shutdown task stopping");
+		torture_kthread_stopping("torture_shutdown");
 		return 0;
 	}
 
@@ -583,7 +583,7 @@ static int torture_stutter(void *arg)
 		ACCESS_ONCE(stutter_pause_test) = 0;
 		torture_shutdown_absorb("torture_stutter");
 	} while (!torture_must_stop());
-	VERBOSE_TOROUT_STRING("torture_stutter task stopping");
+	torture_kthread_stopping("torture_stutter");
 	return 0;
 }
 
@@ -696,3 +696,21 @@ bool torture_must_stop_irq(void)
 	return ACCESS_ONCE(fullstop) != FULLSTOP_DONTSTOP;
 }
 EXPORT_SYMBOL_GPL(torture_must_stop_irq);
+
+/*
+ * Each kthread must wait for kthread_should_stop() before returning from
+ * its top-level function, otherwise segfaults ensue.  This function
+ * prints a "stopping" message and waits for kthread_should_stop(), and
+ * should be called from all torture kthreads immediately prior to
+ * returning.
+ */
+void torture_kthread_stopping(char *title)
+{
+	if (verbose)
+		pr_alert("%s" TORTURE_FLAG " %s\n", torture_type, title);
+	while (!kthread_should_stop()) {
+		torture_shutdown_absorb(title);
+		schedule_timeout_uninterruptible(1);
+	}
+}
+EXPORT_SYMBOL_GPL(torture_kthread_stopping);
-- 
1.8.1.5

