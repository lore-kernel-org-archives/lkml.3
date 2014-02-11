Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751943AbaBKKF4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Feb 2014 05:05:56 -0500
Received: from mailout3.w1.samsung.com ([210.118.77.13]:20624 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751186AbaBKKDy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Feb 2014 05:03:54 -0500
X-AuditID: cbfec7f4-b7f796d000005a13-f0-52f9f5885a0a
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
To: Sangbeom Kim <sbkim73@samsung.com>, Samuel Ortiz <sameo@linux.intel.com>,
        Lee Jones <lee.jones@linaro.org>, linux-kernel@vger.kernel.org,
        linux-samsung-soc@vger.kernel.org
Cc: Kyungmin Park <kyungmin.park@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Krzysztof Kozlowski <k.kozlowski@samsung.com>, stable@vger.kernel.org
Subject: [PATCH 4/7] mfd: max77693: Fix possible NULL pointer dereference on
 i2c_new_dummy error
Date: Tue, 11 Feb 2014 11:03:32 +0100
Message-id: <1392113015-11180-4-git-send-email-k.kozlowski@samsung.com>
X-Mailer: git-send-email 1.7.9.5
In-reply-to: <1392113015-11180-1-git-send-email-k.kozlowski@samsung.com>
References: <1392113015-11180-1-git-send-email-k.kozlowski@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrDJMWRmVeSWpSXmKPExsVy+t/xK7odX38GGSx4JmmxccZ6VovXLwwt
	zja9Ybe4//Uoo8XlXXPYLGac38dksfbIXXaL092sFhdXfGGyWLDxEaMDl8eda3vYPOadDPTo
	27KK0ePzJrkAligum5TUnMyy1CJ9uwSujGlrZ7AWnOKteLPyJnsD40buLkZODgkBE4n+N3OY
	IWwxiQv31rOB2EICSxklJiwL72LkArL7mCTertnJCJJgEzCW2Lx8CRtIQkRgM6PE4u9XWUEc
	ZoG7jBLNd98DVXFwCAskSay4ogDSwCKgKvHxUQ8LiM0r4C7x6NNXVpASCQEFiTmTbEDCnAIe
	Eis+nGGGWOwu0dp/l3UCI+8CRoZVjKKppckFxUnpuYZ6xYm5xaV56XrJ+bmbGCEh9mUH4+Jj
	VocYBTgYlXh4Nyj+DBJiTSwrrsw9xCjBwawkwqt0HCjEm5JYWZValB9fVJqTWnyIkYmDU6qB
	Mflx2HSjFasfhrUdXV486dOMia115yWFK2w/lH3a0dEaFfA2MnbOzffZil6u9g2nZZYXsH/O
	uVHSYuvT9vYmd01a8tvjnF3tMSyNM+bETFQw3V3f8U7K6bm66sPvZV9m/f2/jmnupC3f32hu
	Sm4o3cZyd2ncdZdPP3zu9x40Ntf0ynEp7jU4qsRSnJFoqMVcVJwIAPLcCpIPAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

During probe the driver allocates dummy I2C devices for MUIC and haptic
with i2c_new_dummy() but it does not check the return value of this
calls.

In case of error (i2c_new_device(): memory allocation failure or I2C
address cannot be used) this function returns NULL which is later used
by devm_regmap_init_i2c() and i2c_unregister_device().

If i2c_new_dummy() fails for MUIC or haptic devices, fail also the probe
for main MFD driver.

Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
Cc: stable@vger.kernel.org
---
 drivers/mfd/max77693.c |   12 +++++++++++-
 1 file changed, 11 insertions(+), 1 deletion(-)

diff --git a/drivers/mfd/max77693.c b/drivers/mfd/max77693.c
index e0859987ab6b..c5535f018466 100644
--- a/drivers/mfd/max77693.c
+++ b/drivers/mfd/max77693.c
@@ -148,9 +148,18 @@ static int max77693_i2c_probe(struct i2c_client *i2c,
 		dev_info(max77693->dev, "device ID: 0x%x\n", reg_data);
 
 	max77693->muic = i2c_new_dummy(i2c->adapter, I2C_ADDR_MUIC);
+	if (!max77693->muic) {
+		dev_err(max77693->dev, "Failed to allocate I2C device for MUIC\n");
+		return -ENODEV;
+	}
 	i2c_set_clientdata(max77693->muic, max77693);
 
 	max77693->haptic = i2c_new_dummy(i2c->adapter, I2C_ADDR_HAPTIC);
+	if (!max77693->haptic) {
+		dev_err(max77693->dev, "Failed to allocate I2C device for Haptic\n");
+		ret = -ENODEV;
+		goto err_i2c_haptic;
+	}
 	i2c_set_clientdata(max77693->haptic, max77693);
 
 	/*
@@ -184,8 +193,9 @@ err_mfd:
 	max77693_irq_exit(max77693);
 err_irq:
 err_regmap_muic:
-	i2c_unregister_device(max77693->muic);
 	i2c_unregister_device(max77693->haptic);
+err_i2c_haptic:
+	i2c_unregister_device(max77693->muic);
 	return ret;
 }
 
-- 
1.7.9.5

