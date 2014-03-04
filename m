Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758105AbaCDV1s (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2014 16:27:48 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:40924 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756019AbaCDUDO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2014 15:03:14 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Russell Senior <russell@personaltelco.net>,
        Antonio Quartulli <antonio@meshcoding.com>,
        Marek Lindner <mareklindner@neomailbox.ch>
Subject: [PATCH 3.13 063/172] batman-adv: fix soft-interface MTU computation
Date: Tue,  4 Mar 2014 12:02:27 -0800
Message-Id: <20140304200301.757288975@linuxfoundation.org>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <20140304200259.626667112@linuxfoundation.org>
References: <20140304200259.626667112@linuxfoundation.org>
User-Agent: quilt/0.61-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Antonio Quartulli <antonio@meshcoding.com>

[ Upstream commit 930cd6e46eadce8b8ed2a232ee536e5fd286c152 ]

The current MTU computation always returns a value
smaller than 1500bytes even if the real interfaces
have an MTU large enough to compensate the batman-adv
overhead.

Fix the computation by properly returning the highest
admitted value.

Introduced by a19d3d85e1b854e4a483a55d740a42458085560d
("batman-adv: limit local translation table max size")

Reported-by: Russell Senior <russell@personaltelco.net>
Signed-off-by: Antonio Quartulli <antonio@meshcoding.com>
Signed-off-by: Marek Lindner <mareklindner@neomailbox.ch>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/batman-adv/hard-interface.c |   22 ++++++++++++++--------
 1 file changed, 14 insertions(+), 8 deletions(-)

--- a/net/batman-adv/hard-interface.c
+++ b/net/batman-adv/hard-interface.c
@@ -244,7 +244,7 @@ int batadv_hardif_min_mtu(struct net_dev
 {
 	struct batadv_priv *bat_priv = netdev_priv(soft_iface);
 	const struct batadv_hard_iface *hard_iface;
-	int min_mtu = ETH_DATA_LEN;
+	int min_mtu = INT_MAX;
 
 	rcu_read_lock();
 	list_for_each_entry_rcu(hard_iface, &batadv_hardif_list, list) {
@@ -259,8 +259,6 @@ int batadv_hardif_min_mtu(struct net_dev
 	}
 	rcu_read_unlock();
 
-	atomic_set(&bat_priv->packet_size_max, min_mtu);
-
 	if (atomic_read(&bat_priv->fragmentation) == 0)
 		goto out;
 
@@ -271,13 +269,21 @@ int batadv_hardif_min_mtu(struct net_dev
 	min_mtu = min_t(int, min_mtu, BATADV_FRAG_MAX_FRAG_SIZE);
 	min_mtu -= sizeof(struct batadv_frag_packet);
 	min_mtu *= BATADV_FRAG_MAX_FRAGMENTS;
-	atomic_set(&bat_priv->packet_size_max, min_mtu);
-
-	/* with fragmentation enabled we can fragment external packets easily */
-	min_mtu = min_t(int, min_mtu, ETH_DATA_LEN);
 
 out:
-	return min_mtu - batadv_max_header_len();
+	/* report to the other components the maximum amount of bytes that
+	 * batman-adv can send over the wire (without considering the payload
+	 * overhead). For example, this value is used by TT to compute the
+	 * maximum local table table size
+	 */
+	atomic_set(&bat_priv->packet_size_max, min_mtu);
+
+	/* the real soft-interface MTU is computed by removing the payload
+	 * overhead from the maximum amount of bytes that was just computed.
+	 *
+	 * However batman-adv does not support MTUs bigger than ETH_DATA_LEN
+	 */
+	return min_t(int, min_mtu - batadv_max_header_len(), ETH_DATA_LEN);
 }
 
 /* adjusts the MTU if a new interface with a smaller MTU appeared. */


