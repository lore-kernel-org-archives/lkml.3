Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753597AbaJTTKe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Oct 2014 15:10:34 -0400
Received: from mail-vc0-f202.google.com ([209.85.220.202]:53454 "EHLO
	mail-vc0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751044AbaJTTEK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Oct 2014 15:04:10 -0400
From: Andrew Bresticker <abrestic@chromium.org>
To: Ralf Baechle <ralf@linux-mips.org>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Jason Cooper <jason@lakedaemon.net>
Cc: Andrew Bresticker <abrestic@chromium.org>,
        Paul Burton <paul.burton@imgtec.com>,
        Qais Yousef <qais.yousef@imgtec.com>,
        John Crispin <blogic@openwrt.org>, linux-mips@linux-mips.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 02/19] irqchip: mips-gic: Export function to read counter width
Date: Mon, 20 Oct 2014 12:03:49 -0700
Message-Id: <1413831846-32100-3-git-send-email-abrestic@chromium.org>
X-Mailer: git-send-email 2.1.0.rc2.206.gedb03e5
In-Reply-To: <1413831846-32100-1-git-send-email-abrestic@chromium.org>
References: <1413831846-32100-1-git-send-email-abrestic@chromium.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Export the function gic_get_count_width to read the width of
the GIC global counter from GIC_SH_CONFIG.  Update the GIC
clocksource driver to use this new function.

Signed-off-by: Andrew Bresticker <abrestic@chromium.org>
---
 arch/mips/include/asm/gic.h    |  1 +
 arch/mips/kernel/csrc-gic.c    |  9 +--------
 drivers/irqchip/irq-mips-gic.c | 11 +++++++++++
 3 files changed, 13 insertions(+), 8 deletions(-)

diff --git a/arch/mips/include/asm/gic.h b/arch/mips/include/asm/gic.h
index 727b7bf..c88e1fa 100644
--- a/arch/mips/include/asm/gic.h
+++ b/arch/mips/include/asm/gic.h
@@ -370,6 +370,7 @@ extern void gic_init(unsigned long gic_base_addr,
 	unsigned int irqbase);
 extern void gic_clocksource_init(unsigned int);
 extern cycle_t gic_read_count(void);
+extern unsigned int gic_get_count_width(void);
 extern cycle_t gic_read_compare(void);
 extern void gic_write_compare(cycle_t cnt);
 extern void gic_write_cpu_compare(cycle_t cnt, int cpu);
diff --git a/arch/mips/kernel/csrc-gic.c b/arch/mips/kernel/csrc-gic.c
index e026209..ab615c6 100644
--- a/arch/mips/kernel/csrc-gic.c
+++ b/arch/mips/kernel/csrc-gic.c
@@ -23,15 +23,8 @@ static struct clocksource gic_clocksource = {
 
 void __init gic_clocksource_init(unsigned int frequency)
 {
-	unsigned int config, bits;
-
-	/* Calculate the clocksource mask. */
-	GICREAD(GIC_REG(SHARED, GIC_SH_CONFIG), config);
-	bits = 32 + ((config & GIC_SH_CONFIG_COUNTBITS_MSK) >>
-		(GIC_SH_CONFIG_COUNTBITS_SHF - 2));
-
 	/* Set clocksource mask. */
-	gic_clocksource.mask = CLOCKSOURCE_MASK(bits);
+	gic_clocksource.mask = CLOCKSOURCE_MASK(gic_get_count_width());
 
 	/* Calculate a somewhat reasonable rating value. */
 	gic_clocksource.rating = 200 + frequency / 10000000;
diff --git a/drivers/irqchip/irq-mips-gic.c b/drivers/irqchip/irq-mips-gic.c
index 02c7d2a..83dde6f 100644
--- a/drivers/irqchip/irq-mips-gic.c
+++ b/drivers/irqchip/irq-mips-gic.c
@@ -63,6 +63,17 @@ cycle_t gic_read_count(void)
 	return (((cycle_t) hi) << 32) + lo;
 }
 
+unsigned int gic_get_count_width(void)
+{
+	unsigned int bits, config;
+
+	GICREAD(GIC_REG(SHARED, GIC_SH_CONFIG), config);
+	bits = 32 + 4 * ((config & GIC_SH_CONFIG_COUNTBITS_MSK) >>
+			 GIC_SH_CONFIG_COUNTBITS_SHF);
+
+	return bits;
+}
+
 void gic_write_compare(cycle_t cnt)
 {
 	GICWRITE(GIC_REG(VPE_LOCAL, GIC_VPE_COMPARE_HI),
-- 
2.1.0.rc2.206.gedb03e5

