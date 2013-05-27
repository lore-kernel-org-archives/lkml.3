Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755939Ab3E0JtM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 May 2013 05:49:12 -0400
Received: from terminus.zytor.com ([198.137.202.10]:35360 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755812Ab3E0JtK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 May 2013 05:49:10 -0400
Date: Mon, 27 May 2013 02:48:54 -0700
From: tip-bot for Thomas Gleixner <tipbot@zytor.com>
Message-ID: <tip-7eaeb34305dee26634f7c98ae62646da5cebe91d@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, john.stultz@linaro.org, hpa@zytor.com,
        mingo@kernel.org, tglx@linutronix.de, magnus.damm@gmail.com
Reply-To: mingo@kernel.org, hpa@zytor.com, john.stultz@linaro.org,
        linux-kernel@vger.kernel.org, tglx@linutronix.de,
        magnus.damm@gmail.com
In-Reply-To: <20130425143435.964218245@linutronix.de>
References: <20130425143435.964218245@linutronix.de>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:timers/core] clocksource: Provide unbind interface in sysfs
Git-Commit-ID: 7eaeb34305dee26634f7c98ae62646da5cebe91d
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  7eaeb34305dee26634f7c98ae62646da5cebe91d
Gitweb:     http://git.kernel.org/tip/7eaeb34305dee26634f7c98ae62646da5cebe91d
Author:     Thomas Gleixner <tglx@linutronix.de>
AuthorDate: Thu, 25 Apr 2013 20:31:46 +0000
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Thu, 16 May 2013 11:09:15 +0200

clocksource: Provide unbind interface in sysfs

With the module refcount held for the current clocksource there is no
way to unload the module. 

Provide a sysfs interface which allows to unbind the clocksource. One
could argue that the clocksource override could be (ab)used to do so,
but the clocksource override cannot be used from the kernel itself,
while an unbind function can be used to programmatically check whether
a clocksource can be shutdown or not.

The unbind functionality uses the new skip current feature of
clocksource_select and verifies that a fallback clocksource has been
installed. If the clocksource which should be unbound is the current
clocksource and no fallback can be found, unbind returns -EBUSY.

This does not support the unbinding of a clocksource which is used as
the watchdog clocksource. No point in fostering crappy hardware.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: John Stultz <john.stultz@linaro.org>
Cc: Magnus Damm <magnus.damm@gmail.com>
Link: http://lkml.kernel.org/r/20130425143435.964218245@linutronix.de
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 kernel/time/clocksource.c | 73 +++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 73 insertions(+)

diff --git a/kernel/time/clocksource.c b/kernel/time/clocksource.c
index d7f1a45..791d1ae 100644
--- a/kernel/time/clocksource.c
+++ b/kernel/time/clocksource.c
@@ -440,6 +440,11 @@ static int clocksource_watchdog_kthread(void *data)
 	return 0;
 }
 
+static bool clocksource_is_watchdog(struct clocksource *cs)
+{
+	return cs == watchdog;
+}
+
 #else /* CONFIG_CLOCKSOURCE_WATCHDOG */
 
 static void clocksource_enqueue_watchdog(struct clocksource *cs)
@@ -451,6 +456,7 @@ static void clocksource_enqueue_watchdog(struct clocksource *cs)
 static inline void clocksource_dequeue_watchdog(struct clocksource *cs) { }
 static inline void clocksource_resume_watchdog(void) { }
 static inline int clocksource_watchdog_kthread(void *data) { return 0; }
+static bool clocksource_is_watchdog(struct clocksource *cs) { return false; }
 
 #endif /* CONFIG_CLOCKSOURCE_WATCHDOG */
 
@@ -628,6 +634,11 @@ static void clocksource_select(void)
 	return __clocksource_select(false);
 }
 
+static void clocksource_select_fallback(void)
+{
+	return __clocksource_select(true);
+}
+
 #else /* !CONFIG_ARCH_USES_GETTIMEOFFSET */
 
 static inline void clocksource_select(void) { }
@@ -803,6 +814,29 @@ void clocksource_change_rating(struct clocksource *cs, int rating)
 }
 EXPORT_SYMBOL(clocksource_change_rating);
 
+/*
+ * Unbind clocksource @cs. Called with clocksource_mutex held
+ */
+static int clocksource_unbind(struct clocksource *cs)
+{
+	/*
+	 * I really can't convince myself to support this on hardware
+	 * designed by lobotomized monkeys.
+	 */
+	if (clocksource_is_watchdog(cs))
+		return -EBUSY;
+
+	if (cs == curr_clocksource) {
+		/* Select and try to install a replacement clock source */
+		clocksource_select_fallback();
+		if (curr_clocksource == cs)
+			return -EBUSY;
+	}
+	clocksource_dequeue_watchdog(cs);
+	list_del_init(&cs->list);
+	return 0;
+}
+
 /**
  * clocksource_unregister - remove a registered clocksource
  * @cs:	clocksource to be unregistered
@@ -884,6 +918,40 @@ static ssize_t sysfs_override_clocksource(struct device *dev,
 }
 
 /**
+ * sysfs_unbind_current_clocksource - interface for manually unbinding clocksource
+ * @dev:	unused
+ * @attr:	unused
+ * @buf:	unused
+ * @count:	length of buffer
+ *
+ * Takes input from sysfs interface for manually unbinding a clocksource.
+ */
+static ssize_t sysfs_unbind_clocksource(struct device *dev,
+					struct device_attribute *attr,
+					const char *buf, size_t count)
+{
+	struct clocksource *cs;
+	char name[CS_NAME_LEN];
+	size_t ret;
+
+	ret = clocksource_get_uname(buf, name, count);
+	if (ret < 0)
+		return ret;
+
+	ret = -ENODEV;
+	mutex_lock(&clocksource_mutex);
+	list_for_each_entry(cs, &clocksource_list, list) {
+		if (strcmp(cs->name, name))
+			continue;
+		ret = clocksource_unbind(cs);
+		break;
+	}
+	mutex_unlock(&clocksource_mutex);
+
+	return ret ? ret : count;
+}
+
+/**
  * sysfs_show_available_clocksources - sysfs interface for listing clocksource
  * @dev:	unused
  * @attr:	unused
@@ -925,6 +993,8 @@ sysfs_show_available_clocksources(struct device *dev,
 static DEVICE_ATTR(current_clocksource, 0644, sysfs_show_current_clocksources,
 		   sysfs_override_clocksource);
 
+static DEVICE_ATTR(unbind_clocksource, 0200, NULL, sysfs_unbind_clocksource);
+
 static DEVICE_ATTR(available_clocksource, 0444,
 		   sysfs_show_available_clocksources, NULL);
 
@@ -949,6 +1019,9 @@ static int __init init_clocksource_sysfs(void)
 				&device_clocksource,
 				&dev_attr_current_clocksource);
 	if (!error)
+		error = device_create_file(&device_clocksource,
+					   &dev_attr_unbind_clocksource);
+	if (!error)
 		error = device_create_file(
 				&device_clocksource,
 				&dev_attr_available_clocksource);
