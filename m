Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751310AbaKFR5h (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Nov 2014 12:57:37 -0500
Received: from mail-pd0-f201.google.com ([209.85.192.201]:62706 "EHLO
	mail-pd0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751046AbaKFR5c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Nov 2014 12:57:32 -0500
From: Anatol Pomozov <anatol.pomozov@gmail.com>
To: daniel.lezcano@linaro.org, lorenzo.pieralisi@arm.com
Cc: tglx@linutronix.de, linux-kernel@vger.kernel.org,
        Anatol Pomozov <anatol.pomozov@gmail.com>
Subject: [PATCH] clocksource: arch_timer: Mark ARMv8 system timer as 'always-on'
Date: Thu,  6 Nov 2014 09:57:19 -0800
Message-Id: <1415296639-40203-1-git-send-email-anatol.pomozov@gmail.com>
X-Mailer: git-send-email 2.1.0.rc2.206.gedb03e5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting ARMv8 Reference Manual section D6.1:
"The system counter must be implemented in an always-on power domain."

There is no need to keep 'always-on' configurable on ARMv8. We ignore
this dts property value and unconditionally set it to true.

The issue was discovered while working on ARMv8 board with only one timer
(arm arch timer). If 'always-on' is false then it disables high-resolution
timer functionality.

Signed-off-by: Anatol Pomozov <anatol.pomozov@gmail.com>
---
 .../devicetree/bindings/arm/arch_timer.txt          |  8 ++++++--
 drivers/clocksource/arm_arch_timer.c                | 21 +++++++++++++++++----
 2 files changed, 23 insertions(+), 6 deletions(-)

diff --git a/Documentation/devicetree/bindings/arm/arch_timer.txt b/Documentation/devicetree/bindings/arm/arch_timer.txt
index 37b2caf..cb2d572 100644
--- a/Documentation/devicetree/bindings/arm/arch_timer.txt
+++ b/Documentation/devicetree/bindings/arm/arch_timer.txt
@@ -19,8 +19,12 @@ to deliver its interrupts via SPIs.
 
 - clock-frequency : The frequency of the main counter, in Hz. Optional.
 
-- always-on : a boolean property. If present, the timer is powered through an
-  always-on power domain, therefore it never loses context.
+- always-on : an "armv7-timer" specific boolean property.
+  If present, the timer is powered through an always-on power domain, therefore
+  it never loses context.
+  ARMv8 system timer is in always-on power domain (per Architecture Reference
+  section D6.1) thus this proprty is ignored for "arm,armv8-timer" compatible
+  timer.
 
 Example:
 
diff --git a/drivers/clocksource/arm_arch_timer.c b/drivers/clocksource/arm_arch_timer.c
index 2133f9d..610052d 100644
--- a/drivers/clocksource/arm_arch_timer.c
+++ b/drivers/clocksource/arm_arch_timer.c
@@ -719,13 +719,26 @@ static void __init arch_timer_init(struct device_node *np)
 		}
 	}
 
-	arch_timer_c3stop = !of_property_read_bool(np, "always-on");
-
 	arch_timer_register();
 	arch_timer_common_init();
 }
-CLOCKSOURCE_OF_DECLARE(armv7_arch_timer, "arm,armv7-timer", arch_timer_init);
-CLOCKSOURCE_OF_DECLARE(armv8_arch_timer, "arm,armv8-timer", arch_timer_init);
+
+static void __init v7_arch_timer_init(struct device_node *np)
+{
+	arch_timer_c3stop = !of_property_read_bool(np, "always-on");
+	arch_timer_init(np);
+}
+
+static void __init v8_arch_timer_init(struct device_node *np)
+{
+	/* Per ARMv8 Architecture Reference Manual section D6.1
+	 * the system timer is in always-on power domain.
+	 */
+	arch_timer_c3stop = false;
+	arch_timer_init(np);
+}
+CLOCKSOURCE_OF_DECLARE(armv7_arch_timer, "arm,armv7-timer", v7_arch_timer_init);
+CLOCKSOURCE_OF_DECLARE(armv8_arch_timer, "arm,armv8-timer", v8_arch_timer_init);
 
 static void __init arch_timer_mem_init(struct device_node *np)
 {
-- 
2.1.0.rc2.206.gedb03e5

