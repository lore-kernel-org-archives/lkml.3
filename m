Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932227AbbAYS3L (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Jan 2015 13:29:11 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:58031 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756039AbbAYSK2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Jan 2015 13:10:28 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        "Ahmed S. Darwish" <ahmed.darwish@valeo.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>
Subject: [PATCH 3.18 156/183] can: kvaser_usb: Reset all URB tx contexts upon channel close
Date: Sun, 25 Jan 2015 10:07:58 -0800
Message-Id: <20150125180816.953983522@linuxfoundation.org>
X-Mailer: git-send-email 2.2.2
In-Reply-To: <20150125180810.160428929@linuxfoundation.org>
References: <20150125180810.160428929@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: "Ahmed S. Darwish" <ahmed.darwish@valeo.com>

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/net/can/usb/kvaser_usb.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/net/can/usb/kvaser_usb.c
+++ b/drivers/net/can/usb/kvaser_usb.c
@@ -1246,6 +1246,9 @@ static int kvaser_usb_close(struct net_d
 	if (err)
 		netdev_warn(netdev, "Cannot stop device, error %d\n", err);
 
+	/* reset tx contexts */
+	kvaser_usb_unlink_tx_urbs(priv);
+
 	priv->can.state = CAN_STATE_STOPPED;
 	close_candev(priv->netdev);
 


