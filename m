Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933273AbaLKUGf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Dec 2014 15:06:35 -0500
Received: from mailapp01.imgtec.com ([195.59.15.196]:14528 "EHLO
	mailapp01.imgtec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758732AbaLKUF6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Dec 2014 15:05:58 -0500
From: Sifan Naeem <sifan.naeem@imgtec.com>
To: <james.hogan@imgtec.com>, <mchehab@osg.samsung.com>
CC: <linux-kernel@vger.kernel.org>, <linux-media@vger.kernel.org>,
        <james.hartley@imgtec.com>, <ezequiel.garcia@imgtec.com>,
        Sifan Naeem <sifan.naeem@imgtec.com>
Subject: [PATCH v2 3/5] rc: img-ir: biphase enabled with workaround
Date: Thu, 11 Dec 2014 20:06:24 +0000
Message-ID: <1418328386-9802-4-git-send-email-sifan.naeem@imgtec.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1418328386-9802-1-git-send-email-sifan.naeem@imgtec.com>
References: <1418328386-9802-1-git-send-email-sifan.naeem@imgtec.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [192.168.167.63]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Biphase decoding in the current img-ir has got a quirk, where multiple
Interrupts are generated when an incomplete IR code is received by the
decoder.

Patch adds a work around for the quirk and enables biphase decoding.

Changes from v1:
 * rebased due to conflict with "img-ir/hw: Fix potential deadlock stopping timer"
 * spinlock taken in img_ir_suspend_timer
 * check for hw->stopping before handling quirks in img_ir_isr_hw
 * new memeber added to img_ir_priv_hw to save irq status over suspend

Signed-off-by: Sifan Naeem <sifan.naeem@imgtec.com>
---
 drivers/media/rc/img-ir/img-ir-hw.c |   60 +++++++++++++++++++++++++++++++++--
 drivers/media/rc/img-ir/img-ir-hw.h |    4 +++
 2 files changed, 61 insertions(+), 3 deletions(-)

diff --git a/drivers/media/rc/img-ir/img-ir-hw.c b/drivers/media/rc/img-ir/img-ir-hw.c
index 9cecda7..5c32f05 100644
--- a/drivers/media/rc/img-ir/img-ir-hw.c
+++ b/drivers/media/rc/img-ir/img-ir-hw.c
@@ -52,6 +52,11 @@ static struct img_ir_decoder *img_ir_decoders[] = {
 
 #define IMG_IR_QUIRK_CODE_BROKEN	0x1	/* Decode is broken */
 #define IMG_IR_QUIRK_CODE_LEN_INCR	0x2	/* Bit length needs increment */
+/*
+ * The decoder generates rapid interrupts without actually having
+ * received any new data after an incomplete IR code is decoded.
+ */
+#define IMG_IR_QUIRK_CODE_IRQ		0x4
 
 /* functions for preprocessing timings, ensuring max is set */
 
@@ -542,6 +547,7 @@ static void img_ir_set_decoder(struct img_ir_priv *priv,
 	 */
 	spin_unlock_irq(&priv->lock);
 	del_timer_sync(&hw->end_timer);
+	del_timer_sync(&hw->suspend_timer);
 	spin_lock_irq(&priv->lock);
 
 	hw->stopping = false;
@@ -861,6 +867,29 @@ static void img_ir_end_timer(unsigned long arg)
 	spin_unlock_irq(&priv->lock);
 }
 
+/*
+ * Timer function to re-enable the current protocol after it had been
+ * cleared when invalid interrupts were generated due to a quirk in the
+ * img-ir decoder.
+ */
+static void img_ir_suspend_timer(unsigned long arg)
+{
+	struct img_ir_priv *priv = (struct img_ir_priv *)arg;
+
+	spin_lock_irq(&priv->lock);
+	/*
+	 * Don't overwrite enabled valid/match IRQs if they have already been
+	 * changed by e.g. a filter change.
+	 */
+	if ((priv->hw.quirk_suspend_irq & IMG_IR_IRQ_EDGE) ==
+				img_ir_read(priv, IMG_IR_IRQ_ENABLE))
+		img_ir_write(priv, IMG_IR_IRQ_ENABLE,
+					priv->hw.quirk_suspend_irq);
+	/* enable */
+	img_ir_write(priv, IMG_IR_CONTROL, priv->hw.reg_timings.ctrl);
+	spin_unlock_irq(&priv->lock);
+}
+
 #ifdef CONFIG_COMMON_CLK
 static void img_ir_change_frequency(struct img_ir_priv *priv,
 				    struct clk_notifier_data *change)
@@ -926,15 +955,38 @@ void img_ir_isr_hw(struct img_ir_priv *priv, u32 irq_status)
 	if (!hw->decoder)
 		return;
 
+	ct = hw->decoder->control.code_type;
+
 	ir_status = img_ir_read(priv, IMG_IR_STATUS);
-	if (!(ir_status & (IMG_IR_RXDVAL | IMG_IR_RXDVALD2)))
+	if (!(ir_status & (IMG_IR_RXDVAL | IMG_IR_RXDVALD2))) {
+		if (!(priv->hw.ct_quirks[ct] & IMG_IR_QUIRK_CODE_IRQ) ||
+				hw->stopping)
+			return;
+		/*
+		 * The below functionality is added as a work around to stop
+		 * multiple Interrupts generated when an incomplete IR code is
+		 * received by the decoder.
+		 * The decoder generates rapid interrupts without actually
+		 * having received any new data. After a single interrupt it's
+		 * expected to clear up, but instead multiple interrupts are
+		 * rapidly generated. only way to get out of this loop is to
+		 * reset the control register after a short delay.
+		 */
+		img_ir_write(priv, IMG_IR_CONTROL, 0);
+		hw->quirk_suspend_irq = img_ir_read(priv, IMG_IR_IRQ_ENABLE);
+		img_ir_write(priv, IMG_IR_IRQ_ENABLE,
+			     hw->quirk_suspend_irq & IMG_IR_IRQ_EDGE);
+
+		/* Timer activated to re-enable the protocol. */
+		mod_timer(&hw->suspend_timer,
+			  jiffies + msecs_to_jiffies(5));
 		return;
+	}
 	ir_status &= ~(IMG_IR_RXDVAL | IMG_IR_RXDVALD2);
 	img_ir_write(priv, IMG_IR_STATUS, ir_status);
 
 	len = (ir_status & IMG_IR_RXDLEN) >> IMG_IR_RXDLEN_SHIFT;
 	/* some versions report wrong length for certain code types */
-	ct = hw->decoder->control.code_type;
 	if (hw->ct_quirks[ct] & IMG_IR_QUIRK_CODE_LEN_INCR)
 		++len;
 
@@ -976,7 +1028,7 @@ static void img_ir_probe_hw_caps(struct img_ir_priv *priv)
 	hw->ct_quirks[IMG_IR_CODETYPE_PULSELEN]
 		|= IMG_IR_QUIRK_CODE_LEN_INCR;
 	hw->ct_quirks[IMG_IR_CODETYPE_BIPHASE]
-		|= IMG_IR_QUIRK_CODE_BROKEN;
+		|= IMG_IR_QUIRK_CODE_IRQ;
 	hw->ct_quirks[IMG_IR_CODETYPE_2BITPULSEPOS]
 		|= IMG_IR_QUIRK_CODE_BROKEN;
 }
@@ -995,6 +1047,8 @@ int img_ir_probe_hw(struct img_ir_priv *priv)
 
 	/* Set up the end timer */
 	setup_timer(&hw->end_timer, img_ir_end_timer, (unsigned long)priv);
+	setup_timer(&hw->suspend_timer, img_ir_suspend_timer,
+				(unsigned long)priv);
 
 	/* Register a clock notifier */
 	if (!IS_ERR(priv->clk)) {
diff --git a/drivers/media/rc/img-ir/img-ir-hw.h b/drivers/media/rc/img-ir/img-ir-hw.h
index beac3a6..b31ffc9 100644
--- a/drivers/media/rc/img-ir/img-ir-hw.h
+++ b/drivers/media/rc/img-ir/img-ir-hw.h
@@ -218,6 +218,7 @@ enum img_ir_mode {
  * @rdev:		Remote control device
  * @clk_nb:		Notifier block for clock notify events.
  * @end_timer:		Timer until repeat timeout.
+ * @suspend_timer:	Timer to re-enable protocol.
  * @decoder:		Current decoder settings.
  * @enabled_protocols:	Currently enabled protocols.
  * @clk_hz:		Current core clock rate in Hz.
@@ -228,12 +229,14 @@ enum img_ir_mode {
  * @stopping:		Indicates that decoder is being taken down and timers
  *			should not be restarted.
  * @suspend_irqen:	Saved IRQ enable mask over suspend.
+ * @quirk_suspend_irq:	Saved IRQ enable mask over quirk suspend timer.
  */
 struct img_ir_priv_hw {
 	unsigned int			ct_quirks[4];
 	struct rc_dev			*rdev;
 	struct notifier_block		clk_nb;
 	struct timer_list		end_timer;
+	struct timer_list		suspend_timer;
 	const struct img_ir_decoder	*decoder;
 	u64				enabled_protocols;
 	unsigned long			clk_hz;
@@ -244,6 +247,7 @@ struct img_ir_priv_hw {
 	enum img_ir_mode		mode;
 	bool				stopping;
 	u32				suspend_irqen;
+	u32				quirk_suspend_irq;
 };
 
 static inline bool img_ir_hw_enabled(struct img_ir_priv_hw *hw)
-- 
1.7.9.5

