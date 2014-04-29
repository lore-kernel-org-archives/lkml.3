Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752356AbaD2Cez (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2014 22:34:55 -0400
Received: from mail-pa0-f42.google.com ([209.85.220.42]:59778 "EHLO
	mail-pa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750820AbaD2Cey (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2014 22:34:54 -0400
Date: Mon, 28 Apr 2014 19:34:51 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: linux-input@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Alexander Shiyan <shc_work@mail.ru>
Subject: [PATCH] Input: remove race when instantiating polled device
 attributes
Message-ID: <20140429023449.GA13078@core.coreip.homeip.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Polled device's attributes controlling polling rate and whether polling is
enabled are attached to input device. We should have device core
instantiate them for us, so that they are created by the time new device
notification is sent to userspace, instead of doing it ourselves
afterwards.

Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
---
 drivers/input/input-polldev.c | 19 +++++++++----------
 1 file changed, 9 insertions(+), 10 deletions(-)

diff --git a/drivers/input/input-polldev.c b/drivers/input/input-polldev.c
index 7f161d9..4b19190 100644
--- a/drivers/input/input-polldev.c
+++ b/drivers/input/input-polldev.c
@@ -147,6 +147,11 @@ static struct attribute_group input_polldev_attribute_group = {
 	.attrs = sysfs_attrs
 };
 
+static const struct attribute_group *input_polldev_attribute_groups[] = {
+	&input_polldev_attribute_group,
+	NULL
+};
+
 /**
  * input_allocate_polled_device - allocate memory for polled device
  *
@@ -204,24 +209,21 @@ int input_register_polled_device(struct input_polled_dev *dev)
 
 	input_set_drvdata(input, dev);
 	INIT_DELAYED_WORK(&dev->work, input_polled_device_work);
+
 	if (!dev->poll_interval)
 		dev->poll_interval = 500;
 	if (!dev->poll_interval_max)
 		dev->poll_interval_max = dev->poll_interval;
+
 	input->open = input_open_polled_device;
 	input->close = input_close_polled_device;
 
+	input->dev.groups = input_polldev_attribute_groups;
+
 	error = input_register_device(input);
 	if (error)
 		return error;
 
-	error = sysfs_create_group(&input->dev.kobj,
-				   &input_polldev_attribute_group);
-	if (error) {
-		input_unregister_device(input);
-		return error;
-	}
-
 	/*
 	 * Take extra reference to the underlying input device so
 	 * that it survives call to input_unregister_polled_device()
@@ -245,9 +247,6 @@ EXPORT_SYMBOL(input_register_polled_device);
  */
 void input_unregister_polled_device(struct input_polled_dev *dev)
 {
-	sysfs_remove_group(&dev->input->dev.kobj,
-			   &input_polldev_attribute_group);
-
 	input_unregister_device(dev->input);
 }
 EXPORT_SYMBOL(input_unregister_polled_device);
-- 
1.9.0


-- 
Dmitry
