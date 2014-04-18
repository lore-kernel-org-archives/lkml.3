Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753554AbaDRJjj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Apr 2014 05:39:39 -0400
Received: from ip4-83-240-18-248.cust.nbox.cz ([83.240.18.248]:45961 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752289AbaDRJWs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Apr 2014 05:22:48 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Stefan Wahren <stefan.wahren@i2se.com>,
        "David S. Miller" <davem@davemloft.net>, Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 44/72] eth: fec: Fix lost promiscuous mode after reconnecting cable
Date: Fri, 18 Apr 2014 11:22:17 +0200
Message-Id: <a488bc7135f7bb3c4a716105bda1d119748f87b2.1397812482.git.jslaby@suse.cz>
X-Mailer: git-send-email 1.9.2
In-Reply-To: <3389f243c528afc7c7300c83b8f296290cd3656d.1397812482.git.jslaby@suse.cz>
References: <3389f243c528afc7c7300c83b8f296290cd3656d.1397812482.git.jslaby@suse.cz>
In-Reply-To: <cover.1397812482.git.jslaby@suse.cz>
References: <cover.1397812482.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Stefan Wahren <stefan.wahren@i2se.com>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

[ Upstream commit 84fe61821e4ebab6322eeae3f3c27f77f0031978 ]

If the Freescale fec is in promiscuous mode and network cable is
reconnected then the promiscuous mode get lost. The problem is caused
by a too soon call of set_multicast_list to re-enable promisc mode.
The FEC_R_CNTRL register changes are overwritten by fec_restart.

This patch fixes this by moving the call behind the init of FEC_R_CNTRL
register in fec_restart.

Successful tested on a i.MX28 board.

Signed-off-by: Stefan Wahren <stefan.wahren@i2se.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 drivers/net/ethernet/freescale/fec_main.c | 14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/drivers/net/ethernet/freescale/fec_main.c b/drivers/net/ethernet/freescale/fec_main.c
index 63090c0ddeb9..8672547a2a47 100644
--- a/drivers/net/ethernet/freescale/fec_main.c
+++ b/drivers/net/ethernet/freescale/fec_main.c
@@ -525,13 +525,6 @@ fec_restart(struct net_device *ndev, int duplex)
 	/* Clear any outstanding interrupt. */
 	writel(0xffc00000, fep->hwp + FEC_IEVENT);
 
-	/* Setup multicast filter. */
-	set_multicast_list(ndev);
-#ifndef CONFIG_M5272
-	writel(0, fep->hwp + FEC_HASH_TABLE_HIGH);
-	writel(0, fep->hwp + FEC_HASH_TABLE_LOW);
-#endif
-
 	/* Set maximum receive buffer size. */
 	writel(PKT_MAXBLR_SIZE, fep->hwp + FEC_R_BUFF_SIZE);
 
@@ -652,6 +645,13 @@ fec_restart(struct net_device *ndev, int duplex)
 
 	writel(rcntl, fep->hwp + FEC_R_CNTRL);
 
+	/* Setup multicast filter. */
+	set_multicast_list(ndev);
+#ifndef CONFIG_M5272
+	writel(0, fep->hwp + FEC_HASH_TABLE_HIGH);
+	writel(0, fep->hwp + FEC_HASH_TABLE_LOW);
+#endif
+
 	if (id_entry->driver_data & FEC_QUIRK_ENET_MAC) {
 		/* enable ENET endian swap */
 		ecntl |= (1 << 8);
-- 
1.9.2

