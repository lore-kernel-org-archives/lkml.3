Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752024AbaC2Add (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Mar 2014 20:33:33 -0400
Received: from ring0.de ([5.45.105.125]:43050 "EHLO ring0.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751919AbaC2AdF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Mar 2014 20:33:05 -0400
X-Spam-Report: * -0.0 NO_RELAYS Informational: message was not relayed via SMTP
	* -1.9 BAYES_00 BODY: Spamwahrscheinlichkeit nach Bayes-Test: 0-1%
	*      [score: 0.0000]
	* -0.0 NO_RECEIVED Informational: message has no Received headers
From: Sebastian Reichel <sre@kernel.org>
To: Sebastian Reichel <sre@ring0.de>, Linus Walleij <linus.walleij@linaro.org>,
        Shubhrajyoti Datta <omaplinuxkernel@gmail.com>,
        Carlos Chinea <cch.devel@gmail.com>
Cc: Tony Lindgren <tony@atomide.com>, Rob Herring <robh+dt@kernel.org>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Kumar Gala <galak@codeaurora.org>, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-omap@vger.kernel.org,
        =?UTF-8?q?Pali=20Roh=C3=A1r?= <pali.rohar@gmail.com>,
        =?UTF-8?q?=D0=98=D0=B2=D0=B0=D0=B9=D0=BB=D0=BE=20=D0=94=D0=B8=D0=BC=D0=B8=D1=82=D1=80=D0=BE=D0=B2?= 
	<freemangordon@abv.bg>,
        Joni Lapilainen <joni.lapilainen@gmail.com>,
        Aaro Koskinen <aaro.koskinen@iki.fi>,
        Sebastian Reichel <sre@kernel.org>
Subject: [PATCHv3 05/14] HSI: Add channel resource support to HSI clients
Date: Sat, 29 Mar 2014 01:31:41 +0100
Message-Id: <1396053110-21639-6-git-send-email-sre@kernel.org>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <1396053110-21639-1-git-send-email-sre@kernel.org>
References: <1396053110-21639-1-git-send-email-sre@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Make HSI channel ids platform data, which can be provided
by platform data.

Signed-off-by: Sebastian Reichel <sre@kernel.org>
---
 drivers/hsi/clients/hsi_char.c | 12 +++++------
 drivers/hsi/hsi.c              | 49 +++++++++++++++++++++++++++++++++++++++++-
 include/linux/hsi/hsi.h        | 24 +++++++++++++++++----
 3 files changed, 74 insertions(+), 11 deletions(-)

diff --git a/drivers/hsi/clients/hsi_char.c b/drivers/hsi/clients/hsi_char.c
index 3073320..57f70c2 100644
--- a/drivers/hsi/clients/hsi_char.c
+++ b/drivers/hsi/clients/hsi_char.c
@@ -367,7 +367,7 @@ static int hsc_rx_set(struct hsi_client *cl, struct hsc_rx_config *rxc)
 		return -EINVAL;
 	tmp = cl->rx_cfg;
 	cl->rx_cfg.mode = rxc->mode;
-	cl->rx_cfg.channels = rxc->channels;
+	cl->rx_cfg.num_hw_channels = rxc->channels;
 	cl->rx_cfg.flow = rxc->flow;
 	ret = hsi_setup(cl);
 	if (ret < 0) {
@@ -383,7 +383,7 @@ static int hsc_rx_set(struct hsi_client *cl, struct hsc_rx_config *rxc)
 static inline void hsc_rx_get(struct hsi_client *cl, struct hsc_rx_config *rxc)
 {
 	rxc->mode = cl->rx_cfg.mode;
-	rxc->channels = cl->rx_cfg.channels;
+	rxc->channels = cl->rx_cfg.num_hw_channels;
 	rxc->flow = cl->rx_cfg.flow;
 }
 
@@ -402,7 +402,7 @@ static int hsc_tx_set(struct hsi_client *cl, struct hsc_tx_config *txc)
 		return -EINVAL;
 	tmp = cl->tx_cfg;
 	cl->tx_cfg.mode = txc->mode;
-	cl->tx_cfg.channels = txc->channels;
+	cl->tx_cfg.num_hw_channels = txc->channels;
 	cl->tx_cfg.speed = txc->speed;
 	cl->tx_cfg.arb_mode = txc->arb_mode;
 	ret = hsi_setup(cl);
@@ -417,7 +417,7 @@ static int hsc_tx_set(struct hsi_client *cl, struct hsc_tx_config *txc)
 static inline void hsc_tx_get(struct hsi_client *cl, struct hsc_tx_config *txc)
 {
 	txc->mode = cl->tx_cfg.mode;
-	txc->channels = cl->tx_cfg.channels;
+	txc->channels = cl->tx_cfg.num_hw_channels;
 	txc->speed = cl->tx_cfg.speed;
 	txc->arb_mode = cl->tx_cfg.arb_mode;
 }
@@ -435,7 +435,7 @@ static ssize_t hsc_read(struct file *file, char __user *buf, size_t len,
 		return -EINVAL;
 	if (len > max_data_size)
 		len = max_data_size;
-	if (channel->ch >= channel->cl->rx_cfg.channels)
+	if (channel->ch >= channel->cl->rx_cfg.num_hw_channels)
 		return -ECHRNG;
 	if (test_and_set_bit(HSC_CH_READ, &channel->flags))
 		return -EBUSY;
@@ -492,7 +492,7 @@ static ssize_t hsc_write(struct file *file, const char __user *buf, size_t len,
 		return -EINVAL;
 	if (len > max_data_size)
 		len = max_data_size;
-	if (channel->ch >= channel->cl->tx_cfg.channels)
+	if (channel->ch >= channel->cl->tx_cfg.num_hw_channels)
 		return -ECHRNG;
 	if (test_and_set_bit(HSC_CH_WRITE, &channel->flags))
 		return -EBUSY;
diff --git a/drivers/hsi/hsi.c b/drivers/hsi/hsi.c
index e96a987..9d1130d 100644
--- a/drivers/hsi/hsi.c
+++ b/drivers/hsi/hsi.c
@@ -62,18 +62,39 @@ static struct bus_type hsi_bus_type = {
 
 static void hsi_client_release(struct device *dev)
 {
-	kfree(to_hsi_client(dev));
+	struct hsi_client *cl = to_hsi_client(dev);
+
+	if (cl->tx_cfg.channels)
+		kfree(cl->tx_cfg.channels);
+	if (cl->rx_cfg.channels && cl->rx_cfg.channels != cl->tx_cfg.channels)
+		kfree(cl->rx_cfg.channels);
+
+	kfree(cl);
 }
 
 static void hsi_new_client(struct hsi_port *port, struct hsi_board_info *info)
 {
 	struct hsi_client *cl;
+	size_t size;
 
 	cl = kzalloc(sizeof(*cl), GFP_KERNEL);
 	if (!cl)
 		return;
+
 	cl->tx_cfg = info->tx_cfg;
+	if (cl->tx_cfg.channels) {
+		size = cl->tx_cfg.num_channels * sizeof(*cl->tx_cfg.channels);
+		cl->tx_cfg.channels = kzalloc(size , GFP_KERNEL);
+		memcpy(cl->tx_cfg.channels, info->tx_cfg.channels, size);
+	}
+
 	cl->rx_cfg = info->rx_cfg;
+	if (cl->rx_cfg.channels) {
+		size = cl->rx_cfg.num_channels * sizeof(*cl->rx_cfg.channels);
+		cl->rx_cfg.channels = kzalloc(size , GFP_KERNEL);
+		memcpy(cl->rx_cfg.channels, info->rx_cfg.channels, size);
+	}
+
 	cl->device.bus = &hsi_bus_type;
 	cl->device.parent = &port->device;
 	cl->device.release = hsi_client_release;
@@ -502,6 +523,32 @@ int hsi_event(struct hsi_port *port, unsigned long event)
 }
 EXPORT_SYMBOL_GPL(hsi_event);
 
+/**
+ * hsi_get_channel_id_by_name - acquire channel id by channel name
+ * @cl: HSI client, which uses the channel
+ * @name: name the channel is known under
+ *
+ * Clients can call this function to get the hsi channel ids similar to
+ * requesting IRQs or GPIOs by name. This function assumes the same
+ * channel configuration is used for RX and TX.
+ *
+ * Returns -errno on error or channel id on success.
+ */
+int hsi_get_channel_id_by_name(struct hsi_client *cl, char *name)
+{
+	int i;
+
+	if (!cl->rx_cfg.channels)
+		return -ENOENT;
+
+	for (i=0; i < cl->rx_cfg.num_channels; i++)
+		if (!strcmp(cl->rx_cfg.channels[i].name, name))
+			return cl->rx_cfg.channels[i].id;
+
+	return -ENXIO;
+}
+EXPORT_SYMBOL_GPL(hsi_get_channel_id_by_name);
+
 static int __init hsi_init(void)
 {
 	return bus_register(&hsi_bus_type);
diff --git a/include/linux/hsi/hsi.h b/include/linux/hsi/hsi.h
index 2b1912f..50a85a9 100644
--- a/include/linux/hsi/hsi.h
+++ b/include/linux/hsi/hsi.h
@@ -68,17 +68,31 @@ enum {
 };
 
 /**
+ * struct hsi_channel - channel resource used by the hsi clients
+ * @id: Channel number
+ * @name: Channel name
+ */
+struct hsi_channel {
+	unsigned int	id;
+	const char	*name;
+};
+
+/**
  * struct hsi_config - Configuration for RX/TX HSI modules
  * @mode: Bit transmission mode (STREAM or FRAME)
- * @channels: Number of channels to use [1..16]
+ * @channels: Channel resources used by the client
+ * @num_channels: Number of channel resources
+ * @num_hw_channels: Number of channels the transceiver is configured for [1..16]
  * @speed: Max bit transmission speed (Kbit/s)
  * @flow: RX flow type (SYNCHRONIZED or PIPELINE)
  * @arb_mode: Arbitration mode for TX frame (Round robin, priority)
  */
 struct hsi_config {
-	unsigned int	mode;
-	unsigned int	channels;
-	unsigned int	speed;
+	unsigned int		mode;
+	struct hsi_channel	*channels;
+	unsigned int		num_channels;
+	unsigned int		num_hw_channels;
+	unsigned int		speed;
 	union {
 		unsigned int	flow;		/* RX only */
 		unsigned int	arb_mode;	/* TX only */
@@ -306,6 +320,8 @@ static inline struct hsi_port *hsi_find_port_num(struct hsi_controller *hsi,
  */
 int hsi_async(struct hsi_client *cl, struct hsi_msg *msg);
 
+int hsi_get_channel_id_by_name(struct hsi_client *cl, char *name);
+
 /**
  * hsi_id - Get HSI controller ID associated to a client
  * @cl: Pointer to a HSI client
-- 
1.9.0

