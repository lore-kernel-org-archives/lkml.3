Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752688AbaLOTeE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Dec 2014 14:34:04 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:41026 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752666AbaLOTeA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Dec 2014 14:34:00 -0500
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Thadeu Lima de Souza Cascardo <cascardo@linux.vnet.ibm.com>,
        "David S. Miller" <davem@davemloft.net>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13.y-ckt 90/96] tg3: fix ring init when there are more TX than RX channels
Date: Mon, 15 Dec 2014 11:26:50 -0800
Message-Id: <1418671616-25482-91-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1418671616-25482-1-git-send-email-kamal@canonical.com>
References: <1418671616-25482-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11-ckt13 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Thadeu Lima de Souza Cascardo <cascardo@linux.vnet.ibm.com>

[ Upstream commit a620a6bc1c94c22d6c312892be1e0ae171523125 ]

If TX channels are set to 4 and RX channels are set to less than 4,
using ethtool -L, the driver will try to initialize more RX channels
than it has allocated, causing an oops.

This fix only initializes the RX ring if it has been allocated.

Signed-off-by: Thadeu Lima de Souza Cascardo <cascardo@linux.vnet.ibm.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/net/ethernet/broadcom/tg3.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/broadcom/tg3.c b/drivers/net/ethernet/broadcom/tg3.c
index 1b84139..bbb9bd9 100644
--- a/drivers/net/ethernet/broadcom/tg3.c
+++ b/drivers/net/ethernet/broadcom/tg3.c
@@ -8532,7 +8532,8 @@ static int tg3_init_rings(struct tg3 *tp)
 		if (tnapi->rx_rcb)
 			memset(tnapi->rx_rcb, 0, TG3_RX_RCB_RING_BYTES(tp));
 
-		if (tg3_rx_prodring_alloc(tp, &tnapi->prodring)) {
+		if (tnapi->prodring.rx_std &&
+		    tg3_rx_prodring_alloc(tp, &tnapi->prodring)) {
 			tg3_free_rings(tp);
 			return -ENOMEM;
 		}
-- 
1.9.1

