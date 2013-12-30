Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754243Ab3L3HlM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Dec 2013 02:41:12 -0500
Received: from szxga03-in.huawei.com ([119.145.14.66]:45888 "EHLO
	szxga03-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751431Ab3L3HlJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Dec 2013 02:41:09 -0500
Message-ID: <52C12373.1010502@huawei.com>
Date: Mon, 30 Dec 2013 15:40:35 +0800
From: Ding Tianhong <dingtianhong@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:24.0) Gecko/20100101 Thunderbird/24.0.1
MIME-Version: 1.0
To: Santosh Raspatur <santosh@chelsio.com>,
        "David S. Miller" <davem@davemloft.net>,
        Netdev <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH net-next v3 03/19] net: cxgb3: slight optimization of addr
 compare
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.135.72.199]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use possibly more efficient ether_addr_equal
to instead of memcmp.

Cc: Santosh Raspatur <santosh@chelsio.com>
Signed-off-by: Ding Tianhong <dingtianhong@huawei.com>
---
 drivers/net/ethernet/chelsio/cxgb3/cxgb3_offload.c | 2 +-
 drivers/net/ethernet/chelsio/cxgb3/l2t.c           | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/chelsio/cxgb3/cxgb3_offload.c b/drivers/net/ethernet/chelsio/cxgb3/cxgb3_offload.c
index 76ae0999..c0a9dd5 100644
--- a/drivers/net/ethernet/chelsio/cxgb3/cxgb3_offload.c
+++ b/drivers/net/ethernet/chelsio/cxgb3/cxgb3_offload.c
@@ -182,7 +182,7 @@ static struct net_device *get_iff_from_mac(struct adapter *adapter,
 	for_each_port(adapter, i) {
 		struct net_device *dev = adapter->port[i];
 
-		if (!memcmp(dev->dev_addr, mac, ETH_ALEN)) {
+		if (ether_addr_equal(dev->dev_addr, mac)) {
 			rcu_read_lock();
 			if (vlan && vlan != VLAN_VID_MASK) {
 				dev = __vlan_find_dev_deep(dev, htons(ETH_P_8021Q), vlan);
diff --git a/drivers/net/ethernet/chelsio/cxgb3/l2t.c b/drivers/net/ethernet/chelsio/cxgb3/l2t.c
index 8d53438..5f226ed 100644
--- a/drivers/net/ethernet/chelsio/cxgb3/l2t.c
+++ b/drivers/net/ethernet/chelsio/cxgb3/l2t.c
@@ -429,7 +429,7 @@ found:
 		} else {
 			e->state = neigh->nud_state & NUD_CONNECTED ?
 			    L2T_STATE_VALID : L2T_STATE_STALE;
-			if (memcmp(e->dmac, neigh->ha, 6))
+			if (!ether_addr_equal(e->dmac, neigh->ha))
 				setup_l2e_send_pending(dev, NULL, e);
 		}
 	}
-- 
1.8.0


