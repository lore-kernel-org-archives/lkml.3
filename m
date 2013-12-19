Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756573Ab3LSM4j (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Dec 2013 07:56:39 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:44662 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754414Ab3LSL4j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Dec 2013 06:56:39 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Oliver Hartkopp <socketcan@hartkopp.net>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 056/208] can: sja1000: fix {pre,post}_irq() handling and IRQ handler return value
Date: Thu, 19 Dec 2013 11:52:34 +0000
Message-Id: <1387454106-19326-57-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1387454106-19326-1-git-send-email-luis.henriques@canonical.com>
References: <1387454106-19326-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.2 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Oliver Hartkopp <socketcan@hartkopp.net>

commit 2fea6cd303c0d0cd9067da31d873b6a6d5bd75e7 upstream.

This patch fixes the issue that the sja1000_interrupt() function may have
returned IRQ_NONE without processing the optional pre_irq() and post_irq()
function before. Further the irq processing counter 'n' is moved to the end of
the while statement to return correct IRQ_[NONE|HANDLED] values at error
conditions.

Reported-by: Wolfgang Grandegger <wg@grandegger.com>
Acked-by: Wolfgang Grandegger <wg@grandegger.com>
Signed-off-by: Oliver Hartkopp <socketcan@hartkopp.net>
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/net/can/sja1000/sja1000.c | 17 +++++++++--------
 1 file changed, 9 insertions(+), 8 deletions(-)

diff --git a/drivers/net/can/sja1000/sja1000.c b/drivers/net/can/sja1000/sja1000.c
index 7164a99..f17c301 100644
--- a/drivers/net/can/sja1000/sja1000.c
+++ b/drivers/net/can/sja1000/sja1000.c
@@ -494,20 +494,20 @@ irqreturn_t sja1000_interrupt(int irq, void *dev_id)
 	uint8_t isrc, status;
 	int n = 0;
 
-	/* Shared interrupts and IRQ off? */
-	if (priv->read_reg(priv, SJA1000_IER) == IRQ_OFF)
-		return IRQ_NONE;
-
 	if (priv->pre_irq)
 		priv->pre_irq(priv);
 
+	/* Shared interrupts and IRQ off? */
+	if (priv->read_reg(priv, SJA1000_IER) == IRQ_OFF)
+		goto out;
+
 	while ((isrc = priv->read_reg(priv, SJA1000_IR)) &&
 	       (n < SJA1000_MAX_IRQ)) {
-		n++;
+
 		status = priv->read_reg(priv, SJA1000_SR);
 		/* check for absent controller due to hw unplug */
 		if (status == 0xFF && sja1000_is_absent(priv))
-			return IRQ_NONE;
+			goto out;
 
 		if (isrc & IRQ_WUI)
 			netdev_warn(dev, "wakeup interrupt\n");
@@ -535,7 +535,7 @@ irqreturn_t sja1000_interrupt(int irq, void *dev_id)
 				status = priv->read_reg(priv, SJA1000_SR);
 				/* check for absent controller */
 				if (status == 0xFF && sja1000_is_absent(priv))
-					return IRQ_NONE;
+					goto out;
 			}
 		}
 		if (isrc & (IRQ_DOI | IRQ_EI | IRQ_BEI | IRQ_EPI | IRQ_ALI)) {
@@ -543,8 +543,9 @@ irqreturn_t sja1000_interrupt(int irq, void *dev_id)
 			if (sja1000_err(dev, isrc, status))
 				break;
 		}
+		n++;
 	}
-
+out:
 	if (priv->post_irq)
 		priv->post_irq(priv);
 
-- 
1.8.3.2

