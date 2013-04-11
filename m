Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935496Ab3DKV0H (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Apr 2013 17:26:07 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:2760 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935332Ab3DKUsq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Apr 2013 16:48:46 -0400
X-Authority-Analysis: v=2.0 cv=F+XVh9dN c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=Ciwy3NGCPMMA:10 a=mqq2O4Mmqs4A:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=urE7_ALw9PIA:10 a=CxJuTY6TAAAA:8 a=J1Y8HTJGAAAA:8 a=jmWCE8W1go-RpaolMxwA:9 a=4N9Db7Z2_RYA:10 a=jeBq3FmKZ4MA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-Id: <20130411202613.461843242@goodmis.org>
User-Agent: quilt/0.60-1
Date: Thu, 11 Apr 2013 16:27:49 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Max Nekludov <Max.Nekludov@us.elster.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [ 166/171 ] ks8851: Fix interpretation of rxlen field.
References: <20130411202503.783159048@goodmis.org>
Content-Disposition: inline; filename=0166-ks8851-Fix-interpretation-of-rxlen-field.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6.11.2 stable review patch.
If anyone has any objections, please let me know.

------------------

From: "Max.Nekludov@us.elster.com" <Max.Nekludov@us.elster.com>

[ Upstream commit 14bc435ea54cb888409efb54fc6b76c13ef530e9 ]

According to the Datasheet (page 52):
15-12 Reserved
11-0 RXBC Receive Byte Count
This field indicates the present received frame byte size.

The code has a bug:
                 rxh = ks8851_rdreg32(ks, KS_RXFHSR);
                 rxstat = rxh & 0xffff;
                 rxlen = rxh >> 16; // BUG!!! 0xFFF mask should be applied

Signed-off-by: Max Nekludov <Max.Nekludov@us.elster.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 drivers/net/ethernet/micrel/ks8851.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/micrel/ks8851.c b/drivers/net/ethernet/micrel/ks8851.c
index 1540ebe..a4cd9a0 100644
--- a/drivers/net/ethernet/micrel/ks8851.c
+++ b/drivers/net/ethernet/micrel/ks8851.c
@@ -547,7 +547,7 @@ static void ks8851_rx_pkts(struct ks8851_net *ks)
 	for (; rxfc != 0; rxfc--) {
 		rxh = ks8851_rdreg32(ks, KS_RXFHSR);
 		rxstat = rxh & 0xffff;
-		rxlen = rxh >> 16;
+		rxlen = (rxh >> 16) & 0xfff;
 
 		netif_dbg(ks, rx_status, ks->netdev,
 			  "rx: stat 0x%04x, len 0x%04x\n", rxstat, rxlen);
-- 
1.7.10.4


