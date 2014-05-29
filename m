Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932833AbaE2EgH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2014 00:36:07 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:58194 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932775AbaE2Ef7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2014 00:35:59 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Antonio Quartulli <antonio@open-mesh.com>,
        Marek Lindner <mareklindner@neomailbox.ch>
Subject: [PATCH 3.14 134/140] batman-adv: increase orig refcount when storing ref in gw_node
Date: Wed, 28 May 2014 21:34:33 -0700
Message-Id: <20140529043106.591017117@linuxfoundation.org>
X-Mailer: git-send-email 2.0.0.rc3.2.g998f840
In-Reply-To: <20140529043049.661315084@linuxfoundation.org>
References: <20140529043049.661315084@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.14-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/batman-adv/gateway_client.c |   11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

--- a/net/batman-adv/gateway_client.c
+++ b/net/batman-adv/gateway_client.c
@@ -42,8 +42,10 @@
 
 static void batadv_gw_node_free_ref(struct batadv_gw_node *gw_node)
 {
-	if (atomic_dec_and_test(&gw_node->refcount))
+	if (atomic_dec_and_test(&gw_node->refcount)) {
+		batadv_orig_node_free_ref(gw_node->orig_node);
 		kfree_rcu(gw_node, rcu);
+	}
 }
 
 static struct batadv_gw_node *
@@ -408,9 +410,14 @@ static void batadv_gw_node_add(struct ba
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


