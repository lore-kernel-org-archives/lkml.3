Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753082AbaBMF2T (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Feb 2014 00:28:19 -0500
Received: from mail-pa0-f54.google.com ([209.85.220.54]:38326 "EHLO
	mail-pa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752602AbaBMF2O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Feb 2014 00:28:14 -0500
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
Subject: [PATCH 10/11] Input: synaptics-rmi4 - make accessor for platform data return const pointer
Date: Wed, 12 Feb 2014 21:27:56 -0800
Message-Id: <1392269277-16391-10-git-send-email-dmitry.torokhov@gmail.com>
X-Mailer: git-send-email 1.8.5.3
In-Reply-To: <1392269277-16391-1-git-send-email-dmitry.torokhov@gmail.com>
References: <1392269277-16391-1-git-send-email-dmitry.torokhov@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When accessing platform data of RMI device let's make sure we do not
accidentally change data that may be shared by returning const pointer.
Also switch to an inline function instead of macro to ensure type safety.

Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
---
 drivers/input/rmi4/rmi_bus.h    | 7 ++++++-
 drivers/input/rmi4/rmi_driver.c | 8 ++++----
 drivers/input/rmi4/rmi_f01.c    | 2 +-
 drivers/input/rmi4/rmi_f11.c    | 2 +-
 4 files changed, 12 insertions(+), 7 deletions(-)

diff --git a/drivers/input/rmi4/rmi_bus.h b/drivers/input/rmi4/rmi_bus.h
index 8d47f52..02a2af8 100644
--- a/drivers/input/rmi4/rmi_bus.h
+++ b/drivers/input/rmi4/rmi_bus.h
@@ -224,7 +224,12 @@ struct rmi_device {
 };
 
 #define to_rmi_device(d) container_of(d, struct rmi_device, dev)
-#define to_rmi_platform_data(d) ((d)->xport->dev->platform_data)
+
+static inline const struct rmi_device_platform_data *
+rmi_get_platform_data(struct rmi_device *d)
+{
+	return dev_get_platdata(d->xport->dev);
+}
 
 bool rmi_is_physical_device(struct device *dev);
 
diff --git a/drivers/input/rmi4/rmi_driver.c b/drivers/input/rmi4/rmi_driver.c
index 736cfbd..473efbc 100644
--- a/drivers/input/rmi4/rmi_driver.c
+++ b/drivers/input/rmi4/rmi_driver.c
@@ -598,7 +598,7 @@ static int rmi_initial_reset(struct rmi_device *rmi_dev,
 		u16 cmd_addr = pdt->page_start + pdt->command_base_addr;
 		u8 cmd_buf = RMI_DEVICE_RESET_CMD;
 		const struct rmi_device_platform_data *pdata =
-				to_rmi_platform_data(rmi_dev);
+				rmi_get_platform_data(rmi_dev);
 
 		error = rmi_write_block(rmi_dev, cmd_addr, &cmd_buf, 1);
 		if (error) {
@@ -621,7 +621,7 @@ static int rmi_create_function(struct rmi_device *rmi_dev,
 {
 	struct device *dev = &rmi_dev->dev;
 	struct rmi_driver_data *data = dev_get_drvdata(&rmi_dev->dev);
-	struct rmi_device_platform_data *pdata = to_rmi_platform_data(rmi_dev);
+	const struct rmi_device_platform_data *pdata = rmi_get_platform_data(rmi_dev);
 	int *current_irq_count = ctx;
 	struct rmi_function *fn;
 	int i;
@@ -745,7 +745,7 @@ static int rmi_driver_remove(struct device *dev)
 	struct rmi_device *rmi_dev = to_rmi_device(dev);
 	struct rmi_driver_data *data = dev_get_drvdata(&rmi_dev->dev);
 	const struct rmi_device_platform_data *pdata =
-					to_rmi_platform_data(rmi_dev);
+					rmi_get_platform_data(rmi_dev);
 
 	disable_sensor(rmi_dev);
 	rmi_free_function_list(rmi_dev);
@@ -781,7 +781,7 @@ static int rmi_driver_probe(struct device *dev)
 	rmi_driver = to_rmi_driver(dev->driver);
 	rmi_dev->driver = rmi_driver;
 
-	pdata = to_rmi_platform_data(rmi_dev);
+	pdata = rmi_get_platform_data(rmi_dev);
 
 	data = devm_kzalloc(dev, sizeof(struct rmi_driver_data), GFP_KERNEL);
 	if (!data) {
diff --git a/drivers/input/rmi4/rmi_f01.c b/drivers/input/rmi4/rmi_f01.c
index 0e21004..36fcf8d 100644
--- a/drivers/input/rmi4/rmi_f01.c
+++ b/drivers/input/rmi4/rmi_f01.c
@@ -184,7 +184,7 @@ static int rmi_f01_probe(struct rmi_function *fn)
 {
 	struct rmi_device *rmi_dev = fn->rmi_dev;
 	struct rmi_driver_data *driver_data = dev_get_drvdata(&rmi_dev->dev);
-	const struct rmi_device_platform_data *pdata = to_rmi_platform_data(rmi_dev);
+	const struct rmi_device_platform_data *pdata = rmi_get_platform_data(rmi_dev);
 	struct f01_data *f01;
 	size_t f01_size;
 	int error;
diff --git a/drivers/input/rmi4/rmi_f11.c b/drivers/input/rmi4/rmi_f11.c
index 2aa7d17..5072437 100644
--- a/drivers/input/rmi4/rmi_f11.c
+++ b/drivers/input/rmi4/rmi_f11.c
@@ -1176,7 +1176,7 @@ static int rmi_f11_initialize(struct rmi_function *fn)
 	u16 control_base_addr;
 	u16 max_x_pos, max_y_pos, temp;
 	int rc;
-	struct rmi_device_platform_data *pdata = to_rmi_platform_data(rmi_dev);
+	const struct rmi_device_platform_data *pdata = rmi_get_platform_data(rmi_dev);
 	struct f11_2d_sensor *sensor;
 	u8 buf;
 
-- 
1.8.5.3

