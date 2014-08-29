Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751498AbaH2Uqt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Aug 2014 16:46:49 -0400
Received: from mail-pa0-f52.google.com ([209.85.220.52]:62208 "EHLO
	mail-pa0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751020AbaH2Uqq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Aug 2014 16:46:46 -0400
From: Benjamin Poirier <bpoirier@suse.de>
To: Prashant Sreedharan <prashant@broadcom.com>,
        Michael Chan <mchan@broadcom.com>
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH net v5 2/4] tg3: Fix tx_pending check for MAX_SKB_FRAGS
Date: Fri, 29 Aug 2014 13:46:29 -0700
Message-Id: <1409345191-8819-2-git-send-email-bpoirier@suse.de>
X-Mailer: git-send-email 1.8.4.5
In-Reply-To: <1409345191-8819-1-git-send-email-bpoirier@suse.de>
References: <1409345191-8819-1-git-send-email-bpoirier@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The rest of the driver assumes at least one free descriptor in the tx ring.
Therefore, since an skb with max frags takes up (MAX_SKB_FRAGS + 1)
descriptors, tx_pending must be > (MAX_SKB_FRAGS + 1).

Signed-off-by: Benjamin Poirier <bpoirier@suse.de>
---

Changes v1->v2
Moved ahead in the series from 3/3 to 2/3, no functionnal change

I reproduced this bug using the same approach explained in patch 1.
The bug reproduces with tx_pending = 18
---
 drivers/net/ethernet/broadcom/tg3.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/broadcom/tg3.c b/drivers/net/ethernet/broadcom/tg3.c
index b11c0fd..0cecd6d 100644
--- a/drivers/net/ethernet/broadcom/tg3.c
+++ b/drivers/net/ethernet/broadcom/tg3.c
@@ -12319,7 +12319,7 @@ static int tg3_set_ringparam(struct net_device *dev, struct ethtool_ringparam *e
 	if ((ering->rx_pending > tp->rx_std_ring_mask) ||
 	    (ering->rx_jumbo_pending > tp->rx_jmb_ring_mask) ||
 	    (ering->tx_pending > TG3_TX_RING_SIZE - 1) ||
-	    (ering->tx_pending <= MAX_SKB_FRAGS) ||
+	    (ering->tx_pending <= MAX_SKB_FRAGS + 1) ||
 	    (tg3_flag(tp, TSO_BUG) &&
 	     (ering->tx_pending <= (MAX_SKB_FRAGS * 3))))
 		return -EINVAL;
-- 
1.8.4.5

