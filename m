Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753826AbaANA23 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jan 2014 19:28:29 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:54315 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753729AbaANA2V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jan 2014 19:28:21 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Eric Dumazet <edumazet@google.com>,
        Alexey Brodkin <Alexey.Brodkin@synopsys.com>,
        Richard Cochran <richardcochran@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 3.12 29/77] arc_emac: fix potential use after free
Date: Mon, 13 Jan 2014 16:27:50 -0800
Message-Id: <20140114002753.334870963@linuxfoundation.org>
X-Mailer: git-send-email 1.8.5.1.163.gd7aced9
In-Reply-To: <20140114002752.497010554@linuxfoundation.org>
References: <20140114002752.497010554@linuxfoundation.org>
User-Agent: quilt/0.61-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Eric Dumazet <eric.dumazet@gmail.com>

[ Upstream commit 37ec274e9713eafc2ba6c4471420f06cb8f68ecf ]

Signed-off-by: Eric Dumazet <edumazet@google.com>

skb_tx_timestamp(skb) should be called _before_ TX completion
has a chance to trigger, otherwise it is too late and we access
freed memory.

Fixes: e4f2379db6c6 ("ethernet/arc/arc_emac - Add new driver")
From: Eric Dumazet <edumazet@google.com>
Cc: Alexey Brodkin <Alexey.Brodkin@synopsys.com>
Cc: Richard Cochran <richardcochran@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/arc/emac_main.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/net/ethernet/arc/emac_main.c
+++ b/drivers/net/ethernet/arc/emac_main.c
@@ -565,6 +565,8 @@ static int arc_emac_tx(struct sk_buff *s
 	/* Make sure pointer to data buffer is set */
 	wmb();
 
+	skb_tx_timestamp(skb);
+
 	*info = cpu_to_le32(FOR_EMAC | FIRST_OR_LAST_MASK | len);
 
 	/* Increment index to point to the next BD */
@@ -579,8 +581,6 @@ static int arc_emac_tx(struct sk_buff *s
 
 	arc_reg_set(priv, R_STATUS, TXPL_MASK);
 
-	skb_tx_timestamp(skb);
-
 	return NETDEV_TX_OK;
 }
 


