Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933252AbaEMKJg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2014 06:09:36 -0400
Received: from ip4-83-240-18-248.cust.nbox.cz ([83.240.18.248]:60791 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760052AbaEMJ2z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2014 05:28:55 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
        Krzysztof Kozlowski <k.kozlowski@samsung.com>,
        Lee Jones <lee.jones@linaro.org>, Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 035/182] mfd: 88pm860x: Fix possible NULL pointer dereference on i2c_new_dummy error
Date: Tue, 13 May 2014 11:26:27 +0200
Message-Id: <96c8fcdbcc88827681b2c3af5cf16dd6b36f8114.1399973152.git.jslaby@suse.cz>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <7aa1bde8f6143b2db33e6567a8c3a4debaa246f4.1399973152.git.jslaby@suse.cz>
References: <7aa1bde8f6143b2db33e6567a8c3a4debaa246f4.1399973152.git.jslaby@suse.cz>
In-Reply-To: <cover.1399973152.git.jslaby@suse.cz>
References: <cover.1399973152.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Krzysztof Kozlowski <k.kozlowski@samsung.com>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

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
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 drivers/mfd/88pm860x-core.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/mfd/88pm860x-core.c b/drivers/mfd/88pm860x-core.c
index 7ebe9ef1eba6..675f96b37643 100644
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
1.9.3

