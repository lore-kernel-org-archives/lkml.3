Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753491AbaATRwl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jan 2014 12:52:41 -0500
Received: from smtprelay0015.hostedemail.com ([216.40.44.15]:35805 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752156AbaATRwf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jan 2014 12:52:35 -0500
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,::::::,RULES_HIT:41:355:379:541:800:960:973:981:988:989:1260:1345:1359:1437:1534:1542:1711:1730:1747:1777:1792:2198:2199:2393:2559:2562:3138:3139:3140:3141:3142:3353:3866:3867:3868:4321:5007:6117:6119:6261:7903:10004:10026:10848:11026:11473:11658:11914:12043:12296:12438:12517:12519:12555,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: skirt98_337d3391f535f
X-Filterd-Recvd-Size: 3064
From: Joe Perches <joe@perches.com>
To: David Miller <davem@davemloft.net>
Cc: "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 3/7] atm: Use ether_addr_copy
Date: Mon, 20 Jan 2014 09:52:16 -0800
Message-Id: <891b9869ad352a40f4e8f6dea28cf2da0ce6fde7.1390239869.git.joe@perches.com>
X-Mailer: git-send-email 1.8.1.2.459.gbcd45b4.dirty
In-Reply-To: <cover.1390239869.git.joe@perches.com>
References: <cover.1390239869.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use ether_addr_copy instead of memcpy(a, b, ETH_ALEN) to
save some cycles on arm and powerpc.

Signed-off-by: Joe Perches <joe@perches.com>
---
 net/atm/lec.c | 9 +++++----
 net/atm/mpc.c | 2 +-
 2 files changed, 6 insertions(+), 5 deletions(-)

diff --git a/net/atm/lec.c b/net/atm/lec.c
index f23916b..0b73ae9 100644
--- a/net/atm/lec.c
+++ b/net/atm/lec.c
@@ -521,7 +521,7 @@ send_to_lecd(struct lec_priv *priv, atmlec_msg_type type,
 	if (data != NULL)
 		mesg->sizeoftlvs = data->len;
 	if (mac_addr)
-		memcpy(&mesg->content.normal.mac_addr, mac_addr, ETH_ALEN);
+		ether_addr_copy(&mesg->content.normal.mac_addr, mac_addr);
 	else
 		mesg->content.normal.targetless_le_arp = 1;
 	if (atm_addr)
@@ -1565,7 +1565,7 @@ static struct lec_arp_table *make_entry(struct lec_priv *priv,
 		pr_info("LEC: Arp entry kmalloc failed\n");
 		return NULL;
 	}
-	memcpy(to_return->mac_addr, mac_addr, ETH_ALEN);
+	ether_addr_copy(to_return->mac_addr, mac_addr);
 	INIT_HLIST_NODE(&to_return->next);
 	setup_timer(&to_return->timer, lec_arp_expire_arp,
 			(unsigned long)to_return);
@@ -1887,7 +1887,8 @@ lec_arp_update(struct lec_priv *priv, const unsigned char *mac_addr,
 					entry = tmp;
 				} else {
 					entry->status = ESI_FORWARD_DIRECT;
-					memcpy(entry->mac_addr, mac_addr, ETH_ALEN);
+					ether_addr_copy(entry->mac_addr,
+							mac_addr);
 					entry->last_used = jiffies;
 					lec_arp_add(priv, entry);
 				}
@@ -2263,7 +2264,7 @@ lec_arp_check_empties(struct lec_priv *priv,
 				  &priv->lec_arp_empty_ones, next) {
 		if (vcc == entry->vcc) {
 			del_timer(&entry->timer);
-			memcpy(entry->mac_addr, src, ETH_ALEN);
+			ether_addr_copy(entry->mac_addr, src);
 			entry->status = ESI_FORWARD_DIRECT;
 			entry->last_used = jiffies;
 			/* We might have got an entry */
diff --git a/net/atm/mpc.c b/net/atm/mpc.c
index 3af1275..b71ff6b 100644
--- a/net/atm/mpc.c
+++ b/net/atm/mpc.c
@@ -478,7 +478,7 @@ static const uint8_t *copy_macs(struct mpoa_client *mpc,
 			return NULL;
 		}
 	}
-	memcpy(mpc->mps_macs, router_mac, ETH_ALEN);
+	ether_addr_copy(mpc->mps_macs, router_mac);
 	tlvs += 20; if (device_type == MPS_AND_MPC) tlvs += 20;
 	if (mps_macs > 0)
 		memcpy(mpc->mps_macs, tlvs, mps_macs*ETH_ALEN);
-- 
1.8.1.2.459.gbcd45b4.dirty

