Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752903Ab3FZTbs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Jun 2013 15:31:48 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:13720 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752563Ab3FZTaw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Jun 2013 15:30:52 -0400
X-Authority-Analysis: v=2.0 cv=Odoa/2vY c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=Ciwy3NGCPMMA:10 a=kqR1iYK_dWsA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=KGjhK52YXX0A:10 a=bmc_U4-UbDoA:10 a=m1-CJj7CIYT16TQjaKsA:9 a=jeBq3FmKZ4MA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-Id: <20130626193049.892149772@goodmis.org>
User-Agent: quilt/0.60-1
Date: Wed, 26 Jun 2013 15:28:08 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org,
        linux-rt-users <linux-rt-users@vger.kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, Carsten Emde <C.Emde@osadl.org>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Clark Williams <clark.williams@gmail.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [RFC][PATCH RT 2/6] workqueue: Use rcu_read_lock_sched() to denote RCU synchronize_sched() location
References: <20130626192806.107564905@goodmis.org>
Content-Disposition: inline; filename=workqueue-rcu-sched.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Some functions in the workqueue code uses local_irq_disable() for the
RCU sched critical sections. That is, to make sure updates are done
using synchronize_sched() will synchronize with reader locations.

Unfortunately, local_irq_disable() is not very descriptive of what it
is used to protect, and disables interrupts for locations that do not
require interrupts disabled.

By using rcu_read_lock_sched(), we not only allow interrupts to be disabled
for shorter amounts of time, but also it documents nicely how the critical
section is being protected.

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>

Index: linux-rt.git/kernel/workqueue.c
===================================================================
--- linux-rt.git.orig/kernel/workqueue.c
+++ linux-rt.git/kernel/workqueue.c
@@ -2766,14 +2766,15 @@ static bool start_flush_work(struct work
 
 	might_sleep();
 
-	local_irq_disable();
+	rcu_read_lock_sched();
+
 	pool = get_work_pool(work);
 	if (!pool) {
-		local_irq_enable();
+		rcu_read_unlock_sched();
 		return false;
 	}
 
-	spin_lock(&pool->lock);
+	spin_lock_irq(&pool->lock);
 	/* see the comment in try_to_grab_pending() with the same code */
 	pwq = get_work_pwq(work);
 	if (pwq) {
@@ -2788,6 +2789,7 @@ static bool start_flush_work(struct work
 
 	insert_wq_barrier(pwq, barr, work, worker);
 	spin_unlock_irq(&pool->lock);
+	rcu_read_unlock_sched();
 
 	/*
 	 * If @max_active is 1 or rescuer is in use, flushing another work
@@ -2804,6 +2806,7 @@ static bool start_flush_work(struct work
 	return true;
 already_gone:
 	spin_unlock_irq(&pool->lock);
+	rcu_read_unlock_sched();
 	return false;
 }
 
@@ -4366,7 +4369,7 @@ unsigned int work_busy(struct work_struc
 	if (work_pending(work))
 		ret |= WORK_BUSY_PENDING;
 
-	local_irq_save(flags);
+	rcu_read_lock_sched();
 	pool = get_work_pool(work);
 	if (pool) {
 		spin_lock(&pool->lock);
@@ -4374,7 +4377,7 @@ unsigned int work_busy(struct work_struc
 			ret |= WORK_BUSY_RUNNING;
 		spin_unlock(&pool->lock);
 	}
-	local_irq_restore(flags);
+	rcu_read_unlock_sched();
 
 	return ret;
 }

