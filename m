Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755795Ab3L2CmJ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Dec 2013 21:42:09 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:55347 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752576Ab3L2CKd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Dec 2013 21:10:33 -0500
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "Oliver Hartkopp" <socketcan@hartkopp.net>,
        "Marc Kleine-Budde" <mkl@pengutronix.de>,
        "Wolfgang Grandegger" <wg@grandegger.com>
Date: Sun, 29 Dec 2013 03:08:44 +0100
Message-ID: <lsq.1388282924.588235080@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [PATCH 3.2 096/185] can: sja1000: fix {pre,post}_irq() handling
 and IRQ handler return value
In-Reply-To: <lsq.1388282923.751256928@decadent.org.uk>
X-SA-Exim-Connect-IP: 31.18.200.85
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.54-rc1 review patch.  If anyone has any objections, please let me know.

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
[bwh: Backported to 3.2: s/SJA1000_IER/REG_IER/; s/SJA1000_IR/REG_IR/]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
--- a/drivers/net/can/sja1000/sja1000.c
+++ b/drivers/net/can/sja1000/sja1000.c
@@ -488,19 +488,19 @@ irqreturn_t sja1000_interrupt(int irq, v
 	uint8_t isrc, status;
 	int n = 0;
 
-	/* Shared interrupts and IRQ off? */
-	if (priv->read_reg(priv, REG_IER) == IRQ_OFF)
-		return IRQ_NONE;
-
 	if (priv->pre_irq)
 		priv->pre_irq(priv);
 
+	/* Shared interrupts and IRQ off? */
+	if (priv->read_reg(priv, REG_IER) == IRQ_OFF)
+		goto out;
+
 	while ((isrc = priv->read_reg(priv, REG_IR)) && (n < SJA1000_MAX_IRQ)) {
-		n++;
+
 		status = priv->read_reg(priv, SJA1000_REG_SR);
 		/* check for absent controller due to hw unplug */
 		if (status == 0xFF && sja1000_is_absent(priv))
-			return IRQ_NONE;
+			goto out;
 
 		if (isrc & IRQ_WUI)
 			dev_warn(dev->dev.parent, "wakeup interrupt\n");
@@ -519,7 +519,7 @@ irqreturn_t sja1000_interrupt(int irq, v
 				status = priv->read_reg(priv, SJA1000_REG_SR);
 				/* check for absent controller */
 				if (status == 0xFF && sja1000_is_absent(priv))
-					return IRQ_NONE;
+					goto out;
 			}
 		}
 		if (isrc & (IRQ_DOI | IRQ_EI | IRQ_BEI | IRQ_EPI | IRQ_ALI)) {
@@ -527,8 +527,9 @@ irqreturn_t sja1000_interrupt(int irq, v
 			if (sja1000_err(dev, isrc, status))
 				break;
 		}
+		n++;
 	}
-
+out:
 	if (priv->post_irq)
 		priv->post_irq(priv);
 

