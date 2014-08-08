Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759383AbaHHVwZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Aug 2014 17:52:25 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:60652 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933452AbaHHVgq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Aug 2014 17:36:46 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 3.15 01/26] net: bcmgenet: correctly pad short packets
Date: Fri,  8 Aug 2014 14:35:08 -0700
Message-Id: <20140808213413.706294634@linuxfoundation.org>
X-Mailer: git-send-email 2.0.4
In-Reply-To: <20140808213413.648794968@linuxfoundation.org>
References: <20140808213413.648794968@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Florian Fainelli <f.fainelli@gmail.com>

[ Upstream commit 474ea9cafc459976827a477f2c30eaf6313cb7c1 ]

Packets shorter than ETH_ZLEN were not padded with zeroes, hence leaking
potentially sensitive information. This bug has been present since the
driver got accepted in commit 1c1008c793fa46703a2fee469f4235e1c7984333
("net: bcmgenet: add main driver file").

Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/broadcom/genet/bcmgenet.c |    5 +++++
 1 file changed, 5 insertions(+)

--- a/drivers/net/ethernet/broadcom/genet/bcmgenet.c
+++ b/drivers/net/ethernet/broadcom/genet/bcmgenet.c
@@ -1149,6 +1149,11 @@ static netdev_tx_t bcmgenet_xmit(struct
 		goto out;
 	}
 
+	if (skb_padto(skb, ETH_ZLEN)) {
+		ret = NETDEV_TX_OK;
+		goto out;
+	}
+
 	/* set the SKB transmit checksum */
 	if (priv->desc_64b_en) {
 		ret = bcmgenet_put_tx_csum(dev, skb);


