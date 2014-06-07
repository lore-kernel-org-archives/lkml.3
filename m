Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752841AbaFGBXs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jun 2014 21:23:48 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:35931 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752440AbaFGBXg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jun 2014 21:23:36 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "Ivan Vecera" <ivecera@redhat.com>,
        "Michael Chan" <mchan@broadcom.com>,
        "David S. Miller" <davem@davemloft.net>
Date: Sat, 07 Jun 2014 02:26:28 +0100
Message-ID: <lsq.1402104388.772971002@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [PATCH 3.2 13/92] tg3: update rx_jumbo_pending ring param only
 when jumbo  frames are enabled
In-Reply-To: <lsq.1402104388.385007124@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.249
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.60-rc1 review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/net/ethernet/broadcom/tg3.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/broadcom/tg3.c b/drivers/net/ethernet/broadcom/tg3.c
index c77c462..2615433 100644
--- a/drivers/net/ethernet/broadcom/tg3.c
+++ b/drivers/net/ethernet/broadcom/tg3.c
@@ -10656,7 +10656,9 @@ static int tg3_set_ringparam(struct net_device *dev, struct ethtool_ringparam *e
 	if (tg3_flag(tp, MAX_RXPEND_64) &&
 	    tp->rx_pending > 63)
 		tp->rx_pending = 63;
-	tp->rx_jumbo_pending = ering->rx_jumbo_pending;
+
+	if (tg3_flag(tp, JUMBO_RING_ENABLE))
+		tp->rx_jumbo_pending = ering->rx_jumbo_pending;
 
 	for (i = 0; i < tp->irq_max; i++)
 		tp->napi[i].tx_pending = ering->tx_pending;

