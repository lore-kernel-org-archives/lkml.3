Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757539AbaD2NRX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2014 09:17:23 -0400
Received: from mail-wi0-f175.google.com ([209.85.212.175]:37727 "EHLO
	mail-wi0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757510AbaD2NRV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2014 09:17:21 -0400
From: Daniel Lezcano <daniel.lezcano@linaro.org>
To: tglx@linutronix.de, mingo@kernel.org
Cc: Lorenzo.Pieralisi@arm.com, shc_work@mail.ru, linux-kernel@vger.kernel.org
Subject: [PATCH 1/2] clocksource: arch_arm_timer: Fix age-old arch timer C3STOP detection issue
Date: Tue, 29 Apr 2014 15:17:19 +0200
Message-Id: <1398777440-12016-1-git-send-email-daniel.lezcano@linaro.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <535FA618.6080101@linaro.org>
References: <535FA618.6080101@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>

ARM arch timers are tightly coupled with the CPU logic and lose context
on platform implementing HW power management when cores are powered
down at run-time. Marking the arch timers as C3STOP regardless of power
management capabilities causes issues on platforms with no power management,
since in that case the arch timers cannot possibly enter states where the
timer loses context at runtime and therefore can always be used as a high
resolution clockevent device.

In order to fix the C3STOP issue in a way compliant with how real HW
works, this patch adds a boolean property to the arch timer bindings
to define if the arch timer is managed by an always-on power domain.

This power domain is present on all ARM platforms to date, and manages
HW that must not be turned off, whatever the state of other HW
components (eg power controller). On platforms with no power management
capabilities, it is the only power domain present, which encompasses
and manages power supply for all HW components in the system.

If the timer is powered by the always-on power domain, the always-on
property must be present in the bindings which means that the timer cannot
be shutdown at runtime, so it is not a C3STOP clockevent device.
If the timer binding does not contain the always-on property, the timer is
assumed to be power-gateable, hence it must be defined as a C3STOP
clockevent device.

Cc: Daniel Lezcano <daniel.lezcano@linaro.org>
Cc: Magnus Damm <damm@opensource.se>
Cc: Marc Carino <marc.ceeeee@gmail.com>
Cc: Mark Rutland <mark.rutland@arm.com>
Acked-by: Marc Zyngier <marc.zyngier@arm.com>
Acked-by: Rob Herring <robh@kernel.org>
Signed-off-by: Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>
Signed-off-by: Daniel Lezcano <daniel.lezcano@linaro.org>
---
 .../devicetree/bindings/arm/arch_timer.txt         |    3 +++
 drivers/clocksource/arm_arch_timer.c               |    6 +++++-
 2 files changed, 8 insertions(+), 1 deletion(-)

diff --git a/Documentation/devicetree/bindings/arm/arch_timer.txt b/Documentation/devicetree/bindings/arm/arch_timer.txt
index 06fc760..37b2caf 100644
--- a/Documentation/devicetree/bindings/arm/arch_timer.txt
+++ b/Documentation/devicetree/bindings/arm/arch_timer.txt
@@ -19,6 +19,9 @@ to deliver its interrupts via SPIs.
 
 - clock-frequency : The frequency of the main counter, in Hz. Optional.
 
+- always-on : a boolean property. If present, the timer is powered through an
+  always-on power domain, therefore it never loses context.
+
 Example:
 
 	timer {
diff --git a/drivers/clocksource/arm_arch_timer.c b/drivers/clocksource/arm_arch_timer.c
index 57e823c..5163ec1 100644
--- a/drivers/clocksource/arm_arch_timer.c
+++ b/drivers/clocksource/arm_arch_timer.c
@@ -66,6 +66,7 @@ static int arch_timer_ppi[MAX_TIMER_PPI];
 static struct clock_event_device __percpu *arch_timer_evt;
 
 static bool arch_timer_use_virtual = true;
+static bool arch_timer_c3stop;
 static bool arch_timer_mem_use_virtual;
 
 /*
@@ -263,7 +264,8 @@ static void __arch_timer_setup(unsigned type,
 	clk->features = CLOCK_EVT_FEAT_ONESHOT;
 
 	if (type == ARCH_CP15_TIMER) {
-		clk->features |= CLOCK_EVT_FEAT_C3STOP;
+		if (arch_timer_c3stop)
+			clk->features |= CLOCK_EVT_FEAT_C3STOP;
 		clk->name = "arch_sys_timer";
 		clk->rating = 450;
 		clk->cpumask = cpumask_of(smp_processor_id());
@@ -665,6 +667,8 @@ static void __init arch_timer_init(struct device_node *np)
 		}
 	}
 
+	arch_timer_c3stop = !of_property_read_bool(np, "always-on");
+
 	arch_timer_register();
 	arch_timer_common_init();
 }
-- 
1.7.9.5

