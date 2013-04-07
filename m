Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935055Ab3DGXdw (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Apr 2013 19:33:52 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:46871 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S935041Ab3DGXdt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Apr 2013 19:33:49 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "Marc Kleine-Budde" <mkl@pengutronix.de>,
        "Fengguang Wu" <fengguang.wu@intel.com>
Date: Sun, 07 Apr 2013 23:45:42 +0100
Message-ID: <lsq.1365374742.15394070@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [34/74] can: sja1000: fix define conflict on SH
In-Reply-To: <lsq.1365374742.214522651@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:b4b3:7e2a:e2d0:3478
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.43-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Marc Kleine-Budde <mkl@pengutronix.de>

commit f901b6bc404b67d96eca739857c097e022727b71 upstream.

Thias patch fixes a define conflict between the SH architecture and the sja1000
driver:

    drivers/net/can/sja1000/sja1000.h:59:0: warning:
        "REG_SR" redefined [enabled by default]
    arch/sh/include/asm/ptrace_32.h:25:0: note:
         this is the location of the previous definition

A SJA1000_ prefix is added to the offending sja1000 define only, to make a
minimal patch suited for stable. A later patch will add a SJA1000_ prefix to
all defines in sja1000.h.

Reported-by: Fengguang Wu <fengguang.wu@intel.com>
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/net/can/sja1000/plx_pci.c |    4 ++--
 drivers/net/can/sja1000/sja1000.c |    6 +++---
 drivers/net/can/sja1000/sja1000.h |    2 +-
 3 files changed, 6 insertions(+), 6 deletions(-)

--- a/drivers/net/can/sja1000/plx_pci.c
+++ b/drivers/net/can/sja1000/plx_pci.c
@@ -309,7 +309,7 @@ static inline int plx_pci_check_sja1000(
 	 */
 	if ((priv->read_reg(priv, REG_CR) & REG_CR_BASICCAN_INITIAL_MASK) ==
 	    REG_CR_BASICCAN_INITIAL &&
-	    (priv->read_reg(priv, REG_SR) == REG_SR_BASICCAN_INITIAL) &&
+	    (priv->read_reg(priv, SJA1000_REG_SR) == REG_SR_BASICCAN_INITIAL) &&
 	    (priv->read_reg(priv, REG_IR) == REG_IR_BASICCAN_INITIAL))
 		flag = 1;
 
@@ -321,7 +321,7 @@ static inline int plx_pci_check_sja1000(
 	 * See states on p. 23 of the Datasheet.
 	 */
 	if (priv->read_reg(priv, REG_MOD) == REG_MOD_PELICAN_INITIAL &&
-	    priv->read_reg(priv, REG_SR) == REG_SR_PELICAN_INITIAL &&
+	    priv->read_reg(priv, SJA1000_REG_SR) == REG_SR_PELICAN_INITIAL &&
 	    priv->read_reg(priv, REG_IR) == REG_IR_PELICAN_INITIAL)
 		return flag;
 
--- a/drivers/net/can/sja1000/sja1000.c
+++ b/drivers/net/can/sja1000/sja1000.c
@@ -91,7 +91,7 @@ static void sja1000_write_cmdreg(struct
 	 */
 	spin_lock_irqsave(&priv->cmdreg_lock, flags);
 	priv->write_reg(priv, REG_CMR, val);
-	priv->read_reg(priv, REG_SR);
+	priv->read_reg(priv, SJA1000_REG_SR);
 	spin_unlock_irqrestore(&priv->cmdreg_lock, flags);
 }
 
@@ -497,7 +497,7 @@ irqreturn_t sja1000_interrupt(int irq, v
 
 	while ((isrc = priv->read_reg(priv, REG_IR)) && (n < SJA1000_MAX_IRQ)) {
 		n++;
-		status = priv->read_reg(priv, REG_SR);
+		status = priv->read_reg(priv, SJA1000_REG_SR);
 		/* check for absent controller due to hw unplug */
 		if (status == 0xFF && sja1000_is_absent(priv))
 			return IRQ_NONE;
@@ -516,7 +516,7 @@ irqreturn_t sja1000_interrupt(int irq, v
 			/* receive interrupt */
 			while (status & SR_RBS) {
 				sja1000_rx(dev);
-				status = priv->read_reg(priv, REG_SR);
+				status = priv->read_reg(priv, SJA1000_REG_SR);
 				/* check for absent controller */
 				if (status == 0xFF && sja1000_is_absent(priv))
 					return IRQ_NONE;
--- a/drivers/net/can/sja1000/sja1000.h
+++ b/drivers/net/can/sja1000/sja1000.h
@@ -56,7 +56,7 @@
 /* SJA1000 registers - manual section 6.4 (Pelican Mode) */
 #define REG_MOD		0x00
 #define REG_CMR		0x01
-#define REG_SR		0x02
+#define SJA1000_REG_SR		0x02
 #define REG_IR		0x03
 #define REG_IER		0x04
 #define REG_ALC		0x0B

