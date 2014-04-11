Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759825AbaDKQrh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Apr 2014 12:47:37 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:56497 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759565AbaDKQI7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Apr 2014 12:08:59 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Stefan Wahren <stefan.wahren@i2se.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 3.13 28/65] eth: fec: Fix lost promiscuous mode after reconnecting cable
Date: Fri, 11 Apr 2014 09:11:00 -0700
Message-Id: <20140411161001.597618953@linuxfoundation.org>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <20140411160957.714773410@linuxfoundation.org>
References: <20140411160957.714773410@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Stefan Wahren <stefan.wahren@i2se.com>

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/freescale/fec_main.c |   14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

--- a/drivers/net/ethernet/freescale/fec_main.c
+++ b/drivers/net/ethernet/freescale/fec_main.c
@@ -528,13 +528,6 @@ fec_restart(struct net_device *ndev, int
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
 
@@ -655,6 +648,13 @@ fec_restart(struct net_device *ndev, int
 
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


