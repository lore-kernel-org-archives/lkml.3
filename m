Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758366Ab3DXLqp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Apr 2013 07:46:45 -0400
Received: from mail-pd0-f172.google.com ([209.85.192.172]:48019 "EHLO
	mail-pd0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758345Ab3DXLqm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Apr 2013 07:46:42 -0400
From: Viresh Kumar <viresh.kumar@linaro.org>
To: tj@kernel.org
Cc: davem@davemloft.net, airlied@redhat.com, axboe@kernel.dk,
        tglx@linutronix.de, peterz@infradead.org, mingo@redhat.com,
        rostedt@goodmis.org, linux-rt-users@vger.kernel.org,
        linux-kernel@vger.kernel.org, robin.randhawa@arm.com,
        Steve.Bannister@arm.com, Liviu.Dudau@arm.com,
        charles.garcia-tobin@arm.com, arvind.chauhan@arm.com,
        linaro-kernel@lists.linaro.org, patches@linaro.org,
        Viresh Kumar <viresh.kumar@linaro.org>
Subject: [PATCH V5 2/5] workqueue: Add system wide power_efficient workqueues
Date: Wed, 24 Apr 2013 17:12:54 +0530
Message-Id: <d0410ec9ec8e37b42769db27a17faa901c7fdd62.1366803121.git.viresh.kumar@linaro.org>
X-Mailer: git-send-email 1.7.12.rc2.18.g61b472e
In-Reply-To: <cover.1366803121.git.viresh.kumar@linaro.org>
References: <cover.1366803121.git.viresh.kumar@linaro.org>
In-Reply-To: <cover.1366803121.git.viresh.kumar@linaro.org>
References: <cover.1366803121.git.viresh.kumar@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds system wide workqueues aligned towards power saving. This is
done by allocating them with WQ_UNBOUND flag if 'wq_power_efficient' is set to
'true'.

Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
---
 include/linux/workqueue.h |  7 +++++++
 kernel/workqueue.c        | 13 ++++++++++++-
 2 files changed, 19 insertions(+), 1 deletion(-)

diff --git a/include/linux/workqueue.h b/include/linux/workqueue.h
index 83fa570..ac3e0e29 100644
--- a/include/linux/workqueue.h
+++ b/include/linux/workqueue.h
@@ -336,11 +336,18 @@ enum {
  *
  * system_freezable_wq is equivalent to system_wq except that it's
  * freezable.
+ *
+ * *_power_efficient_wq are inclined towards saving power. They are converted
+ * into WQ_UNBOUND variants, if 'wq_power_efficient' is set to 'true'. Otherwise
+ * they are same as their sibling types. Like: system_power_efficient_wq will
+ * behave like system_wq if 'wq_power_efficient' is not set to 'true'.
  */
 extern struct workqueue_struct *system_wq;
 extern struct workqueue_struct *system_long_wq;
 extern struct workqueue_struct *system_unbound_wq;
 extern struct workqueue_struct *system_freezable_wq;
+extern struct workqueue_struct *system_power_efficient_wq;
+extern struct workqueue_struct *system_freezable_power_efficient_wq;
 
 static inline struct workqueue_struct * __deprecated __system_nrt_wq(void)
 {
diff --git a/kernel/workqueue.c b/kernel/workqueue.c
index a327027..cb1c2cc 100644
--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@ -313,6 +313,10 @@ struct workqueue_struct *system_unbound_wq __read_mostly;
 EXPORT_SYMBOL_GPL(system_unbound_wq);
 struct workqueue_struct *system_freezable_wq __read_mostly;
 EXPORT_SYMBOL_GPL(system_freezable_wq);
+struct workqueue_struct *system_power_efficient_wq __read_mostly;
+EXPORT_SYMBOL_GPL(system_power_efficient_wq);
+struct workqueue_struct *system_freezable_power_efficient_wq __read_mostly;
+EXPORT_SYMBOL_GPL(system_freezable_power_efficient_wq);
 
 static int worker_thread(void *__worker);
 static void copy_workqueue_attrs(struct workqueue_attrs *to,
@@ -4985,8 +4989,15 @@ static int __init init_workqueues(void)
 					    WQ_UNBOUND_MAX_ACTIVE);
 	system_freezable_wq = alloc_workqueue("events_freezable",
 					      WQ_FREEZABLE, 0);
+	system_power_efficient_wq = alloc_workqueue("events_power_efficient",
+					      WQ_POWER_EFFICIENT, 0);
+	system_freezable_power_efficient_wq = alloc_workqueue("events_freezable_power_efficient",
+					      WQ_FREEZABLE | WQ_POWER_EFFICIENT,
+					      0);
 	BUG_ON(!system_wq || !system_highpri_wq || !system_long_wq ||
-	       !system_unbound_wq || !system_freezable_wq);
+	       !system_unbound_wq || !system_freezable_wq ||
+	       !system_power_efficient_wq ||
+	       !system_freezable_power_efficient_wq);
 	return 0;
 }
 early_initcall(init_workqueues);
-- 
1.7.12.rc2.18.g61b472e

