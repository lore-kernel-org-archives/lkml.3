Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752279AbaBGKMQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Feb 2014 05:12:16 -0500
Received: from mail-la0-f52.google.com ([209.85.215.52]:40676 "EHLO
	mail-la0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752194AbaBGKMJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Feb 2014 05:12:09 -0500
Subject: Re: OMAP: clock DT conversion issues with omap36xx
From: Christoph Fritz <chf.fritz@googlemail.com>
To: Tero Kristo <t-kristo@ti.com>
Cc: Tomi Valkeinen <tomi.valkeinen@ti.com>,
        Ivaylo Dimitrov <ivo.g.dimitrov.75@gmail.com>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        linux-kernel@vger.kernel.org, pali.rohar@gmail.com, pavel@ucw.cz,
        Nishanth Menon <nm@ti.com>
In-Reply-To: <52F10C3D.7000507@ti.com>
References: <52E697C0.6000202@gmail.com> <1390848104.4936.62.camel@mars>
	 <52E772A3.4090401@ti.com> <1390901735.2963.8.camel@lovely>
	 <52E77D03.8090001@ti.com>  <52E7B361.2030601@ti.com>
	 <1390928565.4904.88.camel@mars> <1390994505.5023.32.camel@mars>
	 <52F10C3D.7000507@ti.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 07 Feb 2014 11:12:03 +0100
Message-ID: <1391767923.4937.110.camel@mars>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2014-02-04 at 17:50 +0200, Tero Kristo wrote:
> On 01/29/2014 01:21 PM, Christoph Fritz wrote:
> >> Currently I only analyzed sys_clkout2 (see attachments for full
> >> clk_summary files):
> >>
> >> clk_summary__next-20140115__works_as_expected:
> >>               dpll4_m2_ck        1           1            96000000
> >>                  dpll4_m2x2_ck   1           1            96000000
> >>                     omap_192m_alwon_fck 1           1            96000000
> >>                        omap_96m_alwon_fck 1           2            96000000
> >>                           per_96m_fck 0           6            96000000
> >>                              mcbsp4_fck 0           1            96000000
> >>                              mcbsp3_fck 0           2            96000000
> >>                              mcbsp2_fck 0           2            96000000
> >>                           cm_96m_fck 2           3            96000000
> >>                              clkout2_src_ck 1           1            96000000
> >>                                 sys_clkout2 1           1            24000000
> >>
> >> For real, on pin sys_clkout2 are correctly 24 Mhz measured.
> >>
> >> clk_summary__next-20140124__sysclkout2_dss_fails:
> >>               dpll4_m2_ck        1           1            96000000
> >>                  dpll4_m2x2_mul_ck 1           1            192000000
> >>                     dpll4_m2x2_ck 1           1            192000000
> >>                        omap_192m_alwon_fck 0           0            192000000
> >>                        omap_96m_alwon_fck 1           2            192000000
> >>                           per_96m_fck 0           6            192000000
> >>                              mcbsp4_fck 0           1            192000000
> >>                              mcbsp3_fck 0           2            192000000
> >>                              mcbsp2_fck 0           2            192000000
> >>                           cm_96m_fck 2           3            192000000
> >>                              clkout2_src_ck 1           1            192000000
> >>                                 sys_clkout2 1           1            24000000
> >>
> >> For real, on pin sys_clkout2 are only ~12 Mhz measured.
> 
> Hey Christoph,
> 
> I had a chance to look at this in more detail, and it looks like your 
> patch above was almost the correct one (except that I think you modified 
> wrong property and also modified the clock node for all omap3 variants.) 
> Can you give this one a shot? Can you also send me the clk-summary dump 
> with this patch (with the relevant nodes)?

             dpll4_m2_ck        1           1            96000000   0
                dpll4_m2x2_mul_ck 1           1            192000000  0
                   dpll4_m2x2_ck 1           1            192000000  0
                      omap_192m_alwon_fck 0           0            192000000  0
                      omap_96m_alwon_fck 1           2            96000000   0
                         per_96m_fck 0           6            96000000   0
                            mcbsp4_fck 0           1            96000000   0
                            mcbsp3_fck 0           2            96000000   0
                            mcbsp2_fck 0           2            96000000   0
                         cm_96m_fck 2           3            96000000   0
                            clkout2_src_ck 1           1            96000000   0
                               sys_clkout2 1           1            24000000   0

Yes, your patch fixes the issues for sys_clkout2. Thanks! If you want,
you can add my:
Tested-by: Christoph Fritz <chf.fritz@googlemail.com>

Below is my clock fix for dss:

>From b90a62128068e1b6b0ba2a11c5cc0c8e587cf301 Mon Sep 17 00:00:00 2001
From: Christoph Fritz <chf.fritz@googlemail.com>
Date: Fri, 7 Feb 2014 10:51:15 +0100
Subject: [PATCH] ARM: dts: omap36xx: fix dpll4_m4_ck tree

OMAP36xx has different hardware implementation for the dpll4_m4_ck tree
compared to other OMAP3 variants. Reflect this properly in the dts file.

before omap dt clock conversion:
             dpll4_m4_ck        1           1            57600000
                dpll4_m4x2_ck   1           1            57600000
                   dss1_alwon_fck_3430es2 2           4            57600000

after omap dt clock conversion:
             dpll4_m4_ck        0           1            96000000   0
                dpll4_m4x2_mul_ck 0           1            192000000  0
                   dpll4_m4x2_ck 0           1            192000000  0
                      dss1_alwon_fck_3430es2 0           4            192000000  0
with this patch:
             dpll4_m4_ck        1           1            57600000   0
                dss1_alwon_fck_3430es2 2           4            57600000   0
                dpll4_m4x2_mul_ck 0           0            115200000  0
                   dpll4_m4x2_ck 0           0            115200000  0

Signed-off-by: Christoph Fritz <chf.fritz@googlemail.com>
---
 arch/arm/boot/dts/omap36xx-clocks.dtsi |    8 ++++++++
 arch/arm/boot/dts/omap36xx.dtsi        |    2 +-
 2 files changed, 9 insertions(+), 1 deletion(-)

diff --git a/arch/arm/boot/dts/omap36xx-clocks.dtsi b/arch/arm/boot/dts/omap36xx-clocks.dtsi
index 24869cb..8ac8926 100644
--- a/arch/arm/boot/dts/omap36xx-clocks.dtsi
+++ b/arch/arm/boot/dts/omap36xx-clocks.dtsi
@@ -74,6 +74,14 @@
 	clock-div = <2>;
 };
 
+&dpll4_m4_ck {
+	clock-div = <15>;
+};
+
+&dss1_alwon_fck_3430es2 {
+	clocks = <&dpll4_m4_ck>;
+};
+
 &cm_clockdomains {
 	dpll4_clkdm: dpll4_clkdm {
 		compatible = "ti,clockdomain";
diff --git a/arch/arm/boot/dts/omap36xx.dtsi b/arch/arm/boot/dts/omap36xx.dtsi
index 7e8dee9..5e1bcd0 100644
--- a/arch/arm/boot/dts/omap36xx.dtsi
+++ b/arch/arm/boot/dts/omap36xx.dtsi
@@ -52,7 +52,7 @@
 	};
 };
 
-/include/ "omap36xx-clocks.dtsi"
 /include/ "omap34xx-omap36xx-clocks.dtsi"
 /include/ "omap36xx-omap3430es2plus-clocks.dtsi"
 /include/ "omap36xx-am35xx-omap3430es2plus-clocks.dtsi"
+/include/ "omap36xx-clocks.dtsi"
-- 
1.7.10.4



