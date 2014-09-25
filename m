Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752654AbaIYLa2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Sep 2014 07:30:28 -0400
Received: from smtp113.ord1c.emailsrvr.com ([108.166.43.113]:40080 "EHLO
	smtp113.ord1c.emailsrvr.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751514AbaIYLa0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Sep 2014 07:30:26 -0400
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
Subject: [PATCH v4] power: reset: use restart_notifier mechanism for msm-poweroff
Date: Thu, 25 Sep 2014 17:03:51 +0530
Message-Id: <1411644831-2931-1-git-send-email-pramod.gurav@smartplayin.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This change replaces use of arm_pm_restart with recently introduced
reset mechanism in Linux kernel called restart_notifier.

Choosing priority 128, which is default priority, as according to 
documentation, this mechanism is sufficient to restart the entire system.

Cc: Guenter Roeck <linux@roeck-us.net>
Cc: Josh Cartwright <joshc@codeaurora.org>
Cc: Sebastian Reichel <sre@kernel.org>
Cc: Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>
Cc: David Woodhouse <dwmw2@infradead.org>
Cc: Stephen Boyd <sboyd@codeaurora.org>
Cc: linux-pm@vger.kernel.org

Reviewed-by: Guenter Roeck <linux@roeck-us.net>
Reviewed-by: Stephen Boyd <sboyd@codeaurora.org>
Signed-off-by: Pramod Gurav <pramod.gurav@smartplayin.com>
---
Why reset handler in pinctrl-msm wont collide with reset
in poweroff-msm.c in this patch:

In case of apq8064, the ps_hold register region is owned by
pinctrl hence the reset is implemented in pinctrl driver as
the region is already mapped there.
Whereas ps_hold register region in apq8074 are moved to its 
own region. So, for apq8074 there is no need for ps_hold to
be configured/muxed in pinctrl and Josh's changes wont execute.
Hence msm-poweroff wil be the default reset as 128 in the 
default priority.

Tested on Dragonboard APQ8074

Changes since v3:
- Updated Commit message about default priority chosen and how ps_hold
  in a and b family are different.

Changes since v2:
- Removed unwanted header file and added linux/pm.h

Changes since v1:
- Initialized restart_nb with its declaration
- Removed return check for register_restart_handler as it always
  returns 0 as per Guenter's suggestion to Josh's similar patch.
  This takes care of Guenter's comments on error logs and NULL
  initialization of restart_nb.notifier_call.
---
 drivers/power/reset/msm-poweroff.c |   20 ++++++++++++++------
 1 file changed, 14 insertions(+), 6 deletions(-)

diff --git a/drivers/power/reset/msm-poweroff.c b/drivers/power/reset/msm-poweroff.c
index 774f9a3..4702efd 100644
--- a/drivers/power/reset/msm-poweroff.c
+++ b/drivers/power/reset/msm-poweroff.c
@@ -20,21 +20,27 @@
 #include <linux/platform_device.h>
 #include <linux/module.h>
 #include <linux/reboot.h>
-
-#include <asm/system_misc.h>
+#include <linux/pm.h>
 
 static void __iomem *msm_ps_hold;
-
-static void do_msm_restart(enum reboot_mode reboot_mode, const char *cmd)
+static int do_msm_restart(struct notifier_block *nb, unsigned long action,
+			   void *data)
 {
 	writel(0, msm_ps_hold);
 	mdelay(10000);
+
+	return NOTIFY_DONE;
 }
 
+static struct notifier_block restart_nb = {
+	.notifier_call = do_msm_restart,
+	.priority = 128,
+};
+
 static void do_msm_poweroff(void)
 {
 	/* TODO: Add poweroff capability */
-	do_msm_restart(REBOOT_HARD, NULL);
+	do_msm_restart(&restart_nb, 0, NULL);
 }
 
 static int msm_restart_probe(struct platform_device *pdev)
@@ -47,8 +53,10 @@ static int msm_restart_probe(struct platform_device *pdev)
 	if (IS_ERR(msm_ps_hold))
 		return PTR_ERR(msm_ps_hold);
 
+	register_restart_handler(&restart_nb);
+
 	pm_power_off = do_msm_poweroff;
-	arm_pm_restart = do_msm_restart;
+
 	return 0;
 }
 
-- 
1.7.9.5

