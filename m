Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758534Ab3JKK5A (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Oct 2013 06:57:00 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:58639 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757940Ab3JKKng (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Oct 2013 06:43:36 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Roger Luethi <rl@hellgate.ch>,
        =?UTF-8?q?Peter=20Bostr=C3=B6m?= <peter.bostrom@netrounds.com>,
        "David S. Miller" <davem@davemloft.net>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 059/100] via-rhine: fix VLAN priority field (PCP, IEEE 802.1p)
Date: Fri, 11 Oct 2013 11:41:29 +0100
Message-Id: <1381488130-30235-60-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1381488130-30235-1-git-send-email-luis.henriques@canonical.com>
References: <1381488130-30235-1-git-send-email-luis.henriques@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.23 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Roger Luethi <rl@hellgate.ch>

commit 207070f5221e2a901d56a49df9cde47d9b716cd7 upstream.

Outgoing packets sent by via-rhine have their VLAN PCP field off by one
(when hardware acceleration is enabled). The TX descriptor expects only VID
and PCP (without a CFI/DEI bit).

Peter Boström noticed and reported the bug.

Signed-off-by: Roger Luethi <rl@hellgate.ch>
Cc: Peter Boström <peter.bostrom@netrounds.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/net/ethernet/via/via-rhine.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/via/via-rhine.c b/drivers/net/ethernet/via/via-rhine.c
index 046526e0..4c1099e 100644
--- a/drivers/net/ethernet/via/via-rhine.c
+++ b/drivers/net/ethernet/via/via-rhine.c
@@ -32,7 +32,7 @@
 #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
 
 #define DRV_NAME	"via-rhine"
-#define DRV_VERSION	"1.5.0"
+#define DRV_VERSION	"1.5.1"
 #define DRV_RELDATE	"2010-10-09"
 
 #include <linux/types.h>
@@ -1684,7 +1684,12 @@ static netdev_tx_t rhine_start_tx(struct sk_buff *skb,
 		cpu_to_le32(TXDESC | (skb->len >= ETH_ZLEN ? skb->len : ETH_ZLEN));
 
 	if (unlikely(vlan_tx_tag_present(skb))) {
-		rp->tx_ring[entry].tx_status = cpu_to_le32((vlan_tx_tag_get(skb)) << 16);
+		u16 vid_pcp = vlan_tx_tag_get(skb);
+
+		/* drop CFI/DEI bit, register needs VID and PCP */
+		vid_pcp = (vid_pcp & VLAN_VID_MASK) |
+			  ((vid_pcp & VLAN_PRIO_MASK) >> 1);
+		rp->tx_ring[entry].tx_status = cpu_to_le32((vid_pcp) << 16);
 		/* request tagging */
 		rp->tx_ring[entry].desc_length |= cpu_to_le32(0x020000);
 	}
-- 
1.8.3.2

