Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751735AbaC1MEE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Mar 2014 08:04:04 -0400
Received: from mail-ig0-f181.google.com ([209.85.213.181]:53860 "EHLO
	mail-ig0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751602AbaC1MD5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Mar 2014 08:03:57 -0400
From: Srikanth Thokala <sthokal@xilinx.com>
To: dan.j.williams@intel.com, vinod.koul@intel.com, michal.simek@xilinx.com,
        grant.likely@linaro.org, robh+dt@kernel.org
Cc: levex@linux.com, lars@metafoo.de, andriy.shevchenko@linux.intel.com,
        jaswinder.singh@linaro.org, dmaengine@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Srikanth Thokala <sthokal@xilinx.com>
Subject: [PATCH v7 1/2] dma: Add Xilinx Video DMA DT Binding Documentation
Date: Fri, 28 Mar 2014 17:33:41 +0530
Message-Id: <1396008222-7058-2-git-send-email-sthokal@xilinx.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1396008222-7058-1-git-send-email-sthokal@xilinx.com>
References: <1396008222-7058-1-git-send-email-sthokal@xilinx.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Device-tree binding documentation of Xilinx Video DMA Engine

Signed-off-by: Srikanth Thokala <sthokal@xilinx.com>
---
Changes in v7:
None

Changes in v6:
None

Changes in v5:
None

Changes in v4:
None

Changes in v3:
None

Changes in v2:
- Removed device-id DT property, as suggested by Arnd Bergmann
- Properly documented DT bindings as suggested by Arnd Bergmann
---
 .../devicetree/bindings/dma/xilinx/xilinx_vdma.txt |   75 ++++++++++++++++++++
 1 file changed, 75 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/dma/xilinx/xilinx_vdma.txt

diff --git a/Documentation/devicetree/bindings/dma/xilinx/xilinx_vdma.txt b/Documentation/devicetree/bindings/dma/xilinx/xilinx_vdma.txt
new file mode 100644
index 0000000..ab8be1a
--- /dev/null
+++ b/Documentation/devicetree/bindings/dma/xilinx/xilinx_vdma.txt
@@ -0,0 +1,75 @@
+Xilinx AXI VDMA engine, it does transfers between memory and video devices.
+It can be configured to have one channel or two channels. If configured
+as two channels, one is to transmit to the video device and another is
+to receive from the video device.
+
+Required properties:
+- compatible: Should be "xlnx,axi-vdma-1.00.a"
+- #dma-cells: Should be <1>, see "dmas" property below
+- reg: Should contain VDMA registers location and length.
+- xlnx,num-fstores: Should be the number of framebuffers as configured in h/w.
+- dma-channel child node: Should have atleast one channel and can have upto
+	two channels per device. This node specifies the properties of each
+	DMA channel (see child node properties below).
+
+Optional properties:
+- xlnx,include-sg: Tells whether configured for Scatter-mode in
+	the hardware.
+- xlnx,flush-fsync: Tells whether which channel to Flush on Frame sync.
+	It takes following values:
+	{1}, flush both channels
+	{2}, flush mm2s channel
+	{3}, flush s2mm channel
+
+Required child node properties:
+- compatible: It should be either "xlnx,axi-vdma-mm2s-channel" or
+	"xlnx,axi-vdma-s2mm-channel".
+- interrupts: Should contain per channel VDMA interrupts.
+- xlnx,data-width: Should contain the stream data width, take values
+	{32,64...1024}.
+
+Option child node properties:
+- xlnx,include-dre: Tells whether hardware is configured for Data
+	Realignment Engine.
+- xlnx,genlock-mode: Tells whether Genlock synchronization is
+	enabled/disabled in hardware.
+
+Example:
+++++++++
+
+axi_vdma_0: axivdma@40030000 {
+	compatible = "xlnx,axi-vdma-1.00.a";
+	#dma_cells = <1>;
+	reg = < 0x40030000 0x10000 >;
+	xlnx,num-fstores = <0x8>;
+	xlnx,flush-fsync = <0x1>;
+	dma-channel@40030000 {
+		compatible = "xlnx,axi-vdma-mm2s-channel";
+		interrupts = < 0 54 4 >;
+		xlnx,datawidth = <0x40>;
+	} ;
+	dma-channel@40030030 {
+		compatible = "xlnx,axi-vdma-s2mm-channel";
+		interrupts = < 0 53 4 >;
+		xlnx,datawidth = <0x40>;
+	} ;
+} ;
+
+
+* DMA client
+
+Required properties:
+- dmas: a list of <[Video DMA device phandle] [Channel ID]> pairs,
+	where Channel ID is '0' for write/tx and '1' for read/rx
+	channel.
+- dma-names: a list of DMA channel names, one per "dmas" entry
+
+Example:
+++++++++
+
+vdmatest_0: vdmatest@0 {
+	compatible ="xlnx,axi-vdma-test-1.00.a";
+	dmas = <&axi_vdma_0 0
+		&axi_vdma_0 1>;
+	dma-names = "vdma0", "vdma1";
+} ;
-- 
1.7.9.5

