Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751759AbaILEno (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Sep 2014 00:43:44 -0400
Received: from homie.mail.dreamhost.com ([208.97.132.208]:46666 "EHLO
	homiemail-a8.g.dreamhost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751346AbaILEnn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Sep 2014 00:43:43 -0400
Message-ID: <1410496945.2166.12.camel@linux-t7sj.site>
Subject: [PATCH 9/9] locktorture: Introduce torture context
From: Davidlohr Bueso <dave@stgolabs.net>
To: paulmck@linux.vnet.ibm.com
Cc: peterz@infradead.org, mingo@kernel.org, linux-kernel@vger.kernel.org,
        dave@stgolabs.net, dbueso@suse.de
Date: Thu, 11 Sep 2014 21:42:25 -0700
In-Reply-To: <1410493224-3312-1-git-send-email-dave@stgolabs.net>
References: <1410493224-3312-1-git-send-email-dave@stgolabs.net>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.2 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The amount of global variables is getting pretty ugly. Group variables
related to the execution (ie: not parameters) in a new context structure.

Signed-off-by: Davidlohr Bueso <dbueso@suse.de>
---
 kernel/locking/locktorture.c | 161 ++++++++++++++++++++++---------------------
 1 file changed, 82 insertions(+), 79 deletions(-)

diff --git a/kernel/locking/locktorture.c b/kernel/locking/locktorture.c
index 8480118..540d5df 100644
--- a/kernel/locking/locktorture.c
+++ b/kernel/locking/locktorture.c
@@ -66,29 +66,22 @@ torture_param(int, stutter, 5, "Number of jiffies to run/halt test, 0=disable");
 torture_param(bool, verbose, true,
 	     "Enable verbose debugging printk()s");
 
-static bool debug_lock = false;
 static char *torture_type = "spin_lock";
 module_param(torture_type, charp, 0444);
 MODULE_PARM_DESC(torture_type,
 		 "Type of lock to torture (spin_lock, spin_lock_irq, mutex_lock, ...)");
 
-static atomic_t n_lock_torture_errors;
-
 static struct task_struct *stats_task;
 static struct task_struct **writer_tasks;
 static struct task_struct **reader_tasks;
 
-static int nrealwriters_stress;
 static bool lock_is_write_held;
-static int nrealreaders_stress;
 static bool lock_is_read_held;
 
 struct lock_stress_stats {
 	long n_lock_fail;
 	long n_lock_acquired;
 };
-static struct lock_stress_stats *lwsa; /* writer statistics */
-static struct lock_stress_stats *lrsa; /* reader statistics */
 
 #if defined(MODULE)
 #define LOCKTORTURE_RUNNABLE_INIT 1
@@ -117,8 +110,18 @@ struct lock_torture_ops {
 	const char *name;
 };
 
-static struct lock_torture_ops *cur_ops;
-
+struct lock_torture_cxt {
+	int nrealwriters_stress;
+	int nrealreaders_stress;
+	bool debug_lock;
+	atomic_t n_lock_torture_errors;
+	struct lock_torture_ops *cur_ops;
+	struct lock_stress_stats *lwsa; /* writer statistics */
+	struct lock_stress_stats *lrsa; /* reader statistics */
+};
+static struct lock_torture_cxt cxt = { 0, 0, false,
+				       ATOMIC_INIT(0),
+				       NULL, NULL};
 /*
  * Definitions for lock torture testing.
  */
@@ -134,10 +137,10 @@ static void torture_lock_busted_write_delay(struct torture_random_state *trsp)
 
 	/* We want a long delay occasionally to force massive contention.  */
 	if (!(torture_random(trsp) %
-	      (nrealwriters_stress * 2000 * longdelay_us)))
+	      (cxt.nrealwriters_stress * 2000 * longdelay_us)))
 		mdelay(longdelay_us);
 #ifdef CONFIG_PREEMPT
-	if (!(torture_random(trsp) % (nrealwriters_stress * 20000)))
+	if (!(torture_random(trsp) % (cxt.nrealwriters_stress * 20000)))
 		preempt_schedule();  /* Allow test to be preempted. */
 #endif
 }
@@ -174,13 +177,13 @@ static void torture_spin_lock_write_delay(struct torture_random_state *trsp)
 	 * we want a long delay occasionally to force massive contention.
 	 */
 	if (!(torture_random(trsp) %
-	      (nrealwriters_stress * 2000 * longdelay_us)))
+	      (cxt.nrealwriters_stress * 2000 * longdelay_us)))
 		mdelay(longdelay_us);
 	if (!(torture_random(trsp) %
-	      (nrealwriters_stress * 2 * shortdelay_us)))
+	      (cxt.nrealwriters_stress * 2 * shortdelay_us)))
 		udelay(shortdelay_us);
 #ifdef CONFIG_PREEMPT
-	if (!(torture_random(trsp) % (nrealwriters_stress * 20000)))
+	if (!(torture_random(trsp) % (cxt.nrealwriters_stress * 20000)))
 		preempt_schedule();  /* Allow test to be preempted. */
 #endif
 }
@@ -206,14 +209,14 @@ __acquires(torture_spinlock_irq)
 	unsigned long flags;
 
 	spin_lock_irqsave(&torture_spinlock, flags);
-	cur_ops->flags = flags;
+	cxt.cur_ops->flags = flags;
 	return 0;
 }
 
 static void torture_lock_spin_write_unlock_irq(void)
 __releases(torture_spinlock)
 {
-	spin_unlock_irqrestore(&torture_spinlock, cur_ops->flags);
+	spin_unlock_irqrestore(&torture_spinlock, cxt.cur_ops->flags);
 }
 
 static struct lock_torture_ops spin_lock_irq_ops = {
@@ -240,12 +243,12 @@ static void torture_mutex_delay(struct torture_random_state *trsp)
 
 	/* We want a long delay occasionally to force massive contention.  */
 	if (!(torture_random(trsp) %
-	      (nrealwriters_stress * 2000 * longdelay_ms)))
+	      (cxt.nrealwriters_stress * 2000 * longdelay_ms)))
 		mdelay(longdelay_ms * 5);
 	else
 		mdelay(longdelay_ms / 5);
 #ifdef CONFIG_PREEMPT
-	if (!(torture_random(trsp) % (nrealwriters_stress * 20000)))
+	if (!(torture_random(trsp) % (cxt.nrealwriters_stress * 20000)))
 		preempt_schedule();  /* Allow test to be preempted. */
 #endif
 }
@@ -278,12 +281,12 @@ static void torture_rwsem_write_delay(struct torture_random_state *trsp)
 
 	/* We want a long delay occasionally to force massive contention.  */
 	if (!(torture_random(trsp) %
-	      (nrealwriters_stress * 2000 * longdelay_ms)))
+	      (cxt.nrealwriters_stress * 2000 * longdelay_ms)))
 		mdelay(longdelay_ms * 10);
 	else
 		mdelay(longdelay_ms / 10);
 #ifdef CONFIG_PREEMPT
-	if (!(torture_random(trsp) % (nrealwriters_stress * 20000)))
+	if (!(torture_random(trsp) % (cxt.nrealwriters_stress * 20000)))
 		preempt_schedule();  /* Allow test to be preempted. */
 #endif
 }
@@ -305,12 +308,12 @@ static void torture_rwsem_read_delay(struct torture_random_state *trsp)
 
 	/* We want a long delay occasionally to force massive contention.  */
 	if (!(torture_random(trsp) %
-	      (nrealwriters_stress * 2000 * longdelay_ms)))
+	      (cxt.nrealwriters_stress * 2000 * longdelay_ms)))
 		mdelay(longdelay_ms * 2);
 	else
 		mdelay(longdelay_ms / 2);
 #ifdef CONFIG_PREEMPT
-	if (!(torture_random(trsp) % (nrealreaders_stress * 20000)))
+	if (!(torture_random(trsp) % (cxt.nrealreaders_stress * 20000)))
 		preempt_schedule();  /* Allow test to be preempted. */
 #endif
 }
@@ -345,14 +348,14 @@ static int lock_torture_writer(void *arg)
 	do {
 		if ((torture_random(&rand) & 0xfffff) == 0)
 			schedule_timeout_uninterruptible(1);
-		cur_ops->writelock();
+		cxt.cur_ops->writelock();
 		if (WARN_ON_ONCE(lock_is_write_held))
 			lwsp->n_lock_fail++;
 		lock_is_write_held = 1;
 		lwsp->n_lock_acquired++;
-		cur_ops->write_delay(&rand);
+		cxt.cur_ops->write_delay(&rand);
 		lock_is_write_held = 0;
-		cur_ops->writeunlock();
+		cxt.cur_ops->writeunlock();
 		stutter_wait("lock_torture_writer");
 	} while (!torture_must_stop());
 	torture_kthread_stopping("lock_torture_writer");
@@ -374,12 +377,12 @@ static int lock_torture_reader(void *arg)
 	do {
 		if ((torture_random(&rand) & 0xfffff) == 0)
 			schedule_timeout_uninterruptible(1);
-		cur_ops->readlock();
+		cxt.cur_ops->readlock();
 		lock_is_read_held = 1;
 		lrsp->n_lock_acquired++;
-		cur_ops->read_delay(&rand);
+		cxt.cur_ops->read_delay(&rand);
 		lock_is_read_held = 0;
-		cur_ops->readunlock();
+		cxt.cur_ops->readunlock();
 		stutter_wait("lock_torture_reader");
 	} while (!torture_must_stop());
 	torture_kthread_stopping("lock_torture_reader");
@@ -398,7 +401,7 @@ static void __torture_print_stats(char *page,
 	long min = statp[0].n_lock_acquired;
 	long long sum = 0;
 
-	n_stress = write ? nrealwriters_stress : nrealreaders_stress;
+	n_stress = write ? cxt.nrealwriters_stress : cxt.nrealreaders_stress;
 	for (i = 0; i < n_stress; i++) {
 		if (statp[i].n_lock_fail)
 			fail = true;
@@ -414,7 +417,7 @@ static void __torture_print_stats(char *page,
 			sum, max, min, max / 2 > min ? "???" : "",
 			fail, fail ? "!!!" : "");
 	if (fail)
-		atomic_inc(&n_lock_torture_errors);
+		atomic_inc(&cxt.n_lock_torture_errors);
 }
 
 /*
@@ -427,11 +430,11 @@ static void __torture_print_stats(char *page,
  */
 static void lock_torture_stats_print(void)
 {
-	int size = nrealwriters_stress * 200 + 8192;
+	int size = cxt.nrealwriters_stress * 200 + 8192;
 	char *buf;
 
-	if (cur_ops->readlock)
-		size += nrealreaders_stress * 200 + 8192;
+	if (cxt.cur_ops->readlock)
+		size += cxt.nrealreaders_stress * 200 + 8192;
 
 	buf = kmalloc(size, GFP_KERNEL);
 	if (!buf) {
@@ -440,11 +443,11 @@ static void lock_torture_stats_print(void)
 		return;
 	}
 
-	__torture_print_stats(buf, lwsa, true);
+	__torture_print_stats(buf, cxt.lwsa, true);
 	pr_alert("%s", buf);
 	kfree(buf);
 
-	if (cur_ops->readlock) {
+	if (cxt.cur_ops->readlock) {
 		buf = kmalloc(size, GFP_KERNEL);
 		if (!buf) {
 			pr_err("lock_torture_stats_print: Out of memory, need: %d",
@@ -452,7 +455,7 @@ static void lock_torture_stats_print(void)
 			return;
 		}
 
-		__torture_print_stats(buf, lrsa, false);
+		__torture_print_stats(buf, cxt.lrsa, false);
 		pr_alert("%s", buf);
 		kfree(buf);
 	}
@@ -483,8 +486,8 @@ lock_torture_print_module_parms(struct lock_torture_ops *cur_ops,
 {
 	pr_alert("%s" TORTURE_FLAG
 		 "--- %s%s: nwriters_stress=%d nreaders_stress=%d stat_interval=%d verbose=%d shuffle_interval=%d stutter=%d shutdown_secs=%d onoff_interval=%d onoff_holdoff=%d\n",
-		 torture_type, tag, debug_lock ? " [debug]": "",
-		 nrealwriters_stress, nrealreaders_stress, stat_interval,
+		 torture_type, tag, cxt.debug_lock ? " [debug]": "",
+		 cxt.nrealwriters_stress, cxt.nrealreaders_stress, stat_interval,
 		 verbose, shuffle_interval, stutter, shutdown_secs,
 		 onoff_interval, onoff_holdoff);
 }
@@ -497,7 +500,7 @@ static void lock_torture_cleanup(void)
 		return;
 
 	if (writer_tasks) {
-		for (i = 0; i < nrealwriters_stress; i++)
+		for (i = 0; i < cxt.nrealwriters_stress; i++)
 			torture_stop_kthread(lock_torture_writer,
 					     writer_tasks[i]);
 		kfree(writer_tasks);
@@ -505,7 +508,7 @@ static void lock_torture_cleanup(void)
 	}
 
 	if (reader_tasks) {
-		for (i = 0; i < nrealreaders_stress; i++)
+		for (i = 0; i < cxt.nrealreaders_stress; i++)
 			torture_stop_kthread(lock_torture_reader,
 					     reader_tasks[i]);
 		kfree(reader_tasks);
@@ -515,14 +518,14 @@ static void lock_torture_cleanup(void)
 	torture_stop_kthread(lock_torture_stats, stats_task);
 	lock_torture_stats_print();  /* -After- the stats thread is stopped! */
 
-	if (atomic_read(&n_lock_torture_errors))
-		lock_torture_print_module_parms(cur_ops,
+	if (atomic_read(&cxt.n_lock_torture_errors))
+		lock_torture_print_module_parms(cxt.cur_ops,
 						"End of test: FAILURE");
 	else if (torture_onoff_failures())
-		lock_torture_print_module_parms(cur_ops,
+		lock_torture_print_module_parms(cxt.cur_ops,
 						"End of test: LOCK_HOTPLUG");
 	else
-		lock_torture_print_module_parms(cur_ops,
+		lock_torture_print_module_parms(cxt.cur_ops,
 						"End of test: SUCCESS");
 	torture_cleanup_end();
 }
@@ -541,8 +544,8 @@ static int __init lock_torture_init(void)
 
 	/* Process args and tell the world that the torturer is on the job. */
 	for (i = 0; i < ARRAY_SIZE(torture_ops); i++) {
-		cur_ops = torture_ops[i];
-		if (strcmp(torture_type, cur_ops->name) == 0)
+		cxt.cur_ops = torture_ops[i];
+		if (strcmp(torture_type, cxt.cur_ops->name) == 0)
 			break;
 	}
 	if (i == ARRAY_SIZE(torture_ops)) {
@@ -555,40 +558,40 @@ static int __init lock_torture_init(void)
 		torture_init_end();
 		return -EINVAL;
 	}
-	if (cur_ops->init)
-		cur_ops->init(); /* no "goto unwind" prior to this point!!! */
+	if (cxt.cur_ops->init)
+		cxt.cur_ops->init(); /* no "goto unwind" prior to this point!!! */
 
 	if (nwriters_stress >= 0)
-		nrealwriters_stress = nwriters_stress;
+		cxt.nrealwriters_stress = nwriters_stress;
 	else
-		nrealwriters_stress = 2 * num_online_cpus();
+		cxt.nrealwriters_stress = 2 * num_online_cpus();
 
 #ifdef CONFIG_DEBUG_MUTEXES
 	if (strncmp(torture_type, "mutex", 5) == 0)
-		debug_lock = true;
+		cxt.debug_lock = true;
 #endif
 #ifdef CONFIG_DEBUG_SPINLOCK
 	if (strncmp(torture_type, "spin", 4) == 0)
-		debug_lock = true;
+		cxt.debug_lock = true;
 #endif
 
 	/* Initialize the statistics so that each run gets its own numbers. */
 
 	lock_is_write_held = 0;
-	lwsa = kmalloc(sizeof(*lwsa) * nrealwriters_stress, GFP_KERNEL);
-	if (lwsa == NULL) {
-		VERBOSE_TOROUT_STRING("lwsa: Out of memory");
+	cxt.lwsa = kmalloc(sizeof(*cxt.lwsa) * cxt.nrealwriters_stress, GFP_KERNEL);
+	if (cxt.lwsa == NULL) {
+		VERBOSE_TOROUT_STRING("cxt.lwsa: Out of memory");
 		firsterr = -ENOMEM;
 		goto unwind;
 	}
-	for (i = 0; i < nrealwriters_stress; i++) {
-		lwsa[i].n_lock_fail = 0;
-		lwsa[i].n_lock_acquired = 0;
+	for (i = 0; i < cxt.nrealwriters_stress; i++) {
+		cxt.lwsa[i].n_lock_fail = 0;
+		cxt.lwsa[i].n_lock_acquired = 0;
 	}
 
-	if (cur_ops->readlock) {
+	if (cxt.cur_ops->readlock) {
 		if (nreaders_stress >= 0)
-			nrealreaders_stress = nreaders_stress;
+			cxt.nrealreaders_stress = nreaders_stress;
 		else {
 			/*
 			 * By default distribute evenly the number of
@@ -596,25 +599,25 @@ static int __init lock_torture_init(void)
 			 * of threads as the writer-only locks default.
 			 */
 			if (nwriters_stress < 0) /* user doesn't care */
-				nrealwriters_stress = num_online_cpus();
-			nrealreaders_stress = nrealwriters_stress;
+				cxt.nrealwriters_stress = num_online_cpus();
+			cxt.nrealreaders_stress = cxt.nrealwriters_stress;
 		}
 
 		lock_is_read_held = 0;
-		lrsa = kmalloc(sizeof(*lrsa) * nrealreaders_stress, GFP_KERNEL);
-		if (lrsa == NULL) {
-			VERBOSE_TOROUT_STRING("lrsa: Out of memory");
+		cxt.lrsa = kmalloc(sizeof(*cxt.lrsa) * cxt.nrealreaders_stress, GFP_KERNEL);
+		if (cxt.lrsa == NULL) {
+			VERBOSE_TOROUT_STRING("cxt.lrsa: Out of memory");
 			firsterr = -ENOMEM;
-			kfree(lwsa);
+			kfree(cxt.lwsa);
 			goto unwind;
 		}
 
-		for (i = 0; i < nrealreaders_stress; i++) {
-			lrsa[i].n_lock_fail = 0;
-			lrsa[i].n_lock_acquired = 0;
+		for (i = 0; i < cxt.nrealreaders_stress; i++) {
+			cxt.lrsa[i].n_lock_fail = 0;
+			cxt.lrsa[i].n_lock_acquired = 0;
 		}
 	}
-	lock_torture_print_module_parms(cur_ops, "Start of test");
+	lock_torture_print_module_parms(cxt.cur_ops, "Start of test");
 
 	/* Prepare torture context. */
 	if (onoff_interval > 0) {
@@ -640,7 +643,7 @@ static int __init lock_torture_init(void)
 			goto unwind;
 	}
 
-	writer_tasks = kzalloc(nrealwriters_stress * sizeof(writer_tasks[0]),
+	writer_tasks = kzalloc(cxt.nrealwriters_stress * sizeof(writer_tasks[0]),
 			       GFP_KERNEL);
 	if (writer_tasks == NULL) {
 		VERBOSE_TOROUT_ERRSTRING("writer_tasks: Out of memory");
@@ -648,8 +651,8 @@ static int __init lock_torture_init(void)
 		goto unwind;
 	}
 
-	if (cur_ops->readlock) {
-		reader_tasks = kzalloc(nrealreaders_stress * sizeof(reader_tasks[0]),
+	if (cxt.cur_ops->readlock) {
+		reader_tasks = kzalloc(cxt.nrealreaders_stress * sizeof(reader_tasks[0]),
 				       GFP_KERNEL);
 		if (reader_tasks == NULL) {
 			VERBOSE_TOROUT_ERRSTRING("reader_tasks: Out of memory");
@@ -666,22 +669,22 @@ static int __init lock_torture_init(void)
 	 * for very specific needs, or even let the user choose the policy, if
 	 * ever wanted.
 	 */
-	for (i = 0, j = 0; i < nrealwriters_stress ||
-		    j < nrealreaders_stress; i++, j++) {
-		if (i >= nrealwriters_stress)
+	for (i = 0, j = 0; i < cxt.nrealwriters_stress ||
+		    j < cxt.nrealreaders_stress; i++, j++) {
+		if (i >= cxt.nrealwriters_stress)
 			goto create_reader;
 
 		/* Create writer. */
-		firsterr = torture_create_kthread(lock_torture_writer, &lwsa[i],
+		firsterr = torture_create_kthread(lock_torture_writer, &cxt.lwsa[i],
 						  writer_tasks[i]);
 		if (firsterr)
 			goto unwind;
 
 	create_reader:
-		if (cur_ops->readlock == NULL || (j >= nrealreaders_stress))
+		if (cxt.cur_ops->readlock == NULL || (j >= cxt.nrealreaders_stress))
 			continue;
 		/* Create reader. */
-		firsterr = torture_create_kthread(lock_torture_reader, &lrsa[j],
+		firsterr = torture_create_kthread(lock_torture_reader, &cxt.lrsa[j],
 						  reader_tasks[j]);
 		if (firsterr)
 			goto unwind;
-- 
1.8.4.5



