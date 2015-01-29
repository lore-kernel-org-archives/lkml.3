Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753610AbbA2Ojx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jan 2015 09:39:53 -0500
Received: from mailout4.w1.samsung.com ([210.118.77.14]:11261 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751342AbbA2Oju (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jan 2015 09:39:50 -0500
X-AuditID: cbfec7f5-b7fc86d0000066b7-fe-54ca45a24616
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
To: Sebastian Reichel <sre@kernel.org>,
        Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>,
        David Woodhouse <dwmw2@infradead.org>, Milo Kim <milo.kim@ti.com>,
        linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Krzysztof Kozlowski <k.kozlowski@samsung.com>
Subject: [PATCH 1/2] power_supply: ab8500_fg: Simplify creation and removal of
 sysfs entries
Date: Thu, 29 Jan 2015 15:39:38 +0100
Message-id: <1422542379-8202-1-git-send-email-k.kozlowski@samsung.com>
X-Mailer: git-send-email 1.9.1
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrKJMWRmVeSWpSXmKPExsVy+t/xa7qLXE+FGGz8zGixccZ6VotJT94z
	W0xcOZnZ4vULQ4vLu+awWXzuPcJosfzXOhaL07tLHDg8ds66y+6xeYWWx6ZVnWwefVtWMXoc
	v7GdyePzJrkAtigum5TUnMyy1CJ9uwSujJUtF1gLZkpVPL3ZxNbA+Ee0i5GTQ0LARGLGrmYm
	CFtM4sK99WwgtpDAUkaJ23uCuhi5gOw+Joml/7tZQBJsAsYSm5cvYQNJiAhcZ5S48vIYWDez
	QKbEyY8TwbqFBeIktp+9yQ5iswioSty+cR2smVfATeJ/7xRmiG1yEiePTWadwMi9gJFhFaNo
	amlyQXFSeq6RXnFibnFpXrpecn7uJkZI0Hzdwbj0mNUhRgEORiUe3hmbToYIsSaWFVfmHmKU
	4GBWEuFdankqRIg3JbGyKrUoP76oNCe1+BAjEwenVAOjc6LsRXb/exrpm0Win5eXe4rUpor9
	juBzn1n2aSFDw6GzB6QP6J61210fsF269Uqj40MH9V3MSzx/V5sum6vEvuLbHO1Og71PX9cx
	GP2dEfLIOCDJxoDvqfS+hy+nZQeovbfgv+RquO7902dnVjop/tqwa7+49AyHZ/NrP93emuHi
	evHuu5WhSizFGYmGWsxFxYkAtlDRCPgBAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Simplify a little ab8500_fg_sysfs_psy_create_attrs () and
ab8500_fg_sysfs_psy_remove_attrs() functions because they received
pointer to power supply device which was then converted into power
supply instance. Then it was converted into struct ab8500_fg. The path
looked like:
	ab8500_fg->psy.dev -> psy -> ab8500_fg

Instead just pass pointer to struct ab8500_fg directly so all
conversions won't be necessary.

Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
---
 drivers/power/ab8500_fg.c | 29 +++++++++++------------------
 1 file changed, 11 insertions(+), 18 deletions(-)

diff --git a/drivers/power/ab8500_fg.c b/drivers/power/ab8500_fg.c
index c908658aa31a..94d3b10a21ff 100644
--- a/drivers/power/ab8500_fg.c
+++ b/drivers/power/ab8500_fg.c
@@ -2954,44 +2954,37 @@ static struct device_attribute ab8505_fg_sysfs_psy_attrs[] = {
 		ab8505_powercut_enable_status_read, NULL),
 };
 
-static int ab8500_fg_sysfs_psy_create_attrs(struct device *dev)
+static int ab8500_fg_sysfs_psy_create_attrs(struct ab8500_fg *di)
 {
 	unsigned int i;
-	struct power_supply *psy = dev_get_drvdata(dev);
-	struct ab8500_fg *di;
-
-	di = to_ab8500_fg_device_info(psy);
 
 	if (((is_ab8505(di->parent) || is_ab9540(di->parent)) &&
-	     abx500_get_chip_id(dev->parent) >= AB8500_CUT2P0)
+	     abx500_get_chip_id(di->dev) >= AB8500_CUT2P0)
 	    || is_ab8540(di->parent)) {
 		for (i = 0; i < ARRAY_SIZE(ab8505_fg_sysfs_psy_attrs); i++)
-			if (device_create_file(dev,
+			if (device_create_file(di->fg_psy.dev,
 					       &ab8505_fg_sysfs_psy_attrs[i]))
 				goto sysfs_psy_create_attrs_failed_ab8505;
 	}
 	return 0;
 sysfs_psy_create_attrs_failed_ab8505:
-	dev_err(dev, "Failed creating sysfs psy attrs for ab8505.\n");
+	dev_err(di->fg_psy.dev, "Failed creating sysfs psy attrs for ab8505.\n");
 	while (i--)
-		device_remove_file(dev, &ab8505_fg_sysfs_psy_attrs[i]);
+		device_remove_file(di->fg_psy.dev, &ab8505_fg_sysfs_psy_attrs[i]);
 
 	return -EIO;
 }
 
-static void ab8500_fg_sysfs_psy_remove_attrs(struct device *dev)
+static void ab8500_fg_sysfs_psy_remove_attrs(struct ab8500_fg *di)
 {
 	unsigned int i;
-	struct power_supply *psy = dev_get_drvdata(dev);
-	struct ab8500_fg *di;
-
-	di = to_ab8500_fg_device_info(psy);
 
 	if (((is_ab8505(di->parent) || is_ab9540(di->parent)) &&
-	     abx500_get_chip_id(dev->parent) >= AB8500_CUT2P0)
+	     abx500_get_chip_id(di->dev) >= AB8500_CUT2P0)
 	    || is_ab8540(di->parent)) {
 		for (i = 0; i < ARRAY_SIZE(ab8505_fg_sysfs_psy_attrs); i++)
-			(void)device_remove_file(dev, &ab8505_fg_sysfs_psy_attrs[i]);
+			(void)device_remove_file(di->fg_psy.dev,
+						 &ab8505_fg_sysfs_psy_attrs[i]);
 	}
 }
 
@@ -3056,7 +3049,7 @@ static int ab8500_fg_remove(struct platform_device *pdev)
 	ab8500_fg_sysfs_exit(di);
 
 	flush_scheduled_work();
-	ab8500_fg_sysfs_psy_remove_attrs(di->fg_psy.dev);
+	ab8500_fg_sysfs_psy_remove_attrs(di);
 	power_supply_unregister(&di->fg_psy);
 	return ret;
 }
@@ -3221,7 +3214,7 @@ static int ab8500_fg_probe(struct platform_device *pdev)
 		goto free_irq;
 	}
 
-	ret = ab8500_fg_sysfs_psy_create_attrs(di->fg_psy.dev);
+	ret = ab8500_fg_sysfs_psy_create_attrs(di);
 	if (ret) {
 		dev_err(di->dev, "failed to create FG psy\n");
 		ab8500_fg_sysfs_exit(di);
-- 
1.9.1

