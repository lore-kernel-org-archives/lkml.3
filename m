Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932344Ab3FQIK3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Jun 2013 04:10:29 -0400
Received: from co9ehsobe003.messaging.microsoft.com ([207.46.163.26]:46311
	"EHLO co9outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755122Ab3FQIKX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Jun 2013 04:10:23 -0400
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: 3
X-BigFish: VS3(zzc8kzz1f42h1ee6h1de0h1fdah1202h1e76h1d1ah1d2ah1fc6hzz8275bhz2dh2a8h668h839hd24he5bhf0ah1288h12a5h12a9h12bdh12e5h1354h137ah139eh13b6h1441h1504h1537h162dh1631h1758h1898h18e1h1946h19b5h1ad9h1b0ah1d0ch1d2eh1d3fh1dfeh1dffh1e23h1155h)
From: <akhil.goyal@freescale.com>
To: <gregkh@linuxfoundation.org>, <arnd@arndb.de>
CC: <linux-kernel@vger.kernel.org>, <pankaj.chauhan@freescale.com>,
        Akhil Goyal <akhil.goyal@freescale.com>
Subject: [PATCH 5/5] BSC9131rdb/dts: Add nodes for supporting AIC and AD PHY
Date: Mon, 17 Jun 2013 13:39:26 +0530
Message-ID: <1371456566-4934-6-git-send-email-akhil.goyal@freescale.com>
X-Mailer: git-send-email 1.6.3.1
In-Reply-To: <1371456566-4934-5-git-send-email-akhil.goyal@freescale.com>
References: <1371456566-4934-1-git-send-email-akhil.goyal@freescale.com>
 <1371456566-4934-2-git-send-email-akhil.goyal@freescale.com>
 <1371456566-4934-3-git-send-email-akhil.goyal@freescale.com>
 <1371456566-4934-4-git-send-email-akhil.goyal@freescale.com>
 <1371456566-4934-5-git-send-email-akhil.goyal@freescale.com>
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Akhil Goyal <akhil.goyal@freescale.com>

BSC9131 is a hetrogenous system where Antenna interface controller
(AIC) is a part of DSP subsystem. But its configuration is done from
PA side. So a DSP node is added with appropriate CCSR address visible
to PA and hence the address space for AIC will be visible to PA.

BSC9131 support 3 AIC lanes for ADI interface and 3 for MAXIM type of
interface. This patch support only ADI lanes.

This patch also provide node for rfphy which includes control gpios
for RFIC and various SPI parameters required for accessing the ADI
phy registers. ADI chip is connected to espi-1 and control gpios
are controlled by gpio-0 and gpio-1

Currently on BSC9131, the DTS support only one rfphy and it is
attached to AIC lane 3 for LTE and WCDMA networks.

Signed-off-by: Pankaj Chauhan <pankaj.chauhan@freescale.com>
Signed-off-by: Shaveta Leekha <shaveta@freescale.com>
Signed-off-by: Bhaskar Upadhaya <bhaskar.upadhaya@freescale.com>
Signed-off-by: Akhil Goyal <akhil.goyal@freescale.com>
---
 arch/powerpc/boot/dts/bsc9131rdb.dts          |    4 ++
 arch/powerpc/boot/dts/bsc9131rdb.dtsi         |   38 ++++++++++++++++++
 arch/powerpc/boot/dts/fsl/bsc9131si-post.dtsi |   53 +++++++++++++++++++++++-
 arch/powerpc/boot/dts/fsl/pq3-espi-0.dtsi     |    1 +
 arch/powerpc/boot/dts/fsl/pq3-espi-1.dtsi     |   42 +++++++++++++++++++
 arch/powerpc/boot/dts/fsl/pq3-gpio-0.dtsi     |    1 +
 arch/powerpc/boot/dts/fsl/pq3-gpio-1.dtsi     |   42 +++++++++++++++++++
 7 files changed, 178 insertions(+), 3 deletions(-)
 create mode 100644 arch/powerpc/boot/dts/fsl/pq3-espi-1.dtsi
 create mode 100644 arch/powerpc/boot/dts/fsl/pq3-gpio-1.dtsi

diff --git a/arch/powerpc/boot/dts/bsc9131rdb.dts b/arch/powerpc/boot/dts/bsc9131rdb.dts
index e13d2d4..c134de7 100644
--- a/arch/powerpc/boot/dts/bsc9131rdb.dts
+++ b/arch/powerpc/boot/dts/bsc9131rdb.dts
@@ -28,6 +28,10 @@
 	board_soc: soc: soc@ff700000 {
 		ranges = <0x0 0x0 0xff700000 0x100000>;
 	};
+
+	dsp_soc: sc3850@ff600000 {
+		ranges = <0x0 0x0 0xff600000 0x100000>;
+	};
 };
 
 /include/ "bsc9131rdb.dtsi"
diff --git a/arch/powerpc/boot/dts/bsc9131rdb.dtsi b/arch/powerpc/boot/dts/bsc9131rdb.dtsi
index 9e6c013..dcf5d85 100644
--- a/arch/powerpc/boot/dts/bsc9131rdb.dtsi
+++ b/arch/powerpc/boot/dts/bsc9131rdb.dtsi
@@ -110,6 +110,36 @@
 		};
 	};
 
+	spi@6000 {
+		rfphy0: ad9361-phy@0{
+			compatible = "adi,ad9361";
+			reg = <0>;
+			spi-max-frequency = <20000000>;
+			spi-cpha;
+			fsl,ad9361-gpios = <&gpio1 2 1 &gpio0 18 1 &gpio0 17 1>;
+			fsl,ad9361-band-grp1 {
+				fsl,ad9361-bands = <1 7>;
+				fsl,ad9361-sniff-bands = <>;
+			};
+			fsl,ad9361-band-grp2 {
+				fsl,ad9361-lna;
+				fsl,ad9361-bands= <41>;
+				fsl,ad9361-sniff-bands = <13>;
+			};
+			fsl,ad9361-band-grp3 {
+				fsl,ad9361-pa;
+				fsl,ad9361-bands = <>;
+				fsl,ad9361-sniff-bands = <1 7>;
+			};
+			fsl,ad9361-band-grp4 {
+				fsl,ad9361-pa;
+				fsl,ad9361-lna;
+				fsl,ad9361-bands = <13 40>;
+				fsl,ad9361-sniff-bands = <>;
+			};
+		};
+	};
+
 	usb@22000 {
 		phy_type = "ulpi";
 	};
@@ -140,3 +170,11 @@
 		phy-connection-type = "rgmii-id";
 	};
 };
+
+&dsp_soc {
+	aic@50000 {
+		lane2: aiclane@600 {
+		rfphy-handle = <&rfphy0>;
+		};
+	};
+};
diff --git a/arch/powerpc/boot/dts/fsl/bsc9131si-post.dtsi b/arch/powerpc/boot/dts/fsl/bsc9131si-post.dtsi
index 5180d9d..a3d1128 100644
--- a/arch/powerpc/boot/dts/fsl/bsc9131si-post.dtsi
+++ b/arch/powerpc/boot/dts/fsl/bsc9131si-post.dtsi
@@ -45,7 +45,6 @@
 	device_type = "soc";
 	compatible = "fsl,bsc9131-immr", "simple-bus";
 	bus-frequency = <0>;		// Filled out by uboot.
-
 	ecm-law@0 {
 		compatible = "fsl,ecm-law";
 		reg = <0x0 0x1000>;
@@ -87,11 +86,21 @@
 		fsl,espi-num-chipselects = <1>;
 		interrupts = <22 0x2 0 0>;
 	};
+/include/ "pq3-espi-1.dtsi"
+	spi1: spi@6000 {
+		fsl,espi-num-chipselects = <4>;
+		interrupts = <23 0x2 0 0>;
+	};
 
 /include/ "pq3-gpio-0.dtsi"
-	gpio-controller@f000 {
+	gpio0: gpio-controller@f000 {
 		interrupts = <19 0x2 0 0>;
-		};
+	};
+
+/include/ "pq3-gpio-1.dtsi"
+	gpio1: gpio-controller@f100 {
+		interrupts = <19 0x2 0 0>;
+	};
 
 	L2: l2-cache-controller@20000 {
 		compatible = "fsl,bsc9131-l2-cache-controller";
@@ -191,3 +200,41 @@ global-utilities@e0000 {
 		fsl,has-rstcr;
 	};
 };
+
+&dsp_soc {
+	#address-cells = <1>;
+	#size-cells = <1>;
+	compatible = "simple-bus";
+	gcr@18000 {
+		#address-cells = <1>;
+		#size-cells = <1>;
+		compatible = "fsl,bsc9131-gcr", "fsl,bsc9132-gcr";
+		reg = <0x18000 0x200>;
+	};
+	aic@50000 {
+		#address-cells = <1>;
+		#size-cells = <1>;
+		compatible = "fsl,bsc9131-aic", "fsl,bsc9132-aic";
+		reg = <0x50000 0x200>;
+		interrupts = <49 2 0 0 53 2 0 0>;
+		lane0: aiclane@200 {
+			reg = <0x200 0x200>;
+			lane_id = <0>;
+			interrupts = <45 2 0 0>;
+		};
+
+		lane1: aiclane@400 {
+			reg = <0x400 0x200>;
+			lane_id = <1>;
+			interrupts = <46 2 0 0>;
+		};
+
+		lane2: aiclane@600 {
+			reg = <0x600 0x200>;
+			lane_id = <2>;
+			interrupts = <47 2 0 0>;
+		};
+	};
+};
+
+
diff --git a/arch/powerpc/boot/dts/fsl/pq3-espi-0.dtsi b/arch/powerpc/boot/dts/fsl/pq3-espi-0.dtsi
index 75854b2..e0cf954 100644
--- a/arch/powerpc/boot/dts/fsl/pq3-espi-0.dtsi
+++ b/arch/powerpc/boot/dts/fsl/pq3-espi-0.dtsi
@@ -33,6 +33,7 @@
  */
 
 spi@7000 {
+	cell-index = <0>;
 	#address-cells = <1>;
 	#size-cells = <0>;
 	compatible = "fsl,mpc8536-espi";
diff --git a/arch/powerpc/boot/dts/fsl/pq3-espi-1.dtsi b/arch/powerpc/boot/dts/fsl/pq3-espi-1.dtsi
new file mode 100644
index 0000000..1792192
--- /dev/null
+++ b/arch/powerpc/boot/dts/fsl/pq3-espi-1.dtsi
@@ -0,0 +1,42 @@
+/*
+ * PQ3 eSPI device tree stub [ controller @ offset 0x6000 ]
+ *
+ * Copyright 2011 Freescale Semiconductor Inc.
+ *
+ * Redistribution and use in source and binary forms, with or without
+ * modification, are permitted provided that the following conditions are met:
+ *     * Redistributions of source code must retain the above copyright
+ *       notice, this list of conditions and the following disclaimer.
+ *     * Redistributions in binary form must reproduce the above copyright
+ *       notice, this list of conditions and the following disclaimer in the
+ *       documentation and/or other materials provided with the distribution.
+ *     * Neither the name of Freescale Semiconductor nor the
+ *       names of its contributors may be used to endorse or promote products
+ *       derived from this software without specific prior written permission.
+ *
+ *
+ * ALTERNATIVELY, this software may be distributed under the terms of the
+ * GNU General Public License ("GPL") as published by the Free Software
+ * Foundation, either version 2 of that License or (at your option) any
+ * later version.
+ *
+ * THIS SOFTWARE IS PROVIDED BY Freescale Semiconductor ``AS IS'' AND ANY
+ * EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
+ * WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
+ * DISCLAIMED. IN NO EVENT SHALL Freescale Semiconductor BE LIABLE FOR ANY
+ * DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
+ * (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
+ * LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
+ * ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
+ * (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
+ * SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
+ */
+
+spi@6000 {
+	cell-index = <1>;
+	#address-cells = <1>;
+	#size-cells = <0>;
+	compatible = "fsl,mpc8536-espi";
+	reg = <0x6000 0x1000>;
+	interrupts = <59 0x2 0 0>;
+};
diff --git a/arch/powerpc/boot/dts/fsl/pq3-gpio-0.dtsi b/arch/powerpc/boot/dts/fsl/pq3-gpio-0.dtsi
index 72a3ef5..363e401 100644
--- a/arch/powerpc/boot/dts/fsl/pq3-gpio-0.dtsi
+++ b/arch/powerpc/boot/dts/fsl/pq3-gpio-0.dtsi
@@ -33,6 +33,7 @@
  */
 
 gpio-controller@f000 {
+	cell-index = <0>;
 	#gpio-cells = <2>;
 	compatible = "fsl,pq3-gpio";
 	reg = <0xf000 0x100>;
diff --git a/arch/powerpc/boot/dts/fsl/pq3-gpio-1.dtsi b/arch/powerpc/boot/dts/fsl/pq3-gpio-1.dtsi
new file mode 100644
index 0000000..1293e3c
--- /dev/null
+++ b/arch/powerpc/boot/dts/fsl/pq3-gpio-1.dtsi
@@ -0,0 +1,42 @@
+/*
+ * PQ3 GPIO device tree stub [ controller @ offset 0xf100 ]
+ *
+ * Copyright 2011 Freescale Semiconductor Inc.
+ *
+ * Redistribution and use in source and binary forms, with or without
+ * modification, are permitted provided that the following conditions are met:
+ *     * Redistributions of source code must retain the above copyright
+ *       notice, this list of conditions and the following disclaimer.
+ *     * Redistributions in binary form must reproduce the above copyright
+ *       notice, this list of conditions and the following disclaimer in the
+ *       documentation and/or other materials provided with the distribution.
+ *     * Neither the name of Freescale Semiconductor nor the
+ *       names of its contributors may be used to endorse or promote products
+ *       derived from this software without specific prior written permission.
+ *
+ *
+ * ALTERNATIVELY, this software may be distributed under the terms of the
+ * GNU General Public License ("GPL") as published by the Free Software
+ * Foundation, either version 2 of that License or (at your option) any
+ * later version.
+ *
+ * THIS SOFTWARE IS PROVIDED BY Freescale Semiconductor ``AS IS'' AND ANY
+ * EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
+ * WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
+ * DISCLAIMED. IN NO EVENT SHALL Freescale Semiconductor BE LIABLE FOR ANY
+ * DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
+ * (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
+ * LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
+ * ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
+ * (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
+ * SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
+ */
+
+gpio-controller@f100 {
+	cell-index = <1>;
+	#gpio-cells = <2>;
+	compatible = "fsl,pq3-gpio";
+	reg = <0xf100 0x100>;
+	interrupts = <47 0x2 0 0>;
+	gpio-controller;
+};
-- 
1.6.3.1



