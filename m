Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933512AbaGWVNU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jul 2014 17:13:20 -0400
Received: from mail-pa0-f52.google.com ([209.85.220.52]:39504 "EHLO
	mail-pa0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932921AbaGWVNT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jul 2014 17:13:19 -0400
Date: Thu, 24 Jul 2014 02:43:11 +0530
From: Himangi Saraogi <himangi774@gmail.com>
To: Jean Delvare <khali@linux-fr.org>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc: Julia Lawall <julia.lawall@lip6.fr>
Subject: [PATCH v2] EEPROM: Introduce the use of devm_kzalloc
Message-ID: <20140723211311.GA4165@himangi-Dell>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch introduces the use of devm_kzalloc and does away with the
kfrees in the probe and remove functions. Also, a label and the err
variable are removed.

Signed-off-by: Himangi Saraogi <himangi774@gmail.com>
Acked-by: Julia Lawall <julia.lawall@lip6.fr>
---
v2: add missing semi-colon
 drivers/misc/eeprom/eeprom.c | 21 +++++----------------
 1 file changed, 5 insertions(+), 16 deletions(-)

diff --git a/drivers/misc/eeprom/eeprom.c b/drivers/misc/eeprom/eeprom.c
index 33f8673..f4aff20 100644
--- a/drivers/misc/eeprom/eeprom.c
+++ b/drivers/misc/eeprom/eeprom.c
@@ -159,12 +159,11 @@ static int eeprom_probe(struct i2c_client *client,
 {
 	struct i2c_adapter *adapter = client->adapter;
 	struct eeprom_data *data;
-	int err;
 
-	if (!(data = kzalloc(sizeof(struct eeprom_data), GFP_KERNEL))) {
-		err = -ENOMEM;
-		goto exit;
-	}
+	data = devm_kzalloc(&client->dev, sizeof(struct eeprom_data),
+			    GFP_KERNEL);
+	if (!data)
+		return -ENOMEM;
 
 	memset(data->data, 0xff, EEPROM_SIZE);
 	i2c_set_clientdata(client, data);
@@ -190,22 +189,12 @@ static int eeprom_probe(struct i2c_client *client,
 	}
 
 	/* create the sysfs eeprom file */
-	err = sysfs_create_bin_file(&client->dev.kobj, &eeprom_attr);
-	if (err)
-		goto exit_kfree;
-
-	return 0;
-
-exit_kfree:
-	kfree(data);
-exit:
-	return err;
+	return sysfs_create_bin_file(&client->dev.kobj, &eeprom_attr);
 }
 
 static int eeprom_remove(struct i2c_client *client)
 {
 	sysfs_remove_bin_file(&client->dev.kobj, &eeprom_attr);
-	kfree(i2c_get_clientdata(client));
 
 	return 0;
 }
-- 
1.9.1

