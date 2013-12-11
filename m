Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751429Ab3LKFNj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Dec 2013 00:13:39 -0500
Received: from smtprelay0016.hostedemail.com ([216.40.44.16]:35101 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750800Ab3LKFM7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Dec 2013 00:12:59 -0500
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 48,2.914,0,,d41d8cd98f00b204,joe@perches.com,:::::::::::::::::,RULES_HIT:41:69:355:379:418:541:800:960:966:973:988:989:1260:1345:1359:1437:1534:1542:1711:1730:1747:1777:1792:2196:2199:2393:2559:2562:2693:3138:3139:3140:3141:3142:3353:3865:3866:3867:3871:3874:4385:5007:6261:10004:10026:10848:11026:11658:11914:12043:12296:12438:12517:12519:12555:13161:13229,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: glue61_70f6566cf5d54
X-Filterd-Recvd-Size: 3020
From: Joe Perches <joe@perches.com>
To: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: Kees Cook <keescook@chromium.org>,
        Marek Lindner <mareklindner@neomailbox.ch>,
        Simon Wunderlich <sw@simonwunderlich.de>,
        Antonio Quartulli <antonio@meshcoding.com>,
        "David S. Miller" <davem@davemloft.net>,
        b.a.t.m.a.n@lists.open-mesh.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH -next 2/3] batman-adv: Use seq_overflow
Date: Tue, 10 Dec 2013 21:12:43 -0800
Message-Id: <e7104b35287b1e1ec456734c1b5e1aa98dac99f8.1386738050.git.joe@perches.com>
X-Mailer: git-send-email 1.8.1.2.459.gbcd45b4.dirty
In-Reply-To: <cover.1386738050.git.joe@perches.com>
References: <cover.1386738050.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Convert the uses of the return of seq_printf to
instead check seq_overflow to determine if a buffer
overflow has occurred.

This will eventually allow seq_printf & seq_puts to
be converted to a void return instead of the often
misused return that is often assumed to be an int for
the number of bytes emitted ala printk.

Signed-off-by: Joe Perches <joe@perches.com>
---
 net/batman-adv/gateway_client.c | 25 ++++++++++++-------------
 1 file changed, 12 insertions(+), 13 deletions(-)

diff --git a/net/batman-adv/gateway_client.c b/net/batman-adv/gateway_client.c
index 2449afa..dfa5d2d 100644
--- a/net/batman-adv/gateway_client.c
+++ b/net/batman-adv/gateway_client.c
@@ -517,29 +517,28 @@ static int batadv_write_buffer_text(struct batadv_priv *bat_priv,
 {
 	struct batadv_gw_node *curr_gw;
 	struct batadv_neigh_node *router;
-	int ret = -1;
 
 	router = batadv_orig_node_get_router(gw_node->orig_node);
 	if (!router)
-		goto out;
+		return -1;
 
 	curr_gw = batadv_gw_get_selected_gw_node(bat_priv);
 
-	ret = seq_printf(seq, "%s %pM (%3i) %pM [%10s]: %u.%u/%u.%u MBit\n",
-			 (curr_gw == gw_node ? "=>" : "  "),
-			 gw_node->orig_node->orig,
-			 router->bat_iv.tq_avg, router->addr,
-			 router->if_incoming->net_dev->name,
-			 gw_node->bandwidth_down / 10,
-			 gw_node->bandwidth_down % 10,
-			 gw_node->bandwidth_up / 10,
-			 gw_node->bandwidth_up % 10);
+	seq_printf(seq, "%s %pM (%3i) %pM [%10s]: %u.%u/%u.%u MBit\n",
+		   (curr_gw == gw_node ? "=>" : "  "),
+		   gw_node->orig_node->orig,
+		   router->bat_iv.tq_avg, router->addr,
+		   router->if_incoming->net_dev->name,
+		   gw_node->bandwidth_down / 10,
+		   gw_node->bandwidth_down % 10,
+		   gw_node->bandwidth_up / 10,
+		   gw_node->bandwidth_up % 10);
 
 	batadv_neigh_node_free_ref(router);
 	if (curr_gw)
 		batadv_gw_node_free_ref(curr_gw);
-out:
-	return ret;
+
+	return seq_overflow(seq);
 }
 
 int batadv_gw_client_seq_print_text(struct seq_file *seq, void *offset)
-- 
1.8.1.2.459.gbcd45b4.dirty

