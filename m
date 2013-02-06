Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756487Ab3BFBLo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Feb 2013 20:11:44 -0500
Received: from mga03.intel.com ([143.182.124.21]:21260 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754496Ab3BFBLk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Feb 2013 20:11:40 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,610,1355126400"; 
   d="scan'208";a="253112608"
Message-ID: <1360113095.2982.5.camel@rzhang1-mobl4>
Subject: Re: [PATCH V2 1/3] PM: Introduce suspend state PM_SUSPEND_FREEZE
From: Zhang Rui <rui.zhang@intel.com>
To: linux-kernel@vger.kernel.org
Cc: linux-pm@vger.kernel.org, linux-acpi@vger.kernel.org,
        intel-gfx@lists.freedesktop.org, rjw@sisk.pl, lenb@kernel.org
Date: Wed, 06 Feb 2013 09:11:35 +0800
In-Reply-To: <1359961811-978-1-git-send-email-rui.zhang@intel.com>
References: <1359961811-978-1-git-send-email-rui.zhang@intel.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2013-02-04 at 15:10 +0800, Zhang Rui wrote:
> PM_SUSPEND_FREEZE state is a general state that
> does not need any platform specific support, it equals
> frozen processes + suspended devices + idle processors.
> 
> Compared with PM_SUSPEND_MEMORY,
> PM_SUSPEND_FREEZE saves less power
> because the system is still in a running state.
> PM_SUSPEND_FREEZE has less resume latency because it does not
> touch BIOS, and the processors are in idle state.
> 
> Compared with RTPM/idle,
> PM_SUSPEND_FREEZE saves more power as
> 1. the processor has longer sleep time because processes are frozen.
>    The deeper c-state the processor supports, more power saving we can get.
> 2. PM_SUSPEND_FREEZE uses system suspend code path, thus we can get
>    more power saving from the devices that does not have good RTPM support.
> 
> This state is useful for
> 1) platforms that do not have STR, or have a broken STR.
> 2) platforms that have an extremely low power idle state,
>    which can be used to replace STR.
> 
> The following describes how PM_SUSPEND_FREEZE state works.
> 1. echo freeze > /sys/power/state
> 2. the processes are frozen.
> 3. all the devices are suspended.
> 4. all the processors are blocked by a wait queue
> 5. all the processors idles and enters (Deep) c-state.
> 6. an interrupt fires.
> 7. a processor is woken up and handles the irq.
> 8. if it is a general event,
>    a) the irq handler runs and quites.
>    b) goto step 4.
> 9. if it is a real wake event, say, power button pressing, keyboard touch, mouse moving,
>    a) the irq handler runs and activate the wakeup source
>    b) wakeup_source_activate() notifies the wait queue.
>    c) system starts resuming from PM_SUSPEND_FREEZE
> 10. all the devices are resumed.
> 11. all the processes are unfrozen.
> 12. system is back to working.
> 
> Known Issue:
> The wakeup of this new PM_SUSPEND_FREEZE state may behave differently
> from the previous suspend state.
> Take ACPI platform for example, there are some GPEs that only enabled
> when the system is in sleep state, to wake the system backk from S3/S4.
> But we are not touching these GPEs during transition to PM_SUSPEND_FREEZE.
> This means we may lose some wake event.
> But on the other hand, as we do not disable all the Interrupts during
> PM_SUSPEND_FREEZE, we may get some extra "wakeup" Interrupts, that are
> not available for S3/S4.
> 
> The patches has been tested on an old Sony laptop, and here are the results:
> 
> Average Power:
> 1. RPTM/idle for half an hour:
>    14.8W, 12.6W, 14.1W, 12.5W, 14.4W, 13.2W, 12.9W
> 2. Freeze for half an hour:
>    11W, 10.4W, 9.4W, 11.3W 10.5W
> 3. RTPM/idle for three hours:
>    11.6W
> 4. Freeze for three hours:
>    10W
> 5. Suspend to Memory:
>    0.5~0.9W
> 
> Average Resume Latency:
> 1. RTPM/idle with a black screen: (From pressing keyboard to screen back)
>    Less than 0.2s
> 2. Freeze: (From pressing power button to screen back)
>    2.50s
> 3. Suspend to Memory: (From pressing power button to screen back)
>    4.33s
> 
> From the results, we can see that all the platforms should benefit from
> this patch, even if it does not have Low Power S0.
> 
fixed a build error when CONFIG_SUSPEND not set.
refreshed patch attached.

>From e784933534b8fc00b4e7b52f3c34ea9e614e513e Mon Sep 17 00:00:00 2001
From: Zhang Rui <rui.zhang@intel.com>
Date: Mon, 14 Jan 2013 11:12:53 +0800
Subject: [PATCH 1/3] PM: Introduce suspend state PM_SUSPEND_FREEZE

PM_SUSPEND_FREEZE state is a general state that
does not need any platform specific support, it equals
frozen processes + suspended devices + idle processors.

Compared with PM_SUSPEND_MEMORY,
PM_SUSPEND_FREEZE saves less power
because the system is still in a running state.
PM_SUSPEND_FREEZE has less resume latency because it does not
touch BIOS, and the processors are in idle state.

Compared with RTPM/idle,
PM_SUSPEND_FREEZE saves more power as
1. the processor has longer sleep time because processes are frozen.
   The deeper c-state the processor supports, more power saving we can get.
2. PM_SUSPEND_FREEZE uses system suspend code path, thus we can get
   more power saving from the devices that does not have good RTPM support.

This state is useful for
1) platforms that do not have STR, or have a broken STR.
2) platforms that have an extremely low power idle state,
   which can be used to replace STR.

The following describes how PM_SUSPEND_FREEZE state works.
1. echo freeze > /sys/power/state
2. the processes are frozen.
3. all the devices are suspended.
4. all the processors are blocked by a wait queue
5. all the processors idles and enters (Deep) c-state.
6. an interrupt fires.
7. a processor is woken up and handles the irq.
8. if it is a general event,
   a) the irq handler runs and quites.
   b) goto step 4.
9. if it is a real wake event, say, power button pressing, keyboard touch, mouse moving,
   a) the irq handler runs and activate the wakeup source
   b) wakeup_source_activate() notifies the wait queue.
   c) system starts resuming from PM_SUSPEND_FREEZE
10. all the devices are resumed.
11. all the processes are unfrozen.
12. system is back to working.

Known Issue:
The wakeup of this new PM_SUSPEND_FREEZE state may behave differently
from the previous suspend state.
Take ACPI platform for example, there are some GPEs that only enabled
when the system is in sleep state, to wake the system backk from S3/S4.
But we are not touching these GPEs during transition to PM_SUSPEND_FREEZE.
This means we may lose some wake event.
But on the other hand, as we do not disable all the Interrupts during
PM_SUSPEND_FREEZE, we may get some extra "wakeup" Interrupts, that are
not available for S3/S4.

The patches has been tested on an old Sony laptop, and here are the results:

Average Power:
1. RPTM/idle for half an hour:
   14.8W, 12.6W, 14.1W, 12.5W, 14.4W, 13.2W, 12.9W
2. Freeze for half an hour:
   11W, 10.4W, 9.4W, 11.3W 10.5W
3. RTPM/idle for three hours:
   11.6W
4. Freeze for three hours:
   10W
5. Suspend to Memory:
   0.5~0.9W

Average Resume Latency:
1. RTPM/idle with a black screen: (From pressing keyboard to screen back)
   Less than 0.2s
2. Freeze: (From pressing power button to screen back)
   2.50s
3. Suspend to Memory: (From pressing power button to screen back)
   4.33s

>From the results, we can see that all the platforms should benefit from
this patch, even if it does not have Low Power S0.

Signed-off-by: Zhang Rui <rui.zhang@intel.com>
---
 drivers/base/power/wakeup.c |    6 ++++
 include/linux/suspend.h     |    6 +++-
 kernel/power/main.c         |    2 +-
 kernel/power/suspend.c      |   69 +++++++++++++++++++++++++++++++++++--------
 4 files changed, 68 insertions(+), 15 deletions(-)

diff --git a/drivers/base/power/wakeup.c b/drivers/base/power/wakeup.c
index e6ee5e8..79715e7 100644
--- a/drivers/base/power/wakeup.c
+++ b/drivers/base/power/wakeup.c
@@ -382,6 +382,12 @@ static void wakeup_source_activate(struct wakeup_source *ws)
 {
 	unsigned int cec;
 
+	/*
+	 * active wakeup source should bring the system
+	 * out of PM_SUSPEND_FREEZE state
+	 */
+	freeze_wake();
+
 	ws->active = true;
 	ws->active_count++;
 	ws->last_time = ktime_get();
diff --git a/include/linux/suspend.h b/include/linux/suspend.h
index 0c808d7..d4e3f16 100644
--- a/include/linux/suspend.h
+++ b/include/linux/suspend.h
@@ -34,8 +34,10 @@ static inline void pm_restore_console(void)
 typedef int __bitwise suspend_state_t;
 
 #define PM_SUSPEND_ON		((__force suspend_state_t) 0)
-#define PM_SUSPEND_STANDBY	((__force suspend_state_t) 1)
+#define PM_SUSPEND_FREEZE	((__force suspend_state_t) 1)
+#define PM_SUSPEND_STANDBY	((__force suspend_state_t) 2)
 #define PM_SUSPEND_MEM		((__force suspend_state_t) 3)
+#define PM_SUSPEND_MIN		PM_SUSPEND_FREEZE
 #define PM_SUSPEND_MAX		((__force suspend_state_t) 4)
 
 enum suspend_stat_step {
@@ -192,6 +194,7 @@ struct platform_suspend_ops {
  */
 extern void suspend_set_ops(const struct platform_suspend_ops *ops);
 extern int suspend_valid_only_mem(suspend_state_t state);
+extern void freeze_wake(void);
 
 /**
  * arch_suspend_disable_irqs - disable IRQs for suspend
@@ -217,6 +220,7 @@ extern int pm_suspend(suspend_state_t state);
 
 static inline void suspend_set_ops(const struct platform_suspend_ops *ops) {}
 static inline int pm_suspend(suspend_state_t state) { return -ENOSYS; }
+static inline void freeze_wake(void) {}
 #endif /* !CONFIG_SUSPEND */
 
 /* struct pbe is used for creating lists of pages that should be restored
diff --git a/kernel/power/main.c b/kernel/power/main.c
index 1c16f91..b1c26a9 100644
--- a/kernel/power/main.c
+++ b/kernel/power/main.c
@@ -313,7 +313,7 @@ static ssize_t state_show(struct kobject *kobj, struct kobj_attribute *attr,
 static suspend_state_t decode_state(const char *buf, size_t n)
 {
 #ifdef CONFIG_SUSPEND
-	suspend_state_t state = PM_SUSPEND_STANDBY;
+	suspend_state_t state = PM_SUSPEND_MIN;
 	const char * const *s;
 #endif
 	char *p;
diff --git a/kernel/power/suspend.c b/kernel/power/suspend.c
index c8b7446..d4feda0 100644
--- a/kernel/power/suspend.c
+++ b/kernel/power/suspend.c
@@ -30,12 +30,38 @@
 #include "power.h"
 
 const char *const pm_states[PM_SUSPEND_MAX] = {
+	[PM_SUSPEND_FREEZE]	= "freeze",
 	[PM_SUSPEND_STANDBY]	= "standby",
 	[PM_SUSPEND_MEM]	= "mem",
 };
 
 static const struct platform_suspend_ops *suspend_ops;
 
+static bool need_suspend_ops(suspend_state_t state)
+{
+	return !!(state > PM_SUSPEND_FREEZE);
+}
+
+static DECLARE_WAIT_QUEUE_HEAD(suspend_freeze_wait_head);
+static bool suspend_freeze_wake;
+
+static void freeze_begin(void)
+{
+	suspend_freeze_wake = false;
+}
+
+static void freeze_enter(void)
+{
+	wait_event(suspend_freeze_wait_head, suspend_freeze_wake);
+}
+
+void freeze_wake(void)
+{
+	suspend_freeze_wake = true;
+	wake_up(&suspend_freeze_wait_head);
+}
+EXPORT_SYMBOL_GPL(freeze_wake);
+
 /**
  * suspend_set_ops - Set the global suspend method table.
  * @ops: Suspend operations to use.
@@ -50,8 +76,11 @@ EXPORT_SYMBOL_GPL(suspend_set_ops);
 
 bool valid_state(suspend_state_t state)
 {
+	if (state == PM_SUSPEND_FREEZE)
+		return true;
 	/*
-	 * All states need lowlevel support and need to be valid to the lowlevel
+	 * PM_SUSPEND_STANDBY and PM_SUSPEND_MEMORY states need lowlevel
+	 * support and need to be valid to the lowlevel
 	 * implementation, no valid callback implies that none are valid.
 	 */
 	return suspend_ops && suspend_ops->valid && suspend_ops->valid(state);
@@ -89,11 +118,11 @@ static int suspend_test(int level)
  * hibernation).  Run suspend notifiers, allocate the "suspend" console and
  * freeze processes.
  */
-static int suspend_prepare(void)
+static int suspend_prepare(suspend_state_t state)
 {
 	int error;
 
-	if (!suspend_ops || !suspend_ops->enter)
+	if (need_suspend_ops(state) && (!suspend_ops || !suspend_ops->enter))
 		return -EPERM;
 
 	pm_prepare_console();
@@ -137,7 +166,7 @@ static int suspend_enter(suspend_state_t state, bool *wakeup)
 {
 	int error;
 
-	if (suspend_ops->prepare) {
+	if (need_suspend_ops(state) && suspend_ops->prepare) {
 		error = suspend_ops->prepare();
 		if (error)
 			goto Platform_finish;
@@ -149,12 +178,23 @@ static int suspend_enter(suspend_state_t state, bool *wakeup)
 		goto Platform_finish;
 	}
 
-	if (suspend_ops->prepare_late) {
+	if (need_suspend_ops(state) && suspend_ops->prepare_late) {
 		error = suspend_ops->prepare_late();
 		if (error)
 			goto Platform_wake;
 	}
 
+	/*
+	 * PM_SUSPEND_FREEZE equals
+	 * frozen processes + suspended devices + idle processors.
+	 * Thus we should invoke freeze_enter() soon after
+	 * all the devices are suspended.
+	 */
+	if (state == PM_SUSPEND_FREEZE) {
+		freeze_enter();
+		goto Platform_wake;
+	}
+
 	if (suspend_test(TEST_PLATFORM))
 		goto Platform_wake;
 
@@ -182,13 +222,13 @@ static int suspend_enter(suspend_state_t state, bool *wakeup)
 	enable_nonboot_cpus();
 
  Platform_wake:
-	if (suspend_ops->wake)
+	if (need_suspend_ops(state) && suspend_ops->wake)
 		suspend_ops->wake();
 
 	dpm_resume_start(PMSG_RESUME);
 
  Platform_finish:
-	if (suspend_ops->finish)
+	if (need_suspend_ops(state) && suspend_ops->finish)
 		suspend_ops->finish();
 
 	return error;
@@ -203,11 +243,11 @@ int suspend_devices_and_enter(suspend_state_t state)
 	int error;
 	bool wakeup = false;
 
-	if (!suspend_ops)
+	if (need_suspend_ops(state) && !suspend_ops)
 		return -ENOSYS;
 
 	trace_machine_suspend(state);
-	if (suspend_ops->begin) {
+	if (need_suspend_ops(state) && suspend_ops->begin) {
 		error = suspend_ops->begin(state);
 		if (error)
 			goto Close;
@@ -226,7 +266,7 @@ int suspend_devices_and_enter(suspend_state_t state)
 
 	do {
 		error = suspend_enter(state, &wakeup);
-	} while (!error && !wakeup
+	} while (!error && !wakeup && need_suspend_ops(state)
 		&& suspend_ops->suspend_again && suspend_ops->suspend_again());
 
  Resume_devices:
@@ -236,13 +276,13 @@ int suspend_devices_and_enter(suspend_state_t state)
 	ftrace_start();
 	resume_console();
  Close:
-	if (suspend_ops->end)
+	if (need_suspend_ops(state) && suspend_ops->end)
 		suspend_ops->end();
 	trace_machine_suspend(PWR_EVENT_EXIT);
 	return error;
 
  Recover_platform:
-	if (suspend_ops->recover)
+	if (need_suspend_ops(state) && suspend_ops->recover)
 		suspend_ops->recover();
 	goto Resume_devices;
 }
@@ -278,12 +318,15 @@ static int enter_state(suspend_state_t state)
 	if (!mutex_trylock(&pm_mutex))
 		return -EBUSY;
 
+	if (state == PM_SUSPEND_FREEZE)
+		freeze_begin();
+
 	printk(KERN_INFO "PM: Syncing filesystems ... ");
 	sys_sync();
 	printk("done.\n");
 
 	pr_debug("PM: Preparing system for %s sleep\n", pm_states[state]);
-	error = suspend_prepare();
+	error = suspend_prepare(state);
 	if (error)
 		goto Unlock;
 
-- 
1.7.9.5





