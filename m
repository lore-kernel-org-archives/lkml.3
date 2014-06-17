Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967425AbaFQV57 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jun 2014 17:57:59 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:54930 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S967185AbaFQVwu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jun 2014 17:52:50 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Ivan Vecera <ivecera@redhat.com>, "David S. Miller" <davem@davemloft.net>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13 021/212] tg3: update rx_jumbo_pending ring param only when jumbo frames are enabled
Date: Tue, 17 Jun 2014 14:41:55 -0700
Message-Id: <1403041506-13646-22-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1403041506-13646-1-git-send-email-kamal@canonical.com>
References: <1403041506-13646-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11.4 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ivan Vecera <ivecera@redhat.com>

commit ba67b510035141bd89b40bf65efa0a79834311ca upstream.

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
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/net/ethernet/broadcom/tg3.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/broadcom/tg3.c b/drivers/net/ethernet/broadcom/tg3.c
index af88893..e71ee9f 100644
--- a/drivers/net/ethernet/broadcom/tg3.c
+++ b/drivers/net/ethernet/broadcom/tg3.c
@@ -12208,7 +12208,9 @@ static int tg3_set_ringparam(struct net_device *dev, struct ethtool_ringparam *e
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
1.9.1

