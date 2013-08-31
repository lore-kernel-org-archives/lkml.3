Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757208Ab3HaGqK (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 Aug 2013 02:46:10 -0400
Received: from szxga02-in.huawei.com ([119.145.14.65]:34376 "EHLO
	szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754512Ab3HaGqI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 Aug 2013 02:46:08 -0400
Message-ID: <522190E9.9000007@huawei.com>
Date: Sat, 31 Aug 2013 14:44:57 +0800
From: Libo Chen <clbchenlibo.chen@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:17.0) Gecko/20130801 Thunderbird/17.0.8
MIME-Version: 1.0
To: <dmitry.torokhov@gmail.com>
CC: <peter.ujfalusi@ti.com>, Bill Pemberton <wfp5p@virginia.edu>,
        <broonie@opensource.wolfsonmicro.com>, <linux-input@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, Li Zefan <lizefan@huawei.com>,
        "zhangwei(Jovi)" <jovi.zhangwei@huawei.com>
Subject: [PATCH 1/3] driver: input: 88pm860x-ts: fix missing of_node_put
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.135.72.158]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


decrease np device_node refcount after task completion

Signed-off-by: Libo Chen <libo.chen@huawei.com>
---
 drivers/input/touchscreen/88pm860x-ts.c |   22 +++++++++++++++-------
 1 files changed, 15 insertions(+), 7 deletions(-)

diff --git a/drivers/input/touchscreen/88pm860x-ts.c b/drivers/input/touchscreen/88pm860x-ts.c
index f7de14a..4a2fd46 100644
--- a/drivers/input/touchscreen/88pm860x-ts.c
+++ b/drivers/input/touchscreen/88pm860x-ts.c
@@ -142,14 +142,18 @@ static int pm860x_touch_dt_init(struct platform_device *pdev,
 		data |= (n << 7) & PM8607_GPADC_SW_CAL_MASK;
 	if (data) {
 		ret = pm860x_reg_write(i2c, PM8607_GPADC_MISC1, data);
-		if (ret < 0)
-			return -EINVAL;
+		if (ret < 0) {
+			ret = -EINVAL;
+			goto err;
+		}
 	}
 	/* set tsi prebias time */
 	if (!of_property_read_u32(np, "marvell,88pm860x-tsi-prebias", &data)) {
 		ret = pm860x_reg_write(i2c, PM8607_TSI_PREBIAS, data);
-		if (ret < 0)
-			return -EINVAL;
+		if (ret < 0) {
+			ret = -EINVAL;
+			goto err;
+		}
 	}
 	/* set prebias & prechg time of pen detect */
 	data = 0;
@@ -159,11 +163,15 @@ static int pm860x_touch_dt_init(struct platform_device *pdev,
 		data |= n & PM8607_PD_PRECHG_MASK;
 	if (data) {
 		ret = pm860x_reg_write(i2c, PM8607_PD_PREBIAS, data);
-		if (ret < 0)
-			return -EINVAL;
+		if (ret < 0) {
+			ret = -EINVAL;
+			goto err;
+		}
 	}
 	of_property_read_u32(np, "marvell,88pm860x-resistor-X", res_x);
-	return 0;
+err:
+	of_node_put(np);
+	return ret;
 }
 #else
 #define pm860x_touch_dt_init(x, y, z)	(-1)
-- 
1.7.1

