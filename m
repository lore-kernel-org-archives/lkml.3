Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756350Ab3CZRuF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Mar 2013 13:50:05 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:13090 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754143Ab3CZRgU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Mar 2013 13:36:20 -0400
X-Authority-Analysis: v=2.0 cv=H5hZMpki c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=Ciwy3NGCPMMA:10 a=3d4EgXyCpVMA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=OIaNc_L7nBAA:10 a=tHz9FfFoAAAA:8 a=iox4zFpeAAAA:8 a=23663ulKAAAA:8 a=J1Y8HTJGAAAA:8 a=kWDgOHFhbxVf0gkMJRgA:9 a=6O0IECtVFhoA:10 a=n9GBPR9yFnkA:10 a=HEHkIaOUj3cA:10 a=4N9Db7Z2_RYA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-Id: <20130326173606.185399144@goodmis.org>
User-Agent: quilt/0.60-1
Date: Tue, 26 Mar 2013 13:21:38 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Wei Liu <wei.liu2@citrix.com>, Jan Beulich <JBeulich@suse.com>,
        David Vrabel <david.vrabel@citrix.com>,
        "Christopher S. Aker" <caker@theshore.net>,
        Ian Campbell <ian.campbell@citrix.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 39/86] xen-netback: correctly return errors from netbk_count_requests()
References: <20130326172059.136127374@goodmis.org>
Content-Disposition: inline; filename=0039-xen-netback-correctly-return-errors-from-netbk_count.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6.11.1 stable review patch.
If anyone has any objections, please let me know.

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
---
 drivers/net/xen-netback/netback.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/net/xen-netback/netback.c b/drivers/net/xen-netback/netback.c
index 4da6af5..6aa059e 100644
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
1.7.10.4


