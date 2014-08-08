Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753000AbaHHSVx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Aug 2014 14:21:53 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:53787 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751575AbaHHSUr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Aug 2014 14:20:47 -0400
From: Santosh Shilimkar <santosh.shilimkar@ti.com>
To: <linux-kernel@vger.kernel.org>, <robh+dt@kernel.org>
CC: <linux-arm-kernel@lists.infradead.org>, <grant.likely@linaro.org>,
        <gregkh@linuxfoundation.org>, <galak@codeaurora.org>, <olof@lixom.net>,
        <mark.rutland@arm.com>, <devicetree@vger.kernel.org>, <arnd@arndb.de>,
        <sandeep_n@ti.com>, Santosh Shilimkar <santosh.shilimkar@ti.com>
Subject: [Patch v3 4/6] Documentation: dt: soc: add Keystone Navigator DMA bindings
Date: Fri, 8 Aug 2014 14:19:43 -0400
Message-ID: <1407521985-22574-5-git-send-email-santosh.shilimkar@ti.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1407521985-22574-1-git-send-email-santosh.shilimkar@ti.com>
References: <1407521985-22574-1-git-send-email-santosh.shilimkar@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The Keystone Navigator DMA driver sets up the dma channels and flows for
the QMSS(Queue Manager SubSystem) who triggers the actual data movements
across clients using destination queues. Every client modules like
NETCP(Network Coprocessor), SRIO(Serial Rapid IO) and CRYPTO
Engines has its own instance of packet dma hardware. QMSS has also
an internal packet DMA module which is used as an infrastructure
DMA with zero copy.

Initially this driver was proposed as DMA engine driver but since the
hardware is not typical DMA engine and hence doesn't comply with typical
DMA engine driver needs, that approach was naked. Link to that
discussion -
	https://lkml.org/lkml/2014/3/18/340

As aligned, now we pair the Navigator DMA with its companion Navigator
QMSS subsystem driver.

Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Kumar Gala <galak@codeaurora.org>
Cc: Olof Johansson <olof@lixom.net>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Grant Likely <grant.likely@linaro.org>
Cc: Rob Herring <robh+dt@kernel.org>
Cc: Mark Rutland <mark.rutland@arm.com>
Signed-off-by: Sandeep Nair <sandeep_n@ti.com>
Signed-off-by: Santosh Shilimkar <santosh.shilimkar@ti.com>
---
 .../bindings/soc/ti/keystone-navigator-dma.txt     |  111 ++++++++++++++++++++
 1 file changed, 111 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/soc/ti/keystone-navigator-dma.txt

diff --git a/Documentation/devicetree/bindings/soc/ti/keystone-navigator-dma.txt b/Documentation/devicetree/bindings/soc/ti/keystone-navigator-dma.txt
new file mode 100644
index 0000000..337c4ea
--- /dev/null
+++ b/Documentation/devicetree/bindings/soc/ti/keystone-navigator-dma.txt
@@ -0,0 +1,111 @@
+Keystone Navigator DMA Controller
+
+This document explains the device tree bindings for the packet dma
+on keystone devices. The Keystone Navigator DMA driver sets up the dma
+channels and flows for the QMSS(Queue Manager SubSystem) who triggers
+the actual data movements across clients using destination queues. Every
+client modules like  NETCP(Network Coprocessor), SRIO(Serial Rapid IO),
+CRYPTO Engines etc has its own instance of dma hardware. QMSS has also
+an internal packet DMA module which is used as an infrastructure DMA
+with zero copy.
+
+Navigator DMA cloud layout:
+	------------------
+	| Navigator DMAs |
+	------------------
+		|
+		|-> DMA instance #0
+		|
+		|-> DMA instance #1
+			.
+			.
+		|
+		|-> DMA instance #n
+
+Navigator DMA properties:
+Required properties:
+ - compatible: Should be "ti,keystone-navigator-dma"
+ - clocks: phandle to dma instances clocks. The clock handles can be as
+	many as the dma instances. The order should be maintained as per
+	the dma instances.
+ - ti,navigator-cloud-address: Should contain base address for the multi-core
+	navigator cloud and number of addresses depends on SOC integration
+	configuration.. Navigator cloud global address needs to be programmed
+	into DMA and the DMA uses it as the physical addresses to reach queue
+	managers. Note that these addresses though points to queue managers,
+	they are relevant only from DMA perspective. The QMSS may not choose to
+	use them since it has a different address space view to reach all
+	its components.
+
+DMA instance properties:
+Required properties:
+ - reg: Should contain register location and length of the following dma
+	register regions. Register regions should be specified in the following
+	order.
+	- Global control register region (global).
+	- Tx DMA channel configuration register region (txchan).
+	- Rx DMA channel configuration register region (rxchan).
+	- Tx DMA channel Scheduler configuration register region (txsched).
+	- Rx DMA flow configuration register region (rxflow).
+
+Optional properties:
+ - reg-names: Names for the register regions.
+ - ti,enable-all: Enable all DMA channels vs clients opening specific channels
+	what they need. This property is useful for the userspace fast path
+	case where the linux drivers enables the channels used by userland
+	stack.
+ - ti,loop-back: To loopback Tx streaming I/F to Rx streaming I/F. Used for
+	      infrastructure transfers.
+ - ti,rx-retry-timeout: Number of dma cycles to wait before retry on buffer
+		     starvation.
+
+Example:
+
+	knav_dmas: knav_dmas@0 {
+		compatible = "ti,keystone-navigator-dma";
+		clocks = <&papllclk>, <&clkxge>;
+		#address-cells = <1>;
+		#size-cells = <1>;
+		ranges;
+		ti,navigator-cloud-address = <0x23a80000 0x23a90000
+					   0x23aa0000 0x23ab0000>;
+
+		dma_gbe: dma_gbe@0 {
+			reg = <0x2004000 0x100>,
+				  <0x2004400 0x120>,
+				  <0x2004800 0x300>,
+				  <0x2004c00 0x120>,
+				  <0x2005000 0x400>;
+			reg-names = "global", "txchan", "rxchan",
+					"txsched", "rxflow";
+		};
+
+		dma_xgbe: dma_xgbe@0 {
+			reg = <0x2fa1000 0x100>,
+				<0x2fa1400 0x200>,
+				<0x2fa1800 0x200>,
+				<0x2fa1c00 0x200>,
+				<0x2fa2000 0x400>;
+			reg-names = "global", "txchan", "rxchan",
+					"txsched", "rxflow";
+		};
+	};
+
+Navigator DMA client:
+Required properties:
+ - ti,navigator-dmas: List of one or more DMA specifiers, each consisting of
+			- A phandle pointing to DMA instance node
+			- A DMA channel number as a phandle arg.
+ - ti,navigator-dma-names: Contains dma channel name for each DMA specifier in
+			the 'ti,navigator-dmas' property.
+
+Example:
+
+	netcp: netcp@2090000 {
+		..
+		ti,navigator-dmas = <&dma_gbe 22>,
+				<&dma_gbe 23>,
+				<&dma_gbe 8>;
+		ti,navigator-dma-names = "netrx0", "netrx1", "nettx";
+		..
+	};
-- 
1.7.9.5

