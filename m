Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756082AbbAWRMK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Jan 2015 12:12:10 -0500
Received: from down.free-electrons.com ([37.187.137.238]:52717 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755769AbbAWRJi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Jan 2015 12:09:38 -0500
From: Boris Brezillon <boris.brezillon@free-electrons.com>
To: Thomas Gleixner <tglx@linutronix.de>, Jason Cooper <jason@lakedaemon.net>,
        Nicolas Ferre <nicolas.ferre@atmel.com>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Alexandre Belloni <alexandre.belloni@free-electrons.com>,
        Rob Herring <robh+dt@kernel.org>
Cc: Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>, devicetree@vger.kernel.org,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Boris Brezillon <boris.brezillon@free-electrons.com>
Subject: [PATCH v3 3/5] irqchip: Add DT binding doc for dumb demuxer chips
Date: Fri, 23 Jan 2015 18:09:29 +0100
Message-Id: <1422032971-14139-4-git-send-email-boris.brezillon@free-electrons.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1422032971-14139-1-git-send-email-boris.brezillon@free-electrons.com>
References: <1422032971-14139-1-git-send-email-boris.brezillon@free-electrons.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add documentation for the dumb demuxer.

Signed-off-by: Boris Brezillon <boris.brezillon@free-electrons.com>
Acked-by: Nicolas Ferre <nicolas.ferre@atmel.com>
---
 .../bindings/interrupt-controller/dumb-demux.txt   | 41 ++++++++++++++++++++++
 1 file changed, 41 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/interrupt-controller/dumb-demux.txt

diff --git a/Documentation/devicetree/bindings/interrupt-controller/dumb-demux.txt b/Documentation/devicetree/bindings/interrupt-controller/dumb-demux.txt
new file mode 100644
index 0000000..6199923
--- /dev/null
+++ b/Documentation/devicetree/bindings/interrupt-controller/dumb-demux.txt
@@ -0,0 +1,41 @@
+* Generic Dumb Interrupt Demultiplexer
+
+This Dumb demultiplexer simply forward all incoming interrupts to its
+enabled/unmasked children.
+It is only intended to be used by hardware that do not provide a proper way
+to demultiplex a source interrupt, and thus have to wake all their children
+up so that they can possibly handle the interrupt (if needed).
+This can be seen as an alternative to shared interrupts when at least one
+of the interrupt children is a timer (and require the irq to be stay enabled
+on suspend) while others are not. This will prevent calling irq handlers of
+non timer devices while they are suspended.
+
+Required properties:
+- compatible: Should be "virtual,dumb-irq-demux".
+- interrupt-controller: Identifies the node as an interrupt controller.
+- interrupts-extended or interrupt-parent and interrupts: Reference the source
+  interrupt connected to this dumb demuxer.
+- #interrupt-cells: The number of cells to define the interrupts (should be 1).
+  The only cell is the IRQ number.
+- irqs: u32 bitfield specifying the interrupts provided by the demuxer.
+
+Examples:
+	/*
+	 * Dumb demuxer controller
+	 */
+	dumb_irq1_demux: dumb-irq-demux@1 {
+		compatible = "virtual,dumb-irq-demux";
+		interrupt-controller;
+		#interrupt-cells = <1>;
+		interrupts-extended = <&aic 1 IRQ_TYPE_LEVEL_HIGH 7>;
+		irqs = <0x3f>;
+	};
+
+	/*
+	 * Device connected on this dumb demuxer
+	 */
+	dma: dma-controller@ffffec00 {
+		compatible = "atmel,at91sam9g45-dma";
+		reg = <0xffffec00 0x200>;
+		interrupts-extended = <&dumb_irq1_demux 0>;
+	};
-- 
1.9.1

