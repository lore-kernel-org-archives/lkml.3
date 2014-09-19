Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756162AbaISMDs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Sep 2014 08:03:48 -0400
Received: from smtp81.ord1c.emailsrvr.com ([108.166.43.81]:37739 "EHLO
	smtp81.ord1c.emailsrvr.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755682AbaISMDq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Sep 2014 08:03:46 -0400
X-Sender-Id: pramod.gurav@smartplayin.com
From: Pramod Gurav <pramod.gurav@smartplayin.com>
To: linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org
Cc: Pramod Gurav <pramod.gurav@smartplayin.com>,
        Guenter Roeck <linux@roeck-us.net>,
        Josh Cartwright <joshc@codeaurora.org>,
        Sebastian Reichel <sre@kernel.org>,
        Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>,
        David Woodhouse <dwmw2@infradead.org>,
        Stephen Boyd <sboyd@codeaurora.org>, linux-pm@vger.kernel.org
Subject: [PATCH] power: reset: use restart_notifier mechanism for msm poweroff
Date: Fri, 19 Sep 2014 17:36:55 +0530
Message-Id: <1411128415-20381-1-git-send-email-pramod.gurav@smartplayin.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This change uses replaces use of arm_pm_restart with recently introduced
reset mechanism in Linux kernel called restart_notifier.

Cc: Guenter Roeck <linux@roeck-us.net>
Cc: Josh Cartwright <joshc@codeaurora.org>
Cc: Sebastian Reichel <sre@kernel.org>
Cc: Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>
Cc: David Woodhouse <dwmw2@infradead.org>
Cc: Stephen Boyd <sboyd@codeaurora.org>
Cc: linux-pm@vger.kernel.org

Signed-off-by: Pramod Gurav <pramod.gurav@smartplayin.com>

---

This patch is tested on DB8074 Target and are based on patchset [1]
by Guenter Roeck.

[1]: https://patchwork.kernel.org/patch/4746721/

 drivers/power/reset/msm-poweroff.c |   18 +++++++++++++++---
 1 file changed, 15 insertions(+), 3 deletions(-)

diff --git a/drivers/power/reset/msm-poweroff.c b/drivers/power/reset/msm-poweroff.c
index 774f9a3..59b368c 100644
--- a/drivers/power/reset/msm-poweroff.c
+++ b/drivers/power/reset/msm-poweroff.c
@@ -24,17 +24,21 @@
 #include <asm/system_misc.h>
 
 static void __iomem *msm_ps_hold;
+static struct notifier_block restart_nb;
 
-static void do_msm_restart(enum reboot_mode reboot_mode, const char *cmd)
+static int do_msm_restart(struct notifier_block *nb, unsigned long action,
+			   void *data)
 {
 	writel(0, msm_ps_hold);
 	mdelay(10000);
+
+	return NOTIFY_DONE;
 }
 
 static void do_msm_poweroff(void)
 {
 	/* TODO: Add poweroff capability */
-	do_msm_restart(REBOOT_HARD, NULL);
+	do_msm_restart(&restart_nb, 0, NULL);
 }
 
 static int msm_restart_probe(struct platform_device *pdev)
@@ -47,8 +51,16 @@ static int msm_restart_probe(struct platform_device *pdev)
 	if (IS_ERR(msm_ps_hold))
 		return PTR_ERR(msm_ps_hold);
 
+	restart_nb.notifier_call = do_msm_restart;
+	restart_nb.priority = 128;
+	if (register_restart_handler(&restart_nb)) {
+		dev_err(&pdev->dev,
+			"failed to setup restart handler.\n");
+			restart_nb.notifier_call = NULL;
+	}
+
 	pm_power_off = do_msm_poweroff;
-	arm_pm_restart = do_msm_restart;
+
 	return 0;
 }
 
-- 
1.7.9.5

