Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756965AbaCRRTL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Mar 2014 13:19:11 -0400
Received: from www.linutronix.de ([62.245.132.108]:55710 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756662AbaCRRTA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Mar 2014 13:19:00 -0400
Message-Id: <20140318171126.962446866@linutronix.de>
User-Agent: quilt/0.60-1
Date: Tue, 18 Mar 2014 17:19:10 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Wolfgang Grandegger <wg@grandegger.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        Markus Pargmann <mpa@pengutronix.de>,
        Benedikt Spranger <b.spranger@linutronix.de>,
        linux-can@vger.kernel.org, netdev@vger.kernel.org
Subject: [patch 04/12] can: c_can: Fix buffer ordering for real
References: <20140318171007.528610837@linutronix.de>
Content-Disposition: inline; filename=can-c-can-fix-buffer-handling.patch
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The buffer handling of c_can has been broken forever. That leads to
message reordering:

ksoftirqd/0-3     [000] ..s.    79.123776: c_can_poll: rx_poll: val: 00007fff
ksoftirqd/0-3     [000] ..s.    79.124101: c_can_poll: rx_poll: val: 00008001

What happens is:

CPU				HW
				queue new packet into obj 16 (0-15 are busy)
read obj 1-15			
return because pending is 0
				set pending obj 16 -> pending reg 8000
				queue new packet into obj 1 
				set pending obj 1 -> pending reg 8001

So the current algorithmus reads the newest message first, which
violates the ordering rules of CAN.

Add proper handling of that situation by analyzing the contents of the
pending register for gaps.

This does NOT fix the message object corruption which can lead to
interrupt storms. Thats addressed in the next patches.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 drivers/net/can/c_can/c_can.c |   52 ++++++++++++++++++++++++++++++++++++++++--
 1 file changed, 50 insertions(+), 2 deletions(-)

Index: linux/drivers/net/can/c_can/c_can.c
===================================================================
--- linux.orig/drivers/net/can/c_can/c_can.c
+++ linux/drivers/net/can/c_can/c_can.c
@@ -808,6 +808,38 @@ static void c_can_do_tx(struct net_devic
 }
 
 /*
+ * If we have a gap in the pending bits, that means we either
+ * raced with the hardware or failed to readout all upper
+ * objects in the last run due to quota limit.
+ */
+static u32 c_can_adjust_pending(u32 pend)
+{
+	u32 weight, lasts;
+
+	if (pend == RECEIVE_OBJECT_BITS)
+		return pend;
+
+	/*
+	 * If the last set bit is larger than the number of pending
+	 * bits we have a gap.
+	 */
+	weight = hweight32(pend);
+	lasts = fls(pend);
+
+	/* If the bits are linear, nothing to do */
+	if (lasts == weight)
+		return pend;
+
+	/*
+	 * Find the first set bit after the gap. We walk backwards
+	 * from the last set bit.
+	 */
+	for (lasts--; pend & (1 << (lasts - 1)); lasts--);
+
+	return pend & ~((1 << lasts) - 1);
+}
+
+/*
  * theory of operation:
  *
  * c_can core saves a received CAN message into the first free message
@@ -834,7 +866,7 @@ static int c_can_do_rx_poll(struct net_d
 	u32 num_rx_pkts = 0;
 	unsigned int msg_obj, msg_ctrl_save;
 	struct c_can_priv *priv = netdev_priv(dev);
-	u16 val;
+	u32 val, pend = 0;
 
 	/*
 	 * It is faster to read only one 16bit register. This is only possible
@@ -843,7 +875,23 @@ static int c_can_do_rx_poll(struct net_d
 	BUILD_BUG_ON_MSG(C_CAN_MSG_OBJ_RX_LAST > 16,
 			"Implementation does not support more message objects than 16");
 
-	while (quota > 0 && (val = priv->read_reg(priv, C_CAN_INTPND1_REG))) {
+	while (quota > 0) {
+
+		if (!pend) {
+			pend = priv->read_reg(priv, C_CAN_INTPND1_REG);
+			if (!pend)
+				return num_rx_pkts;
+			/*
+			 * If the pending field has a gap, handle the
+			 * bits above the gap first.
+			 */
+			val = c_can_adjust_pending(pend);
+		} else {
+			val = pend;
+		}
+		/* Remove the bits from pend */
+		pend &= ~val;
+
 		while ((msg_obj = ffs(val)) && quota > 0) {
 			val &= ~BIT(msg_obj - 1);
 


