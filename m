Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757317Ab3E0J7X (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 May 2013 05:59:23 -0400
Received: from terminus.zytor.com ([198.137.202.10]:35756 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756904Ab3E0J7V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 May 2013 05:59:21 -0400
Date: Mon, 27 May 2013 02:59:05 -0700
From: tip-bot for Thomas Gleixner <tipbot@zytor.com>
Message-ID: <tip-03e13cf5ee60584fe0c831682c67212effb7fca4@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, john.stultz@linaro.org, hpa@zytor.com,
        mingo@kernel.org, tglx@linutronix.de, magnus.damm@gmail.com
Reply-To: mingo@kernel.org, hpa@zytor.com, john.stultz@linaro.org,
        linux-kernel@vger.kernel.org, tglx@linutronix.de,
        magnus.damm@gmail.com
In-Reply-To: <20130425143436.499216659@linutronix.de>
References: <20130425143436.499216659@linutronix.de>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:timers/core] clockevents: Implement unbind functionality
Git-Commit-ID: 03e13cf5ee60584fe0c831682c67212effb7fca4
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

Commit-ID:  03e13cf5ee60584fe0c831682c67212effb7fca4
Gitweb:     http://git.kernel.org/tip/03e13cf5ee60584fe0c831682c67212effb7fca4
Author:     Thomas Gleixner <tglx@linutronix.de>
AuthorDate: Thu, 25 Apr 2013 20:31:50 +0000
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Thu, 16 May 2013 11:09:18 +0200

clockevents: Implement unbind functionality

Provide a sysfs interface to allow unbinding of clockevent
devices. The device is unbound if it is unused or if there is a
replacement device available. Unbinding of broadcast devices is not
supported as we don't want to foster that nonsense. If no replacement
device is available the unbind returns -EBUSY. Unbind is available
from the kernel and through sysfs, which is necessary to drop the
module refcount.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: John Stultz <john.stultz@linaro.org>
Cc: Magnus Damm <magnus.damm@gmail.com>
Link: http://lkml.kernel.org/r/20130425143436.499216659@linutronix.de
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 include/linux/clockchips.h  |   1 +
 kernel/time/clockevents.c   | 125 ++++++++++++++++++++++++++++++++++++++++++++
 kernel/time/clocksource.c   |   9 ++--
 kernel/time/tick-common.c   |  24 +++++++++
 kernel/time/tick-internal.h |   7 +++
 5 files changed, 162 insertions(+), 4 deletions(-)

diff --git a/include/linux/clockchips.h b/include/linux/clockchips.h
index ae1193b..0857922 100644
--- a/include/linux/clockchips.h
+++ b/include/linux/clockchips.h
@@ -141,6 +141,7 @@ static inline unsigned long div_sc(unsigned long ticks, unsigned long nsec,
 extern u64 clockevent_delta2ns(unsigned long latch,
 			       struct clock_event_device *evt);
 extern void clockevents_register_device(struct clock_event_device *dev);
+extern int clockevents_unbind_device(struct clock_event_device *ced, int cpu);
 
 extern void clockevents_config(struct clock_event_device *dev, u32 freq);
 extern void clockevents_config_and_register(struct clock_event_device *dev,
diff --git a/kernel/time/clockevents.c b/kernel/time/clockevents.c
index 0a23f4f..38959c8 100644
--- a/kernel/time/clockevents.c
+++ b/kernel/time/clockevents.c
@@ -25,6 +25,13 @@ static LIST_HEAD(clockevent_devices);
 static LIST_HEAD(clockevents_released);
 /* Protection for the above */
 static DEFINE_RAW_SPINLOCK(clockevents_lock);
+/* Protection for unbind operations */
+static DEFINE_MUTEX(clockevents_mutex);
+
+struct ce_unbind {
+	struct clock_event_device *ce;
+	int res;
+};
 
 /**
  * clockevents_delta2ns - Convert a latch value (device ticks) to nanoseconds
@@ -245,6 +252,90 @@ static void clockevents_notify_released(void)
 	}
 }
 
+/*
+ * Try to install a replacement clock event device
+ */
+static int clockevents_replace(struct clock_event_device *ced)
+{
+	struct clock_event_device *dev, *newdev = NULL;
+
+	list_for_each_entry(dev, &clockevent_devices, list) {
+		if (dev == ced || dev->mode != CLOCK_EVT_MODE_UNUSED)
+			continue;
+
+		if (!tick_check_replacement(newdev, dev))
+			continue;
+
+		if (!try_module_get(dev->owner))
+			continue;
+
+		if (newdev)
+			module_put(newdev->owner);
+		newdev = dev;
+	}
+	if (newdev) {
+		tick_install_replacement(newdev);
+		list_del_init(&ced->list);
+	}
+	return newdev ? 0 : -EBUSY;
+}
+
+/*
+ * Called with clockevents_mutex and clockevents_lock held
+ */
+static int __clockevents_try_unbind(struct clock_event_device *ced, int cpu)
+{
+	/* Fast track. Device is unused */
+	if (ced->mode == CLOCK_EVT_MODE_UNUSED) {
+		list_del_init(&ced->list);
+		return 0;
+	}
+
+	return ced == per_cpu(tick_cpu_device, cpu).evtdev ? -EAGAIN : -EBUSY;
+}
+
+/*
+ * SMP function call to unbind a device
+ */
+static void __clockevents_unbind(void *arg)
+{
+	struct ce_unbind *cu = arg;
+	int res;
+
+	raw_spin_lock(&clockevents_lock);
+	res = __clockevents_try_unbind(cu->ce, smp_processor_id());
+	if (res == -EAGAIN)
+		res = clockevents_replace(cu->ce);
+	cu->res = res;
+	raw_spin_unlock(&clockevents_lock);
+}
+
+/*
+ * Issues smp function call to unbind a per cpu device. Called with
+ * clockevents_mutex held.
+ */
+static int clockevents_unbind(struct clock_event_device *ced, int cpu)
+{
+	struct ce_unbind cu = { .ce = ced, .res = -ENODEV };
+
+	smp_call_function_single(cpu, __clockevents_unbind, &cu, 1);
+	return cu.res;
+}
+
+/*
+ * Unbind a clockevents device.
+ */
+int clockevents_unbind_device(struct clock_event_device *ced, int cpu)
+{
+	int ret;
+
+	mutex_lock(&clockevents_mutex);
+	ret = clockevents_unbind(ced, cpu);
+	mutex_unlock(&clockevents_mutex);
+	return ret;
+}
+EXPORT_SYMBOL_GPL(clockevents_unbind);
+
 /**
  * clockevents_register_device - register a clock event device
  * @dev:	device to register
@@ -487,6 +578,38 @@ static ssize_t sysfs_show_current_tick_dev(struct device *dev,
 }
 static DEVICE_ATTR(current_device, 0444, sysfs_show_current_tick_dev, NULL);
 
+/* We don't support the abomination of removable broadcast devices */
+static ssize_t sysfs_unbind_tick_dev(struct device *dev,
+				     struct device_attribute *attr,
+				     const char *buf, size_t count)
+{
+	char name[CS_NAME_LEN];
+	size_t ret = sysfs_get_uname(buf, name, count);
+	struct clock_event_device *ce;
+
+	if (ret < 0)
+		return ret;
+
+	ret = -ENODEV;
+	mutex_lock(&clockevents_mutex);
+	raw_spin_lock_irq(&clockevents_lock);
+	list_for_each_entry(ce, &clockevent_devices, list) {
+		if (!strcmp(ce->name, name)) {
+			ret = __clockevents_try_unbind(ce, dev->id);
+			break;
+		}
+	}
+	raw_spin_unlock_irq(&clockevents_lock);
+	/*
+	 * We hold clockevents_mutex, so ce can't go away
+	 */
+	if (ret == -EAGAIN)
+		ret = clockevents_unbind(ce, dev->id);
+	mutex_unlock(&clockevents_mutex);
+	return ret ? ret : count;
+}
+static DEVICE_ATTR(unbind_device, 0200, NULL, sysfs_unbind_tick_dev);
+
 #ifdef CONFIG_GENERIC_CLOCKEVENTS_BROADCAST
 static struct device tick_bc_dev = {
 	.init_name	= "broadcast",
@@ -529,6 +652,8 @@ static int __init tick_init_sysfs(void)
 		err = device_register(dev);
 		if (!err)
 			err = device_create_file(dev, &dev_attr_current_device);
+		if (!err)
+			err = device_create_file(dev, &dev_attr_unbind_device);
 		if (err)
 			return err;
 	}
diff --git a/kernel/time/clocksource.c b/kernel/time/clocksource.c
index 31b9033..6d05b00 100644
--- a/kernel/time/clocksource.c
+++ b/kernel/time/clocksource.c
@@ -31,6 +31,8 @@
 #include <linux/tick.h>
 #include <linux/kthread.h>
 
+#include "tick-internal.h"
+
 void timecounter_init(struct timecounter *tc,
 		      const struct cyclecounter *cc,
 		      u64 start_tstamp)
@@ -174,7 +176,6 @@ clocks_calc_mult_shift(u32 *mult, u32 *shift, u32 from, u32 to, u32 maxsec)
 static struct clocksource *curr_clocksource;
 static LIST_HEAD(clocksource_list);
 static DEFINE_MUTEX(clocksource_mutex);
-#define CS_NAME_LEN		32
 static char override_name[CS_NAME_LEN];
 static int finished_booting;
 
@@ -864,7 +865,7 @@ sysfs_show_current_clocksources(struct device *dev,
 	return count;
 }
 
-static size_t clocksource_get_uname(const char *buf, char *dst, size_t cnt)
+size_t sysfs_get_uname(const char *buf, char *dst, size_t cnt)
 {
 	size_t ret = cnt;
 
@@ -899,7 +900,7 @@ static ssize_t sysfs_override_clocksource(struct device *dev,
 
 	mutex_lock(&clocksource_mutex);
 
-	ret = clocksource_get_uname(buf, override_name, count);
+	ret = sysfs_get_uname(buf, override_name, count);
 	if (ret >= 0)
 		clocksource_select();
 
@@ -925,7 +926,7 @@ static ssize_t sysfs_unbind_clocksource(struct device *dev,
 	char name[CS_NAME_LEN];
 	size_t ret;
 
-	ret = clocksource_get_uname(buf, name, count);
+	ret = sysfs_get_uname(buf, name, count);
 	if (ret < 0)
 		return ret;
 
diff --git a/kernel/time/tick-common.c b/kernel/time/tick-common.c
index c34021650..5edfb48 100644
--- a/kernel/time/tick-common.c
+++ b/kernel/time/tick-common.c
@@ -205,6 +205,17 @@ static void tick_setup_device(struct tick_device *td,
 		tick_setup_oneshot(newdev, handler, next_event);
 }
 
+void tick_install_replacement(struct clock_event_device *newdev)
+{
+	struct tick_device *td = &__get_cpu_var(tick_cpu_device);
+	int cpu = smp_processor_id();
+
+	clockevents_exchange_device(td->evtdev, newdev);
+	tick_setup_device(td, newdev, cpu, cpumask_of(cpu));
+	if (newdev->features & CLOCK_EVT_FEAT_ONESHOT)
+		tick_oneshot_notify();
+}
+
 static bool tick_check_percpu(struct clock_event_device *curdev,
 			      struct clock_event_device *newdev, int cpu)
 {
@@ -237,6 +248,19 @@ static bool tick_check_preferred(struct clock_event_device *curdev,
 }
 
 /*
+ * Check whether the new device is a better fit than curdev. curdev
+ * can be NULL !
+ */
+bool tick_check_replacement(struct clock_event_device *curdev,
+			    struct clock_event_device *newdev)
+{
+	if (tick_check_percpu(curdev, newdev, smp_processor_id()))
+		return false;
+
+	return tick_check_preferred(curdev, newdev);
+}
+
+/*
  * Check, if the new registered device should be used. Called with
  * clockevents_lock held and interrupts disabled.
  */
diff --git a/kernel/time/tick-internal.h b/kernel/time/tick-internal.h
index 06bfc88..be1690e 100644
--- a/kernel/time/tick-internal.h
+++ b/kernel/time/tick-internal.h
@@ -11,6 +11,8 @@ extern seqlock_t jiffies_lock;
 #define TICK_DO_TIMER_NONE	-1
 #define TICK_DO_TIMER_BOOT	-2
 
+#define CS_NAME_LEN	32
+
 DECLARE_PER_CPU(struct tick_device, tick_cpu_device);
 extern ktime_t tick_next_period;
 extern ktime_t tick_period;
@@ -23,9 +25,14 @@ extern void tick_handover_do_timer(int *cpup);
 extern void tick_shutdown(unsigned int *cpup);
 extern void tick_suspend(void);
 extern void tick_resume(void);
+extern bool tick_check_replacement(struct clock_event_device *curdev,
+				   struct clock_event_device *newdev);
+extern void tick_install_replacement(struct clock_event_device *dev);
 
 extern void clockevents_shutdown(struct clock_event_device *dev);
 
+extern size_t sysfs_get_uname(const char *buf, char *dst, size_t cnt);
+
 /*
  * NO_HZ / high resolution timer shared code
  */
