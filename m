Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753290AbaJTTFK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Oct 2014 15:05:10 -0400
Received: from mail-oi0-f73.google.com ([209.85.218.73]:61781 "EHLO
	mail-oi0-f73.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751040AbaJTTEQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Oct 2014 15:04:16 -0400
From: Andrew Bresticker <abrestic@chromium.org>
To: Ralf Baechle <ralf@linux-mips.org>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Jason Cooper <jason@lakedaemon.net>
Cc: Andrew Bresticker <abrestic@chromium.org>,
        Paul Burton <paul.burton@imgtec.com>,
        Qais Yousef <qais.yousef@imgtec.com>,
        John Crispin <blogic@openwrt.org>, linux-mips@linux-mips.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 16/19] clocksource: mips-gic: Use percpu_dev_id
Date: Mon, 20 Oct 2014 12:04:03 -0700
Message-Id: <1413831846-32100-17-git-send-email-abrestic@chromium.org>
X-Mailer: git-send-email 2.1.0.rc2.206.gedb03e5
In-Reply-To: <1413831846-32100-1-git-send-email-abrestic@chromium.org>
References: <1413831846-32100-1-git-send-email-abrestic@chromium.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since the GIC timer IRQ is a percpu IRQ, we can use percpu_dev_id
to pass the IRQ handler the correct clock_event_device.

Signed-off-by: Andrew Bresticker <abrestic@chromium.org>
---
 drivers/clocksource/mips-gic-timer.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/clocksource/mips-gic-timer.c b/drivers/clocksource/mips-gic-timer.c
index 763aa1c..05bdfe1 100644
--- a/drivers/clocksource/mips-gic-timer.c
+++ b/drivers/clocksource/mips-gic-timer.c
@@ -39,17 +39,16 @@ static void gic_set_clock_mode(enum clock_event_mode mode,
 
 static irqreturn_t gic_compare_interrupt(int irq, void *dev_id)
 {
-	struct clock_event_device *cd;
-	int cpu = smp_processor_id();
+	struct clock_event_device *cd = dev_id;
 
 	gic_write_compare(gic_read_compare());
-	cd = &per_cpu(gic_clockevent_device, cpu);
 	cd->event_handler(cd);
 	return IRQ_HANDLED;
 }
 
 struct irqaction gic_compare_irqaction = {
 	.handler = gic_compare_interrupt,
+	.percpu_dev_id = &gic_clockevent_device,
 	.flags = IRQF_PERCPU | IRQF_TIMER,
 	.name = "timer",
 };
-- 
2.1.0.rc2.206.gedb03e5

