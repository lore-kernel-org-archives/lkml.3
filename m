Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750939AbaIFBFf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Sep 2014 21:05:35 -0400
Received: from qmta05.emeryville.ca.mail.comcast.net ([76.96.30.48]:55696 "EHLO
	qmta05.emeryville.ca.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750762AbaIFBFc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Sep 2014 21:05:32 -0400
Date: Thu, 4 Sep 2014 10:18:31 -0500 (CDT)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@gentwo.org
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
cc: Frederic Weisbecker <fweisbec@gmail.com>, linux-kernel@vger.kernel.org
Subject: dynticks: Remove atomic ops for dynticks_idle 
Message-ID: <alpine.DEB.2.11.1409041016410.4565@gentwo.org>
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is on top of the first patch (but still not against your tree). I
wonder what you think about this one. No special operations.


Since dynticks_idle is only ever modified by the local cpu we do
not need to use atomics there.

Signed-off-by: Christoph Lameter <cl@linux.com>

Index: linux/kernel/rcu/tree.c
===================================================================
--- linux.orig/kernel/rcu/tree.c
+++ linux/kernel/rcu/tree.c
@@ -213,7 +213,7 @@ static DEFINE_PER_CPU(struct rcu_dyntick
 	.dynticks = ATOMIC_INIT(1),
 #ifdef CONFIG_NO_HZ_FULL_SYSIDLE
 	.dynticks_idle_nesting = DYNTICK_TASK_NEST_VALUE,
-	.dynticks_idle = ATOMIC_INIT(1),
+	.dynticks_idle = 1,
 #endif /* #ifdef CONFIG_NO_HZ_FULL_SYSIDLE */
 };

Index: linux/kernel/rcu/tree.h
===================================================================
--- linux.orig/kernel/rcu/tree.h
+++ linux/kernel/rcu/tree.h
@@ -91,7 +91,7 @@ struct rcu_dynticks {
 #ifdef CONFIG_NO_HZ_FULL_SYSIDLE
 	long long dynticks_idle_nesting;
 				    /* irq/process nesting level from idle. */
-	atomic_t dynticks_idle;	    /* Even value for idle, else odd. */
+	long dynticks_idle;	    /* Even value for idle, else odd. */
 				    /*  "Idle" excludes userspace execution. */
 	unsigned long dynticks_idle_jiffies;
 				    /* End of last non-NMI non-idle period. */
Index: linux/kernel/rcu/tree_plugin.h
===================================================================
--- linux.orig/kernel/rcu/tree_plugin.h
+++ linux/kernel/rcu/tree_plugin.h
@@ -2644,9 +2644,9 @@ static void rcu_sysidle_enter(int irq)
 	j = jiffies;
 	ACCESS_ONCE(rdtp->dynticks_idle_jiffies) = j;
 	smp_mb__before_atomic();
-	atomic_inc(&rdtp->dynticks_idle);
+	rdtp->dynticks_idle++;
 	smp_mb__after_atomic();
-	WARN_ON_ONCE(atomic_read(&rdtp->dynticks_idle) & 0x1);
+	WARN_ON_ONCE(rdtp->dynticks_idle & 0x1);
 }

 /*
@@ -2712,9 +2712,9 @@ static void rcu_sysidle_exit(int irq)

 	/* Record end of idle period. */
 	smp_mb__before_atomic();
-	atomic_inc(&rdtp->dynticks_idle);
+	rdtp->dynticks_idle++;
 	smp_mb__after_atomic();
-	WARN_ON_ONCE(!(atomic_read(&rdtp->dynticks_idle) & 0x1));
+	WARN_ON_ONCE(!(rdtp->dynticks_idle & 0x1));

 	/*
 	 * If we are the timekeeping CPU, we are permitted to be non-idle
@@ -2755,7 +2755,7 @@ static void rcu_sysidle_check_cpu(struct
 		WARN_ON_ONCE(smp_processor_id() != tick_do_timer_cpu);

 	/* Pick up current idle and NMI-nesting counter and check. */
-	cur = atomic_read(&rdtp->dynticks_idle);
+	cur = rdtp->dynticks_idle;
 	if (cur & 0x1) {
 		*isidle = false; /* We are not idle! */
 		return;
