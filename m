Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755755AbaBGN1h (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Feb 2014 08:27:37 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:41385 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752084AbaBGLrm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Feb 2014 06:47:42 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Eric Dumazet <edumazet@google.com>,
        Alexey Brodkin <Alexey.Brodkin@synopsys.com>,
        Richard Cochran <richardcochran@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 002/233] arc_emac: fix potential use after free
Date: Fri,  7 Feb 2014 11:43:41 +0000
Message-Id: <1391773652-25214-3-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1391773652-25214-1-git-send-email-luis.henriques@canonical.com>
References: <1391773652-25214-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.4 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Eric Dumazet <eric.dumazet@gmail.com>

commit 37ec274e9713eafc2ba6c4471420f06cb8f68ecf upstream.

Signed-off-by: Eric Dumazet <edumazet@google.com>

skb_tx_timestamp(skb) should be called _before_ TX completion
has a chance to trigger, otherwise it is too late and we access
freed memory.

Fixes: e4f2379db6c6 ("ethernet/arc/arc_emac - Add new driver")
From: Eric Dumazet <edumazet@google.com>
Cc: Alexey Brodkin <Alexey.Brodkin@synopsys.com>
Cc: Richard Cochran <richardcochran@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/net/ethernet/arc/emac_main.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/arc/emac_main.c b/drivers/net/ethernet/arc/emac_main.c
index 9e16014..4fc96d6 100644
--- a/drivers/net/ethernet/arc/emac_main.c
+++ b/drivers/net/ethernet/arc/emac_main.c
@@ -565,6 +565,8 @@ static int arc_emac_tx(struct sk_buff *skb, struct net_device *ndev)
 	/* Make sure pointer to data buffer is set */
 	wmb();
 
+	skb_tx_timestamp(skb);
+
 	*info = cpu_to_le32(FOR_EMAC | FIRST_OR_LAST_MASK | len);
 
 	/* Increment index to point to the next BD */
@@ -579,8 +581,6 @@ static int arc_emac_tx(struct sk_buff *skb, struct net_device *ndev)
 
 	arc_reg_set(priv, R_STATUS, TXPL_MASK);
 
-	skb_tx_timestamp(skb);
-
 	return NETDEV_TX_OK;
 }
 
-- 
1.8.3.2

