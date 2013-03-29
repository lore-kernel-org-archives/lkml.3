Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754962Ab3C2QFq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Mar 2013 12:05:46 -0400
Received: from mail-lb0-f174.google.com ([209.85.217.174]:42767 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753603Ab3C2QEy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Mar 2013 12:04:54 -0400
From: Johan Hovold <jhovold@gmail.com>
To: Nicolas Ferre <nicolas.ferre@atmel.com>
Cc: Douglas Gilbert <dgilbert@interlog.com>,
        Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>,
        Ludovic Desroches <ludovic.desroches@atmel.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Johan Hovold <jhovold@gmail.com>
Subject: [RFC 4/5] rtc-at91rm9200: add shadow interrupt mask
Date: Fri, 29 Mar 2013 17:03:48 +0100
Message-Id: <1364573029-19346-4-git-send-email-jhovold@gmail.com>
X-Mailer: git-send-email 1.8.1.5
In-Reply-To: <1364573029-19346-1-git-send-email-jhovold@gmail.com>
References: <1364573029-19346-1-git-send-email-jhovold@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add shadow interrupt-mask register which can be used on SoCs where the
actual hardware register is broken.

Note that some care needs to be taken to make sure the shadow mask
corresponds to the actual hardware state. The added overhead is not an
issue for the non-broken SoCs due to the relatively infrequent
interrupt-mask updates. We do, however, only use the shadow mask value
as a fall-back when it actually needed as there is still a theoretical
possibility that the mask is incorrect (see the code for details).
---
 drivers/rtc/rtc-at91rm9200.c | 49 +++++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 48 insertions(+), 1 deletion(-)

diff --git a/drivers/rtc/rtc-at91rm9200.c b/drivers/rtc/rtc-at91rm9200.c
index cb4462d..2921866 100644
--- a/drivers/rtc/rtc-at91rm9200.c
+++ b/drivers/rtc/rtc-at91rm9200.c
@@ -42,6 +42,7 @@
 #define AT91_RTC_EPOCH		1900UL	/* just like arch/arm/common/rtctime.c */
 
 struct at91_rtc_config {
+	bool use_shadow_imr;
 };
 
 static const struct at91_rtc_config *at91_rtc_config;
@@ -49,20 +50,66 @@ static DECLARE_COMPLETION(at91_rtc_updated);
 static unsigned int at91_alarm_year = AT91_RTC_EPOCH;
 static void __iomem *at91_rtc_regs;
 static int irq;
+static DEFINE_SPINLOCK(at91_rtc_lock);
+static u32 at91_rtc_shadow_imr;
 
 static void at91_rtc_write_ier(u32 mask)
 {
+	unsigned long flags;
+
+	/*
+	 * Lock needed to make sure shadow mask is updated before interrupts
+	 * are enabled.
+	 */
+	spin_lock_irqsave(&at91_rtc_lock, flags);
+	at91_rtc_shadow_imr |= mask;
 	at91_rtc_write(AT91_RTC_IER, mask);
+	spin_unlock_irqrestore(&at91_rtc_lock, flags);
 }
 
 static void at91_rtc_write_idr(u32 mask)
 {
+	unsigned long flags;
+
+	/*
+	 * Lock needed to make sure shadow mask is not updated before
+	 * interrupts have been disabled.
+	 */
+	spin_lock_irqsave(&at91_rtc_lock, flags);
 	at91_rtc_write(AT91_RTC_IDR, mask);
+	/*
+	 * Register read back (of any RTC-register) needed to make sure
+	 * IDR-register write has reached the peripheral before updating
+	 * shadow mask.
+	 *
+	 * Note that there is still a possibility that the mask is updated
+	 * before interrupts have actually been disabled in hardware. The only
+	 * way to be certain would be to poll the IMR-register, which is is
+	 * the very register we are trying to emulate. The register read back
+	 * is a reasonable heuristic.
+	 */
+	at91_rtc_read(AT91_RTC_SR);
+	at91_rtc_shadow_imr &= ~mask;
+	spin_unlock_irqrestore(&at91_rtc_lock, flags);
 }
 
 static u32 at91_rtc_read_imr(void)
 {
-	return at91_rtc_read(AT91_RTC_IMR);
+	unsigned long flags;
+	u32 mask;
+
+	if (at91_rtc_config->use_shadow_imr) {
+		/*
+		 * Lock not strictly necessary on UP.
+		 */
+		spin_lock_irqsave(&at91_rtc_lock, flags);
+		mask = at91_rtc_shadow_imr;
+		spin_unlock_irqrestore(&at91_rtc_lock, flags);
+	} else {
+		mask = at91_rtc_read(AT91_RTC_IMR);
+	}
+
+	return mask;
 }
 
 /*
-- 
1.8.1.5

