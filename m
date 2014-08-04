Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751771AbaHDDQL (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Aug 2014 23:16:11 -0400
Received: from szxga01-in.huawei.com ([119.145.14.64]:62658 "EHLO
	szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750929AbaHDDQK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Aug 2014 23:16:10 -0400
From: <lichunhe@huawei.com>
To: <j.vosburgh@gmail.com>, <vfalico@gmail.com>, <andy@greyhouse.net>,
        <linux-kernel@vger.kernel.org>
CC: <dingtianhong@huawei.com>, <qianhuibin@huawei.com>,
        Chunhe Li <lichunhe@huawei.com>
Subject: [PATCH net/net-next] bonding:Don't received packets if bonding is not up
Date: Mon, 4 Aug 2014 11:15:13 +0800
Message-ID: <1407122113-3184-1-git-send-email-lichunhe@huawei.com>
X-Mailer: git-send-email 1.9.2.msysgit.0
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.177.26.106]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Chunhe Li <lichunhe@huawei.com>

If the bonding device is down, it should not receive packets 
to network stack or other upper flow stack.

Signed-off-by: Chunhe Li <lichunhe@huawei.com>
---
 drivers/net/bonding/bond_main.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/drivers/net/bonding/bond_main.c b/drivers/net/bonding/bond_main.c
index 701f86c..48a127b 100644
--- a/drivers/net/bonding/bond_main.c
+++ b/drivers/net/bonding/bond_main.c
@@ -1110,6 +1110,12 @@ static rx_handler_result_t bond_handle_frame(struct sk_buff **pskb)
 	int (*recv_probe)(const struct sk_buff *, struct bonding *,
 			  struct slave *);
 	int ret = RX_HANDLER_ANOTHER;
+
+	slave = bond_slave_get_rcu(skb->dev);
+	bond = slave->bond;
+
+	if (unlikely(!(bond->dev->flags & IFF_UP)))
+		return RX_HANDLER_PASS;
 
 	skb = skb_share_check(skb, GFP_ATOMIC);
 	if (unlikely(!skb))
@@ -1117,9 +1123,6 @@ static rx_handler_result_t bond_handle_frame(struct sk_buff **pskb)
 
 	*pskb = skb;
 
-	slave = bond_slave_get_rcu(skb->dev);
-	bond = slave->bond;
-
 	recv_probe = ACCESS_ONCE(bond->recv_probe);
 	if (recv_probe) {
 		ret = recv_probe(skb, bond, slave);
-- 
1.9.2.0


