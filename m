Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751980AbaAJHoj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Jan 2014 02:44:39 -0500
Received: from mail-pb0-f54.google.com ([209.85.160.54]:45965 "EHLO
	mail-pb0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750893AbaAJHoc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Jan 2014 02:44:32 -0500
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
Subject: [PATCH 2/4] Input: synaptics-rmi4 - rework transport device allocation
Date: Thu,  9 Jan 2014 23:44:25 -0800
Message-Id: <1389339867-8399-2-git-send-email-dmitry.torokhov@gmail.com>
X-Mailer: git-send-email 1.8.4.2
In-Reply-To: <1389339867-8399-1-git-send-email-dmitry.torokhov@gmail.com>
References: <1389339867-8399-1-git-send-email-dmitry.torokhov@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Instead of allocating common and private part of transport device
separately make private wrap common part and get rid of private data
pointer in the transport device.

Also rename rmi_i2c_data -> rmi_i2c_xport and data -> rmi_i2c.

Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
---
 drivers/input/rmi4/rmi_bus.h |   3 --
 drivers/input/rmi4/rmi_i2c.c | 112 +++++++++++++++++++++----------------------
 2 files changed, 56 insertions(+), 59 deletions(-)

diff --git a/drivers/input/rmi4/rmi_bus.h b/drivers/input/rmi4/rmi_bus.h
index ccf26dc..decb479 100644
--- a/drivers/input/rmi4/rmi_bus.h
+++ b/drivers/input/rmi4/rmi_bus.h
@@ -165,7 +165,6 @@ struct rmi_transport_stats {
  * default irq_thread implementation.
  * @hard_irq: if not NULL, the sensor driver will use this for the hard IRQ
  * handling
- * @data: Private data pointer
  * @proto_name: name of the transport protocol (SPI, i2c, etc)
  * @ops: pointer to transport operations implementation
  * @stats: transport statistics
@@ -181,8 +180,6 @@ struct rmi_transport_dev {
 	irqreturn_t (*irq_thread)(int irq, void *p);
 	irqreturn_t (*hard_irq)(int irq, void *p);
 
-	void *data;
-
 	const char *proto_name;
 	const struct rmi_transport_ops *ops;
 	struct rmi_transport_stats stats;
diff --git a/drivers/input/rmi4/rmi_i2c.c b/drivers/input/rmi4/rmi_i2c.c
index 40badf3..cdc8527 100644
--- a/drivers/input/rmi4/rmi_i2c.c
+++ b/drivers/input/rmi4/rmi_i2c.c
@@ -17,22 +17,25 @@
 #define BUFFER_SIZE_INCREMENT 32
 
 /**
- * struct rmi_i2c_data - stores information for i2c communication
+ * struct rmi_i2c_xport - stores information for i2c communication
+ *
+ * @xport: The transport interface structure
  *
  * @page_mutex: Locks current page to avoid changing pages in unexpected ways.
  * @page: Keeps track of the current virtual page
- * @xport: Pointer to the transport interface
  *
  * @tx_buf: Buffer used for transmitting data to the sensor over i2c.
  * @tx_buf_size: Size of the buffer
  */
-struct rmi_i2c_data {
+struct rmi_i2c_xport {
+	struct rmi_transport_dev xport;
+	struct i2c_client *client;
+
 	struct mutex page_mutex;
 	int page;
-	struct rmi_transport_dev *xport;
 
 	u8 *tx_buf;
-	int tx_buf_size;
+	size_t tx_buf_size;
 };
 
 #define RMI_PAGE_SELECT_REGISTER 0xff
@@ -52,10 +55,10 @@ struct rmi_i2c_data {
  *
  * Returns zero on success, non-zero on failure.
  */
-static int rmi_set_page(struct rmi_transport_dev *xport, u8 page)
+static int rmi_set_page(struct rmi_i2c_xport *rmi_i2c, u8 page)
 {
-	struct i2c_client *client = to_i2c_client(xport->dev);
-	struct rmi_i2c_data *data = xport->data;
+	struct rmi_transport_dev *xport = &rmi_i2c->xport;
+	struct i2c_client *client = rmi_i2c->client;
 	u8 txbuf[2] = {RMI_PAGE_SELECT_REGISTER, page};
 	int retval;
 
@@ -70,37 +73,40 @@ static int rmi_set_page(struct rmi_transport_dev *xport, u8 page)
 			"%s: set page failed: %d.", __func__, retval);
 		return (retval < 0) ? retval : -EIO;
 	}
-	data->page = page;
+	rmi_i2c->page = page;
 	return 0;
 }
 
 static int rmi_i2c_write_block(struct rmi_transport_dev *xport, u16 addr,
 			       const void *buf, size_t len)
 {
-	struct i2c_client *client = to_i2c_client(xport->dev);
-	struct rmi_i2c_data *data = xport->data;
+	struct rmi_i2c_xport *rmi_i2c =
+		container_of(xport, struct rmi_i2c_xport, xport);
+	struct i2c_client *client = rmi_i2c->client;
 	size_t tx_size = len + 1;
 	int retval;
 
-	mutex_lock(&data->page_mutex);
-
-	if (!data->tx_buf || data->tx_buf_size < tx_size) {
-		if (data->tx_buf)
-			devm_kfree(&client->dev, data->tx_buf);
-		data->tx_buf_size = tx_size + BUFFER_SIZE_INCREMENT;
-		data->tx_buf = devm_kzalloc(&client->dev, data->tx_buf_size,
-					    GFP_KERNEL);
-		if (!data->tx_buf) {
-			data->tx_buf_size = 0;
+	mutex_lock(&rmi_i2c->page_mutex);
+
+	if (!rmi_i2c->tx_buf || rmi_i2c->tx_buf_size < tx_size) {
+		if (rmi_i2c->tx_buf)
+			devm_kfree(&client->dev, rmi_i2c->tx_buf);
+		rmi_i2c->tx_buf_size = tx_size + BUFFER_SIZE_INCREMENT;
+		rmi_i2c->tx_buf = devm_kzalloc(&client->dev,
+					       rmi_i2c->tx_buf_size,
+					       GFP_KERNEL);
+		if (!rmi_i2c->tx_buf) {
+			rmi_i2c->tx_buf_size = 0;
 			retval = -ENOMEM;
 			goto exit;
 		}
 	}
-	data->tx_buf[0] = addr & 0xff;
-	memcpy(data->tx_buf + 1, buf, len);
 
-	if (RMI_I2C_PAGE(addr) != data->page) {
-		retval = rmi_set_page(xport, RMI_I2C_PAGE(addr));
+	rmi_i2c->tx_buf[0] = addr & 0xff;
+	memcpy(rmi_i2c->tx_buf + 1, buf, len);
+
+	if (RMI_I2C_PAGE(addr) != rmi_i2c->page) {
+		retval = rmi_set_page(rmi_i2c, RMI_I2C_PAGE(addr));
 		if (retval < 0)
 			goto exit;
 	}
@@ -110,29 +116,30 @@ static int rmi_i2c_write_block(struct rmi_transport_dev *xport, u16 addr,
 
 	xport->stats.tx_count++;
 	xport->stats.tx_bytes += tx_size;
-	retval = i2c_master_send(client, data->tx_buf, tx_size);
+	retval = i2c_master_send(client, rmi_i2c->tx_buf, tx_size);
 	if (retval < 0)
 		xport->stats.tx_errs++;
 	else
 		retval--; /* don't count the address byte */
 
 exit:
-	mutex_unlock(&data->page_mutex);
+	mutex_unlock(&rmi_i2c->page_mutex);
 	return retval;
 }
 
 static int rmi_i2c_read_block(struct rmi_transport_dev *xport, u16 addr,
 			      void *buf, size_t len)
 {
-	struct i2c_client *client = to_i2c_client(xport->dev);
-	struct rmi_i2c_data *data = xport->data;
+	struct rmi_i2c_xport *rmi_i2c =
+		container_of(xport, struct rmi_i2c_xport, xport);
+	struct i2c_client *client = rmi_i2c->client;
 	u8 txbuf[1] = {addr & 0xff};
 	int retval;
 
-	mutex_lock(&data->page_mutex);
+	mutex_lock(&rmi_i2c->page_mutex);
 
-	if (RMI_I2C_PAGE(addr) != data->page) {
-		retval = rmi_set_page(xport, RMI_I2C_PAGE(addr));
+	if (RMI_I2C_PAGE(addr) != rmi_i2c->page) {
+		retval = rmi_set_page(rmi_i2c, RMI_I2C_PAGE(addr));
 		if (retval < 0)
 			goto exit;
 	}
@@ -160,7 +167,7 @@ static int rmi_i2c_read_block(struct rmi_transport_dev *xport, u16 addr,
 			len, addr, (int)len, buf);
 
 exit:
-	mutex_unlock(&data->page_mutex);
+	mutex_unlock(&rmi_i2c->page_mutex);
 	return retval;
 }
 
@@ -174,14 +181,14 @@ static int rmi_i2c_probe(struct i2c_client *client,
 {
 	const struct rmi_device_platform_data *pdata =
 				dev_get_platdata(&client->dev);
-	struct rmi_transport_dev *xport;
-	struct rmi_i2c_data *data;
+	struct rmi_i2c_xport *rmi_i2c;
 	int retval;
 
 	if (!pdata) {
 		dev_err(&client->dev, "no platform data\n");
 		return -EINVAL;
 	}
+
 	dev_dbg(&client->dev, "Probing %s at %#02x (GPIO %d).\n",
 		pdata->sensor_name ? pdata->sensor_name : "-no name-",
 		client->addr, pdata->attn_gpio);
@@ -202,44 +209,36 @@ static int rmi_i2c_probe(struct i2c_client *client,
 		}
 	}
 
-	xport = devm_kzalloc(&client->dev, sizeof(struct rmi_transport_dev),
+	rmi_i2c = devm_kzalloc(&client->dev, sizeof(struct rmi_i2c_xport),
 				GFP_KERNEL);
-
-	if (!xport)
+	if (!rmi_i2c)
 		return -ENOMEM;
 
-	data = devm_kzalloc(&client->dev, sizeof(struct rmi_i2c_data),
-				GFP_KERNEL);
-	if (!data)
-		return -ENOMEM;
-
-	data->xport = xport;
-
-	xport->data = data;
-	xport->dev = &client->dev;
+	rmi_i2c->client = client;
+	mutex_init(&rmi_i2c->page_mutex);
 
-	xport->proto_name = "i2c";
-	xport->ops = &rmi_i2c_ops;
-
-	mutex_init(&data->page_mutex);
+	rmi_i2c->xport.dev = &client->dev;
+	rmi_i2c->xport.proto_name = "i2c";
+	rmi_i2c->xport.ops = &rmi_i2c_ops;
 
 	/*
 	 * Setting the page to zero will (a) make sure the PSR is in a
 	 * known state, and (b) make sure we can talk to the device.
 	 */
-	retval = rmi_set_page(xport, 0);
+	retval = rmi_set_page(rmi_i2c, 0);
 	if (retval) {
 		dev_err(&client->dev, "Failed to set page select to 0.\n");
 		return retval;
 	}
 
-	retval = rmi_register_transport_device(xport);
+	retval = rmi_register_transport_device(&rmi_i2c->xport);
 	if (retval) {
 		dev_err(&client->dev, "Failed to register transport driver at 0x%.2X.\n",
 			client->addr);
 		goto err_gpio;
 	}
-	i2c_set_clientdata(client, xport);
+
+	i2c_set_clientdata(client, rmi_i2c);
 
 	dev_info(&client->dev, "registered rmi i2c driver at %#04x.\n",
 			client->addr);
@@ -248,16 +247,17 @@ static int rmi_i2c_probe(struct i2c_client *client,
 err_gpio:
 	if (pdata->gpio_config)
 		pdata->gpio_config(pdata->gpio_data, false);
+
 	return retval;
 }
 
 static int rmi_i2c_remove(struct i2c_client *client)
 {
-	struct rmi_transport_dev *xport = i2c_get_clientdata(client);
 	const struct rmi_device_platform_data *pdata =
 				dev_get_platdata(&client->dev);
+	struct rmi_i2c_xport *rmi_i2c = i2c_get_clientdata(client);
 
-	rmi_unregister_transport_device(xport);
+	rmi_unregister_transport_device(&rmi_i2c->xport);
 
 	if (pdata->gpio_config)
 		pdata->gpio_config(pdata->gpio_data, false);
-- 
1.8.4.2

