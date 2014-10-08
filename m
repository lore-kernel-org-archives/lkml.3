Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754497AbaJHHdy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Oct 2014 03:33:54 -0400
Received: from mail-pd0-f201.google.com ([209.85.192.201]:65282 "EHLO
	mail-pd0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754170AbaJHHdw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Oct 2014 03:33:52 -0400
From: Sonny Rao <sonnyrao@chromium.org>
To: linux-arm-kernel@lists.infradead.org
Cc: devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        Doug Anderson <dianders@chromium.org>,
        Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
        Olof Johansson <olof@lixom.net>, Thomas Gleixner <tglx@linutronix.de>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Will Deacon <will.deacon@arm.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Sudeep Holla <Sudeep.Holla@arm.com>,
        Mark Rutland <Mark.Rutland@arm.com>,
        Stephen Boyd <sboyd@codeaurora.org>,
        Marc Zyngier <marc.zyngier@arm.com>, pawel.moll@arm.com,
        ijc+devicetree@hellion.org.uk, galak@codeaurora.org,
        Nathan Lynch <Nathan_Lynch@mentor.com>, robh+dt@kernel.org,
        Sonny Rao <sonnyrao@chromium.org>
Subject: [PATCH v4] clocksource: arch_timer: Allow the device tree to specify uninitialized timer registers
Date: Wed,  8 Oct 2014 00:33:47 -0700
Message-Id: <1412753627-28287-1-git-send-email-sonnyrao@chromium.org>
X-Mailer: git-send-email 2.1.0.rc2.206.gedb03e5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Doug Anderson <dianders@chromium.org>

Some 32-bit (ARMv7) systems are architected like this:

* The firmware doesn't know and doesn't care about hypervisor mode and
  we don't want to add the complexity of hypervisor there.

* The firmware isn't involved in SMP bringup or resume.

* The ARCH timer come up with an uninitialized offset (CNTVOFF)
  between the virtual and physical counters.  Each core gets a
  different random offset.

* The device boots in "Secure SVC" mode.

* Nothing has touched the reset value of CNTHCTL.PL1PCEN or
  CNTHCTL.PL1PCTEN (both default to 1 at reset)

On systems like the above, it doesn't make sense to use the virtual
counter.  There's nobody managing the offset and each time a core goes
down and comes back up it will get reinitialized to some other random
value.

This adds an optional property which can inform the kernel of this
situation, and firmware is free to remove the property if it is going
to initialize the CNTVOFF registers when each CPU comes out of reset.

Currently, the best course of action in this case is to use the
physical timer, which is why it is important that CNTHCTL hasn't been
changed from its reset value and it's a reasonable assumption given
that the firmware has never entered HYP mode.

Note that it's been said that on ARMv8 systems the firmware and
kernel really can't be architected as described above.  That means
using the physical timer like this really only makes sense for ARMv7
systems.

Signed-off-by: Doug Anderson <dianders@chromium.org>
Signed-off-by: Sonny Rao <sonnyrao@chromium.org>
Reviewed-by: Mark Rutland <mark.rutland@arm.com>
---
Changes in v2:
- Add "#ifdef CONFIG_ARM" as per Will Deacon

Changes in v3:
- change property name to arm,cntvoff-not-fw-configured and specify
  that the value of CNTHCTL.PL1PC(T)EN must still be the reset value
  of 1 as per Mark Rutland

Changes in v4:
- change property name to arm,cpu-registers-not-fw-configured and
  specify that all cpu registers must have architected reset values
  per Mark Rutland
- change from "#ifdef CONFIG_ARM" to "if (IS_ENABLED(CONFIG_ARM))" per
  Arnd Bergmann
---
 Documentation/devicetree/bindings/arm/arch_timer.txt | 8 ++++++++
 drivers/clocksource/arm_arch_timer.c                 | 8 ++++++++
 2 files changed, 16 insertions(+)

diff --git a/Documentation/devicetree/bindings/arm/arch_timer.txt b/Documentation/devicetree/bindings/arm/arch_timer.txt
index 37b2caf..256b4d8 100644
--- a/Documentation/devicetree/bindings/arm/arch_timer.txt
+++ b/Documentation/devicetree/bindings/arm/arch_timer.txt
@@ -22,6 +22,14 @@ to deliver its interrupts via SPIs.
 - always-on : a boolean property. If present, the timer is powered through an
   always-on power domain, therefore it never loses context.
 
+** Optional properties:
+
+- arm,cpu-registers-not-fw-configured : Firmware does not initialize
+  any of the generic timer CPU registers, which contain their
+  architecturally-defined reset values. Only supported for 32-bit
+  systems which follow the ARMv7 architected reset values.
+
+
 Example:
 
 	timer {
diff --git a/drivers/clocksource/arm_arch_timer.c b/drivers/clocksource/arm_arch_timer.c
index 8daf056..799139f 100644
--- a/drivers/clocksource/arm_arch_timer.c
+++ b/drivers/clocksource/arm_arch_timer.c
@@ -654,6 +654,14 @@ static void __init arch_timer_init(struct device_node *np)
 	arch_timer_detect_rate(NULL, np);
 
 	/*
+	 * If we cannot rely on firmware initializing the timer registers then
+	 * we should use the physical timers instead.
+	 */
+	if (IS_ENABLED(CONFIG_ARM) &&
+	    of_property_read_bool(np, "arm,cpu-registers-not-fw-configured"))
+			arch_timer_use_virtual = false;
+
+	/*
 	 * If HYP mode is available, we know that the physical timer
 	 * has been configured to be accessible from PL1. Use it, so
 	 * that a guest can use the virtual timer instead.
-- 
1.8.3.2

