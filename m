Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753177Ab3FYSvu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Jun 2013 14:51:50 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:41168 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752797Ab3FYSe0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Jun 2013 14:34:26 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [ 75/95] net: sh_eth: fix incorrect RX length error if R8A7740
Date: Tue, 25 Jun 2013 11:33:02 -0700
Message-Id: <20130625182202.045148396@linuxfoundation.org>
X-Mailer: git-send-email 1.8.3.rc0.20.gb99dd2e
In-Reply-To: <20130625182153.605455184@linuxfoundation.org>
References: <20130625182153.605455184@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>

[ Upstream commit dd019897358b815f7828dab90b51d51df4d3658d ]

This patch fixes an issue that the driver increments the "RX length error"
on every buffer in sh_eth_rx() if the R8A7740.
This patch also adds a description about the Receive Frame Status bits.

Signed-off-by: Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/renesas/sh_eth.c |   15 +++++++++++----
 1 file changed, 11 insertions(+), 4 deletions(-)

--- a/drivers/net/ethernet/renesas/sh_eth.c
+++ b/drivers/net/ethernet/renesas/sh_eth.c
@@ -1100,16 +1100,23 @@ static int sh_eth_rx(struct net_device *
 		desc_status = edmac_to_cpu(mdp, rxdesc->status);
 		pkt_len = rxdesc->frame_length;
 
-#if defined(CONFIG_ARCH_R8A7740)
-		desc_status >>= 16;
-#endif
-
 		if (--boguscnt < 0)
 			break;
 
 		if (!(desc_status & RDFEND))
 			ndev->stats.rx_length_errors++;
 
+#if defined(CONFIG_ARCH_R8A7740)
+		/*
+		 * In case of almost all GETHER/ETHERs, the Receive Frame State
+		 * (RFS) bits in the Receive Descriptor 0 are from bit 9 to
+		 * bit 0. However, in case of the R8A7740's GETHER, the RFS
+		 * bits are from bit 25 to bit 16. So, the driver needs right
+		 * shifting by 16.
+		 */
+		desc_status >>= 16;
+#endif
+
 		if (desc_status & (RD_RFS1 | RD_RFS2 | RD_RFS3 | RD_RFS4 |
 				   RD_RFS5 | RD_RFS6 | RD_RFS10)) {
 			ndev->stats.rx_errors++;


