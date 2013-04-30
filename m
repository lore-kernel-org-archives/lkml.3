Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758980Ab3D3HLa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Apr 2013 03:11:30 -0400
Received: from moutng.kundenserver.de ([212.227.126.187]:63301 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758616Ab3D3HL1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Apr 2013 03:11:27 -0400
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: linux-sh@vger.kernel.org
Cc: Magnus Damm <magnus.damm@gmail.com>, Arnd Bergmann <arnd@arndb.de>,
        Vinod Koul <vinod.koul@intel.com>, Tony Lindgren <tony@atomide.com>,
        devicetree-discuss@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        Guennadi Liakhovetski <g.liakhovetski+renesas@gmail.com>
Subject: [PATCH 3/4] ARM: shmobile: move r8a7740 DMA controller DT node under a "dma-mux" node
Date: Tue, 30 Apr 2013 09:11:22 +0200
Message-Id: <1367305883-2997-4-git-send-email-g.liakhovetski@gmx.de>
X-Mailer: git-send-email 1.7.2.5
In-Reply-To: <1367305883-2997-1-git-send-email-g.liakhovetski@gmx.de>
References: <1367305883-2997-1-git-send-email-g.liakhovetski@gmx.de>
X-Provags-ID: V02:K0:kHnC8CRrDqQPjIjC7UZzexo9ZCEpr0YLb/aanKVy3Mu
 GVrN8iZQmv23xDvW8c5XOS8wu9uXEMV/jZuonvU8Drn49fL99f
 Xq6a6ro1vUT2KDqD9Ipcaj9AmN5n6xHQmOfqm1XX9tUjQ0a01/
 asNQrNL70zDgvKpDJXll7Pbwd8J/HTWO5uJLJBU7Yix8m082yq
 Id8f5m+H9UukjzuqnylUrx634EFh3cCgixFDVRiKaUhFHKMPeR
 CmxzfE94S6Hr92hebWzUrXiFsGMNb6B3CM/fHBYALUBZr5nbP2
 J59g9hV1YVIj+EuUm9C9EUR9Jdk0AVmh4RwKV4x/0CCrk+4cil
 Q0laFWgy6hYam9nM5eJpLxm64ibrYOrjv6foqHAVm3rzOVqmiN
 em3tAXt6oOrRA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On r8a7740 multiple DMA controllers can serve the same slaves with the
same DMA slave IDs. To use this feature DMA controller DT nodes have
to be grouped under "dma-mux" multiplexer nodes and slaves have to be
modified to reference multiplexer nodes instead of individual DMA DT
nodes. Future patches shall add further DMA controller DT nodes under
the same DMA multiplexer DT node.

Signed-off-by: Guennadi Liakhovetski <g.liakhovetski+renesas@gmail.com>
---

Applies on top of my earlier "ARM: shmobile: r8a7740: add DT node for one 
DMAC instance" patch still under review.

 .../boot/dts/r8a7740-armadillo800eva-reference.dts |   12 +++---
 arch/arm/boot/dts/r8a7740.dtsi                     |   43 +++++++++++--------
 2 files changed, 31 insertions(+), 24 deletions(-)

diff --git a/arch/arm/boot/dts/r8a7740-armadillo800eva-reference.dts b/arch/arm/boot/dts/r8a7740-armadillo800eva-reference.dts
index c201445..1983d49 100644
--- a/arch/arm/boot/dts/r8a7740-armadillo800eva-reference.dts
+++ b/arch/arm/boot/dts/r8a7740-armadillo800eva-reference.dts
@@ -47,8 +47,8 @@
 	vmmc-supply = <&reg_3p3v>;
 	bus-width = <8>;
 	non-removable;
-	dmas = <&dma0 0xd1
-		&dma0 0xd2>;
+	dmas = <&dmac 0xd1
+		&dmac 0xd2>;
 	dma-names = "tx", "rx";
 	status = "okay";
 };
@@ -57,8 +57,8 @@
 	vmmc-supply = <&reg_3p3v>;
 	bus-width = <4>;
 	broken-cd;
-	dmas = <&dma0 0xc1
-		&dma0 0xc2>;
+	dmas = <&dmac 0xc1
+		&dmac 0xc2>;
 	dma-names = "tx", "rx";
 	status = "okay";
 };
@@ -66,8 +66,8 @@
 &sdhi1 {
 	vmmc-supply = <&reg_3p3v>;
 	bus-width = <4>;
-	dmas = <&dma0 0xc9
-		&dma0 0xca>;
+	dmas = <&dmac 0xc9
+		&dmac 0xca>;
 	dma-names = "tx", "rx";
 	status = "okay";
 };
diff --git a/arch/arm/boot/dts/r8a7740.dtsi b/arch/arm/boot/dts/r8a7740.dtsi
index 054bc1a..965ca4c 100644
--- a/arch/arm/boot/dts/r8a7740.dtsi
+++ b/arch/arm/boot/dts/r8a7740.dtsi
@@ -112,24 +112,31 @@
 			      0 149 0x4>;
 	};
 
-	dma0: shdma@fe008020 {
-		compatible = "renesas,shdma";
-		reg = <0xfe008020 0x270
-			0xfe009000 0xc>;
-		interrupt-parent = <&gic>;
-		interrupts = <0 34 4
-				0 28 4
-				0 29 4
-				0 30 4
-				0 31 4
-				0 32 4
-				0 33 4>;
-		interrupt-names = "error",
-				"ch0", "ch1", "ch2", "ch3",
-				"ch4", "ch5";
-		#dma-cells = <1>;
-		dma-channels = <6>;
-		dma-requests = <256>;
+	dmac: dma-mux0 {
+		compatible = "simple-bus", "dma-mux";
+		#address-cells = <1>;
+		#size-cells = <1>;
+		ranges;
+
+		dma0: shdma@fe008020 {
+			compatible = "renesas,shdma";
+			reg = <0xfe008020 0x270>,
+				<0xfe009000 0xc>;
+			interrupt-parent = <&gic>;
+			interrupts = <0 34 4
+					0 28 4
+					0 29 4
+					0 30 4
+					0 31 4
+					0 32 4
+					0 33 4>;
+			interrupt-names = "error",
+					"ch0", "ch1", "ch2", "ch3",
+					"ch4", "ch5";
+			#dma-cells = <1>;
+			dma-channels = <6>;
+			dma-requests = <256>;
+		};
 	};
 
 	i2c0: i2c@fff20000 {
-- 
1.7.2.5

