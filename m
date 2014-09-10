Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753177AbaIJOdM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Sep 2014 10:33:12 -0400
Received: from kdh-gw.itdev.co.uk ([89.21.227.133]:42847 "EHLO
	hermes.kdh.itdev.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752143AbaIJOdI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Sep 2014 10:33:08 -0400
From: nick.dyer@itdev.co.uk
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Stephen Warren <swarren@wwwdotorg.org>
Cc: Yufeng Shen <miletus@google.com>, Daniel Kurtz <djkurtz@chromium.org>,
        Henrik Rydberg <rydberg@euromail.se>,
        Joonyoung Shim <jy0922.shim@samsung.com>,
        Alan Bowens <Alan.Bowens@atmel.com>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org, Peter Meerwald <pmeerw@pmeerw.net>,
        Benson Leung <bleung@chromium.org>,
        Olof Johansson <olofj@chromium.org>, Sekhar Nori <nsekhar@ti.com>,
        Nick Dyer <nick.dyer@itdev.co.uk>
Subject: [PATCH 2/2 v2] Input: atmel_mxt_ts - fix double free of input device
Date: Wed, 10 Sep 2014 15:33:01 +0100
Message-Id: <1410359581-16284-1-git-send-email-nick.dyer@itdev.co.uk>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <541060D8.9020707@itdev.co.uk>
References: <541060D8.9020707@itdev.co.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Stephen Warren <swarren@wwwdotorg.org>

[reworked after comments by Dmitry Torokhov. Move free of input device into
separate function. Only call in paths that require it.]
Signed-off-by: Nick Dyer <nick.dyer@itdev.co.uk>
---
 drivers/input/touchscreen/atmel_mxt_ts.c | 18 +++++++++++++-----
 1 file changed, 13 insertions(+), 5 deletions(-)

diff --git a/drivers/input/touchscreen/atmel_mxt_ts.c b/drivers/input/touchscreen/atmel_mxt_ts.c
index d954b81..aaacf8b 100644
--- a/drivers/input/touchscreen/atmel_mxt_ts.c
+++ b/drivers/input/touchscreen/atmel_mxt_ts.c
@@ -1379,11 +1379,16 @@ static int mxt_get_info(struct mxt_data *data)
 	return 0;
 }
 
-static void mxt_free_object_table(struct mxt_data *data)
+static void mxt_free_input_device(struct mxt_data *data)
 {
-	input_unregister_device(data->input_dev);
-	data->input_dev = NULL;
+	if (data->input_dev) {
+		input_unregister_device(data->input_dev);
+		data->input_dev = NULL;
+	}
+}
 
+static void mxt_free_object_table(struct mxt_data *data)
+{
 	kfree(data->object_table);
 	data->object_table = NULL;
 	kfree(data->msg_buf);
@@ -1962,11 +1967,13 @@ static int mxt_load_fw(struct device *dev, const char *fn)
 		ret = mxt_lookup_bootloader_address(data, 0);
 		if (ret)
 			goto release_firmware;
+
+		mxt_free_input_device(data);
+		mxt_free_object_table(data);
 	} else {
 		enable_irq(data->irq);
 	}
 
-	mxt_free_object_table(data);
 	reinit_completion(&data->bl_completion);
 
 	ret = mxt_check_bootloader(data, MXT_WAITING_BOOTLOAD_CMD, false);
@@ -2215,6 +2222,7 @@ static int mxt_probe(struct i2c_client *client, const struct i2c_device_id *id)
 	return 0;
 
 err_free_object:
+	mxt_free_input_device(data);
 	mxt_free_object_table(data);
 err_free_irq:
 	free_irq(client->irq, data);
@@ -2229,7 +2237,7 @@ static int mxt_remove(struct i2c_client *client)
 
 	sysfs_remove_group(&client->dev.kobj, &mxt_attr_group);
 	free_irq(data->irq, data);
-	input_unregister_device(data->input_dev);
+	mxt_free_input_device(data);
 	mxt_free_object_table(data);
 	kfree(data);
 
-- 
1.9.1

