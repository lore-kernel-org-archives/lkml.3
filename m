Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752882AbaFEPX0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jun 2014 11:23:26 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:52524 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752320AbaFEPXW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jun 2014 11:23:22 -0400
From: Santosh Shilimkar <santosh.shilimkar@ti.com>
To: <linux-kernel@vger.kernel.org>
CC: <linux-arm-kernel@lists.infradead.org>, <devicetree@vger.kernel.org>,
        <grygorii.strashko@ti.com>, <linux@arm.linux.org.uk>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>,
        Arnd Bergmann <arnd@arndb.de>, Grant Likely <grant.likely@linaro.org>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Shawn Guo <shawn.guo@freescale.com>, Kumar Gala <galak@codeaurora.org>
Subject: [PATCH] dt/documentation: add specification of dma bus information
Date: Thu, 5 Jun 2014 11:22:00 -0400
Message-ID: <1401981720-6946-1-git-send-email-santosh.shilimkar@ti.com>
X-Mailer: git-send-email 1.7.9.5
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Recently we introduced the generic device tree infrastructure for couple of DMA
bus parameter, dma-ranges and dma-coherent. Update the documentation so that
its useful for future users.

The "dma-ranges" property is intended to be used for describing the
configuration of DMA bus RAM addresses and its offset w.r.t CPU addresses.

The "dma-coherent" property is intended to be used for identifying devices
supported coherent DMA operations.

Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Grant Likely <grant.likely@linaro.org>
Cc: Rob Herring <robh+dt@kernel.org>
Cc: Pawel Moll <pawel.moll@arm.com>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Ian Campbell <ijc+devicetree@hellion.org.uk>
Cc: Shawn Guo <shawn.guo@freescale.com>
Cc: Kumar Gala <galak@codeaurora.org>
Signed-off-by: Grygorii Strashko <grygorii.strashko@ti.com>
Signed-off-by: Santosh Shilimkar <santosh.shilimkar@ti.com>
---
 Documentation/devicetree/booting-without-of.txt |   60 +++++++++++++++++++++++
 1 file changed, 60 insertions(+)

diff --git a/Documentation/devicetree/booting-without-of.txt b/Documentation/devicetree/booting-without-of.txt
index 1f013bd..f0120c1 100644
--- a/Documentation/devicetree/booting-without-of.txt
+++ b/Documentation/devicetree/booting-without-of.txt
@@ -51,6 +51,8 @@ Table of Contents
 
   VIII - Specifying device power management information (sleep property)
 
+  VIV - Specifying dma bus information
+
   Appendix A - Sample SOC node for MPC8540
 
 
@@ -1332,6 +1334,64 @@ reasonably grouped in this manner, then create a virtual sleep controller
 (similar to an interrupt nexus, except that defining a standardized
 sleep-map should wait until its necessity is demonstrated).
 
+VIV - Specifying dma bus information
+
+Some devices may have DMA memory range shifted relatively to the beginning of
+RAM, or even placed outside of kernel RAM. For example, the Keystone 2 SoC
+worked in LPAE mode with 4G memory has:
+- RAM range: [0x8 0000 0000, 0x8 FFFF FFFF]
+- DMA range: [  0x8000 0000,   0xFFFF FFFF]
+and DMA range is aliased into first 2G of RAM in HW.
+
+In such cases, DMA addresses translation should be performed between CPU phys
+and DMA addresses. The "dma-ranges" property is intended to be used
+for describing the configuration of such system in DT.
+
+In addition, each DMA master device on the DMA bus may or may not support
+coherent DMA operations. The "dma-coherent" property is intended to be used
+for identifying devices supported coherent DMA operations in DT.
+
+* DMA Bus master
+Optional property:
+- dma-ranges: <prop-encoded-array> encoded as arbitrary number of triplets of
+	(child-bus-address, parent-bus-address, length). Each triplet specified
+	describes a contiguous DMA address range.
+	The dma-ranges property is used to describe the direct memory access (DMA)
+	structure of a memory-mapped bus whose device tree parent can be accessed
+	from DMA operations originating from the bus. It provides a means of
+	defining a mapping or translation between the physical address space of
+	the bus and the physical address space of the parent of the bus.
+	(for more information see ePAPR specification)
+
+* DMA Bus child
+Optional property:
+- dma-ranges: <empty> value. if present - It means that DMA addresses
+	translation has to be enabled for this device.
+- dma-coherent: Present if dma operations are coherent
+
+Example:
+soc {
+		compatible = "ti,keystone","simple-bus";
+		ranges = <0x0 0x0 0x0 0xc0000000>;
+		dma-ranges = <0x80000000 0x8 0x00000000 0x80000000>;
+
+		[...]
+
+		usb: usb@2680000 {
+			compatible = "ti,keystone-dwc3";
+
+			[...]
+
+			dma-coherent;
+			dma-ranges;
+
+			dwc3@2690000 {
+				compatible = "synopsys,dwc3";
+				[...]
+			};
+		};
+};
+
 Appendix A - Sample SOC node for MPC8540
 ========================================
 
-- 
1.7.9.5

