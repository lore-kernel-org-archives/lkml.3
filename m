Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933849AbaE2FFl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2014 01:05:41 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:58189 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932767AbaE2Ef6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2014 00:35:58 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        =?UTF-8?q?Martin=20Hundeb=F8ll?= <martin@hundeboll.net>,
        Antonio Quartulli <antonio@open-mesh.com>,
        Marek Lindner <mareklindner@neomailbox.ch>
Subject: [PATCH 3.14 133/140] batman-adv: fix reference counting imbalance while sending fragment
Date: Wed, 28 May 2014 21:34:32 -0700
Message-Id: <20140529043106.429028353@linuxfoundation.org>
X-Mailer: git-send-email 2.0.0.rc3.2.g998f840
In-Reply-To: <20140529043049.661315084@linuxfoundation.org>
References: <20140529043049.661315084@linuxfoundation.org>
User-Agent: quilt/0.60-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.14-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/batman-adv/fragmentation.c |   11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

--- a/net/batman-adv/fragmentation.c
+++ b/net/batman-adv/fragmentation.c
@@ -418,12 +418,13 @@ bool batadv_frag_send_packet(struct sk_b
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
@@ -483,7 +484,11 @@ bool batadv_frag_send_packet(struct sk_b
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


