Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756275Ab3A2C75 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jan 2013 21:59:57 -0500
Received: from mga03.intel.com ([143.182.124.21]:15654 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750874Ab3A2C74 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jan 2013 21:59:56 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,555,1355126400"; 
   d="scan'208";a="196091360"
Subject: [PATCH] suspend: enable freeze timeout configuration through sysctl
From: fli24 <fei.li@intel.com>
To: rjw@sisk.pl, akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org,
        chuansheng.liu@intel.com, fei.li@intel.com
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 29 Jan 2013 10:58:20 +0800
Message-ID: <1359428300.3211.3.camel@fli24-HP-Compaq-8100-Elite-CMT-PC>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


At present, the timeout value for freezing tasks is fixed as 20s,
which is too long for handheld device usage, especially for mobile
phone.

In order to improve user experience, we enable freeze timeout
configuration through sysctl, so that we can tune the value easily
for concrete usage, such as smaller value for handheld device such
as mobile phone.

Signed-off-by: Liu Chuansheng <chuansheng.liu@intel.com>
Signed-off-by: Li Fei <fei.li@intel.com>
---
 include/linux/freezer.h |    5 +++++
 kernel/power/process.c  |    4 ++--
 kernel/sysctl.c         |   12 ++++++++++++
 3 files changed, 19 insertions(+), 2 deletions(-)

diff --git a/include/linux/freezer.h b/include/linux/freezer.h
index e4238ce..f37b3be 100644
--- a/include/linux/freezer.h
+++ b/include/linux/freezer.h
@@ -13,6 +13,11 @@ extern bool pm_freezing;		/* PM freezing in effect */
 extern bool pm_nosig_freezing;		/* PM nosig freezing in effect */
 
 /*
+ * Timeout for stopping processes
+ */
+extern unsigned int sysctl_freeze_process_timeout_secs;
+
+/*
  * Check if a process has been frozen
  */
 static inline bool frozen(struct task_struct *p)
diff --git a/kernel/power/process.c b/kernel/power/process.c
index d5a258b..f7eb7c9 100644
--- a/kernel/power/process.c
+++ b/kernel/power/process.c
@@ -21,7 +21,7 @@
 /* 
  * Timeout for stopping processes
  */
-#define TIMEOUT	(20 * HZ)
+unsigned int __read_mostly sysctl_freeze_process_timeout_secs = 20;
 
 static int try_to_freeze_tasks(bool user_only)
 {
@@ -36,7 +36,7 @@ static int try_to_freeze_tasks(bool user_only)
 
 	do_gettimeofday(&start);
 
-	end_time = jiffies + TIMEOUT;
+	end_time = jiffies + sysctl_freeze_process_timeout_secs * HZ;
 
 	if (!user_only)
 		freeze_workqueues_begin();
diff --git a/kernel/sysctl.c b/kernel/sysctl.c
index c88878d..f88bcb9 100644
--- a/kernel/sysctl.c
+++ b/kernel/sysctl.c
@@ -90,6 +90,9 @@
 #include <linux/nmi.h>
 #endif
 
+#ifdef CONFIG_FREEZER
+#include <linux/freezer.h>
+#endif
 
 #if defined(CONFIG_SYSCTL)
 
@@ -1047,6 +1050,15 @@ static struct ctl_table kern_table[] = {
 		.proc_handler	= proc_dointvec,
 	},
 #endif
+#ifdef CONFIG_FREEZER
+	{
+		.procname	= "freeze_process_timeout_secs",
+		.data		= &sysctl_freeze_process_timeout_secs,
+		.maxlen		= sizeof(unsigned int),
+		.mode		= 0644,
+		.proc_handler	= proc_dointvec,
+	},
+#endif
 	{ }
 };
 
-- 
1.7.4.1



