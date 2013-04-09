Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936749Ab3DICas (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Apr 2013 22:30:48 -0400
Received: from wolverine01.qualcomm.com ([199.106.114.254]:21442 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934528Ab3DICa0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Apr 2013 22:30:26 -0400
X-IronPort-AV: E=Sophos;i="4.87,434,1363158000"; 
   d="scan'208";a="36738603"
From: Stephen Boyd <sboyd@codeaurora.org>
To: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        devicetree-discuss@lists.ozlabs.org,
        Mark Rutland <mark.rutland@arm.com>,
        Marc Zyngier <Marc.Zyngier@arm.com>
Subject: [PATCH 1/4] Documentation: Add memory mapped ARM architected timer binding
Date: Mon,  8 Apr 2013 19:30:20 -0700
Message-Id: <1365474623-29181-2-git-send-email-sboyd@codeaurora.org>
X-Mailer: git-send-email 1.8.2
In-Reply-To: <1365474623-29181-1-git-send-email-sboyd@codeaurora.org>
References: <1365474623-29181-1-git-send-email-sboyd@codeaurora.org>
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
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Marc Zyngier <Marc.Zyngier@arm.com>
Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>
---
 .../devicetree/bindings/arm/arch_timer.txt         | 62 ++++++++++++++++++++--
 1 file changed, 59 insertions(+), 3 deletions(-)

diff --git a/Documentation/devicetree/bindings/arm/arch_timer.txt b/Documentation/devicetree/bindings/arm/arch_timer.txt
index 20746e5..69ef711 100644
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
@@ -26,3 +30,55 @@ Example:
 			     <1 10 0xf08>;
 		clock-frequency = <100000000>;
 	};
+
+** Memory mapped timer node properties
+
+- compatible : Should at least contain "arm,armv7-timer-mem".
+
+- #address-cells : Must be 1.
+
+- #size-cells : Must be 1.
+
+- ranges : Indicates parent and child bus address space are the same.
+
+- clock-frequency : The frequency of the main counter, in Hz. Optional.
+
+- reg : The control frame base address.
+
+Frame:
+
+- frame-id: Encoded as follows:
+		bits[3:0]  frame number: 0 to 7.
+		bits[10:8] frame usage:
+			0 - user/kernel
+			1 - hyp
+			2 - secure
+
+- interrupts : Interrupt list for physical and virtual timers in that order.
+  The virtual timer interrupt is optional.
+
+- reg : The first and second view base addresses in that order. The second view
+  base address is optional.
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
+		frame0@f0001000 {
+			frame-id = <0x0>
+			interrupts = <0 13 0x8>,
+				     <0 14 0x8>;
+			reg = <0xf0001000 0x1000>,
+			      <0xf0002000 0x1000>;
+		};
+		frame1@f0003000 {
+			frame-id = <0x11>
+			interrupts = <0 15 0x8>;
+			reg = <0xf0003000 0x1000>;
+		};
+	};
-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
hosted by The Linux Foundation

