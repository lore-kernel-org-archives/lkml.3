Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754007AbaDXIxj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2014 04:53:39 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:46573 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753011AbaDXIxg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2014 04:53:36 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Krzysztof Kozlowski <k.kozlowski@samsung.com>,
        Lee Jones <lee.jones@linaro.org>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 070/182] mfd: max77686: Fix possible NULL pointer dereference on i2c_new_dummy error
Date: Thu, 24 Apr 2014 09:49:55 +0100
Message-Id: <1398329507-5911-71-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1398329507-5911-1-git-send-email-luis.henriques@canonical.com>
References: <1398329507-5911-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.9 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Krzysztof Kozlowski <k.kozlowski@samsung.com>

commit b9e183a1d495cd65412abe0f9df19b151716bfe7 upstream.

During probe the driver allocates dummy I2C device for RTC with
i2c_new_dummy() but it does not check the return value of this call.

In case of error (i2c_new_device(): memory allocation failure or I2C
address cannot be used) this function returns NULL which is later used
by i2c_unregister_device().

If i2c_new_dummy() fails for RTC device, fail also the probe for main
MFD driver.

Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
Signed-off-by: Lee Jones <lee.jones@linaro.org>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/mfd/max77686.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/mfd/max77686.c b/drivers/mfd/max77686.c
index 541b240..f50e03f 100644
--- a/drivers/mfd/max77686.c
+++ b/drivers/mfd/max77686.c
@@ -120,6 +120,10 @@ static int max77686_i2c_probe(struct i2c_client *i2c,
 		dev_info(max77686->dev, "device found\n");
 
 	max77686->rtc = i2c_new_dummy(i2c->adapter, I2C_ADDR_RTC);
+	if (!max77686->rtc) {
+		dev_err(max77686->dev, "Failed to allocate I2C device for RTC\n");
+		return -ENODEV;
+	}
 	i2c_set_clientdata(max77686->rtc, max77686);
 
 	max77686_irq_init(max77686);
-- 
1.9.1

