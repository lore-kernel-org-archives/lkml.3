Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753541AbaI3SB0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Sep 2014 14:01:26 -0400
Received: from mail-pa0-f46.google.com ([209.85.220.46]:43664 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753333AbaI3SBQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Sep 2014 14:01:16 -0400
From: Guenter Roeck <linux@roeck-us.net>
To: linux-kernel@vger.kernel.org
Cc: linux-pm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-c6x-dev@linux-c6x.org, linux-ia64@vger.kernel.org,
        linux-metag@vger.kernel.org, linux-mips@linux-mips.org,
        linux-parisc@vger.kernel.org, linux-sh@vger.kernel.org,
        xen-devel@lists.xenproject.org, Guenter Roeck <linux@roeck-us.net>,
        "James E.J. Bottomley" <jejb@parisc-linux.org>,
        Helge Deller <deller@gmx.de>
Subject: [RFC PATCH 03/16] parisc: support poweroff through poweroff handler call chain
Date: Tue, 30 Sep 2014 11:00:43 -0700
Message-Id: <1412100056-15517-4-git-send-email-linux@roeck-us.net>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1412100056-15517-1-git-send-email-linux@roeck-us.net>
References: <1412100056-15517-1-git-send-email-linux@roeck-us.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The kernel core now supports a poweroff handler call chain
to remove power from the system. Call it from machine_power_off.

Also, do not use pm_power_off as alternate pointer to machine_power_off.
Have the parisc/power driver call kernel_power_off() which in turn will
call machine_power_off().

Cc: James E.J. Bottomley <jejb@parisc-linux.org>
Cc: Helge Deller <deller@gmx.de>
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
---
 arch/parisc/kernel/process.c | 7 +++++--
 drivers/parisc/power.c       | 3 +--
 2 files changed, 6 insertions(+), 4 deletions(-)

diff --git a/arch/parisc/kernel/process.c b/arch/parisc/kernel/process.c
index 0bbbf0d..21d1ab3 100644
--- a/arch/parisc/kernel/process.c
+++ b/arch/parisc/kernel/process.c
@@ -42,6 +42,7 @@
 #include <linux/module.h>
 #include <linux/personality.h>
 #include <linux/ptrace.h>
+#include <linux/reboot.h>
 #include <linux/sched.h>
 #include <linux/slab.h>
 #include <linux/stddef.h>
@@ -133,7 +134,9 @@ void machine_power_off(void)
 	pdc_soft_power_button(0);
 	
 	pdc_chassis_send_status(PDC_CHASSIS_DIRECT_SHUTDOWN);
-		
+
+	do_kernel_poweroff();
+
 	/* It seems we have no way to power the system off via
 	 * software. The user has to press the button himself. */
 
@@ -141,7 +144,7 @@ void machine_power_off(void)
 	       "Please power this system off now.");
 }
 
-void (*pm_power_off)(void) = machine_power_off;
+void (*pm_power_off)(void);
 EXPORT_SYMBOL(pm_power_off);
 
 /*
diff --git a/drivers/parisc/power.c b/drivers/parisc/power.c
index 90cca5e..de5b2ff 100644
--- a/drivers/parisc/power.c
+++ b/drivers/parisc/power.c
@@ -95,8 +95,7 @@ static void process_shutdown(void)
 		/* send kill signal */
 		if (kill_cad_pid(SIGINT, 1)) {
 			/* just in case killing init process failed */
-			if (pm_power_off)
-				pm_power_off();
+			kernel_power_off();
 		}
 	}
 }
-- 
1.9.1

