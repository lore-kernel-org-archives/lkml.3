Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932783AbbAIKk0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jan 2015 05:40:26 -0500
Received: from ip4-83-240-67-251.cust.nbox.cz ([83.240.67.251]:44586 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1757484AbbAIKc3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jan 2015 05:32:29 -0500
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
        Thadeu Lima de Souza Cascardo <cascardo@linux.vnet.ibm.com>,
        "David S. Miller" <davem@davemloft.net>, Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 03/78] tg3: fix ring init when there are more TX than RX channels
Date: Fri,  9 Jan 2015 11:31:12 +0100
Message-Id: <ae45dd08b4655300f5f119248a6f51aed7df53f6.1420799385.git.jslaby@suse.cz>
X-Mailer: git-send-email 2.2.1
In-Reply-To: <72002f1f248c28d1715d10454190e209d5a20fe1.1420799385.git.jslaby@suse.cz>
References: <72002f1f248c28d1715d10454190e209d5a20fe1.1420799385.git.jslaby@suse.cz>
In-Reply-To: <cover.1420799385.git.jslaby@suse.cz>
References: <cover.1420799385.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Thadeu Lima de Souza Cascardo <cascardo@linux.vnet.ibm.com>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

[ Upstream commit a620a6bc1c94c22d6c312892be1e0ae171523125 ]

If TX channels are set to 4 and RX channels are set to less than 4,
using ethtool -L, the driver will try to initialize more RX channels
than it has allocated, causing an oops.

This fix only initializes the RX ring if it has been allocated.

Signed-off-by: Thadeu Lima de Souza Cascardo <cascardo@linux.vnet.ibm.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 drivers/net/ethernet/broadcom/tg3.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/broadcom/tg3.c b/drivers/net/ethernet/broadcom/tg3.c
index 18f0d772e544..8d45dce7cfdb 100644
--- a/drivers/net/ethernet/broadcom/tg3.c
+++ b/drivers/net/ethernet/broadcom/tg3.c
@@ -8523,7 +8523,8 @@ static int tg3_init_rings(struct tg3 *tp)
 		if (tnapi->rx_rcb)
 			memset(tnapi->rx_rcb, 0, TG3_RX_RCB_RING_BYTES(tp));
 
-		if (tg3_rx_prodring_alloc(tp, &tnapi->prodring)) {
+		if (tnapi->prodring.rx_std &&
+		    tg3_rx_prodring_alloc(tp, &tnapi->prodring)) {
 			tg3_free_rings(tp);
 			return -ENOMEM;
 		}
-- 
2.2.1

