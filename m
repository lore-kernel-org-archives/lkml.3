Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932390AbaAWT0M (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jan 2014 14:26:12 -0500
Received: from ext3.cumulusnetworks.com ([198.211.106.187]:48665 "EHLO
	ext3.cumulusnetworks.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753231AbaAWT0H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jan 2014 14:26:07 -0500
From: Curt Brune <curt@cumulusnetworks.com>
To: Wolfram Sang <wsa@the-dreams.de>, Laszlo Papp <lpapp@kde.org>
Cc: Thomas De Schampheleire <patrickdepinguin@gmail.com>,
        gregkh@linuxfoundation.org,
        Shrijeet Mukherjee <shm@cumulusnetworks.com>,
        linux-i2c@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        curt@cumulusnetworks.com
Subject: [PATCH v2 2/2] Add at24 based EEPROMs to the eeprom_dev hardware class
Date: Thu, 23 Jan 2014 11:16:02 -0800
Message-Id: <1390504562-20333-2-git-send-email-curt@cumulusnetworks.com>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

During device instantiation have the at24 driver add the new device to
the eeprom_dev hardware class.  The functionality is enabled by
CONFIG_EEPROM_CLASS.

Signed-off-by: Curt Brune <curt@cumulusnetworks.com>
---
 drivers/misc/eeprom/at24.c |   20 ++++++++++++++++++++
 1 file changed, 20 insertions(+)

diff --git a/drivers/misc/eeprom/at24.c b/drivers/misc/eeprom/at24.c
index d87f77f..07782ea 100644
--- a/drivers/misc/eeprom/at24.c
+++ b/drivers/misc/eeprom/at24.c
@@ -22,10 +22,14 @@
 #include <linux/jiffies.h>
 #include <linux/of.h>
 #include <linux/i2c.h>
 #include <linux/platform_data/at24.h>
 
+#ifdef CONFIG_EEPROM_CLASS
+#include <linux/eeprom_class.h>
+#endif
+
 /*
  * I2C EEPROMs from most vendors are inexpensive and mostly interchangeable.
  * Differences between different vendor product lines (like Atmel AT24C or
  * MicroChip 24LC, etc) won't much matter for typical read/write access.
  * There are also I2C RAM chips, likewise interchangeable. One example
@@ -66,10 +70,13 @@ struct at24_data {
 
 	u8 *writebuf;
 	unsigned write_max;
 	unsigned num_addresses;
 
+#ifdef CONFIG_EEPROM_CLASS
+	struct device *eeprom_dev;
+#endif
 	/*
 	 * Some chips tie up multiple I2C addresses; dummy devices reserve
 	 * them for us, and we'll use them with SMBus calls.
 	 */
 	struct i2c_client *client[];
@@ -619,10 +626,19 @@ static int at24_probe(struct i2c_client *client, const struct i2c_device_id *id)
 
 	err = sysfs_create_bin_file(&client->dev.kobj, &at24->bin);
 	if (err)
 		goto err_clients;
 
+#ifdef CONFIG_EEPROM_CLASS
+	at24->eeprom_dev = eeprom_device_register(&client->dev);
+	if (IS_ERR(at24->eeprom_dev)) {
+		dev_err(&client->dev, "error registering eeprom device.\n");
+		err = PTR_ERR(at24->eeprom_dev);
+		goto err_clients;
+	}
+#endif
+
 	i2c_set_clientdata(client, at24);
 
 	dev_info(&client->dev, "%zu byte %s EEPROM, %s, %u bytes/write\n",
 		at24->bin.size, client->name,
 		writable ? "writable" : "read-only", at24->write_max);
@@ -656,10 +672,14 @@ static int at24_remove(struct i2c_client *client)
 	sysfs_remove_bin_file(&client->dev.kobj, &at24->bin);
 
 	for (i = 1; i < at24->num_addresses; i++)
 		i2c_unregister_device(at24->client[i]);
 
+#ifdef CONFIG_EEPROM_CLASS
+	eeprom_device_unregister(at24->eeprom_dev);
+#endif
+
 	return 0;
 }
 
 /*-------------------------------------------------------------------------*/
 
-- 
1.7.10.4

