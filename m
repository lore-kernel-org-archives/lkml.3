Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754914Ab3ETAF3 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 May 2013 20:05:29 -0400
Received: from out2-smtp.messagingengine.com ([66.111.4.26]:53355 "EHLO
	out2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754739Ab3ETAF1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 May 2013 20:05:27 -0400
X-Sasl-enc: b9SYf6YHdiUashNpixyDGfbr+dO1QwNzGVwn2lqIlSAB 1369008319
From: Alan Ott <alan@signal11.us>
To: david@hauweele.net
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-zigbee-devel@lists.sourceforge.net, Alan Ott <alan@signal11.us>
Subject: [PATCH testing] mrf24j40: Move INIT_COMPLETION to before the packet is sent
Date: Sun, 19 May 2013 20:05:16 -0400
Message-Id: <1369008316-16850-1-git-send-email-alan@signal11.us>
X-Mailer: git-send-email 1.7.11.2
In-Reply-To: <CAO+c-UVJQJbmmmCS4hxAEYHKa8gEU1Bs=y+Rv_A75UHeBZxc+w@mail.gmail.com>
References: <CAO+c-UVJQJbmmmCS4hxAEYHKa8gEU1Bs=y+Rv_A75UHeBZxc+w@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This avoids a race condition where the tx_complete interrupt could happen
before the completion is initialized.

---

David H,

Try this out and see if it changes anything for you. I put a bunch of
schedule_timeout()s in mrf24j40_tx() to basically guarantee that a reception
will happen during mrf24j40_tx(), and it seems to work. It would not work
before with said schedule_timeout() calls.

Alan.

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

