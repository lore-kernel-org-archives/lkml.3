Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933135Ab3B1Oy7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Feb 2013 09:54:59 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:42541 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933098Ab3B1OvK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Feb 2013 09:51:10 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Wei Liu <wei.liu2@citrix.com>, Jan Beulich <JBeulich@suse.com>,
        David Vrabel <david.vrabel@citrix.com>,
        "David S. Miller" <davem@davemloft.net>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 127/139] xen-netback: correctly return errors from netbk_count_requests()
Date: Thu, 28 Feb 2013 14:44:37 +0000
Message-Id: <1362062689-2567-128-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1362062689-2567-1-git-send-email-luis.henriques@canonical.com>
References: <1362062689-2567-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.7 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: David Vrabel <david.vrabel@citrix.com>

commit 35876b5ffc154c357476b2c3bdab10feaf4bd8f0 upstream.

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
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/net/xen-netback/netback.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/net/xen-netback/netback.c b/drivers/net/xen-netback/netback.c
index f3c3a68..a98f012 100644
--- a/drivers/net/xen-netback/netback.c
+++ b/drivers/net/xen-netback/netback.c
@@ -882,13 +882,13 @@ static int netbk_count_requests(struct xenvif *vif,
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
@@ -896,7 +896,7 @@ static int netbk_count_requests(struct xenvif *vif,
 		if (txp->size > first->size) {
 			netdev_err(vif->dev, "Frag is bigger than frame.\n");
 			netbk_fatal_tx_err(vif);
-			return -frags;
+			return -EIO;
 		}
 
 		first->size -= txp->size;
@@ -906,7 +906,7 @@ static int netbk_count_requests(struct xenvif *vif,
 			netdev_err(vif->dev, "txp->offset: %x, size: %u\n",
 				 txp->offset, txp->size);
 			netbk_fatal_tx_err(vif);
-			return -frags;
+			return -EINVAL;
 		}
 	} while ((txp++)->flags & XEN_NETTXF_more_data);
 	return frags;
-- 
1.8.1.2

