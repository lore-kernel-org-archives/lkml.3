Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754691AbaFCLml (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jun 2014 07:42:41 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:43785 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754625AbaFCLmf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jun 2014 07:42:35 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Ivan Vecera <ivecera@redhat.com>, "David S. Miller" <davem@davemloft.net>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 108/138] tg3: update rx_jumbo_pending ring param only when jumbo frames are enabled
Date: Tue,  3 Jun 2014 12:39:14 +0100
Message-Id: <1401795584-22664-109-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1401795584-22664-1-git-send-email-luis.henriques@canonical.com>
References: <1401795584-22664-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.11 -stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/net/ethernet/broadcom/tg3.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/broadcom/tg3.c b/drivers/net/ethernet/broadcom/tg3.c
index 17822c53ff82..35f66f680aed 100644
--- a/drivers/net/ethernet/broadcom/tg3.c
+++ b/drivers/net/ethernet/broadcom/tg3.c
@@ -12148,7 +12148,9 @@ static int tg3_set_ringparam(struct net_device *dev, struct ethtool_ringparam *e
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

