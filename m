Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757648Ab3EWIkL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 May 2013 04:40:11 -0400
Received: from mail-lb0-f178.google.com ([209.85.217.178]:49438 "EHLO
	mail-lb0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755408Ab3EWIja (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 May 2013 04:39:30 -0400
From: Johan Hovold <jhovold@gmail.com>
To: Nicolas Ferre <nicolas.ferre@atmel.com>
Cc: Douglas Gilbert <dgilbert@interlog.com>,
        Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>,
        Ludovic Desroches <ludovic.desroches@atmel.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Robert Nelson <Robert.Nelson@digikey.com>,
        Johan Hovold <jhovold@gmail.com>
Subject: [PATCH v3 4/5] rtc-at91rm9200: add shadow interrupt mask
Date: Thu, 23 May 2013 10:38:54 +0200
Message-Id: <1369298335-24597-5-git-send-email-jhovold@gmail.com>
X-Mailer: git-send-email 1.8.2.1
In-Reply-To: <1369298335-24597-1-git-send-email-jhovold@gmail.com>
References: <1364983415-20298-1-git-send-email-jhovold@gmail.com>
 <1369298335-24597-1-git-send-email-jhovold@gmail.com>
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

Signed-off-by: Johan Hovold <jhovold@gmail.com>
---
 drivers/rtc/rtc-at91rm9200.c | 39 ++++++++++++++++++++++++++++++++++++++-
 1 file changed, 38 insertions(+), 1 deletion(-)

diff --git a/drivers/rtc/rtc-at91rm9200.c b/drivers/rtc/rtc-at91rm9200.c
index 9592d08..205701e 100644
--- a/drivers/rtc/rtc-at91rm9200.c
+++ b/drivers/rtc/rtc-at91rm9200.c
@@ -30,6 +30,7 @@
 #include <linux/io.h>
 #include <linux/of.h>
 #include <linux/of_device.h>
+#include <linux/spinlock.h>
 
 #include <asm/uaccess.h>
 
@@ -43,6 +44,7 @@
 #define AT91_RTC_EPOCH		1900UL	/* just like arch/arm/common/rtctime.c */
 
 struct at91_rtc_config {
+	bool use_shadow_imr;
 };
 
 static const struct at91_rtc_config *at91_rtc_config;
@@ -50,20 +52,55 @@ static DECLARE_COMPLETION(at91_rtc_updated);
 static unsigned int at91_alarm_year = AT91_RTC_EPOCH;
 static void __iomem *at91_rtc_regs;
 static int irq;
+static DEFINE_SPINLOCK(at91_rtc_lock);
+static u32 at91_rtc_shadow_imr;
 
 static void at91_rtc_write_ier(u32 mask)
 {
+	unsigned long flags;
+
+	spin_lock_irqsave(&at91_rtc_lock, flags);
+	at91_rtc_shadow_imr |= mask;
 	at91_rtc_write(AT91_RTC_IER, mask);
+	spin_unlock_irqrestore(&at91_rtc_lock, flags);
 }
 
 static void at91_rtc_write_idr(u32 mask)
 {
+	unsigned long flags;
+
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
1.8.2.1

