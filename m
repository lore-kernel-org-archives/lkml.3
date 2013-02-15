Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161960Ab3BONDb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Feb 2013 08:03:31 -0500
Received: from mail-wg0-f52.google.com ([74.125.82.52]:38096 "EHLO
	mail-wg0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161786Ab3BOM5v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Feb 2013 07:57:51 -0500
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        sameo@linux.intel.com
Cc: arnd@arndb.de, linus.walleij@stericsson.com,
        Alexandre Torgue <alexandre.torgue@stericsson.com>,
        Lee Jones <lee.jones@linaro.org>
Subject: [PATCH 15/35] mfd: ab8500-debugfs: Add tests for ab8540 based platform initialisations
Date: Fri, 15 Feb 2013 12:56:46 +0000
Message-Id: <1360933026-30325-16-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1360933026-30325-1-git-send-email-lee.jones@linaro.org>
References: <1360933026-30325-1-git-send-email-lee.jones@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alexandre Torgue <alexandre.torgue@stericsson.com>

Signed-off-by: Alexandre Torgue <alexandre.torgue@stericsson.com>
Signed-off-by: Lee Jones <lee.jones@linaro.org>
Reviewed-by: Marcus COOPER <marcus.xm.cooper@stericsson.com>
Reviewed-by: Mattias WALLIN <mattias.wallin@stericsson.com>
Tested-by: Maxime COQUELIN <maxime.coquelin@stericsson.com>
---
 drivers/mfd/ab8500-core.c    |   11 +++++++----
 drivers/mfd/ab8500-debugfs.c |    2 ++
 2 files changed, 9 insertions(+), 4 deletions(-)

diff --git a/drivers/mfd/ab8500-core.c b/drivers/mfd/ab8500-core.c
index e82cf73..f5ceb2e 100644
--- a/drivers/mfd/ab8500-core.c
+++ b/drivers/mfd/ab8500-core.c
@@ -1296,7 +1296,8 @@ static ssize_t show_chip_id(struct device *dev,
 	ab8500 = dev_get_drvdata(dev);
 	if(ab8500) {
 		chip_id = ab8500->chip_id;
-		if((is_ab8505(ab8500) || is_ab9540(ab8500)) && ab8500->version != 0xFF)
+		if ((is_ab8505(ab8500) || is_ab9540(ab8500)
+			|| is_ab8540(ab8500)) && ab8500->version != 0xFF)
 			chip_id = (ab8500->version << 8) | chip_id;
 	}
 	return sprintf(buf, "%#x\n", chip_id);
@@ -1597,7 +1598,7 @@ static int ab8500_probe(struct platform_device *pdev)
 
 	/*  Activate this feature only in ab9540 */
 	/*  till tests are done on ab8500 1p2 or later*/
-	if (is_ab9540(ab8500)) {
+	if (is_ab9540(ab8500) || is_ab8540(ab8500))
 		ret = devm_request_threaded_irq(&pdev->dev, ab8500->irq, NULL,
 						ab8500_hierarchical_irq,
 						IRQF_ONESHOT | IRQF_NO_SUSPEND,
@@ -1640,7 +1641,8 @@ static int ab8500_probe(struct platform_device *pdev)
 			dev_err(ab8500->dev, "error adding bm devices\n");
 	}
 
-	if (is_ab9540(ab8500))
+	if (((is_ab8505(ab8500) || is_ab9540(ab8500)) &&
+			ab8500->chip_id >= AB8500_CUT2P0) || is_ab8540(ab8500))
 		ret = sysfs_create_group(&ab8500->dev->kobj,
 					&ab9540_attr_group);
 	else
@@ -1656,7 +1658,8 @@ static int ab8500_remove(struct platform_device *pdev)
 {
 	struct ab8500 *ab8500 = platform_get_drvdata(pdev);
 
-	if (is_ab9540(ab8500))
+	if (((is_ab8505(ab8500) || is_ab9540(ab8500)) &&
+			ab8500->chip_id >= AB8500_CUT2P0) || is_ab8540(ab8500))
 		sysfs_remove_group(&ab8500->dev->kobj, &ab9540_attr_group);
 	else
 		sysfs_remove_group(&ab8500->dev->kobj, &ab8500_attr_group);
diff --git a/drivers/mfd/ab8500-debugfs.c b/drivers/mfd/ab8500-debugfs.c
index 51b0e97..3eeab01 100644
--- a/drivers/mfd/ab8500-debugfs.c
+++ b/drivers/mfd/ab8500-debugfs.c
@@ -1942,6 +1942,8 @@ static int ab8500_debug_probe(struct platform_device *plf)
 		num_interrupt_lines = AB8505_NR_IRQS;
 	else if (is_ab9540(ab8500))
 		num_interrupt_lines = AB9540_NR_IRQS;
+	else if (is_ab8540(ab8500))
+		num_interrupt_lines = AB8540_NR_IRQS;
 
 	file = debugfs_create_file("interrupts", (S_IRUGO),
 	    ab8500_dir, &plf->dev, &ab8500_interrupts_fops);
-- 
1.7.10.4

