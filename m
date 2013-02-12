Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759395Ab3BLVAy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Feb 2013 16:00:54 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:53579 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754908Ab3BLUgE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Feb 2013 15:36:04 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Ian Campbell <ian.campbell@citrix.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [ 41/61] xen/netback: free already allocated memory on failure in xen_netbk_get_requests
Date: Tue, 12 Feb 2013 12:35:01 -0800
Message-Id: <20130212203423.655566370@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.rc1.5.g7e0651a
In-Reply-To: <20130212203417.890993903@linuxfoundation.org>
References: <20130212203417.890993903@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.7-stable review patch.  If anyone has any objections, please let me know.

------------------


From: Ian Campbell <Ian.Campbell@citrix.com>

[ Upstream commit 4cc7c1cb7b11b6f3515bd9075527576a1eecc4aa ]

Signed-off-by: Ian Campbell <ian.campbell@citrix.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/xen-netback/netback.c |   13 ++++++++++++-
 1 file changed, 12 insertions(+), 1 deletion(-)

--- a/drivers/net/xen-netback/netback.c
+++ b/drivers/net/xen-netback/netback.c
@@ -978,7 +978,7 @@ static struct gnttab_copy *xen_netbk_get
 		pending_idx = netbk->pending_ring[index];
 		page = xen_netbk_alloc_page(netbk, skb, pending_idx);
 		if (!page)
-			return NULL;
+			goto err;
 
 		gop->source.u.ref = txp->gref;
 		gop->source.domid = vif->domid;
@@ -1000,6 +1000,17 @@ static struct gnttab_copy *xen_netbk_get
 	}
 
 	return gop;
+err:
+	/* Unwind, freeing all pages and sending error responses. */
+	while (i-- > start) {
+		xen_netbk_idx_release(netbk, frag_get_pending_idx(&frags[i]),
+				      XEN_NETIF_RSP_ERROR);
+	}
+	/* The head too, if necessary. */
+	if (start)
+		xen_netbk_idx_release(netbk, pending_idx, XEN_NETIF_RSP_ERROR);
+
+	return NULL;
 }
 
 static int xen_netbk_tx_check_gop(struct xen_netbk *netbk,


