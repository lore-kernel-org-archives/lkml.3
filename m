Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422716Ab3DKU6F (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Apr 2013 16:58:05 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:26790 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935448Ab3DKUt0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Apr 2013 16:49:26 -0400
X-Authority-Analysis: v=2.0 cv=F+XVh9dN c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=Ciwy3NGCPMMA:10 a=bbJp-Ql1SJ4A:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=O7p4vapL1NUA:10 a=VwQbUJbxAAAA:8 a=QyXUC8HyAAAA:8 a=0u0nhMPvhaUjrep2UKUA:9 a=XNN-oNMjSfgA:10 a=dGJ0OcVc7YAA:10 a=jeBq3FmKZ4MA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-Id: <20130411202559.476460156@goodmis.org>
User-Agent: quilt/0.60-1
Date: Thu, 11 Apr 2013 16:26:24 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Fengguang Wu <fengguang.wu@intel.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>
Subject: [ 081/171 ] can: sja1000: fix define conflict on SH
References: <20130411202503.783159048@goodmis.org>
Content-Disposition: inline; filename=0081-can-sja1000-fix-define-conflict-on-SH.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6.11.2 stable review patch.
If anyone has any objections, please let me know.

------------------

From: Marc Kleine-Budde <mkl@pengutronix.de>

[ Upstream commit f901b6bc404b67d96eca739857c097e022727b71 ]

Thias patch fixes a define conflict between the SH architecture and the sja1000
driver:

    drivers/net/can/sja1000/sja1000.h:59:0: warning:
        "REG_SR" redefined [enabled by default]
    arch/sh/include/asm/ptrace_32.h:25:0: note:
         this is the location of the previous definition

A SJA1000_ prefix is added to the offending sja1000 define only, to make a
minimal patch suited for stable. A later patch will add a SJA1000_ prefix to
all defines in sja1000.h.

Cc: linux-stable <stable@vger.kernel.org>
Reported-by: Fengguang Wu <fengguang.wu@intel.com>
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 drivers/net/can/sja1000/plx_pci.c |    4 ++--
 drivers/net/can/sja1000/sja1000.c |    6 +++---
 drivers/net/can/sja1000/sja1000.h |    2 +-
 3 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/net/can/sja1000/plx_pci.c b/drivers/net/can/sja1000/plx_pci.c
index 8bc9598..8099275 100644
--- a/drivers/net/can/sja1000/plx_pci.c
+++ b/drivers/net/can/sja1000/plx_pci.c
@@ -329,7 +329,7 @@ static inline int plx_pci_check_sja1000(const struct sja1000_priv *priv)
 	 */
 	if ((priv->read_reg(priv, REG_CR) & REG_CR_BASICCAN_INITIAL_MASK) ==
 	    REG_CR_BASICCAN_INITIAL &&
-	    (priv->read_reg(priv, REG_SR) == REG_SR_BASICCAN_INITIAL) &&
+	    (priv->read_reg(priv, SJA1000_REG_SR) == REG_SR_BASICCAN_INITIAL) &&
 	    (priv->read_reg(priv, REG_IR) == REG_IR_BASICCAN_INITIAL))
 		flag = 1;
 
@@ -341,7 +341,7 @@ static inline int plx_pci_check_sja1000(const struct sja1000_priv *priv)
 	 * See states on p. 23 of the Datasheet.
 	 */
 	if (priv->read_reg(priv, REG_MOD) == REG_MOD_PELICAN_INITIAL &&
-	    priv->read_reg(priv, REG_SR) == REG_SR_PELICAN_INITIAL &&
+	    priv->read_reg(priv, SJA1000_REG_SR) == REG_SR_PELICAN_INITIAL &&
 	    priv->read_reg(priv, REG_IR) == REG_IR_PELICAN_INITIAL)
 		return flag;
 
diff --git a/drivers/net/can/sja1000/sja1000.c b/drivers/net/can/sja1000/sja1000.c
index 4c4f33d..f0e1789 100644
--- a/drivers/net/can/sja1000/sja1000.c
+++ b/drivers/net/can/sja1000/sja1000.c
@@ -91,7 +91,7 @@ static void sja1000_write_cmdreg(struct sja1000_priv *priv, u8 val)
 	 */
 	spin_lock_irqsave(&priv->cmdreg_lock, flags);
 	priv->write_reg(priv, REG_CMR, val);
-	priv->read_reg(priv, REG_SR);
+	priv->read_reg(priv, SJA1000_REG_SR);
 	spin_unlock_irqrestore(&priv->cmdreg_lock, flags);
 }
 
@@ -496,7 +496,7 @@ irqreturn_t sja1000_interrupt(int irq, void *dev_id)
 
 	while ((isrc = priv->read_reg(priv, REG_IR)) && (n < SJA1000_MAX_IRQ)) {
 		n++;
-		status = priv->read_reg(priv, REG_SR);
+		status = priv->read_reg(priv, SJA1000_REG_SR);
 		/* check for absent controller due to hw unplug */
 		if (status == 0xFF && sja1000_is_absent(priv))
 			return IRQ_NONE;
@@ -515,7 +515,7 @@ irqreturn_t sja1000_interrupt(int irq, void *dev_id)
 			/* receive interrupt */
 			while (status & SR_RBS) {
 				sja1000_rx(dev);
-				status = priv->read_reg(priv, REG_SR);
+				status = priv->read_reg(priv, SJA1000_REG_SR);
 				/* check for absent controller */
 				if (status == 0xFF && sja1000_is_absent(priv))
 					return IRQ_NONE;
diff --git a/drivers/net/can/sja1000/sja1000.h b/drivers/net/can/sja1000/sja1000.h
index 23fff06..2a79543 100644
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
-- 
1.7.10.4


