Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753737AbaHSSxf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Aug 2014 14:53:35 -0400
Received: from mail-pa0-f50.google.com ([209.85.220.50]:40414 "EHLO
	mail-pa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753614AbaHSSx2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Aug 2014 14:53:28 -0400
From: Benjamin Poirier <bpoirier@suse.de>
To: Prashant Sreedharan <prashant@broadcom.com>,
        Michael Chan <mchan@broadcom.com>
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 3/3] tg3: Fix tx_pending check for MAX_SKB_FRAGS
Date: Tue, 19 Aug 2014 11:52:51 -0700
Message-Id: <1408474371-19509-3-git-send-email-bpoirier@suse.de>
X-Mailer: git-send-email 1.8.4.5
In-Reply-To: <1408474371-19509-1-git-send-email-bpoirier@suse.de>
References: <1408474371-19509-1-git-send-email-bpoirier@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The rest of the driver assumes at least one free descriptor in the tx ring.
Therefore, since an skb with max frags takes up (MAX_SKB_FRAGS + 1)
descriptors, tx_pending must be > (MAX_SKB_FRAGS + 1).

Signed-off-by: Benjamin Poirier <bpoirier@suse.de>
---

Currently, it is possible to set tx_pending = MAX_SKB_FRAGS + 1. This leads to
a netdev watchdog tx timeout. Depending on whether the previous patches in
this series are applied or not, the timeout happens as soon as tx_pending is
updated or after an skb with max frags is submitted for transmission.

I reproduced this bug using the same approach explained in patch 1.
The bug reproduces with tx_pending = 18

---
 drivers/net/ethernet/broadcom/tg3.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/broadcom/tg3.c b/drivers/net/ethernet/broadcom/tg3.c
index 7022f6d..27e2701 100644
--- a/drivers/net/ethernet/broadcom/tg3.c
+++ b/drivers/net/ethernet/broadcom/tg3.c
@@ -12328,7 +12328,7 @@ static int tg3_set_ringparam(struct net_device *dev, struct ethtool_ringparam *e
 	if ((ering->rx_pending > tp->rx_std_ring_mask) ||
 	    (ering->rx_jumbo_pending > tp->rx_jmb_ring_mask) ||
 	    (ering->tx_pending > TG3_TX_RING_SIZE - 1) ||
-	    (ering->tx_pending <= MAX_SKB_FRAGS))
+	    (ering->tx_pending <= MAX_SKB_FRAGS + 1))
 		return -EINVAL;
 
 	if (netif_running(dev)) {
-- 
1.8.4.5

