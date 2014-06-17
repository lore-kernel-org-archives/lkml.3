Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966052AbaFQWsl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jun 2014 18:48:41 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:53711 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965589AbaFQVpm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jun 2014 17:45:42 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: =?UTF-8?q?Martin=20Hundeb=C3=B8ll?= <martin@hundeboll.net>,
        Antonio Quartulli <antonio@open-mesh.com>,
        Marek Lindner <mareklindner@neomailbox.ch>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13 058/212] batman-adv: fix reference counting imbalance while sending fragment
Date: Tue, 17 Jun 2014 14:42:32 -0700
Message-Id: <1403041506-13646-59-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1403041506-13646-1-git-send-email-kamal@canonical.com>
References: <1403041506-13646-1-git-send-email-kamal@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11.4 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Antonio Quartulli <antonio@open-mesh.com>

[ Upstream commit be181015a189cd141398b761ba4e79d33fe69949 ]

In the new fragmentation code the batadv_frag_send_packet()
function obtains a reference to the primary_if, but it does
not release it upon return.

This reference imbalance prevents the primary_if (and then
the related netdevice) to be properly released on shut down.

Fix this by releasing the primary_if in batadv_frag_send_packet().

Introduced by ee75ed88879af88558818a5c6609d85f60ff0df4
("batman-adv: Fragment and send skbs larger than mtu")

Cc: Martin Hundebøll <martin@hundeboll.net>
Signed-off-by: Antonio Quartulli <antonio@open-mesh.com>
Signed-off-by: Marek Lindner <mareklindner@neomailbox.ch>
Acked-by: Martin Hundebøll <martin@hundeboll.net>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 net/batman-adv/fragmentation.c | 11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

diff --git a/net/batman-adv/fragmentation.c b/net/batman-adv/fragmentation.c
index 6ddb614..a674034 100644
--- a/net/batman-adv/fragmentation.c
+++ b/net/batman-adv/fragmentation.c
@@ -420,12 +420,13 @@ bool batadv_frag_send_packet(struct sk_buff *skb,
 			     struct batadv_neigh_node *neigh_node)
 {
 	struct batadv_priv *bat_priv;
-	struct batadv_hard_iface *primary_if;
+	struct batadv_hard_iface *primary_if = NULL;
 	struct batadv_frag_packet frag_header;
 	struct sk_buff *skb_fragment;
 	unsigned mtu = neigh_node->if_incoming->net_dev->mtu;
 	unsigned header_size = sizeof(frag_header);
 	unsigned max_fragment_size, max_packet_size;
+	bool ret = false;
 
 	/* To avoid merge and refragmentation at next-hops we never send
 	 * fragments larger than BATADV_FRAG_MAX_FRAG_SIZE
@@ -485,7 +486,11 @@ bool batadv_frag_send_packet(struct sk_buff *skb,
 			   skb->len + ETH_HLEN);
 	batadv_send_skb_packet(skb, neigh_node->if_incoming, neigh_node->addr);
 
-	return true;
+	ret = true;
+
 out_err:
-	return false;
+	if (primary_if)
+		batadv_hardif_free_ref(primary_if);
+
+	return ret;
 }
-- 
1.9.1

