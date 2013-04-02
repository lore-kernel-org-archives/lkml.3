Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933918Ab3DBWOu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Apr 2013 18:14:50 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:33692 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933732Ab3DBWOr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Apr 2013 18:14:47 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Max Nekludov <Max.Nekludov@us.elster.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [ 65/68] ks8851: Fix interpretation of rxlen field.
Date: Tue,  2 Apr 2013 15:13:54 -0700
Message-Id: <20130402221337.512357699@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.rc1.5.g7e0651a
In-Reply-To: <20130402221329.915209206@linuxfoundation.org>
References: <20130402221329.915209206@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/micrel/ks8851.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/net/ethernet/micrel/ks8851.c
+++ b/drivers/net/ethernet/micrel/ks8851.c
@@ -547,7 +547,7 @@ static void ks8851_rx_pkts(struct ks8851
 	for (; rxfc != 0; rxfc--) {
 		rxh = ks8851_rdreg32(ks, KS_RXFHSR);
 		rxstat = rxh & 0xffff;
-		rxlen = rxh >> 16;
+		rxlen = (rxh >> 16) & 0xfff;
 
 		netif_dbg(ks, rx_status, ks->netdev,
 			  "rx: stat 0x%04x, len 0x%04x\n", rxstat, rxlen);


