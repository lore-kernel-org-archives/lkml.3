Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752883AbaJGGhk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Oct 2014 02:37:40 -0400
Received: from mail-ig0-f201.google.com ([209.85.213.201]:60317 "EHLO
	mail-ig0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751244AbaJGGhi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Oct 2014 02:37:38 -0400
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
Subject: [PATCH v3] clocksource: arch_timer: Allow the device tree to specify uninitialized CNTVOFF
Date: Mon,  6 Oct 2014 23:37:32 -0700
Message-Id: <1412663852-32681-1-git-send-email-sonnyrao@chromium.org>
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

Note that it's been said that ARM64 (ARMv8) systems the firmware and
kernel really can't be architected as described above.  That means
using the physical timer like this really only makes sense for ARMv7
systems.

Signed-off-by: Doug Anderson <dianders@chromium.org>
Signed-off-by: Sonny Rao <sonnyrao@chromium.org>
---
Changes in v2:
- Add "#ifdef CONFIG_ARM" as per Will Deacon

Changes in v3:
- change property name to arm,cntvoff-not-fw-configured and specify
  that the value of CNTHCTL.PL1PC(T)EN must still be the reset value
  of 1 as per Mark Rutland
---
 Documentation/devicetree/bindings/arm/arch_timer.txt | 8 ++++++++
 drivers/clocksource/arm_arch_timer.c                 | 9 +++++++++
 2 files changed, 17 insertions(+)

diff --git a/Documentation/devicetree/bindings/arm/arch_timer.txt b/Documentation/devicetree/bindings/arm/arch_timer.txt
index 37b2caf..67837c9 100644
--- a/Documentation/devicetree/bindings/arm/arch_timer.txt
+++ b/Documentation/devicetree/bindings/arm/arch_timer.txt
@@ -22,6 +22,14 @@ to deliver its interrupts via SPIs.
 - always-on : a boolean property. If present, the timer is powered through an
   always-on power domain, therefore it never loses context.
 
+** Optional properties:
+
+- arm,cntvoff-not-fw-configured : Firmware does not initialize
+  CNTVOFF, which may reset to arbitrary and different values on each
+  CPU.  CNTHCTL.PL1PC(T)EN must both be 1, which is the reset value
+  specificed by the architecture.   Only supported for ARM (not ARM64).
+
+
 Example:
 
 	timer {
diff --git a/drivers/clocksource/arm_arch_timer.c b/drivers/clocksource/arm_arch_timer.c
index bd8da15..234d7b9 100644
--- a/drivers/clocksource/arm_arch_timer.c
+++ b/drivers/clocksource/arm_arch_timer.c
@@ -668,6 +668,15 @@ static void __init arch_timer_init(struct device_node *np)
 		arch_timer_ppi[i] = irq_of_parse_and_map(np, i);
 	arch_timer_detect_rate(NULL, np);
 
+#ifdef CONFIG_ARM
+	/*
+	 * If we cannot rely on firmware initializing the CNTVOFF then
+	 * we should use the physical timers instead.
+	 */
+	if (of_property_read_bool(np, "arm,cntvoff-not-fw-configured"))
+		arch_timer_use_virtual = false;
+#endif
+
 	/*
 	 * If HYP mode is available, we know that the physical timer
 	 * has been configured to be accessible from PL1. Use it, so
-- 
1.8.3.2

