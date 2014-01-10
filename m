Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752245AbaAJHpS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Jan 2014 02:45:18 -0500
Received: from mail-pa0-f51.google.com ([209.85.220.51]:58218 "EHLO
	mail-pa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751660AbaAJHod (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Jan 2014 02:44:33 -0500
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Christopher Heiny <cheiny@synaptics.com>
Cc: Andrew Duggan <aduggan@synaptics.com>,
        Vincent Huang <vincent.huang@tw.synaptics.com>,
        Vivian Ly <vly@synaptics.com>,
        Daniel Rosenberg <daniel.rosenberg@synaptics.com>,
        Linus Walleij <linus.walleij@stericsson.com>,
        Benjamin Tissoires <benjamin.tissoires@redhat.com>,
        Linux Input <linux-input@vger.kernel.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH 3/4] Input: synaptics-rmi4 - fix I2C functionality check
Date: Thu,  9 Jan 2014 23:44:26 -0800
Message-Id: <1389339867-8399-3-git-send-email-dmitry.torokhov@gmail.com>
X-Mailer: git-send-email 1.8.4.2
In-Reply-To: <1389339867-8399-1-git-send-email-dmitry.torokhov@gmail.com>
References: <1389339867-8399-1-git-send-email-dmitry.torokhov@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When adapter does not support required functionality (I2C_FUNC_I2C) we were
returning 0 to the upper layers, making them believe that device bound
successfully.

Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
---
 drivers/input/rmi4/rmi_i2c.c | 9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

diff --git a/drivers/input/rmi4/rmi_i2c.c b/drivers/input/rmi4/rmi_i2c.c
index cdc8527..c176218 100644
--- a/drivers/input/rmi4/rmi_i2c.c
+++ b/drivers/input/rmi4/rmi_i2c.c
@@ -193,11 +193,10 @@ static int rmi_i2c_probe(struct i2c_client *client,
 		pdata->sensor_name ? pdata->sensor_name : "-no name-",
 		client->addr, pdata->attn_gpio);
 
-	retval = i2c_check_functionality(client->adapter, I2C_FUNC_I2C);
-	if (!retval) {
-		dev_err(&client->dev, "i2c_check_functionality error %d.\n",
-			retval);
-		return retval;
+	if (!i2c_check_functionality(client->adapter, I2C_FUNC_I2C)) {
+		dev_err(&client->dev,
+			"adapter does not support required functionality.\n");
+		return -ENODEV;
 	}
 
 	if (pdata->gpio_config) {
-- 
1.8.4.2

