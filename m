Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753255Ab3ALLzM (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Jan 2013 06:55:12 -0500
Received: from mail-pa0-f49.google.com ([209.85.220.49]:43803 "EHLO
	mail-pa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751689Ab3ALLzK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Jan 2013 06:55:10 -0500
From: Dongjin Kim <tobetter@gmail.com>
Cc: Dongjin Kim <tobetter@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] USB: misc: fixup smatch WARNING
Date: Sat, 12 Jan 2013 20:54:33 +0900
Message-Id: <1357991692-13453-1-git-send-email-tobetter@gmail.com>
X-Mailer: git-send-email 1.7.10.4
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fixes the warning,

6a099c63650e50ebf7d1259b859a3d230aec4207 [4/10] USB: misc: Add USB3503 High-Speed Hub Controller

drivers/usb/misc/usb3503.c:238 usb3503_probe() error: we previously assumed 'pdata' could be null (see line 196)

Signed-off-by: Dongjin Kim <tobetter@gmail.com>
---
 drivers/usb/misc/usb3503.c |    9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/drivers/usb/misc/usb3503.c b/drivers/usb/misc/usb3503.c
index 796d58c..7bc2812 100644
--- a/drivers/usb/misc/usb3503.c
+++ b/drivers/usb/misc/usb3503.c
@@ -182,12 +182,12 @@ int usb3503_probe(struct i2c_client *i2c, const struct i2c_device_id *id)
 {
 	struct usb3503_platform_data *pdata = i2c->dev.platform_data;
 	struct usb3503 *hub;
-	int err;
+	int err = -ENOMEM;
 
 	hub = kzalloc(sizeof(struct usb3503), GFP_KERNEL);
 	if (!hub) {
 		dev_err(&i2c->dev, "private data alloc fail\n");
-		return -ENOMEM;
+		return err;
 	}
 
 	i2c_set_clientdata(i2c, hub);
@@ -195,6 +195,7 @@ int usb3503_probe(struct i2c_client *i2c, const struct i2c_device_id *id)
 
 	if (!pdata) {
 		dev_dbg(&i2c->dev, "missing platform data\n");
+		goto err_out;
 	} else {
 		hub->gpio_intn		= pdata->gpio_intn;
 		hub->gpio_connect	= pdata->gpio_connect;
@@ -209,7 +210,7 @@ int usb3503_probe(struct i2c_client *i2c, const struct i2c_device_id *id)
 			dev_err(&i2c->dev,
 					"unable to request GPIO %d as connect pin (%d)\n",
 					hub->gpio_intn, err);
-			goto err_gpio_intn;
+			goto err_out;
 		}
 	}
 
@@ -248,7 +249,7 @@ err_gpio_reset:
 err_gpio_connect:
 	if (gpio_is_valid(hub->gpio_intn))
 		gpio_free(hub->gpio_intn);
-err_gpio_intn:
+err_out:
 	kfree(hub);
 
 	return err;
-- 
1.7.9.5

