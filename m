Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933673Ab3GWQKL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jul 2013 12:10:11 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:44514 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933641Ab3GWQKH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jul 2013 12:10:07 -0400
From: Illia Smyrnov <illia.smyrnov@ti.com>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
CC: <balbi@ti.com>, <linux-input@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-omap@vger.kernel.org>
Subject: [PATCH v2 2/3] Input: omap-keypad: Convert to threaded IRQ
Date: Tue, 23 Jul 2013 19:09:57 +0300
Message-ID: <1374595798-15492-3-git-send-email-illia.smyrnov@ti.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1374595798-15492-1-git-send-email-illia.smyrnov@ti.com>
References: <1374595798-15492-1-git-send-email-illia.smyrnov@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Convert to use threaded IRQ.

Cc: Felipe Balbi <balbi@ti.com>
Signed-off-by: Illia Smyrnov <illia.smyrnov@ti.com>
---
 drivers/input/keyboard/omap4-keypad.c |   29 ++++++++++++++++++++---------
 1 files changed, 20 insertions(+), 9 deletions(-)

diff --git a/drivers/input/keyboard/omap4-keypad.c b/drivers/input/keyboard/omap4-keypad.c
index c727548..b876a0d 100644
--- a/drivers/input/keyboard/omap4-keypad.c
+++ b/drivers/input/keyboard/omap4-keypad.c
@@ -112,8 +112,22 @@ static void kbd_write_irqreg(struct omap4_keypad *keypad_data,
 }
 
 
-/* Interrupt handler */
-static irqreturn_t omap4_keypad_interrupt(int irq, void *dev_id)
+/* Interrupt handlers */
+static irqreturn_t omap4_keypad_irq_handler(int irq, void *dev_id)
+{
+	struct omap4_keypad *keypad_data = dev_id;
+
+	if (kbd_read_irqreg(keypad_data, OMAP4_KBD_IRQSTATUS)) {
+		/* Disable interrupts */
+		kbd_write_irqreg(keypad_data, OMAP4_KBD_IRQENABLE,
+				 OMAP4_VAL_IRQDISABLE);
+		return IRQ_WAKE_THREAD;
+	}
+
+	return IRQ_NONE;
+}
+
+static irqreturn_t omap4_keypad_irq_thread_fn(int irq, void *dev_id)
 {
 	struct omap4_keypad *keypad_data = dev_id;
 	struct input_dev *input_dev = keypad_data->input;
@@ -121,10 +135,6 @@ static irqreturn_t omap4_keypad_interrupt(int irq, void *dev_id)
 	unsigned int col, row, code, changed;
 	u32 *new_state = (u32 *) key_state;
 
-	/* Disable interrupts */
-	kbd_write_irqreg(keypad_data, OMAP4_KBD_IRQENABLE,
-			 OMAP4_VAL_IRQDISABLE);
-
 	*new_state = kbd_readl(keypad_data, OMAP4_KBD_FULLCODE31_0);
 	*(new_state + 1) = kbd_readl(keypad_data, OMAP4_KBD_FULLCODE63_32);
 
@@ -360,9 +370,10 @@ static int omap4_keypad_probe(struct platform_device *pdev)
 		goto err_free_keymap;
 	}
 
-	error = request_irq(keypad_data->irq, omap4_keypad_interrupt,
-			     IRQF_TRIGGER_RISING,
-			     "omap4-keypad", keypad_data);
+	error = request_threaded_irq(keypad_data->irq, omap4_keypad_irq_handler,
+				     omap4_keypad_irq_thread_fn,
+				     IRQF_TRIGGER_RISING,
+				     "omap4-keypad", keypad_data);
 	if (error) {
 		dev_err(&pdev->dev, "failed to register interrupt\n");
 		goto err_free_input;
-- 
1.7.0.4

