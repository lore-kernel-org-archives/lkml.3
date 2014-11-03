Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751914AbaKCIes (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Nov 2014 03:34:48 -0500
Received: from mail-pa0-f44.google.com ([209.85.220.44]:35256 "EHLO
	mail-pa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751264AbaKCIeo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Nov 2014 03:34:44 -0500
From: Dudley Du <dudley.dulixin@gmail.com>
X-Google-Original-From: Dudley Du <dudl@cypress.com>
To: dmitry.torokhov@gmail.com, rydberg@euromail.se
Cc: Dudley Du <dudl@cypress.com>, bleung@google.com,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v9 01/18] input: cyapa: add device resource management infrastructure support
Date: Mon,  3 Nov 2014 16:32:53 +0800
Message-Id: <1415003590-30485-2-git-send-email-dudl@cypress.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1415003590-30485-1-git-send-email-dudl@cypress.com>
References: <1415003590-30485-1-git-send-email-dudl@cypress.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Modify cyapa driver to support device resource management infrastructure
to reduce the mistakes of resource management.
TEST=test on Chromebooks.

Signed-off-by: Dudley Du <dudl@cypress.com>
---
 drivers/input/mouse/cyapa.c | 48 ++++++++++++++++++---------------------------
 1 file changed, 19 insertions(+), 29 deletions(-)

diff --git a/drivers/input/mouse/cyapa.c b/drivers/input/mouse/cyapa.c
index b409c3d..b3d7a2a 100644
--- a/drivers/input/mouse/cyapa.c
+++ b/drivers/input/mouse/cyapa.c
@@ -409,11 +409,11 @@ static ssize_t cyapa_read_block(struct cyapa *cyapa, u8 cmd_idx, u8 *values)
 		cmd = cyapa_smbus_cmds[cmd_idx].cmd;
 		len = cyapa_smbus_cmds[cmd_idx].len;
 		return cyapa_smbus_read_block(cyapa, cmd, len, values);
-	} else {
-		cmd = cyapa_i2c_cmds[cmd_idx].cmd;
-		len = cyapa_i2c_cmds[cmd_idx].len;
-		return cyapa_i2c_reg_read_block(cyapa, cmd, len, values);
 	}
+
+	cmd = cyapa_i2c_cmds[cmd_idx].cmd;
+	len = cyapa_i2c_cmds[cmd_idx].len;
+	return cyapa_i2c_reg_read_block(cyapa, cmd, len, values);
 }
 
 /*
@@ -762,7 +762,7 @@ static int cyapa_create_input_dev(struct cyapa *cyapa)
 	if (!cyapa->physical_size_x || !cyapa->physical_size_y)
 		return -EINVAL;
 
-	input = cyapa->input = input_allocate_device();
+	input = cyapa->input = devm_input_allocate_device(dev);
 	if (!input) {
 		dev_err(dev, "allocate memory for input device failed\n");
 		return -ENOMEM;
@@ -837,11 +837,9 @@ static int cyapa_probe(struct i2c_client *client,
 		return -EIO;
 	}
 
-	cyapa = kzalloc(sizeof(struct cyapa), GFP_KERNEL);
-	if (!cyapa) {
-		dev_err(dev, "allocate memory for cyapa failed\n");
+	cyapa = devm_kzalloc(dev, sizeof(struct cyapa), GFP_KERNEL);
+	if (!cyapa)
 		return -ENOMEM;
-	}
 
 	cyapa->gen = CYAPA_GEN3;
 	cyapa->client = client;
@@ -856,51 +854,43 @@ static int cyapa_probe(struct i2c_client *client,
 	ret = cyapa_check_is_operational(cyapa);
 	if (ret) {
 		dev_err(dev, "device not operational, %d\n", ret);
-		goto err_mem_free;
+		return ret;
 	}
 
 	ret = cyapa_create_input_dev(cyapa);
 	if (ret) {
 		dev_err(dev, "create input_dev instance failed, %d\n", ret);
-		goto err_mem_free;
+		return ret;
 	}
 
 	ret = cyapa_set_power_mode(cyapa, PWR_MODE_FULL_ACTIVE);
 	if (ret) {
 		dev_err(dev, "set active power failed, %d\n", ret);
-		goto err_unregister_device;
+		return ret;
 	}
 
 	cyapa->irq = client->irq;
-	ret = request_threaded_irq(cyapa->irq,
-				   NULL,
-				   cyapa_irq,
-				   IRQF_TRIGGER_FALLING | IRQF_ONESHOT,
-				   "cyapa",
-				   cyapa);
+	ret = devm_request_threaded_irq(dev,
+					cyapa->irq,
+					NULL,
+					cyapa_irq,
+					IRQF_TRIGGER_FALLING | IRQF_ONESHOT,
+					"cyapa",
+					cyapa);
 	if (ret) {
 		dev_err(dev, "IRQ request failed: %d\n, ", ret);
-		goto err_unregister_device;
+		return ret;
 	}
 
 	return 0;
-
-err_unregister_device:
-	input_unregister_device(cyapa->input);
-err_mem_free:
-	kfree(cyapa);
-
-	return ret;
 }
 
 static int cyapa_remove(struct i2c_client *client)
 {
 	struct cyapa *cyapa = i2c_get_clientdata(client);
 
-	free_irq(cyapa->irq, cyapa);
-	input_unregister_device(cyapa->input);
+	disable_irq(cyapa->irq);
 	cyapa_set_power_mode(cyapa, PWR_MODE_OFF);
-	kfree(cyapa);
 
 	return 0;
 }
-- 
1.9.1

