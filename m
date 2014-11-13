Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934300AbaKMU6m (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Nov 2014 15:58:42 -0500
Received: from mail-pa0-f73.google.com ([209.85.220.73]:51324 "EHLO
	mail-pa0-f73.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934091AbaKMU6O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Nov 2014 15:58:14 -0500
From: Andrew Bresticker <abrestic@chromium.org>
To: Vinod Koul <vinod.koul@intel.com>, Dan Williams <dan.j.williams@intel.com>
Cc: Andrew Bresticker <abrestic@chromium.org>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Grant Likely <grant.likely@linaro.org>,
        James Hartley <james.hartley@imgtec.com>,
        James Hogan <james.hogan@imgtec.com>,
        Ezequiel Garcia <ezequiel.garcia@imgtec.com>,
        Damien Horsley <Damien.Horsley@imgtec.com>, dmaengine@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 1/2] dmaengine: Add binding document for IMG MDC
Date: Thu, 13 Nov 2014 12:58:07 -0800
Message-Id: <1415912288-26926-2-git-send-email-abrestic@chromium.org>
X-Mailer: git-send-email 2.1.0.rc2.206.gedb03e5
In-Reply-To: <1415912288-26926-1-git-send-email-abrestic@chromium.org>
References: <1415912288-26926-1-git-send-email-abrestic@chromium.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add a binding document for the IMG Multi-threaded DMA Controller (MDC)
present on the MIPS-based Pistachio and other IMG SoCs.

Signed-off-by: Andrew Bresticker <abrestic@chromium.org>
---
 .../devicetree/bindings/dma/img-mdc-dma.txt        | 57 ++++++++++++++++++++++
 1 file changed, 57 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/dma/img-mdc-dma.txt

diff --git a/Documentation/devicetree/bindings/dma/img-mdc-dma.txt b/Documentation/devicetree/bindings/dma/img-mdc-dma.txt
new file mode 100644
index 0000000..28c1341
--- /dev/null
+++ b/Documentation/devicetree/bindings/dma/img-mdc-dma.txt
@@ -0,0 +1,57 @@
+* IMG Multi-threaded DMA Controller (MDC)
+
+Required properties:
+- compatible: Must be "img,pistachio-mdc-dma".
+- reg: Must contain the base address and length of the MDC registers.
+- interrupts: Must contain all the per-channel DMA interrupts.
+- clocks: Must contain an entry for each entry in clock-names.
+  See ../clock/clock-bindings.txt for details.
+- clock-names: Must include the following entries:
+  - sys: MDC system interface clock.
+- img,cr-periph: Must contain a phandle to the peripheral control syscon
+  node which contains the DMA request to channel mapping registers.
+- img,max-burst-multiplier: Must be the maximum supported burst size multiplier.
+  The maximum burst size is this value multiplied by the hardware-reported bus
+  width.
+- #dma-cells: Must be 3:
+  - The first cell is the peripheral's DMA request line.
+  - The second cell is a bitmap specifying to which channels the DMA request
+    line may be mapped (i.e. bit N set indicates channel N is usable).
+  - The third cell is the thread ID to be used by the channel.
+
+Optional properties:
+- dma-channels: Number of supported DMA channels, up to 32.  If not specified
+  the number reported by the hardware is used.
+
+Example:
+
+mdc: dma-controller@18143000 {
+	compatible = "img,pistachio-mdc-dma";
+	reg = <0x18143000 0x1000>;
+	interrupts = <GIC_SHARED 27 IRQ_TYPE_LEVEL_HIGH>,
+		     <GIC_SHARED 28 IRQ_TYPE_LEVEL_HIGH>,
+		     <GIC_SHARED 29 IRQ_TYPE_LEVEL_HIGH>,
+		     <GIC_SHARED 30 IRQ_TYPE_LEVEL_HIGH>,
+		     <GIC_SHARED 31 IRQ_TYPE_LEVEL_HIGH>,
+		     <GIC_SHARED 32 IRQ_TYPE_LEVEL_HIGH>,
+		     <GIC_SHARED 33 IRQ_TYPE_LEVEL_HIGH>,
+		     <GIC_SHARED 34 IRQ_TYPE_LEVEL_HIGH>,
+		     <GIC_SHARED 35 IRQ_TYPE_LEVEL_HIGH>,
+		     <GIC_SHARED 36 IRQ_TYPE_LEVEL_HIGH>,
+		     <GIC_SHARED 37 IRQ_TYPE_LEVEL_HIGH>,
+		     <GIC_SHARED 38 IRQ_TYPE_LEVEL_HIGH>;
+	clocks = <&system_clk>;
+	clock-names = "sys";
+
+	img,max-burst-multiplier = <16>;
+	img,cr-periph = <&cr_periph>;
+
+	#dma-cells = <3>;
+};
+
+spi@18100f00 {
+	...
+	dmas = <&mdc 9 0xffffffff 0>, <&mdc 10 0xffffffff 0>;
+	dma-names = "tx", "rx";
+	...
+};
-- 
2.1.0.rc2.206.gedb03e5

