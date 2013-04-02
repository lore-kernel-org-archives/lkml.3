Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761217Ab3DBNWl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Apr 2013 09:22:41 -0400
Received: from mail-wg0-f53.google.com ([74.125.82.53]:48769 "EHLO
	mail-wg0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761121Ab3DBNWZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Apr 2013 09:22:25 -0400
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: arnd@arndb.de, linus.walleij@stericsson.com,
        Lee Jones <lee.jones@linaro.org>, Samuel Ortiz <sameo@linux.intel.com>
Subject: [PATCH 9/9] mfd: db8500-prcmu: Support platform dependant device selection
Date: Tue,  2 Apr 2013 14:21:56 +0100
Message-Id: <1364908916-29803-9-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1364908916-29803-1-git-send-email-lee.jones@linaro.org>
References: <1364908916-29803-1-git-send-email-lee.jones@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The main aim for this cycle is to have the u8540 booting to a
console. However, the u8540 doesn't support all of the u8500
platform devices yet. After this stage is complete we can then
fill in the inadequacies, such as specific clock support at a
later date. To achieve this we're placing devices supported by
all platforms into a common device structure and the remaining
ones into a platform specific one.

Cc: Samuel Ortiz <sameo@linux.intel.com>
Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 drivers/mfd/db8500-prcmu.c |   45 ++++++++++++++++++++++++++++----------------
 1 file changed, 29 insertions(+), 16 deletions(-)

diff --git a/drivers/mfd/db8500-prcmu.c b/drivers/mfd/db8500-prcmu.c
index 1c4edbf8..5a03b5d 100644
--- a/drivers/mfd/db8500-prcmu.c
+++ b/drivers/mfd/db8500-prcmu.c
@@ -3107,19 +3107,7 @@ static struct ux500_wdt_data db8500_wdt_pdata = {
 	.has_28_bits_resolution = true,
 };
 
-static struct mfd_cell db8500_prcmu_devs[] = {
-	{
-		.name = "db8500-prcmu-regulators",
-		.of_compatible = "stericsson,db8500-prcmu-regulator",
-		.platform_data = &db8500_regulators,
-		.pdata_size = sizeof(db8500_regulators),
-	},
-	{
-		.name = "cpufreq-ux500",
-		.of_compatible = "stericsson,cpufreq-ux500",
-		.platform_data = &db8500_cpufreq_table,
-		.pdata_size = sizeof(db8500_cpufreq_table),
-	},
+static struct mfd_cell common_prcmu_devs[] = {
 	{
 		.name = "ux500_wdt",
 		.platform_data = &db8500_wdt_pdata,
@@ -3135,6 +3123,21 @@ static struct mfd_cell db8500_prcmu_devs[] = {
 	},
 };
 
+static struct mfd_cell db8500_prcmu_devs[] = {
+	{
+		.name = "db8500-prcmu-regulators",
+		.of_compatible = "stericsson,db8500-prcmu-regulator",
+		.platform_data = &db8500_regulators,
+		.pdata_size = sizeof(db8500_regulators),
+	},
+	{
+		.name = "cpufreq-ux500",
+		.of_compatible = "stericsson,cpufreq-ux500",
+		.platform_data = &db8500_cpufreq_table,
+		.pdata_size = sizeof(db8500_cpufreq_table),
+	},
+};
+
 static void db8500_prcmu_update_cpufreq(void)
 {
 	if (prcmu_has_arm_maxopp()) {
@@ -3184,7 +3187,7 @@ static int db8500_prcmu_probe(struct platform_device *pdev)
 
 	db8500_irq_init(np);
 
-	for (i = 0; i < ARRAY_SIZE(db8500_prcmu_devs); i++) {
+	for (i = 0; i < ARRAY_SIZE(common_prcmu_devs); i++) {
 		if (!strcmp(db8500_prcmu_devs[i].name, "ab8500-core")) {
 			db8500_prcmu_devs[i].platform_data = pdata->ab_platdata;
 			db8500_prcmu_devs[i].pdata_size = sizeof(struct ab8500_platform_data);
@@ -3195,13 +3198,23 @@ static int db8500_prcmu_probe(struct platform_device *pdev)
 
 	db8500_prcmu_update_cpufreq();
 
-	err = mfd_add_devices(&pdev->dev, 0, db8500_prcmu_devs,
-			      ARRAY_SIZE(db8500_prcmu_devs), NULL, 0, NULL);
+	err = mfd_add_devices(&pdev->dev, 0, common_prcmu_devs,
+			      ARRAY_SIZE(common_prcmu_devs), NULL, 0, NULL);
 	if (err) {
 		pr_err("prcmu: Failed to add subdevices\n");
 		return err;
 	}
 
+	/* TODO: Remove restriction when clk definitions are available. */
+	if (!of_machine_is_compatible("st-ericsson,u8540")) {
+		err = mfd_add_devices(&pdev->dev, 0, db8500_prcmu_devs,
+				      ARRAY_SIZE(db8500_prcmu_devs), NULL, 0, NULL);
+		if (err) {
+			pr_err("prcmu: Failed to add subdevices\n");
+			return err;
+		}
+	}
+
 	pr_info("DB8500 PRCMU initialized\n");
 
 no_irq_return:
-- 
1.7.10.4

