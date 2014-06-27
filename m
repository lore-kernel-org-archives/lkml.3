Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752687AbaF0SFl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jun 2014 14:05:41 -0400
Received: from mail-pa0-f46.google.com ([209.85.220.46]:47423 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752400AbaF0SEw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jun 2014 14:04:52 -0400
From: mathieu.poirier@linaro.org
To: linus.walleij@linaro.org, will.deacon@arm.com, linux@arm.linux.org.uk,
        daniel.thompson@linaro.org, robherring2@gmail.com
Cc: mathieu.poirier@linaro.org, arve@android.com, john.stultz@linaro.org,
        pratikp@codeaurora.org, varshney@ti.com, Al.Grant@arm.com,
        jonas.svennebring@avagotech.com, james.king@linaro.org,
        panchaxari.prasannamurthy@linaro.org, arnd@linaro.org,
        marcin.jabrzyk@gmail.com, r.sengupta@samsung.com,
        robbelibobban@gmail.com, Tony.Armitstead@arm.com, patches@linaro.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH 8/9 v2] coresight: adding basic support for Vexpress TC2
Date: Fri, 27 Jun 2014 12:04:20 -0600
Message-Id: <1403892261-25026-9-git-send-email-mathieu.poirier@linaro.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1403892261-25026-1-git-send-email-mathieu.poirier@linaro.org>
References: <1403892261-25026-1-git-send-email-mathieu.poirier@linaro.org>
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
 arch/arm/boot/dts/vexpress-v2p-ca15_a7.dts | 174 +++++++++++++++++++++++++++++
 1 file changed, 174 insertions(+)

diff --git a/arch/arm/boot/dts/vexpress-v2p-ca15_a7.dts b/arch/arm/boot/dts/vexpress-v2p-ca15_a7.dts
index 15f98cb..390f2bb 100644
--- a/arch/arm/boot/dts/vexpress-v2p-ca15_a7.dts
+++ b/arch/arm/boot/dts/vexpress-v2p-ca15_a7.dts
@@ -334,6 +334,180 @@
 		};
 	};
 
+	etb: etb@20010000 {
+		compatible = "arm,coresight-etb", "arm,primecell";
+		reg = <0 0x20010000 0 0x1000>;
+
+		coresight-default-sink;
+		clocks = <&oscclk6a>;
+		clock-names = "apb_pclk";
+		port {
+			etb_in_port: endpoint@0 {
+				slave-mode;
+				remote-endpoint = <&funnel_out_port0>;
+			};
+		};
+	};
+
+	tpiu: tpiu@20030000 {
+		compatible = "arm,coresight-tpiu", "arm,primecell";
+		reg = <0 0x20030000 0 0x1000>;
+
+		clocks = <&oscclk6a>;
+		clock-names = "apb_pclk";
+		port {
+			tpiu_in_port: endpoint@0 {
+				slave-mode;
+				remote-endpoint = <&funnel_out_port1>;
+			};
+		};
+	};
+
+	funnel {
+		compatible = "arm,coresight-funnel", "arm,primecell";
+		reg = <0 0x20040000 0 0x1000>;
+
+		clocks = <&oscclk6a>;
+		clock-names = "apb_pclk";
+		ports {
+			#address-cells = <1>;
+			#size-cells = <0>;
+
+			/* The funnel is connected to a replicator - since
+			 * replicators are hardwired we simply treat the
+			 * funnel as a multiple-in and multiple out component.
+			 * The following two ports really belong to the
+			 * repicator but configured as par of the funnel.
+			 */
+
+			/* replicator port */
+			port@0 {
+				reg = <0>;
+				funnel_out_port0: endpoint {
+					remote-endpoint = <&etb_in_port>;
+				};
+			};
+
+			/* replicator port */
+			port@1 {
+				reg = <1>;
+				funnel_out_port1: endpoint {
+					remote-endpoint = <&tpiu_in_port>;
+				};
+			};
+			/* funnel ports */
+			port@2 {
+				reg = <0>;
+				funnel_in_port0: endpoint {
+					slave-mode;
+					remote-endpoint = <&ptm0_out_port>;
+				};
+			};
+
+			port@3 {
+				reg = <1>;
+				funnel_in_port1: endpoint {
+					slave-mode;
+					remote-endpoint = <&ptm1_out_port>;
+				};
+			};
+
+			port@4 {
+				reg = <2>;
+				funnel_in_port2: endpoint {
+					slave-mode;
+					remote-endpoint = <&etm0_out_port>;
+				};
+			};
+
+			port@5 {
+				reg = <4>;
+				funnel_in_port4: endpoint {
+					slave-mode;
+					remote-endpoint = <&etm1_out_port>;
+				};
+			};
+
+			port@6 {
+				reg = <5>;
+				funnel_in_port5: endpoint {
+					slave-mode;
+					remote-endpoint = <&etm2_out_port>;
+				};
+			};
+                };
+	};
+
+	ptm0: ptm@2201c000 {
+		compatible = "arm,coresight-etm", "arm,primecell";
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
+	ptm1: ptm@2201d000 {
+		compatible = "arm,coresight-etm", "arm,primecell";
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
+	etm0: etm@2203c000 {
+		compatible = "arm,coresight-etm", "arm,primecell";
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
+	etm1: etm@2203d000 {
+		compatible = "arm,coresight-etm", "arm,primecell";
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
+	etm2: etm@2203e000 {
+		compatible = "arm,coresight-etm", "arm,primecell";
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

