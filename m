Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757574AbaGANAm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jul 2014 09:00:42 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:45119 "EHLO
	out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753225AbaGANAX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jul 2014 09:00:23 -0400
X-Sasl-enc: hj/KtRN1JOyxF8MqD1L6olciWfXSfBa3ePuIgs0yzRE/ 1404219622
From: Michalis Pappas <mpappas@fastmail.fm>
To: gregkh@linuxfoundation.org
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: [PATCH] staging: gdm72xx: conditionally compile debug code
Date: Tue,  1 Jul 2014 14:00:15 +0100
Message-Id: <1404219616-1788-2-git-send-email-mpappas@fastmail.fm>
X-Mailer: git-send-email 1.8.4
In-Reply-To: <1404219616-1788-1-git-send-email-mpappas@fastmail.fm>
References: <1404219616-1788-1-git-send-email-mpappas@fastmail.fm>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Michalis Pappas <mpappas@fastmail.fm>
---
 drivers/staging/gdm72xx/gdm_qos.c   | 2 ++
 drivers/staging/gdm72xx/gdm_sdio.c  | 7 +++++++
 drivers/staging/gdm72xx/gdm_usb.c   | 7 +++++++
 drivers/staging/gdm72xx/gdm_wimax.c | 6 ++++++
 drivers/staging/gdm72xx/gdm_wimax.h | 2 ++
 5 files changed, 24 insertions(+)

diff --git a/drivers/staging/gdm72xx/gdm_qos.c b/drivers/staging/gdm72xx/gdm_qos.c
index b08c8e1..7900981 100644
--- a/drivers/staging/gdm72xx/gdm_qos.c
+++ b/drivers/staging/gdm72xx/gdm_qos.c
@@ -88,7 +88,9 @@ static void free_qos_entry_list(struct list_head *free_list)
 		total_free++;
 	}
 
+	#if defined(GDM72xx_DEBUG)
 	pr_debug("%s: total_free_cnt=%d\n", __func__, total_free);
+	#endif
 }
 
 void gdm_qos_init(void *nic_ptr)
diff --git a/drivers/staging/gdm72xx/gdm_sdio.c b/drivers/staging/gdm72xx/gdm_sdio.c
index 9d2de6f..914fd75 100644
--- a/drivers/staging/gdm72xx/gdm_sdio.c
+++ b/drivers/staging/gdm72xx/gdm_sdio.c
@@ -280,9 +280,11 @@ static void send_sdu(struct sdio_func *func, struct tx_cxt *tx)
 
 	spin_unlock_irqrestore(&tx->lock, flags);
 
+	#if defined(GDM72xx_DEBUG)
 	print_hex_dump_debug("sdio_send: ", DUMP_PREFIX_NONE, 16, 1,
 			     tx->sdu_buf + TYPE_A_HEADER_SIZE,
 			     aggr_len - TYPE_A_HEADER_SIZE, false);
+	#endif
 
 	for (pos = TYPE_A_HEADER_SIZE; pos < aggr_len; pos += TX_CHUNK_SIZE) {
 		len = aggr_len - pos;
@@ -317,9 +319,12 @@ static void send_hci(struct sdio_func *func, struct tx_cxt *tx,
 {
 	unsigned long flags;
 
+	#if defined(GDM72xx_DEBUG)
 	print_hex_dump_debug("sdio_send: ", DUMP_PREFIX_NONE, 16, 1,
 			     t->buf + TYPE_A_HEADER_SIZE,
 			     t->len - TYPE_A_HEADER_SIZE, false);
+	#endif
+
 	send_sdio_pkt(func, t->buf, t->len);
 
 	spin_lock_irqsave(&tx->lock, flags);
@@ -551,8 +556,10 @@ static void gdm_sdio_irq(struct sdio_func *func)
 	}
 
 end_io:
+	#if defined(GDM72xx_DEBUG)
 	print_hex_dump_debug("sdio_receive: ", DUMP_PREFIX_NONE, 16, 1,
 			     rx->rx_buf, len, false);
+	#endif
 	len = control_sdu_tx_flow(sdev, rx->rx_buf, len);
 
 	spin_lock_irqsave(&rx->lock, flags);
diff --git a/drivers/staging/gdm72xx/gdm_usb.c b/drivers/staging/gdm72xx/gdm_usb.c
index 971976c..bfd347a 100644
--- a/drivers/staging/gdm72xx/gdm_usb.c
+++ b/drivers/staging/gdm72xx/gdm_usb.c
@@ -348,8 +348,11 @@ static int gdm_usb_send(void *priv_dev, void *data, int len,
 	usb_fill_bulk_urb(t->urb, usbdev, usb_sndbulkpipe(usbdev, 1), t->buf,
 			  len + padding, gdm_usb_send_complete, t);
 
+	#if defined(GDM72xx_DEBUG)
 	print_hex_dump_debug("usb_send: ", DUMP_PREFIX_NONE, 16, 1, t->buf,
 			     len + padding, false);
+	#endif
+
 #ifdef CONFIG_WIMAX_GDM72XX_USB_PM
 	if (usbdev->state & USB_STATE_SUSPENDED) {
 		list_add_tail(&t->p_list, &tx->pending_list);
@@ -427,8 +430,12 @@ static void gdm_usb_rcv_complete(struct urb *urb)
 
 	if (!urb->status) {
 		cmd_evt = (r->buf[0] << 8) | (r->buf[1]);
+
+		#if defined(GDM72xx_DEBUG)
 		print_hex_dump_debug("usb_receive: ", DUMP_PREFIX_NONE, 16, 1,
 				     r->buf, urb->actual_length, false);
+		#endif
+
 		if (cmd_evt == WIMAX_SDU_TX_FLOW) {
 			if (r->buf[4] == 0) {
 				dev_dbg(&dev->dev, "WIMAX ==> STOP SDU TX\n");
diff --git a/drivers/staging/gdm72xx/gdm_wimax.c b/drivers/staging/gdm72xx/gdm_wimax.c
index c2e6bfe..63a760b 100644
--- a/drivers/staging/gdm72xx/gdm_wimax.c
+++ b/drivers/staging/gdm72xx/gdm_wimax.c
@@ -61,6 +61,7 @@ static u8 gdm_wimax_macaddr[6] = {0x00, 0x0a, 0x3b, 0xf0, 0x01, 0x30};
 static void gdm_wimax_ind_fsm_update(struct net_device *dev, struct fsm_s *fsm);
 static void gdm_wimax_ind_if_updown(struct net_device *dev, int if_up);
 
+#if defined(GDM72xx_DEBUG)
 static const char *get_protocol_name(u16 protocol)
 {
 	static char buf[32];
@@ -162,6 +163,7 @@ static void dump_eth_packet(struct net_device *dev, const char *title,
 
 	print_hex_dump_debug("", DUMP_PREFIX_NONE, 16, 1, data, len, false);
 }
+#endif
 
 static inline int gdm_wimax_header(struct sk_buff **pskb)
 {
@@ -369,7 +371,9 @@ static int gdm_wimax_tx(struct sk_buff *skb, struct net_device *dev)
 {
 	int ret = 0;
 
+	#if defined(GDM72xx_DEBUG)
 	dump_eth_packet(dev, "TX", skb->data, skb->len);
+	#endif
 
 	ret = gdm_wimax_header(&skb);
 	if (ret < 0) {
@@ -698,7 +702,9 @@ static void gdm_wimax_netif_rx(struct net_device *dev, char *buf, int len)
 	struct sk_buff *skb;
 	int ret;
 
+	#if defined(GDM72xx_DEBUG)
 	dump_eth_packet(dev, "RX", buf, len);
+	#endif
 
 	skb = dev_alloc_skb(len + 2);
 	if (!skb) {
diff --git a/drivers/staging/gdm72xx/gdm_wimax.h b/drivers/staging/gdm72xx/gdm_wimax.h
index 7e2c888..4670729 100644
--- a/drivers/staging/gdm72xx/gdm_wimax.h
+++ b/drivers/staging/gdm72xx/gdm_wimax.h
@@ -23,6 +23,8 @@
 
 #define DRIVER_VERSION		"3.2.3"
 
+/* #define GDM72xx_DEBUG	1 */
+
 #define H2L(x)		__cpu_to_le16(x)
 #define L2H(x)		__le16_to_cpu(x)
 #define DH2L(x)		__cpu_to_le32(x)
-- 
1.8.4

