Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756670AbaDWB2C (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2014 21:28:02 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:46794 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755207AbaDWB17 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2014 21:27:59 -0400
From: Joel Fernandes <joelf@ti.com>
To: Tony Lindgren <tony@atomide.com>, Rob Herring <rob.herring@calxeda.com>,
        Linux OMAP List <linux-omap@vger.kernel.org>,
        Linux ARM Kernel List <linux-arm-kernel@lists.infradead.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
CC: Joel Fernandes <joelf@ti.com>
Subject: [PATCH 8/8] ARM: OMAP2+: timer: Add legacy code for old way of getting fclk
Date: Tue, 22 Apr 2014 20:27:09 -0500
Message-ID: <1398216429-4681-9-git-send-email-joelf@ti.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1398216429-4681-1-git-send-email-joelf@ti.com>
References: <1398216429-4681-1-git-send-email-joelf@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Separate out legacy code for getting timer->fclk and reuse it for
the DT-case as a fallback. All DT users should ideally be specifying
a clock property with a phandle of its clock node. Till the migration
is complete, add a legacy function to keep things working.

Signed-off-by: Joel Fernandes <joelf@ti.com>
---
 arch/arm/mach-omap2/timer.c |   32 ++++++++++++++++++++++++--------
 1 file changed, 24 insertions(+), 8 deletions(-)

diff --git a/arch/arm/mach-omap2/timer.c b/arch/arm/mach-omap2/timer.c
index b3db1da..81a29b1 100644
--- a/arch/arm/mach-omap2/timer.c
+++ b/arch/arm/mach-omap2/timer.c
@@ -248,6 +248,19 @@ static u32 __init omap_dm_timer_get_errata(void)
 	return OMAP_TIMER_ERRATA_I103_I767;
 }
 
+static int legacy_hwmod_clkget(struct omap_dm_timer *timer, const char *oh_name)
+{
+	struct omap_hwmod *oh;
+
+	oh = omap_hwmod_lookup(oh_name);
+	if (!oh)
+		return -ENODEV;
+
+	timer->fclk = clk_get(NULL, omap_hwmod_get_main_clk(oh));
+	if (IS_ERR(timer->fclk))
+		return PTR_ERR(timer->fclk);
+}
+
 static int __init omap_dm_timer_init_one(struct omap_dm_timer *timer,
 					 const char *fck_source,
 					 const char *property,
@@ -289,6 +302,14 @@ static int __init omap_dm_timer_init_one(struct omap_dm_timer *timer,
 			 * fall back code is to be deleted and we're to return
 			 * PTR_ERR(timer->fclk) here.
 			 */
+			of_property_read_string_index(np, "ti,hwmods", 0,
+						      &oh_name);
+			if (!oh_name)
+				return -ENODEV;
+
+			r = legacy_hwmod_clkget(timer, oh_name);
+			if (r)
+				return r;
 		}
 	} else {
 		if (omap_dm_timer_reserve_systimer(timer->id))
@@ -320,15 +341,10 @@ static int __init omap_dm_timer_init_one(struct omap_dm_timer *timer,
 
 		omap_hwmod_setup_one(oh_name);
 		omap_hwmod_enable(oh);
-	}
 
-	if (!timer->fclk || IS_ERR(timer->fclk)) {
-		oh = omap_hwmod_lookup(oh_name);
-		if (!oh)
-			return -ENODEV;
-		timer->fclk = clk_get(NULL, omap_hwmod_get_main_clk(oh));
-		if (IS_ERR(timer->fclk))
-			return PTR_ERR(timer->fclk);
+		r = legacy_hwmod_clkget(timer, oh_name);
+		if (r)
+			return r;
 	}
 
 	/*
-- 
1.7.9.5

