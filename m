Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932263AbaLDPlD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Dec 2014 10:41:03 -0500
Received: from mailapp01.imgtec.com ([195.59.15.196]:15960 "EHLO
	mailapp01.imgtec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753345AbaLDPjO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Dec 2014 10:39:14 -0500
From: Sifan Naeem <sifan.naeem@imgtec.com>
To: <james.hogan@imgtec.com>, <mchehab@osg.samsung.com>
CC: <linux-kernel@vger.kernel.org>, <linux-media@vger.kernel.org>,
        <james.hartley@imgtec.com>, <ezequiel.garcia@imgtec.com>,
        Sifan Naeem <sifan.naeem@imgtec.com>
Subject: [PATCH 3/5] rc: img-ir: biphase enabled with workaround
Date: Thu, 4 Dec 2014 15:38:40 +0000
Message-ID: <1417707523-7730-4-git-send-email-sifan.naeem@imgtec.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1417707523-7730-1-git-send-email-sifan.naeem@imgtec.com>
References: <1417707523-7730-1-git-send-email-sifan.naeem@imgtec.com>
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

Signed-off-by: Sifan Naeem <sifan.naeem@imgtec.com>
---
 drivers/media/rc/img-ir/img-ir-hw.c |   56 +++++++++++++++++++++++++++++++++--
 drivers/media/rc/img-ir/img-ir-hw.h |    2 ++
 2 files changed, 55 insertions(+), 3 deletions(-)

diff --git a/drivers/media/rc/img-ir/img-ir-hw.c b/drivers/media/rc/img-ir/img-ir-hw.c
index 4a1407b..a977467 100644
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
 
@@ -547,6 +552,7 @@ static void img_ir_set_decoder(struct img_ir_priv *priv,
 
 	/* stop the end timer and switch back to normal mode */
 	del_timer_sync(&hw->end_timer);
+	del_timer_sync(&hw->suspend_timer);
 	hw->mode = IMG_IR_M_NORMAL;
 
 	/* clear the wakeup scancode filter */
@@ -843,6 +849,26 @@ static void img_ir_end_timer(unsigned long arg)
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
+	img_ir_write(priv, IMG_IR_IRQ_CLEAR,
+			IMG_IR_IRQ_ALL & ~IMG_IR_IRQ_EDGE);
+
+	/* Don't set IRQ if it has changed in a different context. */
+	if ((priv->hw.suspend_irqen & IMG_IR_IRQ_EDGE) ==
+				img_ir_read(priv, IMG_IR_IRQ_ENABLE))
+		img_ir_write(priv, IMG_IR_IRQ_ENABLE, priv->hw.suspend_irqen);
+	/* enable */
+	img_ir_write(priv, IMG_IR_CONTROL, priv->hw.reg_timings.ctrl);
+}
+
 #ifdef CONFIG_COMMON_CLK
 static void img_ir_change_frequency(struct img_ir_priv *priv,
 				    struct clk_notifier_data *change)
@@ -908,15 +934,37 @@ void img_ir_isr_hw(struct img_ir_priv *priv, u32 irq_status)
 	if (!hw->decoder)
 		return;
 
+	ct = hw->decoder->control.code_type;
+
 	ir_status = img_ir_read(priv, IMG_IR_STATUS);
-	if (!(ir_status & (IMG_IR_RXDVAL | IMG_IR_RXDVALD2)))
+	if (!(ir_status & (IMG_IR_RXDVAL | IMG_IR_RXDVALD2))) {
+		if (!(priv->hw.ct_quirks[ct] & IMG_IR_QUIRK_CODE_IRQ))
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
+		hw->suspend_irqen = img_ir_read(priv, IMG_IR_IRQ_ENABLE);
+		img_ir_write(priv, IMG_IR_IRQ_ENABLE,
+			     hw->suspend_irqen & IMG_IR_IRQ_EDGE);
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
 
@@ -958,7 +1006,7 @@ static void img_ir_probe_hw_caps(struct img_ir_priv *priv)
 	hw->ct_quirks[IMG_IR_CODETYPE_PULSELEN]
 		|= IMG_IR_QUIRK_CODE_LEN_INCR;
 	hw->ct_quirks[IMG_IR_CODETYPE_BIPHASE]
-		|= IMG_IR_QUIRK_CODE_BROKEN;
+		|= IMG_IR_QUIRK_CODE_IRQ;
 	hw->ct_quirks[IMG_IR_CODETYPE_2BITPULSEPOS]
 		|= IMG_IR_QUIRK_CODE_BROKEN;
 }
@@ -977,6 +1025,8 @@ int img_ir_probe_hw(struct img_ir_priv *priv)
 
 	/* Set up the end timer */
 	setup_timer(&hw->end_timer, img_ir_end_timer, (unsigned long)priv);
+	setup_timer(&hw->suspend_timer, img_ir_suspend_timer,
+				(unsigned long)priv);
 
 	/* Register a clock notifier */
 	if (!IS_ERR(priv->clk)) {
diff --git a/drivers/media/rc/img-ir/img-ir-hw.h b/drivers/media/rc/img-ir/img-ir-hw.h
index 5e59e8e..8578aa7 100644
--- a/drivers/media/rc/img-ir/img-ir-hw.h
+++ b/drivers/media/rc/img-ir/img-ir-hw.h
@@ -221,6 +221,7 @@ enum img_ir_mode {
  * @rdev:		Remote control device
  * @clk_nb:		Notifier block for clock notify events.
  * @end_timer:		Timer until repeat timeout.
+ * @suspend_timer:	Timer to re-enable protocol.
  * @decoder:		Current decoder settings.
  * @enabled_protocols:	Currently enabled protocols.
  * @clk_hz:		Current core clock rate in Hz.
@@ -235,6 +236,7 @@ struct img_ir_priv_hw {
 	struct rc_dev			*rdev;
 	struct notifier_block		clk_nb;
 	struct timer_list		end_timer;
+	struct timer_list		suspend_timer;
 	const struct img_ir_decoder	*decoder;
 	u64				enabled_protocols;
 	unsigned long			clk_hz;
-- 
1.7.9.5

