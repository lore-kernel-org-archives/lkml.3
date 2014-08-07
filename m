Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754623AbaHGAsq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Aug 2014 20:48:46 -0400
Received: from bhuna.collabora.co.uk ([93.93.135.160]:35156 "EHLO
	bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754013AbaHGAsn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Aug 2014 20:48:43 -0400
From: Javier Martinez Canillas <javier.martinez@collabora.co.uk>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: Nick Dyer <nick.dyer@itdev.co.uk>, Stephen Warren <swarren@nvidia.com>,
        Yufeng Shen <miletus@chromium.org>, Benson Leung <bleung@chromium.org>,
        Doug Anderson <dianders@chromium.org>, Olof Johansson <olof@lixom.net>,
        linux-input@vger.kernel.org, devicetree@vger.kernel.org,
        linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org,
        Javier Martinez Canillas <javier.martinez@collabora.co.uk>
Subject: [PATCH 1/2] Input: atmel_mxt_ts - Get IRQ edge/level flags on DT booting
Date: Thu,  7 Aug 2014 02:48:05 +0200
Message-Id: <1407372486-25881-1-git-send-email-javier.martinez@collabora.co.uk>
X-Mailer: git-send-email 2.0.0.rc2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The Atmel maXTouch driver assumed that the IRQ type flags will
always be passed using platform data but this is not true when
booting using Device Trees. In these setups the interrupt type
was ignored by the driver when requesting an IRQ.

This means that it will fail if a machine specified other type
than IRQ_TYPE_NONE. The right approach is to get the IRQ flags
that was parsed by OF from the "interrupt" Device Tree propery.

Signed-off-by: Javier Martinez Canillas <javier.martinez@collabora.co.uk>
---
 drivers/input/touchscreen/atmel_mxt_ts.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/drivers/input/touchscreen/atmel_mxt_ts.c b/drivers/input/touchscreen/atmel_mxt_ts.c
index 03b8571..0fb56c9 100644
--- a/drivers/input/touchscreen/atmel_mxt_ts.c
+++ b/drivers/input/touchscreen/atmel_mxt_ts.c
@@ -22,6 +22,7 @@
 #include <linux/i2c.h>
 #include <linux/i2c/atmel_mxt_ts.h>
 #include <linux/input/mt.h>
+#include <linux/irq.h>
 #include <linux/interrupt.h>
 #include <linux/of.h>
 #include <linux/slab.h>
@@ -2130,6 +2131,7 @@ static int mxt_probe(struct i2c_client *client, const struct i2c_device_id *id)
 	struct mxt_data *data;
 	const struct mxt_platform_data *pdata;
 	int error;
+	unsigned long irqflags;
 
 	pdata = dev_get_platdata(&client->dev);
 	if (!pdata) {
@@ -2156,8 +2158,13 @@ static int mxt_probe(struct i2c_client *client, const struct i2c_device_id *id)
 	init_completion(&data->reset_completion);
 	init_completion(&data->crc_completion);
 
+	if (client->dev.of_node)
+		irqflags = irq_get_trigger_type(client->irq);
+	else
+		irqflags = pdata->irqflags;
+
 	error = request_threaded_irq(client->irq, NULL, mxt_interrupt,
-				     pdata->irqflags | IRQF_ONESHOT,
+				     irqflags | IRQF_ONESHOT,
 				     client->name, data);
 	if (error) {
 		dev_err(&client->dev, "Failed to register interrupt\n");
-- 
2.0.0.rc2

