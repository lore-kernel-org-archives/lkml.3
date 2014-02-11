Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751518AbaBKKD6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Feb 2014 05:03:58 -0500
Received: from mailout3.w1.samsung.com ([210.118.77.13]:20624 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750803AbaBKKDx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Feb 2014 05:03:53 -0500
X-AuditID: cbfec7f4-b7f796d000005a13-e7-52f9f586aa05
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
To: Sangbeom Kim <sbkim73@samsung.com>, Samuel Ortiz <sameo@linux.intel.com>,
        Lee Jones <lee.jones@linaro.org>, linux-kernel@vger.kernel.org,
        linux-samsung-soc@vger.kernel.org
Cc: Kyungmin Park <kyungmin.park@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Krzysztof Kozlowski <k.kozlowski@samsung.com>, stable@vger.kernel.org
Subject: [PATCH 1/7] mfd: 88pm860x: Fix possible NULL pointer dereference on
 i2c_new_dummy error
Date: Tue, 11 Feb 2014 11:03:29 +0100
Message-id: <1392113015-11180-1-git-send-email-k.kozlowski@samsung.com>
X-Mailer: git-send-email 1.7.9.5
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrKJMWRmVeSWpSXmKPExsVy+t/xK7ptX38GGZz4Y22xccZ6VovXLwwt
	zja9Ybe4//Uoo8XlXXPYLGac38dksfbIXXaL092sFhdXfGGyWLDxEaMDl8eda3vYPOadDPTo
	27KK0ePzJrkAligum5TUnMyy1CJ9uwSujMMvJzEXfOKsWHepmamBcQ5HFyMHh4SAicS7X1Fd
	jJxAppjEhXvr2boYuTiEBJYySqx9/pkFwuljktj65T0LSBWbgLHE5uVLwKpEBDYzSiz+fpUV
	xGEWuMso0Xz3PSNIlbBAksT6Bz/ZQWwWAVWJbS/ng9m8Au4S/25MY4ZYrSAxZ5LNBEbuBYwM
	qxhFU0uTC4qT0nMN9YoTc4tL89L1kvNzNzFCgubLDsbFx6wOMQpwMCrx8G5Q/BkkxJpYVlyZ
	e4hRgoNZSYRX6ThQiDclsbIqtSg/vqg0J7X4ECMTB6dUA6Nq0+TgP51mJZeOvhD/zHBKavOC
	jwFVla+6pzwKZ8/dO1mhflt0XfQzfvnMb46x7FsZcjf93Wcfm7zddK584qnFu0s5XlhYpqrP
	7Vze7W7sFOI56eCXuFsNxznnHxL1MlG4eVuspyyh+6Tiyr31hvV2HbUPHuY83siWOMny27Ss
	Ldlubsu62JVYijMSDbWYi4oTAetQft74AQAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

During probe the driver allocates dummy I2C device for companion chip
with i2c_new_dummy() but it does not check the return value of this call.

In case of error (i2c_new_device(): memory allocation failure or I2C
address cannot be used) this function returns NULL which is later used
by regmap_init_i2c().

If i2c_new_dummy() fails for companion device, fail also the probe for
main MFD driver.

Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
Cc: stable@vger.kernel.org
---
 drivers/mfd/88pm860x-core.c |    5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/mfd/88pm860x-core.c b/drivers/mfd/88pm860x-core.c
index c9b1f6422941..e456be9a7c67 100644
--- a/drivers/mfd/88pm860x-core.c
+++ b/drivers/mfd/88pm860x-core.c
@@ -1179,6 +1179,11 @@ static int pm860x_probe(struct i2c_client *client,
 		chip->companion_addr = pdata->companion_addr;
 		chip->companion = i2c_new_dummy(chip->client->adapter,
 						chip->companion_addr);
+		if (!chip->companion) {
+			dev_err(&client->dev,
+				"Failed to allocate I2C companion device\n");
+			return -ENODEV;
+		}
 		chip->regmap_companion = regmap_init_i2c(chip->companion,
 							&pm860x_regmap_config);
 		if (IS_ERR(chip->regmap_companion)) {
-- 
1.7.9.5

