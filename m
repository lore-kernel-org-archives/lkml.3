Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759564Ab3DYUeM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Apr 2013 16:34:12 -0400
Received: from www.linutronix.de ([62.245.132.108]:45997 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759222Ab3DYUbr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Apr 2013 16:31:47 -0400
Message-Id: <20130425143435.964218245@linutronix.de>
User-Agent: quilt/0.48-1
Date: Thu, 25 Apr 2013 20:31:46 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: John Stultz <john.stultz@linaro.org>, Ingo Molnar <mingo@elte.hu>,
        Magnus Damm <magnus.damm@gmail.com>
Subject: [patch 07/15] clocksource: Provide unbind interface in sysfs
References: <20130425142452.908423538@linutronix.de>
Content-Disposition: inline;
 filename=clocksource-provide-unbind-interface.patch
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

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
---
 kernel/time/clocksource.c |   68 ++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 68 insertions(+)

Index: tip/kernel/time/clocksource.c
===================================================================
--- tip.orig/kernel/time/clocksource.c
+++ tip/kernel/time/clocksource.c
@@ -440,6 +440,11 @@ static int clocksource_watchdog_kthread(
 	return 0;
 }
 
+static bool clocksource_is_watchdog(struct clocksource *cs)
+{
+	return cs == watchdog;
+}
+
 #else /* CONFIG_CLOCKSOURCE_WATCHDOG */
 
 static void clocksource_enqueue_watchdog(struct clocksource *cs)
@@ -451,6 +456,7 @@ static void clocksource_enqueue_watchdog
 static inline void clocksource_dequeue_watchdog(struct clocksource *cs) { }
 static inline void clocksource_resume_watchdog(void) { }
 static inline int clocksource_watchdog_kthread(void *data) { return 0; }
+static bool clocksource_is_watchdog(struct clocksource *cs) { return false; }
 
 #endif /* CONFIG_CLOCKSOURCE_WATCHDOG */
 
@@ -798,6 +804,29 @@ void clocksource_change_rating(struct cl
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
+		clocksource_select(true);
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
@@ -877,6 +906,40 @@ static ssize_t sysfs_override_clocksourc
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
@@ -918,6 +981,8 @@ sysfs_show_available_clocksources(struct
 static DEVICE_ATTR(current_clocksource, 0644, sysfs_show_current_clocksources,
 		   sysfs_override_clocksource);
 
+static DEVICE_ATTR(unbind_clocksource, 0200, NULL, sysfs_unbind_clocksource);
+
 static DEVICE_ATTR(available_clocksource, 0444,
 		   sysfs_show_available_clocksources, NULL);
 
@@ -942,6 +1007,9 @@ static int __init init_clocksource_sysfs
 				&device_clocksource,
 				&dev_attr_current_clocksource);
 	if (!error)
+		error = device_create_file(&device_clocksource,
+					   &dev_attr_unbind_clocksource);
+	if (!error)
 		error = device_create_file(
 				&device_clocksource,
 				&dev_attr_available_clocksource);


