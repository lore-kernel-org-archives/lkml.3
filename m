Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756914AbaCRRTH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Mar 2014 13:19:07 -0400
Received: from www.linutronix.de ([62.245.132.108]:55703 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756623AbaCRRS7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Mar 2014 13:18:59 -0400
Message-Id: <20140318171126.720944558@linutronix.de>
User-Agent: quilt/0.60-1
Date: Tue, 18 Mar 2014 17:19:08 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Wolfgang Grandegger <wg@grandegger.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        Markus Pargmann <mpa@pengutronix.de>,
        Benedikt Spranger <b.spranger@linutronix.de>,
        linux-can@vger.kernel.org, netdev@vger.kernel.org
Subject: [patch 02/12] can: c_can: Fix hardware raminit function
References: <20140318171007.528610837@linutronix.de>
Content-Disposition: inline; filename=can-c_can-wait-for-raminit.patch
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The function is broken in several ways:

    - The function does not wait for the init to complete.
      That can take quite some microseconds.

    - No protection against being called for two chips at the same
      time. SMP is such a new thing, right?

Clear the start and the init done bit unconditionally and wait for
both bits to be clear.

In the enable path set the init bit and wait
for the init done bit.

Add proper locking.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 drivers/net/can/c_can/c_can_platform.c |   48 ++++++++++++++++++++++++++-------
 1 file changed, 39 insertions(+), 9 deletions(-)

Index: linux/drivers/net/can/c_can/c_can_platform.c
===================================================================
--- linux.orig/drivers/net/can/c_can/c_can_platform.c
+++ linux/drivers/net/can/c_can/c_can_platform.c
@@ -37,8 +37,10 @@
 
 #include "c_can.h"
 
-#define CAN_RAMINIT_START_MASK(i)	(1 << (i))
-
+#define CAN_RAMINIT_START_MASK(i)	(0x001 << (i))
+#define CAN_RAMINIT_DONE_MASK(i)	(0x100 << (i))
+#define CAN_RAMINIT_ALL_MASK(i)		(0x101 << (i))
+static DEFINE_SPINLOCK(raminit_lock);
 /*
  * 16-bit c_can registers can be arranged differently in the memory
  * architecture of different implementations. For example: 16-bit
@@ -69,16 +71,44 @@ static void c_can_plat_write_reg_aligned
 	writew(val, priv->base + 2 * priv->regs[index]);
 }
 
+static void c_can_hw_raminit_wait(const struct c_can_priv *priv, u32 mask,
+				  u32 val)
+{
+	/* We look only at the bits of our instance. */
+	val &= mask;
+	while ((readl(priv->raminit_ctrlreg) & mask) != val)
+		udelay(1);
+}
+
 static void c_can_hw_raminit(const struct c_can_priv *priv, bool enable)
 {
-	u32 val;
+	u32 mask = CAN_RAMINIT_ALL_MASK(priv->instance);
+	u32 ctrl;
+
+	spin_lock(&raminit_lock);
 
-	val = readl(priv->raminit_ctrlreg);
-	if (enable)
-		val |= CAN_RAMINIT_START_MASK(priv->instance);
-	else
-		val &= ~CAN_RAMINIT_START_MASK(priv->instance);
-	writel(val, priv->raminit_ctrlreg);
+	ctrl = readl(priv->raminit_ctrlreg);
+	/*
+	 * We clear the done and start bit first. The start bit is
+	 * looking at the 0 -> transition, but is not self clearing;
+	 * And we clear the init done bit as well.
+	 */
+	ctrl &= ~CAN_RAMINIT_START_MASK(priv->instance);
+	ctrl |= CAN_RAMINIT_DONE_MASK(priv->instance);
+	writel(ctrl, priv->raminit_ctrlreg);
+	ctrl &= ~CAN_RAMINIT_DONE_MASK(priv->instance);
+	c_can_hw_raminit_wait(priv, ctrl, mask);
+
+	if (enable) {
+		/*
+		 * Set start bit and wait for the done bit.
+		 */
+		ctrl |= CAN_RAMINIT_START_MASK(priv->instance);
+		writel(ctrl, priv->raminit_ctrlreg);
+		ctrl |= CAN_RAMINIT_DONE_MASK(priv->instance);
+		c_can_hw_raminit_wait(priv, ctrl, mask);
+	}
+	spin_unlock(&raminit_lock);
 }
 
 static struct platform_device_id c_can_id_table[] = {


