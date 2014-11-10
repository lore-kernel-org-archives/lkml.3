Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752532AbaKJBog (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Nov 2014 20:44:36 -0500
Received: from bh-25.webhostbox.net ([208.91.199.152]:39093 "EHLO
	bh-25.webhostbox.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752455AbaKJBo0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Nov 2014 20:44:26 -0500
From: Guenter Roeck <linux@roeck-us.net>
To: linux-kernel@vger.kernel.org
Cc: linux-pm@vger.kernel.org, Guenter Roeck <linux@roeck-us.net>,
        David Woodhouse <dwmw2@infradead.org>,
        Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>,
        Sebastian Reichel <sre@kernel.org>
Subject: [PATCH v6 28/48] power/reset: at91-poweroff: Register with kernel power-off handler
Date: Sun,  9 Nov 2014 17:42:45 -0800
Message-Id: <1415583785-6980-29-git-send-email-linux@roeck-us.net>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1415583785-6980-1-git-send-email-linux@roeck-us.net>
References: <1415583785-6980-1-git-send-email-linux@roeck-us.net>
X-Authenticated_sender: guenter@roeck-us.net
X-OutGoing-Spam-Status: No, score=-1.0
X-CTCH-PVer: 0000001
X-CTCH-Spam: Unknown
X-CTCH-VOD: Unknown
X-CTCH-Flags: 0
X-CTCH-RefID: str=0001.0A020202.5460187A.00F7,ss=1,re=0.001,recu=0.000,reip=0.000,cl=1,cld=1,fgs=0
X-CTCH-Score: 0.001
X-CTCH-ScoreCust: 0.000
X-CTCH-Rules: C_4847,
X-CTCH-SenderID: linux@roeck-us.net
X-CTCH-SenderID-Flags: 0
X-CTCH-SenderID-TotalMessages: 164
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

Register with kernel power-off handler instead of setting pm_power_off
directly. Select default priority to reflect that the original code sets
pm_power_off unconditionally.

Acked-by: Sebastian Reichel <sre@kernel.org>
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
---
v6:
- This patch: No change.
  Global: Replaced priority defines with enum.
v5:
- Rebase to v3.18-rc3
v4:
- Do not use notifiers but internal functions and data structures to manage
  the list of power-off handlers. Drop unused parameters from callbacks, and
  make the power-off function type void
v3:
- Replace poweroff in all newly introduced variables and in text
  with power_off or power-off as appropriate
- Replace POWEROFF_PRIORITY_xxx with POWER_OFF_PRIORITY_xxx
v2:
- Added patch

 drivers/power/reset/at91-poweroff.c | 12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

diff --git a/drivers/power/reset/at91-poweroff.c b/drivers/power/reset/at91-poweroff.c
index c610003..6fc5944 100644
--- a/drivers/power/reset/at91-poweroff.c
+++ b/drivers/power/reset/at91-poweroff.c
@@ -14,6 +14,7 @@
 #include <linux/module.h>
 #include <linux/of.h>
 #include <linux/platform_device.h>
+#include <linux/pm.h>
 #include <linux/printk.h>
 
 #define AT91_SHDW_CR	0x00		/* Shut Down Control Register */
@@ -66,11 +67,16 @@ static void __init at91_wakeup_status(void)
 	pr_info("AT91: Wake-Up source: %s\n", reason);
 }
 
-static void at91_poweroff(void)
+static void at91_poweroff(struct power_off_handler_block *this)
 {
 	writel(AT91_SHDW_KEY | AT91_SHDW_SHDW, at91_shdwc_base + AT91_SHDW_CR);
 }
 
+static struct power_off_handler_block at91_power_off_hb = {
+	.handler = at91_poweroff,
+	.priority = POWER_OFF_PRIORITY_DEFAULT,
+};
+
 const enum wakeup_type at91_poweroff_get_wakeup_mode(struct device_node *np)
 {
 	const char *pm;
@@ -134,9 +140,7 @@ static int at91_poweroff_probe(struct platform_device *pdev)
 	if (pdev->dev.of_node)
 		at91_poweroff_dt_set_wakeup_mode(pdev);
 
-	pm_power_off = at91_poweroff;
-
-	return 0;
+	return devm_register_power_off_handler(&pdev->dev, &at91_power_off_hb);
 }
 
 static struct of_device_id at91_poweroff_of_match[] = {
-- 
1.9.1

