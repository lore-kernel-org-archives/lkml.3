Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965637AbaFQVpt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jun 2014 17:45:49 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:53721 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965614AbaFQVpq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jun 2014 17:45:46 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Antonio Quartulli <antonio@open-mesh.com>,
        Marek Lindner <mareklindner@neomailbox.ch>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13 059/212] batman-adv: increase orig refcount when storing ref in gw_node
Date: Tue, 17 Jun 2014 14:42:33 -0700
Message-Id: <1403041506-13646-60-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1403041506-13646-1-git-send-email-kamal@canonical.com>
References: <1403041506-13646-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11.4 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Antonio Quartulli <antonio@open-mesh.com>

[ Upstream commit 377fe0f968b30a1a714fab53a908061914f30e26 ]

A pointer to the orig_node representing a bat-gateway is
stored in the gw_node->orig_node member, but the refcount
for such orig_node is never increased.
This leads to memory faults when gw_node->orig_node is accessed
and the originator has already been freed.

Fix this by increasing the refcount on gw_node creation
and decreasing it on gw_node free.

Signed-off-by: Antonio Quartulli <antonio@open-mesh.com>
Signed-off-by: Marek Lindner <mareklindner@neomailbox.ch>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 net/batman-adv/gateway_client.c | 11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

diff --git a/net/batman-adv/gateway_client.c b/net/batman-adv/gateway_client.c
index 2449afa..68676cd 100644
--- a/net/batman-adv/gateway_client.c
+++ b/net/batman-adv/gateway_client.c
@@ -38,8 +38,10 @@
 
 static void batadv_gw_node_free_ref(struct batadv_gw_node *gw_node)
 {
-	if (atomic_dec_and_test(&gw_node->refcount))
+	if (atomic_dec_and_test(&gw_node->refcount)) {
+		batadv_orig_node_free_ref(gw_node->orig_node);
 		kfree_rcu(gw_node, rcu);
+	}
 }
 
 static struct batadv_gw_node *
@@ -351,9 +353,14 @@ static void batadv_gw_node_add(struct batadv_priv *bat_priv,
 	if (gateway->bandwidth_down == 0)
 		return;
 
+	if (!atomic_inc_not_zero(&orig_node->refcount))
+		return;
+
 	gw_node = kzalloc(sizeof(*gw_node), GFP_ATOMIC);
-	if (!gw_node)
+	if (!gw_node) {
+		batadv_orig_node_free_ref(orig_node);
 		return;
+	}
 
 	INIT_HLIST_NODE(&gw_node->list);
 	gw_node->orig_node = orig_node;
-- 
1.9.1

