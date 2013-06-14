Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751936Ab3FNFYI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Jun 2013 01:24:08 -0400
Received: from na3sys009aog133.obsmtp.com ([74.125.149.82]:59024 "EHLO
	na3sys009aog133.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751660Ab3FNFYD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Jun 2013 01:24:03 -0400
From: Chao Xie <chao.xie@marvell.com>
To: <linux-kernel@vger.kernel.org>, <sameo@linux.intel.com>,
        <yizhang@marvell.com>
CC: Chao Xie <chao.xie@marvell.com>
Subject: [PATCH V2 1/9] mfd: 88pm800: fix NULL pointer error
Date: Fri, 14 Jun 2013 01:21:45 -0400
Message-ID: <1371187313-5776-2-git-send-email-chao.xie@marvell.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1371187313-5776-1-git-send-email-chao.xie@marvell.com>
References: <1371187313-5776-1-git-send-email-chao.xie@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Yi Zhang <yizhang@marvell.com>

move "device_800_init" to fix NULL pointer error when
calling "device_gpadc_init"

for "device_gpadc_init" needs "subchip->regmap_gpadc"
to set registers via regmap interface

Signed-off-by: Yi Zhang <yizhang@marvell.com>
Signed-off-by: Chao Xie <chao.xie@marvell.com>
---
 drivers/mfd/88pm800.c |   18 ++++++++++--------
 1 files changed, 10 insertions(+), 8 deletions(-)

diff --git a/drivers/mfd/88pm800.c b/drivers/mfd/88pm800.c
index 582bda5..b2f9f0f 100644
--- a/drivers/mfd/88pm800.c
+++ b/drivers/mfd/88pm800.c
@@ -528,24 +528,26 @@ static int pm800_probe(struct i2c_client *client,
 	subchip->gpadc_page_addr = pdata->gpadc_page_addr;
 	chip->subchip = subchip;
 
-	ret = device_800_init(chip, pdata);
-	if (ret) {
-		dev_err(chip->dev, "%s id 0x%x failed!\n", __func__, chip->id);
-		goto err_subchip_alloc;
-	}
-
 	ret = pm800_pages_init(chip);
 	if (ret) {
 		dev_err(&client->dev, "pm800_pages_init failed!\n");
 		goto err_page_init;
 	}
 
+	ret = device_800_init(chip, pdata);
+	if (ret) {
+		dev_err(chip->dev, "%s id 0x%x failed!\n", __func__, chip->id);
+		goto err_device_init;
+	}
+
 	if (pdata->plat_config)
 		pdata->plat_config(chip, pdata);
 
+	return 0;
+
+err_device_init:
+	pm800_pages_exit(chip);
 err_page_init:
-	mfd_remove_devices(chip->dev);
-	device_irq_exit_800(chip);
 err_subchip_alloc:
 	pm80x_deinit();
 out_init:
-- 
1.7.4.1

