Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756613Ab3BSFcG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Feb 2013 00:32:06 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:5958 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755190Ab3BSFcB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Feb 2013 00:32:01 -0500
X-Authority-Analysis: v=2.0 cv=H5hZMpki c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=Ciwy3NGCPMMA:10 a=AmHzjIGhJLkA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=60MjJKQT36wA:10 a=aAvN45RuVp0Gwv8mYTIA:9 a=Zh68SRI7RUMA:10 a=jeBq3FmKZ4MA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-Id: <20130219053200.112311156@goodmis.org>
User-Agent: quilt/0.60-1
Date: Tue, 19 Feb 2013 00:31:19 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org,
        linux-rt-users <linux-rt-users@vger.kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, Carsten Emde <C.Emde@osadl.org>,
        John Kacur <jkacur@redhat.com>
Subject: [PATCH RT 3/4] rcutiny: Use simple waitqueue
References: <20130219053116.706325380@goodmis.org>
Content-Disposition: inline; filename=0003-rcutiny-Use-simple-waitqueue.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Thomas Gleixner <tglx@linutronix.de>

Simple waitqueues can be handled from interrupt disabled contexts.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/rcutiny_plugin.h |    9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/kernel/rcutiny_plugin.h b/kernel/rcutiny_plugin.h
index f259c67..1cd0c6e 100644
--- a/kernel/rcutiny_plugin.h
+++ b/kernel/rcutiny_plugin.h
@@ -25,6 +25,7 @@
 #include <linux/kthread.h>
 #include <linux/debugfs.h>
 #include <linux/seq_file.h>
+#include <linux/wait-simple.h>
 
 #ifdef CONFIG_RCU_TRACE
 #define RCU_TRACE(stmt)	stmt
@@ -736,7 +737,7 @@ void synchronize_rcu(void)
 }
 EXPORT_SYMBOL_GPL(synchronize_rcu);
 
-static DECLARE_WAIT_QUEUE_HEAD(sync_rcu_preempt_exp_wq);
+static DEFINE_SWAIT_HEAD(sync_rcu_preempt_exp_wq);
 static unsigned long sync_rcu_preempt_exp_count;
 static DEFINE_MUTEX(sync_rcu_preempt_exp_mutex);
 
@@ -758,7 +759,7 @@ static int rcu_preempted_readers_exp(void)
  */
 static void rcu_report_exp_done(void)
 {
-	wake_up(&sync_rcu_preempt_exp_wq);
+	swait_wake(&sync_rcu_preempt_exp_wq);
 }
 
 /*
@@ -810,8 +811,8 @@ void synchronize_rcu_expedited(void)
 	else {
 		rcu_initiate_boost();
 		local_irq_restore(flags);
-		wait_event(sync_rcu_preempt_exp_wq,
-			   !rcu_preempted_readers_exp());
+		swait_event(sync_rcu_preempt_exp_wq,
+			    !rcu_preempted_readers_exp());
 	}
 
 	/* Clean up and exit. */
-- 
1.7.10.4


