Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754966AbaAKTpu (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Jan 2014 14:45:50 -0500
Received: from mail-ee0-f49.google.com ([74.125.83.49]:53291 "EHLO
	mail-ee0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753730AbaAKTnS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Jan 2014 14:43:18 -0500
From: Tomasz Figa <tomasz.figa@gmail.com>
To: linux-pm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, devicetree@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>, Pavel Machek <pavel@ucw.cz>,
        Len Brown <len.brown@intel.com>, Russell King <linux@arm.linux.org.uk>,
        Kukjin Kim <kgene.kim@samsung.com>, Kumar Gala <galak@codeaurora.org>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Mark Rutland <mark.rutland@arm.com>, Pawel Moll <pawel.moll@arm.com>,
        Rob Herring <robh+dt@kernel.org>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Tomasz Figa <t.figa@samsung.com>, Tomasz Figa <tomasz.figa@gmail.com>
Subject: [PATCH RFC 02/10] ARM: s3c64xx: pm: Add always_on field to s3c64xx_pm_domain struct
Date: Sat, 11 Jan 2014 20:42:44 +0100
Message-Id: <1389469372-17199-3-git-send-email-tomasz.figa@gmail.com>
X-Mailer: git-send-email 1.8.5.2
In-Reply-To: <1389469372-17199-1-git-send-email-tomasz.figa@gmail.com>
References: <1389469372-17199-1-git-send-email-tomasz.figa@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds always_on field to s3c64xx_pm_domain struct to allow
handling registration of all domains in the same way, without the need
to have separate arrays for normal and always on domains.

Signed-off-by: Tomasz Figa <tomasz.figa@gmail.com>
---
 arch/arm/mach-s3c64xx/pm.c | 21 ++++++++++++---------
 1 file changed, 12 insertions(+), 9 deletions(-)

diff --git a/arch/arm/mach-s3c64xx/pm.c b/arch/arm/mach-s3c64xx/pm.c
index 5238d66..605bfa9 100644
--- a/arch/arm/mach-s3c64xx/pm.c
+++ b/arch/arm/mach-s3c64xx/pm.c
@@ -35,6 +35,7 @@
 #include "regs-syscon-power.h"
 
 struct s3c64xx_pm_domain {
+	bool always_on;
 	u32 ena;
 	u32 pwr_stat;
 	struct generic_pm_domain pd;
@@ -84,6 +85,7 @@ static int s3c64xx_pd_on(struct generic_pm_domain *domain)
 }
 
 static struct s3c64xx_pm_domain s3c64xx_pm_irom = {
+	.always_on = true,
 	.ena = S3C64XX_NORMALCFG_IROM_ON,
 	.pd = {
 		.name = "domain_irom",
@@ -161,11 +163,8 @@ static struct s3c64xx_pm_domain s3c64xx_pm_v = {
 	},
 };
 
-static struct s3c64xx_pm_domain *s3c64xx_always_on_pm_domains[] = {
-	&s3c64xx_pm_irom,
-};
-
 static struct s3c64xx_pm_domain *s3c64xx_pm_domains[] = {
+	&s3c64xx_pm_irom,
 	&s3c64xx_pm_etm,
 	&s3c64xx_pm_g,
 	&s3c64xx_pm_v,
@@ -311,12 +310,16 @@ int __init s3c64xx_pm_init(void)
 
 	s3c_pm_init();
 
-	for (i = 0; i < ARRAY_SIZE(s3c64xx_always_on_pm_domains); i++)
-		pm_genpd_init(&s3c64xx_always_on_pm_domains[i]->pd,
-			      &pm_domain_always_on_gov, false);
 
-	for (i = 0; i < ARRAY_SIZE(s3c64xx_pm_domains); i++)
-		pm_genpd_init(&s3c64xx_pm_domains[i]->pd, NULL, false);
+	for (i = 0; i < ARRAY_SIZE(s3c64xx_pm_domains); i++) {
+		struct s3c64xx_pm_domain *pd = s3c64xx_pm_domains[i];
+		struct dev_power_governor *gov = NULL;
+
+		if (pd->always_on)
+			gov = &pm_domain_always_on_gov;
+
+		pm_genpd_init(&pd->pd, gov, false);
+	}
 
 #ifdef CONFIG_S3C_DEV_FB
 	if (dev_get_platdata(&s3c_device_fb.dev))
-- 
1.8.5.2

