Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758632AbaELC0Q (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 May 2014 22:26:16 -0400
Received: from 1wt.eu ([62.212.114.60]:34354 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751640AbaELBlc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 May 2014 21:41:32 -0400
Message-Id: <20140512003202.254959995@1wt.eu>
User-Agent: quilt/0.48-1
Date: Mon, 12 May 2014 02:32:39 +0200
From: Willy Tarreau <w@1wt.eu>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Mariusz Ceier <mceier+kernel@gmail.com>,
        Mugunthan V N <mugunthanvnm@ti.com>,
        "David S. Miller" <davem@davemloft.net>, Willy Tarreau <w@1wt.eu>
Subject: [ 039/143] davinci_emac.c: Fix IFF_ALLMULTI setup
In-Reply-To: <f07e5fe6d87f172fc73580b9c86ba9a2@local>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-longterm review patch.  If anyone has any objections, please let me know.

------------------

From: Mariusz Ceier <mceier+kernel@gmail.com>

[ Upstream commit d69e0f7ea95fef8059251325a79c004bac01f018 ]

When IFF_ALLMULTI flag is set on interface and IFF_PROMISC isn't,
emac_dev_mcast_set should only enable RX of multicasts and reset
MACHASH registers.

It does this, but afterwards it either sets up multicast MACs
filtering or disables RX of multicasts and resets MACHASH registers
again, rendering IFF_ALLMULTI flag useless.

This patch fixes emac_dev_mcast_set, so that multicast MACs filtering and
disabling of RX of multicasts are skipped when IFF_ALLMULTI flag is set.

Tested with kernel 2.6.37.

Signed-off-by: Mariusz Ceier <mceier+kernel@gmail.com>
Acked-by: Mugunthan V N <mugunthanvnm@ti.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Willy Tarreau <w@1wt.eu>
---
 drivers/net/davinci_emac.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/davinci_emac.c b/drivers/net/davinci_emac.c
index e347831..eafd1e4 100644
--- a/drivers/net/davinci_emac.c
+++ b/drivers/net/davinci_emac.c
@@ -960,7 +960,7 @@ static void emac_dev_mcast_set(struct net_device *ndev)
 			mbp_enable = (mbp_enable | EMAC_MBP_RXMCAST);
 			emac_add_mcast(priv, EMAC_ALL_MULTI_SET, NULL);
 		}
-		if (ndev->mc_count > 0) {
+		else if (ndev->mc_count > 0) {
 			struct dev_mc_list *mc_ptr;
 			mbp_enable = (mbp_enable | EMAC_MBP_RXMCAST);
 			emac_add_mcast(priv, EMAC_ALL_MULTI_CLR, NULL);
-- 
1.7.12.2.21.g234cd45.dirty



