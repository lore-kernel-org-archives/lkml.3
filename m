Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933513AbaJUUW7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Oct 2014 16:22:59 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:51560 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933433AbaJUUWz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Oct 2014 16:22:55 -0400
From: Nishanth Menon <nm@ti.com>
To: Tony Lindgren <tony@atomide.com>,
        Kevin Hilman <khilman@deeprootsystems.com>
CC: <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux-omap@vger.kernel.org>, Tero Kristo <t-kristo@ti.com>,
        Nishanth Menon <nm@ti.com>
Subject: [PATCH 1/2] ARM: OMAP4: PM: Only do static dependency configuration in omap4_init_static_deps
Date: Tue, 21 Oct 2014 15:22:28 -0500
Message-ID: <1413922949-22300-2-git-send-email-nm@ti.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1413922949-22300-1-git-send-email-nm@ti.com>
References: <1413922949-22300-1-git-send-email-nm@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit 705814b5ea6f ("ARM: OMAP4+: PM: Consolidate OMAP4 PM code to
re-use it for OMAP5")

Moved logic generic for OMAP5+ as part of the init routine by
introducing omap4_pm_init. However, the patch left the powerdomain
initial setup, an unused omap4430 es1.0 check and a spurious log
"Power Management for TI OMAP4." in the original code.

Remove the duplicate code which is already present in omap4_pm_init from
omap4_init_static_deps.

As part of this change, also move the u-boot version print out of the
static dependency function to the omap4_pm_init function.

Fixes: 705814b5ea6f ("ARM: OMAP4+: PM: Consolidate OMAP4 PM code to re-use it for OMAP5")
Signed-off-by: Nishanth Menon <nm@ti.com>
---
 arch/arm/mach-omap2/pm44xx.c |   29 +++++++++--------------------
 1 file changed, 9 insertions(+), 20 deletions(-)

diff --git a/arch/arm/mach-omap2/pm44xx.c b/arch/arm/mach-omap2/pm44xx.c
index 503097c..e7f823b 100644
--- a/arch/arm/mach-omap2/pm44xx.c
+++ b/arch/arm/mach-omap2/pm44xx.c
@@ -160,26 +160,6 @@ static inline int omap4_init_static_deps(void)
 	struct clockdomain *ducati_clkdm, *l3_2_clkdm;
 	int ret = 0;
 
-	if (omap_rev() == OMAP4430_REV_ES1_0) {
-		WARN(1, "Power Management not supported on OMAP4430 ES1.0\n");
-		return -ENODEV;
-	}
-
-	pr_err("Power Management for TI OMAP4.\n");
-	/*
-	 * OMAP4 chip PM currently works only with certain (newer)
-	 * versions of bootloaders. This is due to missing code in the
-	 * kernel to properly reset and initialize some devices.
-	 * http://www.spinics.net/lists/arm-kernel/msg218641.html
-	 */
-	pr_warn("OMAP4 PM: u-boot >= v2012.07 is required for full PM support\n");
-
-	ret = pwrdm_for_each(pwrdms_setup, NULL);
-	if (ret) {
-		pr_err("Failed to setup powerdomains\n");
-		return ret;
-	}
-
 	/*
 	 * The dynamic dependency between MPUSS -> MEMIF and
 	 * MPUSS -> L4_PER/L3_* and DUCATI -> L3_* doesn't work as
@@ -272,6 +252,15 @@ int __init omap4_pm_init(void)
 
 	pr_info("Power Management for TI OMAP4+ devices.\n");
 
+	/*
+	 * OMAP4 chip PM currently works only with certain (newer)
+	 * versions of bootloaders. This is due to missing code in the
+	 * kernel to properly reset and initialize some devices.
+	 * http://www.spinics.net/lists/arm-kernel/msg218641.html
+	 */
+	if (cpu_is_omap44xx())
+		pr_warn("OMAP4 PM: u-boot >= v2012.07 is required for full PM support\n");
+
 	ret = pwrdm_for_each(pwrdms_setup, NULL);
 	if (ret) {
 		pr_err("Failed to setup powerdomains.\n");
-- 
1.7.9.5

