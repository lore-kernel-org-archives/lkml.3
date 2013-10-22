Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753685Ab3JVOM5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Oct 2013 10:12:57 -0400
Received: from www.linutronix.de ([62.245.132.108]:54018 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752319Ab3JVOM4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Oct 2013 10:12:56 -0400
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
To: Lee Jones <lee.jones@linaro.org>
Cc: Samuel Ortiz <sameo@linux.intel.com>, linux-kernel@vger.kernel.org,
        Zubair Lutfullah <zubair.lutfullah@gmail.com>,
        Felipe Balbi <balbi@ti.com>, kishon@ti.com,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Subject: [PATCH] mfd: ti_am335x_tscadc: avoid possible deadlock of reg_lock
Date: Tue, 22 Oct 2013 16:12:39 +0200
Message-Id: <1382451159-25183-1-git-send-email-bigeasy@linutronix.de>
X-Mailer: git-send-email 1.8.4.rc3
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001,URIBL_BLOCKED=0.001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since the addition of continuous sampling mode and shared irq support,
the reg_lock lock can be taken with and without interrupts. This patch
uses the *_irq* variant which should be used in order to avaoid a deadlock.

Cc: Zubair Lutfullah <zubair.lutfullah@gmail.com>
Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
---
 drivers/mfd/ti_am335x_tscadc.c | 12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

diff --git a/drivers/mfd/ti_am335x_tscadc.c b/drivers/mfd/ti_am335x_tscadc.c
index baaf5a8..912a41f 100644
--- a/drivers/mfd/ti_am335x_tscadc.c
+++ b/drivers/mfd/ti_am335x_tscadc.c
@@ -56,21 +56,25 @@ EXPORT_SYMBOL_GPL(am335x_tsc_se_update);
 
 void am335x_tsc_se_set(struct ti_tscadc_dev *tsadc, u32 val)
 {
-	spin_lock(&tsadc->reg_lock);
+	unsigned long flags;
+
+	spin_lock_irqsave(&tsadc->reg_lock, flags);
 	tsadc->reg_se_cache = tscadc_readl(tsadc, REG_SE);
 	tsadc->reg_se_cache |= val;
 	am335x_tsc_se_update(tsadc);
-	spin_unlock(&tsadc->reg_lock);
+	spin_unlock_irqrestore(&tsadc->reg_lock, flags);
 }
 EXPORT_SYMBOL_GPL(am335x_tsc_se_set);
 
 void am335x_tsc_se_clr(struct ti_tscadc_dev *tsadc, u32 val)
 {
-	spin_lock(&tsadc->reg_lock);
+	unsigned long flags;
+
+	spin_lock_irqsave(&tsadc->reg_lock, flags);
 	tsadc->reg_se_cache = tscadc_readl(tsadc, REG_SE);
 	tsadc->reg_se_cache &= ~val;
 	am335x_tsc_se_update(tsadc);
-	spin_unlock(&tsadc->reg_lock);
+	spin_unlock_irqrestore(&tsadc->reg_lock, flags);
 }
 EXPORT_SYMBOL_GPL(am335x_tsc_se_clr);
 
-- 
1.8.4.rc3

