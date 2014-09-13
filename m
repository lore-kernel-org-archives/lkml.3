Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751499AbaIMLUC (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Sep 2014 07:20:02 -0400
Received: from galahad.ideasonboard.com ([185.26.127.97]:36354 "EHLO
	galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751136AbaIMLUA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Sep 2014 07:20:00 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: linux-kernel@vger.kernel.org
Cc: rtc-linux@googlegroups.com, "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Thomas Gleixner <tglx@linutronix.de>,
        laurent.pinchart@ideasonboard.com
Subject: [PATCH/RFC] rtc: rtc-twl: Fixed nested IRQ handling in resume from suspend
Date: Sat, 13 Sep 2014 14:19:56 +0300
Message-Id: <1410607196-3941-1-git-send-email-laurent.pinchart@ideasonboard.com>
X-Mailer: git-send-email 1.8.5.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The TWL RTC interrupt is a double-nested threaded interrupt, handled
through the TWL SIH (Secondary Interrupt Handler) and PIH (Primary
Interrupt Handler).

When the system is woken up from suspend by a TWL RTC alarm interrupt,
the TWL PIH and SIH are enabled first (due to the normal IRQ enabling
sequence for the PIH and to the IRQF_EARLY_RESUME flag for the SIH)
before the TWL RTC interrupt gets enabled. This results on the interrupt
being processed by the TWL primary interrupt handler, forwarded to the
nested SIH, and then marked as pending for the RTC by handle_nested_irq
called from the SIH.

The RTC interrupt then eventually gets reenabled the kernel, which will
try to call its top half interrupt handler. As the interrupt is a nested
threaded IRQ, its primary handler has been set to the
irq_nested_primary_handler function, which is never supposed to be
called and generates a WARN_ON, without waking the IRQ thread up.

Fix this by setting the IRQF_EARLY_RESUME for the TWL RTC interrupt to
ensure it gets enabled before the parent handlers try to process it.

This is likely a bit of a hack, I have a feeling that a more generic
solution that would fix the problem for all nested threaded IRQs enabled
as a wake up source by enable_irq_wake would be better.

I've noticed that Rafael's "PM / sleep / irq: Do not suspend wakeup
interrupts" patch (which has been reverted) might be related, but it
resulted in an endless stream of I2C errors in the kernel log at resume
time:

[  189.730682] twl4030: I2C error -13 reading PIH ISR
[  189.730712] twl: Read failed (mod 1, reg 0x01 count 1)

Given that I'm not that familiar with the IRQ subsystem I would
appreciate some guidance on how to properly solve the problem.

Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
---
 drivers/rtc/rtc-twl.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/rtc/rtc-twl.c b/drivers/rtc/rtc-twl.c
index 1915464..3155af1 100644
--- a/drivers/rtc/rtc-twl.c
+++ b/drivers/rtc/rtc-twl.c
@@ -536,7 +536,8 @@ static int twl_rtc_probe(struct platform_device *pdev)
 
 	ret = devm_request_threaded_irq(&pdev->dev, irq, NULL,
 					twl_rtc_interrupt,
-					IRQF_TRIGGER_RISING | IRQF_ONESHOT,
+					IRQF_TRIGGER_RISING | IRQF_ONESHOT |
+					IRQF_EARLY_RESUME,
 					dev_name(&rtc->dev), rtc);
 	if (ret < 0) {
 		dev_err(&pdev->dev, "IRQ is not free.\n");
-- 
Regards,

Laurent Pinchart

