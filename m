Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932623AbaIIOye (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Sep 2014 10:54:34 -0400
Received: from sauhun.de ([89.238.76.85]:34778 "EHLO pokefinder.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757330AbaIIOyZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Sep 2014 10:54:25 -0400
From: Wolfram Sang <wsa@the-dreams.de>
To: linux-i2c@vger.kernel.org
Cc: linux-sh@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, Jean Delvare <jdelvare@suse.de>,
        Magnus Damm <magnus.damm@gmail.com>
Subject: [RFC 1/4] i2c: core changes for slave support
Date: Tue,  9 Sep 2014 16:54:27 +0200
Message-Id: <1410274470-12712-2-git-send-email-wsa@the-dreams.de>
X-Mailer: git-send-email 2.0.0
In-Reply-To: <1410274470-12712-1-git-send-email-wsa@the-dreams.de>
References: <1410274470-12712-1-git-send-email-wsa@the-dreams.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Wolfram Sang <wsa+renesas@sang-engineering.com>

Signed-off-by: Wolfram Sang <wsa+renesas@sang-engineering.com>
---
 drivers/i2c/i2c-core.c | 44 ++++++++++++++++++++++++++++++++++++++++++++
 include/linux/i2c.h    | 22 ++++++++++++++++++++++
 2 files changed, 66 insertions(+)

diff --git a/drivers/i2c/i2c-core.c b/drivers/i2c/i2c-core.c
index 632057a44615..6713d438539b 100644
--- a/drivers/i2c/i2c-core.c
+++ b/drivers/i2c/i2c-core.c
@@ -27,6 +27,7 @@
    OF support is copyright (c) 2008 Jochen Friedrich <jochen@scram.de>
    (based on a previous patch from Jon Smirl <jonsmirl@gmail.com>) and
    (c) 2013  Wolfram Sang <wsa@the-dreams.de>
+   I2C slave support (c) 2014 by Wolfram Sang <wsa@sang-engineering.com> 
  */
 
 #include <linux/module.h>
@@ -2536,6 +2537,49 @@ trace:
 }
 EXPORT_SYMBOL(i2c_smbus_xfer);
 
+int i2c_slave_register(struct i2c_client *client, i2c_slave_cb_t slave_cb)
+{
+	int ret;
+
+	if (!client || !slave_cb)
+		return -EINVAL;
+
+	if (!(client->flags & I2C_CLIENT_TEN)) {
+		/* Enforce stricter address checking */
+		ret = i2c_check_addr_validity(client->addr);
+		if (ret)
+			return ret;
+	}
+
+	if (!client->adapter->algo->reg_slave)
+		return -EOPNOTSUPP;
+
+	client->slave_cb = slave_cb;
+
+	ret = client->adapter->algo->reg_slave(client);
+	if (ret)
+		client->slave_cb = NULL;
+
+	return ret;
+}
+EXPORT_SYMBOL_GPL(i2c_slave_register);
+
+int i2c_slave_unregister(struct i2c_client *client)
+{
+	int ret;
+
+	if (!client->adapter->algo->unreg_slave)
+		return -EOPNOTSUPP;
+
+	ret = client->adapter->algo->unreg_slave(client);
+
+	if (ret == 0)
+		client->slave_cb = NULL;
+
+	return ret;
+}
+EXPORT_SYMBOL_GPL(i2c_slave_unregister);
+
 MODULE_AUTHOR("Simon G. Vogl <simon@tk.uni-linz.ac.at>");
 MODULE_DESCRIPTION("I2C-Bus main module");
 MODULE_LICENSE("GPL");
diff --git a/include/linux/i2c.h b/include/linux/i2c.h
index a95efeb53a8b..11d4edb1ab3e 100644
--- a/include/linux/i2c.h
+++ b/include/linux/i2c.h
@@ -121,6 +121,24 @@ extern s32 i2c_smbus_write_i2c_block_data(const struct i2c_client *client,
 					  const u8 *values);
 #endif /* I2C */
 
+/* I2C slave support */
+
+enum i2c_slave_event {
+	I2C_SLAVE_REQ_READ_START,
+	I2C_SLAVE_REQ_READ_END,
+	I2C_SLAVE_REQ_WRITE_START,
+	I2C_SLAVE_REQ_WRITE_END,
+	I2C_SLAVE_STOP,
+};
+
+typedef int (*i2c_slave_cb_t)(struct i2c_client *, enum i2c_slave_event, u8 *);
+
+extern int i2c_slave_register(struct i2c_client *client, i2c_slave_cb_t slave_cb);
+extern int i2c_slave_unregister(struct i2c_client *client);
+
+#define i2c_slave_event(__client, __event, __value) \
+	__client->slave_cb(__client, __event, __value)
+
 /**
  * struct i2c_driver - represent an I2C device driver
  * @class: What kind of i2c device we instantiate (for detect)
@@ -224,6 +242,7 @@ struct i2c_client {
 	struct device dev;		/* the device structure		*/
 	int irq;			/* irq issued by device		*/
 	struct list_head detected;
+	i2c_slave_cb_t slave_cb;	/* callback for slave mode	*/
 };
 #define to_i2c_client(d) container_of(d, struct i2c_client, dev)
 
@@ -377,6 +396,9 @@ struct i2c_algorithm {
 
 	/* To determine what the adapter supports */
 	u32 (*functionality) (struct i2c_adapter *);
+
+	int (*reg_slave)(struct i2c_client *client);
+	int (*unreg_slave)(struct i2c_client *client);
 };
 
 /**
-- 
2.0.0

