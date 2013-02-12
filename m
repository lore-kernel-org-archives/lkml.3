Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933183Ab3BLM6p (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Feb 2013 07:58:45 -0500
Received: from mail-lb0-f178.google.com ([209.85.217.178]:58462 "EHLO
	mail-lb0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933099Ab3BLM6o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Feb 2013 07:58:44 -0500
From: Denis Efremov <yefremov.denis@gmail.com>
To: Alexander Smirnov <alex.bluesman.smirnov@gmail.com>
Cc: Denis Efremov <yefremov.denis@gmail.com>,
        "David S. Miller" <davem@davemloft.net>, linux-kernel@vger.kernel.org
Subject: [PATCH] ieee802154/at231rf230: deadlock in at86rf230_xmit
Date: Tue, 12 Feb 2013 16:57:21 +0400
Message-Id: <1360673841-20651-1-git-send-email-yefremov.denis@gmail.com>
X-Mailer: git-send-email 1.8.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

spin_lock(&lp->lock) is used in at86rf230_isr interrupt
handler and in at86rf230_xmit callback to protect
lp->irq_disabled. It seems that deadlock is possible,
because:
at86rf230_xmit
   spin_lock(&lp->lock); // acquired
// interrupt
at86rf230_isr
   spin_lock(&lp->lock); // deadlock

To prevent it, spin_lock_irq* should be used in xmit callback.

Found by Linux Driver Verification project (linuxtesting.org).

Signed-off-by: Denis Efremov <yefremov.denis@gmail.com>
---
 drivers/net/ieee802154/at86rf230.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ieee802154/at86rf230.c b/drivers/net/ieee802154/at86rf230.c
index a4a62e1..7c02dd9 100644
--- a/drivers/net/ieee802154/at86rf230.c
+++ b/drivers/net/ieee802154/at86rf230.c
@@ -543,12 +543,12 @@ at86rf230_xmit(struct ieee802154_dev *dev, struct sk_buff *skb)
 	int rc;
 	unsigned long flags;
 
-	spin_lock(&lp->lock);
+	spin_lock_irqsave(&lp->lock, flags);
 	if  (lp->irq_disabled) {
-		spin_unlock(&lp->lock);
+		spin_unlock_irqrestore(&lp->lock, flags);
 		return -EBUSY;
 	}
-	spin_unlock(&lp->lock);
+	spin_unlock_irqrestore(&lp->lock, flags);
 
 	might_sleep();
 
-- 
1.8.1.2

