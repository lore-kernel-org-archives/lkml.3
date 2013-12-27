Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754400Ab3L0GtR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Dec 2013 01:49:17 -0500
Received: from szxga01-in.huawei.com ([119.145.14.64]:39913 "EHLO
	szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754354Ab3L0GtN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Dec 2013 01:49:13 -0500
Message-ID: <52BD22C3.9070908@huawei.com>
Date: Fri, 27 Dec 2013 14:48:35 +0800
From: Ding Tianhong <dingtianhong@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:24.0) Gecko/20100101 Thunderbird/24.0.1
MIME-Version: 1.0
To: Amir Vadai <amirv@mellanox.com>, "David S. Miller" <davem@davemloft.net>,
        Netdev <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH net-next 08/20] net: mlx4: slight optimization of addr compare
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.135.72.199]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use possibly more efficient ether_addr_equal
to instead of memcmp.

Cc: Amir Vadai <amirv@mellanox.com>
Signed-off-by: Ding Tianhong <dingtianhong@huawei.com>
---
 drivers/net/ethernet/mellanox/mlx4/en_netdev.c        | 4 ++--
 drivers/net/ethernet/mellanox/mlx4/resource_tracker.c | 2 +-
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx4/en_netdev.c b/drivers/net/ethernet/mellanox/mlx4/en_netdev.c
index 6f92090..7e43858 100644
--- a/drivers/net/ethernet/mellanox/mlx4/en_netdev.c
+++ b/drivers/net/ethernet/mellanox/mlx4/en_netdev.c
@@ -782,7 +782,7 @@ static void update_mclist_flags(struct mlx4_en_priv *priv,
 	list_for_each_entry(dst_tmp, dst, list) {
 		found = false;
 		list_for_each_entry(src_tmp, src, list) {
-			if (!memcmp(dst_tmp->addr, src_tmp->addr, ETH_ALEN)) {
+			if (ether_addr_equal(dst_tmp->addr, src_tmp->addr)) {
 				found = true;
 				break;
 			}
@@ -797,7 +797,7 @@ static void update_mclist_flags(struct mlx4_en_priv *priv,
 	list_for_each_entry(src_tmp, src, list) {
 		found = false;
 		list_for_each_entry(dst_tmp, dst, list) {
-			if (!memcmp(dst_tmp->addr, src_tmp->addr, ETH_ALEN)) {
+			if (ether_addr_equal(dst_tmp->addr, src_tmp->addr)) {
 				dst_tmp->action = MCLIST_NONE;
 				found = true;
 				break;
diff --git a/drivers/net/ethernet/mellanox/mlx4/resource_tracker.c b/drivers/net/ethernet/mellanox/mlx4/resource_tracker.c
index 2f3f2bc..2e3232c 100644
--- a/drivers/net/ethernet/mellanox/mlx4/resource_tracker.c
+++ b/drivers/net/ethernet/mellanox/mlx4/resource_tracker.c
@@ -3634,7 +3634,7 @@ static int validate_eth_header_mac(int slave, struct _rule_hw *eth_header,
 	    !is_broadcast_ether_addr(eth_header->eth.dst_mac)) {
 		list_for_each_entry_safe(res, tmp, rlist, list) {
 			be_mac = cpu_to_be64(res->mac << 16);
-			if (!memcmp(&be_mac, eth_header->eth.dst_mac, ETH_ALEN))
+			if (ether_addr_equal((u8 *)&be_mac, eth_header->eth.dst_mac))
 				return 0;
 		}
 		pr_err("MAC %pM doesn't belong to VF %d, Steering rule rejected\n",
-- 
1.8.0


