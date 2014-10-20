Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753730AbaJTVJd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Oct 2014 17:09:33 -0400
Received: from mail-pd0-f174.google.com ([209.85.192.174]:36074 "EHLO
	mail-pd0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753513AbaJTVJT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Oct 2014 17:09:19 -0400
From: mathieu.poirier@linaro.org
To: gregkh@linuxfoundation.org
Cc: linux@arm.linux.org.uk, pratikp@codeaurora.org, varshney@ti.com,
        Al.Grant@arm.com, jonas.svennebring@avagotech.com,
        james.king@linaro.org, kaixu.xia@linaro.org, marcin.jabrzyk@gmail.com,
        r.sengupta@samsung.com, robbelibobban@gmail.com, patches@linaro.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        mathieu.poirier@linaro.org
Subject: [PATCH v8 10/11] coresight: adding basic support for Vexpress TC2
Date: Mon, 20 Oct 2014 15:08:11 -0600
Message-Id: <1413839292-19135-11-git-send-email-mathieu.poirier@linaro.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1413839292-19135-1-git-send-email-mathieu.poirier@linaro.org>
References: <1413839292-19135-1-git-send-email-mathieu.poirier@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mathieu Poirier <mathieu.poirier@linaro.org>

Support for the 2 PTMs, 3 ETMs, funnel, TPIU and replicator
connected to the ETB are included.  Proper handling of the
ITM and the replicator linked to it along with the CTIs
and SWO are not included.

Signed-off-by: Mathieu Poirier <mathieu.poirier@linaro.org>
---
 arch/arm/boot/dts/vexpress-v2p-ca15_a7.dts | 199 +++++++++++++++++++++++++++++
 1 file changed, 199 insertions(+)

diff --git a/arch/arm/boot/dts/vexpress-v2p-ca15_a7.dts b/arch/arm/boot/dts/vexpress-v2p-ca15_a7.dts
index 322fd15..33920df 100644
--- a/arch/arm/boot/dts/vexpress-v2p-ca15_a7.dts
+++ b/arch/arm/boot/dts/vexpress-v2p-ca15_a7.dts
@@ -358,6 +358,205 @@
 		};
 	};
 
+	etb@0,20010000 {
+		compatible = "arm,coresight-etb10", "arm,primecell";
+		reg = <0 0x20010000 0 0x1000>;
+
+		coresight-default-sink;
+		clocks = <&oscclk6a>;
+		clock-names = "apb_pclk";
+		port {
+			etb_in_port: endpoint@0 {
+				slave-mode;
+				remote-endpoint = <&replicator_out_port0>;
+			};
+		};
+	};
+
+	tpiu@0,20030000 {
+		compatible = "arm,coresight-tpiu", "arm,primecell";
+		reg = <0 0x20030000 0 0x1000>;
+
+		clocks = <&oscclk6a>;
+		clock-names = "apb_pclk";
+		port {
+			tpiu_in_port: endpoint@0 {
+				slave-mode;
+				remote-endpoint = <&replicator_out_port1>;
+			};
+		};
+	};
+
+	replicator {
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
+				replicator_out_port0: endpoint {
+					remote-endpoint = <&etb_in_port>;
+				};
+			};
+
+			port@1 {
+				reg = <1>;
+				replicator_out_port1: endpoint {
+					remote-endpoint = <&tpiu_in_port>;
+				};
+			};
+
+			/* replicator input port */
+			port@2 {
+				reg = <0>;
+				replicator_in_port0: endpoint {
+					slave-mode;
+					remote-endpoint = <&funnel_out_port0>;
+				};
+			};
+		};
+	};
+
+	funnel@0,20040000 {
+		compatible = "arm,coresight-funnel", "arm,primecell";
+		reg = <0 0x20040000 0 0x1000>;
+
+		clocks = <&oscclk6a>;
+		clock-names = "apb_pclk";
+		ports {
+			#address-cells = <1>;
+			#size-cells = <0>;
+
+			/* funnel output port */
+			port@0 {
+				reg = <0>;
+				funnel_out_port0: endpoint {
+					remote-endpoint =
+						<&replicator_in_port0>;
+				};
+			};
+
+			/* funnel input ports */
+			port@1 {
+				reg = <0>;
+				funnel_in_port0: endpoint {
+					slave-mode;
+					remote-endpoint = <&ptm0_out_port>;
+				};
+			};
+
+			port@2 {
+				reg = <1>;
+				funnel_in_port1: endpoint {
+					slave-mode;
+					remote-endpoint = <&ptm1_out_port>;
+				};
+			};
+
+			port@3 {
+				reg = <2>;
+				funnel_in_port2: endpoint {
+					slave-mode;
+					remote-endpoint = <&etm0_out_port>;
+				};
+			};
+
+			/* Input port #3 is for ITM, not supported here */
+
+			port@4 {
+				reg = <4>;
+				funnel_in_port4: endpoint {
+					slave-mode;
+					remote-endpoint = <&etm1_out_port>;
+				};
+			};
+
+			port@5 {
+				reg = <5>;
+				funnel_in_port5: endpoint {
+					slave-mode;
+					remote-endpoint = <&etm2_out_port>;
+				};
+			};
+		};
+	};
+
+	ptm@0,2201c000 {
+		compatible = "arm,coresight-etm3x", "arm,primecell";
+		reg = <0 0x2201c000 0 0x1000>;
+
+		cpu = <&cpu0>;
+		clocks = <&oscclk6a>;
+		clock-names = "apb_pclk";
+		port {
+			ptm0_out_port: endpoint {
+				remote-endpoint = <&funnel_in_port0>;
+			};
+		};
+	};
+
+	ptm@0,2201d000 {
+		compatible = "arm,coresight-etm3x", "arm,primecell";
+		reg = <0 0x2201d000 0 0x1000>;
+
+		cpu = <&cpu1>;
+		clocks = <&oscclk6a>;
+		clock-names = "apb_pclk";
+		port {
+			ptm1_out_port: endpoint {
+				remote-endpoint = <&funnel_in_port1>;
+			};
+		};
+	};
+
+	etm@0,2203c000 {
+		compatible = "arm,coresight-etm3x", "arm,primecell";
+		reg = <0 0x2203c000 0 0x1000>;
+
+		cpu = <&cpu2>;
+		clocks = <&oscclk6a>;
+		clock-names = "apb_pclk";
+		port {
+			etm0_out_port: endpoint {
+				remote-endpoint = <&funnel_in_port2>;
+			};
+		};
+	};
+
+	etm@0,2203d000 {
+		compatible = "arm,coresight-etm3x", "arm,primecell";
+		reg = <0 0x2203d000 0 0x1000>;
+
+		cpu = <&cpu3>;
+		clocks = <&oscclk6a>;
+		clock-names = "apb_pclk";
+		port {
+			etm1_out_port: endpoint {
+				remote-endpoint = <&funnel_in_port4>;
+			};
+		};
+	};
+
+	etm@0,2203e000 {
+		compatible = "arm,coresight-etm3x", "arm,primecell";
+		reg = <0 0x2203e000 0 0x1000>;
+
+		cpu = <&cpu4>;
+		clocks = <&oscclk6a>;
+		clock-names = "apb_pclk";
+		port {
+			etm2_out_port: endpoint {
+				remote-endpoint = <&funnel_in_port5>;
+			};
+		};
+	};
+
 	smb {
 		compatible = "simple-bus";
 
-- 
1.9.1

