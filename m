Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752428Ab3BPCiq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Feb 2013 21:38:46 -0500
Received: from mail-pb0-f46.google.com ([209.85.160.46]:49619 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752242Ab3BPCin (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Feb 2013 21:38:43 -0500
Date: Fri, 15 Feb 2013 18:38:41 -0800
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Wolfram Sang <w.sang@pengutronix.de>
Cc: Ben Dooks <ben-linux@fluff.org>, Jean Delvare <khali@linux-fr.org>,
        linux-i2c@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] I2C: add i2c_master_send_exact() and friends
Message-ID: <20130216023840.GA16084@core.coreip.homeip.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Many i2c users consider short transfers to be an error and would prefer
getting -EIO instead of a positive return value and having to convert
it to error code by themselves. So let's add the following new helpers:

	i2c_master_send_exact()
	i2c_master_recv_exact()
	i2c_transfer_exact()

Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
---
 drivers/i2c/i2c-core.c |   69 ++++++++++++++++++++++++++++++++++++++++++++++++
 include/linux/i2c.h    |   11 ++++++++
 2 files changed, 80 insertions(+)

diff --git a/drivers/i2c/i2c-core.c b/drivers/i2c/i2c-core.c
index e388590..6cddb5d 100644
--- a/drivers/i2c/i2c-core.c
+++ b/drivers/i2c/i2c-core.c
@@ -1430,6 +1430,33 @@ int i2c_transfer(struct i2c_adapter *adap, struct i2c_msg *msgs, int num)
 EXPORT_SYMBOL(i2c_transfer);
 
 /**
+ * i2c_transfer_exact - transfer given number of I2C messages
+ * @adap: Handle to I2C bus
+ * @msgs: One or more messages to execute before STOP is issued to
+ *	terminate the operation; each message begins with a START.
+ * @num: Number of messages to be executed.
+ *
+ * Returns negative errno (including -EIO on short transfer),
+ * or 0 if all messages have been tranferred successfully.
+ *
+ * Note that there is no requirement that each message be sent to
+ * the same slave address, although that is the most common model.
+ */
+int i2c_transfer_exact(struct i2c_adapter *adap,
+		       struct i2c_msg *msgs, int num)
+{
+	int ret;
+
+	ret = i2c_transfer(adap, msgs, num);
+	if (ret == num)
+		return 0;
+
+	return ret < 0 ? ret : -EIO;
+
+}
+EXPORT_SYMBOL(i2c_transfer_exact);
+
+/**
  * i2c_master_send - issue a single I2C message in master transmit mode
  * @client: Handle to slave device
  * @buf: Data that will be written to the slave
@@ -1459,6 +1486,27 @@ int i2c_master_send(const struct i2c_client *client, const char *buf, int count)
 EXPORT_SYMBOL(i2c_master_send);
 
 /**
+ * i2c_master_send_exact - send exact number of bytes in master transmit mode
+ * @client: Handle to slave device
+ * @buf: Data that will be written to the slave
+ * @count: How many bytes to write, must be less than 64k since msg.len is u16
+ *
+ * Returns negative errno (including -EIO on short transfer), or 0.
+ */
+int i2c_master_send_exact(const struct i2c_client *client,
+			  const char *buf, int count)
+{
+	int ret;
+
+	ret = i2c_master_send(client, buf, count);
+	if (ret == count)
+		return 0;
+
+	return ret < 0 ? ret : -EIO;
+}
+EXPORT_SYMBOL(i2c_master_send_exact);
+
+/**
  * i2c_master_recv - issue a single I2C message in master receive mode
  * @client: Handle to slave device
  * @buf: Where to store data read from slave
@@ -1488,6 +1536,27 @@ int i2c_master_recv(const struct i2c_client *client, char *buf, int count)
 }
 EXPORT_SYMBOL(i2c_master_recv);
 
+/**
+ * i2c_master_recv_exact - read exact number of bytes in master receive mode
+ * @client: Handle to slave device
+ * @buf: Where to store data read from slave
+ * @count: How many bytes to read, must be less than 64k since msg.len is u16
+ *
+ * Returns negative errno (including -EIO on short transfer), or 0.
+ */
+int i2c_master_recv_exact(const struct i2c_client *client,
+			  char *buf, int count)
+{
+	int ret;
+
+	ret = i2c_master_recv(client, buf, count);
+	if (ret == count)
+		return 0;
+
+	return ret < 0 ? ret : -EIO;
+}
+EXPORT_SYMBOL(i2c_master_recv_exact);
+
 /* ----------------------------------------------------
  * the i2c address scanning function
  * Will not work for 10-bit addresses!
diff --git a/include/linux/i2c.h b/include/linux/i2c.h
index d0c4db7..3d76059 100644
--- a/include/linux/i2c.h
+++ b/include/linux/i2c.h
@@ -59,13 +59,24 @@ struct module;
  */
 extern int i2c_master_send(const struct i2c_client *client, const char *buf,
 			   int count);
+
+extern int i2c_master_send_exact(const struct i2c_client *client,
+				 const char *buf, int count);
+
 extern int i2c_master_recv(const struct i2c_client *client, char *buf,
 			   int count);
 
+extern int i2c_master_recv_exact(const struct i2c_client *client,
+				 char *buf, int count);
+
 /* Transfer num messages.
  */
 extern int i2c_transfer(struct i2c_adapter *adap, struct i2c_msg *msgs,
 			int num);
+
+extern int i2c_transfer_exact(struct i2c_adapter *adap,
+			      struct i2c_msg *msgs, int num);
+
 /* Unlocked flavor */
 extern int __i2c_transfer(struct i2c_adapter *adap, struct i2c_msg *msgs,
 			  int num);
-- 
Dmitry
