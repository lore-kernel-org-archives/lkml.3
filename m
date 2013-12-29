Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754283Ab3L2CMX (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Dec 2013 21:12:23 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:55725 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753986Ab3L2CLZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Dec 2013 21:11:25 -0500
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "Marc Kleine-Budde" <mkl@pengutronix.de>,
        "Markus Pargmann" <mpa@pengutronix.de>
Date: Sun, 29 Dec 2013 03:08:43 +0100
Message-ID: <lsq.1388282923.597095294@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [PATCH 3.2 020/185] can: c_can: Fix RX message handling, handle
 lost message before EOB
In-Reply-To: <lsq.1388282923.751256928@decadent.org.uk>
X-SA-Exim-Connect-IP: 31.18.200.85
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.54-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Markus Pargmann <mpa@pengutronix.de>

commit 5d0f801a2ccec3b1fdabc3392c8d99ed0413d216 upstream.

If we handle end of block messages with higher priority than a lost message,
we can run into an endless interrupt loop.

This is reproducable with a am335x processor and "cansequence -r" at 1Mbit.
As soon as we loose a packet we can't escape from an interrupt loop.

This patch fixes the problem by handling lost packets before EOB packets.

Signed-off-by: Markus Pargmann <mpa@pengutronix.de>
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/net/can/c_can/c_can.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/drivers/net/can/c_can/c_can.c
+++ b/drivers/net/can/c_can/c_can.c
@@ -764,9 +764,6 @@ static int c_can_do_rx_poll(struct net_d
 			msg_ctrl_save = priv->read_reg(priv,
 					&priv->regs->ifregs[0].msg_cntrl);
 
-			if (msg_ctrl_save & IF_MCONT_EOB)
-				return num_rx_pkts;
-
 			if (msg_ctrl_save & IF_MCONT_MSGLST) {
 				c_can_handle_lost_msg_obj(dev, 0, msg_obj);
 				num_rx_pkts++;
@@ -774,6 +771,9 @@ static int c_can_do_rx_poll(struct net_d
 				continue;
 			}
 
+			if (msg_ctrl_save & IF_MCONT_EOB)
+				return num_rx_pkts;
+
 			if (!(msg_ctrl_save & IF_MCONT_NEWDAT))
 				continue;
 

