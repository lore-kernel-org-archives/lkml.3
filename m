Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754317AbaILDnA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Sep 2014 23:43:00 -0400
Received: from homie.mail.dreamhost.com ([208.97.132.208]:58924 "EHLO
	homiemail-a3.g.dreamhost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754126AbaILDlt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Sep 2014 23:41:49 -0400
From: Davidlohr Bueso <dave@stgolabs.net>
To: paulmck@linux.vnet.ibm.com
Cc: peterz@infradead.org, mingo@kernel.org, linux-kernel@vger.kernel.org,
        dave@stgolabs.net, Davidlohr Bueso <dbueso@suse.de>
Subject: [PATCH 3/9] locktorture: Support mutexes
Date: Thu, 11 Sep 2014 20:40:18 -0700
Message-Id: <1410493224-3312-4-git-send-email-dave@stgolabs.net>
X-Mailer: git-send-email 1.8.4.5
In-Reply-To: <1410493224-3312-1-git-send-email-dave@stgolabs.net>
References: <1410493224-3312-1-git-send-email-dave@stgolabs.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add a "mutex_lock" torture test. The main difference with the already
existing spinlock tests is that the latency of the critical region
is much larger. We randomly delay for (arbitrarily) either 500 ms or,
otherwise, 25 ms. While this can considerably reduce the amount of
writes compared to non blocking locks, if run long enough it can have
the same torturous effect. Furthermore it is more representative of
mutex hold times and can stress better things like thrashing.

Signed-off-by: Davidlohr Bueso <dbueso@suse.de>
---
 Documentation/locking/locktorture.txt |  2 ++
 kernel/locking/locktorture.c          | 41 +++++++++++++++++++++++++++++++++--
 2 files changed, 41 insertions(+), 2 deletions(-)

diff --git a/Documentation/locking/locktorture.txt b/Documentation/locking/locktorture.txt
index c0ab969..6b1e7ca 100644
--- a/Documentation/locking/locktorture.txt
+++ b/Documentation/locking/locktorture.txt
@@ -40,6 +40,8 @@ torture_type	  Type of lock to torture. By default, only spinlocks will
 		     o "spin_lock_irq": spin_lock_irq() and spin_unlock_irq()
 					pairs.
 
+		     o "mutex_lock": mutex_lock() and mutex_unlock() pairs.
+
 torture_runnable  Start locktorture at module init. By default it will begin
 		  once the module is loaded.
 
diff --git a/kernel/locking/locktorture.c b/kernel/locking/locktorture.c
index 8c770b2..414ba45 100644
--- a/kernel/locking/locktorture.c
+++ b/kernel/locking/locktorture.c
@@ -27,6 +27,7 @@
 #include <linux/kthread.h>
 #include <linux/err.h>
 #include <linux/spinlock.h>
+#include <linux/mutex.h>
 #include <linux/smp.h>
 #include <linux/interrupt.h>
 #include <linux/sched.h>
@@ -66,7 +67,7 @@ torture_param(bool, verbose, true,
 static char *torture_type = "spin_lock";
 module_param(torture_type, charp, 0444);
 MODULE_PARM_DESC(torture_type,
-		 "Type of lock to torture (spin_lock, spin_lock_irq, ...)");
+		 "Type of lock to torture (spin_lock, spin_lock_irq, mutex_lock, ...)");
 
 static atomic_t n_lock_torture_errors;
 
@@ -206,6 +207,42 @@ static struct lock_torture_ops spin_lock_irq_ops = {
 	.name		= "spin_lock_irq"
 };
 
+static DEFINE_MUTEX(torture_mutex);
+
+static int torture_mutex_lock(void) __acquires(torture_mutex)
+{
+	mutex_lock(&torture_mutex);
+	return 0;
+}
+
+static void torture_mutex_delay(struct torture_random_state *trsp)
+{
+	const unsigned long longdelay_ms = 100;
+
+	/* We want a long delay occasionally to force massive contention.  */
+	if (!(torture_random(trsp) %
+	      (nrealwriters_stress * 2000 * longdelay_ms)))
+		mdelay(longdelay_ms * 5);
+	else
+		mdelay(longdelay_ms / 5);
+#ifdef CONFIG_PREEMPT
+	if (!(torture_random(trsp) % (nrealwriters_stress * 20000)))
+		preempt_schedule();  /* Allow test to be preempted. */
+#endif
+}
+
+static void torture_mutex_unlock(void) __releases(torture_mutex)
+{
+	mutex_unlock(&torture_mutex);
+}
+
+static struct lock_torture_ops mutex_lock_ops = {
+	.writelock	= torture_mutex_lock,
+	.write_delay	= torture_mutex_delay,
+	.writeunlock	= torture_mutex_unlock,
+	.name		= "mutex_lock"
+};
+
 /*
  * Lock torture writer kthread.  Repeatedly acquires and releases
  * the lock, checking for duplicate acquisitions.
@@ -352,7 +389,7 @@ static int __init lock_torture_init(void)
 	int i;
 	int firsterr = 0;
 	static struct lock_torture_ops *torture_ops[] = {
-		&lock_busted_ops, &spin_lock_ops, &spin_lock_irq_ops,
+		&lock_busted_ops, &spin_lock_ops, &spin_lock_irq_ops, &mutex_lock_ops,
 	};
 
 	if (!torture_init_begin(torture_type, verbose, &torture_runnable))
-- 
1.8.4.5

