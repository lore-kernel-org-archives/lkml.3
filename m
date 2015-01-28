Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757463AbbA2JBb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jan 2015 04:01:31 -0500
Received: from ip4-83-240-67-251.cust.nbox.cz ([83.240.67.251]:44737 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752923AbbA2JBW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jan 2015 04:01:22 -0500
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, "Ahmed S. Darwish" <ahmed.darwish@valeo.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>, Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 117/176] can: kvaser_usb: Reset all URB tx contexts upon channel close
Date: Wed, 28 Jan 2015 15:29:07 +0100
Message-Id: <e77e202ad6447ede64f43697ab32e990a1e96d1e.1422455352.git.jslaby@suse.cz>
X-Mailer: git-send-email 2.2.2
In-Reply-To: <ce4a451f616a1e7ab58cfeceea5e49c8b1c68c81.1422455352.git.jslaby@suse.cz>
References: <ce4a451f616a1e7ab58cfeceea5e49c8b1c68c81.1422455352.git.jslaby@suse.cz>
In-Reply-To: <cover.1422455352.git.jslaby@suse.cz>
References: <cover.1422455352.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Ahmed S. Darwish" <ahmed.darwish@valeo.com>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

commit 889b77f7fd2bcc922493d73a4c51d8a851505815 upstream.

Flooding the Kvaser CAN to USB dongle with multiple reads and
writes in very high frequency (*), closing the CAN channel while
all the transmissions are on (#), opening the device again (@),
then sending a small number of packets would make the driver
enter an almost infinite loop of:

[....]
[15959.853988] kvaser_usb 4-3:1.0 can0: cannot find free context
[15959.853990] kvaser_usb 4-3:1.0 can0: cannot find free context
[15959.853991] kvaser_usb 4-3:1.0 can0: cannot find free context
[15959.853993] kvaser_usb 4-3:1.0 can0: cannot find free context
[15959.853994] kvaser_usb 4-3:1.0 can0: cannot find free context
[15959.853995] kvaser_usb 4-3:1.0 can0: cannot find free context
[....]

_dragging the whole system down_ in the process due to the
excessive logging output.

Initially, this has caused random panics in the kernel due to a
buggy error recovery path.  That got fixed in an earlier commit.(%)
This patch aims at solving the root cause. -->

16 tx URBs and contexts are allocated per CAN channel per USB
device. Such URBs are protected by:

a) A simple atomic counter, up to a value of MAX_TX_URBS (16)
b) A flag in each URB context, stating if it's free
c) The fact that ndo_start_xmit calls are themselves protected
   by the networking layers higher above

After grabbing one of the tx URBs, if the driver noticed that all
of them are now taken, it stops the netif transmission queue.
Such queue is worken up again only if an acknowedgment was received
from the firmware on one of our earlier-sent frames.

Meanwhile, upon channel close (#), the driver sends a CMD_STOP_CHIP
to the firmware, effectively closing all further communication.  In
the high traffic case, the atomic counter remains at MAX_TX_URBS,
and all the URB contexts remain marked as active.  While opening
the channel again (@), it cannot send any further frames since no
more free tx URB contexts are available.

Reset all tx URB contexts upon CAN channel close.

(*) 50 parallel instances of `cangen0 -g 0 -ix`
(#) `ifconfig can0 down`
(@) `ifconfig can0 up`
(%) "can: kvaser_usb: Don't free packets when tight on URBs"

Signed-off-by: Ahmed S. Darwish <ahmed.darwish@valeo.com>
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 drivers/net/can/usb/kvaser_usb.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/net/can/usb/kvaser_usb.c b/drivers/net/can/usb/kvaser_usb.c
index f6e30be1c0eb..925273ca7879 100644
--- a/drivers/net/can/usb/kvaser_usb.c
+++ b/drivers/net/can/usb/kvaser_usb.c
@@ -1238,6 +1238,9 @@ static int kvaser_usb_close(struct net_device *netdev)
 	if (err)
 		netdev_warn(netdev, "Cannot stop device, error %d\n", err);
 
+	/* reset tx contexts */
+	kvaser_usb_unlink_tx_urbs(priv);
+
 	priv->can.state = CAN_STATE_STOPPED;
 	close_candev(priv->netdev);
 
-- 
2.2.2

