Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756054Ab3JPOob (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Oct 2013 10:44:31 -0400
Received: from a9-70.smtp-out.amazonses.com ([54.240.9.70]:53733 "EHLO
	a9-70.smtp-out.amazonses.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752074Ab3JPOoa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Oct 2013 10:44:30 -0400
Date: Wed, 16 Oct 2013 14:44:28 +0000
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@gentwo.org
To: Frederic Weisbecker <fweisbec@gmail.com>
cc: Mike Galbraith <bitbucket@online.de>, Thomas Gleixner <tglx@linutronix.de>,
        Gilad Ben-Yossef <gilad@benyossef.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Mike Frysinger <vapier@gentoo.org>
Subject: [PATCH] kmod: Run usermodehelpers only on cpus allowed for
 kthreadd
Message-ID: <00000141c1b99b20-64f9d142-961a-447e-8ebe-40f86b638278-000000@email.amazonses.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-SES-Outgoing: 2013.10.16-54.240.9.70
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a follow on patch related to the earlier
discussion about restricting the
spawning of kernel threads. See https://lkml.org/lkml/2013/9/5/426




usermodehelper() threads can currently run on all processors.
This is an issue for low latency cores.

Restrict usermodehelper() threads to the cores that kthreadd is
restricted to.

The default for kthreadd is to be allowed to run on an processors.
If the user restricts kthreadd then threads spawned by
usermodhelper() will similarly restricted.

Before this patch there is no way to limit the cpus that usermodehelper
can run on since the affinity is set when the thread is spawned to
all processors.

Signed-off-by: Christoph Lameter <cl@linux.com>

Index: linux/include/linux/kthread.h
===================================================================
--- linux.orig/include/linux/kthread.h	2013-10-10 11:00:34.167771996 -0500
+++ linux/include/linux/kthread.h	2013-10-15 13:57:52.859056676 -0500
@@ -51,6 +51,7 @@ void kthread_parkme(void);
 int kthreadd(void *unused);
 extern struct task_struct *kthreadd_task;
 extern int tsk_fork_get_node(struct task_struct *tsk);
+void set_kthreadd_affinity(void);

 /*
  * Simple work processor based on kthread.
Index: linux/kernel/kmod.c
===================================================================
--- linux.orig/kernel/kmod.c	2013-10-10 11:00:39.091771917 -0500
+++ linux/kernel/kmod.c	2013-10-15 14:02:01.904261324 -0500
@@ -40,6 +40,7 @@
 #include <linux/ptrace.h>
 #include <linux/async.h>
 #include <asm/uaccess.h>
+#include <linux/kthread.h>

 #include <trace/events/module.h>

@@ -209,8 +210,8 @@ static int ____call_usermodehelper(void
 	flush_signal_handlers(current, 1);
 	spin_unlock_irq(&current->sighand->siglock);

-	/* We can run anywhere, unlike our parent keventd(). */
-	set_cpus_allowed_ptr(current, cpu_all_mask);
+	/* We can run anywhere kthreadd can run */
+	set_kthreadd_affinity();

 	/*
 	 * Our parent is keventd, which runs with elevated scheduling priority.
Index: linux/kernel/kthread.c
===================================================================
--- linux.orig/kernel/kthread.c	2013-10-10 11:00:39.139771916 -0500
+++ linux/kernel/kthread.c	2013-10-15 14:04:36.636043744 -0500
@@ -136,6 +136,15 @@ void *kthread_data(struct task_struct *t
 	return to_kthread(task)->data;
 }

+/*
+ * Set the affinity of the calling task to be the same
+ * as the kthreadd affinities.
+ */
+void set_kthreadd_affinity(void)
+{
+	set_cpus_allowed(current, kthreadd_task->cpus_allowed);
+}
+
 /**
  * probe_kthread_data - speculative version of kthread_data()
  * @task: possible kthread task in question
