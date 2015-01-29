Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756891AbbA2MUj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jan 2015 07:20:39 -0500
Received: from mailapp01.imgtec.com ([195.59.15.196]:1565 "EHLO
	mailapp01.imgtec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754073AbbA2MTw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jan 2015 07:19:52 -0500
From: Zubair Lutfullah Kakakhel <Zubair.Kakakhel@imgtec.com>
To: <vinod.koul@intel.com>, <dan.j.williams@intel.com>
CC: <devicetree@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <dmaengine@vger.kernel.org>, <Zubair.Kakakhel@imgtec.com>
Subject: [PATCH 1/2] dt: dma: Add DT binding document for jz4780-dma
Date: Thu, 29 Jan 2015 12:19:38 +0000
Message-ID: <1422533980-42761-2-git-send-email-Zubair.Kakakhel@imgtec.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1422533980-42761-1-git-send-email-Zubair.Kakakhel@imgtec.com>
References: <1422533980-42761-1-git-send-email-Zubair.Kakakhel@imgtec.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [192.168.154.89]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alex Smith <alex.smith@imgtec.com>

Add device tree bindings for the DMA controller on JZ4780 SoCs, used by
the dma-jz4780 driver.

Signed-off-by: Alex Smith <alex.smith@imgtec.com>
---
 .../devicetree/bindings/dma/jz4780-dma.txt         | 59 ++++++++++++++++++++++
 1 file changed, 59 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/dma/jz4780-dma.txt

diff --git a/Documentation/devicetree/bindings/dma/jz4780-dma.txt b/Documentation/devicetree/bindings/dma/jz4780-dma.txt
new file mode 100644
index 0000000..0e46056
--- /dev/null
+++ b/Documentation/devicetree/bindings/dma/jz4780-dma.txt
@@ -0,0 +1,59 @@
+* Ingenic JZ4780 DMA Controller
+
+Required properties:
+
+- compatible: Should be "ingenic,jz4780-dma"
+- reg: Should contain the DMA controller registers location and length.
+- interrupts: Should contain the interrupt specifier of the DMA controller.
+- clocks: Should contain a clock specifier for the JZ4780 PDMA clock.
+- #dma-cells: Must be <3>. Number of integer cells in the dmas property of
+  DMA clients (see below).
+
+Optional properties:
+
+- ingenic,reserved-channels: Bitmask of channels to reserve for devices that
+  need a specific channel. These channels will only be assigned when explicitly
+  requested by a client. The primary use for this is channels 0 and 1, which
+  can be configured to have special behaviour for NAND/BCH when using
+  programmable firmware.
+
+Example:
+
+dma: dma@13420000 {
+	compatible = "ingenic,jz4780-dma";
+	reg = <0x13420000 0x10000>;
+
+	interrupts = <10>;
+
+	clocks = <&cgu JZ4780_CLK_PDMA>;
+
+	#dma-cells = <3>;
+
+	ingenic,reserved-channels = <0x3>;
+};
+
+DMA clients must use the format described in dma.txt, giving a phandle to the
+DMA controller plus the following 3 integer cells:
+
+1. Transmit request type: The DMA request type for transfers to the device on
+   the allocated channel, as defined in the SoC documentation. If set to 0,
+   transfers to the device will not be allowed on the channel.
+
+2. Receive request type: The DMA request type for transfers from the device on
+   the allocated channel, as defined in the SoC documentation. If set to 0,
+   transfers from the device will not be allowed on the channel.
+
+3. Channel: If set to 0xffffffff, any available channel will be allocated for
+   the client. Otherwise, the exact channel specified will be used. The channel
+   should be reserved on the DMA controller using the ingenic,reserved-channels
+   property.
+
+Example:
+
+uart0: serial@10030000 {
+	...
+	dmas = <&dma 0x14 0 0xffffffff
+		&dma 0 0x15 0xffffffff>;
+	dma-names = "tx", "rx";
+	...
+};
-- 
1.9.1

