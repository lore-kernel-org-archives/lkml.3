Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754346AbaG3Mfb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jul 2014 08:35:31 -0400
Received: from ip4-83-240-18-248.cust.nbox.cz ([83.240.18.248]:36710 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752869AbaG3MPc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jul 2014 08:15:32 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Li RongQing <roy.qing.li@gmail.com>,
        "David S. Miller" <davem@davemloft.net>, Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 36/94] 8021q: fix a potential memory leak
Date: Wed, 30 Jul 2014 14:14:25 +0200
Message-Id: <50cd0c7603e48063dd2bc0954416889f9431fecf.1406722270.git.jslaby@suse.cz>
X-Mailer: git-send-email 2.0.1
In-Reply-To: <e43bbc2c2b44d8f0bd0b7f65d6fd50ef738c57aa.1406722270.git.jslaby@suse.cz>
References: <e43bbc2c2b44d8f0bd0b7f65d6fd50ef738c57aa.1406722270.git.jslaby@suse.cz>
In-Reply-To: <cover.1406722269.git.jslaby@suse.cz>
References: <cover.1406722269.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Li RongQing <roy.qing.li@gmail.com>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

[ Upstream commit 916c1689a09bc1ca81f2d7a34876f8d35aadd11b ]

skb_cow called in vlan_reorder_header does not free the skb when it failed,
and vlan_reorder_header returns NULL to reset original skb when it is called
in vlan_untag, lead to a memory leak.

Signed-off-by: Li RongQing <roy.qing.li@gmail.com>
Acked-by: Eric Dumazet <edumazet@google.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 net/8021q/vlan_core.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/net/8021q/vlan_core.c b/net/8021q/vlan_core.c
index 6ee48aac776f..7e57135c7cc4 100644
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
2.0.1

