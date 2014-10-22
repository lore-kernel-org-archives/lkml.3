Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932468AbaJVHjo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2014 03:39:44 -0400
Received: from andre.telenet-ops.be ([195.130.132.53]:47082 "EHLO
	andre.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932123AbaJVHjm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2014 03:39:42 -0400
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: "David S. Miller" <davem@davemloft.net>,
        Iyappan Subramanian <isubramanian@apm.com>,
        Keyur Chudgar <kchudgar@apm.com>
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Geert Uytterhoeven <geert@linux-m68k.org>
Subject: [PATCH v2] drivers: net: xgene: Rewrite loop in xgene_enet_ecc_init()
Date: Wed, 22 Oct 2014 09:39:41 +0200
Message-Id: <1413963581-24019-1-git-send-email-geert@linux-m68k.org>
X-Mailer: git-send-email 1.9.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

drivers/net/ethernet/apm/xgene/xgene_enet_sgmac.c: In function ‘xgene_enet_ecc_init’:
drivers/net/ethernet/apm/xgene/xgene_enet_sgmac.c:126: warning: ‘data’ may be used uninitialized in this function

Depending on the arbitrary value on the stack, the loop may terminate
too early, and cause a bogus -ENODEV failure.

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
---
v2: Rewrite the loop instead of pre-initializing data.

 drivers/net/ethernet/apm/xgene/xgene_enet_sgmac.c | 12 +++++-------
 1 file changed, 5 insertions(+), 7 deletions(-)

diff --git a/drivers/net/ethernet/apm/xgene/xgene_enet_sgmac.c b/drivers/net/ethernet/apm/xgene/xgene_enet_sgmac.c
index e6d24c2101982444..2a497b38ed420495 100644
--- a/drivers/net/ethernet/apm/xgene/xgene_enet_sgmac.c
+++ b/drivers/net/ethernet/apm/xgene/xgene_enet_sgmac.c
@@ -127,17 +127,15 @@ static int xgene_enet_ecc_init(struct xgene_enet_pdata *p)
 	int i;
 
 	xgene_enet_wr_diag_csr(p, ENET_CFG_MEM_RAM_SHUTDOWN_ADDR, 0);
-	for (i = 0; i < 10 && data != ~0U ; i++) {
+	for (i = 0; i < 10; i++) {
 		usleep_range(100, 110);
 		data = xgene_enet_rd_diag_csr(p, ENET_BLOCK_MEM_RDY_ADDR);
+		if (data == ~0U)
+			return 0;
 	}
 
-	if (data != ~0U) {
-		netdev_err(ndev, "Failed to release memory from shutdown\n");
-		return -ENODEV;
-	}
-
-	return 0;
+	netdev_err(ndev, "Failed to release memory from shutdown\n");
+	return -ENODEV;
 }
 
 static void xgene_enet_config_ring_if_assoc(struct xgene_enet_pdata *p)
-- 
1.9.1

