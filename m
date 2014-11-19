Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933383AbaKSXR5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Nov 2014 18:17:57 -0500
Received: from mail-wg0-f48.google.com ([74.125.82.48]:43138 "EHLO
	mail-wg0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755954AbaKSXQT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Nov 2014 18:16:19 -0500
From: James Hogan <james.hogan@imgtec.com>
To: Mike Turquette <mturquette@linaro.org>, linux-metag@vger.kernel.org,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org
Cc: James Hogan <james.hogan@imgtec.com>, Rob Herring <robh+dt@kernel.org>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>
Subject: [PATCH 11/15] dt: binding: add binding for TZ1090 PDC clock
Date: Wed, 19 Nov 2014 23:15:39 +0000
Message-Id: <1416438943-11429-12-git-send-email-james.hogan@imgtec.com>
X-Mailer: git-send-email 2.0.4
In-Reply-To: <1416438943-11429-1-git-send-email-james.hogan@imgtec.com>
References: <1416438943-11429-1-git-send-email-james.hogan@imgtec.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The TZ1090 PDC (PowerDown Controller) clock should be at 32.768KHz, and
is generated either directly from the XTAL3 clock or by dividing the
XTAL1 clock. Both the divide and the mux are in a single register which
also contains GPIO output data, and may need to be used by other
non-Linux cores and threads, so create a special clock binding for this
clock.

It essentially has just two clock inputs, and two clock outputs.

Signed-off-by: James Hogan <james.hogan@imgtec.com>
Cc: Mike Turquette <mturquette@linaro.org>
Cc: Rob Herring <robh+dt@kernel.org>
Cc: Pawel Moll <pawel.moll@arm.com>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Ian Campbell <ijc+devicetree@hellion.org.uk>
Cc: Kumar Gala <galak@codeaurora.org>
Cc: linux-metag@vger.kernel.org
Cc: devicetree@vger.kernel.org
---
 .../bindings/clock/img,tz1090-pdc-clock.txt        | 44 ++++++++++++++++++++++
 1 file changed, 44 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/clock/img,tz1090-pdc-clock.txt

diff --git a/Documentation/devicetree/bindings/clock/img,tz1090-pdc-clock.txt b/Documentation/devicetree/bindings/clock/img,tz1090-pdc-clock.txt
new file mode 100644
index 0000000..68e2eee
--- /dev/null
+++ b/Documentation/devicetree/bindings/clock/img,tz1090-pdc-clock.txt
@@ -0,0 +1,44 @@
+Binding for TZ1090 PDC clock.
+
+This binding uses the common clock binding[1]. It has two input clocks
+(clocks[0..1]), two output clocks (out[0..1]), and a memory-mapped register
+(reg) controlling a divider and a mux atomically with respect to other fields
+and (non-Linux) threads or cores.
+
+              _____
+clocks[0] ___| div |______________________
+             |_____|  |    ____   out[0]
+                      `--o| sw \__________
+clocks[1] ----------------|____/  out[1]
+
+
+out[0] = clocks[0] / (reg[26:16] + 1)
+out[1] = reg[30] ? clocks[1] : out[0]
+
+
+[1] Documentation/devicetree/bindings/clock/clock-bindings.txt
+
+Required properties:
+- compatible         : shall be "img,tz1090-pdc-clock".
+- #clock-cells       : from common clock binding; shall be set to 1.
+- reg                : base address for register controlling mux and divider
+- clocks             : clock specifiers of two parent clocks
+- clock-output-names : from common clock binding. Name of two output clocks.
+
+Clock Specifier Definition:
+- <1st-cell>: output clock number.
+
+Examples:
+	/*           ___________
+	 * xtal1 ___| xtal1_div |____________________________
+	 *          |___________|  |    ________   xtal1_div
+	 *                         `--o| rtc_sw \____________
+	 * xtal3 ----------------------|________/  32khz
+	 */
+	pdc_clk {
+		compatible = "img,tz1090-pdc-clock";
+		#clock-cells = <1>;
+		reg = <0x02006500 4>;	/* SOC_GPIO_CONTROL0 */
+		clocks = <&xtal1>, <&xtal3>;
+		clock-output-names = "xtal1_div", "32khz";
+	};
-- 
2.0.4

