Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753041AbaBMF2Q (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Feb 2014 00:28:16 -0500
Received: from mail-pa0-f49.google.com ([209.85.220.49]:57307 "EHLO
	mail-pa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752878AbaBMF2M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Feb 2014 00:28:12 -0500
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Christopher Heiny <cheiny@synaptics.com>
Cc: Andrew Duggan <aduggan@synaptics.com>,
        Vincent Huang <vincent.huang@tw.synaptics.com>,
        Vivian Ly <vly@synaptics.com>,
        Daniel Rosenberg <daniel.rosenberg@synaptics.com>,
        Linus Walleij <linus.walleij@stericsson.com>,
        Benjamin Tissoires <benjamin.tissoires@redhat.com>,
        Courtney Cavin <courtney.cavin@sonymobile.com>,
        Linux Input <linux-input@vger.kernel.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH 09/11] Input: synaptics-rmi4 - consolidate memory allocations in F01
Date: Wed, 12 Feb 2014 21:27:55 -0800
Message-Id: <1392269277-16391-9-git-send-email-dmitry.torokhov@gmail.com>
X-Mailer: git-send-email 1.8.5.3
In-Reply-To: <1392269277-16391-1-git-send-email-dmitry.torokhov@gmail.com>
References: <1392269277-16391-1-git-send-email-dmitry.torokhov@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Let's allocate interrupt mask together with the main structure and combine
rmi_f01_alloc_memory, rmi_f01_initialize and rmi_f01_probe into single
function.

Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
---
 drivers/input/rmi4/rmi_f01.c | 86 ++++++++++++++++----------------------------
 1 file changed, 30 insertions(+), 56 deletions(-)

diff --git a/drivers/input/rmi4/rmi_f01.c b/drivers/input/rmi4/rmi_f01.c
index a2f05bc..0e21004 100644
--- a/drivers/input/rmi4/rmi_f01.c
+++ b/drivers/input/rmi4/rmi_f01.c
@@ -130,37 +130,15 @@ struct f01_data {
 	u16 doze_interval_addr;
 	u16 wakeup_threshold_addr;
 	u16 doze_holdoff_addr;
-	int irq_count;
-	int num_of_irq_regs;
 
 #ifdef CONFIG_PM_SLEEP
 	bool suspended;
 	bool old_nosleep;
 #endif
-};
-
-static int rmi_f01_alloc_memory(struct rmi_function *fn,
-				int num_of_irq_regs)
-{
-	struct f01_data *f01;
 
-	f01 = devm_kzalloc(&fn->dev, sizeof(struct f01_data), GFP_KERNEL);
-	if (!f01) {
-		dev_err(&fn->dev, "Failed to allocate fn_01_data.\n");
-		return -ENOMEM;
-	}
-
-	f01->device_control.interrupt_enable = devm_kzalloc(&fn->dev,
-			sizeof(u8) * (num_of_irq_regs),
-			GFP_KERNEL);
-	if (!f01->device_control.interrupt_enable) {
-		dev_err(&fn->dev, "Failed to allocate interrupt enable.\n");
-		return -ENOMEM;
-	}
-	fn->data = f01;
-
-	return 0;
-}
+	unsigned int num_of_irq_regs;
+	u8 interrupt_enable[];
+};
 
 static int rmi_f01_read_properties(struct rmi_device *rmi_dev,
 				   u16 query_base_addr,
@@ -202,16 +180,28 @@ static int rmi_f01_read_properties(struct rmi_device *rmi_dev,
 	return 0;
 }
 
-static int rmi_f01_initialize(struct rmi_function *fn)
+static int rmi_f01_probe(struct rmi_function *fn)
 {
-	u8 temp;
-	int error;
 	struct rmi_device *rmi_dev = fn->rmi_dev;
 	struct rmi_driver_data *driver_data = dev_get_drvdata(&rmi_dev->dev);
-	struct f01_data *f01 = fn->data;
 	const struct rmi_device_platform_data *pdata = to_rmi_platform_data(rmi_dev);
+	struct f01_data *f01;
+	size_t f01_size;
+	int error;
 	u16 ctrl_base_addr = fn->fd.control_base_addr;
 	u8 device_status;
+	u8 temp;
+
+	f01_size = sizeof(struct f01_data) +
+				sizeof(u8) * driver_data->num_of_irq_regs;
+	f01 = devm_kzalloc(&fn->dev, f01_size, GFP_KERNEL);
+	if (!f01) {
+		dev_err(&fn->dev, "Failed to allocate fn01_data.\n");
+		return -ENOMEM;
+	}
+
+	f01->num_of_irq_regs = driver_data->num_of_irq_regs;
+	f01->device_control.interrupt_enable = f01->interrupt_enable;
 
 	/*
 	 * Set the configured bit and (optionally) other important stuff
@@ -257,12 +247,11 @@ static int rmi_f01_initialize(struct rmi_function *fn)
 		return error;
 	}
 
-	f01->irq_count = driver_data->irq_count;
-	f01->num_of_irq_regs = driver_data->num_of_irq_regs;
-	ctrl_base_addr += sizeof(u8);
-
+	/* Advance to interrupt control registers */
+	ctrl_base_addr++;
 	f01->interrupt_enable_addr = ctrl_base_addr;
-	error = rmi_read_block(rmi_dev, ctrl_base_addr,
+
+	error = rmi_read_block(rmi_dev, f01->interrupt_enable_addr,
 				f01->device_control.interrupt_enable,
 				sizeof(u8) * (f01->num_of_irq_regs));
 	if (error) {
@@ -272,9 +261,7 @@ static int rmi_f01_initialize(struct rmi_function *fn)
 		return error;
 	}
 
-	ctrl_base_addr += f01->num_of_irq_regs;
-
-	/* dummy read in order to clear irqs */
+	/* Dummy read in order to clear irqs */
 	error = rmi_read(rmi_dev, fn->fd.data_base_addr + 1, &temp);
 	if (error < 0) {
 		dev_err(&fn->dev, "Failed to read Interrupt Status.\n");
@@ -287,11 +274,13 @@ static int rmi_f01_initialize(struct rmi_function *fn)
 		dev_err(&fn->dev, "Failed to read F01 properties.\n");
 		return error;
 	}
+
 	dev_info(&fn->dev, "found RMI device, manufacturer: %s, product: %s\n",
-		 f01->properties.manufacturer_id == 1 ?
-							"Synaptics" : "unknown",
+		 f01->properties.manufacturer_id == 1 ? "Synaptics" : "unknown",
 		 f01->properties.product_id);
 
+	ctrl_base_addr += f01->num_of_irq_regs;
+
 	/* read control register */
 	if (f01->properties.has_adjustable_doze) {
 		f01->doze_interval_addr = ctrl_base_addr;
@@ -365,6 +354,8 @@ static int rmi_f01_initialize(struct rmi_function *fn)
 		return -EINVAL;
 	}
 
+	fn->data = f01;
+
 	return 0;
 }
 
@@ -424,23 +415,6 @@ static int rmi_f01_config(struct rmi_function *fn)
 	return 0;
 }
 
-static int rmi_f01_probe(struct rmi_function *fn)
-{
-	struct rmi_driver_data *driver_data =
-			dev_get_drvdata(&fn->rmi_dev->dev);
-	int error;
-
-	error = rmi_f01_alloc_memory(fn, driver_data->num_of_irq_regs);
-	if (error)
-		return error;
-
-	error = rmi_f01_initialize(fn);
-	if (error)
-		return error;
-
-	return 0;
-}
-
 #ifdef CONFIG_PM_SLEEP
 static int rmi_f01_suspend(struct device *dev)
 {
-- 
1.8.5.3

