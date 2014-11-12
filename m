Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752530AbaKLH7E (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Nov 2014 02:59:04 -0500
Received: from mail-wg0-f43.google.com ([74.125.82.43]:60846 "EHLO
	mail-wg0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752492AbaKLH7A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Nov 2014 02:59:00 -0500
From: Tomeu Vizoso <tomeu.vizoso@collabora.com>
To: linux-tegra@vger.kernel.org
Cc: Javier Martinez Canillas <javier.martinez@collabora.co.uk>,
        mikko.perttunen@kapsi.fi, acourbot@nvidia.com,
        Tomeu Vizoso <tomeu.vizoso@collabora.com>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Thierry Reding <thierry.reding@gmail.com>,
        Alexandre Courbot <gnurou@gmail.com>, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v4 05/13] of: Document timings subnode of nvidia,tegra-mc
Date: Wed, 12 Nov 2014 08:56:28 +0100
Message-Id: <1415779051-26410-6-git-send-email-tomeu.vizoso@collabora.com>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1415779051-26410-1-git-send-email-tomeu.vizoso@collabora.com>
References: <1415779051-26410-1-git-send-email-tomeu.vizoso@collabora.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The MC driver needs some timing-specific information to program the EMEM during
a rate change of the EMC clock.

Signed-off-by: Tomeu Vizoso <tomeu.vizoso@collabora.com>

---

v4:	* Add more information about nvidia,emem-configuration
	* Remove mandatory naming of the timings subnode
	* Remove constraint on the unit-address of the timings and timing subnodes
---
 .../memory-controllers/nvidia,tegra-mc.txt         | 84 +++++++++++++++++++++-
 1 file changed, 82 insertions(+), 2 deletions(-)

diff --git a/Documentation/devicetree/bindings/memory-controllers/nvidia,tegra-mc.txt b/Documentation/devicetree/bindings/memory-controllers/nvidia,tegra-mc.txt
index f3db93c..3338a28 100644
--- a/Documentation/devicetree/bindings/memory-controllers/nvidia,tegra-mc.txt
+++ b/Documentation/devicetree/bindings/memory-controllers/nvidia,tegra-mc.txt
@@ -1,6 +1,9 @@
 NVIDIA Tegra Memory Controller device tree bindings
 ===================================================
 
+memory-controller node
+----------------------
+
 Required properties:
 - compatible: Should be "nvidia,tegra<chip>-mc"
 - reg: Physical base address and length of the controller's registers.
@@ -15,9 +18,49 @@ Required properties:
 This device implements an IOMMU that complies with the generic IOMMU binding.
 See ../iommu/iommu.txt for details.
 
-Example:
---------
+emc-timings subnode
+-------------------
+
+The node should contain a "emc-timings" subnode for each supported RAM type (see field RAM_CODE in
+register PMC_STRAPPING_OPT_A).
+
+Required properties for "emc-timings" nodes :
+- nvidia,ram-code : Should contain the value of RAM_CODE this timing set is used for.
+
+timing subnode
+--------------
+
+Each "emc-timings" node should contain a subnode for every supported EMC clock rate.
+
+Required properties for timing nodes :
+- clock-frequency : Should contain the memory clock rate in Hz.
+- nvidia,emem-configuration : Values to be written to the EMEM register block. For the Tegra124 SoC
+(see section "15.6.1 MC Registers" in the TRM), these are the registers whose values need to be
+specified, according to the board documentation:
+
+	MC_EMEM_ARB_CFG
+	MC_EMEM_ARB_OUTSTANDING_REQ
+	MC_EMEM_ARB_TIMING_RCD
+	MC_EMEM_ARB_TIMING_RP
+	MC_EMEM_ARB_TIMING_RC
+	MC_EMEM_ARB_TIMING_RAS
+	MC_EMEM_ARB_TIMING_FAW
+	MC_EMEM_ARB_TIMING_RRD
+	MC_EMEM_ARB_TIMING_RAP2PRE
+	MC_EMEM_ARB_TIMING_WAP2PRE
+	MC_EMEM_ARB_TIMING_R2R
+	MC_EMEM_ARB_TIMING_W2W
+	MC_EMEM_ARB_TIMING_R2W
+	MC_EMEM_ARB_TIMING_W2R
+	MC_EMEM_ARB_DA_TURNS
+	MC_EMEM_ARB_DA_COVERS
+	MC_EMEM_ARB_MISC0
+	MC_EMEM_ARB_MISC1
+	MC_EMEM_ARB_RING1_THROTTLE
 
+Example SoC include file:
+
+/ {
 	mc: memory-controller@0,70019000 {
 		compatible = "nvidia,tegra124-mc";
 		reg = <0x0 0x70019000 0x0 0x1000>;
@@ -34,3 +77,40 @@ Example:
 		...
 		iommus = <&mc TEGRA_SWGROUP_SDMMC1A>;
 	};
+};
+
+Example board file:
+
+/ {
+	memory-controller@0,70019000 {
+		emc-timings-3 {
+			nvidia,ram-code = <3>;
+
+			timing-12750000 {
+				clock-frequency = <12750000>;
+
+				nvidia,emem-configuration = <
+					0x40040001 /* MC_EMEM_ARB_CFG */
+					0x8000000a /* MC_EMEM_ARB_OUTSTANDING_REQ */
+					0x00000001 /* MC_EMEM_ARB_TIMING_RCD */
+					0x00000001 /* MC_EMEM_ARB_TIMING_RP */
+					0x00000002 /* MC_EMEM_ARB_TIMING_RC */
+					0x00000000 /* MC_EMEM_ARB_TIMING_RAS */
+					0x00000002 /* MC_EMEM_ARB_TIMING_FAW */
+					0x00000001 /* MC_EMEM_ARB_TIMING_RRD */
+					0x00000002 /* MC_EMEM_ARB_TIMING_RAP2PRE */
+					0x00000008 /* MC_EMEM_ARB_TIMING_WAP2PRE */
+					0x00000003 /* MC_EMEM_ARB_TIMING_R2R */
+					0x00000002 /* MC_EMEM_ARB_TIMING_W2W */
+					0x00000003 /* MC_EMEM_ARB_TIMING_R2W */
+					0x00000006 /* MC_EMEM_ARB_TIMING_W2R */
+					0x06030203 /* MC_EMEM_ARB_DA_TURNS */
+					0x000a0402 /* MC_EMEM_ARB_DA_COVERS */
+					0x77e30303 /* MC_EMEM_ARB_MISC0 */
+					0x70000f03 /* MC_EMEM_ARB_MISC1 */
+					0x001f0000 /* MC_EMEM_ARB_RING1_THROTTLE */
+				>;
+			};
+		};
+	};
+};
-- 
1.9.3

