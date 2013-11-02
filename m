Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754858Ab3KBWh5 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Nov 2013 18:37:57 -0400
Received: from mail-we0-f177.google.com ([74.125.82.177]:58024 "EHLO
	mail-we0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754765Ab3KBWhN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Nov 2013 18:37:13 -0400
From: Grant Likely <grant.likely@linaro.org>
To: devicetree-discuss@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Grant Likely <grant.likely@linaro.org>,
        Rob Herring <rob.herring@calxeda.com>
Subject: [PATCH 1/2] of/irq: Fix bug in interrupt parsing refactor.
Date: Sat,  2 Nov 2013 08:24:45 +0000
Message-Id: <1383380686-26979-2-git-send-email-grant.likely@linaro.org>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1383380686-26979-1-git-send-email-grant.likely@linaro.org>
References: <1383380686-26979-1-git-send-email-grant.likely@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit 2361613206e6, "of/irq: Refactor interrupt-map parsing" introduced
a bug. The irq parsing will fail for some nodes that don't have a reg
property. It is fixed by deferring the check for reg until it is
actually needed. Also adjust the testcase data to catch the bug.

Signed-off-by: Grant Likely <grant.likely@linaro.org>
Tested-by: Stephen Warren <swarren@nvidia.com>
Cc: Rob Herring <rob.herring@calxeda.com>
---
 arch/arm/boot/dts/testcases/tests-interrupts.dtsi |  6 +++---
 drivers/of/irq.c                                  | 20 ++++++++++----------
 2 files changed, 13 insertions(+), 13 deletions(-)

diff --git a/arch/arm/boot/dts/testcases/tests-interrupts.dtsi b/arch/arm/boot/dts/testcases/tests-interrupts.dtsi
index 560d6bf680b6..94cd511a1f64 100644
--- a/arch/arm/boot/dts/testcases/tests-interrupts.dtsi
+++ b/arch/arm/boot/dts/testcases/tests-interrupts.dtsi
@@ -2,7 +2,7 @@
 / {
 	testcase-data {
 		interrupts {
-			#address-cells = <0>;
+			#address-cells = <1>;
 			test_intc0: intc0 {
 				interrupt-controller;
 				#interrupt-cells = <1>;
@@ -29,8 +29,7 @@
 
 			test_intmap1: intmap1 {
 				#interrupt-cells = <2>;
-				#address-cells = <0>;
-				interrupt-map = <1 2 &test_intc0 15>;
+				interrupt-map = <0x5000 1 2 &test_intc0 15>;
 			};
 
 			interrupts0 {
@@ -44,6 +43,7 @@
 			};
 
 			interrupts-extended0 {
+				reg = <0x5000>;
 				interrupts-extended = <&test_intc0 1>,
 						      <&test_intc1 2 3 4>,
 						      <&test_intc2 5 6>,
diff --git a/drivers/of/irq.c b/drivers/of/irq.c
index 8cc62b4a7988..52dba6a01423 100644
--- a/drivers/of/irq.c
+++ b/drivers/of/irq.c
@@ -147,18 +147,9 @@ int of_irq_parse_raw(const __be32 *addr, struct of_phandle_args *out_irq)
 
 	pr_debug(" -> addrsize=%d\n", addrsize);
 
-	/* If we were passed no "reg" property and we attempt to parse
-	 * an interrupt-map, then #address-cells must be 0.
-	 * Fail if it's not.
-	 */
-	if (addr == NULL && addrsize != 0) {
-		pr_debug(" -> no reg passed in when needed !\n");
-		return -EINVAL;
-	}
-
 	/* Precalculate the match array - this simplifies match loop */
 	for (i = 0; i < addrsize; i++)
-		initial_match_array[i] = addr[i];
+		initial_match_array[i] = addr ? addr[i] : 0;
 	for (i = 0; i < intsize; i++)
 		initial_match_array[addrsize + i] = cpu_to_be32(out_irq->args[i]);
 
@@ -174,6 +165,15 @@ int of_irq_parse_raw(const __be32 *addr, struct of_phandle_args *out_irq)
 			return 0;
 		}
 
+		/*
+		 * interrupt-map parsing does not work without a reg
+		 * property when #address-cells != 0
+		 */
+		if (addrsize && !addr) {
+			pr_debug(" -> no reg passed in when needed !\n");
+			goto fail;
+		}
+
 		/* Now look for an interrupt-map */
 		imap = of_get_property(ipar, "interrupt-map", &imaplen);
 		/* No interrupt map, check for an interrupt parent */
-- 
1.8.1.2

