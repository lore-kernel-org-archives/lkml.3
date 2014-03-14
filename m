Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756188AbaCNVEW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Mar 2014 17:04:22 -0400
Received: from mail.ispras.ru ([83.149.199.45]:50552 "EHLO mail.ispras.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756016AbaCNVER (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Mar 2014 17:04:17 -0400
From: Alexey Khoroshilov <khoroshilov@ispras.ru>
To: Mauro Carvalho Chehab <m.chehab@samsung.com>
Cc: Alexey Khoroshilov <khoroshilov@ispras.ru>,
        Hans Verkuil <hans.verkuil@cisco.com>, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org, ldv-project@linuxtesting.org
Subject: [PATCH] [media] adv7180: free an interrupt on failure paths in init_device()
Date: Sat, 15 Mar 2014 01:04:03 +0400
Message-Id: <1394831043-21425-1-git-send-email-khoroshilov@ispras.ru>
X-Mailer: git-send-email 1.8.3.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There is request_irq() in init_device(), but the interrupt is not removed
on failure paths. The patch adds proper error handling.

Found by Linux Driver Verification project (linuxtesting.org).

Signed-off-by: Alexey Khoroshilov <khoroshilov@ispras.ru>
---
 drivers/media/i2c/adv7180.c | 18 +++++++++++-------
 1 file changed, 11 insertions(+), 7 deletions(-)

diff --git a/drivers/media/i2c/adv7180.c b/drivers/media/i2c/adv7180.c
index d7d99f1c69e4..e462392ba043 100644
--- a/drivers/media/i2c/adv7180.c
+++ b/drivers/media/i2c/adv7180.c
@@ -541,40 +541,44 @@ static int init_device(struct i2c_client *client, struct adv7180_state *state)
 		ret = i2c_smbus_write_byte_data(client, ADV7180_ADI_CTRL_REG,
 						ADV7180_ADI_CTRL_IRQ_SPACE);
 		if (ret < 0)
-			return ret;
+			goto err;
 
 		/* config the Interrupt pin to be active low */
 		ret = i2c_smbus_write_byte_data(client, ADV7180_ICONF1_ADI,
 						ADV7180_ICONF1_ACTIVE_LOW |
 						ADV7180_ICONF1_PSYNC_ONLY);
 		if (ret < 0)
-			return ret;
+			goto err;
 
 		ret = i2c_smbus_write_byte_data(client, ADV7180_IMR1_ADI, 0);
 		if (ret < 0)
-			return ret;
+			goto err;
 
 		ret = i2c_smbus_write_byte_data(client, ADV7180_IMR2_ADI, 0);
 		if (ret < 0)
-			return ret;
+			goto err;
 
 		/* enable AD change interrupts interrupts */
 		ret = i2c_smbus_write_byte_data(client, ADV7180_IMR3_ADI,
 						ADV7180_IRQ3_AD_CHANGE);
 		if (ret < 0)
-			return ret;
+			goto err;
 
 		ret = i2c_smbus_write_byte_data(client, ADV7180_IMR4_ADI, 0);
 		if (ret < 0)
-			return ret;
+			goto err;
 
 		ret = i2c_smbus_write_byte_data(client, ADV7180_ADI_CTRL_REG,
 						0);
 		if (ret < 0)
-			return ret;
+			goto err;
 	}
 
 	return 0;
+
+err:
+	free_irq(state->irq, state);
+	return ret;
 }
 
 static int adv7180_probe(struct i2c_client *client,
-- 
1.8.3.2

