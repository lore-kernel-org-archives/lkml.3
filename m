Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933350AbaE3NpS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 May 2014 09:45:18 -0400
Received: from mail-pa0-f54.google.com ([209.85.220.54]:54782 "EHLO
	mail-pa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933286AbaE3NoE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 May 2014 09:44:04 -0400
From: mathieu.poirier@linaro.org
To: linus.walleij@linaro.org, will.deacon@arm.com
Cc: mathieu.poirier@linaro.org, arve@android.com, john.stultz@linaro.org,
        pratikp@codeaurora.org, varshney@ti.com, Al.Grant@arm.com,
        jonas.svennebring@avagotech.com, james.king@linaro.org,
        panchaxari.prasannamurthy@linaro.org, arnd@linaro.org,
        marcin.jabrzyk@gmail.com, r.sengupta@samsung.com,
        robbelibobban@gmail.com, patches@linaro.org, linux@arm.linux.org.uk,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        daniel.thompson@linaro.org
Subject: [RFC PATCH 09/11] coresight: adding basic support for Vexpress TC2
Date: Fri, 30 May 2014 07:43:09 -0600
Message-Id: <1401457391-12242-10-git-send-email-mathieu.poirier@linaro.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1401457391-12242-1-git-send-email-mathieu.poirier@linaro.org>
References: <1401457391-12242-1-git-send-email-mathieu.poirier@linaro.org>
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
 arch/arm/boot/dts/vexpress-v2p-ca15_a7.dts | 122 +++++++++++++++++++++++++++++
 1 file changed, 122 insertions(+)

diff --git a/arch/arm/boot/dts/vexpress-v2p-ca15_a7.dts b/arch/arm/boot/dts/vexpress-v2p-ca15_a7.dts
index 15f98cb..18de06e 100644
--- a/arch/arm/boot/dts/vexpress-v2p-ca15_a7.dts
+++ b/arch/arm/boot/dts/vexpress-v2p-ca15_a7.dts
@@ -334,6 +334,128 @@
 		};
 	};
 
+	coresight {
+		compatible = "arm,coresight";
+		#address-cells = <1>;
+		#size-cells = <1>;
+		ranges = <0x20010000 0 0x20010000 0x1000
+			  0x20030000 0 0x20030000 0x1000
+			  0x20040000 0 0x20040000 0x1000
+			  0x2201c000 0 0x2201c000 0x1000
+			  0x2201d000 0 0x2201d000 0x1000
+			  0x2203c000 0 0x2203c000 0x1000
+			  0x2203d000 0 0x2203d000 0x1000
+			  0x2203e000 0 0x2203e000 0x1000>;
+
+		etb: etb@20010000 {
+			compatible = "arm,coresight-etb";
+			reg = <0x20010000 0x1000>;
+
+			coresight-id = <0>;
+			coresight-name = "coresight-etb";
+			coresight-nr-inports = <1>;
+			coresight-default-sink;
+		};
+
+		etb_replicator: replicator {
+			compatible = "arm,coresight-replicator";
+
+			coresight-id = <1>;
+			coresight-name = "coresight-etb-replicator";
+			coresight-nr-inports = <1>;
+			coresight-outports = <0 1>;
+			coresight-child-list = <&etb &tpiu>;
+			coresight-child-ports = <0 0>;
+		};
+
+		tpiu: tpiu@20030000 {
+			compatible = "arm,coresight-tpiu";
+			reg = <0x20030000 0x1000>;
+
+			coresight-id = <2>;
+			coresight-name = "coresight-tpiu";
+			coresight-nr-inports = <1>;
+		};
+
+		funnel: funnel@20040000 {
+			compatible = "arm,coresight-funnel";
+			reg = <0x20040000 0x1000>;
+
+			coresight-id = <3>;
+			coresight-name = "coresight-funnel";
+			coresight-nr-inports = <1>;
+			coresight-outports = <0>;
+			coresight-child-list = <&etb_replicator>;
+			coresight-child-ports = <0>;
+		};
+
+		ptm0: ptm@2201c000 {
+			compatible = "arm,coresight-etm";
+			reg = <0x2201c000 0x1000>;
+
+			coresight-id = <4>;
+			coresight-name = "coresight-ptm0";
+			cpu = <&cpu0>;
+			coresight-nr-inports = <0>;
+			coresight-outports = <0>;
+			coresight-child-list = <&funnel>;
+			coresight-child-ports = <0>;
+		};
+
+		ptm1: ptm@2201d000 {
+			compatible = "arm,coresight-etm";
+			reg = <0x2201d000 0x1000>;
+
+			coresight-id = <5>;
+			coresight-name = "coresight-ptm1";
+			cpu = <&cpu1>;
+			coresight-nr-inports = <0>;
+			coresight-outports = <0>;
+			coresight-child-list = <&funnel>;
+			coresight-child-ports = <1>;
+		};
+
+		etm0: etm@2203c000 {
+			compatible = "arm,coresight-etm";
+			reg = <0x2203c000 0x1000>;
+
+			coresight-id = <6>;
+			coresight-name = "coresight-etm0";
+			cpu = <&cpu2>;
+			coresight-nr-inports = <0>;
+			coresight-outports = <0>;
+			coresight-child-list = <&funnel>;
+			coresight-child-ports = <2>;
+		};
+
+		etm1: etm@2203d000 {
+			compatible = "arm,coresight-etm";
+			reg = <0x2203d000 0x1000>;
+
+			coresight-id = <7>;
+			coresight-name = "coresight-etm1";
+			cpu = <&cpu3>;
+			coresight-nr-inports = <0>;
+			coresight-outports = <0>;
+			coresight-child-list = <&funnel>;
+			coresight-child-ports = <4>;
+		};
+
+		etm2: etm@2203e000 {
+			compatible = "arm,coresight-etm";
+			reg = <0x2203e000 0x1000>;
+
+			coresight-id = <8>;
+			coresight-name = "coresight-etm2";
+			cpu = <&cpu4>;
+			coresight-nr-inports = <0>;
+			coresight-outports = <0>;
+			coresight-child-list = <&funnel>;
+			coresight-child-ports = <5>;
+		};
+
+	};
+
 	smb {
 		compatible = "simple-bus";
 
-- 
1.9.1

