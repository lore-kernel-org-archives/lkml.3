Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754865AbaI3AJQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Sep 2014 20:09:16 -0400
Received: from v094114.home.net.pl ([79.96.170.134]:62323 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751028AbaI3AJN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Sep 2014 20:09:13 -0400
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: ACPI Devel Maling List <linux-acpi@vger.kernel.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Zhang Rui <rui.zhang@intel.com>,
        Linux PM list <linux-pm@vger.kernel.org>,
        Robert Moore <robert.moore@intel.com>
Subject: [PATCH 5/5] ACPI / sleep: Rework the handling of ACPI GPE wakeup from suspend-to-idle
Date: Tue, 30 Sep 2014 02:29:01 +0200
Message-ID: <31388978.n2DDPQ82nQ@vostro.rjw.lan>
User-Agent: KMail/4.11.5 (Linux/3.16.0-rc5+; KDE/4.11.5; x86_64; ; )
In-Reply-To: <1622293.rpSt5UtDk3@vostro.rjw.lan>
References: <1622293.rpSt5UtDk3@vostro.rjw.lan>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>

The ACPI GPE wakeup from suspend-to-idle is currently based on using
the IRQF_NO_SUSPEND flag for the ACPI SCI, but that is problematic
for a couple of reasons.  First, in principle the ACPI SCI may be
shared and IRQF_NO_SUSPEND does not really work well with shared
interrupts.  Second, it may require the ACPI subsystem to special-case
the handling of device notifications depending on whether or not
they are received during suspend-to-idle in some places which would
lead to fragile code.  Finally, it's better the handle ACPI wakeup
interrupts consistently with wakeup interrupts from other sources.

For this reason, remove the IRQF_NO_SUSPEND flag from the ACPI SCI
and use enable_irq_wake()/disable_irq_wake() with it instead, which
requires two additional platform hooks to be added to struct
platform_freeze_ops.

Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
---
 drivers/acpi/osl.c      |    2 +-
 drivers/acpi/sleep.c    |   16 ++++++++++++++++
 include/linux/suspend.h |    2 ++
 kernel/power/suspend.c  |   21 ++++++++++++++++++++-
 4 files changed, 39 insertions(+), 2 deletions(-)

Index: linux-pm/include/linux/suspend.h
===================================================================
--- linux-pm.orig/include/linux/suspend.h
+++ linux-pm/include/linux/suspend.h
@@ -189,6 +189,8 @@ struct platform_suspend_ops {
 
 struct platform_freeze_ops {
 	int (*begin)(void);
+	int (*prepare)(void);
+	void (*restore)(void);
 	void (*end)(void);
 };
 
Index: linux-pm/kernel/power/suspend.c
===================================================================
--- linux-pm.orig/kernel/power/suspend.c
+++ linux-pm/kernel/power/suspend.c
@@ -144,6 +144,12 @@ static int platform_suspend_prepare(susp
 		suspend_ops->prepare() : 0;
 }
 
+static int platform_suspend_prepare_late(suspend_state_t state)
+{
+	return state == PM_SUSPEND_FREEZE && freeze_ops->prepare ?
+		freeze_ops->prepare() : 0;
+}
+
 static int platform_suspend_prepare_noirq(suspend_state_t state)
 {
 	return state != PM_SUSPEND_FREEZE && suspend_ops->prepare_late ?
@@ -156,6 +162,12 @@ static void platform_resume_noirq(suspen
 		suspend_ops->wake();
 }
 
+static void platform_resume_early(suspend_state_t state)
+{
+	if (state == PM_SUSPEND_FREEZE && freeze_ops->restore)
+		freeze_ops->restore();
+}
+
 static void platform_resume_finish(suspend_state_t state)
 {
 	if (state != PM_SUSPEND_FREEZE && suspend_ops->finish)
@@ -270,10 +282,14 @@ static int suspend_enter(suspend_state_t
 		printk(KERN_ERR "PM: late suspend of devices failed\n");
 		goto Platform_finish;
 	}
+	error = platform_suspend_prepare_late(state);
+	if (error)
+		goto Devices_early_resume;
+
 	error = dpm_suspend_noirq(PMSG_SUSPEND);
 	if (error) {
 		printk(KERN_ERR "PM: noirq suspend of devices failed\n");
-		goto Devices_early_resume;
+		goto Platform_early_resume;
 	}
 	error = platform_suspend_prepare_noirq(state);
 	if (error)
@@ -326,6 +342,9 @@ static int suspend_enter(suspend_state_t
 	platform_resume_noirq(state);
 	dpm_resume_noirq(PMSG_RESUME);
 
+ Platform_early_resume:
+	platform_resume_early(state);
+
  Devices_early_resume:
 	dpm_resume_early(PMSG_RESUME);
 
Index: linux-pm/drivers/acpi/sleep.c
===================================================================
--- linux-pm.orig/drivers/acpi/sleep.c
+++ linux-pm/drivers/acpi/sleep.c
@@ -14,6 +14,7 @@
 #include <linux/irq.h>
 #include <linux/dmi.h>
 #include <linux/device.h>
+#include <linux/interrupt.h>
 #include <linux/suspend.h>
 #include <linux/reboot.h>
 #include <linux/acpi.h>
@@ -626,6 +627,19 @@ static int acpi_freeze_begin(void)
 	return 0;
 }
 
+static int acpi_freeze_prepare(void)
+{
+	acpi_enable_all_wakeup_gpes();
+	enable_irq_wake(acpi_gbl_FADT.sci_interrupt);
+	return 0;
+}
+
+static void acpi_freeze_restore(void)
+{
+	disable_irq_wake(acpi_gbl_FADT.sci_interrupt);
+	acpi_enable_all_runtime_gpes();
+}
+
 static void acpi_freeze_end(void)
 {
 	acpi_scan_lock_release();
@@ -633,6 +647,8 @@ static void acpi_freeze_end(void)
 
 static const struct platform_freeze_ops acpi_freeze_ops = {
 	.begin = acpi_freeze_begin,
+	.prepare = acpi_freeze_prepare,
+	.restore = acpi_freeze_restore,
 	.end = acpi_freeze_end,
 };
 
Index: linux-pm/drivers/acpi/osl.c
===================================================================
--- linux-pm.orig/drivers/acpi/osl.c
+++ linux-pm/drivers/acpi/osl.c
@@ -835,7 +835,7 @@ acpi_os_install_interrupt_handler(u32 gs
 
 	acpi_irq_handler = handler;
 	acpi_irq_context = context;
-	if (request_irq(irq, acpi_irq, IRQF_SHARED | IRQF_NO_SUSPEND, "acpi", acpi_irq)) {
+	if (request_irq(irq, acpi_irq, IRQF_SHARED, "acpi", acpi_irq)) {
 		printk(KERN_ERR PREFIX "SCI (IRQ%d) allocation failed\n", irq);
 		acpi_irq_handler = NULL;
 		return AE_NOT_ACQUIRED;

