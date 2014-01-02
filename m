Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752737AbaABBQe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Jan 2014 20:16:34 -0500
Received: from szxga02-in.huawei.com ([119.145.14.65]:58480 "EHLO
	szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752473AbaABBQb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Jan 2014 20:16:31 -0500
Message-ID: <52C4BD22.2040704@huawei.com>
Date: Thu, 2 Jan 2014 09:13:06 +0800
From: Ding Tianhong <dingtianhong@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:24.0) Gecko/20100101 Thunderbird/24.0.1
MIME-Version: 1.0
To: Jay Vosburgh <fubar@us.ibm.com>, Veaceslav Falico <vfalico@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Netdev <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Julia Lawall <julia.lawall@lip6.fr>
Subject: [PATCH RESEND net-next 4/7] bonding: slight optimizztion for bond_slave_override()
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.135.72.199]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When the skb is xmit by the function bond_slave_override(),
it will have duplicate judgement for slave state, and I think it
will consumes a little performance, maybe it is negligible,
so I simplify the function and remove the unwanted judgement.

Signed-off-by: Ding Tianhong <dingtianhong@huawei.com>
---
 drivers/net/bonding/bond_main.c | 20 ++++++++------------
 1 file changed, 8 insertions(+), 12 deletions(-)

diff --git a/drivers/net/bonding/bond_main.c b/drivers/net/bonding/bond_main.c
index c0456cc..f14e235 100644
--- a/drivers/net/bonding/bond_main.c
+++ b/drivers/net/bonding/bond_main.c
@@ -3668,28 +3668,24 @@ static inline int bond_slave_override(struct bonding *bond,
 				      struct sk_buff *skb)
 {
 	struct slave *slave = NULL;
-	struct slave *check_slave;
 	struct list_head *iter;
-	int res = 1;
 
 	if (!skb->queue_mapping)
 		return 1;
 
 	/* Find out if any slaves have the same mapping as this skb. */
-	bond_for_each_slave_rcu(bond, check_slave, iter) {
-		if (check_slave->queue_id == skb->queue_mapping) {
-			slave = check_slave;
+	bond_for_each_slave_rcu(bond, slave, iter) {
+		if (slave->queue_id == skb->queue_mapping) {
+			if (slave_can_tx(slave)) {
+				bond_dev_queue_xmit(bond, skb, slave->dev);
+				return 0;
+			}
+			/* If the slave isn't UP, use default transmit policy. */
 			break;
 		}
 	}
 
-	/* If the slave isn't UP, use default transmit policy. */
-	if (slave && slave->queue_id && IS_UP(slave->dev) &&
-	    (slave->link == BOND_LINK_UP)) {
-		res = bond_dev_queue_xmit(bond, skb, slave->dev);
-	}
-
-	return res;
+	return 1;
 }
 
 
-- 
1.8.0


