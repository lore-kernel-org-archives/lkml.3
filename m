Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757094AbaEPKqc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 May 2014 06:46:32 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:41647 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756740AbaEPKq1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 May 2014 06:46:27 -0400
From: Nishanth Menon <nm@ti.com>
To: =?UTF-8?q?Beno=C3=AEt=20Cousson?= <bcousson@baylibre.com>,
        Tony Lindgren <tony@atomide.com>,
        Mike Turquette <mturquette@linaro.org>, Tero Kristo <t-kristo@ti.com>,
        Paul <paul@pwsan.com>
CC: Nishanth Menon <nm@ti.com>, <devicetree@vger.kernel.org>,
        <linux-doc@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <linux-omap@vger.kernel.org>
Subject: [PATCH 1/3] ARM: OMAP5+: dpll: support Duty Cycle Correction(DCC)
Date: Fri, 16 May 2014 05:45:58 -0500
Message-ID: <1400237160-25125-2-git-send-email-nm@ti.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1400237160-25125-1-git-send-email-nm@ti.com>
References: <1400237160-25125-1-git-send-email-nm@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andrii Tseglytskyi <andrii.tseglytskyi@ti.com>

Duty Cycle Correction(DCC) needs to be enabled if the MPU is to run at
frequencies beyond 1.4GHz for OMAP5, DRA75x, DRA72x.

MPU DPLL has a limitation on the maximum frequency it can be locked
at. Duty Cycle Correction circuit is used to recover a correct duty
cycle for achieving higher frequencies (hardware internally switches
output to M3 output(CLKOUTHIF) from M2 output (CLKOUT)).

For further information, See the note on OMAP5432 Technical Reference
Manual(SWPU282U) chapter 3.6.3.3.1 "DPLLs Output Clocks Parameters",
and also the "OMAP543x ES2.0 DM Operating Conditions Addendum v0.5"
chapter 2.1 "Micro Processor Unit (MPU)". Equivalent information is
present in relevant DRA75x, 72x documentation(SPRUHP2E, SPRUHI2P).

Signed-off-by: Andrii Tseglytskyi <andrii.tseglytskyi@ti.com>
Signed-off-by: Taras Kondratiuk <taras@ti.com>
Signed-off-by: J Keerthy <j-keerthy@ti.com>
Signed-off-by: Nishanth Menon <nm@ti.com>
[t-kristo@ti.com: added TRM / DM references for DCC clock rate]
Signed-off-by: Tero Kristo <t-kristo@ti.com>
---
 arch/arm/mach-omap2/dpll3xxx.c |    9 +++++++++
 include/linux/clk/ti.h         |    4 ++++
 2 files changed, 13 insertions(+)

diff --git a/arch/arm/mach-omap2/dpll3xxx.c b/arch/arm/mach-omap2/dpll3xxx.c
index fcd8036..6d7ba37 100644
--- a/arch/arm/mach-omap2/dpll3xxx.c
+++ b/arch/arm/mach-omap2/dpll3xxx.c
@@ -319,6 +319,15 @@ static int omap3_noncore_dpll_program(struct clk_hw_omap *clk, u16 freqsel)
 
 	/* Set DPLL multiplier, divider */
 	v = omap2_clk_readl(clk, dd->mult_div1_reg);
+
+	/* Handle Duty Cycle Correction */
+	if (dd->dcc_mask) {
+		if (dd->last_rounded_rate >= dd->dcc_rate)
+			v |= dd->dcc_mask; /* Enable DCC */
+		else
+			v &= ~dd->dcc_mask; /* Disable DCC */
+	}
+
 	v &= ~(dd->mult_mask | dd->div1_mask);
 	v |= dd->last_rounded_m << __ffs(dd->mult_mask);
 	v |= (dd->last_rounded_n - 1) << __ffs(dd->div1_mask);
diff --git a/include/linux/clk/ti.h b/include/linux/clk/ti.h
index 4a21a87..1f5c55e 100644
--- a/include/linux/clk/ti.h
+++ b/include/linux/clk/ti.h
@@ -41,6 +41,8 @@
  * @idlest_reg: register containing the DPLL idle status bitfield
  * @autoidle_mask: mask of the DPLL autoidle mode bitfield in @autoidle_reg
  * @freqsel_mask: mask of the DPLL jitter correction bitfield in @control_reg
+ * @dcc_mask: mask of the DPLL DCC correction bitfield @mult_div1_reg
+ * @dcc_rate: rate atleast which DCC @dcc_mask must be set
  * @idlest_mask: mask of the DPLL idle status bitfield in @idlest_reg
  * @lpmode_mask: mask of the DPLL low-power mode bitfield in @control_reg
  * @m4xen_mask: mask of the DPLL M4X multiplier bitfield in @control_reg
@@ -86,6 +88,8 @@ struct dpll_data {
 	u32			idlest_mask;
 	u32			dco_mask;
 	u32			sddiv_mask;
+	u32			dcc_mask;
+	unsigned long		dcc_rate;
 	u32			lpmode_mask;
 	u32			m4xen_mask;
 	u8			auto_recal_bit;
-- 
1.7.9.5

