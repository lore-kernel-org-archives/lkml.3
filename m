Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752247Ab3GEWwF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Jul 2013 18:52:05 -0400
Received: from gloria.sntech.de ([95.129.55.99]:37937 "EHLO gloria.sntech.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751441Ab3GEWwD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Jul 2013 18:52:03 -0400
From: Heiko =?utf-8?q?St=C3=BCbner?= <heiko@sntech.de>
To: John Stultz <john.stultz@linaro.org>
Subject: [PATCH 1/9] clocksource: dw_apb_timer: infrastructure to handle quirks
Date: Sat, 6 Jul 2013 00:51:52 +0200
User-Agent: KMail/1.13.7 (Linux/3.2.0-3-686-pae; KDE/4.8.4; i686; ; )
Cc: Thomas Gleixner <tglx@linutronix.de>, Jamie Iles <jamie@jamieiles.com>,
        Dinh Nguyen <dinguyen@altera.com>,
        Grant Likely <grant.likely@linaro.org>,
        linux-arm-kernel@lists.infradead.org,
        Rob Herring <rob.herring@calxeda.com>,
        devicetree-discuss@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        Arnd Bergmann <arnd@arndb.de>, Olof Johansson <olof@lixom.net>,
        Ulrich Prinz <ulrich.prinz@googlemail.com>
References: <201307060051.09716.heiko@sntech.de>
In-Reply-To: <201307060051.09716.heiko@sntech.de>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201307060051.53244.heiko@sntech.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There exist variants of the timer IP with some modified properties.

Therefore add infrastructure to handle hardware-quirks in the driver.

Signed-off-by: Heiko Stuebner <heiko@sntech.de>
---
 arch/x86/kernel/apb_timer.c           |    4 ++--
 drivers/clocksource/dw_apb_timer.c    |    7 +++++--
 drivers/clocksource/dw_apb_timer_of.c |    4 ++--
 include/linux/dw_apb_timer.h          |    6 ++++--
 4 files changed, 13 insertions(+), 8 deletions(-)

diff --git a/arch/x86/kernel/apb_timer.c b/arch/x86/kernel/apb_timer.c
index c9876ef..e7fe0f6 100644
--- a/arch/x86/kernel/apb_timer.c
+++ b/arch/x86/kernel/apb_timer.c
@@ -121,7 +121,7 @@ static inline void apbt_set_mapping(void)
 
 	clocksource_apbt = dw_apb_clocksource_init(APBT_CLOCKSOURCE_RATING,
 		"apbt0", apbt_virt_address + phy_cs_timer_id *
-		APBTMRS_REG_SIZE, apbt_freq);
+		APBTMRS_REG_SIZE, apbt_freq, 0);
 	return;
 
 panic_noapbt:
@@ -159,7 +159,7 @@ static int __init apbt_clockevent_register(void)
 	adev->timer = dw_apb_clockevent_init(smp_processor_id(), "apbt0",
 		mrst_timer_options == MRST_TIMER_LAPIC_APBT ?
 		APBT_CLOCKEVENT_RATING - 100 : APBT_CLOCKEVENT_RATING,
-		adev_virt_addr(adev), 0, apbt_freq);
+		adev_virt_addr(adev), 0, apbt_freq, 0);
 	/* Firmware does EOI handling for us. */
 	adev->timer->eoi = NULL;
 
diff --git a/drivers/clocksource/dw_apb_timer.c b/drivers/clocksource/dw_apb_timer.c
index 8c2a35f..01bdac0 100644
--- a/drivers/clocksource/dw_apb_timer.c
+++ b/drivers/clocksource/dw_apb_timer.c
@@ -213,7 +213,8 @@ static int apbt_next_event(unsigned long delta,
  */
 struct dw_apb_clock_event_device *
 dw_apb_clockevent_init(int cpu, const char *name, unsigned rating,
-		       void __iomem *base, int irq, unsigned long freq)
+		       void __iomem *base, int irq, unsigned long freq,
+		       int quirks)
 {
 	struct dw_apb_clock_event_device *dw_ced =
 		kzalloc(sizeof(*dw_ced), GFP_KERNEL);
@@ -225,6 +226,7 @@ dw_apb_clockevent_init(int cpu, const char *name, unsigned rating,
 	dw_ced->timer.base = base;
 	dw_ced->timer.irq = irq;
 	dw_ced->timer.freq = freq;
+	dw_ced->timer.quirks = quirks;
 
 	clockevents_calc_mult_shift(&dw_ced->ced, freq, APBT_MIN_PERIOD);
 	dw_ced->ced.max_delta_ns = clockevent_delta2ns(0x7fffffff,
@@ -349,7 +351,7 @@ static void apbt_restart_clocksource(struct clocksource *cs)
  */
 struct dw_apb_clocksource *
 dw_apb_clocksource_init(unsigned rating, const char *name, void __iomem *base,
-			unsigned long freq)
+			unsigned long freq, int quirks)
 {
 	struct dw_apb_clocksource *dw_cs = kzalloc(sizeof(*dw_cs), GFP_KERNEL);
 
@@ -358,6 +360,7 @@ dw_apb_clocksource_init(unsigned rating, const char *name, void __iomem *base,
 
 	dw_cs->timer.base = base;
 	dw_cs->timer.freq = freq;
+	dw_cs->timer.quirks = quirks;
 	dw_cs->cs.name = name;
 	dw_cs->cs.rating = rating;
 	dw_cs->cs.read = __apbt_read_clocksource;
diff --git a/drivers/clocksource/dw_apb_timer_of.c b/drivers/clocksource/dw_apb_timer_of.c
index cef5544..b5412af 100644
--- a/drivers/clocksource/dw_apb_timer_of.c
+++ b/drivers/clocksource/dw_apb_timer_of.c
@@ -74,7 +74,7 @@ static void add_clockevent(struct device_node *event_timer)
 	timer_get_base_and_rate(event_timer, &iobase, &rate);
 
 	ced = dw_apb_clockevent_init(0, event_timer->name, 300, iobase, irq,
-				     rate);
+				     rate, 0);
 	if (!ced)
 		panic("Unable to initialise clockevent device");
 
@@ -92,7 +92,7 @@ static void add_clocksource(struct device_node *source_timer)
 
 	timer_get_base_and_rate(source_timer, &iobase, &rate);
 
-	cs = dw_apb_clocksource_init(300, source_timer->name, iobase, rate);
+	cs = dw_apb_clocksource_init(300, source_timer->name, iobase, rate, 0);
 	if (!cs)
 		panic("Unable to initialise clocksource device");
 
diff --git a/include/linux/dw_apb_timer.h b/include/linux/dw_apb_timer.h
index 07261d5..67d09c7 100644
--- a/include/linux/dw_apb_timer.h
+++ b/include/linux/dw_apb_timer.h
@@ -23,6 +23,7 @@ struct dw_apb_timer {
 	void __iomem				*base;
 	unsigned long				freq;
 	int					irq;
+	int					quirks;
 };
 
 struct dw_apb_clock_event_device {
@@ -44,10 +45,11 @@ void dw_apb_clockevent_stop(struct dw_apb_clock_event_device *dw_ced);
 
 struct dw_apb_clock_event_device *
 dw_apb_clockevent_init(int cpu, const char *name, unsigned rating,
-		       void __iomem *base, int irq, unsigned long freq);
+		       void __iomem *base, int irq, unsigned long freq,
+		       int quirks);
 struct dw_apb_clocksource *
 dw_apb_clocksource_init(unsigned rating, const char *name, void __iomem *base,
-			unsigned long freq);
+			unsigned long freq, int quirks);
 void dw_apb_clocksource_register(struct dw_apb_clocksource *dw_cs);
 void dw_apb_clocksource_start(struct dw_apb_clocksource *dw_cs);
 cycle_t dw_apb_clocksource_read(struct dw_apb_clocksource *dw_cs);
-- 
1.7.10.4

