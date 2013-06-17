Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754461Ab3FQSAU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Jun 2013 14:00:20 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:50416 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753257Ab3FQRbm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Jun 2013 13:31:42 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Jonas Peterson <jonas.peterson@gmail.com>,
        Olivier Sobrie <olivier@sobrie.be>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 06/84] net: can: kvaser_usb: fix reception on "USBcan Pro" and "USBcan R" type hardware.
Date: Mon, 17 Jun 2013 10:30:10 -0700
Message-Id: <1371490288-23167-7-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1371490288-23167-1-git-send-email-kamal@canonical.com>
References: <1371490288-23167-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.3 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jonas Peterson <jonas.peterson@gmail.com>

commit a90f13b24fb40d02d11496cce6a10ae8d4b319b2 upstream.

Unlike Kvaser Leaf light devices, some other Kvaser devices (like USBcan
Pro, USBcan R) receive CAN messages in CMD_LOG_MESSAGE frames. This
patch adds support for it.

Signed-off-by: Jonas Peterson <jonas.peterson@gmail.com>
Signed-off-by: Olivier Sobrie <olivier@sobrie.be>
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/net/can/usb/kvaser_usb.c | 64 +++++++++++++++++++++++++++-------------
 1 file changed, 43 insertions(+), 21 deletions(-)

diff --git a/drivers/net/can/usb/kvaser_usb.c b/drivers/net/can/usb/kvaser_usb.c
index 5b58a4d..20b5a3a 100644
--- a/drivers/net/can/usb/kvaser_usb.c
+++ b/drivers/net/can/usb/kvaser_usb.c
@@ -136,6 +136,9 @@
 #define KVASER_CTRL_MODE_SELFRECEPTION	3
 #define KVASER_CTRL_MODE_OFF		4
 
+/* log message */
+#define KVASER_EXTENDED_FRAME		BIT(31)
+
 struct kvaser_msg_simple {
 	u8 tid;
 	u8 channel;
@@ -818,8 +821,13 @@ static void kvaser_usb_rx_can_msg(const struct kvaser_usb *dev,
 	priv = dev->nets[channel];
 	stats = &priv->netdev->stats;
 
-	if (msg->u.rx_can.flag & (MSG_FLAG_ERROR_FRAME | MSG_FLAG_NERR |
-				  MSG_FLAG_OVERRUN)) {
+	if ((msg->u.rx_can.flag & MSG_FLAG_ERROR_FRAME) &&
+	    (msg->id == CMD_LOG_MESSAGE)) {
+		kvaser_usb_rx_error(dev, msg);
+		return;
+	} else if (msg->u.rx_can.flag & (MSG_FLAG_ERROR_FRAME |
+					 MSG_FLAG_NERR |
+					 MSG_FLAG_OVERRUN)) {
 		kvaser_usb_rx_can_err(priv, msg);
 		return;
 	} else if (msg->u.rx_can.flag & ~MSG_FLAG_REMOTE_FRAME) {
@@ -835,22 +843,40 @@ static void kvaser_usb_rx_can_msg(const struct kvaser_usb *dev,
 		return;
 	}
 
-	cf->can_id = ((msg->u.rx_can.msg[0] & 0x1f) << 6) |
-		     (msg->u.rx_can.msg[1] & 0x3f);
-	cf->can_dlc = get_can_dlc(msg->u.rx_can.msg[5]);
+	if (msg->id == CMD_LOG_MESSAGE) {
+		cf->can_id = le32_to_cpu(msg->u.log_message.id);
+		if (cf->can_id & KVASER_EXTENDED_FRAME)
+			cf->can_id &= CAN_EFF_MASK | CAN_EFF_FLAG;
+		else
+			cf->can_id &= CAN_SFF_MASK;
 
-	if (msg->id == CMD_RX_EXT_MESSAGE) {
-		cf->can_id <<= 18;
-		cf->can_id |= ((msg->u.rx_can.msg[2] & 0x0f) << 14) |
-			      ((msg->u.rx_can.msg[3] & 0xff) << 6) |
-			      (msg->u.rx_can.msg[4] & 0x3f);
-		cf->can_id |= CAN_EFF_FLAG;
-	}
+		cf->can_dlc = get_can_dlc(msg->u.log_message.dlc);
 
-	if (msg->u.rx_can.flag & MSG_FLAG_REMOTE_FRAME)
-		cf->can_id |= CAN_RTR_FLAG;
-	else
-		memcpy(cf->data, &msg->u.rx_can.msg[6], cf->can_dlc);
+		if (msg->u.log_message.flags & MSG_FLAG_REMOTE_FRAME)
+			cf->can_id |= CAN_RTR_FLAG;
+		else
+			memcpy(cf->data, &msg->u.log_message.data,
+			       cf->can_dlc);
+	} else {
+		cf->can_id = ((msg->u.rx_can.msg[0] & 0x1f) << 6) |
+			     (msg->u.rx_can.msg[1] & 0x3f);
+
+		if (msg->id == CMD_RX_EXT_MESSAGE) {
+			cf->can_id <<= 18;
+			cf->can_id |= ((msg->u.rx_can.msg[2] & 0x0f) << 14) |
+				      ((msg->u.rx_can.msg[3] & 0xff) << 6) |
+				      (msg->u.rx_can.msg[4] & 0x3f);
+			cf->can_id |= CAN_EFF_FLAG;
+		}
+
+		cf->can_dlc = get_can_dlc(msg->u.rx_can.msg[5]);
+
+		if (msg->u.rx_can.flag & MSG_FLAG_REMOTE_FRAME)
+			cf->can_id |= CAN_RTR_FLAG;
+		else
+			memcpy(cf->data, &msg->u.rx_can.msg[6],
+			       cf->can_dlc);
+	}
 
 	netif_rx(skb);
 
@@ -912,6 +938,7 @@ static void kvaser_usb_handle_message(const struct kvaser_usb *dev,
 
 	case CMD_RX_STD_MESSAGE:
 	case CMD_RX_EXT_MESSAGE:
+	case CMD_LOG_MESSAGE:
 		kvaser_usb_rx_can_msg(dev, msg);
 		break;
 
@@ -920,11 +947,6 @@ static void kvaser_usb_handle_message(const struct kvaser_usb *dev,
 		kvaser_usb_rx_error(dev, msg);
 		break;
 
-	case CMD_LOG_MESSAGE:
-		if (msg->u.log_message.flags & MSG_FLAG_ERROR_FRAME)
-			kvaser_usb_rx_error(dev, msg);
-		break;
-
 	case CMD_TX_ACKNOWLEDGE:
 		kvaser_usb_tx_acknowledge(dev, msg);
 		break;
-- 
1.8.1.2

