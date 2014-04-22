Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758092AbaDVUx2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2014 16:53:28 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:36509 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757975AbaDVUXG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2014 16:23:06 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Krzysztof Kozlowski <k.kozlowski@samsung.com>,
        Lee Jones <lee.jones@linaro.org>, Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.8 074/133] mfd: sec-core: Fix possible NULL pointer dereference when i2c_new_dummy error
Date: Tue, 22 Apr 2014 13:13:32 -0700
Message-Id: <1398197671-12786-75-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1398197671-12786-1-git-send-email-kamal@canonical.com>
References: <1398197671-12786-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.22 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Krzysztof Kozlowski <k.kozlowski@samsung.com>

commit 65aba1e04916d72b30c028730a1e31860c225412 upstream.

During probe the sec-core driver allocates dummy I2C device for RTC with
i2c_new_dummy() but return value is not checked. In case of error
(i2c_new_device(): memory allocation failure or I2C address cannot be
used) this function returns NULL which is later used by
devm_regmap_init_i2c() or i2c_unregister_device().

If i2c_new_dummy() fails for RTC device, fail also the probe for main
MFD driver.

Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
Signed-off-by: Lee Jones <lee.jones@linaro.org>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/mfd/sec-core.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/mfd/sec-core.c b/drivers/mfd/sec-core.c
index 49d361a..fe4038f 100644
--- a/drivers/mfd/sec-core.c
+++ b/drivers/mfd/sec-core.c
@@ -129,6 +129,10 @@ static int sec_pmic_probe(struct i2c_client *i2c,
 	}
 
 	sec_pmic->rtc = i2c_new_dummy(i2c->adapter, RTC_I2C_ADDR);
+	if (!sec_pmic->rtc) {
+		dev_err(&i2c->dev, "Failed to allocate I2C for RTC\n");
+		return -ENODEV;
+	}
 	i2c_set_clientdata(sec_pmic->rtc, sec_pmic);
 
 	if (pdata && pdata->cfg_pmic_irq)
-- 
1.9.1

