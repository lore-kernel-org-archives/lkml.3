Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753116Ab3FDJhh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Jun 2013 05:37:37 -0400
Received: from gloria.sntech.de ([95.129.55.99]:57441 "EHLO gloria.sntech.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752939Ab3FDJhN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Jun 2013 05:37:13 -0400
From: Heiko =?utf-8?q?St=C3=BCbner?= <heiko@sntech.de>
To: John Stultz <john.stultz@linaro.org>, Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH v2 1/4] clocksource: dw_apb_timer_of: enable the use the clocksource as sched clock
Date: Tue, 4 Jun 2013 11:37:02 +0200
User-Agent: KMail/1.13.7 (Linux/3.2.0-3-686-pae; KDE/4.8.4; i686; ; )
Cc: Jamie Iles <jamie@jamieiles.com>, Dinh Nguyen <dinguyen@altera.com>,
        Grant Likely <grant.likely@linaro.org>,
        linux-arm-kernel@lists.infradead.org,
        Rob Herring <rob.herring@calxeda.com>,
        devicetree-discuss@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        Arnd Bergmann <arnd@arndb.de>,
        Linus Walleij <linus.walleij@linaro.org>,
        Baruch Siach <baruch@tkos.co.il>
References: <201306041136.09566.heiko@sntech.de>
In-Reply-To: <201306041136.09566.heiko@sntech.de>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201306041137.03319.heiko@sntech.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently the dw_apb_timer always expects a separate special timer to be
availbable for the sched_clock. Some devices using dw_apb_timers do not
have this sptimer but can use the clocksource as sched_clock instead.

Therefore enable the driver to distiguish between devices with and without
sptimer based on the devicetree data and select the correct timer as
sched_clock.

Signed-off-by: Heiko Stuebner <heiko@sntech.de>
---
 drivers/clocksource/dw_apb_timer_of.c |   26 +++++++++++++++++---------
 1 files changed, 17 insertions(+), 9 deletions(-)

diff --git a/drivers/clocksource/dw_apb_timer_of.c b/drivers/clocksource/dw_apb_timer_of.c
index ab09ed3..d6c0fda 100644
--- a/drivers/clocksource/dw_apb_timer_of.c
+++ b/drivers/clocksource/dw_apb_timer_of.c
@@ -57,6 +57,9 @@ static void add_clockevent(struct device_node *event_timer)
 	dw_apb_clockevent_register(ced);
 }
 
+static void __iomem *sched_io_base;
+static u32 sched_rate;
+
 static void add_clocksource(struct device_node *source_timer)
 {
 	void __iomem *iobase;
@@ -71,9 +74,15 @@ static void add_clocksource(struct device_node *source_timer)
 
 	dw_apb_clocksource_start(cs);
 	dw_apb_clocksource_register(cs);
-}
 
-static void __iomem *sched_io_base;
+	/*
+	 * Fallback to use the clocksource as sched_clock if no separate
+	 * timer is found. sched_io_base then points to the current_value
+	 * register of the clocksource timer.
+	 */
+	sched_io_base = iobase + 0x04;
+	sched_rate = rate;
+}
 
 static u32 read_sched_clock(void)
 {
@@ -89,16 +98,15 @@ static const struct of_device_id sptimer_ids[] __initconst = {
 static void init_sched_clock(void)
 {
 	struct device_node *sched_timer;
-	u32 rate;
 
 	sched_timer = of_find_matching_node(NULL, sptimer_ids);
-	if (!sched_timer)
-		panic("No RTC for sched clock to use");
-
-	timer_get_base_and_rate(sched_timer, &sched_io_base, &rate);
-	of_node_put(sched_timer);
+	if (sched_timer) {
+		timer_get_base_and_rate(sched_timer, &sched_io_base,
+					&sched_rate);
+		of_node_put(sched_timer);
+	}
 
-	setup_sched_clock(read_sched_clock, 32, rate);
+	setup_sched_clock(read_sched_clock, 32, sched_rate);
 }
 
 static const struct of_device_id osctimer_ids[] __initconst = {
-- 
1.7.2.3

