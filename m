Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756934AbbAYSOb (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Jan 2015 13:14:31 -0500
Received: from bh-25.webhostbox.net ([208.91.199.152]:52323 "EHLO
	bh-25.webhostbox.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753356AbbAYSOS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Jan 2015 13:14:18 -0500
From: Guenter Roeck <linux@roeck-us.net>
To: Sebastian Reichel <sre@kernel.org>
Cc: linux-pm@vger.kernel.org, Guenter Roeck <linux@roeck-us.net>,
        David Woodhouse <dwmw2@infradead.org>,
        Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH 4/6] power/reset: st-poweroff: Register with kernel restart handler
Date: Sun, 25 Jan 2015 10:13:40 -0800
Message-Id: <1422209622-31994-4-git-send-email-linux@roeck-us.net>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1422209622-31994-1-git-send-email-linux@roeck-us.net>
References: <1422209622-31994-1-git-send-email-linux@roeck-us.net>
X-Authenticated_sender: guenter@roeck-us.net
X-OutGoing-Spam-Status: No, score=-1.0
X-CTCH-PVer: 0000001
X-CTCH-Spam: Unknown
X-CTCH-VOD: Unknown
X-CTCH-Flags: 0
X-CTCH-RefID: str=0001.0A020202.54C5327A.00B5,ss=1,re=0.001,recu=0.000,reip=0.000,cl=1,cld=1,fgs=0
X-CTCH-Score: 0.001
X-CTCH-ScoreCust: 0.000
X-CTCH-Rules: C_4847,
X-CTCH-SenderID: linux@roeck-us.net
X-CTCH-SenderID-Flags: 0
X-CTCH-SenderID-TotalMessages: 23
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
directly. Select high priority since the restart handler is instantiated
through devicetree, indicating that it should be used if configured.

Signed-off-by: Guenter Roeck <linux@roeck-us.net>
---
 drivers/power/reset/st-poweroff.c | 17 +++++++++++------
 1 file changed, 11 insertions(+), 6 deletions(-)

diff --git a/drivers/power/reset/st-poweroff.c b/drivers/power/reset/st-poweroff.c
index a0acf25..27383de 100644
--- a/drivers/power/reset/st-poweroff.c
+++ b/drivers/power/reset/st-poweroff.c
@@ -15,10 +15,9 @@
 #include <linux/of_platform.h>
 #include <linux/platform_device.h>
 #include <linux/mfd/syscon.h>
+#include <linux/reboot.h>
 #include <linux/regmap.h>
 
-#include <asm/system_misc.h>
-
 struct reset_syscfg {
 	struct regmap *regmap;
 	/* syscfg used for reset */
@@ -75,7 +74,8 @@ static struct reset_syscfg stid127_reset = {
 
 static struct reset_syscfg *st_restart_syscfg;
 
-static void st_restart(enum reboot_mode reboot_mode, const char *cmd)
+static int st_restart(struct notifier_block *this, unsigned long mode,
+		      void *cmd)
 {
 	/* reset syscfg updated */
 	regmap_update_bits(st_restart_syscfg->regmap,
@@ -88,8 +88,15 @@ static void st_restart(enum reboot_mode reboot_mode, const char *cmd)
 			   st_restart_syscfg->offset_rst_msk,
 			   st_restart_syscfg->mask_rst_msk,
 			   0);
+
+	return NOTIFY_DONE;
 }
 
+static struct notifier_block st_restart_nb = {
+	.notifier_call = st_restart,
+	.priority = 192,
+};
+
 static struct of_device_id st_reset_of_match[] = {
 	{
 		.compatible = "st,stih415-restart",
@@ -126,9 +133,7 @@ static int st_reset_probe(struct platform_device *pdev)
 		return PTR_ERR(st_restart_syscfg->regmap);
 	}
 
-	arm_pm_restart = st_restart;
-
-	return 0;
+	return register_restart_handler(&st_restart_nb);
 }
 
 static struct platform_driver st_reset_driver = {
-- 
2.1.0

