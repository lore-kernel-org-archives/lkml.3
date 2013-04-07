Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934551Ab3DGW4B (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Apr 2013 18:56:01 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:46335 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S934522Ab3DGWz5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Apr 2013 18:55:57 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org,
        "Max.Nekludov@us.elster.com" <Max.Nekludov@us.elster.com>,
        "David S. Miller" <davem@davemloft.net>
Date: Sun, 07 Apr 2013 23:45:43 +0100
Message-ID: <lsq.1365374743.456176645@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [69/74] ks8851: Fix interpretation of rxlen field.
In-Reply-To: <lsq.1365374742.214522651@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:b4b3:7e2a:e2d0:3478
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.43-rc1 review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/net/ethernet/micrel/ks8851.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/micrel/ks8851.c b/drivers/net/ethernet/micrel/ks8851.c
index f56743a..115e374 100644
--- a/drivers/net/ethernet/micrel/ks8851.c
+++ b/drivers/net/ethernet/micrel/ks8851.c
@@ -490,7 +490,7 @@ static void ks8851_rx_pkts(struct ks8851_net *ks)
 	for (; rxfc != 0; rxfc--) {
 		rxh = ks8851_rdreg32(ks, KS_RXFHSR);
 		rxstat = rxh & 0xffff;
-		rxlen = rxh >> 16;
+		rxlen = (rxh >> 16) & 0xfff;
 
 		netif_dbg(ks, rx_status, ks->netdev,
 			  "rx: stat 0x%04x, len 0x%04x\n", rxstat, rxlen);

