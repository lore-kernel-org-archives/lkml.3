Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932110AbaA1Qyq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jan 2014 11:54:46 -0500
Received: from mail-pb0-f41.google.com ([209.85.160.41]:53332 "EHLO
	mail-pb0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753866AbaA1Qyo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jan 2014 11:54:44 -0500
From: Manish Badarkhe <badarkhe.manish@gmail.com>
To: linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: dbaryshkov@gmail.com, dwmw2@infradead.org, badarkhe.manish@gmail.com
Subject: [PATCH V4] max8925_power: Use "IS_ENABLED(CONFIG_OF)" for DT code.
Date: Tue, 28 Jan 2014 22:24:29 +0530
Message-Id: <1390928069-7313-1-git-send-email-badarkhe.manish@gmail.com>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Instead of "#ifdef CONFIG_OF" use "IS_ENABLED(CONFIG_OF)"
option for DT code to avoid if-deffery in code.

Signed-off-by: Manish Badarkhe <badarkhe.manish@gmail.com>
---
Changes since V1:
1.Updated code to use "IS_ENABLED" during retrieval 
  of platform/DT data.

Changes since V2:
1.Updated code as per Dmitry's comment to give preferance to
  platform data. 

Changes since V3:
1.Updated code to use "IS_ENABLED(CONFIG_OF)" to remove 
  DT data retrieval function during compilation itself
  when CONFIG_OF option is not set.

:100644 100644 b4513f2... a7482db... M	drivers/power/max8925_power.c
 drivers/power/max8925_power.c |   17 +++++------------
 1 file changed, 5 insertions(+), 12 deletions(-)

diff --git a/drivers/power/max8925_power.c b/drivers/power/max8925_power.c
index b4513f2..a7482db 100644
--- a/drivers/power/max8925_power.c
+++ b/drivers/power/max8925_power.c
@@ -427,7 +427,6 @@ static int max8925_deinit_charger(struct max8925_power_info *info)
 	return 0;
 }
 
-#ifdef CONFIG_OF
 static struct max8925_power_pdata *
 max8925_power_dt_init(struct platform_device *pdev)
 {
@@ -440,9 +439,6 @@ max8925_power_dt_init(struct platform_device *pdev)
 	int no_insert_detect;
 	struct max8925_power_pdata *pdata;
 
-	if (!nproot)
-		return pdev->dev.platform_data;
-
 	np = of_find_node_by_name(nproot, "charger");
 	if (!np) {
 		dev_err(&pdev->dev, "failed to find charger node\n");
@@ -468,13 +464,6 @@ max8925_power_dt_init(struct platform_device *pdev)
 
 	return pdata;
 }
-#else
-static struct max8925_power_pdata *
-max8925_power_dt_init(struct platform_device *pdev)
-{
-	return pdev->dev.platform_data;
-}
-#endif
 
 static int max8925_power_probe(struct platform_device *pdev)
 {
@@ -483,7 +472,11 @@ static int max8925_power_probe(struct platform_device *pdev)
 	struct max8925_power_info *info;
 	int ret;
 
-	pdata = max8925_power_dt_init(pdev);
+	pdata = dev_get_platdata(&pdev->dev);
+
+	if (IS_ENABLED(CONFIG_OF) && !pdata && chip->dev->of_node)
+		pdata = max8925_power_dt_init(pdev);
+
 	if (!pdata) {
 		dev_err(&pdev->dev, "platform data isn't assigned to "
 			"power supply\n");
-- 
1.7.10.4

