Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757691Ab3CFLUH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Mar 2013 06:20:07 -0500
Received: from www.linutronix.de ([62.245.132.108]:42531 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757510Ab3CFLSl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Mar 2013 06:18:41 -0500
Message-Id: <20130306111537.702278273@linutronix.de>
User-Agent: quilt/0.48-1
Date: Wed, 06 Mar 2013 11:18:37 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: LAK <linux-arm-kernel@lists.infradead.org>,
        John Stultz <john.stultz@linaro.org>,
        Arjan van de Veen <arjan@infradead.org>,
        Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>,
        Jason Liu <liu.h.jason@gmail.com>, x86@kernel.org
Subject: [patch 7/7] x86: Use tick broadcast expired check
References: <20130306111351.883117670@linutronix.de>
Content-Disposition: inline; filename=x86-use-broadcast-expired-check.patch
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Avoid going back into deep idle if the tick broadcast IPI is about to
fire.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: x86@kernel.org
---
 arch/x86/kernel/process.c |   12 ++++++++++++
 1 file changed, 12 insertions(+)

Index: tip/arch/x86/kernel/process.c
===================================================================
--- tip.orig/arch/x86/kernel/process.c
+++ tip/arch/x86/kernel/process.c
@@ -336,6 +336,18 @@ void cpu_idle(void)
 			local_touch_nmi();
 			local_irq_disable();
 
+			/*
+			 * We detected in the wakeup path that the
+			 * tick broadcast device expired for us, but
+			 * we raced with the other CPU and came back
+			 * here before it was able to fire the IPI.
+			 * No point in going idle.
+			 */
+			if (tick_check_broadcast_expired()) {
+				local_irq_enable();
+				continue;
+			}
+
 			enter_idle();
 
 			/* Don't trace irqs off for idle */


