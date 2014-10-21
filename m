Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754738AbaJUETO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Oct 2014 00:19:14 -0400
Received: from bh-25.webhostbox.net ([208.91.199.152]:33887 "EHLO
	bh-25.webhostbox.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754563AbaJUEOb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Oct 2014 00:14:31 -0400
From: Guenter Roeck <linux@roeck-us.net>
To: linux-kernel@vger.kernel.org
Cc: linux-pm@vger.kernel.org, Guenter Roeck <linux@roeck-us.net>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>, Len Brown <lenb@kernel.org>,
        linux-acpi@vger.kernel.org
Subject: [PATCH v2 34/47] acpi: Register poweroff handler with kernel poweroff handler
Date: Mon, 20 Oct 2014 21:12:50 -0700
Message-Id: <1413864783-3271-35-git-send-email-linux@roeck-us.net>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1413864783-3271-1-git-send-email-linux@roeck-us.net>
References: <1413864783-3271-1-git-send-email-linux@roeck-us.net>
X-Authenticated_sender: guenter@roeck-us.net
X-OutGoing-Spam-Status: No, score=-1.0
X-CTCH-PVer: 0000001
X-CTCH-Spam: Unknown
X-CTCH-VOD: Unknown
X-CTCH-Flags: 0
X-CTCH-RefID: str=0001.0A020209.5445DDA6.016B,ss=1,re=0.000,recu=0.000,reip=0.000,cl=1,cld=1,fgs=0
X-CTCH-Score: 0.000
X-CTCH-ScoreCust: 0.000
X-CTCH-Rules: C_4847,
X-CTCH-SenderID: linux@roeck-us.net
X-CTCH-SenderID-Flags: 0
X-CTCH-SenderID-TotalMessages: 178
X-CTCH-SenderID-TotalSpam: 0
X-CTCH-SenderID-TotalSuspected: 0
X-CTCH-SenderID-TotalConfirmed: 0
X-CTCH-SenderID-TotalBulk: 0
X-CTCH-SenderID-TotalVirus: 0
X-CTCH-SenderID-TotalRecipients: 0
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - bh-25.webhostbox.net
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - roeck-us.net
X-Get-Message-Sender-Via: bh-25.webhostbox.net: mailgid no entry from get_relayhosts_entry
X-Source: 
X-Source-Args: 
X-Source-Dir: 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Register with kernel poweroff handler instead of setting pm_power_off
directly. Register with high priority to reflect that the driver explicitly
overrides existing poweroff handlers.

Cc: Rafael J. Wysocki <rjw@rjwysocki.net>
Cc: Len Brown <lenb@kernel.org>
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
---
v2:
- Use define to specify poweroff handler priority
- Use pr_warn instead of pr_err

 drivers/acpi/sleep.c | 15 +++++++++++++--
 1 file changed, 13 insertions(+), 2 deletions(-)

diff --git a/drivers/acpi/sleep.c b/drivers/acpi/sleep.c
index 05a31b5..1eba563 100644
--- a/drivers/acpi/sleep.c
+++ b/drivers/acpi/sleep.c
@@ -16,6 +16,8 @@
 #include <linux/device.h>
 #include <linux/interrupt.h>
 #include <linux/suspend.h>
+#include <linux/notifier.h>
+#include <linux/pm.h>
 #include <linux/reboot.h>
 #include <linux/acpi.h>
 #include <linux/module.h>
@@ -827,14 +829,22 @@ static void acpi_power_off_prepare(void)
 	acpi_disable_all_gpes();
 }
 
-static void acpi_power_off(void)
+static int acpi_power_off(struct notifier_block *this,
+			  unsigned long unused1, void *unused2)
 {
 	/* acpi_sleep_prepare(ACPI_STATE_S5) should have already been called */
 	printk(KERN_DEBUG "%s called\n", __func__);
 	local_irq_disable();
 	acpi_enter_sleep_state(ACPI_STATE_S5);
+
+	return NOTIFY_DONE;
 }
 
+static struct notifier_block acpi_poweroff_nb = {
+	.notifier_call = acpi_power_off,
+	.priority = POWEROFF_PRIORITY_HIGH,
+};
+
 int __init acpi_sleep_init(void)
 {
 	char supported[ACPI_S_STATE_COUNT * 3 + 1];
@@ -851,7 +861,8 @@ int __init acpi_sleep_init(void)
 	if (acpi_sleep_state_supported(ACPI_STATE_S5)) {
 		sleep_states[ACPI_STATE_S5] = 1;
 		pm_power_off_prepare = acpi_power_off_prepare;
-		pm_power_off = acpi_power_off;
+		if (register_power_off_handler(&acpi_poweroff_nb))
+			pr_warn("acpi: Failed to register poweroff handler\n");
 	}
 
 	supported[0] = 0;
-- 
1.9.1

