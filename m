Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760137Ab3DBXWD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Apr 2013 19:22:03 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:32845 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932513Ab3DBWL5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Apr 2013 18:11:57 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Fengguang Wu <fengguang.wu@intel.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>
Subject: [ 011/124] can: sja1000: fix define conflict on SH
Date: Tue,  2 Apr 2013 15:09:53 -0700
Message-Id: <20130402221105.515507531@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.rc1.5.g7e0651a
In-Reply-To: <20130402221104.163133110@linuxfoundation.org>
References: <20130402221104.163133110@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/net/can/sja1000/plx_pci.c |    4 ++--
 drivers/net/can/sja1000/sja1000.c |    6 +++---
 drivers/net/can/sja1000/sja1000.h |    2 +-
 3 files changed, 6 insertions(+), 6 deletions(-)

--- a/drivers/net/can/sja1000/plx_pci.c
+++ b/drivers/net/can/sja1000/plx_pci.c
@@ -348,7 +348,7 @@ static inline int plx_pci_check_sja1000(
 	 */
 	if ((priv->read_reg(priv, REG_CR) & REG_CR_BASICCAN_INITIAL_MASK) ==
 	    REG_CR_BASICCAN_INITIAL &&
-	    (priv->read_reg(priv, REG_SR) == REG_SR_BASICCAN_INITIAL) &&
+	    (priv->read_reg(priv, SJA1000_REG_SR) == REG_SR_BASICCAN_INITIAL) &&
 	    (priv->read_reg(priv, REG_IR) == REG_IR_BASICCAN_INITIAL))
 		flag = 1;
 
@@ -360,7 +360,7 @@ static inline int plx_pci_check_sja1000(
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
 
@@ -499,7 +499,7 @@ irqreturn_t sja1000_interrupt(int irq, v
 
 	while ((isrc = priv->read_reg(priv, REG_IR)) && (n < SJA1000_MAX_IRQ)) {
 		n++;
-		status = priv->read_reg(priv, REG_SR);
+		status = priv->read_reg(priv, SJA1000_REG_SR);
 		/* check for absent controller due to hw unplug */
 		if (status == 0xFF && sja1000_is_absent(priv))
 			return IRQ_NONE;
@@ -526,7 +526,7 @@ irqreturn_t sja1000_interrupt(int irq, v
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


