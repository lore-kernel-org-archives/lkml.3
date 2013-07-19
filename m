Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760435Ab3GSNDz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Jul 2013 09:03:55 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:50100 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759903Ab3GSNDx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Jul 2013 09:03:53 -0400
From: Illia Smyrnov <illia.smyrnov@globallogic.com>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
CC: <linux-input@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-omap@vger.kernel.org>
Subject: [PATCH 2/2] Input: omap-keypad: Cleanup - remove unnecessary IRQ enabling/disabling
Date: Fri, 19 Jul 2013 16:03:47 +0300
Message-ID: <1374239027-3927-3-git-send-email-illia.smyrnov@globallogic.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1374239027-3927-1-git-send-email-illia.smyrnov@globallogic.com>
References: <1374239027-3927-1-git-send-email-illia.smyrnov@globallogic.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Illia Smyrnov <illia.smyrnov@ti.com>

Remove unnecessary IRQ enabling/disabling for certain keyboard events.

Signed-off-by: Illia Smyrnov <illia.smyrnov@ti.com>
---
 drivers/input/keyboard/omap4-keypad.c |   15 ++++-----------
 1 files changed, 4 insertions(+), 11 deletions(-)

diff --git a/drivers/input/keyboard/omap4-keypad.c b/drivers/input/keyboard/omap4-keypad.c
index c727548..73813b6 100644
--- a/drivers/input/keyboard/omap4-keypad.c
+++ b/drivers/input/keyboard/omap4-keypad.c
@@ -121,10 +121,6 @@ static irqreturn_t omap4_keypad_interrupt(int irq, void *dev_id)
 	unsigned int col, row, code, changed;
 	u32 *new_state = (u32 *) key_state;
 
-	/* Disable interrupts */
-	kbd_write_irqreg(keypad_data, OMAP4_KBD_IRQENABLE,
-			 OMAP4_VAL_IRQDISABLE);
-
 	*new_state = kbd_readl(keypad_data, OMAP4_KBD_FULLCODE31_0);
 	*(new_state + 1) = kbd_readl(keypad_data, OMAP4_KBD_FULLCODE63_32);
 
@@ -154,11 +150,6 @@ static irqreturn_t omap4_keypad_interrupt(int irq, void *dev_id)
 	kbd_write_irqreg(keypad_data, OMAP4_KBD_IRQSTATUS,
 			 kbd_read_irqreg(keypad_data, OMAP4_KBD_IRQSTATUS));
 
-	/* enable interrupts */
-	kbd_write_irqreg(keypad_data, OMAP4_KBD_IRQENABLE,
-		OMAP4_DEF_IRQENABLE_EVENTEN |
-				OMAP4_DEF_IRQENABLE_LONGKEY);
-
 	return IRQ_HANDLED;
 }
 
@@ -175,14 +166,16 @@ static int omap4_keypad_open(struct input_dev *input)
 			(OMAP4_VAL_PVT << OMAP4_DEF_CTRL_PTV_SHIFT));
 	kbd_writel(keypad_data, OMAP4_KBD_DEBOUNCINGTIME,
 			OMAP4_VAL_DEBOUNCINGTIME);
-	kbd_write_irqreg(keypad_data, OMAP4_KBD_IRQSTATUS,
-			OMAP4_VAL_IRQDISABLE);
 	kbd_write_irqreg(keypad_data, OMAP4_KBD_IRQENABLE,
 			OMAP4_DEF_IRQENABLE_EVENTEN |
 				OMAP4_DEF_IRQENABLE_LONGKEY);
 	kbd_writel(keypad_data, OMAP4_KBD_WAKEUPENABLE,
 			OMAP4_DEF_WUP_EVENT_ENA | OMAP4_DEF_WUP_LONG_KEY_ENA);
 
+	/* clear pending interrupts */
+	kbd_write_irqreg(keypad_data, OMAP4_KBD_IRQSTATUS,
+			 kbd_read_irqreg(keypad_data, OMAP4_KBD_IRQSTATUS));
+
 	enable_irq(keypad_data->irq);
 
 	return 0;
-- 
1.7.0.4

