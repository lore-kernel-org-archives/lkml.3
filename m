Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933131AbaHHVPY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Aug 2014 17:15:24 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:41068 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932610AbaHHUvv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Aug 2014 16:51:51 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Li RongQing <roy.qing.li@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13 235/259] 8021q: fix a potential memory leak
Date: Fri,  8 Aug 2014 13:40:58 -0700
Message-Id: <1407530482-4483-236-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1407530482-4483-1-git-send-email-kamal@canonical.com>
References: <1407530482-4483-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11.6 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Li RongQing <roy.qing.li@gmail.com>

[ Upstream commit 916c1689a09bc1ca81f2d7a34876f8d35aadd11b ]

skb_cow called in vlan_reorder_header does not free the skb when it failed,
and vlan_reorder_header returns NULL to reset original skb when it is called
in vlan_untag, lead to a memory leak.

Signed-off-by: Li RongQing <roy.qing.li@gmail.com>
Acked-by: Eric Dumazet <edumazet@google.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 net/8021q/vlan_core.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/net/8021q/vlan_core.c b/net/8021q/vlan_core.c
index 6ee48aa..7e57135 100644
--- a/net/8021q/vlan_core.c
+++ b/net/8021q/vlan_core.c
@@ -108,8 +108,11 @@ EXPORT_SYMBOL(vlan_dev_vlan_id);
 
 static struct sk_buff *vlan_reorder_header(struct sk_buff *skb)
 {
-	if (skb_cow(skb, skb_headroom(skb)) < 0)
+	if (skb_cow(skb, skb_headroom(skb)) < 0) {
+		kfree_skb(skb);
 		return NULL;
+	}
+
 	memmove(skb->data - ETH_HLEN, skb->data - VLAN_ETH_HLEN, 2 * ETH_ALEN);
 	skb->mac_header += VLAN_HLEN;
 	return skb;
-- 
1.9.1

