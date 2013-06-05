Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933188Ab3FEVm3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Jun 2013 17:42:29 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:38072 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933120Ab3FEVgP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Jun 2013 17:36:15 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Jonas Peterson <jonas.peterson@gmail.com>,
        Olivier Sobrie <olivier@sobrie.be>,
        Marc Kleine-Budde <mkl@pengutronix.de>
Subject: [ 113/127] net: can: kvaser_usb: fix reception on "USBcan Pro" and "USBcan R" type hardware.
Date: Wed,  5 Jun 2013 14:34:40 -0700
Message-Id: <20130605213230.828265508@linuxfoundation.org>
X-Mailer: git-send-email 1.8.3.rc0.20.gb99dd2e
In-Reply-To: <20130605213217.966891866@linuxfoundation.org>
References: <20130605213217.966891866@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jonas Peterson <jonas.peterson@gmail.com>

commit a90f13b24fb40d02d11496cce6a10ae8d4b319b2 upstream.

Unlike Kvaser Leaf light devices, some other Kvaser devices (like USBcan
Pro, USBcan R) receive CAN messages in CMD_LOG_MESSAGE frames. This
patch adds support for it.

Signed-off-by: Jonas Peterson <jonas.peterson@gmail.com>
Signed-off-by: Olivier Sobrie <olivier@sobrie.be>
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/net/can/usb/kvaser_usb.c |   68 +++++++++++++++++++++++++--------------
 1 file changed, 45 insertions(+), 23 deletions(-)

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
@@ -817,8 +820,13 @@ static void kvaser_usb_rx_can_msg(const
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
@@ -834,22 +842,40 @@ static void kvaser_usb_rx_can_msg(const
 		return;
 	}
 
-	cf->can_id = ((msg->u.rx_can.msg[0] & 0x1f) << 6) |
-		     (msg->u.rx_can.msg[1] & 0x3f);
-	cf->can_dlc = get_can_dlc(msg->u.rx_can.msg[5]);
-
-	if (msg->id == CMD_RX_EXT_MESSAGE) {
-		cf->can_id <<= 18;
-		cf->can_id |= ((msg->u.rx_can.msg[2] & 0x0f) << 14) |
-			      ((msg->u.rx_can.msg[3] & 0xff) << 6) |
-			      (msg->u.rx_can.msg[4] & 0x3f);
-		cf->can_id |= CAN_EFF_FLAG;
-	}
-
-	if (msg->u.rx_can.flag & MSG_FLAG_REMOTE_FRAME)
-		cf->can_id |= CAN_RTR_FLAG;
-	else
-		memcpy(cf->data, &msg->u.rx_can.msg[6], cf->can_dlc);
+	if (msg->id == CMD_LOG_MESSAGE) {
+		cf->can_id = le32_to_cpu(msg->u.log_message.id);
+		if (cf->can_id & KVASER_EXTENDED_FRAME)
+			cf->can_id &= CAN_EFF_MASK | CAN_EFF_FLAG;
+		else
+			cf->can_id &= CAN_SFF_MASK;
+
+		cf->can_dlc = get_can_dlc(msg->u.log_message.dlc);
+
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
 
@@ -911,6 +937,7 @@ static void kvaser_usb_handle_message(co
 
 	case CMD_RX_STD_MESSAGE:
 	case CMD_RX_EXT_MESSAGE:
+	case CMD_LOG_MESSAGE:
 		kvaser_usb_rx_can_msg(dev, msg);
 		break;
 
@@ -919,11 +946,6 @@ static void kvaser_usb_handle_message(co
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


