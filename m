Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754760Ab3KYNIy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Nov 2013 08:08:54 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:57244 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751366Ab3KYNIu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Nov 2013 08:08:50 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Markus Pargmann <mpa@pengutronix.de>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.5 56/78] can: c_can: Fix RX message handling, handle lost message before EOB
Date: Mon, 25 Nov 2013 13:06:43 +0000
Message-Id: <1385384825-21681-57-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1385384825-21681-1-git-send-email-luis.henriques@canonical.com>
References: <1385384825-21681-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.26 -stable review patch.  If anyone has any objections, please let me know.

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
[ luis: backported to 3.5: adjusted context ]
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/net/can/c_can/c_can.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/can/c_can/c_can.c b/drivers/net/can/c_can/c_can.c
index 64647d4..91d1b5a 100644
--- a/drivers/net/can/c_can/c_can.c
+++ b/drivers/net/can/c_can/c_can.c
@@ -764,9 +764,6 @@ static int c_can_do_rx_poll(struct net_device *dev, int quota)
 			msg_ctrl_save = priv->read_reg(priv,
 					&priv->regs->ifregs[0].msg_cntrl);
 
-			if (msg_ctrl_save & IF_MCONT_EOB)
-				return num_rx_pkts;
-
 			if (msg_ctrl_save & IF_MCONT_MSGLST) {
 				c_can_handle_lost_msg_obj(dev, 0, msg_obj);
 				num_rx_pkts++;
@@ -774,6 +771,9 @@ static int c_can_do_rx_poll(struct net_device *dev, int quota)
 				continue;
 			}
 
+			if (msg_ctrl_save & IF_MCONT_EOB)
+				return num_rx_pkts;
+
 			if (!(msg_ctrl_save & IF_MCONT_NEWDAT))
 				continue;
 
-- 
1.8.3.2

