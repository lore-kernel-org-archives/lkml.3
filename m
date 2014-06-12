Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752225AbaFLTsC (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jun 2014 15:48:02 -0400
Received: from smtp.outflux.net ([198.145.64.163]:59019 "EHLO smtp.outflux.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751345AbaFLTr7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jun 2014 15:47:59 -0400
From: Kees Cook <keescook@chromium.org>
To: linux-kernel@vger.kernel.org
Cc: Kees Cook <keescook@chromium.org>, Randy Dunlap <rdunlap@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Len Brown <len.brown@intel.com>, Pavel Machek <pavel@ucw.cz>,
        Wei Yongjun <yongjun_wei@trendmicro.com.cn>, linux-doc@vger.kernel.org,
        linux-pm@vger.kernel.org
Subject: [PATCH 1/2] hibernate: create one-way disable mode
Date: Thu, 12 Jun 2014 12:46:58 -0700
Message-Id: <1402602419-27934-2-git-send-email-keescook@chromium.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1402602419-27934-1-git-send-email-keescook@chromium.org>
References: <1402602419-27934-1-git-send-email-keescook@chromium.org>
X-HELO: www.outflux.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

To support using kernel features that are not compatible with hibernation,
this creates a "disabled" hibernation state so that hibernation selection
can be a boot-time choice instead of only a compile-time choice.

Signed-off-by: Kees Cook <keescook@chromium.org>
---
 include/linux/suspend.h  |    2 ++
 kernel/power/hibernate.c |   55 +++++++++++++++++++++++++++++++---------------
 kernel/power/main.c      |    6 ++---
 kernel/power/user.c      |    3 +++
 4 files changed, 44 insertions(+), 22 deletions(-)

diff --git a/include/linux/suspend.h b/include/linux/suspend.h
index f76994b9396c..519064e0c943 100644
--- a/include/linux/suspend.h
+++ b/include/linux/suspend.h
@@ -327,6 +327,7 @@ extern unsigned long get_safe_page(gfp_t gfp_mask);
 extern void hibernation_set_ops(const struct platform_hibernation_ops *ops);
 extern int hibernate(void);
 extern bool system_entering_hibernation(void);
+extern bool hibernation_available(void);
 asmlinkage int swsusp_save(void);
 extern struct pbe *restore_pblist;
 #else /* CONFIG_HIBERNATION */
@@ -339,6 +340,7 @@ static inline void swsusp_unset_page_free(struct page *p) {}
 static inline void hibernation_set_ops(const struct platform_hibernation_ops *ops) {}
 static inline int hibernate(void) { return -ENOSYS; }
 static inline bool system_entering_hibernation(void) { return false; }
+static inline bool hibernation_available(void) { return false; }
 #endif /* CONFIG_HIBERNATION */
 
 /* Hibernation and suspend events */
diff --git a/kernel/power/hibernate.c b/kernel/power/hibernate.c
index df88d55dc436..32672da81114 100644
--- a/kernel/power/hibernate.c
+++ b/kernel/power/hibernate.c
@@ -43,6 +43,7 @@ __visible int in_suspend __nosavedata;
 
 enum {
 	HIBERNATION_INVALID,
+	HIBERNATION_DISABLED,
 	HIBERNATION_PLATFORM,
 	HIBERNATION_SHUTDOWN,
 	HIBERNATION_REBOOT,
@@ -61,6 +62,11 @@ bool freezer_test_done;
 
 static const struct platform_hibernation_ops *hibernation_ops;
 
+bool hibernation_available(void)
+{
+	return (hibernation_mode > HIBERNATION_DISABLED);
+}
+
 /**
  * hibernation_set_ops - Set the global hibernate operations.
  * @ops: Hibernation operations to use in subsequent hibernation transitions.
@@ -75,10 +81,12 @@ void hibernation_set_ops(const struct platform_hibernation_ops *ops)
 	}
 	lock_system_sleep();
 	hibernation_ops = ops;
-	if (ops)
-		hibernation_mode = HIBERNATION_PLATFORM;
-	else if (hibernation_mode == HIBERNATION_PLATFORM)
-		hibernation_mode = HIBERNATION_SHUTDOWN;
+	if (hibernation_available()) {
+		if (ops)
+			hibernation_mode = HIBERNATION_PLATFORM;
+		else if (hibernation_mode == HIBERNATION_PLATFORM)
+			hibernation_mode = HIBERNATION_SHUTDOWN;
+	}
 
 	unlock_system_sleep();
 }
@@ -639,6 +647,11 @@ int hibernate(void)
 {
 	int error;
 
+	if (!hibernation_available()) {
+		pr_debug("PM: Hibernation not available.\n");
+		return -EINVAL;
+	}
+
 	lock_system_sleep();
 	/* The snapshot device should not be opened while we're running */
 	if (!atomic_add_unless(&snapshot_device_available, -1, 0)) {
@@ -731,7 +744,7 @@ static int software_resume(void)
 	/*
 	 * If the user said "noresume".. bail out early.
 	 */
-	if (noresume)
+	if (noresume || !hibernation_available())
 		return 0;
 
 	/*
@@ -857,6 +870,7 @@ late_initcall_sync(software_resume);
 
 
 static const char * const hibernation_modes[] = {
+	[HIBERNATION_DISABLED]	= "disabled",
 	[HIBERNATION_PLATFORM]	= "platform",
 	[HIBERNATION_SHUTDOWN]	= "shutdown",
 	[HIBERNATION_REBOOT]	= "reboot",
@@ -931,6 +945,9 @@ static ssize_t disk_store(struct kobject *kobj, struct kobj_attribute *attr,
 	char *p;
 	int mode = HIBERNATION_INVALID;
 
+	if (!hibernation_available())
+		return -EINVAL;
+
 	p = memchr(buf, '\n', n);
 	len = p ? p - buf : n;
 
@@ -942,23 +959,25 @@ static ssize_t disk_store(struct kobject *kobj, struct kobj_attribute *attr,
 			break;
 		}
 	}
-	if (mode != HIBERNATION_INVALID) {
-		switch (mode) {
-		case HIBERNATION_SHUTDOWN:
-		case HIBERNATION_REBOOT:
+	switch (mode) {
+	case HIBERNATION_DISABLED:
+	case HIBERNATION_SHUTDOWN:
+	case HIBERNATION_REBOOT:
 #ifdef CONFIG_SUSPEND
-		case HIBERNATION_SUSPEND:
+	case HIBERNATION_SUSPEND:
 #endif
+		hibernation_mode = mode;
+		break;
+	case HIBERNATION_PLATFORM:
+		if (hibernation_ops)
 			hibernation_mode = mode;
-			break;
-		case HIBERNATION_PLATFORM:
-			if (hibernation_ops)
-				hibernation_mode = mode;
-			else
-				error = -EINVAL;
-		}
-	} else
+		else
+			error = -EINVAL;
+		break;
+	default:
 		error = -EINVAL;
+		break;
+	}
 
 	if (!error)
 		pr_debug("PM: Hibernation mode set to '%s'\n",
diff --git a/kernel/power/main.c b/kernel/power/main.c
index 573410d6647e..8e90f330f139 100644
--- a/kernel/power/main.c
+++ b/kernel/power/main.c
@@ -300,13 +300,11 @@ static ssize_t state_show(struct kobject *kobj, struct kobj_attribute *attr,
 			s += sprintf(s,"%s ", pm_states[i].label);
 
 #endif
-#ifdef CONFIG_HIBERNATION
-	s += sprintf(s, "%s\n", "disk");
-#else
+	if (hibernation_available())
+		s += sprintf(s, "disk ");
 	if (s != buf)
 		/* convert the last space to a newline */
 		*(s-1) = '\n';
-#endif
 	return (s - buf);
 }
 
diff --git a/kernel/power/user.c b/kernel/power/user.c
index 98d357584cd6..000b94419182 100644
--- a/kernel/power/user.c
+++ b/kernel/power/user.c
@@ -49,6 +49,9 @@ static int snapshot_open(struct inode *inode, struct file *filp)
 	struct snapshot_data *data;
 	int error;
 
+	if (!hibernation_available())
+		return -EINVAL;
+
 	lock_system_sleep();
 
 	if (!atomic_add_unless(&snapshot_device_available, -1, 0)) {
-- 
1.7.9.5

