Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754850AbaBQWXF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Feb 2014 17:23:05 -0500
Received: from e32.co.us.ibm.com ([32.97.110.150]:44718 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753845AbaBQWNT (ORCPT
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
Subject: [PATCH tip/core/rcu 28/55] rcutorture: Privatize fullstop
Date: Mon, 17 Feb 2014 14:12:32 -0800
Message-Id: <1392675179-11560-28-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.8.1.5
In-Reply-To: <1392675179-11560-1-git-send-email-paulmck@linux.vnet.ibm.com>
References: <20140217221231.GA8419@linux.vnet.ibm.com>
 <1392675179-11560-1-git-send-email-paulmck@linux.vnet.ibm.com>
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14021722-0928-0000-0000-000006C34EF4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>

This commit introduces the torture_must_stop() function in order to
keep use of the fullstop variable local to kernel/torture.c.  There
is also a torture_must_stop_irq() counterpart for use from RCU callbacks,
timeout handlers, and the like.

Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---
 include/linux/torture.h |  8 ++------
 kernel/rcu/rcutorture.c | 38 +++++++++++++++-----------------------
 kernel/torture.c        | 27 +++++++++++++++++++++++++--
 3 files changed, 42 insertions(+), 31 deletions(-)

diff --git a/include/linux/torture.h b/include/linux/torture.h
index a12ed5ba5996..1e2e7cd528c0 100644
--- a/include/linux/torture.h
+++ b/include/linux/torture.h
@@ -41,12 +41,6 @@
 	module_param(name, type, 0444); \
 	MODULE_PARM_DESC(name, msg);
 
-/* Mediate rmmod and system shutdown.  Concurrent rmmod & shutdown illegal! */
-#define FULLSTOP_DONTSTOP 0	/* Normal operation. */
-#define FULLSTOP_SHUTDOWN 1	/* System shutdown with rcutorture running. */
-#define FULLSTOP_RMMOD    2	/* Normal rmmod of rcutorture. */
-extern int fullstop;
-
 #define TORTURE_FLAG "-torture:"
 #define TOROUT_STRING(s) \
 	pr_alert("%s" TORTURE_FLAG s "\n", torture_type)
@@ -85,5 +79,7 @@ void torture_shutdown_absorb(const char *title);
 void torture_init_begin(char *ttype, bool v);
 void torture_init_end(void);
 bool torture_cleanup(void);
+bool torture_must_stop(void);
+bool torture_must_stop_irq(void);
 
 #endif /* __LINUX_TORTURE_H */
diff --git a/kernel/rcu/rcutorture.c b/kernel/rcu/rcutorture.c
index 14a045fa3d2e..87bd690c5958 100644
--- a/kernel/rcu/rcutorture.c
+++ b/kernel/rcu/rcutorture.c
@@ -303,7 +303,7 @@ rcu_torture_cb(struct rcu_head *p)
 	int i;
 	struct rcu_torture *rp = container_of(p, struct rcu_torture, rtort_rcu);
 
-	if (fullstop != FULLSTOP_DONTSTOP) {
+	if (torture_must_stop_irq()) {
 		/* Test is ending, just drop callbacks on the floor. */
 		/* The next initialization will pick up the pieces. */
 		return;
@@ -571,8 +571,7 @@ static int rcu_torture_boost(void *arg)
 		while (ULONG_CMP_LT(jiffies, oldstarttime)) {
 			schedule_timeout_interruptible(oldstarttime - jiffies);
 			rcu_stutter_wait("rcu_torture_boost");
-			if (kthread_should_stop() ||
-			    fullstop != FULLSTOP_DONTSTOP)
+			if (torture_must_stop())
 				goto checkwait;
 		}
 
@@ -594,8 +593,7 @@ static int rcu_torture_boost(void *arg)
 			}
 			cond_resched();
 			rcu_stutter_wait("rcu_torture_boost");
-			if (kthread_should_stop() ||
-			    fullstop != FULLSTOP_DONTSTOP)
+			if (torture_must_stop())
 				goto checkwait;
 		}
 
@@ -620,7 +618,7 @@ static int rcu_torture_boost(void *arg)
 
 		/* Go do the stutter. */
 checkwait:	rcu_stutter_wait("rcu_torture_boost");
-	} while (!kthread_should_stop() && fullstop  == FULLSTOP_DONTSTOP);
+	} while (!torture_must_stop());
 
 	/* Clean up and exit. */
 	VERBOSE_TOROUT_STRING("rcu_torture_boost task stopping");
@@ -658,7 +656,7 @@ rcu_torture_fqs(void *arg)
 			fqs_burst_remaining -= fqs_holdoff;
 		}
 		rcu_stutter_wait("rcu_torture_fqs");
-	} while (!kthread_should_stop() && fullstop == FULLSTOP_DONTSTOP);
+	} while (!torture_must_stop());
 	VERBOSE_TOROUT_STRING("rcu_torture_fqs task stopping");
 	torture_shutdown_absorb("rcu_torture_fqs");
 	while (!kthread_should_stop())
@@ -730,7 +728,7 @@ rcu_torture_writer(void *arg)
 		}
 		rcutorture_record_progress(++rcu_torture_current_version);
 		rcu_stutter_wait("rcu_torture_writer");
-	} while (!kthread_should_stop() && fullstop == FULLSTOP_DONTSTOP);
+	} while (!torture_must_stop());
 	VERBOSE_TOROUT_STRING("rcu_torture_writer task stopping");
 	torture_shutdown_absorb("rcu_torture_writer");
 	while (!kthread_should_stop())
@@ -767,7 +765,7 @@ rcu_torture_fakewriter(void *arg)
 			cur_ops->exp_sync();
 		}
 		rcu_stutter_wait("rcu_torture_fakewriter");
-	} while (!kthread_should_stop() && fullstop == FULLSTOP_DONTSTOP);
+	} while (!torture_must_stop());
 
 	VERBOSE_TOROUT_STRING("rcu_torture_fakewriter task stopping");
 	torture_shutdown_absorb("rcu_torture_fakewriter");
@@ -912,7 +910,7 @@ rcu_torture_reader(void *arg)
 		cur_ops->readunlock(idx);
 		schedule();
 		rcu_stutter_wait("rcu_torture_reader");
-	} while (!kthread_should_stop() && fullstop == FULLSTOP_DONTSTOP);
+	} while (!torture_must_stop());
 	VERBOSE_TOROUT_STRING("rcu_torture_reader task stopping");
 	torture_shutdown_absorb("rcu_torture_reader");
 	if (irqreader && cur_ops->irq_capable)
@@ -1021,9 +1019,6 @@ rcu_torture_stats_print(void)
 /*
  * Periodically prints torture statistics, if periodic statistics printing
  * was specified via the stat_interval module parameter.
- *
- * No need to worry about fullstop here, since this one doesn't reference
- * volatile state or register callbacks.
  */
 static int
 rcu_torture_stats(void *arg)
@@ -1033,7 +1028,7 @@ rcu_torture_stats(void *arg)
 		schedule_timeout_interruptible(stat_interval * HZ);
 		rcu_torture_stats_print();
 		torture_shutdown_absorb("rcu_torture_stats");
-	} while (!kthread_should_stop());
+	} while (!torture_must_stop());
 	VERBOSE_TOROUT_STRING("rcu_torture_stats task stopping");
 	return 0;
 }
@@ -1240,16 +1235,15 @@ static int rcu_torture_barrier_cbs(void *arg)
 		wait_event(barrier_cbs_wq[myid],
 			   (newphase =
 			    ACCESS_ONCE(barrier_phase)) != lastphase ||
-			   kthread_should_stop() ||
-			   fullstop != FULLSTOP_DONTSTOP);
+			   torture_must_stop());
 		lastphase = newphase;
 		smp_mb(); /* ensure barrier_phase load before ->call(). */
-		if (kthread_should_stop() || fullstop != FULLSTOP_DONTSTOP)
+		if (torture_must_stop())
 			break;
 		cur_ops->call(&rcu, rcu_torture_barrier_cbf);
 		if (atomic_dec_and_test(&barrier_cbs_count))
 			wake_up(&barrier_wq);
-	} while (!kthread_should_stop() && fullstop == FULLSTOP_DONTSTOP);
+	} while (!torture_must_stop());
 	VERBOSE_TOROUT_STRING("rcu_torture_barrier_cbs task stopping");
 	torture_shutdown_absorb("rcu_torture_barrier_cbs");
 	while (!kthread_should_stop())
@@ -1274,9 +1268,8 @@ static int rcu_torture_barrier(void *arg)
 			wake_up(&barrier_cbs_wq[i]);
 		wait_event(barrier_wq,
 			   atomic_read(&barrier_cbs_count) == 0 ||
-			   kthread_should_stop() ||
-			   fullstop != FULLSTOP_DONTSTOP);
-		if (kthread_should_stop() || fullstop != FULLSTOP_DONTSTOP)
+			   torture_must_stop());
+		if (torture_must_stop())
 			break;
 		n_barrier_attempts++;
 		cur_ops->cb_barrier(); /* Implies smp_mb() for wait_event(). */
@@ -1286,7 +1279,7 @@ static int rcu_torture_barrier(void *arg)
 		}
 		n_barrier_successes++;
 		schedule_timeout_interruptible(HZ / 10);
-	} while (!kthread_should_stop() && fullstop == FULLSTOP_DONTSTOP);
+	} while (!torture_must_stop());
 	VERBOSE_TOROUT_STRING("rcu_torture_barrier task stopping");
 	torture_shutdown_absorb("rcu_torture_barrier");
 	while (!kthread_should_stop())
@@ -1584,7 +1577,6 @@ rcu_torture_init(void)
 	else
 		nrealreaders = 2 * num_online_cpus();
 	rcu_torture_print_module_parms(cur_ops, "Start of test");
-	fullstop = FULLSTOP_DONTSTOP;
 
 	/* Set up the freelist. */
 
diff --git a/kernel/torture.c b/kernel/torture.c
index b02fa2785bbb..ed360cf948da 100644
--- a/kernel/torture.c
+++ b/kernel/torture.c
@@ -52,8 +52,11 @@ MODULE_AUTHOR("Paul E. McKenney <paulmck@us.ibm.com>");
 static char *torture_type;
 static bool verbose;
 
-int fullstop = FULLSTOP_RMMOD;
-EXPORT_SYMBOL_GPL(fullstop);
+/* Mediate rmmod and system shutdown.  Concurrent rmmod & shutdown illegal! */
+#define FULLSTOP_DONTSTOP 0	/* Normal operation. */
+#define FULLSTOP_SHUTDOWN 1	/* System shutdown with torture running. */
+#define FULLSTOP_RMMOD    2	/* Normal rmmod of torture. */
+static int fullstop = FULLSTOP_RMMOD;
 static DEFINE_MUTEX(fullstop_mutex);
 
 #ifdef CONFIG_HOTPLUG_CPU
@@ -458,6 +461,7 @@ void __init torture_init_begin(char *ttype, bool v)
 	mutex_lock(&fullstop_mutex);
 	torture_type = ttype;
 	verbose = v;
+	fullstop = FULLSTOP_DONTSTOP;
 
 }
 EXPORT_SYMBOL_GPL(torture_init_begin);
@@ -498,3 +502,22 @@ bool torture_cleanup(void)
 	return false;
 }
 EXPORT_SYMBOL_GPL(torture_cleanup);
+
+/*
+ * Is it time for the current torture test to stop?
+ */
+bool torture_must_stop(void)
+{
+	return torture_must_stop_irq() || kthread_should_stop();
+}
+EXPORT_SYMBOL_GPL(torture_must_stop);
+
+/*
+ * Is it time for the current torture test to stop?  This is the irq-safe
+ * version, hence no check for kthread_should_stop().
+ */
+bool torture_must_stop_irq(void)
+{
+	return fullstop != FULLSTOP_DONTSTOP;
+}
+EXPORT_SYMBOL_GPL(torture_must_stop_irq);
-- 
1.8.1.5

