Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758295Ab3CUNsi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Mar 2013 09:48:38 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:59821 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758173Ab3CUNsh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Mar 2013 09:48:37 -0400
From: Roger Quadros <rogerq@ti.com>
To: <tony@atomide.com>
CC: <balbi@ti.com>, <rnayak@ti.com>, <t-kristo@ti.com>,
        <linux-omap@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>, Roger Quadros <rogerq@ti.com>
Subject: [PATCH] ARM: OMAP4: clock: Initialize USB DPLL
Date: Thu, 21 Mar 2013 15:48:25 +0200
Message-ID: <1363873705-3224-1-git-send-email-rogerq@ti.com>
X-Mailer: git-send-email 1.7.4.1
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If the bootloader doesn't configure USB DPLL (e.g. in u-boot,
disable CONFIG_USB_EHCI_OMAP), then we get all sorts of problems
like
- division by zero errors at boot [1]
- USB DPLL fails to enter locked state
- USB EHCI Host is non functional
- Device can't enter OFF mode

Initializing the USB DPLL fixes all these issues.

[1]

[    0.000000] clock: dpll_usb_ck failed transition to 'locked'
[    0.000000] Division by zero in kernel.
[    0.000000] [<c001b00c>] (unwind_backtrace+0x0/0xf0) from [<c02b2378>] (Ldiv0+0x8/0x10)
[    0.000000] [<c02b2378>] (Ldiv0+0x8/0x10) from [<c041cf3c>] (clk_divider_set_rate+0x10/0x124)
[    0.000000] [<c041cf3c>] (clk_divider_set_rate+0x10/0x124) from [<c041bfc4>] (clk_change_rate+0x3c/0xb4)
[    0.000000] [<c041bfc4>] (clk_change_rate+0x3c/0xb4) from [<c041c028>] (clk_change_rate+0xa0/0xb4)

Signed-off-by: Roger Quadros <rogerq@ti.com>
---
 arch/arm/mach-omap2/cclock44xx_data.c |   19 +++++++++++++++++++
 1 files changed, 19 insertions(+), 0 deletions(-)

diff --git a/arch/arm/mach-omap2/cclock44xx_data.c b/arch/arm/mach-omap2/cclock44xx_data.c
index bfc46c1..6127bb9 100644
--- a/arch/arm/mach-omap2/cclock44xx_data.c
+++ b/arch/arm/mach-omap2/cclock44xx_data.c
@@ -53,6 +53,12 @@
  */
 #define OMAP4_DPLL_ABE_DEFFREQ				98304000
 
+/*
+ * OMAP4450 TRM Rev X, section "3.6.3.9.5 DPLL_USB Preferred Settings"
+ * states it must be at 960MHz
+ */
+#define OMAP4_DPLL_USB_DEFFREQ				960000000
+
 /* Root clocks */
 
 DEFINE_CLK_FIXED_RATE(extalt_clkin_ck, CLK_IS_ROOT, 59000000, 0x0);
@@ -1729,6 +1735,19 @@ int __init omap4xxx_clk_init(void)
 	omap2_clk_disable_autoidle_all();
 
 	/*
+	 * Lock USB_DPLL to avoid issues with USB host and OFF mode
+	 */
+	rc = clk_set_rate(&dpll_usb_ck, OMAP4_DPLL_USB_DEFFREQ);
+	if (rc) {
+		pr_err("%s: failed to configure DPLL_USB: %d\n", __func__, rc);
+	} else {
+		rc = clk_set_rate(&dpll_usb_m2_ck, OMAP4_DPLL_USB_DEFFREQ/2);
+		if (rc)
+			pr_err("%s: failed to configure DPLL_USB_M2: %d\n",
+								__func__, rc);
+	}
+
+	/*
 	 * On OMAP4460 the ABE DPLL fails to turn on if in idle low-power
 	 * state when turning the ABE clock domain. Workaround this by
 	 * locking the ABE DPLL on boot.
-- 
1.7.4.1

