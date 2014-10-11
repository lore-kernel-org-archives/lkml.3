Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752134AbaJKVOb (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Oct 2014 17:14:31 -0400
Received: from mail-pa0-f44.google.com ([209.85.220.44]:45418 "EHLO
	mail-pa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751147AbaJKVO3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Oct 2014 17:14:29 -0400
From: Guenter Roeck <linux@roeck-us.net>
To: linux-kernel@vger.kernel.org
Cc: linux-pm@vger.kernel.org, "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Len Brown <len.brown@intel.com>, Pavel Machek <pavel@ucw.cz>,
        Andrew Morton <akpm@linux-foundation.org>,
        Guenter Roeck <linux@roeck-us.net>
Subject: [RFC PATCH 1/2] acpi: Use syscore instead of pm_power_off_prepare to prepare for poweroff
Date: Sat, 11 Oct 2014 14:14:16 -0700
Message-Id: <1413062057-11657-2-git-send-email-linux@roeck-us.net>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1413062057-11657-1-git-send-email-linux@roeck-us.net>
References: <1413062057-11657-1-git-send-email-linux@roeck-us.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The syscore shutdown callback seems to be perfectly suited to prepare for system
poweroff. Use it instead of pm_power_off_prepare.

Cc: Rafael J. Wysocki <rjw@rjwysocki.net>
Cc: Len Brown <len.brown@intel.com>
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
---
 drivers/acpi/sleep.c | 21 ++++++++++++++++-----
 1 file changed, 16 insertions(+), 5 deletions(-)

diff --git a/drivers/acpi/sleep.c b/drivers/acpi/sleep.c
index 05a31b5..e03c74d 100644
--- a/drivers/acpi/sleep.c
+++ b/drivers/acpi/sleep.c
@@ -17,6 +17,7 @@
 #include <linux/interrupt.h>
 #include <linux/suspend.h>
 #include <linux/reboot.h>
+#include <linux/syscore_ops.h>
 #include <linux/acpi.h>
 #include <linux/module.h>
 #include <asm/io.h>
@@ -820,13 +821,23 @@ int acpi_suspend(u32 acpi_state)
 	return -EINVAL;
 }
 
-static void acpi_power_off_prepare(void)
+static void acpi_shutdown(void)
 {
-	/* Prepare to power off the system */
-	acpi_sleep_prepare(ACPI_STATE_S5);
-	acpi_disable_all_gpes();
+	switch (system_state) {
+	case SYSTEM_POWER_OFF:
+		/* Prepare to power off the system */
+		acpi_sleep_prepare(ACPI_STATE_S5);
+		acpi_disable_all_gpes();
+		break;
+	default:
+		break;
+	}
 }
 
+static struct syscore_ops acpi_syscore_ops = {
+	.shutdown = acpi_shutdown,
+};
+
 static void acpi_power_off(void)
 {
 	/* acpi_sleep_prepare(ACPI_STATE_S5) should have already been called */
@@ -850,7 +861,7 @@ int __init acpi_sleep_init(void)
 
 	if (acpi_sleep_state_supported(ACPI_STATE_S5)) {
 		sleep_states[ACPI_STATE_S5] = 1;
-		pm_power_off_prepare = acpi_power_off_prepare;
+		register_syscore_ops(&acpi_syscore_ops);
 		pm_power_off = acpi_power_off;
 	}
 
-- 
1.9.1

