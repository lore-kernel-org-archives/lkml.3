Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756157Ab3EVMKU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 May 2013 08:10:20 -0400
Received: from na3sys009aog135.obsmtp.com ([74.125.149.84]:32845 "EHLO
	na3sys009aog135.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756027Ab3EVMKQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 May 2013 08:10:16 -0400
From: <yizhang.mrvl@gmail.com>
To: <sameo@linux.intel.com>, <gregkh@linuxfoundation.org>,
        <yizhang.mrvl@gmail.com>
CC: <cxie4@marvell.com>, <arnd@arndb.de>, <yizhang@marvell.com>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH 1/4] mfd: 88pm800: fix NULL pointer error
Date: Wed, 22 May 2013 20:07:06 +0800
Message-ID: <1369224429-27077-2-git-send-email-yizhang.mrvl@gmail.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1369224429-27077-1-git-send-email-yizhang.mrvl@gmail.com>
References: <1369224429-27077-1-git-send-email-yizhang.mrvl@gmail.com>
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

