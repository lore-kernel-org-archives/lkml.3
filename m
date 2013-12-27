Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754350Ab3L0GtJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Dec 2013 01:49:09 -0500
Received: from szxga03-in.huawei.com ([119.145.14.66]:11684 "EHLO
	szxga03-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754299Ab3L0GtE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Dec 2013 01:49:04 -0500
Message-ID: <52BD22C7.6000806@huawei.com>
Date: Fri, 27 Dec 2013 14:48:39 +0800
From: Ding Tianhong <dingtianhong@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:24.0) Gecko/20100101 Thunderbird/24.0.1
MIME-Version: 1.0
To: "David S. Miller" <davem@davemloft.net>, Netdev <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH net-next 09/20] net: ksz884x: slight optimization of addr
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

Cc: "David S. Miller" <davem@davemloft.net>
Signed-off-by: Ding Tianhong <dingtianhong@huawei.com>
---
 drivers/net/ethernet/micrel/ksz884x.c | 9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/micrel/ksz884x.c b/drivers/net/ethernet/micrel/ksz884x.c
index ddd252a..8e9dad7 100644
--- a/drivers/net/ethernet/micrel/ksz884x.c
+++ b/drivers/net/ethernet/micrel/ksz884x.c
@@ -4128,10 +4128,10 @@ static int hw_add_addr(struct ksz_hw *hw, u8 *mac_addr)
 	int i;
 	int j = ADDITIONAL_ENTRIES;
 
-	if (!memcmp(hw->override_addr, mac_addr, ETH_ALEN))
+	if (ether_addr_equal(hw->override_addr, mac_addr))
 		return 0;
 	for (i = 0; i < hw->addr_list_size; i++) {
-		if (!memcmp(hw->address[i], mac_addr, ETH_ALEN))
+		if (ether_addr_equal(hw->address[i], mac_addr))
 			return 0;
 		if (ADDITIONAL_ENTRIES == j && empty_addr(hw->address[i]))
 			j = i;
@@ -4149,7 +4149,7 @@ static int hw_del_addr(struct ksz_hw *hw, u8 *mac_addr)
 	int i;
 
 	for (i = 0; i < hw->addr_list_size; i++) {
-		if (!memcmp(hw->address[i], mac_addr, ETH_ALEN)) {
+		if (ether_addr_equal(hw->address[i], mac_addr)) {
 			memset(hw->address[i], 0, ETH_ALEN);
 			writel(0, hw->io + ADD_ADDR_INCR * i +
 				KS_ADD_ADDR_0_HI);
@@ -7104,8 +7104,7 @@ static int pcidev_init(struct pci_dev *pdev, const struct pci_device_id *id)
 			       ETH_ALEN);
 		else {
 			memcpy(dev->dev_addr, sw->other_addr, ETH_ALEN);
-			if (!memcmp(sw->other_addr, hw->override_addr,
-				    ETH_ALEN))
+			if (ether_addr_equal(sw->other_addr, hw->override_addr))
 				dev->dev_addr[5] += port->first_port;
 		}
 
-- 
1.8.0


