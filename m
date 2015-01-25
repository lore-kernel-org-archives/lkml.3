Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756919AbbAYSO0 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Jan 2015 13:14:26 -0500
Received: from bh-25.webhostbox.net ([208.91.199.152]:52324 "EHLO
	bh-25.webhostbox.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754052AbbAYSOS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Jan 2015 13:14:18 -0500
From: Guenter Roeck <linux@roeck-us.net>
To: Sebastian Reichel <sre@kernel.org>
Cc: linux-pm@vger.kernel.org, Guenter Roeck <linux@roeck-us.net>,
        David Woodhouse <dwmw2@infradead.org>,
        Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH 2/6] power/reset: at91: Register with kernel restart handler
Date: Sun, 25 Jan 2015 10:13:38 -0800
Message-Id: <1422209622-31994-2-git-send-email-linux@roeck-us.net>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1422209622-31994-1-git-send-email-linux@roeck-us.net>
References: <1422209622-31994-1-git-send-email-linux@roeck-us.net>
X-Authenticated_sender: guenter@roeck-us.net
X-OutGoing-Spam-Status: No, score=-1.0
X-CTCH-PVer: 0000001
X-CTCH-Spam: Unknown
X-CTCH-VOD: Unknown
X-CTCH-Flags: 0
X-CTCH-RefID: str=0001.0A020201.54C5327A.00BA,ss=1,re=0.001,recu=0.000,reip=0.000,cl=1,cld=1,fgs=0
X-CTCH-Score: 0.001
X-CTCH-ScoreCust: 0.000
X-CTCH-Rules: C_4847,
X-CTCH-SenderID: linux@roeck-us.net
X-CTCH-SenderID-Flags: 0
X-CTCH-SenderID-TotalMessages: 24
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

Register with kernel restart handler instead of setting arm_pm_restart
directly. Register with high priority since the driver unconditionally
overwrites other restart handlers if instantiated.

Signed-off-by: Guenter Roeck <linux@roeck-us.net>
---
 drivers/power/reset/at91-reset.c | 28 ++++++++++++++++++----------
 1 file changed, 18 insertions(+), 10 deletions(-)

diff --git a/drivers/power/reset/at91-reset.c b/drivers/power/reset/at91-reset.c
index 69a75d99..13584e2 100644
--- a/drivers/power/reset/at91-reset.c
+++ b/drivers/power/reset/at91-reset.c
@@ -17,8 +17,6 @@
 #include <linux/platform_device.h>
 #include <linux/reboot.h>
 
-#include <asm/system_misc.h>
-
 #include <soc/at91/at91sam9_ddrsdr.h>
 #include <soc/at91/at91sam9_sdramc.h>
 
@@ -54,7 +52,8 @@ static void __iomem *at91_ramc_base[2], *at91_rstc_base;
 * reset register it can be left driving the data bus and
 * killing the chance of a subsequent boot from NAND
 */
-static void at91sam9260_restart(enum reboot_mode mode, const char *cmd)
+static int at91sam9260_restart(struct notifier_block *this, unsigned long mode,
+			       void *cmd)
 {
 	asm volatile(
 		/* Align to cache lines */
@@ -76,9 +75,12 @@ static void at91sam9260_restart(enum reboot_mode mode, const char *cmd)
 		  "r" (1),
 		  "r" (AT91_SDRAMC_LPCB_POWER_DOWN),
 		  "r" (AT91_RSTC_KEY | AT91_RSTC_PERRST | AT91_RSTC_PROCRST));
+
+	return NOTIFY_DONE;
 }
 
-static void at91sam9g45_restart(enum reboot_mode mode, const char *cmd)
+static int at91sam9g45_restart(struct notifier_block *this, unsigned long mode,
+			       void *cmd)
 {
 	asm volatile(
 		/*
@@ -117,6 +119,8 @@ static void at91sam9g45_restart(enum reboot_mode mode, const char *cmd)
 		  "r" (AT91_DDRSDRC_LPCB_POWER_DOWN),
 		  "r" (AT91_RSTC_KEY | AT91_RSTC_PERRST | AT91_RSTC_PROCRST)
 		: "r0");
+
+	return NOTIFY_DONE;
 }
 
 static void __init at91_reset_status(struct platform_device *pdev)
@@ -161,6 +165,10 @@ static struct of_device_id at91_reset_of_match[] = {
 	{ /* sentinel */ }
 };
 
+static struct notifier_block at91_restart_nb = {
+	.priority = 192,
+};
+
 static int at91_reset_of_probe(struct platform_device *pdev)
 {
 	const struct of_device_id *match;
@@ -183,9 +191,8 @@ static int at91_reset_of_probe(struct platform_device *pdev)
 	}
 
 	match = of_match_node(at91_reset_of_match, pdev->dev.of_node);
-	arm_pm_restart = match->data;
-
-	return 0;
+	at91_restart_nb.notifier_call = match->data;
+	return register_restart_handler(&at91_restart_nb);
 }
 
 static int at91_reset_platform_probe(struct platform_device *pdev)
@@ -212,10 +219,11 @@ static int at91_reset_platform_probe(struct platform_device *pdev)
 	}
 
 	match = platform_get_device_id(pdev);
-	arm_pm_restart = (void (*)(enum reboot_mode, const char*))
-		match->driver_data;
+	at91_restart_nb.notifier_call =
+		(int (*)(struct notifier_block *,
+			 unsigned long, void *)) match->driver_data;
 
-	return 0;
+	return register_restart_handler(&at91_restart_nb);
 }
 
 static int at91_reset_probe(struct platform_device *pdev)
-- 
2.1.0

