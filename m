Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757307AbaIKRAP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Sep 2014 13:00:15 -0400
Received: from mail-pa0-f48.google.com ([209.85.220.48]:57974 "EHLO
	mail-pa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752419AbaIKRAL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Sep 2014 13:00:11 -0400
From: Doug Anderson <dianders@chromium.org>
To: olof@lixom.net
Cc: Sonny Rao <sonnyrao@chromium.org>, Will Deacon <will.deacon@arm.com>,
        Catalin Marinas <Catalin.Marinas@arm.com>,
        Mark Rutland <Mark.Rutland@arm.com>,
        Stephen Boyd <sboyd@codeaurora.org>,
        Marc Zyngier <marc.zyngier@arm.com>,
        Sudeep Holla <Sudeep.Holla@arm.com>,
        Christopher Covington <cov@codeaurora.org>,
        Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Nathan Lynch <Nathan_Lynch@mentor.com>,
        linux-arm-kernel@lists.infradead.org,
        Doug Anderson <dianders@chromium.org>, robh+dt@kernel.org,
        pawel.moll@arm.com, mark.rutland@arm.com,
        ijc+devicetree@hellion.org.uk, galak@codeaurora.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v3] clocksource: arch_timer: Allow the device tree to specify the physical timer
Date: Thu, 11 Sep 2014 10:00:01 -0700
Message-Id: <1410454801-14231-1-git-send-email-dianders@chromium.org>
X-Mailer: git-send-email 2.1.0.rc2.206.gedb03e5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Some 32-bit (ARMv7) systems are architected like this:

* The firmware doesn't know and doesn't care about hypervisor mode and
  we don't want to add the complexity of hypervisor there.

* The firmware isn't involved in SMP bringup or resume.

* The ARCH timer come up with an uninitialized offset between the
  virtual and physical counters.  Each core gets a different random
  offset.

* The device boots in "Secure SVC" mode.

* Nothing has touched the reset value of CNTHCTL.PL1PCEN or
  CNTHCTL.PL1PCTEN (both default to 1 at reset)

On systems like the above, it doesn't make sense to use the virtual
counter.  There's nobody managing the offset and each time a core goes
down and comes back up it will get reinitialized to some other random
value.

Let's add a property to the device tree to say that we shouldn't use
the virtual timer.  Firmware could potentially remove this property
before passing the device tree to the kernel if it really wants the
kernel to use a virtual timer.

Note that it's been said that ARM64 (ARMv8) systems the firmware and
kernel really can't be architected as described above.  That means
using the physical timer like this really only makes sense for ARMv7
systems.

In order for this patch to do anything useful, we also need Sonny's
patch at <https://patchwork.kernel.org/patch/4790921/>

Signed-off-by: Doug Anderson <dianders@chromium.org>
Signed-off-by: Sonny Rao <sonnyrao@chromium.org>
---
Changes in v3:
- Wording changes to bindings and patch desc as per Will Deacon

Changes in v2:
- Add "#ifdef CONFIG_ARM" as per Will Deacon

 Documentation/devicetree/bindings/arm/arch_timer.txt | 6 ++++++
 drivers/clocksource/arm_arch_timer.c                 | 5 +++++
 2 files changed, 11 insertions(+)

diff --git a/Documentation/devicetree/bindings/arm/arch_timer.txt b/Documentation/devicetree/bindings/arm/arch_timer.txt
index 37b2caf..e28fced 100644
--- a/Documentation/devicetree/bindings/arm/arch_timer.txt
+++ b/Documentation/devicetree/bindings/arm/arch_timer.txt
@@ -22,6 +22,12 @@ to deliver its interrupts via SPIs.
 - always-on : a boolean property. If present, the timer is powered through an
   always-on power domain, therefore it never loses context.
 
+** Optional properties:
+
+- arm,use-physical-timer : Don't ever use the virtual timer, just use the
+  physical one.  Only supported for ARM (not ARM64).
+
+
 Example:
 
 	timer {
diff --git a/drivers/clocksource/arm_arch_timer.c b/drivers/clocksource/arm_arch_timer.c
index 5163ec1..e7aa256 100644
--- a/drivers/clocksource/arm_arch_timer.c
+++ b/drivers/clocksource/arm_arch_timer.c
@@ -649,6 +649,11 @@ static void __init arch_timer_init(struct device_node *np)
 		arch_timer_ppi[i] = irq_of_parse_and_map(np, i);
 	arch_timer_detect_rate(NULL, np);
 
+#ifdef CONFIG_ARM
+	if (of_property_read_bool(np, "arm,use-physical-timer"))
+		arch_timer_use_virtual = false;
+#endif
+
 	/*
 	 * If HYP mode is available, we know that the physical timer
 	 * has been configured to be accessible from PL1. Use it, so
-- 
2.1.0.rc2.206.gedb03e5

