Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754887Ab3EVCBu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 May 2013 22:01:50 -0400
Received: from out2-smtp.messagingengine.com ([66.111.4.26]:39956 "EHLO
	out2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754183Ab3EVCB0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 May 2013 22:01:26 -0400
X-Sasl-enc: VurbihbRlo6buhY/jlqlfQLnJaDaxHlvf2wBUPO2o5XA 1369188085
From: Alan Ott <alan@signal11.us>
To: david@hauweele.net
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-zigbee-devel@lists.sourceforge.net, Alan Ott <alan@signal11.us>
Subject: [PATCH beta 1] 1/3] mrf24j40: Move INIT_COMPLETION() to before packet transmission
Date: Tue, 21 May 2013 22:01:18 -0400
Message-Id: <1369188080-8904-2-git-send-email-alan@signal11.us>
X-Mailer: git-send-email 1.7.11.2
In-Reply-To: <1369188080-8904-1-git-send-email-alan@signal11.us>
References: <CAO+c-UVJQJbmmmCS4hxAEYHKa8gEU1Bs=y+Rv_A75UHeBZxc+w@mail.gmail.com>
 <1369188080-8904-1-git-send-email-alan@signal11.us>
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
index 556151d..0ea2a5a 100644
--- a/drivers/net/ieee802154/mrf24j40.c
+++ b/drivers/net/ieee802154/mrf24j40.c
@@ -345,6 +345,8 @@ static int mrf24j40_tx(struct ieee802154_dev *dev, struct sk_buff *skb)
 	if (ret)
 		goto err;
 
+	INIT_COMPLETION(devrec->tx_complete);
+
 	/* Set TXNTRIG bit of TXNCON to send packet */
 	ret = read_short_reg(devrec, REG_TXNCON, &val);
 	if (ret)
@@ -355,8 +357,6 @@ static int mrf24j40_tx(struct ieee802154_dev *dev, struct sk_buff *skb)
 		val |= 0x4;
 	write_short_reg(devrec, REG_TXNCON, val);
 
-	INIT_COMPLETION(devrec->tx_complete);
-
 	/* Wait for the device to send the TX complete interrupt. */
 	ret = wait_for_completion_interruptible_timeout(
 						&devrec->tx_complete,
-- 
1.7.11.2

