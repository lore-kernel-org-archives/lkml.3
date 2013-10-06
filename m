Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753635Ab3JFDwu (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Oct 2013 23:52:50 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:35493 "EHLO
	out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752914Ab3JFDwk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Oct 2013 23:52:40 -0400
X-Sasl-enc: T/v0FXwaMwT8cyG8zvIaetVrCbiTL7AEwwbScYbagcCU 1381031559
From: Alan Ott <alan@signal11.us>
To: Alexander Smirnov <alex.bluesman.smirnov@gmail.com>,
        Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>,
        "David S. Miller" <davem@davemloft.net>, david@hauweele.net
Cc: linux-zigbee-devel@lists.sourceforge.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Alan Ott <alan@signal11.us>
Subject: [PATCH v1 1/3] mrf24j40: Move INIT_COMPLETION() to before packet transmission
Date: Sat,  5 Oct 2013 23:52:22 -0400
Message-Id: <1381031544-2960-2-git-send-email-alan@signal11.us>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1381031544-2960-1-git-send-email-alan@signal11.us>
References: <1369188080-8904-1-git-send-email-alan@signal11.us>
 <1381031544-2960-1-git-send-email-alan@signal11.us>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This avoids a race condition where complete(tx_complete) could be called
before tx_complete is initialized.

Signed-off-by: Alan Ott <alan@signal11.us>
---
 drivers/net/ieee802154/mrf24j40.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ieee802154/mrf24j40.c b/drivers/net/ieee802154/mrf24j40.c
index 42e6dee..66bb4ce 100644
--- a/drivers/net/ieee802154/mrf24j40.c
+++ b/drivers/net/ieee802154/mrf24j40.c
@@ -344,6 +344,8 @@ static int mrf24j40_tx(struct ieee802154_dev *dev, struct sk_buff *skb)
 	if (ret)
 		goto err;
 
+	INIT_COMPLETION(devrec->tx_complete);
+
 	/* Set TXNTRIG bit of TXNCON to send packet */
 	ret = read_short_reg(devrec, REG_TXNCON, &val);
 	if (ret)
@@ -354,8 +356,6 @@ static int mrf24j40_tx(struct ieee802154_dev *dev, struct sk_buff *skb)
 		val |= 0x4;
 	write_short_reg(devrec, REG_TXNCON, val);
 
-	INIT_COMPLETION(devrec->tx_complete);
-
 	/* Wait for the device to send the TX complete interrupt. */
 	ret = wait_for_completion_interruptible_timeout(
 						&devrec->tx_complete,
-- 
1.8.1.2

