Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751762AbaAJHoe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Jan 2014 02:44:34 -0500
Received: from mail-pb0-f52.google.com ([209.85.160.52]:33974 "EHLO
	mail-pb0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750793AbaAJHob (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Jan 2014 02:44:31 -0500
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
Subject: [PATCH 1/4] Input: synaptics-rmi4 - split of transport ops into a separate structure
Date: Thu,  9 Jan 2014 23:44:24 -0800
Message-Id: <1389339867-8399-1-git-send-email-dmitry.torokhov@gmail.com>
X-Mailer: git-send-email 1.8.4.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Split off transport operations from rmi_transport_dev into a separate
structure that will be shared between all devices using the same transport
and use const pointer to access it.

Change signature on transport methods so that length is using the proper
tyep - size_t.

Also rename rmi_transport_info to rmi_transport_stats and move protocol
name (which is the only immutable piece of data there) into the transport
device itself.

Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
---
 drivers/input/rmi4/rmi_bus.h    | 64 ++++++++++++++++++++++++-----------------
 drivers/input/rmi4/rmi_driver.c |  8 +++---
 drivers/input/rmi4/rmi_i2c.c    | 49 ++++++++++++++++---------------
 3 files changed, 67 insertions(+), 54 deletions(-)

diff --git a/drivers/input/rmi4/rmi_bus.h b/drivers/input/rmi4/rmi_bus.h
index 3e8b57a..ccf26dc 100644
--- a/drivers/input/rmi4/rmi_bus.h
+++ b/drivers/input/rmi4/rmi_bus.h
@@ -135,26 +135,25 @@ struct rmi_driver {
 #define to_rmi_driver(d) \
 	container_of(d, struct rmi_driver, driver);
 
-/** struct rmi_transport_info - diagnostic information about the RMI transport
+/**
+ * struct rmi_transport_stats - diagnostic information about the RMI transport
  * device, used in the xport_info debugfs file.
  *
  * @proto String indicating the protocol being used.
  * @tx_count Number of transmit operations.
- * @tx_bytes Number of bytes transmitted.
  * @tx_errs  Number of errors encountered during transmit operations.
+ * @tx_bytes Number of bytes transmitted.
  * @rx_count Number of receive operations.
- * @rx_bytes Number of bytes received.
  * @rx_errs  Number of errors encountered during receive operations.
- * @att_count Number of times ATTN assertions have been handled.
+ * @rx_bytes Number of bytes received.
  */
-struct rmi_transport_info {
-	const char *proto;
-	long tx_count;
-	long tx_bytes;
-	long tx_errs;
-	long rx_count;
-	long rx_bytes;
-	long rx_errs;
+struct rmi_transport_stats {
+	unsigned long tx_count;
+	unsigned long tx_errs;
+	size_t tx_bytes;
+	unsigned long rx_count;
+	unsigned long rx_errs;
+	size_t rx_bytes;
 };
 
 /**
@@ -162,13 +161,14 @@ struct rmi_transport_info {
  *
  * @dev: Pointer to the communication device, e.g. i2c or spi
  * @rmi_dev: Pointer to the RMI device
- * @write_block: Writing a block of data to the specified address
- * @read_block: Read a block of data from the specified address.
  * @irq_thread: if not NULL, the sensor driver will use this instead of the
  * default irq_thread implementation.
  * @hard_irq: if not NULL, the sensor driver will use this for the hard IRQ
  * handling
  * @data: Private data pointer
+ * @proto_name: name of the transport protocol (SPI, i2c, etc)
+ * @ops: pointer to transport operations implementation
+ * @stats: transport statistics
  *
  * The RMI transport device implements the glue between different communication
  * buses such as I2C and SPI.
@@ -178,20 +178,30 @@ struct rmi_transport_dev {
 	struct device *dev;
 	struct rmi_device *rmi_dev;
 
-	int (*write_block)(struct rmi_transport_dev *xport, u16 addr,
-			   const void *buf, const int len);
-	int (*read_block)(struct rmi_transport_dev *xport, u16 addr,
-			  void *buf, const int len);
-
-	int (*enable_device) (struct rmi_transport_dev *xport);
-	void (*disable_device) (struct rmi_transport_dev *xport);
-
 	irqreturn_t (*irq_thread)(int irq, void *p);
 	irqreturn_t (*hard_irq)(int irq, void *p);
 
 	void *data;
 
-	struct rmi_transport_info info;
+	const char *proto_name;
+	const struct rmi_transport_ops *ops;
+	struct rmi_transport_stats stats;
+};
+
+/**
+ * struct rmi_transport_ops - defines transport protocol operations.
+ *
+ * @write_block: Writing a block of data to the specified address
+ * @read_block: Read a block of data from the specified address.
+ */
+struct rmi_transport_ops {
+	int (*write_block)(struct rmi_transport_dev *xport, u16 addr,
+			   const void *buf, size_t len);
+	int (*read_block)(struct rmi_transport_dev *xport, u16 addr,
+			  void *buf, size_t len);
+
+	int (*enable_device) (struct rmi_transport_dev *xport);
+	void (*disable_device) (struct rmi_transport_dev *xport);
 };
 
 /**
@@ -232,7 +242,7 @@ bool rmi_is_physical_device(struct device *dev);
  */
 static inline int rmi_read(struct rmi_device *d, u16 addr, void *buf)
 {
-	return d->xport->read_block(d->xport, addr, buf, 1);
+	return d->xport->ops->read_block(d->xport, addr, buf, 1);
 }
 
 /**
@@ -248,7 +258,7 @@ static inline int rmi_read(struct rmi_device *d, u16 addr, void *buf)
 static inline int rmi_read_block(struct rmi_device *d, u16 addr, void *buf,
 				 const int len)
 {
-	return d->xport->read_block(d->xport, addr, buf, len);
+	return d->xport->ops->read_block(d->xport, addr, buf, len);
 }
 
 /**
@@ -262,7 +272,7 @@ static inline int rmi_read_block(struct rmi_device *d, u16 addr, void *buf,
  */
 static inline int rmi_write(struct rmi_device *d, u16 addr, const u8 data)
 {
-	return d->xport->write_block(d->xport, addr, &data, 1);
+	return d->xport->ops->write_block(d->xport, addr, &data, 1);
 }
 
 /**
@@ -278,7 +288,7 @@ static inline int rmi_write(struct rmi_device *d, u16 addr, const u8 data)
 static inline int rmi_write_block(struct rmi_device *d, u16 addr,
 				  const void *buf, const int len)
 {
-	return d->xport->write_block(d->xport, addr, buf, len);
+	return d->xport->ops->write_block(d->xport, addr, buf, len);
 }
 
 int rmi_register_transport_device(struct rmi_transport_dev *xport);
diff --git a/drivers/input/rmi4/rmi_driver.c b/drivers/input/rmi4/rmi_driver.c
index eb790ff..3483e5b 100644
--- a/drivers/input/rmi4/rmi_driver.c
+++ b/drivers/input/rmi4/rmi_driver.c
@@ -126,8 +126,8 @@ static void disable_sensor(struct rmi_device *rmi_dev)
 	if (!data->irq)
 		disable_polling(rmi_dev);
 
-	if (rmi_dev->xport->disable_device)
-		rmi_dev->xport->disable_device(rmi_dev->xport);
+	if (rmi_dev->xport->ops->disable_device)
+		rmi_dev->xport->ops->disable_device(rmi_dev->xport);
 
 	if (data->irq) {
 		disable_irq(data->irq);
@@ -146,8 +146,8 @@ static int enable_sensor(struct rmi_device *rmi_dev)
 	if (data->enabled)
 		return 0;
 
-	if (rmi_dev->xport->enable_device) {
-		retval = rmi_dev->xport->enable_device(rmi_dev->xport);
+	if (rmi_dev->xport->ops->enable_device) {
+		retval = rmi_dev->xport->ops->enable_device(rmi_dev->xport);
 		if (retval)
 			return retval;
 	}
diff --git a/drivers/input/rmi4/rmi_i2c.c b/drivers/input/rmi4/rmi_i2c.c
index 12aea8c..40badf3 100644
--- a/drivers/input/rmi4/rmi_i2c.c
+++ b/drivers/input/rmi4/rmi_i2c.c
@@ -61,11 +61,11 @@ static int rmi_set_page(struct rmi_transport_dev *xport, u8 page)
 
 	dev_dbg(&client->dev, "writes 3 bytes: %02x %02x\n",
 			txbuf[0], txbuf[1]);
-	xport->info.tx_count++;
-	xport->info.tx_bytes += sizeof(txbuf);
+	xport->stats.tx_count++;
+	xport->stats.tx_bytes += sizeof(txbuf);
 	retval = i2c_master_send(client, txbuf, sizeof(txbuf));
 	if (retval != sizeof(txbuf)) {
-		xport->info.tx_errs++;
+		xport->stats.tx_errs++;
 		dev_err(&client->dev,
 			"%s: set page failed: %d.", __func__, retval);
 		return (retval < 0) ? retval : -EIO;
@@ -75,12 +75,12 @@ static int rmi_set_page(struct rmi_transport_dev *xport, u8 page)
 }
 
 static int rmi_i2c_write_block(struct rmi_transport_dev *xport, u16 addr,
-			       const void *buf, const int len)
+			       const void *buf, size_t len)
 {
 	struct i2c_client *client = to_i2c_client(xport->dev);
 	struct rmi_i2c_data *data = xport->data;
+	size_t tx_size = len + 1;
 	int retval;
-	int tx_size = len + 1;
 
 	mutex_lock(&data->page_mutex);
 
@@ -106,13 +106,13 @@ static int rmi_i2c_write_block(struct rmi_transport_dev *xport, u16 addr,
 	}
 
 	dev_dbg(&client->dev,
-		"writes %d bytes at %#06x: %*ph\n", len, addr, len, buf);
+		"writes %zd bytes at %#06x: %*ph\n", len, addr, (int)len, buf);
 
-	xport->info.tx_count++;
-	xport->info.tx_bytes += tx_size;
+	xport->stats.tx_count++;
+	xport->stats.tx_bytes += tx_size;
 	retval = i2c_master_send(client, data->tx_buf, tx_size);
 	if (retval < 0)
-		xport->info.tx_errs++;
+		xport->stats.tx_errs++;
 	else
 		retval--; /* don't count the address byte */
 
@@ -121,9 +121,8 @@ exit:
 	return retval;
 }
 
-
 static int rmi_i2c_read_block(struct rmi_transport_dev *xport, u16 addr,
-			      void *buf, const int len)
+			      void *buf, size_t len)
 {
 	struct i2c_client *client = to_i2c_client(xport->dev);
 	struct rmi_i2c_data *data = xport->data;
@@ -140,31 +139,36 @@ static int rmi_i2c_read_block(struct rmi_transport_dev *xport, u16 addr,
 
 	dev_dbg(&client->dev, "writes 1 bytes: %02x\n", txbuf[0]);
 
-	xport->info.tx_count++;
-	xport->info.tx_bytes += sizeof(txbuf);
+	xport->stats.tx_count++;
+	xport->stats.tx_bytes += sizeof(txbuf);
 	retval = i2c_master_send(client, txbuf, sizeof(txbuf));
 	if (retval != sizeof(txbuf)) {
-		xport->info.tx_errs++;
+		xport->stats.tx_errs++;
 		retval = (retval < 0) ? retval : -EIO;
 		goto exit;
 	}
 
-	retval = i2c_master_recv(client, buf, len);
+	xport->stats.rx_count++;
+	xport->stats.rx_bytes += len;
 
-	xport->info.rx_count++;
-	xport->info.rx_bytes += len;
+	retval = i2c_master_recv(client, buf, len);
 	if (retval < 0)
-		xport->info.rx_errs++;
+		xport->stats.rx_errs++;
 	else
 		dev_dbg(&client->dev,
-			"read %d bytes at %#06x: %*ph\n",
-			len, addr, len, buf);
+			"read %zd bytes at %#06x: %*ph\n",
+			len, addr, (int)len, buf);
 
 exit:
 	mutex_unlock(&data->page_mutex);
 	return retval;
 }
 
+static const struct rmi_transport_ops rmi_i2c_ops = {
+	.write_block	= rmi_i2c_write_block,
+	.read_block	= rmi_i2c_read_block,
+};
+
 static int rmi_i2c_probe(struct i2c_client *client,
 			 const struct i2c_device_id *id)
 {
@@ -214,9 +218,8 @@ static int rmi_i2c_probe(struct i2c_client *client,
 	xport->data = data;
 	xport->dev = &client->dev;
 
-	xport->write_block = rmi_i2c_write_block;
-	xport->read_block = rmi_i2c_read_block;
-	xport->info.proto = "i2c";
+	xport->proto_name = "i2c";
+	xport->ops = &rmi_i2c_ops;
 
 	mutex_init(&data->page_mutex);
 
-- 
1.8.4.2

