Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758947Ab3CYVAb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Mar 2013 17:00:31 -0400
Received: from eu1sys200aog113.obsmtp.com ([207.126.144.135]:44979 "EHLO
	eu1sys200aog113.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758887Ab3CYVA3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Mar 2013 17:00:29 -0400
From: Linus Walleij <linus.walleij@stericsson.com>
To: <gregkh@linuxfoundation.org>, <linux-kernel@vger.kernel.org>
Cc: Arnd Bergmann <arnd@arndb.de>, Linus Walleij <linus.walleij@linaro.org>
Subject: [PATCH 5/9 RESEND] staging: ste_rmi4: kill platform_data hack
Date: Mon, 25 Mar 2013 22:00:11 +0100
Message-ID: <1364245211-21422-1-git-send-email-linus.walleij@stericsson.com>
X-Mailer: git-send-email 1.7.11.3
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnd Bergmann <arnd@arndb.de>

There is only one instance of the platform data for synaptics_i2c_rmi4
in the mainline kernel, so there is no point of pretending its
variable here. The only member that has a dependency on the platform
is actually the interrupt number, and there is a field in the
i2c_client structure that gets initialized from the board info,
so we can trivially move the board_into into the platform without
knowledge of the platform_data structure.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
---
Hi Greg, seeking your ACK on this to take it through the ARM SoC
tree.
---
 arch/arm/mach-ux500/board-mop500-u8500uib.c        |  7 +++--
 drivers/staging/ste_rmi4/Makefile                  |  1 -
 .../staging/ste_rmi4/board-mop500-u8500uib-rmi4.c  | 31 ----------------------
 drivers/staging/ste_rmi4/synaptics_i2c_rmi4.c      | 31 +++++++++++++---------
 drivers/staging/ste_rmi4/synaptics_i2c_rmi4.h      |  1 -
 5 files changed, 23 insertions(+), 48 deletions(-)
 delete mode 100644 drivers/staging/ste_rmi4/board-mop500-u8500uib-rmi4.c

diff --git a/arch/arm/mach-ux500/board-mop500-u8500uib.c b/arch/arm/mach-ux500/board-mop500-u8500uib.c
index ead91c9..0b5e14a 100644
--- a/arch/arm/mach-ux500/board-mop500-u8500uib.c
+++ b/arch/arm/mach-ux500/board-mop500-u8500uib.c
@@ -16,8 +16,11 @@
 
 #include "board-mop500.h"
 
-/* Dummy data that can be overridden by staging driver */
-struct i2c_board_info __initdata __weak mop500_i2c3_devices_u8500[] = {
+static struct i2c_board_info __initdata mop500_i2c3_devices_u8500[] = {
+	{
+		I2C_BOARD_INFO("synaptics_rmi4_i2c", 0x4B),
+		.irq = NOMADIK_GPIO_TO_IRQ(84),
+	},
 };
 
 /*
diff --git a/drivers/staging/ste_rmi4/Makefile b/drivers/staging/ste_rmi4/Makefile
index e4c0335..6cce2ed 100644
--- a/drivers/staging/ste_rmi4/Makefile
+++ b/drivers/staging/ste_rmi4/Makefile
@@ -2,4 +2,3 @@
 # Makefile for the RMI4 touchscreen driver.
 #
 obj-$(CONFIG_TOUCHSCREEN_SYNAPTICS_I2C_RMI4) += synaptics_i2c_rmi4.o
-obj-$(CONFIG_MACH_MOP500) += board-mop500-u8500uib-rmi4.o
diff --git a/drivers/staging/ste_rmi4/board-mop500-u8500uib-rmi4.c b/drivers/staging/ste_rmi4/board-mop500-u8500uib-rmi4.c
deleted file mode 100644
index 47439c3..0000000
--- a/drivers/staging/ste_rmi4/board-mop500-u8500uib-rmi4.c
+++ /dev/null
@@ -1,31 +0,0 @@
-/*
- * Some platform data for the RMI4 touchscreen that will override the __weak
- * platform data in the Ux500 machine if this driver is activated.
- */
-#include <linux/i2c.h>
-#include <linux/gpio.h>
-#include <linux/interrupt.h>
-#include <mach/irqs.h>
-#include "synaptics_i2c_rmi4.h"
-
-/*
- * Synaptics RMI4 touchscreen interface on the U8500 UIB
- */
-
-/*
- * Descriptor structure.
- * Describes the number of i2c devices on the bus that speak RMI.
- */
-static struct synaptics_rmi4_platform_data rmi4_i2c_dev_platformdata = {
-	.irq_number     = NOMADIK_GPIO_TO_IRQ(84),
-	.irq_type       = (IRQF_TRIGGER_FALLING | IRQF_SHARED),
-	.x_flip		= false,
-	.y_flip		= true,
-};
-
-struct i2c_board_info __initdata mop500_i2c3_devices_u8500[] = {
-	{
-		I2C_BOARD_INFO("synaptics_rmi4_i2c", 0x4B),
-		.platform_data = &rmi4_i2c_dev_platformdata,
-	},
-};
diff --git a/drivers/staging/ste_rmi4/synaptics_i2c_rmi4.c b/drivers/staging/ste_rmi4/synaptics_i2c_rmi4.c
index 6a21f67..2e35307 100644
--- a/drivers/staging/ste_rmi4/synaptics_i2c_rmi4.c
+++ b/drivers/staging/ste_rmi4/synaptics_i2c_rmi4.c
@@ -864,6 +864,16 @@ static int synaptics_rmi4_i2c_query_device(struct synaptics_rmi4_data *pdata)
 	return 0;
 }
 
+/*
+ * Descriptor structure.
+ * Describes the number of i2c devices on the bus that speak RMI.
+ */
+static struct synaptics_rmi4_platform_data synaptics_rmi4_platformdata = {
+	.irq_type       = (IRQF_TRIGGER_FALLING | IRQF_SHARED),
+	.x_flip		= false,
+	.y_flip		= true,
+};
+
 /**
  * synaptics_rmi4_probe() - Initialze the i2c-client touchscreen driver
  * @i2c: i2c client structure pointer
@@ -890,10 +900,8 @@ static int synaptics_rmi4_probe
 		return -EIO;
 	}
 
-	if (!platformdata) {
-		dev_err(&client->dev, "%s: no platform data\n", __func__);
-		return -EINVAL;
-	}
+	if (!platformdata)
+		platformdata = &synaptics_rmi4_platformdata;
 
 	/* Allocate and initialize the instance data for this client */
 	rmi4_data = kcalloc(2, sizeof(struct synaptics_rmi4_data),
@@ -977,13 +985,13 @@ static int synaptics_rmi4_probe
 	synaptics_rmi4_i2c_block_read(rmi4_data,
 			rmi4_data->fn01_data_base_addr + 1, intr_status,
 				rmi4_data->number_of_interrupt_register);
-	retval = request_threaded_irq(platformdata->irq_number, NULL,
+	retval = request_threaded_irq(client->irq, NULL,
 					synaptics_rmi4_irq,
 					platformdata->irq_type,
 					DRIVER_NAME, rmi4_data);
 	if (retval) {
 		dev_err(&client->dev, "%s:Unable to get attn irq %d\n",
-				__func__, platformdata->irq_number);
+				__func__, client->irq);
 		goto err_query_dev;
 	}
 
@@ -996,7 +1004,7 @@ static int synaptics_rmi4_probe
 	return retval;
 
 err_free_irq:
-	free_irq(platformdata->irq_number, rmi4_data);
+	free_irq(client->irq, rmi4_data);
 err_query_dev:
 	regulator_disable(rmi4_data->regulator);
 err_regulator_enable:
@@ -1019,11 +1027,10 @@ err_input:
 static int synaptics_rmi4_remove(struct i2c_client *client)
 {
 	struct synaptics_rmi4_data *rmi4_data = i2c_get_clientdata(client);
-	const struct synaptics_rmi4_platform_data *pdata = rmi4_data->board;
 
 	rmi4_data->touch_stopped = true;
 	wake_up(&rmi4_data->wait);
-	free_irq(pdata->irq_number, rmi4_data);
+	free_irq(client->irq, rmi4_data);
 	input_unregister_device(rmi4_data->input_dev);
 	regulator_disable(rmi4_data->regulator);
 	regulator_put(rmi4_data->regulator);
@@ -1046,10 +1053,9 @@ static int synaptics_rmi4_suspend(struct device *dev)
 	int retval;
 	unsigned char intr_status;
 	struct synaptics_rmi4_data *rmi4_data = dev_get_drvdata(dev);
-	const struct synaptics_rmi4_platform_data *pdata = rmi4_data->board;
 
 	rmi4_data->touch_stopped = true;
-	disable_irq(pdata->irq_number);
+	disable_irq(rmi4_data->i2c_client->irq);
 
 	retval = synaptics_rmi4_i2c_block_read(rmi4_data,
 				rmi4_data->fn01_data_base_addr + 1,
@@ -1080,11 +1086,10 @@ static int synaptics_rmi4_resume(struct device *dev)
 	int retval;
 	unsigned char intr_status;
 	struct synaptics_rmi4_data *rmi4_data = dev_get_drvdata(dev);
-	const struct synaptics_rmi4_platform_data *pdata = rmi4_data->board;
 
 	regulator_enable(rmi4_data->regulator);
 
-	enable_irq(pdata->irq_number);
+	enable_irq(rmi4_data->i2c_client->irq);
 	rmi4_data->touch_stopped = false;
 
 	retval = synaptics_rmi4_i2c_block_read(rmi4_data,
diff --git a/drivers/staging/ste_rmi4/synaptics_i2c_rmi4.h b/drivers/staging/ste_rmi4/synaptics_i2c_rmi4.h
index 384436e..8c9166b 100644
--- a/drivers/staging/ste_rmi4/synaptics_i2c_rmi4.h
+++ b/drivers/staging/ste_rmi4/synaptics_i2c_rmi4.h
@@ -38,7 +38,6 @@
  * This structure gives platform data for rmi4.
  */
 struct synaptics_rmi4_platform_data {
-	int irq_number;
 	int irq_type;
 	bool x_flip;
 	bool y_flip;
-- 
1.7.11.3

