Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751377AbaILEmA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Sep 2014 00:42:00 -0400
Received: from homie.mail.dreamhost.com ([208.97.132.208]:36887 "EHLO
	homiemail-a6.g.dreamhost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750976AbaILEl7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Sep 2014 00:41:59 -0400
Message-ID: <1410496841.2166.10.camel@linux-t7sj.site>
Subject: [PATCH 7/9] locktorture: Add infrastructure for torturing read locks
From: Davidlohr Bueso <dave@stgolabs.net>
To: paulmck@linux.vnet.ibm.com
Cc: peterz@infradead.org, mingo@kernel.org, linux-kernel@vger.kernel.org,
        dave@stgolabs.net, dbueso@suse.de
Date: Thu, 11 Sep 2014 21:40:41 -0700
In-Reply-To: <1410493224-3312-1-git-send-email-dave@stgolabs.net>
References: <1410493224-3312-1-git-send-email-dave@stgolabs.net>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.2 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Most of it is based on what we already have for writers. This allows
readers to be very independent (and thus configurable), enabling
future module parameters to control things such as rw distribution.
Furthermore, readers have their own delaying function, allowing us
to test different rw critical region latencies, and stress locking
internals. Similarly, statistics, for now will only serve for the
number of lock acquisitions -- as opposed to writers, readers have
no failure detection.

In addition, introduce a new nreaders_stress module parameter. The
default number of readers will be the same number of writers threads.
Writer threads are interleaved with readers. Documentation is updated,
respectively.

Signed-off-by: Davidlohr Bueso <dbueso@suse.de>
---
 Documentation/locking/locktorture.txt |  16 +++-
 kernel/locking/locktorture.c          | 176 ++++++++++++++++++++++++++++++----
 2 files changed, 168 insertions(+), 24 deletions(-)

diff --git a/Documentation/locking/locktorture.txt b/Documentation/locking/locktorture.txt
index 6b1e7ca..1bdeb71 100644
--- a/Documentation/locking/locktorture.txt
+++ b/Documentation/locking/locktorture.txt
@@ -29,6 +29,11 @@ nwriters_stress   Number of kernel threads that will stress exclusive lock
 		  ownership (writers). The default value is twice the amount
 		  of online CPUs.
 
+nreaders_stress   Number of kernel threads that will stress shared lock
+		  ownership (readers). The default is the same amount of writer
+		  locks. If the user did not specify nwriters_stress, then
+		  both readers and writers be the amount of online CPUs.
+
 torture_type	  Type of lock to torture. By default, only spinlocks will
 		  be tortured. This module can torture the following locks,
 		  with string values as follows:
@@ -95,15 +100,18 @@ STATISTICS
 Statistics are printed in the following format:
 
 spin_lock-torture: Writes:  Total: 93746064  Max/Min: 0/0   Fail: 0
-   (A)				   (B)		  (C)	       (D)
+   (A)		    (B)		   (C)		  (D)	       (E)
 
 (A): Lock type that is being tortured -- torture_type parameter.
 
-(B): Number of times the lock was acquired.
+(B): Number of writer lock acquisitions. If dealing with a read/write primitive
+     a second "Reads" statistics line is printed.
+
+(C): Number of times the lock was acquired.
 
-(C): Min and max number of times threads failed to acquire the lock.
+(D): Min and max number of times threads failed to acquire the lock.
 
-(D): true/false values if there were errors acquiring the lock. This should
+(E): true/false values if there were errors acquiring the lock. This should
      -only- be positive if there is a bug in the locking primitive's
      implementation. Otherwise a lock should never fail (ie: spin_lock()).
      Of course, the same applies for (C), above. A dummy example of this is
diff --git a/kernel/locking/locktorture.c b/kernel/locking/locktorture.c
index 988267c..c1073d7 100644
--- a/kernel/locking/locktorture.c
+++ b/kernel/locking/locktorture.c
@@ -52,6 +52,8 @@ MODULE_AUTHOR("Paul E. McKenney <paulmck@us.ibm.com>");
 
 torture_param(int, nwriters_stress, -1,
 	     "Number of write-locking stress-test threads");
+torture_param(int, nreaders_stress, -1,
+	     "Number of read-locking stress-test threads");
 torture_param(int, onoff_holdoff, 0, "Time after boot before CPU hotplugs (s)");
 torture_param(int, onoff_interval, 0,
 	     "Time between CPU hotplugs (s), 0=disable");
@@ -74,15 +76,19 @@ static atomic_t n_lock_torture_errors;
 
 static struct task_struct *stats_task;
 static struct task_struct **writer_tasks;
+static struct task_struct **reader_tasks;
 
 static int nrealwriters_stress;
 static bool lock_is_write_held;
+static int nrealreaders_stress;
+static bool lock_is_read_held;
 
 struct lock_stress_stats {
 	long n_lock_fail;
 	long n_lock_acquired;
 };
 static struct lock_stress_stats *lwsa; /* writer statistics */
+static struct lock_stress_stats *lrsa; /* reader statistics */
 
 #if defined(MODULE)
 #define LOCKTORTURE_RUNNABLE_INIT 1
@@ -104,6 +110,9 @@ struct lock_torture_ops {
 	int (*writelock)(void);
 	void (*write_delay)(struct torture_random_state *trsp);
 	void (*writeunlock)(void);
+	int (*readlock)(void);
+	void (*read_delay)(struct torture_random_state *trsp);
+	void (*readunlock)(void);
 	unsigned long flags;
 	const char *name;
 };
@@ -142,6 +151,9 @@ static struct lock_torture_ops lock_busted_ops = {
 	.writelock	= torture_lock_busted_write_lock,
 	.write_delay	= torture_lock_busted_write_delay,
 	.writeunlock	= torture_lock_busted_write_unlock,
+	.readlock       = NULL,
+	.read_delay     = NULL,
+	.readunlock     = NULL,
 	.name		= "lock_busted"
 };
 
@@ -182,6 +194,9 @@ static struct lock_torture_ops spin_lock_ops = {
 	.writelock	= torture_spin_lock_write_lock,
 	.write_delay	= torture_spin_lock_write_delay,
 	.writeunlock	= torture_spin_lock_write_unlock,
+	.readlock       = NULL,
+	.read_delay     = NULL,
+	.readunlock     = NULL,
 	.name		= "spin_lock"
 };
 
@@ -205,6 +220,9 @@ static struct lock_torture_ops spin_lock_irq_ops = {
 	.writelock	= torture_spin_lock_write_lock_irq,
 	.write_delay	= torture_spin_lock_write_delay,
 	.writeunlock	= torture_lock_spin_write_unlock_irq,
+	.readlock       = NULL,
+	.read_delay     = NULL,
+	.readunlock     = NULL,
 	.name		= "spin_lock_irq"
 };
 
@@ -241,6 +259,9 @@ static struct lock_torture_ops mutex_lock_ops = {
 	.writelock	= torture_mutex_lock,
 	.write_delay	= torture_mutex_delay,
 	.writeunlock	= torture_mutex_unlock,
+	.readlock       = NULL,
+	.read_delay     = NULL,
+	.readunlock     = NULL,
 	.name		= "mutex_lock"
 };
 
@@ -274,28 +295,57 @@ static int lock_torture_writer(void *arg)
 }
 
 /*
+ * Lock torture reader kthread.  Repeatedly acquires and releases
+ * the reader lock.
+ */
+static int lock_torture_reader(void *arg)
+{
+	struct lock_stress_stats *lrsp = arg;
+	static DEFINE_TORTURE_RANDOM(rand);
+
+	VERBOSE_TOROUT_STRING("lock_torture_reader task started");
+	set_user_nice(current, MAX_NICE);
+
+	do {
+		if ((torture_random(&rand) & 0xfffff) == 0)
+			schedule_timeout_uninterruptible(1);
+		cur_ops->readlock();
+		lock_is_read_held = 1;
+		lrsp->n_lock_acquired++;
+		cur_ops->read_delay(&rand);
+		lock_is_read_held = 0;
+		cur_ops->readunlock();
+		stutter_wait("lock_torture_reader");
+	} while (!torture_must_stop());
+	torture_kthread_stopping("lock_torture_reader");
+	return 0;
+}
+
+/*
  * Create an lock-torture-statistics message in the specified buffer.
  */
-static void lock_torture_printk(char *page)
+static void __torture_print_stats(char *page,
+				  struct lock_stress_stats *statp, bool write)
 {
 	bool fail = 0;
-	int i;
+	int i, n_stress;
 	long max = 0;
-	long min = lwsa[0].n_lock_acquired;
+	long min = statp[0].n_lock_acquired;
 	long long sum = 0;
 
-	for (i = 0; i < nrealwriters_stress; i++) {
-		if (lwsa[i].n_lock_fail)
+	n_stress = write ? nrealwriters_stress : nrealreaders_stress;
+	for (i = 0; i < n_stress; i++) {
+		if (statp[i].n_lock_fail)
 			fail = true;
-		sum += lwsa[i].n_lock_acquired;
-		if (max < lwsa[i].n_lock_fail)
-			max = lwsa[i].n_lock_fail;
-		if (min > lwsa[i].n_lock_fail)
-			min = lwsa[i].n_lock_fail;
+		sum += statp[i].n_lock_acquired;
+		if (max < statp[i].n_lock_fail)
+			max = statp[i].n_lock_fail;
+		if (min > statp[i].n_lock_fail)
+			min = statp[i].n_lock_fail;
 	}
-	page += sprintf(page, "%s%s ", torture_type, TORTURE_FLAG);
 	page += sprintf(page,
-			"Writes:  Total: %lld  Max/Min: %ld/%ld %s  Fail: %d %s\n",
+			"%s:  Total: %lld  Max/Min: %ld/%ld %s  Fail: %d %s\n",
+			write ? "Writes" : "Reads ",
 			sum, max, min, max / 2 > min ? "???" : "",
 			fail, fail ? "!!!" : "");
 	if (fail)
@@ -315,15 +365,32 @@ static void lock_torture_stats_print(void)
 	int size = nrealwriters_stress * 200 + 8192;
 	char *buf;
 
+	if (cur_ops->readlock)
+		size += nrealreaders_stress * 200 + 8192;
+
 	buf = kmalloc(size, GFP_KERNEL);
 	if (!buf) {
 		pr_err("lock_torture_stats_print: Out of memory, need: %d",
 		       size);
 		return;
 	}
-	lock_torture_printk(buf);
+
+	__torture_print_stats(buf, lwsa, true);
 	pr_alert("%s", buf);
 	kfree(buf);
+
+	if (cur_ops->readlock) {
+		buf = kmalloc(size, GFP_KERNEL);
+		if (!buf) {
+			pr_err("lock_torture_stats_print: Out of memory, need: %d",
+			       size);
+			return;
+		}
+
+		__torture_print_stats(buf, lrsa, false);
+		pr_alert("%s", buf);
+		kfree(buf);
+	}
 }
 
 /*
@@ -350,10 +417,10 @@ lock_torture_print_module_parms(struct lock_torture_ops *cur_ops,
 				const char *tag)
 {
 	pr_alert("%s" TORTURE_FLAG
-		 "--- %s%s: nwriters_stress=%d stat_interval=%d verbose=%d shuffle_interval=%d stutter=%d shutdown_secs=%d onoff_interval=%d onoff_holdoff=%d\n",
+		 "--- %s%s: nwriters_stress=%d nreaders_stress=%d stat_interval=%d verbose=%d shuffle_interval=%d stutter=%d shutdown_secs=%d onoff_interval=%d onoff_holdoff=%d\n",
 		 torture_type, tag, debug_lock ? " [debug]": "",
-		 nrealwriters_stress, stat_interval, verbose,
-		 shuffle_interval, stutter, shutdown_secs,
+		 nrealwriters_stress, nrealreaders_stress, stat_interval,
+		 verbose, shuffle_interval, stutter, shutdown_secs,
 		 onoff_interval, onoff_holdoff);
 }
 
@@ -372,6 +439,14 @@ static void lock_torture_cleanup(void)
 		writer_tasks = NULL;
 	}
 
+	if (reader_tasks) {
+		for (i = 0; i < nrealreaders_stress; i++)
+			torture_stop_kthread(lock_torture_reader,
+					     reader_tasks[i]);
+		kfree(reader_tasks);
+		reader_tasks = NULL;
+	}
+
 	torture_stop_kthread(lock_torture_stats, stats_task);
 	lock_torture_stats_print();  /* -After- the stats thread is stopped! */
 
@@ -389,7 +464,7 @@ static void lock_torture_cleanup(void)
 
 static int __init lock_torture_init(void)
 {
-	int i;
+	int i, j;
 	int firsterr = 0;
 	static struct lock_torture_ops *torture_ops[] = {
 		&lock_busted_ops, &spin_lock_ops, &spin_lock_irq_ops, &mutex_lock_ops,
@@ -430,7 +505,6 @@ static int __init lock_torture_init(void)
 	if (strncmp(torture_type, "spin", 4) == 0)
 		debug_lock = true;
 #endif
-	lock_torture_print_module_parms(cur_ops, "Start of test");
 
 	/* Initialize the statistics so that each run gets its own numbers. */
 
@@ -446,8 +520,37 @@ static int __init lock_torture_init(void)
 		lwsa[i].n_lock_acquired = 0;
 	}
 
-	/* Start up the kthreads. */
+	if (cur_ops->readlock) {
+		if (nreaders_stress >= 0)
+			nrealreaders_stress = nreaders_stress;
+		else {
+			/*
+			 * By default distribute evenly the number of
+			 * readers and writers. We still run the same number
+			 * of threads as the writer-only locks default.
+			 */
+			if (nwriters_stress < 0) /* user doesn't care */
+				nrealwriters_stress = num_online_cpus();
+			nrealreaders_stress = nrealwriters_stress;
+		}
+
+		lock_is_read_held = 0;
+		lrsa = kmalloc(sizeof(*lrsa) * nrealreaders_stress, GFP_KERNEL);
+		if (lrsa == NULL) {
+			VERBOSE_TOROUT_STRING("lrsa: Out of memory");
+			firsterr = -ENOMEM;
+			kfree(lwsa);
+			goto unwind;
+		}
 
+		for (i = 0; i < nrealreaders_stress; i++) {
+			lrsa[i].n_lock_fail = 0;
+			lrsa[i].n_lock_acquired = 0;
+		}
+	}
+	lock_torture_print_module_parms(cur_ops, "Start of test");
+
+	/* Prepare torture context. */
 	if (onoff_interval > 0) {
 		firsterr = torture_onoff_init(onoff_holdoff * HZ,
 					      onoff_interval * HZ);
@@ -478,11 +581,44 @@ static int __init lock_torture_init(void)
 		firsterr = -ENOMEM;
 		goto unwind;
 	}
-	for (i = 0; i < nrealwriters_stress; i++) {
+
+	if (cur_ops->readlock) {
+		reader_tasks = kzalloc(nrealreaders_stress * sizeof(reader_tasks[0]),
+				       GFP_KERNEL);
+		if (reader_tasks == NULL) {
+			VERBOSE_TOROUT_ERRSTRING("reader_tasks: Out of memory");
+			firsterr = -ENOMEM;
+			goto unwind;
+		}
+	}
+
+	/*
+	 * Create the kthreads and start torturing (oh, those poor little locks).
+	 *
+	 * TODO: Note that we interleave writers with readers, giving writers a
+	 * slight advantage, by creating its kthread first. This can be modified
+	 * for very specific needs, or even let the user choose the policy, if
+	 * ever wanted.
+	 */
+	for (i = 0, j = 0; i < nrealwriters_stress ||
+		    j < nrealreaders_stress; i++, j++) {
+		if (i >= nrealwriters_stress)
+			goto create_reader;
+
+		/* Create writer. */
 		firsterr = torture_create_kthread(lock_torture_writer, &lwsa[i],
 						  writer_tasks[i]);
 		if (firsterr)
 			goto unwind;
+
+	create_reader:
+		if (cur_ops->readlock == NULL || (j >= nrealreaders_stress))
+			continue;
+		/* Create reader. */
+		firsterr = torture_create_kthread(lock_torture_reader, &lrsa[j],
+						  reader_tasks[j]);
+		if (firsterr)
+			goto unwind;
 	}
 	if (stat_interval > 0) {
 		firsterr = torture_create_kthread(lock_torture_stats, NULL,
-- 
1.8.4.5



