Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161898Ab3BONDt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Feb 2013 08:03:49 -0500
Received: from mail-wi0-f181.google.com ([209.85.212.181]:50582 "EHLO
	mail-wi0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161785Ab3BOM5t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Feb 2013 07:57:49 -0500
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        sameo@linux.intel.com
Cc: arnd@arndb.de, linus.walleij@stericsson.com,
        Marcus Danielsson <marcus.danielsson@stericsson.com>,
        Lee Jones <lee.jones@linaro.org>
Subject: [PATCH 14/35] mfd: ab8500-sysctrl: Error check clean up
Date: Fri, 15 Feb 2013 12:56:45 +0000
Message-Id: <1360933026-30325-15-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1360933026-30325-1-git-send-email-lee.jones@linaro.org>
References: <1360933026-30325-1-git-send-email-lee.jones@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Marcus Danielsson <marcus.danielsson@stericsson.com>

Add error checks to see if sysctrl was probed as it should.
If the sysctrl_dev is not set the return value is -EINVAL.

Signed-off-by: Marcus Danielsson <marcus.danielsson@stericsson.com>
Signed-off-by: Lee Jones <lee.jones@linaro.org>
Reviewed-by: Mattias WALLIN <mattias.wallin@stericsson.com>
Tested-by: Per FORLIN <per.forlin@stericsson.com>
---
 drivers/mfd/ab8500-sysctrl.c |   38 ++++++++++++++++++++++----------------
 1 file changed, 22 insertions(+), 16 deletions(-)

diff --git a/drivers/mfd/ab8500-sysctrl.c b/drivers/mfd/ab8500-sysctrl.c
index 108fd86..ab6bfd3 100644
--- a/drivers/mfd/ab8500-sysctrl.c
+++ b/drivers/mfd/ab8500-sysctrl.c
@@ -28,6 +28,11 @@ void ab8500_power_off(void)
 	struct power_supply *psy;
 	int ret;
 
+	if (sysctrl_dev == NULL) {
+		pr_err("%s: sysctrl not initialized\n", __func__);
+		return;
+	}
+
 	/*
 	 * If we have a charger connected and we're powering off,
 	 * reboot into charge-only mode.
@@ -85,7 +90,7 @@ int ab8500_sysctrl_read(u16 reg, u8 *value)
 	u8 bank;
 
 	if (sysctrl_dev == NULL)
-		return -EAGAIN;
+		return -EINVAL;
 
 	bank = (reg >> 8);
 	if (!valid_bank(bank))
@@ -101,7 +106,7 @@ int ab8500_sysctrl_write(u16 reg, u8 mask, u8 value)
 	u8 bank;
 
 	if (sysctrl_dev == NULL)
-		return -EAGAIN;
+		return -EINVAL;
 
 	bank = (reg >> 8);
 	if (!valid_bank(bank))
@@ -116,31 +121,32 @@ static int ab8500_sysctrl_probe(struct platform_device *pdev)
 {
 	struct ab8500_platform_data *plat;
 	struct ab8500_sysctrl_platform_data *pdata;
+	int ret, i, j;
 
-	sysctrl_dev = &pdev->dev;
 	plat = dev_get_platdata(pdev->dev.parent);
+
+	if (!(plat && plat->sysctrl))
+		return -EINVAL;
+
 	if (plat->pm_power_off)
 		pm_power_off = ab8500_power_off;
 
 	pdata = plat->sysctrl;
 
-	if (pdata) {
-		int ret, i, j;
 
-		for (i = AB8500_SYSCLKREQ1RFCLKBUF;
-		     i <= AB8500_SYSCLKREQ8RFCLKBUF; i++) {
-			j = i - AB8500_SYSCLKREQ1RFCLKBUF;
-			ret = ab8500_sysctrl_write(i, 0xff,
-						   pdata->initial_req_buf_config[j]);
-			dev_dbg(&pdev->dev,
+	for (i = AB8500_SYSCLKREQ1RFCLKBUF;
+	     i <= AB8500_SYSCLKREQ8RFCLKBUF; i++) {
+		j = i - AB8500_SYSCLKREQ1RFCLKBUF;
+		ret = ab8500_sysctrl_write(i, 0xff,
+				pdata->initial_req_buf_config[j]);
+		dev_dbg(&pdev->dev,
 				"Setting SysClkReq%dRfClkBuf 0x%X\n",
 				j + 1,
 				pdata->initial_req_buf_config[j]);
-			if (ret < 0) {
-				dev_err(&pdev->dev,
-					"unable to set sysClkReq%dRfClkBuf: "
-					"%d\n", j + 1, ret);
-			}
+		if (ret < 0) {
+			dev_err(&pdev->dev,
+				"unable to set sysClkReq%dRfClkBuf: "
+				"%d\n", j + 1, ret);
 		}
 	}
 
-- 
1.7.10.4

