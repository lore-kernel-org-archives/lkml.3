Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932522AbaGELOR (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Jul 2014 07:14:17 -0400
Received: from smtp04.smtpout.orange.fr ([80.12.242.126]:19940 "EHLO
	smtp.smtpout.orange.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755198AbaGELOC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Jul 2014 07:14:02 -0400
X-ME-Helo: localhost.localdomain
X-ME-Date: Sat, 05 Jul 2014 13:14:01 +0200
X-ME-IP: 86.199.194.180
From: Robert Jarzmik <robert.jarzmik@free.fr>
To: Daniel Lezcano <daniel.lezcano@linaro.org>,
        Haojian Zhuang <haojian.zhuang@gmail.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Robert Jarzmik <robert.jarzmik@free.fr>
Subject: [PATCH v2 4/4] arm: pxa: add non device-tree timer link to clocksource
Date: Sat,  5 Jul 2014 13:13:01 +0200
Message-Id: <1404558781-9537-4-git-send-email-robert.jarzmik@free.fr>
X-Mailer: git-send-email 2.0.0.rc2
In-Reply-To: <1404558781-9537-1-git-send-email-robert.jarzmik@free.fr>
References: <1404558781-9537-1-git-send-email-robert.jarzmik@free.fr>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As clocksource pxa_timer was moved to clocksource framework, the
pxa_timer initialization needs to be a bit amended, to pass the
necessary informations to clocksource, ie :
 - the timer interrupt (mach specific)
 - the timer registers base (ditto)
 - the timer clockrate

Signed-off-by: Robert Jarzmik <robert.jarzmik@free.fr>
---
 arch/arm/mach-pxa/generic.c | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/arch/arm/mach-pxa/generic.c b/arch/arm/mach-pxa/generic.c
index 4225417..2dcded5 100644
--- a/arch/arm/mach-pxa/generic.c
+++ b/arch/arm/mach-pxa/generic.c
@@ -25,6 +25,7 @@
 #include <asm/mach/map.h>
 #include <asm/mach-types.h>
 
+#include <mach/irqs.h>
 #include <mach/reset.h>
 #include <mach/smemc.h>
 #include <mach/pxa3xx-regs.h>
@@ -57,6 +58,17 @@ unsigned long get_clock_tick_rate(void)
 EXPORT_SYMBOL(get_clock_tick_rate);
 
 /*
+ * For non device-tree builds, keep legacy timer init
+ */
+extern void pxa_timer_nodt_init(int irq, void __iomem *base,
+			   unsigned long clock_tick_rate);
+void pxa_timer_init(void)
+{
+	pxa_timer_nodt_init(IRQ_OST0, io_p2v(0x40a00000),
+			    get_clock_tick_rate());
+}
+
+/*
  * Get the clock frequency as reflected by CCCR and the turbo flag.
  * We assume these values have been applied via a fcs.
  * If info is not 0 we also display the current settings.
-- 
2.0.0.rc2

