Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756669Ab3FDOI6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Jun 2013 10:08:58 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:46987 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756603Ab3FDOIw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Jun 2013 10:08:52 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Wei Liu <wei.liu2@citrix.com>, "David S. Miller" <davem@davemloft.net>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 69/70] xen-netfront: frags -> slots in xennet_get_responses
Date: Tue,  4 Jun 2013 15:07:25 +0100
Message-Id: <1370354846-14213-70-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1370354846-14213-1-git-send-email-luis.henriques@canonical.com>
References: <1370354846-14213-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.14 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Wei Liu <wei.liu2@citrix.com>

commit 7158ff6d0c6aa3724fb51c6c11143d31e166eb1f upstream.

This function is in fact counting the ring slots required for responses.
Separate the concepts of ring slots and skb frags make the code clearer, as
now netfront and netback can have different MAX_SKB_FRAGS, slot and frag are
not mapped 1:1 any more.

Signed-off-by: Wei Liu <wei.liu2@citrix.com>
Reviewed-by: David Vrabel <david.vrabel@citrix.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/net/xen-netfront.c | 18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)

diff --git a/drivers/net/xen-netfront.c b/drivers/net/xen-netfront.c
index 0ab0da4..9f09606 100644
--- a/drivers/net/xen-netfront.c
+++ b/drivers/net/xen-netfront.c
@@ -656,7 +656,7 @@ static int xennet_get_responses(struct netfront_info *np,
 	struct sk_buff *skb = xennet_get_rx_skb(np, cons);
 	grant_ref_t ref = xennet_get_rx_ref(np, cons);
 	int max = MAX_SKB_FRAGS + (rx->status <= RX_COPY_THRESHOLD);
-	int frags = 1;
+	int slots = 1;
 	int err = 0;
 	unsigned long ret;
 
@@ -700,27 +700,27 @@ next:
 		if (!(rx->flags & XEN_NETRXF_more_data))
 			break;
 
-		if (cons + frags == rp) {
+		if (cons + slots == rp) {
 			if (net_ratelimit())
-				dev_warn(dev, "Need more frags\n");
+				dev_warn(dev, "Need more slots\n");
 			err = -ENOENT;
 			break;
 		}
 
-		rx = RING_GET_RESPONSE(&np->rx, cons + frags);
-		skb = xennet_get_rx_skb(np, cons + frags);
-		ref = xennet_get_rx_ref(np, cons + frags);
-		frags++;
+		rx = RING_GET_RESPONSE(&np->rx, cons + slots);
+		skb = xennet_get_rx_skb(np, cons + slots);
+		ref = xennet_get_rx_ref(np, cons + slots);
+		slots++;
 	}
 
-	if (unlikely(frags > max)) {
+	if (unlikely(slots > max)) {
 		if (net_ratelimit())
 			dev_warn(dev, "Too many frags\n");
 		err = -E2BIG;
 	}
 
 	if (unlikely(err))
-		np->rx.rsp_cons = cons + frags;
+		np->rx.rsp_cons = cons + slots;
 
 	return err;
 }
-- 
1.8.1.2

