Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933618AbaGWVPs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jul 2014 17:15:48 -0400
Received: from mail-pa0-f48.google.com ([209.85.220.48]:38021 "EHLO
	mail-pa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933322AbaGWVPr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jul 2014 17:15:47 -0400
Date: Thu, 24 Jul 2014 02:45:40 +0530
From: Himangi Saraogi <himangi774@gmail.com>
To: Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc: Julia Lawall <julia.lawall@lip6.fr>
Subject: [PATCH] misc: bh1780: Introduce the use of devm_kzalloc
Message-ID: <20140723211540.GA4254@himangi-Dell>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch introduces the use of devm_kzalloc and does away with the
kfrees in the probe and remove functions. A label and the kfree
being called on the return path of failure on i2c_check_functionality,
which is completely unnecessary and removed. The NULL assignment of
ddata is no longer required is also done away with.

Signed-off-by: Himangi Saraogi <himangi774@gmail.com>
Acked-by: Julia Lawall <julia.lawall@lip6.fr>
---
 drivers/misc/bh1780gli.c | 33 +++++++++------------------------
 1 file changed, 9 insertions(+), 24 deletions(-)

diff --git a/drivers/misc/bh1780gli.c b/drivers/misc/bh1780gli.c
index 48ea33d..4c4a59b 100644
--- a/drivers/misc/bh1780gli.c
+++ b/drivers/misc/bh1780gli.c
@@ -149,50 +149,35 @@ static int bh1780_probe(struct i2c_client *client,
 						const struct i2c_device_id *id)
 {
 	int ret;
-	struct bh1780_data *ddata = NULL;
+	struct bh1780_data *ddata;
 	struct i2c_adapter *adapter = to_i2c_adapter(client->dev.parent);
 
-	if (!i2c_check_functionality(adapter, I2C_FUNC_SMBUS_BYTE)) {
-		ret = -EIO;
-		goto err_op_failed;
-	}
+	if (!i2c_check_functionality(adapter, I2C_FUNC_SMBUS_BYTE))
+		return -EIO;
 
-	ddata = kzalloc(sizeof(struct bh1780_data), GFP_KERNEL);
-	if (ddata == NULL) {
-		ret = -ENOMEM;
-		goto err_op_failed;
-	}
+	ddata = devm_kzalloc(&client->dev, sizeof(struct bh1780_data),
+			     GFP_KERNEL);
+	if (ddata == NULL)
+		return -ENOMEM;
 
 	ddata->client = client;
 	i2c_set_clientdata(client, ddata);
 
 	ret = bh1780_read(ddata, BH1780_REG_PARTID, "PART ID");
 	if (ret < 0)
-		goto err_op_failed;
+		return ret;
 
 	dev_info(&client->dev, "Ambient Light Sensor, Rev : %d\n",
 			(ret & BH1780_REVMASK));
 
 	mutex_init(&ddata->lock);
 
-	ret = sysfs_create_group(&client->dev.kobj, &bh1780_attr_group);
-	if (ret)
-		goto err_op_failed;
-
-	return 0;
-
-err_op_failed:
-	kfree(ddata);
-	return ret;
+	return sysfs_create_group(&client->dev.kobj, &bh1780_attr_group);
 }
 
 static int bh1780_remove(struct i2c_client *client)
 {
-	struct bh1780_data *ddata;
-
-	ddata = i2c_get_clientdata(client);
 	sysfs_remove_group(&client->dev.kobj, &bh1780_attr_group);
-	kfree(ddata);
 
 	return 0;
 }
-- 
1.9.1

