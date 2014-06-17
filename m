Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966849AbaFQWuA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jun 2014 18:50:00 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:53687 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965523AbaFQVpa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jun 2014 17:45:30 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Toshiaki Makita <makita.toshiaki@lab.ntt.co.jp>,
        "David S. Miller" <davem@davemloft.net>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13 008/212] bridge: Fix double free and memory leak around br_allowed_ingress
Date: Tue, 17 Jun 2014 14:41:42 -0700
Message-Id: <1403041506-13646-9-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1403041506-13646-1-git-send-email-kamal@canonical.com>
References: <1403041506-13646-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11.4 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Toshiaki Makita <makita.toshiaki@lab.ntt.co.jp>

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
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 net/bridge/br_input.c | 2 +-
 net/bridge/br_vlan.c  | 7 ++++---
 2 files changed, 5 insertions(+), 4 deletions(-)

diff --git a/net/bridge/br_input.c b/net/bridge/br_input.c
index 7e73c32..fa29179 100644
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
index af5ebd1..9bddc9b 100644
--- a/net/bridge/br_vlan.c
+++ b/net/bridge/br_vlan.c
@@ -193,7 +193,7 @@ bool br_allowed_ingress(struct net_bridge *br, struct net_port_vlans *v,
 	 * rejected.
 	 */
 	if (!v)
-		return false;
+		goto drop;
 
 	err = br_vlan_get_tag(skb, vid);
 	if (!*vid) {
@@ -204,7 +204,7 @@ bool br_allowed_ingress(struct net_bridge *br, struct net_port_vlans *v,
 		 * vlan untagged or priority-tagged traffic belongs to.
 		 */
 		if (pvid == VLAN_N_VID)
-			return false;
+			goto drop;
 
 		/* PVID is set on this port.  Any untagged or priority-tagged
 		 * ingress frame is considered to belong to this vlan.
@@ -227,7 +227,8 @@ bool br_allowed_ingress(struct net_bridge *br, struct net_port_vlans *v,
 	/* Frame had a valid vlan tag.  See if vlan is allowed */
 	if (test_bit(*vid, v->vlan_bitmap))
 		return true;
-
+drop:
+	kfree_skb(skb);
 	return false;
 }
 
-- 
1.9.1

