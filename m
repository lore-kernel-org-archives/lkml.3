Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932164Ab3DBNG4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Apr 2013 09:06:56 -0400
Received: from eusmtp01.atmel.com ([212.144.249.243]:30752 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755411Ab3DBNGz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Apr 2013 09:06:55 -0400
From: Nicolas Ferre <nicolas.ferre@atmel.com>
To: <linux-arm-kernel@lists.infradead.org>, <jhovold@gmail.com>,
        <dgilbert@interlog.com>
CC: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>,
        Ludovic Desroches <ludovic.desroches@atmel.com>,
        <linux-kernel@vger.kernel.org>,
        Nicolas Ferre <nicolas.ferre@atmel.com>
Subject: [RFC PATCH] rtc: rtc-at91rm9200: manage IMR depending on revision
Date: Tue, 2 Apr 2013 15:06:47 +0200
Message-ID: <1364908007-5150-1-git-send-email-nicolas.ferre@atmel.com>
X-Mailer: git-send-email 1.8.0
In-Reply-To: <1364573029-19346-5-git-send-email-jhovold@gmail.com>
References: <1364573029-19346-5-git-send-email-jhovold@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Nicolas Ferre <nicolas.ferre@atmel.com>
---
Hi all,

The funny thing is that I was writing exactly the same code as Johan's
when he posted his series.

So, here is my single patch, with the comment about the readback stolen from
Johan's, but without the way to determine with IP is buggy and which one is
not...
After having dug the possibility to read the IP revision, I discovered that it
is not possible to use this information ("version" register offset changing
according to... IP version number: well done!).
In conclusion, I guess that the only way to determine if we need the workaround
is to use the DT.
One remark though: if we use the compatibility string for this purpose, I fear
that we would twist the meaning of this information: SoC using an
"atmel,at91sam9x5-rtc" compatible RTC will not necessarily be touched by the
"non responding IMR" bug: at91sam9n12 or upcoming sama5d3 are not affected for
instance, and we need to cling to "atmel,at91rm9200-rtc" for them...
I think that we can use this method for the moment and move to another
compatibility string later if it is needed.

Thanks for your help, best regards.

 drivers/rtc/rtc-at91rm9200.c | 75 ++++++++++++++++++++++++++++++++++++++++++++
 drivers/rtc/rtc-at91rm9200.h |  1 +
 2 files changed, 76 insertions(+)

diff --git a/drivers/rtc/rtc-at91rm9200.c b/drivers/rtc/rtc-at91rm9200.c
index 29b92e4..4960d42 100644
--- a/drivers/rtc/rtc-at91rm9200.c
+++ b/drivers/rtc/rtc-at91rm9200.c
@@ -25,6 +25,7 @@
 #include <linux/rtc.h>
 #include <linux/bcd.h>
 #include <linux/interrupt.h>
+#include <linux/spinlock.h>
 #include <linux/ioctl.h>
 #include <linux/completion.h>
 #include <linux/io.h>
@@ -47,6 +48,74 @@ static unsigned int at91_alarm_year = AT91_RTC_EPOCH;
 static void __iomem *at91_rtc_regs;
 static int irq;
 static u32 at91_rtc_imr;
+static DEFINE_SPINLOCK(lock);
+static void (*at91_rtc_set_irq)(u32 irq_mask);
+static void (*at91_rtc_clear_irq)(u32 irq_mask);
+static u32 (*at91_rtc_read_imr)(void);
+
+static inline unsigned int at91_rtc_get_version(void)
+{
+	return at91_rtc_read(AT91_RTC_VERSION) & 0x00000fff;
+}
+
+static void at91_rtc_set_irq_simple(u32 irq_mask)
+{
+	at91_rtc_write(AT91_RTC_IER, irq_mask);
+}
+
+static void at91_rtc_clear_irq_simple(u32 irq_mask)
+{
+	at91_rtc_write(AT91_RTC_IDR, irq_mask);
+}
+
+static u32 at91_rtc_read_imr_simple(void)
+{
+	return at91_rtc_read(AT91_RTC_IMR);
+}
+
+static void at91_rtc_set_irq_brokenimr(u32 irq_mask)
+{
+	unsigned long flags;
+
+	spin_lock_irqsave(&lock, flags);
+	at91_rtc_imr |= irq_mask;
+	at91_rtc_write(AT91_RTC_IER, irq_mask);
+	spin_unlock_irqrestore(&lock, flags);
+}
+
+static void at91_rtc_clear_irq_brokenimr(u32 irq_mask)
+{
+	unsigned long flags;
+
+	spin_lock_irqsave(&lock, flags);
+	at91_rtc_write(AT91_RTC_IDR, irq_mask);
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
+	at91_rtc_imr &= ~irq_mask;
+	spin_unlock_irqrestore(&lock, flags);
+}
+
+static u32 at91_rtc_read_imr_brokenimr(void)
+{
+	unsigned long flags;
+	u32 shadow_imr;
+
+	spin_lock_irqsave(&lock, flags);
+	shadow_imr = at91_rtc_imr;
+	spin_unlock_irqrestore(&lock, flags);
+
+	return shadow_imr;
+}
 
 /*
  * Decode time/date into rtc_time structure
@@ -300,6 +369,12 @@ static int __init at91_rtc_probe(struct platform_device *pdev)
 					AT91_RTC_SECEV | AT91_RTC_TIMEV |
 					AT91_RTC_CALEV);
 	at91_rtc_imr = 0;
+	spin_lock_init(&lock);
+
+	/* Choose IMR access functions */
+	at91_rtc_set_irq = at91_rtc_set_irq_simple;
+	at91_rtc_clear_irq = at91_rtc_clear_irq_simple;
+	at91_rtc_read_imr = at91_rtc_read_imr_simple;
 
 	ret = request_irq(irq, at91_rtc_interrupt,
 				IRQF_SHARED,
diff --git a/drivers/rtc/rtc-at91rm9200.h b/drivers/rtc/rtc-at91rm9200.h
index 5f940b6..da1945e 100644
--- a/drivers/rtc/rtc-at91rm9200.h
+++ b/drivers/rtc/rtc-at91rm9200.h
@@ -64,6 +64,7 @@
 #define	AT91_RTC_SCCR		0x1c			/* Status Clear Command Register */
 #define	AT91_RTC_IER		0x20			/* Interrupt Enable Register */
 #define	AT91_RTC_IDR		0x24			/* Interrupt Disable Register */
+#define	AT91_RTC_IMR		0x28			/* Interrupt Mask Register */
 
 #define	AT91_RTC_VER		0x2c			/* Valid Entry Register */
 #define		AT91_RTC_NVTIM		(1 <<  0)		/* Non valid Time */
-- 
1.8.0

