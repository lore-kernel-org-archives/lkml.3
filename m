Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753006AbaBXRLJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Feb 2014 12:11:09 -0500
Received: from smtp.codeaurora.org ([198.145.11.231]:45076 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752464AbaBXRLE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Feb 2014 12:11:04 -0500
From: Josh Cartwright <joshc@codeaurora.org>
To: Pavel Machek <pavel@ucw.cz>, "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Len Brown <len.brown@intel.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 2/3] PM: define new ASSIGN_*_PM_OPS macros based on assign_if
Date: Mon, 24 Feb 2014 11:08:26 -0600
Message-Id: <1393261707-30565-3-git-send-email-joshc@codeaurora.org>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <1393261707-30565-1-git-send-email-joshc@codeaurora.org>
References: <1393261707-30565-1-git-send-email-joshc@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Similar to the SET_*_PM_OPS(), these functions are to be used in
initializers of struct dev_pm_ops, for example:

	static const struct dev_pm_ops foo_pm_ops = {
		ASSIGN_RUNTIME_PM_OPS(foo_rpm_suspend, foo_rpm_resume, NULL)
		ASSIGN_SYSTEM_SLEEP_PM_OPS(foo_suspend, foo_resume)
	};

Unlike their SET_*_PM_OPS() counter parts, it is unnecessary to wrap the
function callbacks in #ifdeffery in order to prevent 'defined but not
used' warnings when the corresponding CONFIG_PM* options are unset.

Signed-off-by: Josh Cartwright <joshc@codeaurora.org>
---
 include/linux/pm.h | 39 +++++++++++++++++++++++++++++++++++++++
 1 file changed, 39 insertions(+)

diff --git a/include/linux/pm.h b/include/linux/pm.h
index db2be5f..3810d56 100644
--- a/include/linux/pm.h
+++ b/include/linux/pm.h
@@ -299,6 +299,15 @@ struct dev_pm_ops {
 	int (*runtime_idle)(struct device *dev);
 };
 
+#define assign_if_pm_sleep(fn) \
+	assign_if_enabled(CONFIG_PM_SLEEP, fn)
+
+#define assign_if_pm_runtime(fn) \
+	assign_if_enabled(CONFIG_PM_RUNTIME, fn)
+
+#define assign_if_pm(fn) \
+	assign_if_enabled(CONFIG_PM, fn)
+
 #ifdef CONFIG_PM_SLEEP
 #define SET_SYSTEM_SLEEP_PM_OPS(suspend_fn, resume_fn) \
 	.suspend = suspend_fn, \
@@ -342,6 +351,36 @@ struct dev_pm_ops {
 #endif
 
 /*
+ * The ASSIGN_* variations of the above make wrapping the associated callback
+ * functions in preprocessor defines unnecessary.
+ */
+#define ASSIGN_SYSTEM_SLEEP_PM_OPS(suspend_fn, resume_fn) \
+	.suspend = assign_if_pm_sleep(suspend_fn), \
+	.resume = assign_if_pm_sleep(resume_fn), \
+	.freeze = assign_if_pm_sleep(suspend_fn), \
+	.thaw = assign_if_pm_sleep(resume_fn), \
+	.poweroff = assign_if_pm_sleep(suspend_fn), \
+	.restore = assign_if_pm_sleep(resume_fn),
+
+#define ASSIGN_LATE_SYSTEM_SLEEP_PM_OPS(suspend_fn, resume_fn) \
+	.suspend_late = assign_if_pm_sleep(suspend_fn), \
+	.resume_early = assign_if_pm_sleep(resume_fn), \
+	.freeze_late = assign_if_pm_sleep(suspend_fn), \
+	.thaw_early = assign_if_pm_sleep(resume_fn), \
+	.poweroff_late = assign_if_pm_sleep(suspend_fn), \
+	.restore_early = assign_if_pm_sleep(resume_fn),
+
+#define ASSIGN_RUNTIME_PM_OPS(suspend_fn, resume_fn, idle_fn) \
+	.runtime_suspend = assign_if_pm_runtime(suspend_fn), \
+	.runtime_resume = assign_if_pm_runtime(resume_fn), \
+	.runtime_idle = assign_if_pm_runtime(idle_fn),
+
+#define ASSIGN_PM_RUNTIME_PM_OPS(suspend_fn, resume_fn, idle_fn) \
+	.runtime_suspend = assign_if_pm(suspend_fn), \
+	.runtime_resume = assign_if_pm(resume_fn), \
+	.runtime_idle = assign_if_pm(idle_fn),
+
+/*
  * Use this if you want to use the same suspend and resume callbacks for suspend
  * to RAM and hibernation.
  */
-- 
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
hosted by The Linux Foundation

