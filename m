Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932292AbaJUEUt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Oct 2014 00:20:49 -0400
Received: from bh-25.webhostbox.net ([208.91.199.152]:33774 "EHLO
	bh-25.webhostbox.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754477AbaJUEOS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Oct 2014 00:14:18 -0400
From: Guenter Roeck <linux@roeck-us.net>
To: linux-kernel@vger.kernel.org
Cc: linux-pm@vger.kernel.org, Guenter Roeck <linux@roeck-us.net>,
        David Woodhouse <dwmw2@infradead.org>,
        Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>,
        Sebastian Reichel <sre@kernel.org>
Subject: [PATCH v2 28/47] power/reset: at91-poweroff: Register with kernel poweroff handler
Date: Mon, 20 Oct 2014 21:12:44 -0700
Message-Id: <1413864783-3271-29-git-send-email-linux@roeck-us.net>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1413864783-3271-1-git-send-email-linux@roeck-us.net>
References: <1413864783-3271-1-git-send-email-linux@roeck-us.net>
X-Authenticated_sender: guenter@roeck-us.net
X-OutGoing-Spam-Status: No, score=-1.0
X-CTCH-PVer: 0000001
X-CTCH-Spam: Unknown
X-CTCH-VOD: Unknown
X-CTCH-Flags: 0
X-CTCH-RefID: str=0001.0A020209.5445DD99.00E7,ss=1,re=0.000,recu=0.000,reip=0.000,cl=1,cld=1,fgs=0
X-CTCH-Score: 0.000
X-CTCH-ScoreCust: 0.000
X-CTCH-Rules: C_4847,
X-CTCH-SenderID: linux@roeck-us.net
X-CTCH-SenderID-Flags: 0
X-CTCH-SenderID-TotalMessages: 155
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
directly. Select default priority to reflect that the original code sets
pm_power_off unconditionally.

Signed-off-by: Guenter Roeck <linux@roeck-us.net>
---
v2: Added patch

 drivers/power/reset/at91-poweroff.c | 16 ++++++++++++----
 1 file changed, 12 insertions(+), 4 deletions(-)

diff --git a/drivers/power/reset/at91-poweroff.c b/drivers/power/reset/at91-poweroff.c
index c610003..ac49a83 100644
--- a/drivers/power/reset/at91-poweroff.c
+++ b/drivers/power/reset/at91-poweroff.c
@@ -12,8 +12,10 @@
 
 #include <linux/io.h>
 #include <linux/module.h>
+#include <linux/notifier.h>
 #include <linux/of.h>
 #include <linux/platform_device.h>
+#include <linux/pm.h>
 #include <linux/printk.h>
 
 #define AT91_SHDW_CR	0x00		/* Shut Down Control Register */
@@ -66,11 +68,19 @@ static void __init at91_wakeup_status(void)
 	pr_info("AT91: Wake-Up source: %s\n", reason);
 }
 
-static void at91_poweroff(void)
+static int at91_poweroff(struct notifier_block *this, unsigned long unused1,
+			 void *unused2)
 {
 	writel(AT91_SHDW_KEY | AT91_SHDW_SHDW, at91_shdwc_base + AT91_SHDW_CR);
+
+	return NOTIFY_DONE;
 }
 
+static struct notifier_block at91_poweroff_nb = {
+	.notifier_call = at91_poweroff,
+	.priority = POWEROFF_PRIORITY_DEFAULT,
+};
+
 const enum wakeup_type at91_poweroff_get_wakeup_mode(struct device_node *np)
 {
 	const char *pm;
@@ -134,9 +144,7 @@ static int at91_poweroff_probe(struct platform_device *pdev)
 	if (pdev->dev.of_node)
 		at91_poweroff_dt_set_wakeup_mode(pdev);
 
-	pm_power_off = at91_poweroff;
-
-	return 0;
+	return devm_register_power_off_handler(&pdev->dev, &at91_poweroff_nb);
 }
 
 static struct of_device_id at91_poweroff_of_match[] = {
-- 
1.9.1

