Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750870AbaABBNX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Jan 2014 20:13:23 -0500
Received: from szxga03-in.huawei.com ([119.145.14.66]:25010 "EHLO
	szxga03-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750735AbaABBNW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Jan 2014 20:13:22 -0500
Message-ID: <52C4BD1E.8020008@huawei.com>
Date: Thu, 2 Jan 2014 09:13:02 +0800
From: Ding Tianhong <dingtianhong@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:24.0) Gecko/20100101 Thunderbird/24.0.1
MIME-Version: 1.0
To: Jay Vosburgh <fubar@us.ibm.com>, Veaceslav Falico <vfalico@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Netdev <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Julia Lawall <julia.lawall@lip6.fr>
Subject: [PATCH RESEND net-next 3/7] bonding: slight optimization for bond_alb_xmit()
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.135.72.199]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The bond_alb_xmit will check the return value for
bond_dev_queue_xmit() every time, but the bond_dev_queue_xmit()
is always return 0, it is no need to check the value every time,
so remove the unneed judgement for the xmit path.

Signed-off-by: Ding Tianhong <dingtianhong@huawei.com>
---
 drivers/net/bonding/bond_alb.c | 12 +++++-------
 1 file changed, 5 insertions(+), 7 deletions(-)

diff --git a/drivers/net/bonding/bond_alb.c b/drivers/net/bonding/bond_alb.c
index 759ddee..a2c4747 100644
--- a/drivers/net/bonding/bond_alb.c
+++ b/drivers/net/bonding/bond_alb.c
@@ -1371,7 +1371,6 @@ int bond_alb_xmit(struct sk_buff *skb, struct net_device *bond_dev)
 	int do_tx_balance = 1;
 	u32 hash_index = 0;
 	const u8 *hash_start = NULL;
-	int res = 1;
 	struct ipv6hdr *ip6hdr;
 
 	skb_reset_mac_header(skb);
@@ -1469,7 +1468,8 @@ int bond_alb_xmit(struct sk_buff *skb, struct net_device *bond_dev)
 			       ETH_ALEN);
 		}
 
-		res = bond_dev_queue_xmit(bond, skb, tx_slave->dev);
+		bond_dev_queue_xmit(bond, skb, tx_slave->dev);
+		goto out;
 	} else {
 		if (tx_slave) {
 			_lock_tx_hashtbl(bond);
@@ -1478,11 +1478,9 @@ int bond_alb_xmit(struct sk_buff *skb, struct net_device *bond_dev)
 		}
 	}
 
-	if (res) {
-		/* no suitable interface, frame not sent */
-		kfree_skb(skb);
-	}
-
+	/* no suitable interface, frame not sent */
+	kfree_skb(skb);
+out:
 	return NETDEV_TX_OK;
 }
 
-- 
1.8.0


