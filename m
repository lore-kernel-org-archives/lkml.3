Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753132AbaLOO32 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Dec 2014 09:29:28 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:39020 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753084AbaLOO3T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Dec 2014 09:29:19 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Thadeu Lima de Souza Cascardo <cascardo@linux.vnet.ibm.com>,
        "David S. Miller" <davem@davemloft.net>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.16.y-ckt 155/168] tg3: fix ring init when there are more TX than RX channels
Date: Mon, 15 Dec 2014 14:26:49 +0000
Message-Id: <1418653622-21105-156-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <1418653622-21105-1-git-send-email-luis.henriques@canonical.com>
References: <1418653622-21105-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.16
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.16.7-ckt3 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Thadeu Lima de Souza Cascardo <cascardo@linux.vnet.ibm.com>

commit a620a6bc1c94c22d6c312892be1e0ae171523125 upstream.

If TX channels are set to 4 and RX channels are set to less than 4,
using ethtool -L, the driver will try to initialize more RX channels
than it has allocated, causing an oops.

This fix only initializes the RX ring if it has been allocated.

Signed-off-by: Thadeu Lima de Souza Cascardo <cascardo@linux.vnet.ibm.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/net/ethernet/broadcom/tg3.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/broadcom/tg3.c b/drivers/net/ethernet/broadcom/tg3.c
index 8345c6523799..2a1adec84d0e 100644
--- a/drivers/net/ethernet/broadcom/tg3.c
+++ b/drivers/net/ethernet/broadcom/tg3.c
@@ -8561,7 +8561,8 @@ static int tg3_init_rings(struct tg3 *tp)
 		if (tnapi->rx_rcb)
 			memset(tnapi->rx_rcb, 0, TG3_RX_RCB_RING_BYTES(tp));
 
-		if (tg3_rx_prodring_alloc(tp, &tnapi->prodring)) {
+		if (tnapi->prodring.rx_std &&
+		    tg3_rx_prodring_alloc(tp, &tnapi->prodring)) {
 			tg3_free_rings(tp);
 			return -ENOMEM;
 		}
-- 
2.1.3

