Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751837Ab3KMVwb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Nov 2013 16:52:31 -0500
Received: from multi.imgtec.com ([194.200.65.239]:20880 "EHLO multi.imgtec.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751617Ab3KMVwJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Nov 2013 16:52:09 -0500
From: James Hogan <james.hogan@imgtec.com>
To: Mike Turquette <mturquette@linaro.org>,
        <linux-arm-kernel@lists.infradead.org>
CC: Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Mark Rutland <mark.rutland@arm.com>, Pawel Moll <pawel.moll@arm.com>,
        Rob Herring <rob.herring@calxeda.com>,
        Stephen Warren <swarren@wwwdotorg.org>, <devicetree@vger.kernel.org>,
        <linux-metag@vger.kernel.org>, Tomasz Figa <tomasz.figa@gmail.com>,
        <linux-kernel@vger.kernel.org>, James Hogan <james.hogan@imgtec.com>,
        Rob Landley <rob@landley.net>, <linux-doc@vger.kernel.org>
Subject: [PATCH v2 1/2] dt: binding: add specified-clock for discoverable rate clocks
Date: Wed, 13 Nov 2013 21:49:59 +0000
Message-ID: <1384379400-24776-2-git-send-email-james.hogan@imgtec.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1384379400-24776-1-git-send-email-james.hogan@imgtec.com>
References: <1384379400-24776-1-git-send-email-james.hogan@imgtec.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [192.168.154.65]
X-SEF-Processed: 7_3_0_01192__2013_11_13_21_52_05
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The frequency of some fixed rate external oscillators on some SoCs (for
example TZ1090's XTAL1) are specified by the board using pull-ups and
pull-downs of configuration pins which are automatically latched on
reset and available in an SoC register, so that the boot ROM and OS can
automatically discover it.

These clocks are very similar to fixed-clocks since the rate never
changes, but we still want to be able to automatically discover the
frequency, so add a new binding to describe such clocks. Instead of
using a "clock-frequency" property, use "reg", "bit-mask", "bit-shift"
properties to describe the register field. The mapping from register
values to clock frequencies is specified in a "table" property which
contains pairs of register values and frequencies.

There is scope to extend the binding further in future to handle other
mapping types, by using different properties instead of "table".

Signed-off-by: James Hogan <james.hogan@imgtec.com>
Cc: Mike Turquette <mturquette@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org
Cc: Ian Campbell <ijc+devicetree@hellion.org.uk>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Pawel Moll <pawel.moll@arm.com>
Cc: Rob Herring <rob.herring@calxeda.com>
Cc: Stephen Warren <swarren@wwwdotorg.org>
Cc: devicetree@vger.kernel.org
Cc: Rob Landley <rob@landley.net>
Cc: linux-doc@vger.kernel.org
---
I could easily have extended the fixed-rate binding instead, but there'd
be no properties in common except the standard common clock properties
so it seemed like it deserved a separate binding. I'm open to arguments
to the contrary or better compatible string names though.

Changes in v2:
 * Borrow bit-mask and bit-shift bindings from Mike's mux clock binding
   proposals.
---
 .../devicetree/bindings/clock/specified-clock.txt  | 38 ++++++++++++++++++++++
 1 file changed, 38 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/clock/specified-clock.txt

diff --git a/Documentation/devicetree/bindings/clock/specified-clock.txt b/Documentation/devicetree/bindings/clock/specified-clock.txt
new file mode 100644
index 000000000000..fa5010ffd903
--- /dev/null
+++ b/Documentation/devicetree/bindings/clock/specified-clock.txt
@@ -0,0 +1,38 @@
+Binding for discoverable-fixed-rate clock sources.
+
+This binding uses the common clock binding[1].
+
+[1] Documentation/devicetree/bindings/clock/clock-bindings.txt
+
+Required properties:
+- compatible : shall be "specified-clock".
+- #clock-cells : from common clock binding; shall be set to 0.
+- reg : Base address of configuration register specifying the frequency.
+- bit-mask : Mask of bits in the field specifying the frequency.
+- table : array of integer pairs defining register field values and
+  corresponding clock frequencies in Hz.
+
+Optional properties:
+- bit-shift : Number of bits to shift the masked register value,
+  defaults to (ffs(bit-mask) - 1) if absent.
+- gpios : From common gpio binding; gpio connection to clock enable pin.
+- clock-output-names : From common clock binding.
+
+Example:
+	clock {
+		compatible = "specified-clock";
+		#clock-cells = <0>;
+		reg = <0x02004004 0x4>;		/* CR_PERIP_RESET_CFG */
+		bit-mask = <0x00000f00>;	/* FXTAL */
+		table =	/*	FXTAL	Frequency */
+				<0	16384000>,
+				<1	19200000>,
+				<2	24000000>,
+				<3	24576000>,
+				<4	26000000>,
+				<5	36000000>,
+				<6	36864000>,
+				<7	38400000>,
+				<8	40000000>;
+		clock-output-names = "xtal1";
+	};
-- 
1.8.1.2


