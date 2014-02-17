Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753861AbaBQW0B (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Feb 2014 17:26:01 -0500
Received: from e31.co.us.ibm.com ([32.97.110.149]:35170 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753702AbaBQWNS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Feb 2014 17:13:18 -0500
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@kernel.org, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@efficios.com,
        josh@joshtriplett.org, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, dhowells@redhat.com,
        edumazet@google.com, darren@dvhart.com, fweisbec@gmail.com,
        oleg@redhat.com, sbw@mit.edu,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH tip/core/rcu 17/55] rcutorture: Abstract torture_param()
Date: Mon, 17 Feb 2014 14:12:21 -0800
Message-Id: <1392675179-11560-17-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.8.1.5
In-Reply-To: <1392675179-11560-1-git-send-email-paulmck@linux.vnet.ibm.com>
References: <20140217221231.GA8419@linux.vnet.ibm.com>
 <1392675179-11560-1-git-send-email-paulmck@linux.vnet.ibm.com>
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14021722-8236-0000-0000-0000074F3823
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>

Create a torture_param() macro and apply it to rcutorture in order to
save a few lines of code.  This same macro may be applied to other
torture frameworks.

Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---
 include/linux/torture.h |   9 ++++-
 kernel/rcu/rcutorture.c | 102 ++++++++++++++++--------------------------------
 2 files changed, 40 insertions(+), 71 deletions(-)

diff --git a/include/linux/torture.h b/include/linux/torture.h
index 979e3e6b378a..368e15bb1a39 100644
--- a/include/linux/torture.h
+++ b/include/linux/torture.h
@@ -35,13 +35,18 @@
 #include <linux/bug.h>
 #include <linux/compiler.h>
 
+/* Definitions for a non-string torture-test module parameter. */
+#define torture_parm(type, name, init, msg) \
+	static type name = init; \
+	module_param(name, type, 0444); \
+	MODULE_PARM_DESC(name, msg);
+
+/* Low-rider random number generator. */
 struct torture_random_state {
 	unsigned long trs_state;
 	long trs_count;
 };
-
 #define DEFINE_TORTURE_RANDOM(name) struct torture_random_state name = { 0, 0 }
-
 unsigned long torture_random(struct torture_random_state *trsp);
 
 #endif /* __LINUX_TORTURE_H */
diff --git a/kernel/rcu/rcutorture.c b/kernel/rcu/rcutorture.c
index c4f861cd90de..d09183d55817 100644
--- a/kernel/rcu/rcutorture.c
+++ b/kernel/rcu/rcutorture.c
@@ -59,78 +59,42 @@ MODULE_ALIAS("rcutorture");
 #endif
 #define MODULE_PARAM_PREFIX "rcutorture."
 
-static int fqs_duration;
-module_param(fqs_duration, int, 0444);
-MODULE_PARM_DESC(fqs_duration, "Duration of fqs bursts (us), 0 to disable");
-static int fqs_holdoff;
-module_param(fqs_holdoff, int, 0444);
-MODULE_PARM_DESC(fqs_holdoff, "Holdoff time within fqs bursts (us)");
-static int fqs_stutter = 3;
-module_param(fqs_stutter, int, 0444);
-MODULE_PARM_DESC(fqs_stutter, "Wait time between fqs bursts (s)");
-static bool gp_exp;
-module_param(gp_exp, bool, 0444);
-MODULE_PARM_DESC(gp_exp, "Use expedited GP wait primitives");
-static bool gp_normal;
-module_param(gp_normal, bool, 0444);
-MODULE_PARM_DESC(gp_normal, "Use normal (non-expedited) GP wait primitives");
-static int irqreader = 1;
-module_param(irqreader, int, 0444);
-MODULE_PARM_DESC(irqreader, "Allow RCU readers from irq handlers");
-static int n_barrier_cbs;
-module_param(n_barrier_cbs, int, 0444);
-MODULE_PARM_DESC(n_barrier_cbs, "# of callbacks/kthreads for barrier testing");
-static int nfakewriters = 4;
-module_param(nfakewriters, int, 0444);
-MODULE_PARM_DESC(nfakewriters, "Number of RCU fake writer threads");
-static int nreaders = -1;
-module_param(nreaders, int, 0444);
-MODULE_PARM_DESC(nreaders, "Number of RCU reader threads");
-static int object_debug;
-module_param(object_debug, int, 0444);
-MODULE_PARM_DESC(object_debug, "Enable debug-object double call_rcu() testing");
-static int onoff_holdoff;
-module_param(onoff_holdoff, int, 0444);
-MODULE_PARM_DESC(onoff_holdoff, "Time after boot before CPU hotplugs (s)");
-static int onoff_interval;
-module_param(onoff_interval, int, 0444);
-MODULE_PARM_DESC(onoff_interval, "Time between CPU hotplugs (s), 0=disable");
-static int shuffle_interval = 3;
-module_param(shuffle_interval, int, 0444);
-MODULE_PARM_DESC(shuffle_interval, "Number of seconds between shuffles");
-static int shutdown_secs;
-module_param(shutdown_secs, int, 0444);
-MODULE_PARM_DESC(shutdown_secs, "Shutdown time (s), <= zero to disable.");
-static int stall_cpu;
-module_param(stall_cpu, int, 0444);
-MODULE_PARM_DESC(stall_cpu, "Stall duration (s), zero to disable.");
-static int stall_cpu_holdoff = 10;
-module_param(stall_cpu_holdoff, int, 0444);
-MODULE_PARM_DESC(stall_cpu_holdoff, "Time to wait before starting stall (s).");
-static int stat_interval = 60;
-module_param(stat_interval, int, 0644);
-MODULE_PARM_DESC(stat_interval, "Number of seconds between stats printk()s");
-static int stutter = 5;
-module_param(stutter, int, 0444);
-MODULE_PARM_DESC(stutter, "Number of seconds to run/halt test");
-static int test_boost = 1;
-module_param(test_boost, int, 0444);
-MODULE_PARM_DESC(test_boost, "Test RCU prio boost: 0=no, 1=maybe, 2=yes.");
-static int test_boost_duration = 4;
-module_param(test_boost_duration, int, 0444);
-MODULE_PARM_DESC(test_boost_duration, "Duration of each boost test, seconds.");
-static int test_boost_interval = 7;
-module_param(test_boost_interval, int, 0444);
-MODULE_PARM_DESC(test_boost_interval, "Interval between boost tests, seconds.");
-static bool test_no_idle_hz = true;
-module_param(test_no_idle_hz, bool, 0444);
-MODULE_PARM_DESC(test_no_idle_hz, "Test support for tickless idle CPUs");
+torture_parm(int, fqs_duration, 0, "Duration of fqs bursts (us), 0 to disable");
+torture_parm(int, fqs_holdoff, 0, "Holdoff time within fqs bursts (us)");
+torture_parm(int, fqs_stutter, 3, "Wait time between fqs bursts (s)");
+torture_parm(bool, gp_exp, false, "Use expedited GP wait primitives");
+torture_parm(bool, gp_normal, false,
+	     "Use normal (non-expedited) GP wait primitives");
+torture_parm(int, irqreader, 1, "Allow RCU readers from irq handlers");
+torture_parm(int, n_barrier_cbs, 0,
+	     "# of callbacks/kthreads for barrier testing");
+torture_parm(int, nfakewriters, 4, "Number of RCU fake writer threads");
+torture_parm(int, nreaders, -1, "Number of RCU reader threads");
+torture_parm(int, object_debug, 0,
+	     "Enable debug-object double call_rcu() testing");
+torture_parm(int, onoff_holdoff, 0, "Time after boot before CPU hotplugs (s)");
+torture_parm(int, onoff_interval, 0,
+	     "Time between CPU hotplugs (s), 0=disable");
+torture_parm(int, shuffle_interval, 3, "Number of seconds between shuffles");
+torture_parm(int, shutdown_secs, 0, "Shutdown time (s), <= zero to disable.");
+torture_parm(int, stall_cpu, 0, "Stall duration (s), zero to disable.");
+torture_parm(int, stall_cpu_holdoff, 10,
+	     "Time to wait before starting stall (s).");
+torture_parm(int, stat_interval, 60,
+	     "Number of seconds between stats printk()s");
+torture_parm(int, stutter, 5, "Number of seconds to run/halt test");
+torture_parm(int, test_boost, 1, "Test RCU prio boost: 0=no, 1=maybe, 2=yes.");
+torture_parm(int, test_boost_duration, 4,
+	     "Duration of each boost test, seconds.");
+torture_parm(int, test_boost_interval, 7,
+	     "Interval between boost tests, seconds.");
+torture_parm(bool, test_no_idle_hz, true,
+	     "Test support for tickless idle CPUs");
+torture_parm(bool, verbose, false, "Enable verbose debugging printk()s");
+
 static char *torture_type = "rcu";
 module_param(torture_type, charp, 0444);
 MODULE_PARM_DESC(torture_type, "Type of RCU to torture (rcu, rcu_bh, ...)");
-static bool verbose;
-module_param(verbose, bool, 0444);
-MODULE_PARM_DESC(verbose, "Enable verbose debugging printk()s");
 
 #define TORTURE_FLAG "-torture:"
 #define PRINTK_STRING(s) \
-- 
1.8.1.5

