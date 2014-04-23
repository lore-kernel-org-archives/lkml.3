Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752733AbaDWXrg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Apr 2014 19:47:36 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:57801 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752599AbaDWXrb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Apr 2014 19:47:31 -0400
From: Santosh Shilimkar <santosh.shilimkar@ti.com>
To: <linux-kernel@vger.kernel.org>
CC: <linux-arm-kernel@lists.infradead.org>, <devicetree@vger.kernel.org>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kumar Gala <galak@codeaurora.org>, Olof Johansson <olof@lixom.net>,
        Arnd Bergmann <arnd@arndb.de>, Grant Likely <grant.likely@linaro.org>,
        Rob Herring <robh+dt@kernel.org>, Mark Rutland <mark.rutland@arm.com>,
        Sandeep Nair <sandeep_n@ti.com>
Subject: [PATCH v2 5/6] Documentation: dt: soc: add Keystone Navigator DMA bindings
Date: Wed, 23 Apr 2014 19:46:21 -0400
Message-ID: <1398296783-1176-6-git-send-email-santosh.shilimkar@ti.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1398296783-1176-1-git-send-email-santosh.shilimkar@ti.com>
References: <1398296783-1176-1-git-send-email-santosh.shilimkar@ti.com>
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
 .../bindings/soc/keystone-navigator-dma.txt        |  101 ++++++++++++++++++++
 1 file changed, 101 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/soc/keystone-navigator-dma.txt

diff --git a/Documentation/devicetree/bindings/soc/keystone-navigator-dma.txt b/Documentation/devicetree/bindings/soc/keystone-navigator-dma.txt
new file mode 100644
index 0000000..4b7d9a7
--- /dev/null
+++ b/Documentation/devicetree/bindings/soc/keystone-navigator-dma.txt
@@ -0,0 +1,101 @@
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
+ - compatible:	Should be "ti,keystone-navigator-dma"
+ - clocks:	phandle to dma instances clocks
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
+ - qm-base-address: Base address of the logical queue managers for dma.
+ - #dma-cells: Has to be 1. Keystone DMA doesn't support anything else.
+
+Optional properties:
+ - reg-names: Names for the register regions.
+ - enable-all: Enable all DMA channels.
+ - loop-back: To loopback Tx streaming I/F to Rx streaming I/F. Used for
+	      infrastructure transfers.
+ - rx-retry-timeout: Number of dma cycles to wait before retry on buffer
+		     starvation.
+Example:
+
+	knav_dmas: knav_dmas@0 {
+		compatible = "ti,keystone-navigator-dma";
+		clocks = <&papllclk>, <&clkxge>;
+		#address-cells = <1>;
+		#size-cells = <1>;
+		ranges;
+
+		dma_gbe {
+			dma-id = <0>;
+			reg = <0x2004000 0x100>,
+				  <0x2004400 0x120>,
+				  <0x2004800 0x300>,
+				  <0x2004c00 0x120>,
+				  <0x2005000 0x400>;
+			reg-names = "global", "txchan", "rxchan",
+					"txsched", "rxflow";
+
+			qm-base-address = <0x23a80000 0x23a90000
+					   0x23aa0000 0x23ab0000>;
+		};
+
+		dma_xgbe {
+			dma-id = <1>;
+			reg = <0x2fa1000 0x100>,
+				<0x2fa1400 0x200>,
+				<0x2fa1800 0x200>,
+				<0x2fa1c00 0x200>,
+				<0x2fa2000 0x400>;
+			reg-names = "global", "txchan", "rxchan",
+					"txsched", "rxflow";
+
+			qm-base-address = <0x23a80000 0x23a90000
+					   0x23aa0000 0x23ab0000>;
+		};
+	};
+
+Navigator DMA client:
+Required properties:
+- dma-id:	DMA instance number
+- rx-channel:	DMA receive channel number
+- tx-channel:	DMA transmit channel number
+
+Example:
+
+	netcp: netcp@2090000 {
+		dma-id = <0>;
+		tx-channel = <8>;
+		rx-channel = <22>;
+		...
+	};
-- 
1.7.9.5

