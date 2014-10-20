Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753752AbaJTVOI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Oct 2014 17:14:08 -0400
Received: from mail-pa0-f49.google.com ([209.85.220.49]:40309 "EHLO
	mail-pa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753415AbaJTVOG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Oct 2014 17:14:06 -0400
From: mathieu.poirier@linaro.org
To: robh+dt@kernel.org, pawel.moll@arm.com, mark.rutland@arm.com,
        ijc+devicetree@hellion.org.uk, galak@codeaurora.org
Cc: devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        mathieu.poirier@linaro.org
Subject: [PATCH v8] coresight: bindings for coresight drivers
Date: Mon, 20 Oct 2014 15:13:55 -0600
Message-Id: <1413839635-20519-1-git-send-email-mathieu.poirier@linaro.org>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mathieu Poirier <mathieu.poirier@linaro.org>

Coresight IP blocks allow for the support of HW assisted tracing
on ARM SoCs.  Bindings for the currently available blocks are
presented herein.

Signed-off-by: Pratik Patel <pratikp@codeaurora.org>
Signed-off-by: Mathieu Poirier <mathieu.poirier@linaro.org>
---
 .../devicetree/bindings/arm/coresight.txt          | 203 +++++++++++++++++++++
 1 file changed, 203 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/arm/coresight.txt

diff --git a/Documentation/devicetree/bindings/arm/coresight.txt b/Documentation/devicetree/bindings/arm/coresight.txt
new file mode 100644
index 0000000..96dd947
--- /dev/null
+++ b/Documentation/devicetree/bindings/arm/coresight.txt
@@ -0,0 +1,203 @@
+* CoreSight Components:
+
+CoreSight components are compliant with the ARM CoreSight architecture
+specification and can be connected in various topologies to suit a particular
+SoCs tracing needs. These trace components can generally be classified as sinks,
+links and sources. Trace data produced by one or more sources flows through the
+intermediate links connecting the source to the currently selected sink. Each
+CoreSight component device should use these properties to describe its hardware
+characteristcs.
+
+* Required properties for all components *except* non-configurable replicators:
+
+	* compatible: These have to be supplemented with "arm,primecell" as
+	  drivers are using the AMBA bus interface.  Possible values include:
+		- "arm,coresight-etb10", "arm,primecell";
+		- "arm,coresight-tpiu", "arm,primecell";
+		- "arm,coresight-tmc", "arm,primecell";
+		- "arm,coresight-funnel", "arm,primecell";
+		- "arm,coresight-etm3x", "arm,primecell";
+
+	* reg: physical base address and length of the register
+	  set(s) of the component.
+
+	* clocks: the clock associated to this component.
+
+	* clock-names: the name of the clock as referenced by the code.
+	  Since we are using the AMBA framework, the name should be
+	  "apb_pclk".
+
+	* port or ports: The representation of the component's port
+	  layout using the generic DT graph presentation found in
+	  "bindings/graph.txt".
+
+* Required properties for devices that don't show up on the AMBA bus, such as
+  non-configurable replicators:
+
+	* compatible: Currently supported value is (note the absence of the
+	  AMBA markee):
+		- "arm,coresight-replicator"
+
+	* id: a unique number that will identify this replicator.
+
+	* port or ports: same as above.
+
+* Optional properties for ETM/PTMs:
+
+	* arm,cp14: must be present if the system accesses ETM/PTM management registers
+	  via co-processor 14.
+
+	* cpu: the cpu phandle this ETM/PTM is affined to. When omitted the source is
+	  considered to belong to CPU0.
+
+* Optional property for TMC:
+
+	* arm,buffer-size: size of contiguous buffer space for TMC ETR
+	 (embedded trace router)
+
+
+Example:
+
+1. Sinks
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
+2. Links
+	replicator {
+		/* non-configurable replicators don't show up on the
+		 * AMBA bus.  As such no need to add "arm,primecell".
+		 */
+		compatible = "arm,coresight-replicator";
+		/* this will show up in debugfs as "0.replicator" */
+		id = <0>;
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
+					remote-endpoint = <&replicator_in_port0>;
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
+		};
+	};
+
+3. Sources
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
-- 
1.9.1

