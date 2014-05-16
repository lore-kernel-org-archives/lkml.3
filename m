Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932328AbaEPMZb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 May 2014 08:25:31 -0400
Received: from mail-ee0-f45.google.com ([74.125.83.45]:53416 "EHLO
	mail-ee0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754537AbaEPMZ2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 May 2014 08:25:28 -0400
From: Thierry Reding <thierry.reding@gmail.com>
To: Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>
Cc: Arnd Bergmann <arnd@arndb.de>, Cho KyongHo <pullip.cho@samsung.com>,
        Grant Grundler <grundler@chromium.org>,
        Dave Martin <Dave.Martin@arm.com>, Marc Zyngier <marc.zyngier@arm.com>,
        Will Deacon <will.deacon@arm.com>, Joerg Roedel <joro@8bytes.org>,
        Stephen Warren <swarren@wwwdotorg.org>, devicetree@vger.kernel.org,
        iommu@lists.linux-foundation.org, linux-arm-kernel@lists.infradead.org,
        linux-tegra@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] devicetree: Add generic IOMMU device tree bindings
Date: Fri, 16 May 2014 14:23:18 +0200
Message-Id: <1400242998-437-1-git-send-email-thierry.reding@gmail.com>
X-Mailer: git-send-email 1.9.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Thierry Reding <treding@nvidia.com>

This commit introduces a generic device tree binding for IOMMU devices.
Only a very minimal subset is described here, but it is enough to cover
the requirements of both the Exynos System MMU and Tegra SMMU as
discussed here:

    https://lkml.org/lkml/2014/4/27/346

More advanced functionality such as the dma-ranges property can easily
be added in a backwards-compatible way. In the absence of a dma-ranges
property it should be safe to default to the whole address space.

Signed-off-by: Thierry Reding <treding@nvidia.com>
---
 Documentation/devicetree/bindings/iommu/iommu.txt | 109 ++++++++++++++++++++++
 1 file changed, 109 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/iommu/iommu.txt

diff --git a/Documentation/devicetree/bindings/iommu/iommu.txt b/Documentation/devicetree/bindings/iommu/iommu.txt
new file mode 100644
index 000000000000..2d67b52b656e
--- /dev/null
+++ b/Documentation/devicetree/bindings/iommu/iommu.txt
@@ -0,0 +1,109 @@
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
+Required properties:
+--------------------
+- #iommu-cells: The number of cells in an IOMMU specifier. The meaning of the
+  cells is defined by the binding for the IOMMU device.
+
+  Typical values include:
+  * 0: Single-master IOMMU devices are often not configurable, therefore the
+    specifying doesn't need to encode any information and can be empty.
+
+  * 1: Multiple-master IOMMU devices need to know for which master they should
+    enable translation. Typically the single cell in the specifier corresponds
+    to the master device's ID.
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
+Optional properties:
+--------------------
+- iommu-names: A list of names identifying each entry in the iommus property.
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
+		iommu = <&/iommu>;
+	};
+
+Multi-master IOMMU:
+-------------------
+
+	iommu {
+		/* the specifier represents the ID of the master */
+		#iommu-cells = <1>;
+	};
+
+	master {
+		/* device has master ID 42 in the IOMMU */
+		iommu = <&/iommu 42>;
+	};
+
+Multi-master device:
+--------------------
+
+	/* single-master IOMMU */
+	iommu@1 {
+		#iommu-cells = <0>;
+	};
+
+	/* multi-master IOMMU */
+	iommu@2 {
+		/* the specifier represents the ID of the master */
+		#iommu-cells = <1>;
+	};
+
+	/* device with two master interfaces */
+	master {
+		iommus = <&/iommu@1>,    /* master of the single-master IOMMU */
+			 <&/iommu@2 42>; /* ID 42 in multi-master IOMMU */
+	};
-- 
1.9.2

