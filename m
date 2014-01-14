Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755514AbaANBBe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jan 2014 20:01:34 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:54079 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753315AbaANA1Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jan 2014 19:27:24 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Eric Dumazet <edumazet@google.com>, Frank Li <Frank.Li@freescale.com>,
        Richard Cochran <richardcochran@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 3.10 25/62] net: fec: fix potential use after free
Date: Mon, 13 Jan 2014 16:26:50 -0800
Message-Id: <20140114002711.181624286@linuxfoundation.org>
X-Mailer: git-send-email 1.8.5.1.163.gd7aced9
In-Reply-To: <20140114002710.464561569@linuxfoundation.org>
References: <20140114002710.464561569@linuxfoundation.org>
User-Agent: quilt/0.61-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Eric Dumazet <edumazet@google.com>

[ Upstream commit 7a2a84518cfb263d2c4171b3d63671f88316adb2 ]

skb_tx_timestamp(skb) should be called _before_ TX completion
has a chance to trigger, otherwise it is too late and we access
freed memory.

Signed-off-by: Eric Dumazet <edumazet@google.com>
Fixes: de5fb0a05348 ("net: fec: put tx to napi poll function to fix dead lock")
Cc: Frank Li <Frank.Li@freescale.com>
Cc: Richard Cochran <richardcochran@gmail.com>
Acked-by: Richard Cochran <richardcochran@gmail.com>
Acked-by: Frank Li <Frank.Li@freescale.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/freescale/fec_main.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/net/ethernet/freescale/fec_main.c
+++ b/drivers/net/ethernet/freescale/fec_main.c
@@ -371,6 +371,8 @@ fec_enet_start_xmit(struct sk_buff *skb,
 	else
 		bdp = fec_enet_get_nextdesc(bdp, fep->bufdesc_ex);
 
+	skb_tx_timestamp(skb);
+
 	fep->cur_tx = bdp;
 
 	if (fep->cur_tx == fep->dirty_tx)
@@ -379,8 +381,6 @@ fec_enet_start_xmit(struct sk_buff *skb,
 	/* Trigger transmission start */
 	writel(0, fep->hwp + FEC_X_DES_ACTIVE);
 
-	skb_tx_timestamp(skb);
-
 	return NETDEV_TX_OK;
 }
 


