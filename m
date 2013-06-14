Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751723Ab3FNFXh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Jun 2013 01:23:37 -0400
Received: from na3sys009aog126.obsmtp.com ([74.125.149.155]:38383 "EHLO
	na3sys009aog126.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751692Ab3FNFXf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Jun 2013 01:23:35 -0400
From: Chao Xie <chao.xie@marvell.com>
To: <linux-kernel@vger.kernel.org>, <sameo@linux.intel.com>,
        <yizhang@marvell.com>
CC: Chao Xie <chao.xie@marvell.com>
Subject: [PATCH V2 9/9] mfd: 88pm800: add regulator sub device
Date: Fri, 14 Jun 2013 01:21:53 -0400
Message-ID: <1371187313-5776-10-git-send-email-chao.xie@marvell.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1371187313-5776-1-git-send-email-chao.xie@marvell.com>
References: <1371187313-5776-1-git-send-email-chao.xie@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Chao Xie <chao.xie@marvell.com>
---
 drivers/mfd/88pm800.c       |   28 ++++++++++++++++++++++++++++
 include/linux/mfd/88pm80x.h |    8 ++++++++
 2 files changed, 36 insertions(+), 0 deletions(-)

diff --git a/drivers/mfd/88pm800.c b/drivers/mfd/88pm800.c
index 35c7fe8..ec9d815 100644
--- a/drivers/mfd/88pm800.c
+++ b/drivers/mfd/88pm800.c
@@ -156,6 +156,13 @@ static struct mfd_cell onkey_devs[] = {
 	 },
 };
 
+static struct mfd_cell regulator_devs[] = {
+	{
+	 .name = "88pm80x-regulator",
+	 .id = -1,
+	},
+};
+
 static const struct regmap_irq pm800_irqs[] = {
 	/* INT0 */
 	[PM800_IRQ_ONKEY] = {
@@ -338,6 +345,21 @@ static int device_rtc_init(struct pm80x_chip *chip,
 	return 0;
 }
 
+static int device_regulator_init(struct pm80x_chip *chip,
+					   struct pm80x_platform_data *pdata)
+{
+	int ret;
+
+	ret = mfd_add_devices(chip->dev, 0, &regulator_devs[0],
+			      ARRAY_SIZE(regulator_devs), NULL, 0, NULL);
+	if (ret) {
+		dev_err(chip->dev, "Failed to add regulator subdev\n");
+		return ret;
+	}
+
+	return 0;
+}
+
 static int device_irq_init_800(struct pm80x_chip *chip)
 {
 	struct regmap *map = chip->regmap;
@@ -499,6 +521,12 @@ static int device_800_init(struct pm80x_chip *chip,
 		goto out;
 	}
 
+	ret = device_regulator_init(chip, pdata);
+	if (ret) {
+		dev_err(chip->dev, "Failed to add regulators subdev\n");
+		goto out;
+	}
+
 	return 0;
 out_dev:
 	mfd_remove_devices(chip->dev);
diff --git a/include/linux/mfd/88pm80x.h b/include/linux/mfd/88pm80x.h
index 4a66a56..97cb283 100644
--- a/include/linux/mfd/88pm80x.h
+++ b/include/linux/mfd/88pm80x.h
@@ -307,6 +307,14 @@ struct pm80x_chip {
 
 struct pm80x_platform_data {
 	struct pm80x_rtc_pdata *rtc;
+	/*
+	 * For the regulator not defined, set regulators[not_defined] to be
+	 * NULL. num_regulators are the number of regulators supposed to be
+	 * initialized. If all regulators are not defined, set num_regulators
+	 * to be 0.
+	 */
+	struct regulator_init_data *regulators[PM800_ID_RG_MAX];
+	unsigned int num_regulators;
 	int irq_mode;		/* Clear interrupt by read/write(0/1) */
 	int batt_det;		/* enable/disable */
 	int (*plat_config)(struct pm80x_chip *chip,
-- 
1.7.4.1

