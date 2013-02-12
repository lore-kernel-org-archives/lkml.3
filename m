Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758886Ab3BLUmD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Feb 2013 15:42:03 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:54066 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757177Ab3BLUmA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Feb 2013 15:42:00 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Somnath Kotur <somnath.kotur@emulex.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jacek Luczak <difrost.kernel@gmail.com>
Subject: [ 36/36] be2net: Fix to trim skb for padded vlan packets to workaround an ASIC Bug
Date: Tue, 12 Feb 2013 12:41:30 -0800
Message-Id: <20130212203901.474654300@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.rc1.5.g7e0651a
In-Reply-To: <20130212203857.305594226@linuxfoundation.org>
References: <20130212203857.305594226@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Somnath Kotur <somnath.kotur@emulex.com>

commit 93040ae5cc8dcc893eca4a4366dc8415af278edf upstream.

Fixed spelling error in a comment as pointed out by DaveM.
Also refactored existing code a bit to provide placeholders for another ASIC
Bug workaround that will be checked-in soon after this.

Signed-off-by: Somnath Kotur <somnath.kotur@emulex.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Cc: Jacek Luczak <difrost.kernel@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/net/ethernet/emulex/benet/be.h      |    5 ++
 drivers/net/ethernet/emulex/benet/be_main.c |   56 +++++++++++++++++++++-------
 2 files changed, 47 insertions(+), 14 deletions(-)

--- a/drivers/net/ethernet/emulex/benet/be.h
+++ b/drivers/net/ethernet/emulex/benet/be.h
@@ -536,6 +536,11 @@ static inline void be_check_sriov_fn_typ
 	adapter->is_virtfn = (sli_intf & SLI_INTF_FT_MASK) ? 1 : 0;
 }
 
+static inline bool is_ipv4_pkt(struct sk_buff *skb)
+{
+	return skb->protocol == ntohs(ETH_P_IP) && ip_hdr(skb)->version == 4;
+}
+
 static inline void be_vf_eth_addr_generate(struct be_adapter *adapter, u8 *mac)
 {
 	u32 addr;
--- a/drivers/net/ethernet/emulex/benet/be_main.c
+++ b/drivers/net/ethernet/emulex/benet/be_main.c
@@ -571,6 +571,11 @@ static inline u16 be_get_tx_vlan_tag(str
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
@@ -698,33 +703,56 @@ dma_err:
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


