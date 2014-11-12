Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753576AbaKLTog (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Nov 2014 14:44:36 -0500
Received: from mail-ie0-f202.google.com ([209.85.223.202]:37645 "EHLO
	mail-ie0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753469AbaKLTns (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Nov 2014 14:43:48 -0500
From: Andrew Bresticker <abrestic@chromium.org>
To: Ralf Baechle <ralf@linux-mips.org>, Rob Herring <robh+dt@kernel.org>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Jason Cooper <jason@lakedaemon.net>,
        Daniel Lezcano <daniel.lezcano@linaro.org>
Cc: Andrew Bresticker <abrestic@chromium.org>,
        John Crispin <blogic@openwrt.org>, David Daney <ddaney.cavm@gmail.com>,
        Qais Yousef <qais.yousef@imgtec.com>,
        James Hogan <james.hogan@imgtec.com>, Arnd Bergmann <arnd@arndb.de>,
        linux-mips@linux-mips.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH V5 2/4] of: Add binding document for MIPS GIC
Date: Wed, 12 Nov 2014 11:43:37 -0800
Message-Id: <1415821419-26974-3-git-send-email-abrestic@chromium.org>
X-Mailer: git-send-email 2.1.0.rc2.206.gedb03e5
In-Reply-To: <1415821419-26974-1-git-send-email-abrestic@chromium.org>
References: <1415821419-26974-1-git-send-email-abrestic@chromium.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The Global Interrupt Controller (GIC) present on certain MIPS systems
can be used to route external interrupts to individual VPEs and CPU
interrupt vectors.  It also supports a timer and software-generated
interrupts.

Signed-off-by: Andrew Bresticker <abrestic@chromium.org>
Acked-by: Arnd Bergmann <arnd@arndb.de>
---
No changes from v4.
Changes from v3:
 - removed CPU name from compatible string
 - removed available-cpu-vectors, added reserved-cpu-vectors
 - made reg property optional
Changes from v2:
 - added third cell to specify local vs. shared
 - added documentation for timer sub-node
 - changed compatible string to include CPU version
Changes from v1:
 - moved from mips/ to interrupt-controller/
 - removed interrupts and interrupt-parent properties
 - added available-cpu-vectors property
 - dropped third cell in interrupt specifier
---
 .../bindings/interrupt-controller/mips-gic.txt     | 55 ++++++++++++++++++++++
 .../dt-bindings/interrupt-controller/mips-gic.h    |  9 ++++
 2 files changed, 64 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/interrupt-controller/mips-gic.txt
 create mode 100644 include/dt-bindings/interrupt-controller/mips-gic.h

diff --git a/Documentation/devicetree/bindings/interrupt-controller/mips-gic.txt b/Documentation/devicetree/bindings/interrupt-controller/mips-gic.txt
new file mode 100644
index 0000000..5a65478
--- /dev/null
+++ b/Documentation/devicetree/bindings/interrupt-controller/mips-gic.txt
@@ -0,0 +1,55 @@
+MIPS Global Interrupt Controller (GIC)
+
+The MIPS GIC routes external interrupts to individual VPEs and IRQ pins.
+It also supports local (per-processor) interrupts and software-generated
+interrupts which can be used as IPIs.  The GIC also includes a free-running
+global timer, per-CPU count/compare timers, and a watchdog.
+
+Required properties:
+- compatible : Should be "mti,gic".
+- interrupt-controller : Identifies the node as an interrupt controller
+- #interrupt-cells : Specifies the number of cells needed to encode an
+  interrupt specifier.  Should be 3.
+  - The first cell is the type of interrupt, local or shared.
+    See <include/dt-bindings/interrupt-controller/mips-gic.h>.
+  - The second cell is the GIC interrupt number.
+  - The third cell encodes the interrupt flags.
+    See <include/dt-bindings/interrupt-controller/irq.h> for a list of valid
+    flags.
+
+Optional properties:
+- reg : Base address and length of the GIC registers.  If not present,
+  the base address reported by the hardware GCR_GIC_BASE will be used.
+- mti,reserved-cpu-vectors : Specifies the list of CPU interrupt vectors
+  to which the GIC may not route interrupts.  Valid values are 2 - 7.
+  This property is ignored if the CPU is started in EIC mode.
+
+Required properties for timer sub-node:
+- compatible : Should be "mti,gic-timer".
+- interrupts : Interrupt for the GIC local timer.
+- clock-frequency : Clock frequency at which the GIC timers operate.
+
+Example:
+
+	gic: interrupt-controller@1bdc0000 {
+		compatible = "mti,gic";
+		reg = <0x1bdc0000 0x20000>;
+
+		interrupt-controller;
+		#interrupt-cells = <3>;
+
+		mti,reserved-cpu-vectors = <7>;
+
+		timer {
+			compatible = "mti,gic-timer";
+			interrupts = <GIC_LOCAL 1 IRQ_TYPE_NONE>;
+			clock-frequency = <50000000>;
+		};
+	};
+
+	uart@18101400 {
+		...
+		interrupt-parent = <&gic>;
+		interrupts = <GIC_SHARED 24 IRQ_TYPE_LEVEL_HIGH>;
+		...
+	};
diff --git a/include/dt-bindings/interrupt-controller/mips-gic.h b/include/dt-bindings/interrupt-controller/mips-gic.h
new file mode 100644
index 0000000..cf35a57
--- /dev/null
+++ b/include/dt-bindings/interrupt-controller/mips-gic.h
@@ -0,0 +1,9 @@
+#ifndef _DT_BINDINGS_INTERRUPT_CONTROLLER_MIPS_GIC_H
+#define _DT_BINDINGS_INTERRUPT_CONTROLLER_MIPS_GIC_H
+
+#include <dt-bindings/interrupt-controller/irq.h>
+
+#define GIC_SHARED 0
+#define GIC_LOCAL 1
+
+#endif
-- 
2.1.0.rc2.206.gedb03e5

