Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758000Ab3FEWLf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Jun 2013 18:11:35 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:37620 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757854Ab3FEVfB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Jun 2013 17:35:01 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Vaibhav Hiremath <hvaibhav@ti.com>, Rajendra Nayak <rnayak@ti.com>,
        Paul Walmsley <paul@pwsan.com>, Tony Lindgren <tony@atomide.com>
Subject: [ 006/127] ARM: AM33XX: Add missing .clkdm_name to clkdiv32k_ick clock
Date: Wed,  5 Jun 2013 14:32:53 -0700
Message-Id: <20130605213218.719499547@linuxfoundation.org>
X-Mailer: git-send-email 1.8.3.rc0.20.gb99dd2e
In-Reply-To: <20130605213217.966891866@linuxfoundation.org>
References: <20130605213217.966891866@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Vaibhav Hiremath <hvaibhav@ti.com>

commit a6d25f4c951b8b28f2eaec6f891ff834622532f2 upstream.

It is required to enable respective clock-domain before
enabling any clock/module inside that clock-domain.

During common-clock migration, .clkdm_name field got missed
for "clkdiv32k_ick" clock, which leaves "clk_24mhz_clkdm"
unused; so it will be disabled even if childs of this clock-domain
is enabled, which keeps child modules in idle mode.

This fixes the kernel crash observed on AM335xEVM-SK platform,
where clkdiv32_ick clock is being used as a gpio debounce clock
and since clkdiv32k_ick is in idle mode it leads to below crash -

Crash Log:
==========
[    2.598347] Unhandled fault: external abort on non-linefetch (0x1028) at
0xfa1ac150
[    2.606434] Internal error: : 1028 [#1] SMP ARM
[    2.611207] Modules linked in:
[    2.614449] CPU: 0    Not tainted  (3.8.4-01382-g1f449cd-dirty #4)
[    2.620973] PC is at _set_gpio_debounce+0x60/0x104
[    2.626025] LR is at clk_enable+0x30/0x3c

Signed-off-by: Vaibhav Hiremath <hvaibhav@ti.com>
Cc: Rajendra Nayak <rnayak@ti.com>
Acked-by: Paul Walmsley <paul@pwsan.com>
Signed-off-by: Tony Lindgren <tony@atomide.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/arm/mach-omap2/cclock33xx_data.c |   26 +++++++++++++++++++++++---
 1 file changed, 23 insertions(+), 3 deletions(-)

--- a/arch/arm/mach-omap2/cclock33xx_data.c
+++ b/arch/arm/mach-omap2/cclock33xx_data.c
@@ -446,9 +446,29 @@ DEFINE_CLK_GATE(cefuse_fck, "sys_clkin_c
  */
 DEFINE_CLK_FIXED_FACTOR(clkdiv32k_ck, "clk_24mhz", &clk_24mhz, 0x0, 1, 732);
 
-DEFINE_CLK_GATE(clkdiv32k_ick, "clkdiv32k_ck", &clkdiv32k_ck, 0x0,
-		AM33XX_CM_PER_CLKDIV32K_CLKCTRL, AM33XX_MODULEMODE_SWCTRL_SHIFT,
-		0x0, NULL);
+static struct clk clkdiv32k_ick;
+
+static const char *clkdiv32k_ick_parent_names[] = {
+	"clkdiv32k_ck",
+};
+
+static const struct clk_ops clkdiv32k_ick_ops = {
+	.enable         = &omap2_dflt_clk_enable,
+	.disable        = &omap2_dflt_clk_disable,
+	.is_enabled     = &omap2_dflt_clk_is_enabled,
+	.init           = &omap2_init_clk_clkdm,
+};
+
+static struct clk_hw_omap clkdiv32k_ick_hw = {
+	.hw	= {
+		.clk	= &clkdiv32k_ick,
+	},
+	.enable_reg	= AM33XX_CM_PER_CLKDIV32K_CLKCTRL,
+	.enable_bit	= AM33XX_MODULEMODE_SWCTRL_SHIFT,
+	.clkdm_name	= "clk_24mhz_clkdm",
+};
+
+DEFINE_STRUCT_CLK(clkdiv32k_ick, clkdiv32k_ick_parent_names, clkdiv32k_ick_ops);
 
 /* "usbotg_fck" is an additional clock and not really a modulemode */
 DEFINE_CLK_GATE(usbotg_fck, "dpll_per_ck", &dpll_per_ck, 0x0,


