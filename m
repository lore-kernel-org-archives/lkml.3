Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755654Ab3EIPVc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 May 2013 11:21:32 -0400
Received: from mail-wi0-f174.google.com ([209.85.212.174]:53533 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755577Ab3EIPV1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 May 2013 11:21:27 -0400
From: David Hauweele <david@hauweele.net>
To: Alexander Smirnov <alex.bluesman.smirnov@gmail.com>,
        Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>,
        linux-zigbee-devel@lists.sourceforge.net
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        David Hauweele <david@hauweele.net>
Subject: [PATCH 2/2] mrf24j40: Keep the interrupt line enabled
Date: Thu,  9 May 2013 17:19:47 +0200
Message-Id: <1368112788-25701-2-git-send-email-david@hauweele.net>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1368112788-25701-1-git-send-email-david@hauweele.net>
References: <1368112788-25701-1-git-send-email-david@hauweele.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Disabling the interrupt line could miss an IRQ and leave the line into a
low state hence locking the driver.

Signed-off-by: David Hauweele <david@hauweele.net>
---
 drivers/net/ieee802154/mrf24j40.c |    7 +------
 1 file changed, 1 insertion(+), 6 deletions(-)

diff --git a/drivers/net/ieee802154/mrf24j40.c b/drivers/net/ieee802154/mrf24j40.c
index 1e3ddf3..6ef32f7 100644
--- a/drivers/net/ieee802154/mrf24j40.c
+++ b/drivers/net/ieee802154/mrf24j40.c
@@ -603,8 +603,6 @@ static irqreturn_t mrf24j40_isr(int irq, void *data)
 {
 	struct mrf24j40 *devrec = data;
 
-	disable_irq_nosync(irq);
-
 	schedule_work(&devrec->irqwork);
 
 	return IRQ_HANDLED;
@@ -619,7 +617,7 @@ static void mrf24j40_isrwork(struct work_struct *work)
 	/* Read the interrupt status */
 	ret = read_short_reg(devrec, REG_INTSTAT, &intstat);
 	if (ret)
-		goto out;
+		return;
 
 	/* Check for TX complete */
 	if (intstat & 0x1)
@@ -628,9 +626,6 @@ static void mrf24j40_isrwork(struct work_struct *work)
 	/* Check for Rx */
 	if (intstat & 0x8)
 		schedule_work(&devrec->rxwork);
-
-out:
-	enable_irq(devrec->spi->irq);
 }
 
 static void mrf24j40_rxwork(struct work_struct *work)
-- 
1.7.10.4

