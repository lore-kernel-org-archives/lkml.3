Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933790Ab3EGOJu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 May 2013 10:09:50 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:42279 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932909Ab3EGNlN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 May 2013 09:41:13 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: "Huang, Xiong" <xiong@qca.qualcomm.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Hannes Frederic Sowa <hannes@stressinduktion.org>,
        "David S. Miller" <davem@davemloft.net>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 045/118] atl1e: limit gso segment size to prevent generation of wrong ip length fields
Date: Tue,  7 May 2013 14:38:11 +0100
Message-Id: <1367933964-1564-46-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1367933964-1564-1-git-send-email-luis.henriques@canonical.com>
References: <1367933964-1564-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.12 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hannes Frederic Sowa <hannes@stressinduktion.org>

commit 31d1670e73f4911fe401273a8f576edc9c2b5fea upstream.

The limit of 0x3c00 is taken from the windows driver.

Suggested-by: Huang, Xiong <xiong@qca.qualcomm.com>
Cc: Huang, Xiong <xiong@qca.qualcomm.com>
Cc: Eric Dumazet <eric.dumazet@gmail.com>
Signed-off-by: Hannes Frederic Sowa <hannes@stressinduktion.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/net/ethernet/atheros/atl1e/atl1e.h      | 2 +-
 drivers/net/ethernet/atheros/atl1e/atl1e_main.c | 1 +
 2 files changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/atheros/atl1e/atl1e.h b/drivers/net/ethernet/atheros/atl1e/atl1e.h
index edfdf6b..b5fd934 100644
--- a/drivers/net/ethernet/atheros/atl1e/atl1e.h
+++ b/drivers/net/ethernet/atheros/atl1e/atl1e.h
@@ -186,7 +186,7 @@ struct atl1e_tpd_desc {
 /* how about 0x2000 */
 #define MAX_TX_BUF_LEN      0x2000
 #define MAX_TX_BUF_SHIFT    13
-/*#define MAX_TX_BUF_LEN  0x3000 */
+#define MAX_TSO_SEG_SIZE    0x3c00
 
 /* rrs word 1 bit 0:31 */
 #define RRS_RX_CSUM_MASK	0xFFFF
diff --git a/drivers/net/ethernet/atheros/atl1e/atl1e_main.c b/drivers/net/ethernet/atheros/atl1e/atl1e_main.c
index 38f7093..56b04c4 100644
--- a/drivers/net/ethernet/atheros/atl1e/atl1e_main.c
+++ b/drivers/net/ethernet/atheros/atl1e/atl1e_main.c
@@ -2352,6 +2352,7 @@ static int __devinit atl1e_probe(struct pci_dev *pdev,
 
 	INIT_WORK(&adapter->reset_task, atl1e_reset_task);
 	INIT_WORK(&adapter->link_chg_task, atl1e_link_chg_task);
+	netif_set_gso_max_size(netdev, MAX_TSO_SEG_SIZE);
 	err = register_netdev(netdev);
 	if (err) {
 		netdev_err(netdev, "register netdevice failed\n");
-- 
1.8.1.2

