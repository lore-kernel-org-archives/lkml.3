Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757507AbaE2N5Q (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2014 09:57:16 -0400
Received: from ip4-83-240-18-248.cust.nbox.cz ([83.240.18.248]:59481 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933473AbaE2Ntd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2014 09:49:33 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
        Toshiaki Makita <makita.toshiaki@lab.ntt.co.jp>,
        "David S. Miller" <davem@davemloft.net>, Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 063/103] bridge: Fix double free and memory leak around br_allowed_ingress
Date: Thu, 29 May 2014 15:48:48 +0200
Message-Id: <262cacfba2c885aa7b45433e824eb67636323c65.1401371259.git.jslaby@suse.cz>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <bcbac220dab16a4038ac1a7c5cfe3e7f034b3836.1401371258.git.jslaby@suse.cz>
References: <bcbac220dab16a4038ac1a7c5cfe3e7f034b3836.1401371258.git.jslaby@suse.cz>
In-Reply-To: <cover.1401371258.git.jslaby@suse.cz>
References: <cover.1401371258.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Toshiaki Makita <makita.toshiaki@lab.ntt.co.jp>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

[ Upstream commit eb7076182d1ae4bc4641534134ed707100d76acc ]

br_allowed_ingress() has two problems.

1. If br_allowed_ingress() is called by br_handle_frame_finish() and
vlan_untag() in br_allowed_ingress() fails, skb will be freed by both
vlan_untag() and br_handle_frame_finish().

2. If br_allowed_ingress() is called by br_dev_xmit() and
br_allowed_ingress() fails, the skb will not be freed.

Fix these two problems by freeing the skb in br_allowed_ingress()
if it fails.

Signed-off-by: Toshiaki Makita <makita.toshiaki@lab.ntt.co.jp>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 net/bridge/br_input.c | 2 +-
 net/bridge/br_vlan.c  | 7 ++++---
 2 files changed, 5 insertions(+), 4 deletions(-)

diff --git a/net/bridge/br_input.c b/net/bridge/br_input.c
index a2fd37ec35f7..c378750602cd 100644
--- a/net/bridge/br_input.c
+++ b/net/bridge/br_input.c
@@ -72,7 +72,7 @@ int br_handle_frame_finish(struct sk_buff *skb)
 		goto drop;
 
 	if (!br_allowed_ingress(p->br, nbp_get_vlan_info(p), skb, &vid))
-		goto drop;
+		goto out;
 
 	/* insert into forwarding database after filtering to avoid spoofing */
 	br = p->br;
diff --git a/net/bridge/br_vlan.c b/net/bridge/br_vlan.c
index 53f0990eab58..45a26debe64e 100644
--- a/net/bridge/br_vlan.c
+++ b/net/bridge/br_vlan.c
@@ -201,7 +201,7 @@ bool br_allowed_ingress(struct net_bridge *br, struct net_port_vlans *v,
 	 * rejected.
 	 */
 	if (!v)
-		return false;
+		goto drop;
 
 	err = br_vlan_get_tag(skb, vid);
 	if (!*vid) {
@@ -212,7 +212,7 @@ bool br_allowed_ingress(struct net_bridge *br, struct net_port_vlans *v,
 		 * vlan untagged or priority-tagged traffic belongs to.
 		 */
 		if (pvid == VLAN_N_VID)
-			return false;
+			goto drop;
 
 		/* PVID is set on this port.  Any untagged or priority-tagged
 		 * ingress frame is considered to belong to this vlan.
@@ -235,7 +235,8 @@ bool br_allowed_ingress(struct net_bridge *br, struct net_port_vlans *v,
 	/* Frame had a valid vlan tag.  See if vlan is allowed */
 	if (test_bit(*vid, v->vlan_bitmap))
 		return true;
-
+drop:
+	kfree_skb(skb);
 	return false;
 }
 
-- 
1.9.3

