Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757952Ab3ENR4t (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 May 2013 13:56:49 -0400
Received: from mail-gg0-f174.google.com ([209.85.161.174]:40791 "EHLO
	mail-gg0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754057Ab3ENR4s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 May 2013 13:56:48 -0400
Date: Tue, 14 May 2013 10:56:40 -0700
From: Tejun Heo <tj@kernel.org>
To: Viresh Kumar <viresh.kumar@linaro.org>
Cc: davem@davemloft.net, airlied@redhat.com, axboe@kernel.dk,
        tglx@linutronix.de, peterz@infradead.org, mingo@redhat.com,
        rostedt@goodmis.org, linux-rt-users@vger.kernel.org,
        linux-kernel@vger.kernel.org, robin.randhawa@arm.com,
        Steve.Bannister@arm.com, Liviu.Dudau@arm.com,
        charles.garcia-tobin@arm.com, arvind.chauhan@arm.com,
        linaro-kernel@lists.linaro.org, patches@linaro.org
Subject: Re: [PATCH V5 2/5] workqueue: Add system wide power_efficient
 workqueues
Message-ID: <20130514175640.GI6795@mtj.dyndns.org>
References: <cover.1366803121.git.viresh.kumar@linaro.org>
 <d0410ec9ec8e37b42769db27a17faa901c7fdd62.1366803121.git.viresh.kumar@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d0410ec9ec8e37b42769db27a17faa901c7fdd62.1366803121.git.viresh.kumar@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This one is slightly updated too.  The rest remain the same.

>From 0668106ca3865ba945e155097fb042bf66d364d3 Mon Sep 17 00:00:00 2001
From: Viresh Kumar <viresh.kumar@linaro.org>
Date: Wed, 24 Apr 2013 17:12:54 +0530
Subject: workqueue: Add system wide power_efficient workqueues

This patch adds system wide workqueues aligned towards power saving. This is
done by allocating them with WQ_UNBOUND flag if 'wq_power_efficient' is set to
'true'.

tj: updated comments a bit.

Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
Signed-off-by: Tejun Heo <tj@kernel.org>
---
 include/linux/workqueue.h |  8 ++++++++
 kernel/workqueue.c        | 13 ++++++++++++-
 2 files changed, 20 insertions(+), 1 deletion(-)

diff --git a/include/linux/workqueue.h b/include/linux/workqueue.h
index fc0136b..a9f4119 100644
--- a/include/linux/workqueue.h
+++ b/include/linux/workqueue.h
@@ -360,11 +360,19 @@ enum {
  *
  * system_freezable_wq is equivalent to system_wq except that it's
  * freezable.
+ *
+ * *_power_efficient_wq are inclined towards saving power and converted
+ * into WQ_UNBOUND variants if 'wq_power_efficient' is enabled; otherwise,
+ * they are same as their non-power-efficient counterparts - e.g.
+ * system_power_efficient_wq is identical to system_wq if
+ * 'wq_power_efficient' is disabled.  See WQ_POWER_EFFICIENT for more info.
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
index 8068d97..16ca2d3 100644
--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@ -314,6 +314,10 @@ struct workqueue_struct *system_unbound_wq __read_mostly;
 EXPORT_SYMBOL_GPL(system_unbound_wq);
 struct workqueue_struct *system_freezable_wq __read_mostly;
 EXPORT_SYMBOL_GPL(system_freezable_wq);
+struct workqueue_struct *system_power_efficient_wq __read_mostly;
+EXPORT_SYMBOL_GPL(system_power_efficient_wq);
+struct workqueue_struct *system_freezable_power_efficient_wq __read_mostly;
+EXPORT_SYMBOL_GPL(system_freezable_power_efficient_wq);
 
 static int worker_thread(void *__worker);
 static void copy_workqueue_attrs(struct workqueue_attrs *to,
@@ -4987,8 +4991,15 @@ static int __init init_workqueues(void)
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
1.8.1.4

