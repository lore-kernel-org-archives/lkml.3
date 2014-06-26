Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752342AbaFZUwz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jun 2014 16:52:55 -0400
Received: from mail-wg0-f50.google.com ([74.125.82.50]:44970 "EHLO
	mail-wg0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751622AbaFZUt7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jun 2014 16:49:59 -0400
From: Thierry Reding <thierry.reding@gmail.com>
To: Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Stephen Warren <swarren@wwwdotorg.org>, Arnd Bergmann <arnd@arndb.de>,
        Will Deacon <will.deacon@arm.com>, Joerg Roedel <joro@8bytes.org>
Cc: Cho KyongHo <pullip.cho@samsung.com>,
        Grant Grundler <grundler@chromium.org>,
        Dave Martin <Dave.Martin@arm.com>, Marc Zyngier <marc.zyngier@arm.com>,
        Hiroshi Doyu <hdoyu@nvidia.com>, Olav Haugan <ohaugan@codeaurora.org>,
        Paul Walmsley <pwalmsley@nvidia.com>,
        Rhyland Klein <rklein@nvidia.com>, Allen Martin <amartin@nvidia.com>,
        devicetree@vger.kernel.org, iommu@lists.linux-foundation.org,
        linux-arm-kernel@lists.infradead.org, linux-tegra@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v3 02/10] devicetree: Add generic IOMMU device tree bindings
Date: Thu, 26 Jun 2014 22:49:42 +0200
Message-Id: <1403815790-8548-3-git-send-email-thierry.reding@gmail.com>
X-Mailer: git-send-email 2.0.0
In-Reply-To: <1403815790-8548-1-git-send-email-thierry.reding@gmail.com>
References: <1403815790-8548-1-git-send-email-thierry.reding@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Thierry Reding <treding@nvidia.com>

This commit introduces a generic device tree binding for IOMMU devices.
Only a very minimal subset is described here, but it is enough to cover
the requirements of both the Exynos System MMU and Tegra SMMU as
discussed here:

    https://lkml.org/lkml/2014/4/27/346

Signed-off-by: Thierry Reding <treding@nvidia.com>
---
Changes in v3:
- use #iommu-cells instead of #address-cells/#size-cells
- drop optional iommu-names property

Changes in v2:
- add notes about "dma-ranges" property (drop note from commit message)
- document priorities of "iommus" property vs. "dma-ranges" property
- drop #iommu-cells in favour of #address-cells and #size-cells
- remove multiple-master device example

 Documentation/devicetree/bindings/iommu/iommu.txt | 156 ++++++++++++++++++++++
 1 file changed, 156 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/iommu/iommu.txt

diff --git a/Documentation/devicetree/bindings/iommu/iommu.txt b/Documentation/devicetree/bindings/iommu/iommu.txt
new file mode 100644
index 000000000000..f8f03f057156
--- /dev/null
+++ b/Documentation/devicetree/bindings/iommu/iommu.txt
@@ -0,0 +1,156 @@
+This document describes the generic device tree binding for IOMMUs and their
+master(s).
+
+
+IOMMU device node:
+==================
+
+An IOMMU can provide the following services:
+
+* Remap address space to allow devices to access physical memory ranges that
+  they otherwise wouldn't be capable of accessing.
+
+  Example: 32-bit DMA to 64-bit physical addresses
+
+* Implement scatter-gather at page level granularity so that the device does
+  not have to.
+
+* Provide system protection against "rogue" DMA by forcing all accesses to go
+  through the IOMMU and faulting when encountering accesses to unmapped
+  address regions.
+
+* Provide address space isolation between multiple contexts.
+
+  Example: Virtualization
+
+Device nodes compatible with this binding represent hardware with some of the
+above capabilities.
+
+IOMMUs can be single-master or multiple-master. Single-master IOMMU devices
+typically have a fixed association to the master device, whereas multiple-
+master IOMMU devices can translate accesses from more than one master.
+
+The device tree node of the IOMMU device's parent bus must contain a valid
+"dma-ranges" property that describes how the physical address space of the
+IOMMU maps to memory. An empty "dma-ranges" property means that there is a
+1:1 mapping from IOMMU to memory.
+
+Required properties:
+--------------------
+- #iommu-cells: The number of cells in an IOMMU specifier needed to encode an
+  address.
+
+Typical values for the above include:
+- #iommu-cells = <0>: Single master IOMMU devices are not configurable and
+  therefore no additional information needs to be encoded in the specifier.
+  This may also apply to multiple master IOMMU devices that do not allow the
+  association of masters to be configured.
+- #iommu-cells = <1>: Multiple master IOMMU devices may need to be configured
+  in order to enable translation for a given master. In such cases the single
+  address cell corresponds to the master device's ID.
+- #iommu-cells = <4>: Some IOMMU devices allow the DMA window for masters to
+  be configured. The first cell of the address in this may contain the master
+  device's ID for example, while the second cell could contain the start of
+  the DMA window for the given device. The length of the DMA window is given
+  by the third and fourth cells.
+
+
+IOMMU master node:
+==================
+
+Devices that access memory through an IOMMU are called masters. A device can
+have multiple master interfaces (to one or more IOMMU devices).
+
+Required properties:
+--------------------
+- iommus: A list of phandle and IOMMU specifier pairs that describe the IOMMU
+  master interfaces of the device. One entry in the list describes one master
+  interface of the device.
+
+When an "iommus" property is specified in a device tree node, the IOMMU will
+be used for address translation. If a "dma-ranges" property exists in the
+device's parent node it will be ignored. An exception to this rule is if the
+referenced IOMMU is disabled, in which case the "dma-ranges" property of the
+parent shall take effect.
+
+
+Notes:
+======
+
+One possible extension to the above is to use an "iommus" property along with
+a "dma-ranges" property in a bus device node (such as PCI host bridges). This
+can be useful to describe how children on the bus relate to the IOMMU if they
+are not explicitly listed in the device tree (e.g. PCI devices). However, the
+requirements of that use-case haven't been fully determined yet. Implementing
+this is therefore not recommended without further discussion and extension of
+this binding.
+
+
+Examples:
+=========
+
+Single-master IOMMU:
+--------------------
+
+	iommu {
+		#iommu-cells = <0>;
+	};
+
+	master {
+		iommus = <&/iommu>;
+	};
+
+Multiple-master IOMMU with fixed associations:
+----------------------------------------------
+
+	/* multiple-master IOMMU */
+	iommu {
+		/*
+		 * Masters are statically associated with this IOMMU and
+		 * address translation is always enabled.
+		 */
+		#iommu-cells = <0>;
+	};
+
+	/* static association with IOMMU */
+	master@1 {
+		reg = <1>;
+		iommus = <&/iommu>;
+	};
+
+	/* static association with IOMMU */
+	master@2 {
+		reg = <2>;
+		iommus = <&/iommu>;
+	};
+
+Multiple-master IOMMU:
+----------------------
+
+	iommu {
+		/* the specifier represents the ID of the master */
+		#iommu-cells = <1>;
+	};
+
+	master {
+		/* device has master ID 42 in the IOMMU */
+		iommus = <&/iommu 42>;
+	};
+
+Multiple-master IOMMU with configurable DMA window:
+---------------------------------------------------
+
+	/ {
+		#address-cells = <1>;
+		#size-cells = <1>;
+
+		iommu {
+			/* master ID, address and length of DMA window */
+			#iommu-cells = <4>;
+		};
+
+		master {
+			/* master ID 42, 4 GiB DMA window starting at 0 */
+			iommus = <&/iommu  42  0  0x1 0x0>;
+		};
+	};
-- 
2.0.0

