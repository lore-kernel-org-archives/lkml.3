Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757682Ab3EQWMR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 May 2013 18:12:17 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:54258 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757143Ab3EQVhn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 May 2013 17:37:43 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Holger Eitzenberger <holger@eitzenberger.org>,
        "David S. Miller" <davem@davemloft.net>
Subject: [ 064/102] asix: fix BUG in receive path when lowering MTU
Date: Fri, 17 May 2013 14:36:19 -0700
Message-Id: <20130517213251.116419900@linuxfoundation.org>
X-Mailer: git-send-email 1.8.3.rc0.20.gb99dd2e
In-Reply-To: <20130517213244.277411019@linuxfoundation.org>
References: <20130517213244.277411019@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.9-stable review patch.  If anyone has any objections, please let me know.

------------------


From: "holger@eitzenberger.org" <holger@eitzenberger.org>

[ Upstream commit c5060cec6ba27ad3f0e7facfdf05d2f18e3e3010 ]

There is bug in the receive path of the asix driver at the time a
packet is received larger than MTU size and DF bit set:

 BUG: unable to handle kernel paging request at 0000004000000001
 IP: [<ffffffff8126f65b>] skb_release_head_state+0x2d/0xd2
 ...
 Call Trace:
  <IRQ>
  [<ffffffff8126f86d>] ? skb_release_all+0x9/0x1e
  [<ffffffff8126f8ad>] ? __kfree_skb+0x9/0x6f
  [<ffffffffa00b4200>] ? asix_rx_fixup_internal+0xff/0x1ae [asix]
  [<ffffffffa00fb3dc>] ? usbnet_bh+0x4f/0x226 [usbnet]
  ...

It is easily reproducable by setting an MTU of 512 e. g. and sending
something like

  ping -s 1472 -c 1 -M do $SELF

from another box.

And this is because the rx->ax_skb is freed on error, but rx->ax_skb
is not reset, and the size is not reset to zero in this case.

And since the skb is added again to the usbnet->done skb queue it is
accessing already freed memory, resulting in the BUG when freeing a
2nd time.  I therefore think the value 0x0000004000000001 show in the
trace is more or less random data.

Signed-off-by: Holger Eitzenberger <holger@eitzenberger.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/usb/asix_common.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/net/usb/asix_common.c
+++ b/drivers/net/usb/asix_common.c
@@ -100,6 +100,9 @@ int asix_rx_fixup_internal(struct usbnet
 			netdev_err(dev->net, "asix_rx_fixup() Bad RX Length %d\n",
 				   rx->size);
 			kfree_skb(rx->ax_skb);
+			rx->ax_skb = NULL;
+			rx->size = 0U;
+
 			return 0;
 		}
 


