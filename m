Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932180Ab3J1Q75 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Oct 2013 12:59:57 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:34485 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932153Ab3J1Q74 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Oct 2013 12:59:56 -0400
From: Markus Pargmann <mpa@pengutronix.de>
To: Marc Kleine-Budde <mkl@pengutronix.de>,
        Wolfgang Grandegger <wg@grandegger.com>
Cc: linux-can@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, kernel@pengutronix.de,
        Markus Pargmann <mpa@pengutronix.de>
Subject: [PATCH] can: c_can: Speed up rx_poll function
Date: Mon, 28 Oct 2013 17:59:42 +0100
Message-Id: <1382979582-10352-1-git-send-email-mpa@pengutronix.de>
X-Mailer: git-send-email 1.8.4.rc3
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:21e:67ff:fe11:9c5c
X-SA-Exim-Mail-From: mpa@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch speeds up the rx_poll function by reducing the number of
register reads.

Replace the 32bit register read by a 16bit register read. Currently
the 32bit register read is implemented by using 2 16bit reads. This is
inefficient as we only use the lower 16bit in rx_poll.

The for loops reads the pending interrupts in every iteration. This
leads up to 16 reads of pending interrupts. The patch introduces a new
outer loop to read the pending interrupts as long as 'quota' is above 0.
This reduces the total number of reads.

The third change is to replace the for-loop by a find_next_bit loop.

Tested on AM335x. I removed all 'static' and 'inline' from c_can.c to
see the timings for all functions. I used the function tracer with
trace_stats.

125kbit:
  Function                               Hit    Time            Avg             s^2
  --------                               ---    ----            ---             ---
  c_can_do_rx_poll                     63960    10168178 us     158.977 us      1493056 us
With patch:
  c_can_do_rx_poll                     63939    4268457 us     66.758 us       818790.9 us

1Mbit:
  Function                               Hit    Time            Avg             s^2
  --------                               ---    ----            ---             ---
  c_can_do_rx_poll                     69489    30049498 us     432.435 us      9271851 us
With patch:
  c_can_do_rx_poll                    103034    24220362 us     235.071 us      6016656 us

Signed-off-by: Markus Pargmann <mpa@pengutronix.de>
---
 drivers/net/can/c_can/c_can.c | 30 ++++++++++++++++++++----------
 1 file changed, 20 insertions(+), 10 deletions(-)

diff --git a/drivers/net/can/c_can/c_can.c b/drivers/net/can/c_can/c_can.c
index a668cd4..31af033 100644
--- a/drivers/net/can/c_can/c_can.c
+++ b/drivers/net/can/c_can/c_can.c
@@ -259,6 +259,12 @@ static u32 c_can_read_reg32(struct c_can_priv *priv, enum reg index)
 	return val;
 }
 
+u16 c_can_read_reg16(struct c_can_priv *priv, enum reg index)
+{
+	u16 val = priv->read_reg(priv, index);
+	return val;
+}
+
 static void c_can_enable_all_interrupts(struct c_can_priv *priv,
 						int enable)
 {
@@ -798,17 +804,21 @@ static int c_can_do_rx_poll(struct net_device *dev, int quota)
 	u32 num_rx_pkts = 0;
 	unsigned int msg_obj, msg_ctrl_save;
 	struct c_can_priv *priv = netdev_priv(dev);
-	u32 val = c_can_read_reg32(priv, C_CAN_INTPND1_REG);
+	unsigned long val = c_can_read_reg16(priv, C_CAN_INTPND1_REG);
+
+	/*
+	 * It is faster to read only one 16bit register. This is only possible
+	 * for a maximum number of 16 objects.
+	 */
+	BUILD_BUG_ON_MSG(C_CAN_MSG_OBJ_RX_LAST > 16,
+			"Implementation does not support more message objects than 16");
+
+	while (quota > 0 && (val = c_can_read_reg16(priv, C_CAN_INTPND1_REG))) {
+		msg_obj = 0;
+		while ((msg_obj = find_next_bit(&val, 16, msg_obj)) < 16 &&
+				quota > 0) {
+			++msg_obj;
 
-	for (msg_obj = C_CAN_MSG_OBJ_RX_FIRST;
-			msg_obj <= C_CAN_MSG_OBJ_RX_LAST && quota > 0;
-			val = c_can_read_reg32(priv, C_CAN_INTPND1_REG),
-			msg_obj++) {
-		/*
-		 * as interrupt pending register's bit n-1 corresponds to
-		 * message object n, we need to handle the same properly.
-		 */
-		if (val & (1 << (msg_obj - 1))) {
 			c_can_object_get(dev, 0, msg_obj, IF_COMM_ALL &
 					~IF_COMM_TXRQST);
 			msg_ctrl_save = priv->read_reg(priv,
-- 
1.8.4.rc3

