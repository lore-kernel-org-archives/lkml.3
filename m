Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755665AbaDXKnE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2014 06:43:04 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:46594 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754024AbaDXIxm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2014 04:53:42 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Krzysztof Kozlowski <k.kozlowski@samsung.com>,
        Lee Jones <lee.jones@linaro.org>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 074/182] mfd: 88pm860x: Fix possible NULL pointer dereference on i2c_new_dummy error
Date: Thu, 24 Apr 2014 09:49:59 +0100
Message-Id: <1398329507-5911-75-git-send-email-luis.henriques@canonical.com>
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

commit 159ce52a6b777fc82fa0b51c7440e25f9e4c6feb upstream.

During probe the driver allocates dummy I2C device for companion chip
with i2c_new_dummy() but it does not check the return value of this call.

In case of error (i2c_new_device(): memory allocation failure or I2C
address cannot be used) this function returns NULL which is later used
by regmap_init_i2c().

If i2c_new_dummy() fails for companion device, fail also the probe for
main MFD driver.

Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
Signed-off-by: Lee Jones <lee.jones@linaro.org>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/mfd/88pm860x-core.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/mfd/88pm860x-core.c b/drivers/mfd/88pm860x-core.c
index ec94081..df63945 100644
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
1.9.1

