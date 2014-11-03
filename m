Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754033AbaKCSJI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Nov 2014 13:09:08 -0500
Received: from mail-pa0-f47.google.com ([209.85.220.47]:46633 "EHLO
	mail-pa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753808AbaKCSI2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Nov 2014 13:08:28 -0500
From: mathieu.poirier@linaro.org
To: gregkh@linuxfoundation.org
Cc: linux@arm.linux.org.uk, pratikp@codeaurora.org, varshney@ti.com,
        Al.Grant@arm.com, jonas.svennebring@avagotech.com,
        james.king@linaro.org, kaixu.xia@linaro.org, marcin.jabrzyk@gmail.com,
        r.sengupta@samsung.com, robbelibobban@gmail.com, patches@linaro.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        mathieu.poirier@linaro.org
Subject: [PATCH v9 11/12] coresight: adding basic support for D01 board
Date: Mon,  3 Nov 2014 11:07:45 -0700
Message-Id: <1415038066-22423-12-git-send-email-mathieu.poirier@linaro.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1415038066-22423-1-git-send-email-mathieu.poirier@linaro.org>
References: <1415038066-22423-1-git-send-email-mathieu.poirier@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Xia Kaixu <kaixu.xia@linaro.org>

Support for 16 PTMs, funnel, TPIU and replicator connected
to the ETB are included.

Signed-off-by: Xia Kaixu <kaixu.xia@linaro.org>
Signed-off-by: Mathieu Poirier <mathieu.poirier@linaro.org>
---
 arch/arm/boot/dts/hip04.dtsi | 717 +++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 717 insertions(+)

diff --git a/arch/arm/boot/dts/hip04.dtsi b/arch/arm/boot/dts/hip04.dtsi
index 93b6c90..2388145 100644
--- a/arch/arm/boot/dts/hip04.dtsi
+++ b/arch/arm/boot/dts/hip04.dtsi
@@ -190,6 +190,12 @@
 		clock-frequency = <168000000>;
 	};
 
+	clk_375m: clk_375m {
+		#clock-cells = <0>;
+		compatible = "fixed-clock";
+		clock-frequency = <375000000>;
+	};
+
 	soc {
 		/* It's a 32-bit SoC. */
 		#address-cells = <1>;
@@ -264,4 +270,715 @@
 		};
 
 	};
+
+	etb@0,e3c42000 {
+		compatible = "arm,coresight-etb10", "arm,primecell";
+		reg = <0 0xe3c42000 0 0x1000>;
+
+		coresight-default-sink;
+		clocks = <&clk_375m>;
+		clock-names = "apb_pclk";
+		port {
+			etb0_in_port: endpoint@0 {
+				slave-mode;
+				remote-endpoint = <&replicator0_out_port0>;
+			};
+		};
+	};
+
+	etb@0,e3c82000 {
+		compatible = "arm,coresight-etb10", "arm,primecell";
+		reg = <0 0xe3c82000 0 0x1000>;
+
+		clocks = <&clk_375m>;
+		clock-names = "apb_pclk";
+		port {
+			etb1_in_port: endpoint@0 {
+				slave-mode;
+				remote-endpoint = <&replicator1_out_port0>;
+			};
+		};
+	};
+
+	etb@0,e3cc2000 {
+		compatible = "arm,coresight-etb10", "arm,primecell";
+		reg = <0 0xe3cc2000 0 0x1000>;
+
+		clocks = <&clk_375m>;
+		clock-names = "apb_pclk";
+		port {
+			etb2_in_port: endpoint@0 {
+				slave-mode;
+				remote-endpoint = <&replicator2_out_port0>;
+			};
+		};
+	};
+
+	etb@0,e3d02000 {
+		compatible = "arm,coresight-etb10", "arm,primecell";
+		reg = <0 0xe3d02000 0 0x1000>;
+
+		clocks = <&clk_375m>;
+		clock-names = "apb_pclk";
+		port {
+			etb3_in_port: endpoint@0 {
+				slave-mode;
+				remote-endpoint = <&replicator3_out_port0>;
+			};
+		};
+	};
+
+	tpiu@0,e3c05000 {
+		compatible = "arm,coresight-tpiu", "arm,primecell";
+		reg = <0 0xe3c05000 0 0x1000>;
+
+		clocks = <&clk_375m>;
+		clock-names = "apb_pclk";
+		port {
+			tpiu_in_port: endpoint@0 {
+				slave-mode;
+				remote-endpoint = <&funnel4_out_port0>;
+			};
+		};
+	};
+
+	replicator0 {
+		/* non-configurable replicators don't show up on the
+		 * AMBA bus.  As such no need to add "arm,primecell".
+		 */
+		compatible = "arm,coresight-replicator";
+
+		ports {
+			#address-cells = <1>;
+			#size-cells = <0>;
+
+			/* replicator output ports */
+			port@0 {
+				reg = <0>;
+				replicator0_out_port0: endpoint {
+					remote-endpoint = <&etb0_in_port>;
+				};
+			};
+
+			port@1 {
+				reg = <1>;
+				replicator0_out_port1: endpoint {
+					remote-endpoint = <&funnel4_in_port0>;
+				};
+			};
+
+			/* replicator input port */
+			port@2 {
+				reg = <0>;
+				replicator0_in_port0: endpoint {
+					slave-mode;
+					remote-endpoint = <&funnel0_out_port0>;
+				};
+			};
+		};
+	};
+
+	replicator1 {
+		/* non-configurable replicators don't show up on the
+		 * AMBA bus.  As such no need to add "arm,primecell".
+		 */
+		compatible = "arm,coresight-replicator";
+
+		ports {
+			#address-cells = <1>;
+			#size-cells = <0>;
+
+			/* replicator output ports */
+			port@0 {
+				reg = <0>;
+				replicator1_out_port0: endpoint {
+					remote-endpoint = <&etb1_in_port>;
+				};
+			};
+
+			port@1 {
+				reg = <1>;
+				replicator1_out_port1: endpoint {
+					remote-endpoint = <&funnel4_in_port1>;
+				};
+			};
+
+			/* replicator input port */
+			port@2 {
+				reg = <0>;
+				replicator1_in_port0: endpoint {
+					slave-mode;
+					remote-endpoint = <&funnel1_out_port0>;
+				};
+			};
+		};
+	};
+
+	replicator2 {
+		/* non-configurable replicators don't show up on the
+		 * AMBA bus.  As such no need to add "arm,primecell".
+		 */
+		compatible = "arm,coresight-replicator";
+
+		ports {
+			#address-cells = <1>;
+			#size-cells = <0>;
+
+			/* replicator output ports */
+			port@0 {
+				reg = <0>;
+				replicator2_out_port0: endpoint {
+					remote-endpoint = <&etb2_in_port>;
+				};
+			};
+
+			port@1 {
+				reg = <1>;
+					replicator2_out_port1: endpoint {
+					remote-endpoint = <&funnel4_in_port2>;
+				};
+			};
+
+			/* replicator input port */
+			port@2 {
+				reg = <0>;
+				replicator2_in_port0: endpoint {
+					slave-mode;
+					remote-endpoint = <&funnel2_out_port0>;
+				};
+			};
+		};
+	};
+
+	replicator3 {
+		/* non-configurable replicators don't show up on the
+		 * AMBA bus.  As such no need to add "arm,primecell".
+		 */
+		compatible = "arm,coresight-replicator";
+
+		ports {
+			#address-cells = <1>;
+			#size-cells = <0>;
+
+			/* replicator output ports */
+			port@0 {
+				reg = <0>;
+				replicator3_out_port0: endpoint {
+					remote-endpoint = <&etb3_in_port>;
+				};
+			};
+
+			port@1 {
+				reg = <1>;
+				replicator3_out_port1: endpoint {
+					remote-endpoint = <&funnel4_in_port3>;
+				};
+			};
+
+			/* replicator input port */
+			port@2 {
+				reg = <0>;
+				replicator3_in_port0: endpoint {
+					slave-mode;
+					remote-endpoint = <&funnel3_out_port0>;
+				};
+			};
+		};
+	};
+
+	funnel@0,e3c41000 {
+		compatible = "arm,coresight-funnel", "arm,primecell";
+		reg = <0 0xe3c41000 0 0x1000>;
+
+		clocks = <&clk_375m>;
+		clock-names = "apb_pclk";
+		ports {
+			#address-cells = <1>;
+			#size-cells = <0>;
+
+			/* funnel output port */
+			port@0 {
+				reg = <0>;
+				funnel0_out_port0: endpoint {
+					remote-endpoint =
+						<&replicator0_in_port0>;
+				};
+			};
+
+			/* funnel input ports */
+			port@1 {
+				reg = <0>;
+				funnel0_in_port0: endpoint {
+					slave-mode;
+					remote-endpoint = <&ptm0_out_port>;
+				};
+			};
+
+			port@2 {
+				reg = <1>;
+				funnel0_in_port1: endpoint {
+					slave-mode;
+					remote-endpoint = <&ptm1_out_port>;
+				};
+			};
+
+			port@3 {
+				reg = <2>;
+				funnel0_in_port2: endpoint {
+					slave-mode;
+					remote-endpoint = <&ptm2_out_port>;
+				};
+			};
+
+			port@4 {
+				reg = <3>;
+				funnel0_in_port3: endpoint {
+					slave-mode;
+					remote-endpoint = <&ptm3_out_port>;
+				};
+			};
+		};
+	};
+
+	funnel@0,e3c81000 {
+		compatible = "arm,coresight-funnel", "arm,primecell";
+		reg = <0 0xe3c81000 0 0x1000>;
+
+		clocks = <&clk_375m>;
+		clock-names = "apb_pclk";
+		ports {
+			#address-cells = <1>;
+			#size-cells = <0>;
+
+			/* funnel output port */
+			port@0 {
+				reg = <0>;
+				funnel1_out_port0: endpoint {
+					remote-endpoint =
+						<&replicator1_in_port0>;
+				};
+			};
+
+			/* funnel input ports */
+			port@1 {
+				reg = <0>;
+				funnel1_in_port0: endpoint {
+					slave-mode;
+					remote-endpoint = <&ptm4_out_port>;
+				};
+			};
+
+			port@2 {
+				reg = <1>;
+				funnel1_in_port1: endpoint {
+					slave-mode;
+					remote-endpoint = <&ptm5_out_port>;
+				};
+			};
+
+			port@3 {
+				reg = <2>;
+				funnel1_in_port2: endpoint {
+					slave-mode;
+					remote-endpoint = <&ptm6_out_port>;
+				};
+			};
+
+			port@4 {
+				reg = <3>;
+				funnel1_in_port3: endpoint {
+					slave-mode;
+					remote-endpoint = <&ptm7_out_port>;
+				};
+			};
+		};
+	};
+
+	funnel@0,e3cc1000 {
+		compatible = "arm,coresight-funnel", "arm,primecell";
+		reg = <0 0xe3cc1000 0 0x1000>;
+
+		clocks = <&clk_375m>;
+		clock-names = "apb_pclk";
+		ports {
+			#address-cells = <1>;
+			#size-cells = <0>;
+
+			/* funnel output port */
+			port@0 {
+				reg = <0>;
+				funnel2_out_port0: endpoint {
+					remote-endpoint =
+						<&replicator2_in_port0>;
+				};
+			};
+
+			/* funnel input ports */
+			port@1 {
+				reg = <0>;
+				funnel2_in_port0: endpoint {
+					slave-mode;
+					remote-endpoint = <&ptm8_out_port>;
+				};
+			};
+
+			port@2 {
+				reg = <1>;
+				funnel2_in_port1: endpoint {
+					slave-mode;
+					remote-endpoint = <&ptm9_out_port>;
+				};
+			};
+
+			port@3 {
+				reg = <2>;
+				funnel2_in_port2: endpoint {
+					slave-mode;
+					remote-endpoint = <&ptm10_out_port>;
+				};
+			};
+
+			port@4 {
+				reg = <3>;
+				funnel2_in_port3: endpoint {
+					slave-mode;
+					remote-endpoint = <&ptm11_out_port>;
+				};
+			};
+		};
+	};
+
+	funnel@0,e3d01000 {
+		compatible = "arm,coresight-funnel", "arm,primecell";
+		reg = <0 0xe3d01000 0 0x1000>;
+
+		clocks = <&clk_375m>;
+		clock-names = "apb_pclk";
+		ports {
+			#address-cells = <1>;
+			#size-cells = <0>;
+
+			/* funnel output port */
+			port@0 {
+				reg = <0>;
+				funnel3_out_port0: endpoint {
+					remote-endpoint =
+						<&replicator3_in_port0>;
+				};
+			};
+
+			/* funnel input ports */
+			port@1 {
+				reg = <0>;
+				funnel3_in_port0: endpoint {
+					slave-mode;
+					remote-endpoint = <&ptm12_out_port>;
+				};
+			};
+
+			port@2 {
+				reg = <1>;
+				funnel3_in_port1: endpoint {
+					slave-mode;
+					remote-endpoint = <&ptm13_out_port>;
+				};
+			};
+
+			port@3 {
+				reg = <2>;
+				funnel3_in_port2: endpoint {
+					slave-mode;
+					remote-endpoint = <&ptm14_out_port>;
+				};
+			};
+
+			port@4 {
+				reg = <3>;
+				funnel3_in_port3: endpoint {
+					slave-mode;
+					remote-endpoint = <&ptm15_out_port>;
+				};
+			};
+		};
+	};
+
+	funnel@0,e3c04000 {
+		compatible = "arm,coresight-funnel", "arm,primecell";
+		reg = <0 0xe3c04000 0 0x1000>;
+
+		clocks = <&clk_375m>;
+		clock-names = "apb_pclk";
+		ports {
+			#address-cells = <1>;
+			#size-cells = <0>;
+
+			/* funnel output port */
+			port@0 {
+				reg = <0>;
+				funnel4_out_port0: endpoint {
+					remote-endpoint = <&tpiu_in_port>;
+				};
+			};
+
+			/* funnel input ports */
+			port@1 {
+				reg = <0>;
+				funnel4_in_port0: endpoint {
+					slave-mode;
+					remote-endpoint =
+						<&replicator0_out_port1>;
+				};
+			};
+
+			port@2 {
+				reg = <1>;
+				funnel4_in_port1: endpoint {
+					slave-mode;
+					remote-endpoint =
+						<&replicator1_out_port1>;
+				};
+			};
+
+			port@3 {
+				reg = <2>;
+				funnel4_in_port2: endpoint {
+					slave-mode;
+					remote-endpoint =
+						<&replicator2_out_port1>;
+				};
+			};
+
+			port@4 {
+				reg = <3>;
+				funnel4_in_port3: endpoint {
+					slave-mode;
+					remote-endpoint =
+						<&replicator3_out_port1>;
+				};
+			};
+		};
+	};
+
+	ptm@0,e3c7c000 {
+		compatible = "arm,coresight-etm3x", "arm,primecell";
+		reg = <0 0xe3c7c000 0 0x1000>;
+
+		clocks = <&clk_375m>;
+		clock-names = "apb_pclk";
+		cpu = <&CPU0>;
+		port {
+			ptm0_out_port: endpoint {
+				remote-endpoint = <&funnel0_in_port0>;
+			};
+		};
+	};
+
+	ptm@0,e3c7d000 {
+		compatible = "arm,coresight-etm3x", "arm,primecell";
+		reg = <0 0xe3c7d000 0 0x1000>;
+
+		clocks = <&clk_375m>;
+		clock-names = "apb_pclk";
+		cpu = <&CPU1>;
+		port {
+			ptm1_out_port: endpoint {
+				remote-endpoint = <&funnel0_in_port1>;
+			};
+		};
+	};
+
+	ptm@0,e3c7e000 {
+		compatible = "arm,coresight-etm3x", "arm,primecell";
+		reg = <0 0xe3c7e000 0 0x1000>;
+
+		clocks = <&clk_375m>;
+		clock-names = "apb_pclk";
+		cpu = <&CPU2>;
+		port {
+			ptm2_out_port: endpoint {
+				remote-endpoint = <&funnel0_in_port2>;
+			};
+		};
+	};
+
+	ptm@0,e3c7f000 {
+		compatible = "arm,coresight-etm3x", "arm,primecell";
+		reg = <0 0xe3c7f000 0 0x1000>;
+
+		clocks = <&clk_375m>;
+		clock-names = "apb_pclk";
+		cpu = <&CPU3>;
+		port {
+			ptm3_out_port: endpoint {
+				remote-endpoint = <&funnel0_in_port3>;
+			};
+		};
+	};
+
+	ptm@0,e3cbc000 {
+		compatible = "arm,coresight-etm3x", "arm,primecell";
+		reg = <0 0xe3cbc000 0 0x1000>;
+
+		clocks = <&clk_375m>;
+		clock-names = "apb_pclk";
+		cpu = <&CPU4>;
+		port {
+			ptm4_out_port: endpoint {
+				remote-endpoint = <&funnel1_in_port0>;
+			};
+		};
+	};
+
+	ptm@0,e3cbd000 {
+		compatible = "arm,coresight-etm3x", "arm,primecell";
+		reg = <0 0xe3cbd000 0 0x1000>;
+
+		clocks = <&clk_375m>;
+		clock-names = "apb_pclk";
+		cpu = <&CPU5>;
+		port {
+			ptm5_out_port: endpoint {
+				remote-endpoint = <&funnel1_in_port1>;
+			};
+		};
+	};
+
+	ptm@0,e3cbe000 {
+		compatible = "arm,coresight-etm3x", "arm,primecell";
+		reg = <0 0xe3cbe000 0 0x1000>;
+
+		clocks = <&clk_375m>;
+		clock-names = "apb_pclk";
+		cpu = <&CPU6>;
+		port {
+			ptm6_out_port: endpoint {
+				remote-endpoint = <&funnel1_in_port2>;
+			};
+		};
+	};
+
+	ptm@0,e3cbf000 {
+		compatible = "arm,coresight-etm3x", "arm,primecell";
+		reg = <0 0xe3cbf000 0 0x1000>;
+
+		clocks = <&clk_375m>;
+		clock-names = "apb_pclk";
+		cpu = <&CPU7>;
+		port {
+			ptm7_out_port: endpoint {
+				remote-endpoint = <&funnel1_in_port3>;
+			};
+		};
+	};
+
+	ptm@0,e3cfc000 {
+		compatible = "arm,coresight-etm3x", "arm,primecell";
+		reg = <0 0xe3cfc000 0 0x1000>;
+
+		clocks = <&clk_375m>;
+		clock-names = "apb_pclk";
+		cpu = <&CPU8>;
+		port {
+			ptm8_out_port: endpoint {
+				remote-endpoint = <&funnel2_in_port0>;
+			};
+		};
+	};
+
+	ptm@0,e3cfd000 {
+		compatible = "arm,coresight-etm3x", "arm,primecell";
+		reg = <0 0xe3cfd000 0 0x1000>;
+		clocks = <&clk_375m>;
+		clock-names = "apb_pclk";
+		cpu = <&CPU9>;
+		port {
+			ptm9_out_port: endpoint {
+				remote-endpoint = <&funnel2_in_port1>;
+			};
+		};
+	};
+
+	ptm@0,e3cfe000 {
+		compatible = "arm,coresight-etm3x", "arm,primecell";
+		reg = <0 0xe3cfe000 0 0x1000>;
+
+		clocks = <&clk_375m>;
+		clock-names = "apb_pclk";
+		cpu = <&CPU10>;
+		port {
+			ptm10_out_port: endpoint {
+				remote-endpoint = <&funnel2_in_port2>;
+			};
+		};
+	};
+
+	ptm@0,e3cff000 {
+		compatible = "arm,coresight-etm3x", "arm,primecell";
+		reg = <0 0xe3cff000 0 0x1000>;
+
+		clocks = <&clk_375m>;
+		clock-names = "apb_pclk";
+		cpu = <&CPU11>;
+		port {
+			ptm11_out_port: endpoint {
+				remote-endpoint = <&funnel2_in_port3>;
+			};
+		};
+	};
+
+	ptm@0,e3d3c000 {
+		compatible = "arm,coresight-etm3x", "arm,primecell";
+		reg = <0 0xe3d3c000 0 0x1000>;
+
+		clocks = <&clk_375m>;
+		clock-names = "apb_pclk";
+		cpu = <&CPU12>;
+		port {
+			ptm12_out_port: endpoint {
+				remote-endpoint = <&funnel3_in_port0>;
+			};
+		};
+	};
+
+	ptm@0,e3d3d000 {
+		compatible = "arm,coresight-etm3x", "arm,primecell";
+		reg = <0 0xe3d3d000 0 0x1000>;
+
+		clocks = <&clk_375m>;
+		clock-names = "apb_pclk";
+		cpu = <&CPU13>;
+		port {
+			ptm13_out_port: endpoint {
+				remote-endpoint = <&funnel3_in_port1>;
+			};
+		};
+	};
+
+	ptm@0,e3d3e000 {
+		compatible = "arm,coresight-etm3x", "arm,primecell";
+		reg = <0 0xe3d3e000 0 0x1000>;
+
+		clocks = <&clk_375m>;
+		clock-names = "apb_pclk";
+		cpu = <&CPU14>;
+		port {
+			ptm14_out_port: endpoint {
+				remote-endpoint = <&funnel3_in_port2>;
+			};
+		};
+	};
+
+	ptm@0,e3d3f000 {
+		compatible = "arm,coresight-etm3x", "arm,primecell";
+		reg = <0 0xe3d3f000 0 0x1000>;
+
+		clocks = <&clk_375m>;
+		clock-names = "apb_pclk";
+		cpu = <&CPU15>;
+		port {
+			ptm15_out_port: endpoint {
+				remote-endpoint = <&funnel3_in_port3>;
+			};
+		};
+	};
 };
-- 
1.9.1

