Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753011AbaJ0P5H (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2014 11:57:07 -0400
Received: from bh-25.webhostbox.net ([208.91.199.152]:50151 "EHLO
	bh-25.webhostbox.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752011AbaJ0P5D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2014 11:57:03 -0400
From: Guenter Roeck <linux@roeck-us.net>
To: linux-kernel@vger.kernel.org
Cc: linux-pm@vger.kernel.org, Guenter Roeck <linux@roeck-us.net>,
        David Woodhouse <dwmw2@infradead.org>,
        Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>,
        Sebastian Reichel <sre@kernel.org>
Subject: [PATCH v3 26/47] power/reset: msm-poweroff: Register with kernel power-off handler
Date: Mon, 27 Oct 2014 08:55:33 -0700
Message-Id: <1414425354-10359-27-git-send-email-linux@roeck-us.net>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1414425354-10359-1-git-send-email-linux@roeck-us.net>
References: <1414425354-10359-1-git-send-email-linux@roeck-us.net>
X-Authenticated_sender: guenter@roeck-us.net
X-OutGoing-Spam-Status: No, score=-1.0
X-CTCH-PVer: 0000001
X-CTCH-Spam: Unknown
X-CTCH-VOD: Unknown
X-CTCH-Flags: 0
X-CTCH-RefID: str=0001.0A020209.544E6B4F.007A,ss=1,re=0.000,recu=0.000,reip=0.000,cl=1,cld=1,fgs=0
X-CTCH-Score: 0.000
X-CTCH-ScoreCust: 0.000
X-CTCH-Rules: C_4847,
X-CTCH-SenderID: linux@roeck-us.net
X-CTCH-SenderID-Flags: 0
X-CTCH-SenderID-TotalMessages: 152
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
directly. Select fallback priority since the code does not really poweroff
the system but resets it instead.

Acked-by: Sebastian Reichel <sre@kernel.org>
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
---
v3:
- Replace poweroff in all newly introduced variables and in text
  with power_off or power-off as appropriate
- Replace POWEROFF_PRIORITY_xxx with POWER_OFF_PRIORITY_xxx
v2:
- Use define to specify poweroff handler priority
- Fix headline and description
- Merge with restart handler code now used in same driver
- Use dev_warn instead of dev_err

 drivers/power/reset/msm-poweroff.c | 13 ++++++++-----
 1 file changed, 8 insertions(+), 5 deletions(-)

diff --git a/drivers/power/reset/msm-poweroff.c b/drivers/power/reset/msm-poweroff.c
index 4702efd..c63c070 100644
--- a/drivers/power/reset/msm-poweroff.c
+++ b/drivers/power/reset/msm-poweroff.c
@@ -19,10 +19,12 @@
 #include <linux/of.h>
 #include <linux/platform_device.h>
 #include <linux/module.h>
+#include <linux/notifier.h>
 #include <linux/reboot.h>
 #include <linux/pm.h>
 
 static void __iomem *msm_ps_hold;
+
 static int do_msm_restart(struct notifier_block *nb, unsigned long action,
 			   void *data)
 {
@@ -37,11 +39,11 @@ static struct notifier_block restart_nb = {
 	.priority = 128,
 };
 
-static void do_msm_poweroff(void)
-{
+static struct notifier_block msm_power_off_nb = {
 	/* TODO: Add poweroff capability */
-	do_msm_restart(&restart_nb, 0, NULL);
-}
+	.notifier_call = do_msm_restart,
+	.priority = POWER_OFF_PRIORITY_FALLBACK,
+};
 
 static int msm_restart_probe(struct platform_device *pdev)
 {
@@ -55,7 +57,8 @@ static int msm_restart_probe(struct platform_device *pdev)
 
 	register_restart_handler(&restart_nb);
 
-	pm_power_off = do_msm_poweroff;
+	if (register_power_off_handler(&msm_power_off_nb))
+		dev_warn(&pdev->dev, "Failed to register power-off handler\n");
 
 	return 0;
 }
-- 
1.9.1

