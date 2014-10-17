Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753779AbaJQRBg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Oct 2014 13:01:36 -0400
Received: from mx1.redhat.com ([209.132.183.28]:47606 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752638AbaJQRAG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Oct 2014 13:00:06 -0400
From: Ulrich Obergfell <uobergfe@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: dzickus@redhat.com, uobergfe@redhat.com
Subject: [PATCH v2 5/9] watchdog: introduce separate handlers for parameters in /proc/sys/kernel
Date: Fri, 17 Oct 2014 19:06:24 +0200
Message-Id: <1413565588-4144-6-git-send-email-uobergfe@redhat.com>
In-Reply-To: <1413565588-4144-1-git-send-email-uobergfe@redhat.com>
References: <1413565588-4144-1-git-send-email-uobergfe@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Separate handlers for each watchdog parameter in /proc/sys/kernel
replace the proc_dowatchdog() function. Three of those handlers
merely call proc_watchdog_common() with one different argument.

Signed-off-by: Ulrich Obergfell <uobergfe@redhat.com>
---
 include/linux/nmi.h |  8 ++++++++
 kernel/watchdog.c   | 59 +++++++++++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 67 insertions(+)

diff --git a/include/linux/nmi.h b/include/linux/nmi.h
index 3885a7d..5b54505 100644
--- a/include/linux/nmi.h
+++ b/include/linux/nmi.h
@@ -74,6 +74,14 @@ extern int watchdog_user_enabled;
 extern int watchdog_thresh;
 extern int sysctl_softlockup_all_cpu_backtrace;
 struct ctl_table;
+extern int proc_watchdog(struct ctl_table *, int ,
+			 void __user *, size_t *, loff_t *);
+extern int proc_nmi_watchdog(struct ctl_table *, int ,
+			     void __user *, size_t *, loff_t *);
+extern int proc_soft_watchdog(struct ctl_table *, int ,
+			      void __user *, size_t *, loff_t *);
+extern int proc_watchdog_thresh(struct ctl_table *, int ,
+				void __user *, size_t *, loff_t *);
 extern int proc_dowatchdog(struct ctl_table *, int ,
 			   void __user *, size_t *, loff_t *);
 #endif
diff --git a/kernel/watchdog.c b/kernel/watchdog.c
index ea19971..3de09ca 100644
--- a/kernel/watchdog.c
+++ b/kernel/watchdog.c
@@ -769,6 +769,65 @@ out:
 }
 
 /*
+ * /proc/sys/kernel/watchdog
+ */
+int proc_watchdog(struct ctl_table *table, int write,
+		  void __user *buffer, size_t *lenp, loff_t *ppos)
+{
+	return proc_watchdog_common(NMI_WATCHDOG_ENABLED|SOFT_WATCHDOG_ENABLED,
+				    table, write, buffer, lenp, ppos);
+}
+
+/*
+ * /proc/sys/kernel/nmi_watchdog
+ */
+int proc_nmi_watchdog(struct ctl_table *table, int write,
+		      void __user *buffer, size_t *lenp, loff_t *ppos)
+{
+	return proc_watchdog_common(NMI_WATCHDOG_ENABLED,
+				    table, write, buffer, lenp, ppos);
+}
+
+/*
+ * /proc/sys/kernel/soft_watchdog
+ */
+int proc_soft_watchdog(struct ctl_table *table, int write,
+			void __user *buffer, size_t *lenp, loff_t *ppos)
+{
+	return proc_watchdog_common(SOFT_WATCHDOG_ENABLED,
+				    table, write, buffer, lenp, ppos);
+}
+
+/*
+ * /proc/sys/kernel/watchdog_thresh
+ */
+int proc_watchdog_thresh(struct ctl_table *table, int write,
+			 void __user *buffer, size_t *lenp, loff_t *ppos)
+{
+	int err, old;
+
+	mutex_lock(&watchdog_proc_mutex);
+
+	old = ACCESS_ONCE(watchdog_thresh);
+	err = proc_dointvec_minmax(table, write, buffer, lenp, ppos);
+
+	if (err || !write)
+		goto out;
+
+	/*
+	 * Update the sample period.
+	 * Restore 'watchdog_thresh' on failure.
+	 */
+	set_sample_period();
+	err = proc_watchdog_update();
+	if (err)
+		watchdog_thresh = old;
+out:
+	mutex_unlock(&watchdog_proc_mutex);
+	return err;
+}
+
+/*
  * proc handler for /proc/sys/kernel/nmi_watchdog,watchdog_thresh
  */
 
-- 
1.7.11.7

