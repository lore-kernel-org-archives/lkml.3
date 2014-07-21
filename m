Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754684AbaGUKlT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jul 2014 06:41:19 -0400
Received: from smtp.citrix.com ([66.165.176.89]:23103 "EHLO SMTP.CITRIX.COM"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754350AbaGUKlR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jul 2014 06:41:17 -0400
X-IronPort-AV: E=Sophos;i="5.01,699,1400025600"; 
   d="scan'208";a="154165745"
From: Zoltan Kiss <zoltan.kiss@citrix.com>
To: Wei Liu <wei.liu2@citrix.com>, Ian Campbell <Ian.Campbell@citrix.com>
CC: Zoltan Kiss <zoltan.kiss@citrix.com>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <xen-devel@lists.xenproject.org>
Subject: [PATCH for stable 3.15 1/4 v2] xen-netback: Fix handling frag_list on grant op error path
Date: Mon, 21 Jul 2014 11:40:59 +0100
Message-ID: <1405939262-7944-1-git-send-email-zoltan.kiss@citrix.com>
X-Mailer: git-send-email 1.9.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.80.2.133]
X-DLP: MIA2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The error handling for skb's with frag_list was completely wrong, it caused
double unmap attempts to happen if the error was on the first skb. Move it to
the right place in the loop.

Signed-off-by: Zoltan Kiss <zoltan.kiss@citrix.com>
Reported-by: Armin Zentai <armin.zentai@ezit.hu>
Cc: netdev@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Cc: xen-devel@lists.xenproject.org
---
v2: grammar change in comment

diff --git a/drivers/net/xen-netback/netback.c b/drivers/net/xen-netback/netback.c
index 7367208..d7ae93d 100644
--- a/drivers/net/xen-netback/netback.c
+++ b/drivers/net/xen-netback/netback.c
@@ -1007,10 +1007,16 @@ static int xenvif_tx_check_gop(struct xenvif *vif,
 {
 	struct gnttab_map_grant_ref *gop_map = *gopp_map;
 	u16 pending_idx = XENVIF_TX_CB(skb)->pending_idx;
+	/* This always points to the shinfo of the skb being checked, which
+	 * could be either the first or the one on the frag_list
+	 */
 	struct skb_shared_info *shinfo = skb_shinfo(skb);
+	/* If this is non-NULL, we are currently checking the frag_list skb, and
+	 * this points to the shinfo of the first one
+	 */
+	struct skb_shared_info *first_shinfo = NULL;
 	int nr_frags = shinfo->nr_frags;
 	int i, err;
-	struct sk_buff *first_skb = NULL;
 
 	/* Check status of header. */
 	err = (*gopp_copy)->status;
@@ -1063,31 +1069,28 @@ check_frags:
 			xenvif_idx_unmap(vif, pending_idx);
 		}
 
+		/* And if we found the error while checking the frag_list, unmap
+		 * the first skb's frags
+		 */
+		if (first_shinfo) {
+			for (j = 0; j < first_shinfo->nr_frags; j++) {
+				pending_idx = frag_get_pending_idx(&first_shinfo->frags[j]);
+				xenvif_idx_unmap(vif, pending_idx);
+			}
+		}
+
 		/* Remember the error: invalidate all subsequent fragments. */
 		err = newerr;
 	}
 
-	if (skb_has_frag_list(skb)) {
-		first_skb = skb;
-		skb = shinfo->frag_list;
-		shinfo = skb_shinfo(skb);
+	if (skb_has_frag_list(skb) && !first_shinfo) {
+		first_shinfo = skb_shinfo(skb);
+		shinfo = skb_shinfo(skb_shinfo(skb)->frag_list);
 		nr_frags = shinfo->nr_frags;
 
 		goto check_frags;
 	}
 
-	/* There was a mapping error in the frag_list skb. We have to unmap
-	 * the first skb's frags
-	 */
-	if (first_skb && err) {
-		int j;
-		shinfo = skb_shinfo(first_skb);
-		for (j = 0; j < shinfo->nr_frags; j++) {
-			pending_idx = frag_get_pending_idx(&shinfo->frags[j]);
-			xenvif_idx_unmap(vif, pending_idx);
-		}
-	}
-
 	*gopp_map = gop_map;
 	return err;
 }
