Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755353AbbAYUbc (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Jan 2015 15:31:32 -0500
Received: from bh-25.webhostbox.net ([208.91.199.152]:45923 "EHLO
	bh-25.webhostbox.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752761AbbAYUb0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Jan 2015 15:31:26 -0500
From: Guenter Roeck <linux@roeck-us.net>
To: Sebastian Reichel <sre@kernel.org>
Cc: linux-pm@vger.kernel.org, Guenter Roeck <linux@roeck-us.net>,
        David Woodhouse <dwmw2@infradead.org>,
        Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2 1/6] power/reset: arm-versatile: Register with kernel restart handler
Date: Sun, 25 Jan 2015 12:30:40 -0800
Message-Id: <1422217845-18901-2-git-send-email-linux@roeck-us.net>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1422217845-18901-1-git-send-email-linux@roeck-us.net>
References: <1422217845-18901-1-git-send-email-linux@roeck-us.net>
X-Authenticated_sender: guenter@roeck-us.net
X-OutGoing-Spam-Status: No, score=-1.0
X-CTCH-PVer: 0000001
X-CTCH-Spam: Unknown
X-CTCH-VOD: Unknown
X-CTCH-Flags: 0
X-CTCH-RefID: str=0001.0A020204.54C5529E.0003,ss=1,re=0.001,recu=0.000,reip=0.000,cl=1,cld=1,fgs=0
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
directly. Select high priority since the restart handler is instantiated
through devicetree, indicating that it should be used if configured.

Signed-off-by: Guenter Roeck <linux@roeck-us.net>
---
 drivers/power/reset/arm-versatile-reboot.c | 17 ++++++++++++++---
 1 file changed, 14 insertions(+), 3 deletions(-)

diff --git a/drivers/power/reset/arm-versatile-reboot.c b/drivers/power/reset/arm-versatile-reboot.c
index adea9d0..b208073 100644
--- a/drivers/power/reset/arm-versatile-reboot.c
+++ b/drivers/power/reset/arm-versatile-reboot.c
@@ -13,7 +13,6 @@
 #include <linux/reboot.h>
 #include <linux/regmap.h>
 #include <linux/of.h>
-#include <asm/system_misc.h>
 
 #define INTEGRATOR_HDR_CTRL_OFFSET	0x0C
 #define INTEGRATOR_HDR_LOCK_OFFSET	0x14
@@ -69,7 +68,8 @@ static const struct of_device_id versatile_reboot_of_match[] = {
 	{},
 };
 
-static void versatile_reboot(enum reboot_mode mode, const char *cmd)
+static int versatile_reboot(struct notifier_block *this, unsigned long mode,
+			    void *cmd)
 {
 	/* Unlock the reset register */
 	/* Then hit reset on the different machines */
@@ -113,12 +113,20 @@ static void versatile_reboot(enum reboot_mode mode, const char *cmd)
 		break;
 	}
 	dsb();
+
+	return NOTIFY_DONE;
 }
 
+static struct notifier_block versatile_reboot_nb = {
+	.notifier_call = versatile_reboot,
+	.priority = 192,
+};
+
 static int __init versatile_reboot_probe(void)
 {
 	const struct of_device_id *reboot_id;
 	struct device_node *np;
+	int err;
 
 	np = of_find_matching_node_and_match(NULL, versatile_reboot_of_match,
 						 &reboot_id);
@@ -130,7 +138,10 @@ static int __init versatile_reboot_probe(void)
 	if (IS_ERR(syscon_regmap))
 		return PTR_ERR(syscon_regmap);
 
-	arm_pm_restart = versatile_reboot;
+	err = register_restart_handler(&versatile_reboot_nb);
+	if (err)
+		return err;
+
 	pr_info("versatile reboot driver registered\n");
 	return 0;
 }
-- 
2.1.0

