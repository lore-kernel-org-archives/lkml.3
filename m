Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757666Ab3CFLSv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Mar 2013 06:18:51 -0500
Received: from www.linutronix.de ([62.245.132.108]:42520 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753951Ab3CFLSi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Mar 2013 06:18:38 -0500
Message-Id: <20130306111537.640722922@linutronix.de>
User-Agent: quilt/0.48-1
Date: Wed, 06 Mar 2013 11:18:37 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: LAK <linux-arm-kernel@lists.infradead.org>,
        John Stultz <john.stultz@linaro.org>,
        Arjan van de Veen <arjan@infradead.org>,
        Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>,
        Jason Liu <liu.h.jason@gmail.com>
Subject: [patch 6/7] arm: Use tick broadcast expired check
References: <20130306111351.883117670@linutronix.de>
Content-Disposition: inline; filename=arm-use-broadcast-expired-check.patch
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Avoid going back into deep idle if the tick broadcast IPI is about to
fire.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 arch/arm/kernel/process.c |   11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

Index: tip/arch/arm/kernel/process.c
===================================================================
--- tip.orig/arch/arm/kernel/process.c
+++ tip/arch/arm/kernel/process.c
@@ -199,7 +199,16 @@ void cpu_idle(void)
 #ifdef CONFIG_PL310_ERRATA_769419
 			wmb();
 #endif
-			if (hlt_counter) {
+			/*
+			 * In poll mode we reenable interrupts and spin.
+			 *
+			 * Also if we detected in the wakeup from idle
+			 * path that the tick broadcast device expired
+			 * for us, we don't want to go deep idle as we
+			 * know that the IPI is going to arrive right
+			 * away
+			 */
+			if (hlt_counter || tick_check_broadcast_expired()) {
 				local_irq_enable();
 				cpu_relax();
 			} else if (!need_resched()) {


