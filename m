Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755644Ab3BAI5y (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Feb 2013 03:57:54 -0500
Received: from mga09.intel.com ([134.134.136.24]:30103 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751850Ab3BAI5v (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Feb 2013 03:57:51 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,579,1355126400"; 
   d="scan'208";a="279602759"
Subject: [PATCH V4] suspend: enable freeze timeout configuration through sys
From: fli24 <fei.li@intel.com>
To: rjw@sisk.pl
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
        linux-pm@vger.kernel.org, chuansheng.liu@intel.com, fei.li@intel.com
In-Reply-To: <1359608132.7918.2.camel@fli24-HP-Compaq-8100-Elite-CMT-PC>
References: <1359428300.3211.3.camel@fli24-HP-Compaq-8100-Elite-CMT-PC>
	 <1359527019.26790.3.camel@fli24-HP-Compaq-8100-Elite-CMT-PC>
	 <1359608132.7918.2.camel@fli24-HP-Compaq-8100-Elite-CMT-PC>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 01 Feb 2013 16:56:03 +0800
Message-ID: <1359708963.7240.3.camel@fli24-HP-Compaq-8100-Elite-CMT-PC>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


At present, the value of timeout for freezing is 20s, which is
meaningless in case that one thread is frozen with mutex locked
and another thread is trying to lock the mutex, as this time of
freezing will fail unavoidably.
And if there is no new wakeup event registered, the system will
waste at most 20s for such meaningless trying of freezing.

With this patch, the value of timeout can be configured to smaller
value, so such meaningless trying of freezing will be aborted in
earlier time, and later freezing can be also triggered in earlier
time. And more power will be saved.
In normal case on mobile phone, it costs real little time to freeze
processes. On some platform, it only costs about 20ms to freeze
user space processes and 10ms to freeze kernel freezable threads.

Signed-off-by: Liu Chuansheng <chuansheng.liu@intel.com>
Signed-off-by: Li Fei <fei.li@intel.com>
---
 Documentation/power/freezing-of-tasks.txt |    5 +++++
 include/linux/freezer.h                   |    5 +++++
 kernel/power/main.c                       |   27 +++++++++++++++++++++++++++
 kernel/power/process.c                    |    4 ++--
 4 files changed, 39 insertions(+), 2 deletions(-)

diff --git a/Documentation/power/freezing-of-tasks.txt b/Documentation/power/freezing-of-tasks.txt
index 6ec291e..85894d8 100644
--- a/Documentation/power/freezing-of-tasks.txt
+++ b/Documentation/power/freezing-of-tasks.txt
@@ -223,3 +223,8 @@ since they ask the freezer to skip freezing this task, since it is anyway
 only after the entire suspend/hibernation sequence is complete.
 So, to summarize, use [un]lock_system_sleep() instead of directly using
 mutex_[un]lock(&pm_mutex). That would prevent freezing failures.
+
+V. Miscellaneous
+/sys/power/pm_freeze_timeout controls how long it will cost at most to freeze
+all user space processes or all freezable kernel threads, in unit of millisecond.
+The default value is 20000, with range of unsigned integer.
diff --git a/include/linux/freezer.h b/include/linux/freezer.h
index e4238ce..e70df40 100644
--- a/include/linux/freezer.h
+++ b/include/linux/freezer.h
@@ -13,6 +13,11 @@ extern bool pm_freezing;		/* PM freezing in effect */
 extern bool pm_nosig_freezing;		/* PM nosig freezing in effect */
 
 /*
+ * Timeout for stopping processes
+ */
+extern unsigned int freeze_timeout_msecs;
+
+/*
  * Check if a process has been frozen
  */
 static inline bool frozen(struct task_struct *p)
diff --git a/kernel/power/main.c b/kernel/power/main.c
index 1c16f91..3e1c9da 100644
--- a/kernel/power/main.c
+++ b/kernel/power/main.c
@@ -553,6 +553,30 @@ power_attr(pm_trace_dev_match);
 
 #endif /* CONFIG_PM_TRACE */
 
+#ifdef CONFIG_FREEZER
+static ssize_t pm_freeze_timeout_show(struct kobject *kobj,
+				      struct kobj_attribute *attr, char *buf)
+{
+	return sprintf(buf, "%u\n", freeze_timeout_msecs);
+}
+
+static ssize_t pm_freeze_timeout_store(struct kobject *kobj,
+				       struct kobj_attribute *attr,
+				       const char *buf, size_t n)
+{
+	unsigned long val;
+
+	if (kstrtoul(buf, 10, &val))
+		return -EINVAL;
+
+	freeze_timeout_msecs = val;
+	return n;
+}
+
+power_attr(pm_freeze_timeout);
+
+#endif	/* CONFIG_FREEZER*/
+
 static struct attribute * g[] = {
 	&state_attr.attr,
 #ifdef CONFIG_PM_TRACE
@@ -576,6 +600,9 @@ static struct attribute * g[] = {
 	&pm_print_times_attr.attr,
 #endif
 #endif
+#ifdef CONFIG_FREEZER
+	&pm_freeze_timeout_attr.attr,
+#endif
 	NULL,
 };
 
diff --git a/kernel/power/process.c b/kernel/power/process.c
index d5a258b..98088e0 100644
--- a/kernel/power/process.c
+++ b/kernel/power/process.c
@@ -21,7 +21,7 @@
 /* 
  * Timeout for stopping processes
  */
-#define TIMEOUT	(20 * HZ)
+unsigned int __read_mostly freeze_timeout_msecs = 20 * MSEC_PER_SEC;
 
 static int try_to_freeze_tasks(bool user_only)
 {
@@ -36,7 +36,7 @@ static int try_to_freeze_tasks(bool user_only)
 
 	do_gettimeofday(&start);
 
-	end_time = jiffies + TIMEOUT;
+	end_time = jiffies + msecs_to_jiffies(freeze_timeout_msecs);
 
 	if (!user_only)
 		freeze_workqueues_begin();
-- 
1.7.4.1



