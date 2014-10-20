Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753328AbaJTTFT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Oct 2014 15:05:19 -0400
Received: from mail-pa0-f74.google.com ([209.85.220.74]:42121 "EHLO
	mail-pa0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752863AbaJTTEP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Oct 2014 15:04:15 -0400
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
Subject: [PATCH 14/19] clocksource: mips-gic: Move gic_frequency to clocksource driver
Date: Mon, 20 Oct 2014 12:04:01 -0700
Message-Id: <1413831846-32100-15-git-send-email-abrestic@chromium.org>
X-Mailer: git-send-email 2.1.0.rc2.206.gedb03e5
In-Reply-To: <1413831846-32100-1-git-send-email-abrestic@chromium.org>
References: <1413831846-32100-1-git-send-email-abrestic@chromium.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There's no reason for gic_frequency to be global any more and it
certainly doesn't belong in the GIC irqchip driver, so move it to
the GIC clocksource driver.

Signed-off-by: Andrew Bresticker <abrestic@chromium.org>
---
 arch/mips/mti-malta/malta-time.c     | 2 ++
 drivers/clocksource/mips-gic-timer.c | 3 +++
 drivers/irqchip/irq-mips-gic.c       | 1 -
 include/linux/irqchip/mips-gic.h     | 1 -
 4 files changed, 5 insertions(+), 2 deletions(-)

diff --git a/arch/mips/mti-malta/malta-time.c b/arch/mips/mti-malta/malta-time.c
index 028fae0..ce02dbd 100644
--- a/arch/mips/mti-malta/malta-time.c
+++ b/arch/mips/mti-malta/malta-time.c
@@ -46,6 +46,8 @@ static int mips_cpu_timer_irq;
 static int mips_cpu_perf_irq;
 extern int cp0_perfcount_irq;
 
+static unsigned int gic_frequency;
+
 static void mips_timer_dispatch(void)
 {
 	do_IRQ(mips_cpu_timer_irq);
diff --git a/drivers/clocksource/mips-gic-timer.c b/drivers/clocksource/mips-gic-timer.c
index 2603f50..bced17d 100644
--- a/drivers/clocksource/mips-gic-timer.c
+++ b/drivers/clocksource/mips-gic-timer.c
@@ -17,6 +17,7 @@
 
 static DEFINE_PER_CPU(struct clock_event_device, gic_clockevent_device);
 static int gic_timer_irq_installed;
+static unsigned int gic_frequency;
 
 static int gic_next_event(unsigned long delta, struct clock_event_device *evt)
 {
@@ -112,6 +113,8 @@ static struct clocksource gic_clocksource = {
 
 void __init gic_clocksource_init(unsigned int frequency)
 {
+	gic_frequency = frequency;
+
 	/* Set clocksource mask. */
 	gic_clocksource.mask = CLOCKSOURCE_MASK(gic_get_count_width());
 
diff --git a/drivers/irqchip/irq-mips-gic.c b/drivers/irqchip/irq-mips-gic.c
index 5c856e6..2949a9c 100644
--- a/drivers/irqchip/irq-mips-gic.c
+++ b/drivers/irqchip/irq-mips-gic.c
@@ -18,7 +18,6 @@
 #include <asm/setup.h>
 #include <asm/traps.h>
 
-unsigned int gic_frequency;
 unsigned int gic_present;
 
 struct gic_pcpu_mask {
diff --git a/include/linux/irqchip/mips-gic.h b/include/linux/irqchip/mips-gic.h
index 0350eff..420f77b 100644
--- a/include/linux/irqchip/mips-gic.h
+++ b/include/linux/irqchip/mips-gic.h
@@ -230,7 +230,6 @@
 #define GIC_HWIRQ_TO_SHARED(x)	((x) - GIC_SHARED_HWIRQ_BASE)
 
 extern unsigned int gic_present;
-extern unsigned int gic_frequency;
 
 extern void gic_init(unsigned long gic_base_addr,
 	unsigned long gic_addrspace_size, unsigned int cpu_vec,
-- 
2.1.0.rc2.206.gedb03e5

