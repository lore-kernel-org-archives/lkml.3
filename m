Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757627AbaGORY5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2014 13:24:57 -0400
Received: from mail-wi0-f171.google.com ([209.85.212.171]:56299 "EHLO
	mail-wi0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755329AbaGORCJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2014 13:02:09 -0400
From: Sam Asadi <asadi.samuel@gmail.com>
To: gregkh@linuxfoundation.org
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Rajendra Nayak <rnayak@ti.com>, Tero Kristo <t-kristo@ti.com>,
        sam-the-6 <asadi.samuel@gmail.com>
Subject: [PATCH 20/94] ARM: dts: dra7xx-clocks: Fix the l3 and l4 clock rates
Date: Tue, 15 Jul 2014 20:00:35 +0300
Message-Id: <1405443709-15288-20-git-send-email-asadi.samuel@gmail.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1405443709-15288-1-git-send-email-asadi.samuel@gmail.com>
References: <1405443709-15288-1-git-send-email-asadi.samuel@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rajendra Nayak <rnayak@ti.com>

Without the patch:
/debug/.../dpll_core_x2_ck/dpll_core_h12x2_ck # cat clk_rate
532000000
/debug/.../dpll_core_x2_ck/dpll_core_h12x2_ck/l3_iclk_div # cat clk_rate
532000000
/debug/.../dpll_core_x2_ck/dpll_core_h12x2_ck/l3_iclk_div/l4_root_clk_div # cat clk_rate
532000000

With the patch:
/debug/.../dpll_core_x2_ck/dpll_core_h12x2_ck # cat clk_rate
532000000
/debug/.../dpll_core_x2_ck/dpll_core_h12x2_ck/l3_iclk_div # cat clk_rate
266000000
/debug/.../dpll_core_x2_ck/dpll_core_h12x2_ck/l3_iclk_div/l4_root_clk_div # cat clk_rate
133000000

The l3 clock derived from core DPLL is actually a divider clock,
with the default divider set to 2. l4 then derived from l3 is a fixed factor
clock, but the fixed divider is 2 and not 1. Which means the l3 clock is
half of core DPLLs h12x2 and l4 is half of l3 (as seen with this patch)

Signed-off-by: Rajendra Nayak <rnayak@ti.com>
Signed-off-by: Tero Kristo <t-kristo@ti.com>
Signed-off-by: sam-the-6 <asadi.samuel@gmail.com>
---
 arch/arm/boot/dts/dra7xx-clocks.dtsi |   10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/arch/arm/boot/dts/dra7xx-clocks.dtsi b/arch/arm/boot/dts/dra7xx-clocks.dtsi
index c90c76d..dc7a292 100644
--- a/arch/arm/boot/dts/dra7xx-clocks.dtsi
+++ b/arch/arm/boot/dts/dra7xx-clocks.dtsi
@@ -673,10 +673,12 @@
 
 	l3_iclk_div: l3_iclk_div {
 		#clock-cells = <0>;
-		compatible = "fixed-factor-clock";
+		compatible = "ti,divider-clock";
+		ti,max-div = <2>;
+		ti,bit-shift = <4>;
+		reg = <0x0100>;
 		clocks = <&dpll_core_h12x2_ck>;
-		clock-mult = <1>;
-		clock-div = <1>;
+		ti,index-power-of-two;
 	};
 
 	l4_root_clk_div: l4_root_clk_div {
@@ -684,7 +686,7 @@
 		compatible = "fixed-factor-clock";
 		clocks = <&l3_iclk_div>;
 		clock-mult = <1>;
-		clock-div = <1>;
+		clock-div = <2>;
 	};
 
 	video1_clk2_div: video1_clk2_div {
-- 
1.7.10.4

