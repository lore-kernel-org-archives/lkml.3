Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753946AbaEBQSx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 May 2014 12:18:53 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:43830 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752596AbaEBPl6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 May 2014 11:41:58 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Krzysztof Kozlowski <k.kozlowski@samsung.com>,
        Lee Jones <lee.jones@linaro.org>, Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13 072/151] mfd: 88pm860x: Fix I2C device resource leak on regmap init fail
Date: Fri,  2 May 2014 08:37:40 -0700
Message-Id: <1399045139-4531-73-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1399045139-4531-1-git-send-email-kamal@canonical.com>
References: <1399045139-4531-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11.1 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Krzysztof Kozlowski <k.kozlowski@samsung.com>

commit a7ab1c8b261305af583ce26bb4a14f555fdaa73e upstream.

During probe the driver allocates dummy I2C device for companion chip
and then allocates a regmap for it. If regmap_init_i2c() fails then the
I2C driver (allocated with i2c_new_dummy()) is not freed and this
resource leaks.

Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
Signed-off-by: Lee Jones <lee.jones@linaro.org>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/mfd/88pm860x-core.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/mfd/88pm860x-core.c b/drivers/mfd/88pm860x-core.c
index c9b1f64..2461014 100644
--- a/drivers/mfd/88pm860x-core.c
+++ b/drivers/mfd/88pm860x-core.c
@@ -1185,6 +1185,7 @@ static int pm860x_probe(struct i2c_client *client,
 			ret = PTR_ERR(chip->regmap_companion);
 			dev_err(&chip->companion->dev,
 				"Failed to allocate register map: %d\n", ret);
+			i2c_unregister_device(chip->companion);
 			return ret;
 		}
 		i2c_set_clientdata(chip->companion, chip);
-- 
1.9.1

