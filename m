Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758594Ab3EWLL2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 May 2013 07:11:28 -0400
Received: from na3sys009aog110.obsmtp.com ([74.125.149.203]:56535 "EHLO
	na3sys009aog110.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758424Ab3EWLLZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 May 2013 07:11:25 -0400
From: <yizhang.mrvl@gmail.com>
To: <sameo@linux.intel.com>, <gregkh@linuxfoundation.org>,
        <yizhang.mrvl@gmail.com>
CC: <cxie4@marvell.com>, <arnd@arndb.de>, <yizhang@marvell.com>,
        <linux-kernel@vger.kernel.org>, <jtzhou@marvell.com>
Subject: [PATCH 1/4] mfd: 88pm800: fix NULL pointer error
Date: Thu, 23 May 2013 19:10:44 +0800
Message-ID: <1369307447-17874-2-git-send-email-yizhang.mrvl@gmail.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1369307447-17874-1-git-send-email-yizhang.mrvl@gmail.com>
References: <1369307447-17874-1-git-send-email-yizhang.mrvl@gmail.com>
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
---
 drivers/mfd/88pm800.c |   16 ++++++++--------
 1 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/drivers/mfd/88pm800.c b/drivers/mfd/88pm800.c
index 582bda5..bbb6aa8 100644
--- a/drivers/mfd/88pm800.c
+++ b/drivers/mfd/88pm800.c
@@ -528,25 +528,25 @@ static int pm800_probe(struct i2c_client *client,
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
+		goto err_subchip_alloc;
+	}
+
 	if (pdata->plat_config)
 		pdata->plat_config(chip, pdata);
 
-err_page_init:
+err_subchip_alloc:
 	mfd_remove_devices(chip->dev);
 	device_irq_exit_800(chip);
-err_subchip_alloc:
+err_page_init:
 	pm80x_deinit();
 out_init:
 	return ret;
-- 
1.7.0.4

