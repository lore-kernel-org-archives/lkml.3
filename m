Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934859AbaE2OFs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2014 10:05:48 -0400
Received: from ip4-83-240-18-248.cust.nbox.cz ([83.240.18.248]:59413 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933326AbaE2Ntc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2014 09:49:32 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Ivan Vecera <ivecera@redhat.com>,
        "David S. Miller" <davem@davemloft.net>, Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 071/103] tg3: update rx_jumbo_pending ring param only when jumbo frames are enabled
Date: Thu, 29 May 2014 15:48:56 +0200
Message-Id: <6341e247c4ef83688fbdb8b30a3ddfe1e4e40703.1401371259.git.jslaby@suse.cz>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <bcbac220dab16a4038ac1a7c5cfe3e7f034b3836.1401371258.git.jslaby@suse.cz>
References: <bcbac220dab16a4038ac1a7c5cfe3e7f034b3836.1401371258.git.jslaby@suse.cz>
In-Reply-To: <cover.1401371258.git.jslaby@suse.cz>
References: <cover.1401371258.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ivan Vecera <ivecera@redhat.com>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

The patch fixes a problem with dropped jumbo frames after usage of
'ethtool -G ... rx'.

Scenario:
1. ip link set eth0 up
2. ethtool -G eth0 rx N # <- This zeroes rx-jumbo
3. ip link set mtu 9000 dev eth0

The ethtool command set rx_jumbo_pending to zero so any received jumbo
packets are dropped and you need to use 'ethtool -G eth0 rx-jumbo N'
to workaround the issue.
The patch changes the logic so rx_jumbo_pending value is changed only if
jumbo frames are enabled (MTU > 1500).

Signed-off-by: Ivan Vecera <ivecera@redhat.com>
Acked-by: Michael Chan <mchan@broadcom.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 drivers/net/ethernet/broadcom/tg3.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/broadcom/tg3.c b/drivers/net/ethernet/broadcom/tg3.c
index aae7ba66e7bb..65a058967cbb 100644
--- a/drivers/net/ethernet/broadcom/tg3.c
+++ b/drivers/net/ethernet/broadcom/tg3.c
@@ -12197,7 +12197,9 @@ static int tg3_set_ringparam(struct net_device *dev, struct ethtool_ringparam *e
 	if (tg3_flag(tp, MAX_RXPEND_64) &&
 	    tp->rx_pending > 63)
 		tp->rx_pending = 63;
-	tp->rx_jumbo_pending = ering->rx_jumbo_pending;
+
+	if (tg3_flag(tp, JUMBO_RING_ENABLE))
+		tp->rx_jumbo_pending = ering->rx_jumbo_pending;
 
 	for (i = 0; i < tp->irq_max; i++)
 		tp->napi[i].tx_pending = ering->tx_pending;
-- 
1.9.3

