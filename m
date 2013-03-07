Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759889Ab3CGVoT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Mar 2013 16:44:19 -0500
Received: from mail-qa0-f52.google.com ([209.85.216.52]:61976 "EHLO
	mail-qa0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752764Ab3CGVoR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Mar 2013 16:44:17 -0500
From: Tejun Heo <tj@kernel.org>
To: axboe@kernel.dk, laijs@cn.fujitsu.com, fengguang.wu@intel.com
Cc: linux-kernel@vger.kernel.org, jmoyer@redhat.com, Tejun Heo <tj@kernel.org>
Subject: [PATCH 1/4] implement current_is_workqueue_rescuer()
Date: Thu,  7 Mar 2013 13:44:06 -0800
Message-Id: <1362692649-25570-2-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1362692649-25570-1-git-send-email-tj@kernel.org>
References: <1362692649-25570-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Implement a function which queries whether it currently is running off
a workqueue rescuer.  This will be used to convert writeback to
workqueue.

Signed-off-by: Tejun Heo <tj@kernel.org>
---
 include/linux/workqueue.h |  1 +
 kernel/workqueue.c        | 13 +++++++++++++
 2 files changed, 14 insertions(+)

diff --git a/include/linux/workqueue.h b/include/linux/workqueue.h
index 7f6d29a..df30763 100644
--- a/include/linux/workqueue.h
+++ b/include/linux/workqueue.h
@@ -451,6 +451,7 @@ extern bool cancel_delayed_work_sync(struct delayed_work *dwork);
 
 extern void workqueue_set_max_active(struct workqueue_struct *wq,
 				     int max_active);
+extern bool current_is_workqueue_rescuer(void);
 extern bool workqueue_congested(int cpu, struct workqueue_struct *wq);
 extern unsigned int work_busy(struct work_struct *work);
 
diff --git a/kernel/workqueue.c b/kernel/workqueue.c
index 904a901..af79dd8 100644
--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@ -4062,6 +4062,19 @@ void workqueue_set_max_active(struct workqueue_struct *wq, int max_active)
 EXPORT_SYMBOL_GPL(workqueue_set_max_active);
 
 /**
+ * current_is_workqueue_rescuer - is %current workqueue rescuer?
+ *
+ * Determine whether %current is a workqueue rescuer.  Can be used from
+ * work functions to determine whether it's being run off the rescuer task.
+ */
+bool current_is_workqueue_rescuer(void)
+{
+	struct worker *worker = current_wq_worker();
+
+	return worker && worker == worker->current_pwq->wq->rescuer;
+}
+
+/**
  * workqueue_congested - test whether a workqueue is congested
  * @cpu: CPU in question
  * @wq: target workqueue
-- 
1.8.1.4

