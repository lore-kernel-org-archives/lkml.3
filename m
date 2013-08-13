Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932312Ab3HMQEW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Aug 2013 12:04:22 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:10925 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758689Ab3HMP6d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Aug 2013 11:58:33 -0400
X-Authority-Analysis: v=2.0 cv=aqMw+FlV c=1 sm=0 a=Sro2XwOs0tJUSHxCKfOySw==:17 a=Drc5e87SC40A:10 a=Ciwy3NGCPMMA:10 a=XbSlTk6RBWoA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=KGjhK52YXX0A:10 a=bCkD6svqTacA:10 a=yC-0_ovQAAAA:8 a=J1Y8HTJGAAAA:8 a=PTHmlhs0BlRbN_MygUMA:9 a=hhvDFVipPpIA:10 a=4N9Db7Z2_RYA:10 a=jeBq3FmKZ4MA:10 a=DirMCcvN7PavkhQg:21 a=5tVpkO42tk3k9MJS:21 a=Sro2XwOs0tJUSHxCKfOySw==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 67.255.60.225
Message-Id: <20130813155828.644305486@goodmis.org>
User-Agent: quilt/0.60-1
Date: Tue, 13 Aug 2013 11:57:26 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [32/88] net: sh_eth: fix incorrect RX length error if R8A7740
References: <20130813155654.069291373@goodmis.org>
Content-Disposition: inline; filename=0032-net-sh_eth-fix-incorrect-RX-length-error-if-R8A7740.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6.11.7-rc1 stable review patch.
If anyone has any objections, please let me know.

------------------

From: Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>

[ Upstream commit dd019897358b815f7828dab90b51d51df4d3658d ]

This patch fixes an issue that the driver increments the "RX length error"
on every buffer in sh_eth_rx() if the R8A7740.
This patch also adds a description about the Receive Frame Status bits.

Signed-off-by: Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 drivers/net/ethernet/renesas/sh_eth.c |   15 +++++++++++----
 1 file changed, 11 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/renesas/sh_eth.c b/drivers/net/ethernet/renesas/sh_eth.c
index bad8f2e..cce72da 100644
--- a/drivers/net/ethernet/renesas/sh_eth.c
+++ b/drivers/net/ethernet/renesas/sh_eth.c
@@ -1102,16 +1102,23 @@ static int sh_eth_rx(struct net_device *ndev, u32 intr_status)
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
-- 
1.7.10.4


