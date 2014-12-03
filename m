Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752130AbaLCJb2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2014 04:31:28 -0500
Received: from mail-pd0-f174.google.com ([209.85.192.174]:52180 "EHLO
	mail-pd0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751261AbaLCJbW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2014 04:31:22 -0500
From: Dudley Du <dudley.dulixin@gmail.com>
To: dmitry.torokhov@gmail.com, rydberg@euromail.se
Cc: Dudley Du <dudley.dulixin@gmail.com>, bleung@google.com,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v12 01/19] input: cyapa: modify code to following kernel code style
Date: Wed,  3 Dec 2014 17:30:07 +0800
Message-Id: <1417599025-21681-2-git-send-email-dudley.dulixin@gmail.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1417599025-21681-1-git-send-email-dudley.dulixin@gmail.com>
References: <1417599025-21681-1-git-send-email-dudley.dulixin@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch modified the code to fix the patch check warning issue with latest
checkpatch.sh tool, and also changed the return variable name from "ret" to
"error" when there is only one error path to follow code style.
TEST=test on Chromebooks.

Signed-off-by: Dudley Du <dudley.dulixin@gmail.com>
---
 drivers/input/mouse/cyapa.c | 162 ++++++++++++++++++++++----------------------
 1 file changed, 80 insertions(+), 82 deletions(-)

diff --git a/drivers/input/mouse/cyapa.c b/drivers/input/mouse/cyapa.c
index b409c3d..c9fdf6d 100644
--- a/drivers/input/mouse/cyapa.c
+++ b/drivers/input/mouse/cyapa.c
@@ -6,7 +6,7 @@
  *   Daniel Kurtz <djkurtz@chromium.org>
  *   Benson Leung <bleung@chromium.org>
  *
- * Copyright (C) 2011-2012 Cypress Semiconductor, Inc.
+ * Copyright (C) 2011-2014 Cypress Semiconductor, Inc.
  * Copyright (C) 2011-2012 Google, Inc.
  *
  * This file is subject to the terms and conditions of the GNU General Public
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
@@ -422,8 +422,8 @@ static ssize_t cyapa_read_block(struct cyapa *cyapa, u8 cmd_idx, u8 *values)
  */
 static int cyapa_get_state(struct cyapa *cyapa)
 {
-	int ret;
 	u8 status[BL_STATUS_SIZE];
+	int error;
 
 	cyapa->state = CYAPA_STATE_NO_DEVICE;
 
@@ -433,7 +433,7 @@ static int cyapa_get_state(struct cyapa *cyapa)
 	 * If the device is in operation mode, this will be the DATA regs.
 	 *
 	 */
-	ret = cyapa_i2c_reg_read_block(cyapa, BL_HEAD_OFFSET, BL_STATUS_SIZE,
+	error = cyapa_i2c_reg_read_block(cyapa, BL_HEAD_OFFSET, BL_STATUS_SIZE,
 				       status);
 
 	/*
@@ -441,10 +441,10 @@ static int cyapa_get_state(struct cyapa *cyapa)
 	 * -ETIMEDOUT.  In this case, try again using the smbus equivalent
 	 * command.  This should return a BL_HEAD indicating CYAPA_STATE_OP.
 	 */
-	if (cyapa->smbus && (ret == -ETIMEDOUT || ret == -ENXIO))
-		ret = cyapa_read_block(cyapa, CYAPA_CMD_BL_STATUS, status);
+	if (cyapa->smbus && (error == -ETIMEDOUT || error == -ENXIO))
+		error = cyapa_read_block(cyapa, CYAPA_CMD_BL_STATUS, status);
 
-	if (ret != BL_STATUS_SIZE)
+	if (error != BL_STATUS_SIZE)
 		goto error;
 
 	if ((status[REG_OP_STATUS] & OP_STATUS_SRC) == OP_STATUS_SRC) {
@@ -454,7 +454,7 @@ static int cyapa_get_state(struct cyapa *cyapa)
 			cyapa->state = CYAPA_STATE_OP;
 			break;
 		default:
-			ret = -EAGAIN;
+			error = -EAGAIN;
 			goto error;
 		}
 	} else {
@@ -468,7 +468,7 @@ static int cyapa_get_state(struct cyapa *cyapa)
 
 	return 0;
 error:
-	return (ret < 0) ? ret : -EAGAIN;
+	return (error < 0) ? error : -EAGAIN;
 }
 
 /*
@@ -487,31 +487,31 @@ error:
  */
 static int cyapa_poll_state(struct cyapa *cyapa, unsigned int timeout)
 {
-	int ret;
+	int error;
 	int tries = timeout / 100;
 
-	ret = cyapa_get_state(cyapa);
-	while ((ret || cyapa->state >= CYAPA_STATE_BL_BUSY) && tries--) {
+	error = cyapa_get_state(cyapa);
+	while ((error || cyapa->state >= CYAPA_STATE_BL_BUSY) && tries--) {
 		msleep(100);
-		ret = cyapa_get_state(cyapa);
+		error = cyapa_get_state(cyapa);
 	}
-	return (ret == -EAGAIN || ret == -ETIMEDOUT) ? -ETIMEDOUT : ret;
+	return (error == -EAGAIN || error == -ETIMEDOUT) ? -ETIMEDOUT : error;
 }
 
 static int cyapa_bl_deactivate(struct cyapa *cyapa)
 {
-	int ret;
+	int error;
 
-	ret = cyapa_i2c_reg_write_block(cyapa, 0, sizeof(bl_deactivate),
+	error = cyapa_i2c_reg_write_block(cyapa, 0, sizeof(bl_deactivate),
 					bl_deactivate);
-	if (ret < 0)
-		return ret;
+	if (error)
+		return error;
 
 	/* wait for bootloader to switch to idle state; should take < 100ms */
 	msleep(100);
-	ret = cyapa_poll_state(cyapa, 500);
-	if (ret < 0)
-		return ret;
+	error = cyapa_poll_state(cyapa, 500);
+	if (error)
+		return error;
 	if (cyapa->state != CYAPA_STATE_BL_IDLE)
 		return -EAGAIN;
 	return 0;
@@ -532,11 +532,11 @@ static int cyapa_bl_deactivate(struct cyapa *cyapa)
  */
 static int cyapa_bl_exit(struct cyapa *cyapa)
 {
-	int ret;
+	int error;
 
-	ret = cyapa_i2c_reg_write_block(cyapa, 0, sizeof(bl_exit), bl_exit);
-	if (ret < 0)
-		return ret;
+	error = cyapa_i2c_reg_write_block(cyapa, 0, sizeof(bl_exit), bl_exit);
+	if (error)
+		return error;
 
 	/*
 	 * Wait for bootloader to exit, and operation mode to start.
@@ -548,9 +548,9 @@ static int cyapa_bl_exit(struct cyapa *cyapa)
 	 * updated to new firmware, it must first calibrate its sensors, which
 	 * can take up to an additional 2 seconds.
 	 */
-	ret = cyapa_poll_state(cyapa, 2000);
-	if (ret < 0)
-		return ret;
+	error = cyapa_poll_state(cyapa, 2000);
+	if (error < 0)
+		return error;
 	if (cyapa->state != CYAPA_STATE_OP)
 		return -EAGAIN;
 
@@ -637,28 +637,28 @@ static int cyapa_check_is_operational(struct cyapa *cyapa)
 {
 	struct device *dev = &cyapa->client->dev;
 	static const char unique_str[] = "CYTRA";
-	int ret;
+	int error;
 
-	ret = cyapa_poll_state(cyapa, 2000);
-	if (ret < 0)
-		return ret;
+	error = cyapa_poll_state(cyapa, 2000);
+	if (error)
+		return error;
 	switch (cyapa->state) {
 	case CYAPA_STATE_BL_ACTIVE:
-		ret = cyapa_bl_deactivate(cyapa);
-		if (ret)
-			return ret;
+		error = cyapa_bl_deactivate(cyapa);
+		if (error)
+			return error;
 
 	/* Fallthrough state */
 	case CYAPA_STATE_BL_IDLE:
-		ret = cyapa_bl_exit(cyapa);
-		if (ret)
-			return ret;
+		error = cyapa_bl_exit(cyapa);
+		if (error)
+			return error;
 
 	/* Fallthrough state */
 	case CYAPA_STATE_OP:
-		ret = cyapa_get_query_data(cyapa);
-		if (ret < 0)
-			return ret;
+		error = cyapa_get_query_data(cyapa);
+		if (error)
+			return error;
 
 		/* only support firmware protocol gen3 */
 		if (cyapa->gen != CYAPA_GEN3) {
@@ -756,15 +756,15 @@ static u8 cyapa_check_adapter_functionality(struct i2c_client *client)
 static int cyapa_create_input_dev(struct cyapa *cyapa)
 {
 	struct device *dev = &cyapa->client->dev;
-	int ret;
 	struct input_dev *input;
+	int error;
 
 	if (!cyapa->physical_size_x || !cyapa->physical_size_y)
 		return -EINVAL;
 
 	input = cyapa->input = input_allocate_device();
 	if (!input) {
-		dev_err(dev, "allocate memory for input device failed\n");
+		dev_err(dev, "failed to allocate memory for input device.\n");
 		return -ENOMEM;
 	}
 
@@ -772,14 +772,14 @@ static int cyapa_create_input_dev(struct cyapa *cyapa)
 	input->phys = cyapa->phys;
 	input->id.bustype = BUS_I2C;
 	input->id.version = 1;
-	input->id.product = 0;  /* means any product in eventcomm. */
+	input->id.product = 0;  /* Means any product in eventcomm. */
 	input->dev.parent = &cyapa->client->dev;
 
 	input_set_drvdata(input, cyapa);
 
 	__set_bit(EV_ABS, input->evbit);
 
-	/* finger position */
+	/* Finger position */
 	input_set_abs_params(input, ABS_MT_POSITION_X, 0, cyapa->max_abs_x, 0,
 			     0);
 	input_set_abs_params(input, ABS_MT_POSITION_Y, 0, cyapa->max_abs_y, 0,
@@ -801,18 +801,18 @@ static int cyapa_create_input_dev(struct cyapa *cyapa)
 	if (cyapa->btn_capability == CAPABILITY_LEFT_BTN_MASK)
 		__set_bit(INPUT_PROP_BUTTONPAD, input->propbit);
 
-	/* handle pointer emulation and unused slots in core */
-	ret = input_mt_init_slots(input, CYAPA_MAX_MT_SLOTS,
-				  INPUT_MT_POINTER | INPUT_MT_DROP_UNUSED);
-	if (ret) {
-		dev_err(dev, "allocate memory for MT slots failed, %d\n", ret);
+	/* Handle pointer emulation and unused slots in core */
+	error = input_mt_init_slots(input, CYAPA_MAX_MT_SLOTS,
+			INPUT_MT_POINTER | INPUT_MT_DROP_UNUSED);
+	if (error) {
+		dev_err(dev, "failed to initialize MT slots, %d\n", error);
 		goto err_free_device;
 	}
 
 	/* Register the device in input subsystem */
-	ret = input_register_device(input);
-	if (ret) {
-		dev_err(dev, "input device register failed, %d\n", ret);
+	error = input_register_device(input);
+	if (error) {
+		dev_err(dev, "failed to register input device, %d\n", error);
 		goto err_free_device;
 	}
 	return 0;
@@ -820,16 +820,16 @@ static int cyapa_create_input_dev(struct cyapa *cyapa)
 err_free_device:
 	input_free_device(input);
 	cyapa->input = NULL;
-	return ret;
+	return error;
 }
 
 static int cyapa_probe(struct i2c_client *client,
 		       const struct i2c_device_id *dev_id)
 {
-	int ret;
 	u8 adapter_func;
 	struct cyapa *cyapa;
 	struct device *dev = &client->dev;
+	int error;
 
 	adapter_func = cyapa_check_adapter_functionality(client);
 	if (adapter_func == CYAPA_ADAPTER_FUNC_NONE) {
@@ -838,10 +838,8 @@ static int cyapa_probe(struct i2c_client *client,
 	}
 
 	cyapa = kzalloc(sizeof(struct cyapa), GFP_KERNEL);
-	if (!cyapa) {
-		dev_err(dev, "allocate memory for cyapa failed\n");
+	if (!cyapa)
 		return -ENOMEM;
-	}
 
 	cyapa->gen = CYAPA_GEN3;
 	cyapa->client = client;
@@ -853,33 +851,33 @@ static int cyapa_probe(struct i2c_client *client,
 	if (adapter_func == CYAPA_ADAPTER_FUNC_SMBUS)
 		cyapa->smbus = true;
 	cyapa->state = CYAPA_STATE_NO_DEVICE;
-	ret = cyapa_check_is_operational(cyapa);
-	if (ret) {
-		dev_err(dev, "device not operational, %d\n", ret);
+	error = cyapa_check_is_operational(cyapa);
+	if (error) {
+		dev_err(dev, "device not operational, %d\n", error);
 		goto err_mem_free;
 	}
 
-	ret = cyapa_create_input_dev(cyapa);
-	if (ret) {
-		dev_err(dev, "create input_dev instance failed, %d\n", ret);
+	error = cyapa_create_input_dev(cyapa);
+	if (error) {
+		dev_err(dev, "create input_dev instance failed, %d\n", error);
 		goto err_mem_free;
 	}
 
-	ret = cyapa_set_power_mode(cyapa, PWR_MODE_FULL_ACTIVE);
-	if (ret) {
-		dev_err(dev, "set active power failed, %d\n", ret);
+	error = cyapa_set_power_mode(cyapa, PWR_MODE_FULL_ACTIVE);
+	if (error) {
+		dev_err(dev, "set active power failed, %d\n", error);
 		goto err_unregister_device;
 	}
 
 	cyapa->irq = client->irq;
-	ret = request_threaded_irq(cyapa->irq,
+	error = request_threaded_irq(cyapa->irq,
 				   NULL,
 				   cyapa_irq,
 				   IRQF_TRIGGER_FALLING | IRQF_ONESHOT,
 				   "cyapa",
 				   cyapa);
-	if (ret) {
-		dev_err(dev, "IRQ request failed: %d\n, ", ret);
+	if (error) {
+		dev_err(dev, "failed to request threaded irq: %d\n", error);
 		goto err_unregister_device;
 	}
 
@@ -890,7 +888,7 @@ err_unregister_device:
 err_mem_free:
 	kfree(cyapa);
 
-	return ret;
+	return error;
 }
 
 static int cyapa_remove(struct i2c_client *client)
@@ -908,7 +906,7 @@ static int cyapa_remove(struct i2c_client *client)
 #ifdef CONFIG_PM_SLEEP
 static int cyapa_suspend(struct device *dev)
 {
-	int ret;
+	int error;
 	u8 power_mode;
 	struct cyapa *cyapa = dev_get_drvdata(dev);
 
@@ -920,9 +918,9 @@ static int cyapa_suspend(struct device *dev)
 	 */
 	power_mode = device_may_wakeup(dev) ? PWR_MODE_IDLE
 					    : PWR_MODE_OFF;
-	ret = cyapa_set_power_mode(cyapa, power_mode);
-	if (ret < 0)
-		dev_err(dev, "set power mode failed, %d\n", ret);
+	error = cyapa_set_power_mode(cyapa, power_mode);
+	if (error)
+		dev_err(dev, "set power mode failed, %d\n", error);
 
 	if (device_may_wakeup(dev))
 		cyapa->irq_wake = (enable_irq_wake(cyapa->irq) == 0);
@@ -931,15 +929,15 @@ static int cyapa_suspend(struct device *dev)
 
 static int cyapa_resume(struct device *dev)
 {
-	int ret;
+	int error;
 	struct cyapa *cyapa = dev_get_drvdata(dev);
 
 	if (device_may_wakeup(dev) && cyapa->irq_wake)
 		disable_irq_wake(cyapa->irq);
 
-	ret = cyapa_set_power_mode(cyapa, PWR_MODE_FULL_ACTIVE);
-	if (ret)
-		dev_warn(dev, "resume active power failed, %d\n", ret);
+	error = cyapa_set_power_mode(cyapa, PWR_MODE_FULL_ACTIVE);
+	if (error)
+		dev_warn(dev, "resume active power failed, %d\n", error);
 
 	enable_irq(cyapa->irq);
 	return 0;
-- 
1.9.1

