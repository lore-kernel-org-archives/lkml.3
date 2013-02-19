Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932374Ab3BSD44 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Feb 2013 22:56:56 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:29372 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932184Ab3BSD4r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Feb 2013 22:56:47 -0500
X-Authority-Analysis: v=2.0 cv=H5hZMpki c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=Ciwy3NGCPMMA:10 a=3blZSj-AL28A:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=60MjJKQT36wA:10 a=F5gwLfWOzrZmvdusooAA:9 a=Zh68SRI7RUMA:10 a=jeBq3FmKZ4MA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-Id: <20130219035646.405150342@goodmis.org>
User-Agent: quilt/0.60-1
Date: Mon, 18 Feb 2013 22:56:29 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org,
        linux-rt-users <linux-rt-users@vger.kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, Carsten Emde <C.Emde@osadl.org>,
        John Kacur <jkacur@redhat.com>
Subject: [PATCH RT 6/7] rcutiny: Use simple waitqueue
References: <20130219035623.277664914@goodmis.org>
Content-Disposition: inline; filename=0006-rcutiny-Use-simple-waitqueue.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Thomas Gleixner <tglx@linutronix.de>

Simple waitqueues can be handled from interrupt disabled contexts.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/rcutiny_plugin.h |   17 +++++++++--------
 1 file changed, 9 insertions(+), 8 deletions(-)

diff --git a/kernel/rcutiny_plugin.h b/kernel/rcutiny_plugin.h
index 2b0484a..f0a6606 100644
--- a/kernel/rcutiny_plugin.h
+++ b/kernel/rcutiny_plugin.h
@@ -26,6 +26,7 @@
 #include <linux/module.h>
 #include <linux/debugfs.h>
 #include <linux/seq_file.h>
+#include <linux/wait-simple.h>
 
 /* Global control variables for rcupdate callback mechanism. */
 struct rcu_ctrlblk {
@@ -250,7 +251,7 @@ static void show_tiny_preempt_stats(struct seq_file *m)
 
 /* Controls for rcu_kthread() kthread. */
 static struct task_struct *rcu_kthread_task;
-static DECLARE_WAIT_QUEUE_HEAD(rcu_kthread_wq);
+static DEFINE_SWAIT_HEAD(rcu_kthread_wq);
 static unsigned long have_rcu_kthread_work;
 
 /*
@@ -720,7 +721,7 @@ void synchronize_rcu(void)
 }
 EXPORT_SYMBOL_GPL(synchronize_rcu);
 
-static DECLARE_WAIT_QUEUE_HEAD(sync_rcu_preempt_exp_wq);
+static DEFINE_SWAIT_HEAD(sync_rcu_preempt_exp_wq);
 static unsigned long sync_rcu_preempt_exp_count;
 static DEFINE_MUTEX(sync_rcu_preempt_exp_mutex);
 
@@ -742,7 +743,7 @@ static int rcu_preempted_readers_exp(void)
  */
 static void rcu_report_exp_done(void)
 {
-	wake_up(&sync_rcu_preempt_exp_wq);
+	swait_wake(&sync_rcu_preempt_exp_wq);
 }
 
 /*
@@ -794,8 +795,8 @@ void synchronize_rcu_expedited(void)
 	else {
 		rcu_initiate_boost();
 		local_irq_restore(flags);
-		wait_event(sync_rcu_preempt_exp_wq,
-			   !rcu_preempted_readers_exp());
+		swait_event(sync_rcu_preempt_exp_wq,
+			    !rcu_preempted_readers_exp());
 	}
 
 	/* Clean up and exit. */
@@ -882,7 +883,7 @@ static void rcu_preempt_process_callbacks(void)
 static void invoke_rcu_callbacks(void)
 {
 	have_rcu_kthread_work = 1;
-	wake_up(&rcu_kthread_wq);
+	swake_up(&rcu_kthread_wq);
 }
 
 /*
@@ -899,8 +900,8 @@ static int rcu_kthread(void *arg)
 	unsigned long flags;
 
 	for (;;) {
-		wait_event_interruptible(rcu_kthread_wq,
-					 have_rcu_kthread_work != 0);
+		swait_event_interruptible(rcu_kthread_wq,
+					  have_rcu_kthread_work != 0);
 		morework = rcu_boost();
 		local_irq_save(flags);
 		work = have_rcu_kthread_work;
-- 
1.7.10.4


