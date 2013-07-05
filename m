Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752466Ab3GEWzm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Jul 2013 18:55:42 -0400
Received: from gloria.sntech.de ([95.129.55.99]:38082 "EHLO gloria.sntech.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752190Ab3GEWzl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Jul 2013 18:55:41 -0400
From: Heiko =?utf-8?q?St=C3=BCbner?= <heiko@sntech.de>
To: John Stultz <john.stultz@linaro.org>
Subject: [PATCH 7/9] clocksource: dw_apb_timer: quirk for inverted timer mode setting
Date: Sat, 6 Jul 2013 00:55:31 +0200
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
Message-Id: <201307060055.31882.heiko@sntech.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ulrich Prinz <ulrich.prinz@googlemail.com>

Some variants of SOCs using dw_apb_timer have inverted logic for the
bit that sets one-shot / periodic mode or free running timer. This
commit adds the new APBTMR_QUIRK_INVERSE_PERIODIC.

Signed-off-by: Ulrich Prinz <ulrich.prinz@googlemail.com>
---
 drivers/clocksource/dw_apb_timer.c |   11 +++++++++--
 include/linux/dw_apb_timer.h       |    6 ++++++
 2 files changed, 15 insertions(+), 2 deletions(-)

diff --git a/drivers/clocksource/dw_apb_timer.c 
b/drivers/clocksource/dw_apb_timer.c
index 7705d13..a2e8306 100644
--- a/drivers/clocksource/dw_apb_timer.c
+++ b/drivers/clocksource/dw_apb_timer.c
@@ -159,7 +159,11 @@ static void apbt_set_mode(enum clock_event_mode mode,
 	case CLOCK_EVT_MODE_PERIODIC:
 		period = DIV_ROUND_UP(timer->freq, HZ);
 		ctrl = apbt_readl(timer, timer->reg_control);
-		ctrl |= APBTMR_CONTROL_MODE_PERIODIC;
+
+		if (timer->quirks & APBTMR_QUIRK_INVERSE_PERIODIC)
+			ctrl &= ~APBTMR_CONTROL_MODE_PERIODIC;
+		else
+			ctrl |= APBTMR_CONTROL_MODE_PERIODIC;
 		apbt_writel(timer, ctrl, timer->reg_control);
 		/*
 		 * DW APB p. 46, have to disable timer before load counter,
@@ -186,7 +190,10 @@ static void apbt_set_mode(enum clock_event_mode mode,
 		 * the next event, therefore emulate the one-shot mode.
 		 */
 		ctrl &= ~APBTMR_CONTROL_ENABLE;
-		ctrl &= ~APBTMR_CONTROL_MODE_PERIODIC;
+		if (timer->quirks & APBTMR_QUIRK_INVERSE_PERIODIC)
+			ctrl |= APBTMR_CONTROL_MODE_PERIODIC;
+		else
+			ctrl &= ~APBTMR_CONTROL_MODE_PERIODIC;
 
 		apbt_writel(timer, ctrl, timer->reg_control);
 		/* write again to set free running mode */
diff --git a/include/linux/dw_apb_timer.h b/include/linux/dw_apb_timer.h
index 7d36d91..5d9210cc 100644
--- a/include/linux/dw_apb_timer.h
+++ b/include/linux/dw_apb_timer.h
@@ -36,6 +36,12 @@
  */
 #define APBTMR_QUIRK_INVERSE_INTMASK	BIT(2)
 
+/* The IP uses inverted logic for the bit setting periodic mode.
+ * Periodic means it times out after the period is over and is set to
+ * 1 in the original IP. This IP uses 1 for free running mode.
+ */
+#define APBTMR_QUIRK_INVERSE_PERIODIC	BIT(3)
+
 struct dw_apb_timer {
 	void __iomem				*base;
 	unsigned long				freq;
-- 
1.7.10.4

