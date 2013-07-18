Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965360Ab3GSAA6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Jul 2013 20:00:58 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:32920 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759440Ab3GRX7g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Jul 2013 19:59:36 -0400
From: Stephen Boyd <sboyd@codeaurora.org>
To: Daniel Lezcano <daniel.lezcano@linaro.org>
Cc: linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        John Stultz <john.stultz@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        devicetree-discuss@lists.ozlabs.org,
        Marc Zyngier <Marc.Zyngier@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Rob Herring <robherring2@gmail.com>
Subject: [PATCH v4 2/5] Documentation: Add memory mapped ARM architected timer binding
Date: Thu, 18 Jul 2013 16:59:29 -0700
Message-Id: <1374191972-18015-3-git-send-email-sboyd@codeaurora.org>
X-Mailer: git-send-email 1.8.3.3.754.g9c3c367
In-Reply-To: <1374191972-18015-1-git-send-email-sboyd@codeaurora.org>
References: <1374191972-18015-1-git-send-email-sboyd@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add a binding for the arm architected timer hardware's memory
mapped interface. The mmio timer hardware is made up of one base
frame and a collection of up to 8 timer frames, where each of the
8 timer frames can have either one or two views. A frame
typically maps to a privilege level (user/kernel, hypervisor,
secure). The first view has full access to the registers within a
frame, while the second view can be restricted to particular
registers within a frame. Each frame must support a physical
timer. It's optional for a frame to support a virtual timer.

Cc: devicetree-discuss@lists.ozlabs.org
Cc: Marc Zyngier <Marc.Zyngier@arm.com>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Rob Herring <robherring2@gmail.com>
Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>
---
 .../devicetree/bindings/arm/arch_timer.txt         | 59 ++++++++++++++++++++--
 1 file changed, 56 insertions(+), 3 deletions(-)

diff --git a/Documentation/devicetree/bindings/arm/arch_timer.txt b/Documentation/devicetree/bindings/arm/arch_timer.txt
index 20746e5..06fc760 100644
--- a/Documentation/devicetree/bindings/arm/arch_timer.txt
+++ b/Documentation/devicetree/bindings/arm/arch_timer.txt
@@ -1,10 +1,14 @@
 * ARM architected timer
 
-ARM cores may have a per-core architected timer, which provides per-cpu timers.
+ARM cores may have a per-core architected timer, which provides per-cpu timers,
+or a memory mapped architected timer, which provides up to 8 frames with a
+physical and optional virtual timer per frame.
 
-The timer is attached to a GIC to deliver its per-processor interrupts.
+The per-core architected timer is attached to a GIC to deliver its
+per-processor interrupts via PPIs. The memory mapped timer is attached to a GIC
+to deliver its interrupts via SPIs.
 
-** Timer node properties:
+** CP15 Timer node properties:
 
 - compatible : Should at least contain one of
 	"arm,armv7-timer"
@@ -26,3 +30,52 @@ Example:
 			     <1 10 0xf08>;
 		clock-frequency = <100000000>;
 	};
+
+** Memory mapped timer node properties:
+
+- compatible : Should at least contain "arm,armv7-timer-mem".
+
+- clock-frequency : The frequency of the main counter, in Hz. Optional.
+
+- reg : The control frame base address.
+
+Note that #address-cells, #size-cells, and ranges shall be present to ensure
+the CPU can address a frame's registers.
+
+A timer node has up to 8 frame sub-nodes, each with the following properties:
+
+- frame-number: 0 to 7.
+
+- interrupts : Interrupt list for physical and virtual timers in that order.
+  The virtual timer interrupt is optional.
+
+- reg : The first and second view base addresses in that order. The second view
+  base address is optional.
+
+- status : "disabled" indicates the frame is not available for use. Optional.
+
+Example:
+
+	timer@f0000000 {
+		compatible = "arm,armv7-timer-mem";
+		#address-cells = <1>;
+		#size-cells = <1>;
+		ranges;
+		reg = <0xf0000000 0x1000>;
+		clock-frequency = <50000000>;
+
+		frame@f0001000 {
+			frame-number = <0>
+			interrupts = <0 13 0x8>,
+				     <0 14 0x8>;
+			reg = <0xf0001000 0x1000>,
+			      <0xf0002000 0x1000>;
+		};
+
+		frame@f0003000 {
+			frame-number = <1>
+			interrupts = <0 15 0x8>;
+			reg = <0xf0003000 0x1000>;
+			status = "disabled";
+		};
+	};
-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
hosted by The Linux Foundation

