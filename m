Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933696Ab3JPKBK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Oct 2013 06:01:10 -0400
Received: from mail-lb0-f169.google.com ([209.85.217.169]:45387 "EHLO
	mail-lb0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760229Ab3JPKAl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Oct 2013 06:00:41 -0400
From: Johan Hovold <jhovold@gmail.com>
To: Nicolas Ferre <nicolas.ferre@atmel.com>
Cc: Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Andrew Victor <linux@maxim.org.za>,
        Alessandro Zummo <a.zummo@towertech.it>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        rtc-linux@googlegroups.com, Johan Hovold <jhovold@gmail.com>
Subject: [PATCH v3 3/3] ARM: at91/rtc: disable interrupts at shutdown
Date: Wed, 16 Oct 2013 11:56:16 +0200
Message-Id: <1381917376-21107-4-git-send-email-jhovold@gmail.com>
X-Mailer: git-send-email 1.8.4
In-Reply-To: <1381917376-21107-1-git-send-email-jhovold@gmail.com>
References: <1363025279-17615-1-git-send-email-jhovold@gmail.com>
 <1381917376-21107-1-git-send-email-jhovold@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Make sure RTC-interrupts are disabled at shutdown.

As the RTC is generally powered by backup power (VDDBU), its interrupts
are not disabled on wake-up, user, watchdog or software reset. This
could cause troubles on other systems (e.g. older kernels) if an
interrupt occurs before a handler has been installed at next boot.

Let us be well-behaved and disable them on clean shutdowns at least (as
do the RTT-based rtc-at91sam9 driver).

Signed-off-by: Johan Hovold <jhovold@gmail.com>
---
 drivers/rtc/rtc-at91rm9200.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/drivers/rtc/rtc-at91rm9200.c b/drivers/rtc/rtc-at91rm9200.c
index 7418926..ea088e9 100644
--- a/drivers/rtc/rtc-at91rm9200.c
+++ b/drivers/rtc/rtc-at91rm9200.c
@@ -442,6 +442,14 @@ static int __exit at91_rtc_remove(struct platform_device *pdev)
 	return 0;
 }
 
+static void at91_rtc_shutdown(struct platform_device *pdev)
+{
+	/* Disable all interrupts */
+	at91_rtc_write(AT91_RTC_IDR, AT91_RTC_ACKUPD | AT91_RTC_ALARM |
+					AT91_RTC_SECEV | AT91_RTC_TIMEV |
+					AT91_RTC_CALEV);
+}
+
 #ifdef CONFIG_PM_SLEEP
 
 /* AT91RM9200 RTC Power management control */
@@ -480,6 +488,7 @@ static SIMPLE_DEV_PM_OPS(at91_rtc_pm_ops, at91_rtc_suspend, at91_rtc_resume);
 
 static struct platform_driver at91_rtc_driver = {
 	.remove		= __exit_p(at91_rtc_remove),
+	.shutdown	= at91_rtc_shutdown,
 	.driver		= {
 		.name	= "at91_rtc",
 		.owner	= THIS_MODULE,
-- 
1.8.4

