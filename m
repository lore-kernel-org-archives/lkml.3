Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755339AbaJUOro (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Oct 2014 10:47:44 -0400
Received: from mail-wi0-f175.google.com ([209.85.212.175]:61315 "EHLO
	mail-wi0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755406AbaJUOrk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Oct 2014 10:47:40 -0400
From: Tomeu Vizoso <tomeu.vizoso@collabora.com>
To: linux-tegra@vger.kernel.org
Cc: Javier Martinez Canillas <javier.martinez@collabora.co.uk>,
        Tomeu Vizoso <tomeu.vizoso@collabora.com>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Thierry Reding <thierry.reding@gmail.com>,
        Alexandre Courbot <gnurou@gmail.com>, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2 05/12] of: Document timings subnode of nvidia,tegra-mc
Date: Tue, 21 Oct 2014 16:45:37 +0200
Message-Id: <1413902788-7727-6-git-send-email-tomeu.vizoso@collabora.com>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1413902788-7727-1-git-send-email-tomeu.vizoso@collabora.com>
References: <1413902788-7727-1-git-send-email-tomeu.vizoso@collabora.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The MC driver needs some timing-specific information to program the EMEM during
a rate change of the EMC clock.

Signed-off-by: Tomeu Vizoso <tomeu.vizoso@collabora.com>
---
 .../memory-controllers/nvidia,tegra-mc.txt         | 46 +++++++++++++++++++++-
 1 file changed, 44 insertions(+), 2 deletions(-)

diff --git a/Documentation/devicetree/bindings/memory-controllers/nvidia,tegra-mc.txt b/Documentation/devicetree/bindings/memory-controllers/nvidia,tegra-mc.txt
index f3db93c..8467b8c 100644
--- a/Documentation/devicetree/bindings/memory-controllers/nvidia,tegra-mc.txt
+++ b/Documentation/devicetree/bindings/memory-controllers/nvidia,tegra-mc.txt
@@ -15,9 +15,26 @@ Required properties:
 This device implements an IOMMU that complies with the generic IOMMU binding.
 See ../iommu/iommu.txt for details.
 
-Example:
---------
+The node should contain a "timings" subnode for each supported RAM type (see
+field RAM_CODE in register PMC_STRAPPING_OPT_A), with its unit address being its
+RAM_CODE.
 
+Required properties for "timings" nodes :
+- nvidia,ram-code : Should contain the value of RAM_CODE this timing set is used
+for.
+
+Each "timings" node should contain a "timing" subnode for every supported EMC
+clock rate. The "timing" subnodes should have the clock rate in Hz as their unit
+address.
+
+Required properties for "timing" nodes :
+- clock-frequency : Should contain the memory clock rate in Hz.
+- nvidia,emem-configuration : Values to be written to the EMEM register block,
+as specified by the board documentation.
+
+Example SoC include file:
+
+/ {
 	mc: memory-controller@0,70019000 {
 		compatible = "nvidia,tegra124-mc";
 		reg = <0x0 0x70019000 0x0 0x1000>;
@@ -34,3 +51,28 @@ Example:
 		...
 		iommus = <&mc TEGRA_SWGROUP_SDMMC1A>;
 	};
+};
+
+Example board file:
+
+/ {
+	memory-controller@0,70019000 {
+		timings@3 {
+			nvidia,ram-code = <3>;
+
+			timing@12750000 {
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
+				>;
+			};
+		};
+	};
+};
-- 
1.9.3

