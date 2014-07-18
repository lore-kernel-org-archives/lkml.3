Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422930AbaGRSJG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2014 14:09:06 -0400
Received: from smtp.citrix.com ([66.165.176.89]:16605 "EHLO SMTP.CITRIX.COM"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1422809AbaGRSIT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2014 14:08:19 -0400
X-IronPort-AV: E=Sophos;i="5.01,686,1400025600"; 
   d="scan'208";a="153763638"
From: Zoltan Kiss <zoltan.kiss@citrix.com>
To: Wei Liu <wei.liu2@citrix.com>, Ian Campbell <Ian.Campbell@citrix.com>
CC: Zoltan Kiss <zoltan.kiss@citrix.com>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <xen-devel@lists.xenproject.org>
Subject: [PATCH net 2/4 v2] xen-netback: Fix releasing frag_list skbs in error path
Date: Fri, 18 Jul 2014 19:08:03 +0100
Message-ID: <1405706885-16763-3-git-send-email-zoltan.kiss@citrix.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1405706885-16763-1-git-send-email-zoltan.kiss@citrix.com>
References: <1405706885-16763-1-git-send-email-zoltan.kiss@citrix.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.80.2.133]
X-DLP: MIA1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When the grant operations failed, the skb is freed up eventually, and it tries
to release the frags, if there is any. For the main skb nr_frags is set to 0 to
avoid this, but on the frag_list it iterates through the frags array, and tries
to call put_page on the page pointer which contains garbage at that time.

Signed-off-by: Zoltan Kiss <zoltan.kiss@citrix.com>
Reported-by: Armin Zentai <armin.zentai@ezit.hu>
Cc: netdev@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Cc: xen-devel@lists.xenproject.org
---
v2: adding comment
diff --git a/drivers/net/xen-netback/netback.c b/drivers/net/xen-netback/netback.c
index a773f20..8cbf60d 100644
--- a/drivers/net/xen-netback/netback.c
+++ b/drivers/net/xen-netback/netback.c
@@ -1521,7 +1521,16 @@ static int xenvif_tx_submit(struct xenvif_queue *queue)
 
 		/* Check the remap error code. */
 		if (unlikely(xenvif_tx_check_gop(queue, skb, &gop_map, &gop_copy))) {
+			/* If there was an error, xenvif_tx_check_gop is
+			 * expected to release all the frags which were mapped,
+			 * so kfree_skb shouldn't do it again
+			 */
 			skb_shinfo(skb)->nr_frags = 0;
+			if (skb_has_frag_list(skb)) {
+				struct sk_buff *nskb =
+						skb_shinfo(skb)->frag_list;
+				skb_shinfo(nskb)->nr_frags = 0;
+			}
 			kfree_skb(skb);
 			continue;
 		}
