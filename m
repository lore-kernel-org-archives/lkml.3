Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755779AbaCRRUt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Mar 2014 13:20:49 -0400
Received: from www.linutronix.de ([62.245.132.108]:55750 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756862AbaCRRTF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Mar 2014 13:19:05 -0400
Message-Id: <20140318171127.923041002@linutronix.de>
User-Agent: quilt/0.60-1
Date: Tue, 18 Mar 2014 17:19:15 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Wolfgang Grandegger <wg@grandegger.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        Markus Pargmann <mpa@pengutronix.de>,
        Benedikt Spranger <b.spranger@linutronix.de>,
        linux-can@vger.kernel.org, netdev@vger.kernel.org
Subject: [patch 12/12] can: c_can: Avoid led toggling for every packet.
References: <20140318171007.528610837@linutronix.de>
Content-Disposition: inline; filename=can-c_can-move-rx-led-toggle.patch
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There is no point to toggle the RX led for every packet. Especially if
we have a full FIFO we want to avoid everything we can.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 drivers/net/can/c_can/c_can.c |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

Index: linux/drivers/net/can/c_can/c_can.c
===================================================================
--- linux.orig/drivers/net/can/c_can/c_can.c
+++ linux/drivers/net/can/c_can/c_can.c
@@ -433,9 +433,6 @@ static int c_can_read_msg_object(struct
 
 	stats->rx_packets++;
 	stats->rx_bytes += frame->can_dlc;
-
-	can_led_event(dev, CAN_LED_EVENT_RX);
-
 	return 0;
 }
 
@@ -892,6 +889,10 @@ static int c_can_do_rx_poll(struct net_d
 		pkts += n;
 		quota -= n;
 	}
+
+	if (pkts)
+		can_led_event(dev, CAN_LED_EVENT_RX);
+
 	return pkts;
 }
 


