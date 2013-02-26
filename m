Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933549Ab3B0AGG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Feb 2013 19:06:06 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:42495 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933483Ab3BZX7G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Feb 2013 18:59:06 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Wei Liu <wei.liu2@citrix.com>, Jan Beulich <JBeulich@suse.com>,
        David Vrabel <david.vrabel@citrix.com>,
        "Christopher S. Aker" <caker@theshore.net>,
        Ian Campbell <ian.campbell@citrix.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [ 43/53] xen-netback: correctly return errors from netbk_count_requests()
Date: Tue, 26 Feb 2013 15:58:12 -0800
Message-Id: <20130226235624.339191788@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.rc1.5.g7e0651a
In-Reply-To: <20130226235619.844721947@linuxfoundation.org>
References: <20130226235619.844721947@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

------------------


From: David Vrabel <david.vrabel@citrix.com>

[ Upstream commit 35876b5ffc154c357476b2c3bdab10feaf4bd8f0 ]

netbk_count_requests() could detect an error, call
netbk_fatal_tx_error() but return 0.  The vif may then be used
afterwards (e.g., in a call to netbk_tx_error().

Since netbk_fatal_tx_error() could set vif->refcnt to 1, the vif may
be freed immediately after the call to netbk_fatal_tx_error() (e.g.,
if the vif is also removed).

Netback thread              Xenwatch thread
-------------------------------------------
netbk_fatal_tx_err()        netback_remove()
                              xenvif_disconnect()
                                ...
                                free_netdev()
netbk_tx_err() Oops!

Signed-off-by: Wei Liu <wei.liu2@citrix.com>
Signed-off-by: Jan Beulich <JBeulich@suse.com>
Signed-off-by: David Vrabel <david.vrabel@citrix.com>
Reported-by: Christopher S. Aker <caker@theshore.net>
Acked-by: Ian Campbell <ian.campbell@citrix.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/xen-netback/netback.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/drivers/net/xen-netback/netback.c
+++ b/drivers/net/xen-netback/netback.c
@@ -870,13 +870,13 @@ static int netbk_count_requests(struct x
 		if (frags >= work_to_do) {
 			netdev_err(vif->dev, "Need more frags\n");
 			netbk_fatal_tx_err(vif);
-			return -frags;
+			return -ENODATA;
 		}
 
 		if (unlikely(frags >= MAX_SKB_FRAGS)) {
 			netdev_err(vif->dev, "Too many frags\n");
 			netbk_fatal_tx_err(vif);
-			return -frags;
+			return -E2BIG;
 		}
 
 		memcpy(txp, RING_GET_REQUEST(&vif->tx, cons + frags),
@@ -884,7 +884,7 @@ static int netbk_count_requests(struct x
 		if (txp->size > first->size) {
 			netdev_err(vif->dev, "Frag is bigger than frame.\n");
 			netbk_fatal_tx_err(vif);
-			return -frags;
+			return -EIO;
 		}
 
 		first->size -= txp->size;
@@ -894,7 +894,7 @@ static int netbk_count_requests(struct x
 			netdev_err(vif->dev, "txp->offset: %x, size: %u\n",
 				 txp->offset, txp->size);
 			netbk_fatal_tx_err(vif);
-			return -frags;
+			return -EINVAL;
 		}
 	} while ((txp++)->flags & XEN_NETTXF_more_data);
 	return frags;


