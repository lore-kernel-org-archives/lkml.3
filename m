Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964778AbaGQQKB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jul 2014 12:10:01 -0400
Received: from out3-smtp.messagingengine.com ([66.111.4.27]:43000 "EHLO
	out3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757016AbaGQQJ6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jul 2014 12:09:58 -0400
X-Sasl-enc: Ayaaji9avH/1aAtOgw766LlNyIy5vCsNNaQVEsYimiNu 1405613398
From: Michalis Pappas <mpappas@fastmail.fm>
To: gregkh@linuxfoundation.org
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        benchan@chromium.org
Subject: [PATCH] staging: gdm72xx: replace print_hex_dump_debug() with dev_dbg()
Date: Thu, 17 Jul 2014 17:09:39 +0100
Message-Id: <1405613379-25338-2-git-send-email-mpappas@fastmail.fm>
X-Mailer: git-send-email 1.8.4
In-Reply-To: <1405613379-25338-1-git-send-email-mpappas@fastmail.fm>
References: <1405613379-25338-1-git-send-email-mpappas@fastmail.fm>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Michalis Pappas <mpappas@fastmail.fm>
---
 drivers/staging/gdm72xx/gdm_sdio.c | 15 +++++++--------
 drivers/staging/gdm72xx/gdm_usb.c  | 10 ++++++----
 2 files changed, 13 insertions(+), 12 deletions(-)

diff --git a/drivers/staging/gdm72xx/gdm_sdio.c b/drivers/staging/gdm72xx/gdm_sdio.c
index 6a23bef..a741c31 100644
--- a/drivers/staging/gdm72xx/gdm_sdio.c
+++ b/drivers/staging/gdm72xx/gdm_sdio.c
@@ -278,9 +278,8 @@ static void send_sdu(struct sdio_func *func, struct tx_cxt *tx)
 
 	spin_unlock_irqrestore(&tx->lock, flags);
 
-	print_hex_dump_debug("sdio_send: ", DUMP_PREFIX_NONE, 16, 1,
-			     tx->sdu_buf + TYPE_A_HEADER_SIZE,
-			     aggr_len - TYPE_A_HEADER_SIZE, false);
+	dev_dbg(func->dev, "sdio_send: %*ph\n", aggr_len - TYPE_A_HEADER_SIZE,
+		tx->sdu_buf + TYPE_A_HEADER_SIZE);
 
 	for (pos = TYPE_A_HEADER_SIZE; pos < aggr_len; pos += TX_CHUNK_SIZE) {
 		len = aggr_len - pos;
@@ -315,9 +314,9 @@ static void send_hci(struct sdio_func *func, struct tx_cxt *tx,
 {
 	unsigned long flags;
 
-	print_hex_dump_debug("sdio_send: ", DUMP_PREFIX_NONE, 16, 1,
-			     t->buf + TYPE_A_HEADER_SIZE,
-			     t->len - TYPE_A_HEADER_SIZE, false);
+	dev_dbg(func->dev, "sdio_send: %*ph\n", t->len - TYPE_A_HEADER_SIZE,
+		t->buf + TYPE_A_HEADER_SIZE);
+
 	send_sdio_pkt(func, t->buf, t->len);
 
 	spin_lock_irqsave(&tx->lock, flags);
@@ -549,8 +548,8 @@ static void gdm_sdio_irq(struct sdio_func *func)
 	}
 
 end_io:
-	print_hex_dump_debug("sdio_receive: ", DUMP_PREFIX_NONE, 16, 1,
-			     rx->rx_buf, len, false);
+	dev_dbg(func->dev, "sdio_receive: %*ph\n", len, rx->rx_buf);
+
 	len = control_sdu_tx_flow(sdev, rx->rx_buf, len);
 
 	spin_lock_irqsave(&rx->lock, flags);
diff --git a/drivers/staging/gdm72xx/gdm_usb.c b/drivers/staging/gdm72xx/gdm_usb.c
index 45b3dda..eac2f34 100644
--- a/drivers/staging/gdm72xx/gdm_usb.c
+++ b/drivers/staging/gdm72xx/gdm_usb.c
@@ -341,8 +341,8 @@ static int gdm_usb_send(void *priv_dev, void *data, int len,
 	usb_fill_bulk_urb(t->urb, usbdev, usb_sndbulkpipe(usbdev, 1), t->buf,
 			  len + padding, gdm_usb_send_complete, t);
 
-	print_hex_dump_debug("usb_send: ", DUMP_PREFIX_NONE, 16, 1, t->buf,
-			     len + padding, false);
+	dev_dbg(&usbdev->dev, "usb_send: %*ph\n", len + padding, t->buf);
+
 #ifdef CONFIG_WIMAX_GDM72XX_USB_PM
 	if (usbdev->state & USB_STATE_SUSPENDED) {
 		list_add_tail(&t->p_list, &tx->pending_list);
@@ -420,8 +420,10 @@ static void gdm_usb_rcv_complete(struct urb *urb)
 
 	if (!urb->status) {
 		cmd_evt = (r->buf[0] << 8) | (r->buf[1]);
-		print_hex_dump_debug("usb_receive: ", DUMP_PREFIX_NONE, 16, 1,
-				     r->buf, urb->actual_length, false);
+
+		dev_dbg(&dev->dev, "usb_receive: %*ph\n", urb->actual_length,
+			r->buf);
+
 		if (cmd_evt == WIMAX_SDU_TX_FLOW) {
 			if (r->buf[4] == 0) {
 				dev_dbg(&dev->dev, "WIMAX ==> STOP SDU TX\n");
-- 
1.8.4

