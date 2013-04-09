Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936104Ab3DITxG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Apr 2013 15:53:06 -0400
Received: from mail-wi0-f181.google.com ([209.85.212.181]:37864 "EHLO
	mail-wi0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S936044Ab3DITxE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Apr 2013 15:53:04 -0400
Date: Tue, 9 Apr 2013 20:52:58 +0100
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: arnd@arndb.de, linus.walleij@stericsson.com,
        Samuel Ortiz <sameo@linux.intel.com>
Subject: [PATCH 2/2 v2] mfd: db8500-prcmu: Support platform dependant device
 selection
Message-ID: <20130409195258.GH25316@gmail.com>
References: <1365071941-23475-1-git-send-email-lee.jones@linaro.org>
 <1365071941-23475-2-git-send-email-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1365071941-23475-2-git-send-email-lee.jones@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
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
 drivers/mfd/db8500-prcmu.c |   32 ++++++++++++++++++++++++--------
 1 file changed, 24 insertions(+), 8 deletions(-)

diff --git a/drivers/mfd/db8500-prcmu.c b/drivers/mfd/db8500-prcmu.c
index 25dda8d..319b8ab 100644
--- a/drivers/mfd/db8500-prcmu.c
+++ b/drivers/mfd/db8500-prcmu.c
@@ -24,6 +24,7 @@
 #include <linux/jiffies.h>
 #include <linux/bitops.h>
 #include <linux/fs.h>
+#include <linux/of.h>
 #include <linux/platform_device.h>
 #include <linux/uaccess.h>
 #include <linux/mfd/core.h>
@@ -3067,6 +3068,15 @@ static struct db8500_thsens_platform_data db8500_thsens_data = {
 	.num_trips = 4,
 };
 
+static struct mfd_cell common_prcmu_devs[] = {
+	{
+		.name = "ux500_wdt",
+		.platform_data = &db8500_wdt_pdata,
+		.pdata_size = sizeof(db8500_wdt_pdata),
+		.id = -1,
+	},
+};
+
 static struct mfd_cell db8500_prcmu_devs[] = {
 	{
 		.name = "db8500-prcmu-regulators",
@@ -3081,12 +3091,6 @@ static struct mfd_cell db8500_prcmu_devs[] = {
 		.pdata_size = sizeof(db8500_cpufreq_table),
 	},
 	{
-		.name = "ux500_wdt",
-		.platform_data = &db8500_wdt_pdata,
-		.pdata_size = sizeof(db8500_wdt_pdata),
-		.id = -1,
-	},
-	{
 		.name = "db8500-thermal",
 		.num_resources = ARRAY_SIZE(db8500_thsens_resources),
 		.resources = db8500_thsens_resources,
@@ -3175,13 +3179,25 @@ static int db8500_prcmu_probe(struct platform_device *pdev)
 
 	db8500_prcmu_update_cpufreq();
 
-	err = mfd_add_devices(&pdev->dev, 0, db8500_prcmu_devs,
-			      ARRAY_SIZE(db8500_prcmu_devs), NULL, 0, db8500_irq_domain);
+	err = mfd_add_devices(&pdev->dev, 0, common_prcmu_devs,
+			      ARRAY_SIZE(common_prcmu_devs), NULL, 0, db8500_irq_domain);
 	if (err) {
 		pr_err("prcmu: Failed to add subdevices\n");
 		return err;
 	}
 
+	/* TODO: Remove restriction when clk definitions are available. */
+	if (!of_machine_is_compatible("st-ericsson,u8540")) {
+		err = mfd_add_devices(&pdev->dev, 0, db8500_prcmu_devs,
+				      ARRAY_SIZE(db8500_prcmu_devs), NULL, 0,
+				      db8500_irq_domain);
+		if (err) {
+			mfd_remove_devices(&pdev->dev);
+			pr_err("prcmu: Failed to add subdevices\n");
+			goto no_irq_return;
+		}
+	}
+
 	err = db8500_prcmu_register_ab8500(&pdev->dev, pdata->ab_platdata,
 					   pdata->ab_irq);
 	if (err) {
-- 
1.7.10.4
