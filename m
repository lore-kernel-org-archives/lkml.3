Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752489Ab3GEW4P (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Jul 2013 18:56:15 -0400
Received: from gloria.sntech.de ([95.129.55.99]:38109 "EHLO gloria.sntech.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751960Ab3GEW4O (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Jul 2013 18:56:14 -0400
From: Heiko =?utf-8?q?St=C3=BCbner?= <heiko@sntech.de>
To: John Stultz <john.stultz@linaro.org>
Subject: [PATCH 8/9] clocksource: dw_apb_timer_of: add quirk handling
Date: Sat, 6 Jul 2013 00:56:03 +0200
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
Message-Id: <201307060056.03543.heiko@sntech.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

timer_get_base_and_rate now also can extract informations about present
hardware-quirks from the devicetree node and transmit it to the
clocksource / clockevent init function.

Signed-off-by: Heiko Stuebner <heiko@sntech.de>
---
 drivers/clocksource/dw_apb_timer_of.c |   21 +++++++++++++++------
 1 file changed, 15 insertions(+), 6 deletions(-)

diff --git a/drivers/clocksource/dw_apb_timer_of.c b/drivers/clocksource/dw_apb_timer_of.c
index b5412af..4bcc1c1 100644
--- a/drivers/clocksource/dw_apb_timer_of.c
+++ b/drivers/clocksource/dw_apb_timer_of.c
@@ -26,7 +26,7 @@
 #include <asm/sched_clock.h>
 
 static void timer_get_base_and_rate(struct device_node *np,
-				    void __iomem **base, u32 *rate)
+				    void __iomem **base, u32 *rate, int *quirks)
 {
 	struct clk *timer_clk;
 	struct clk *pclk;
@@ -36,6 +36,8 @@ static void timer_get_base_and_rate(struct device_node *np,
 	if (!*base)
 		panic("Unable to map regs for %s", np->name);
 
+	*quirks = 0;
+
 	/*
 	 * Not all implementations use a periphal clock, so don't panic
 	 * if it's not present
@@ -66,15 +68,16 @@ static void add_clockevent(struct device_node *event_timer)
 	void __iomem *iobase;
 	struct dw_apb_clock_event_device *ced;
 	u32 irq, rate;
+	int quirks;
 
 	irq = irq_of_parse_and_map(event_timer, 0);
 	if (irq == NO_IRQ)
 		panic("No IRQ for clock event timer");
 
-	timer_get_base_and_rate(event_timer, &iobase, &rate);
+	timer_get_base_and_rate(event_timer, &iobase, &rate, &quirks);
 
 	ced = dw_apb_clockevent_init(0, event_timer->name, 300, iobase, irq,
-				     rate, 0);
+				     rate, quirks);
 	if (!ced)
 		panic("Unable to initialise clockevent device");
 
@@ -89,10 +92,12 @@ static void add_clocksource(struct device_node *source_timer)
 	void __iomem *iobase;
 	struct dw_apb_clocksource *cs;
 	u32 rate;
+	int quirks;
 
-	timer_get_base_and_rate(source_timer, &iobase, &rate);
+	timer_get_base_and_rate(source_timer, &iobase, &rate, &quirks);
 
-	cs = dw_apb_clocksource_init(300, source_timer->name, iobase, rate, 0);
+	cs = dw_apb_clocksource_init(300, source_timer->name, iobase, rate,
+				     quirks);
 	if (!cs)
 		panic("Unable to initialise clocksource device");
 
@@ -106,6 +111,9 @@ static void add_clocksource(struct device_node *source_timer)
 	 */
 	sched_io_base = iobase + 0x04;
 	sched_rate = rate;
+
+	if (quirks & APBTMR_QUIRK_64BIT_COUNTER)
+		sched_io_base += 0x04;
 }
 
 static u32 read_sched_clock(void)
@@ -122,11 +130,12 @@ static const struct of_device_id sptimer_ids[] __initconst = {
 static void init_sched_clock(void)
 {
 	struct device_node *sched_timer;
+	int quirks;
 
 	sched_timer = of_find_matching_node(NULL, sptimer_ids);
 	if (sched_timer) {
 		timer_get_base_and_rate(sched_timer, &sched_io_base,
-					&sched_rate);
+					&sched_rate, &quirks);
 		of_node_put(sched_timer);
 	}
 
-- 
1.7.10.4

