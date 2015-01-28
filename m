Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760947AbbA2JQb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jan 2015 04:16:31 -0500
Received: from ip4-83-240-67-251.cust.nbox.cz ([83.240.67.251]:44917 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S932622AbbA2JIA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jan 2015 04:08:00 -0500
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Nishanth Menon <nm@ti.com>,
        Tony Lindgren <tony@atomide.com>, Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 046/176] ARM: OMAP4: PM: Only do static dependency configuration in omap4_init_static_deps
Date: Wed, 28 Jan 2015 15:27:56 +0100
Message-Id: <02d684c2515b8bbe11b9ce1345840d5c855dc685.1422455352.git.jslaby@suse.cz>
X-Mailer: git-send-email 2.2.2
In-Reply-To: <ce4a451f616a1e7ab58cfeceea5e49c8b1c68c81.1422455352.git.jslaby@suse.cz>
References: <ce4a451f616a1e7ab58cfeceea5e49c8b1c68c81.1422455352.git.jslaby@suse.cz>
In-Reply-To: <cover.1422455352.git.jslaby@suse.cz>
References: <cover.1422455352.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Nishanth Menon <nm@ti.com>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

commit 9008d83fe9dc2e0f19b8ba17a423b3759d8e0fd7 upstream.

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
Signed-off-by: Tony Lindgren <tony@atomide.com>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 arch/arm/mach-omap2/pm44xx.c | 29 +++++++++--------------------
 1 file changed, 9 insertions(+), 20 deletions(-)

diff --git a/arch/arm/mach-omap2/pm44xx.c b/arch/arm/mach-omap2/pm44xx.c
index 82f0698933d8..6be33ceb9853 100644
--- a/arch/arm/mach-omap2/pm44xx.c
+++ b/arch/arm/mach-omap2/pm44xx.c
@@ -146,26 +146,6 @@ static inline int omap4_init_static_deps(void)
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
@@ -216,6 +196,15 @@ int __init omap4_pm_init(void)
 
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
2.2.2

