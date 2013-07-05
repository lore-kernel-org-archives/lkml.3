Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752442Ab3GEWyT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Jul 2013 18:54:19 -0400
Received: from gloria.sntech.de ([95.129.55.99]:38022 "EHLO gloria.sntech.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751935Ab3GEWyS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Jul 2013 18:54:18 -0400
From: Heiko =?utf-8?q?St=C3=BCbner?= <heiko@sntech.de>
To: John Stultz <john.stultz@linaro.org>
Subject: [PATCH 5/9] clocksource: dw_apb_timer: quirk for variants without EOI register
Date: Sat, 6 Jul 2013 00:54:07 +0200
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
Message-Id: <201307060054.07784.heiko@sntech.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Some variants of the dw_apb_timer don't have an eoi register but instead expect a
one to be written to the int_status register at eoi time.

Signed-off-by: Ulrich Prinz <ulrich.prinz@googlemail.com>
---
 drivers/clocksource/dw_apb_timer.c |   10 +++++++++-
 include/linux/dw_apb_timer.h       |    5 +++++
 2 files changed, 14 insertions(+), 1 deletion(-)

diff --git a/drivers/clocksource/dw_apb_timer.c b/drivers/clocksource/dw_apb_timer.c
index 5f80a30..23cd7c6 100644
--- a/drivers/clocksource/dw_apb_timer.c
+++ b/drivers/clocksource/dw_apb_timer.c
@@ -104,6 +104,11 @@ static void apbt_eoi(struct dw_apb_timer *timer)
 	apbt_readl(timer, timer->reg_eoi);
 }
 
+static void apbt_eoi_int_status(struct dw_apb_timer *timer)
+{
+	apbt_writel(timer, 1, timer->reg_int_status);
+}
+
 static irqreturn_t dw_apb_clockevent_irq(int irq, void *data)
 {
 	struct clock_event_device *evt = data;
@@ -286,7 +291,10 @@ dw_apb_clockevent_init(int cpu, const char *name, unsigned rating,
 					  IRQF_NOBALANCING |
 					  IRQF_DISABLED;
 
-	dw_ced->eoi = apbt_eoi;
+	if (quirks & APBTMR_QUIRK_NO_EOI)
+		dw_ced->eoi = apbt_eoi_int_status;
+	else
+		dw_ced->eoi = apbt_eoi;
 	err = setup_irq(irq, &dw_ced->irqaction);
 	if (err) {
 		pr_err("failed to request timer irq\n");
diff --git a/include/linux/dw_apb_timer.h b/include/linux/dw_apb_timer.h
index 80f6686..fbe4c6b 100644
--- a/include/linux/dw_apb_timer.h
+++ b/include/linux/dw_apb_timer.h
@@ -25,6 +25,11 @@
  */
 #define APBTMR_QUIRK_64BIT_COUNTER	BIT(0)
 
+/* The IP does not provide a end-of-interrupt register to clear pending
+ * interrupts, but requires to write a 1 to the interrupt-status register.
+ */
+#define APBTMR_QUIRK_NO_EOI		BIT(1)
+
 struct dw_apb_timer {
 	void __iomem				*base;
 	unsigned long				freq;
-- 
1.7.10.4

