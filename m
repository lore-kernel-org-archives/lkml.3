Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760904Ab3K0CGu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Nov 2013 21:06:50 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:38785 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756479Ab3K0A4m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Nov 2013 19:56:42 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Markus Pargmann <mpa@pengutronix.de>,
        Marc Kleine-Budde <mkl@pengutronix.de>
Subject: [PATCH 3.4 11/39] can: c_can: Fix RX message handling, handle lost message before EOB
Date: Tue, 26 Nov 2013 16:56:35 -0800
Message-Id: <20131127005619.830590699@linuxfoundation.org>
X-Mailer: git-send-email 1.8.5.rc3
In-Reply-To: <20131127005619.011763867@linuxfoundation.org>
References: <20131127005619.011763867@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/net/can/c_can/c_can.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/drivers/net/can/c_can/c_can.c
+++ b/drivers/net/can/c_can/c_can.c
@@ -760,9 +760,6 @@ static int c_can_do_rx_poll(struct net_d
 			msg_ctrl_save = priv->read_reg(priv,
 					&priv->regs->ifregs[0].msg_cntrl);
 
-			if (msg_ctrl_save & IF_MCONT_EOB)
-				return num_rx_pkts;
-
 			if (msg_ctrl_save & IF_MCONT_MSGLST) {
 				c_can_handle_lost_msg_obj(dev, 0, msg_obj);
 				num_rx_pkts++;
@@ -770,6 +767,9 @@ static int c_can_do_rx_poll(struct net_d
 				continue;
 			}
 
+			if (msg_ctrl_save & IF_MCONT_EOB)
+				return num_rx_pkts;
+
 			if (!(msg_ctrl_save & IF_MCONT_NEWDAT))
 				continue;
 


