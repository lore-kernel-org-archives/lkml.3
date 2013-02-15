Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161413Ab3BOMqV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Feb 2013 07:46:21 -0500
Received: from mail-wi0-f174.google.com ([209.85.212.174]:57716 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161374Ab3BOMqO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Feb 2013 07:46:14 -0500
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: arnd@arndb.de, linus.walleij@stericsson.com, cbouatmailru@gmail.com,
        sameo@linux.intel.com, Rupesh Kumar <rupesh.kumar@stericsson.com>,
        Lee Jones <lee.jones@linaro.org>
Subject: [PATCH 14/40] pm2301-charger: Die temp thermal protection
Date: Fri, 15 Feb 2013 12:44:44 +0000
Message-Id: <1360932310-30065-15-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1360932310-30065-1-git-send-email-lee.jones@linaro.org>
References: <1360932310-30065-1-git-send-email-lee.jones@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rupesh Kumar <rupesh.kumar@stericsson.com>

This patch adds support for die temperature thermal protection
in pm2301 driver.

Signed-off-by: Rupesh Kumar <rupesh.kumar@stericsson.com>
Signed-off-by: Lee Jones <lee.jones@linaro.org>
Reviewed-by: Hakan BERG <hakan.berg@stericsson.com>
Reviewed-by: Philippe LANGLAIS <philippe.langlais@stericsson.com>
---
 drivers/power/pm2301_charger.c |   22 +++++++++++++++++++++-
 1 file changed, 21 insertions(+), 1 deletion(-)

diff --git a/drivers/power/pm2301_charger.c b/drivers/power/pm2301_charger.c
index 4cb8f7f..ec51026 100644
--- a/drivers/power/pm2301_charger.c
+++ b/drivers/power/pm2301_charger.c
@@ -876,7 +876,27 @@ static void pm2xxx_charger_check_hw_failure_work(struct work_struct *work)
 static void pm2xxx_charger_check_main_thermal_prot_work(
 	struct work_struct *work)
 {
-};
+	int ret;
+	u8 val;
+
+	struct pm2xxx_charger *pm2 = container_of(work, struct pm2xxx_charger,
+					check_main_thermal_prot_work);
+
+	/* Check if die temp warning is still active */
+	ret = pm2xxx_reg_read(pm2, PM2XXX_SRCE_REG_INT5, &val);
+	if (ret < 0) {
+		dev_err(pm2->dev, "%s pm2xxx read failed\n", __func__);
+		return;
+	}
+	if (val & (PM2XXX_INT5_S_ITTHERMALWARNINGRISE
+			| PM2XXX_INT5_S_ITTHERMALSHUTDOWNRISE))
+		pm2->flags.main_thermal_prot = true;
+	else if (val & (PM2XXX_INT5_S_ITTHERMALWARNINGFALL
+				| PM2XXX_INT5_S_ITTHERMALSHUTDOWNFALL))
+		pm2->flags.main_thermal_prot = false;
+
+	power_supply_changed(&pm2->ac_chg.psy);
+}
 
 static struct pm2xxx_interrupts pm2xxx_int = {
 	.handler[0] = pm2_int_reg0,
-- 
1.7.10.4

