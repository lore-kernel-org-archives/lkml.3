Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754734Ab3JUJHG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Oct 2013 05:07:06 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:39749 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754056Ab3JUIwW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Oct 2013 04:52:22 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "David S. Miller" <davem@davemloft.net>,
        "=?UTF-8?Q?Peter=20Bostr=C3=B6m?=" <peter.bostrom@netrounds.com>,
        "Roger Luethi" <rl@hellgate.ch>
Date: Mon, 21 Oct 2013 09:46:28 +0100
Message-ID: <lsq.1382345188.750802206@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [PATCH 3.2 108/149] via-rhine: fix VLAN priority field (PCP, IEEE
 802.1p)
In-Reply-To: <lsq.1382345187.199780875@decadent.org.uk>
X-SA-Exim-Connect-IP: 212.20.242.100
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.52-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Roger Luethi <rl@hellgate.ch>

[ Upstream commit 207070f5221e2a901d56a49df9cde47d9b716cd7 ]

Outgoing packets sent by via-rhine have their VLAN PCP field off by one
(when hardware acceleration is enabled). The TX descriptor expects only VID
and PCP (without a CFI/DEI bit).

Peter Boström noticed and reported the bug.

Signed-off-by: Roger Luethi <rl@hellgate.ch>
Cc: Peter Boström <peter.bostrom@netrounds.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/net/ethernet/via/via-rhine.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/via/via-rhine.c b/drivers/net/ethernet/via/via-rhine.c
index f34dd99..f37e0ae 100644
--- a/drivers/net/ethernet/via/via-rhine.c
+++ b/drivers/net/ethernet/via/via-rhine.c
@@ -32,7 +32,7 @@
 #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
 
 #define DRV_NAME	"via-rhine"
-#define DRV_VERSION	"1.5.0"
+#define DRV_VERSION	"1.5.1"
 #define DRV_RELDATE	"2010-10-09"
 
 
@@ -1518,7 +1518,12 @@ static netdev_tx_t rhine_start_tx(struct sk_buff *skb,
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

