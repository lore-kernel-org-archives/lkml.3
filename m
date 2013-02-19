Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933477Ab3BSSwo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Feb 2013 13:52:44 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:54354 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932886Ab3BSSwl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Feb 2013 13:52:41 -0500
From: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Somnath Kotur <somnath.kotur@emulex.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jacek Luczak <difrost.kernel@gmail.com>,
        Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
Subject: [PATCH 42/81] be2net: Fix to trim skb for padded vlan packets to workaround an ASIC Bug
Date: Tue, 19 Feb 2013 15:49:05 -0300
Message-Id: <1361299784-8830-43-git-send-email-herton.krzesinski@canonical.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1361299784-8830-1-git-send-email-herton.krzesinski@canonical.com>
References: <1361299784-8830-1-git-send-email-herton.krzesinski@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.6 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Somnath Kotur <somnath.kotur@emulex.com>

commit 93040ae5cc8dcc893eca4a4366dc8415af278edf upstream.

Fixed spelling error in a comment as pointed out by DaveM.
Also refactored existing code a bit to provide placeholders for another ASIC
Bug workaround that will be checked-in soon after this.

Signed-off-by: Somnath Kotur <somnath.kotur@emulex.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Cc: Jacek Luczak <difrost.kernel@gmail.com>
[ herton: adjust context ]
Signed-off-by: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
---
 drivers/net/ethernet/emulex/benet/be.h      |    5 +++
 drivers/net/ethernet/emulex/benet/be_main.c |   56 ++++++++++++++++++++-------
 2 files changed, 47 insertions(+), 14 deletions(-)

diff --git a/drivers/net/ethernet/emulex/benet/be.h b/drivers/net/ethernet/emulex/benet/be.h
index c5c4c0e..793ee6b 100644
--- a/drivers/net/ethernet/emulex/benet/be.h
+++ b/drivers/net/ethernet/emulex/benet/be.h
@@ -573,6 +573,11 @@ static inline u8 is_udp_pkt(struct sk_buff *skb)
 	return val;
 }
 
+static inline bool is_ipv4_pkt(struct sk_buff *skb)
+{
+	return skb->protocol == ntohs(ETH_P_IP) && ip_hdr(skb)->version == 4;
+}
+
 static inline void be_vf_eth_addr_generate(struct be_adapter *adapter, u8 *mac)
 {
 	u32 addr;
diff --git a/drivers/net/ethernet/emulex/benet/be_main.c b/drivers/net/ethernet/emulex/benet/be_main.c
index bd5cf7e..dc36f5c 100644
--- a/drivers/net/ethernet/emulex/benet/be_main.c
+++ b/drivers/net/ethernet/emulex/benet/be_main.c
@@ -576,6 +576,11 @@ static inline u16 be_get_tx_vlan_tag(struct be_adapter *adapter,
 	return vlan_tag;
 }
 
+static int be_vlan_tag_chk(struct be_adapter *adapter, struct sk_buff *skb)
+{
+	return vlan_tx_tag_present(skb) || adapter->pvid;
+}
+
 static void wrb_fill_hdr(struct be_adapter *adapter, struct be_eth_hdr_wrb *hdr,
 		struct sk_buff *skb, u32 wrb_cnt, u32 len)
 {
@@ -703,33 +708,56 @@ dma_err:
 	return 0;
 }
 
+static struct sk_buff *be_insert_vlan_in_pkt(struct be_adapter *adapter,
+					     struct sk_buff *skb)
+{
+	u16 vlan_tag = 0;
+
+	skb = skb_share_check(skb, GFP_ATOMIC);
+	if (unlikely(!skb))
+		return skb;
+
+	if (vlan_tx_tag_present(skb)) {
+		vlan_tag = be_get_tx_vlan_tag(adapter, skb);
+		__vlan_put_tag(skb, vlan_tag);
+		skb->vlan_tci = 0;
+	}
+
+	return skb;
+}
+
 static netdev_tx_t be_xmit(struct sk_buff *skb,
 			struct net_device *netdev)
 {
 	struct be_adapter *adapter = netdev_priv(netdev);
 	struct be_tx_obj *txo = &adapter->tx_obj[skb_get_queue_mapping(skb)];
 	struct be_queue_info *txq = &txo->q;
+	struct iphdr *ip = NULL;
 	u32 wrb_cnt = 0, copied = 0;
-	u32 start = txq->head;
+	u32 start = txq->head, eth_hdr_len;
 	bool dummy_wrb, stopped = false;
 
-	/* For vlan tagged pkts, BE
-	 * 1) calculates checksum even when CSO is not requested
-	 * 2) calculates checksum wrongly for padded pkt less than
-	 * 60 bytes long.
-	 * As a workaround disable TX vlan offloading in such cases.
+	eth_hdr_len = ntohs(skb->protocol) == ETH_P_8021Q ?
+		VLAN_ETH_HLEN : ETH_HLEN;
+
+	/* HW has a bug which considers padding bytes as legal
+	 * and modifies the IPv4 hdr's 'tot_len' field
 	 */
-	if (unlikely(vlan_tx_tag_present(skb) &&
-		     (skb->ip_summed != CHECKSUM_PARTIAL || skb->len <= 60))) {
-		skb = skb_share_check(skb, GFP_ATOMIC);
-		if (unlikely(!skb))
-			goto tx_drop;
+	if (skb->len <= 60 && be_vlan_tag_chk(adapter, skb) &&
+			is_ipv4_pkt(skb)) {
+		ip = (struct iphdr *)ip_hdr(skb);
+		pskb_trim(skb, eth_hdr_len + ntohs(ip->tot_len));
+	}
 
-		skb = __vlan_put_tag(skb, be_get_tx_vlan_tag(adapter, skb));
+	/* HW has a bug wherein it will calculate CSUM for VLAN
+	 * pkts even though it is disabled.
+	 * Manually insert VLAN in pkt.
+	 */
+	if (skb->ip_summed != CHECKSUM_PARTIAL &&
+			be_vlan_tag_chk(adapter, skb)) {
+		skb = be_insert_vlan_in_pkt(adapter, skb);
 		if (unlikely(!skb))
 			goto tx_drop;
-
-		skb->vlan_tci = 0;
 	}
 
 	wrb_cnt = wrb_cnt_for_skb(adapter, skb, &dummy_wrb);
-- 
1.7.9.5

