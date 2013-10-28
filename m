Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755837Ab3J1IzB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Oct 2013 04:55:01 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:46011 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754581Ab3J1Iy6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Oct 2013 04:54:58 -0400
From: Markus Pargmann <mpa@pengutronix.de>
To: Marc Kleine-Budde <mkl@pengutronix.de>,
        Wolfgang Grandegger <wg@grandegger.com>
Cc: linux-can@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, kernel@pengutronix.de,
        Markus Pargmann <mpa@pengutronix.de>
Subject: [PATCH] can: c_can: Handle lost message before EOB
Date: Mon, 28 Oct 2013 09:54:40 +0100
Message-Id: <1382950480-12515-1-git-send-email-mpa@pengutronix.de>
X-Mailer: git-send-email 1.8.4.rc3
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:21e:67ff:fe11:9c5c
X-SA-Exim-Mail-From: mpa@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If we handle end of block messages with higher priority than a lost
message, we can run into an endless interrupt loop.

This is reproducable with a am335x processor and "cansequence -r" at
1Mbit. As soon as we loose a packet we can't escape from a interrupt
loop.

This patch handles lost packets before EOB packets.

Signed-off-by: Markus Pargmann <mpa@pengutronix.de>
---
 drivers/net/can/c_can/c_can.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/can/c_can/c_can.c b/drivers/net/can/c_can/c_can.c
index a668cd4..e3fc07c 100644
--- a/drivers/net/can/c_can/c_can.c
+++ b/drivers/net/can/c_can/c_can.c
@@ -814,9 +814,6 @@ static int c_can_do_rx_poll(struct net_device *dev, int quota)
 			msg_ctrl_save = priv->read_reg(priv,
 					C_CAN_IFACE(MSGCTRL_REG, 0));
 
-			if (msg_ctrl_save & IF_MCONT_EOB)
-				return num_rx_pkts;
-
 			if (msg_ctrl_save & IF_MCONT_MSGLST) {
 				c_can_handle_lost_msg_obj(dev, 0, msg_obj);
 				num_rx_pkts++;
@@ -824,6 +821,9 @@ static int c_can_do_rx_poll(struct net_device *dev, int quota)
 				continue;
 			}
 
+			if (msg_ctrl_save & IF_MCONT_EOB)
+				return num_rx_pkts;
+
 			if (!(msg_ctrl_save & IF_MCONT_NEWDAT))
 				continue;
 
-- 
1.8.4.rc3

