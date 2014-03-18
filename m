Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757303AbaCRRZx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Mar 2014 13:25:53 -0400
Received: from www.linutronix.de ([62.245.132.108]:55721 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756784AbaCRRTC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Mar 2014 13:19:02 -0400
Message-Id: <20140318171127.186186948@linutronix.de>
User-Agent: quilt/0.60-1
Date: Tue, 18 Mar 2014 17:19:11 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Wolfgang Grandegger <wg@grandegger.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        Markus Pargmann <mpa@pengutronix.de>,
        Benedikt Spranger <b.spranger@linutronix.de>,
        linux-can@vger.kernel.org, netdev@vger.kernel.org
Subject: [patch 06/12] can: c_can: Remove braindamaged EOB exit
References: <20140318171007.528610837@linutronix.de>
Content-Disposition: inline; filename=can-c-can-fix-eob-handling.patch
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The rx_poll code has the following gem:

	if (msg_ctrl_save & IF_MCONT_EOB)
		return num_rx_pkts;

The EOB bit is the indicator for the hardware that this is the last
configured FIFO object. But this object can contain valid data, if we
manage to free up objects before the overrun case hits.

Now if the code exits due to the EOB bit set, then this buffer is
stale and the interrupt bit and NewDat bit of the buffer are still
set. Results in a nice interrupt storm unless we come into an overrun
situation where the MSGLST bit gets set.

     ksoftirqd/0-3     [000] ..s.    79.124101: c_can_poll: rx_poll: val: 00008001 pend 00008001
     ksoftirqd/0-3     [000] ..s.    79.124176: c_can_poll: rx_poll: val: 00008000 pend 00008000
     ksoftirqd/0-3     [000] ..s.    79.124187: c_can_poll: rx_poll: val: 00008002 pend 00008002
     ksoftirqd/0-3     [000] ..s.    79.124256: c_can_poll: rx_poll: val: 00008000 pend 00008000
     ksoftirqd/0-3     [000] ..s.    79.124267: c_can_poll: rx_poll: val: 00008000 pend 00008000

The amazing thing is that the check of the MSGLST (aka overrun bit)
used to be after the check of the EOB bit. That was "fixed" in commit
5d0f801a2c(can: c_can: Fix RX message handling, handle lost message
before EOB). But the author of this "fix" did not even understand that
the EOB check is broken as well.

Again a simple solution: Remove the brainfart.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 drivers/net/can/c_can/c_can.c |    3 ---
 1 file changed, 3 deletions(-)

Index: linux/drivers/net/can/c_can/c_can.c
===================================================================
--- linux.orig/drivers/net/can/c_can/c_can.c
+++ linux/drivers/net/can/c_can/c_can.c
@@ -906,9 +906,6 @@ static int c_can_do_rx_poll(struct net_d
 				continue;
 			}
 
-			if (msg_ctrl_save & IF_MCONT_EOB)
-				return num_rx_pkts;
-
 			if (!(msg_ctrl_save & IF_MCONT_NEWDAT))
 				continue;
 


