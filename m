Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752750AbaKFQ5A (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Nov 2014 11:57:00 -0500
Received: from bh-25.webhostbox.net ([208.91.199.152]:56330 "EHLO
	bh-25.webhostbox.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752095AbaKFQom (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Nov 2014 11:44:42 -0500
From: Guenter Roeck <linux@roeck-us.net>
To: linux-kernel@vger.kernel.org
Cc: linux-pm@vger.kernel.org, Guenter Roeck <linux@roeck-us.net>,
        David Woodhouse <dwmw2@infradead.org>,
        Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>,
        Sebastian Reichel <sre@kernel.org>
Subject: [PATCH v5 26/48] power/reset: msm-poweroff: Register with kernel power-off handler
Date: Thu,  6 Nov 2014 08:43:10 -0800
Message-Id: <1415292213-28652-27-git-send-email-linux@roeck-us.net>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1415292213-28652-1-git-send-email-linux@roeck-us.net>
References: <1415292213-28652-1-git-send-email-linux@roeck-us.net>
X-Authenticated_sender: guenter@roeck-us.net
X-OutGoing-Spam-Status: No, score=-1.0
X-CTCH-PVer: 0000001
X-CTCH-Spam: Unknown
X-CTCH-VOD: Unknown
X-CTCH-Flags: 0
X-CTCH-RefID: str=0001.0A020209.545BA579.02DB,ss=1,re=0.001,recu=0.000,reip=0.000,cl=1,cld=1,fgs=0
X-CTCH-Score: 0.001
X-CTCH-ScoreCust: 0.000
X-CTCH-Rules: C_4847,
X-CTCH-SenderID: linux@roeck-us.net
X-CTCH-SenderID-Flags: 0
X-CTCH-SenderID-TotalMessages: 148
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
- Use define to specify poweroff handler priority
- Fix headline and description
- Merge with restart handler code now used in same driver
- Use dev_warn instead of dev_err

 drivers/power/reset/msm-poweroff.c | 24 ++++++++++++++++++------
 1 file changed, 18 insertions(+), 6 deletions(-)

diff --git a/drivers/power/reset/msm-poweroff.c b/drivers/power/reset/msm-poweroff.c
index 4702efd..822f358 100644
--- a/drivers/power/reset/msm-poweroff.c
+++ b/drivers/power/reset/msm-poweroff.c
@@ -23,11 +23,17 @@
 #include <linux/pm.h>
 
 static void __iomem *msm_ps_hold;
-static int do_msm_restart(struct notifier_block *nb, unsigned long action,
-			   void *data)
+
+static void _do_msm_restart(void)
 {
 	writel(0, msm_ps_hold);
 	mdelay(10000);
+}
+
+static int do_msm_restart(struct notifier_block *nb, unsigned long action,
+			  void *data)
+{
+	_do_msm_restart();
 
 	return NOTIFY_DONE;
 }
@@ -37,12 +43,17 @@ static struct notifier_block restart_nb = {
 	.priority = 128,
 };
 
-static void do_msm_poweroff(void)
+static void do_msm_power_off(struct power_off_handler_block *this)
 {
-	/* TODO: Add poweroff capability */
-	do_msm_restart(&restart_nb, 0, NULL);
+	/* TODO: Add power-off capability */
+	_do_msm_restart();
 }
 
+static struct power_off_handler_block power_off_hb = {
+	.handler = do_msm_power_off,
+	.priority = POWER_OFF_PRIORITY_FALLBACK,
+};
+
 static int msm_restart_probe(struct platform_device *pdev)
 {
 	struct device *dev = &pdev->dev;
@@ -55,7 +66,8 @@ static int msm_restart_probe(struct platform_device *pdev)
 
 	register_restart_handler(&restart_nb);
 
-	pm_power_off = do_msm_poweroff;
+	if (register_power_off_handler(&power_off_hb))
+		dev_warn(&pdev->dev, "Failed to register power-off handler\n");
 
 	return 0;
 }
-- 
1.9.1

