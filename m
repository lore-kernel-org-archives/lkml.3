Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754187AbaLNUpa (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Dec 2014 15:45:30 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:52911 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751317AbaLNUVx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Dec 2014 15:21:53 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Thadeu Lima de Souza Cascardo <cascardo@linux.vnet.ibm.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 3.14 21/34] tg3: fix ring init when there are more TX than RX channels
Date: Sun, 14 Dec 2014 12:20:59 -0800
Message-Id: <20141214201804.410353138@linuxfoundation.org>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <20141214201803.791392744@linuxfoundation.org>
References: <20141214201803.791392744@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Thadeu Lima de Souza Cascardo <cascardo@linux.vnet.ibm.com>

[ Upstream commit a620a6bc1c94c22d6c312892be1e0ae171523125 ]

If TX channels are set to 4 and RX channels are set to less than 4,
using ethtool -L, the driver will try to initialize more RX channels
than it has allocated, causing an oops.

This fix only initializes the RX ring if it has been allocated.

Signed-off-by: Thadeu Lima de Souza Cascardo <cascardo@linux.vnet.ibm.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/broadcom/tg3.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/net/ethernet/broadcom/tg3.c
+++ b/drivers/net/ethernet/broadcom/tg3.c
@@ -8548,7 +8548,8 @@ static int tg3_init_rings(struct tg3 *tp
 		if (tnapi->rx_rcb)
 			memset(tnapi->rx_rcb, 0, TG3_RX_RCB_RING_BYTES(tp));
 
-		if (tg3_rx_prodring_alloc(tp, &tnapi->prodring)) {
+		if (tnapi->prodring.rx_std &&
+		    tg3_rx_prodring_alloc(tp, &tnapi->prodring)) {
 			tg3_free_rings(tp);
 			return -ENOMEM;
 		}


