Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758289Ab3BFWvB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Feb 2013 17:51:01 -0500
Received: from mail-ee0-f47.google.com ([74.125.83.47]:43917 "EHLO
	mail-ee0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757961Ab3BFWu6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Feb 2013 17:50:58 -0500
From: Ruslan Bilovol <ruslan.bilovol@ti.com>
To: tony@atomide.com, linux@arm.linux.org.uk,
        linux-arm-kernel@lists.infradead.org, linux-omap@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v3 1/2] ARM: OMAP2+: SoC name and revision unification
Date: Thu,  7 Feb 2013 00:50:48 +0200
Message-Id: <1360191049-24017-2-git-send-email-ruslan.bilovol@ti.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1360191049-24017-1-git-send-email-ruslan.bilovol@ti.com>
References: <1360191049-24017-1-git-send-email-ruslan.bilovol@ti.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a long story where for each new generation of
OMAP we used different approaches for creating
strings for SoCs names and revisions that this patch
fixes. It makes future exporting of this information
to SoC infrastructure easier.

Signed-off-by: Ruslan Bilovol <ruslan.bilovol@ti.com>
---
 arch/arm/mach-omap2/id.c |   30 ++++++++++++++++++++++--------
 1 file changed, 22 insertions(+), 8 deletions(-)

diff --git a/arch/arm/mach-omap2/id.c b/arch/arm/mach-omap2/id.c
index 8a68f1e..3737700 100644
--- a/arch/arm/mach-omap2/id.c
+++ b/arch/arm/mach-omap2/id.c
@@ -31,8 +31,11 @@
 #define OMAP4_SILICON_TYPE_STANDARD		0x01
 #define OMAP4_SILICON_TYPE_PERFORMANCE		0x02
 
+#define OMAP_SOC_MAX_NAME_LENGTH		16
+
 static unsigned int omap_revision;
-static const char *cpu_rev;
+static char soc_name[OMAP_SOC_MAX_NAME_LENGTH];
+static char soc_rev[OMAP_SOC_MAX_NAME_LENGTH];
 u32 omap_features;
 
 unsigned int omap_rev(void)
@@ -169,9 +172,12 @@ void __init omap2xxx_check_revision(void)
 		j = i;
 	}
 
-	pr_info("OMAP%04x", omap_rev() >> 16);
+	sprintf(soc_name, "OMAP%04x", omap_rev() >> 16);
+	sprintf(soc_rev, "ES%x", (omap_rev() >> 12) & 0xf);
+
+	pr_info("%s", soc_name);
 	if ((omap_rev() >> 8) & 0x0f)
-		pr_info("ES%x", (omap_rev() >> 12) & 0xf);
+		pr_info("%s", soc_rev);
 	pr_info("\n");
 }
 
@@ -211,8 +217,10 @@ static void __init omap3_cpuinfo(void)
 		cpu_name = "OMAP3503";
 	}
 
+	sprintf(soc_name, "%s", cpu_name);
+
 	/* Print verbose information */
-	pr_info("%s ES%s (", cpu_name, cpu_rev);
+	pr_info("%s %s (", soc_name, soc_rev);
 
 	OMAP3_SHOW_FEATURE(l2cache);
 	OMAP3_SHOW_FEATURE(iva);
@@ -291,6 +299,7 @@ void __init ti81xx_check_features(void)
 
 void __init omap3xxx_check_revision(void)
 {
+	const char *cpu_rev;
 	u32 cpuid, idcode;
 	u16 hawkeye;
 	u8 rev;
@@ -438,6 +447,7 @@ void __init omap3xxx_check_revision(void)
 		cpu_rev = "1.2";
 		pr_warn("Warning: unknown chip type; assuming OMAP3630ES1.2\n");
 	}
+	sprintf(soc_rev, "ES%s", cpu_rev);
 }
 
 void __init omap4xxx_check_revision(void)
@@ -512,8 +522,10 @@ void __init omap4xxx_check_revision(void)
 		omap_revision = OMAP4430_REV_ES2_3;
 	}
 
-	pr_info("OMAP%04x ES%d.%d\n", omap_rev() >> 16,
-		((omap_rev() >> 12) & 0xf), ((omap_rev() >> 8) & 0xf));
+	sprintf(soc_name, "OMAP%04x", omap_rev() >> 16);
+	sprintf(soc_rev, "ES%d.%d", (omap_rev() >> 12) & 0xf,
+						(omap_rev() >> 8) & 0xf);
+	pr_info("%s %s\n", soc_name, soc_rev);
 }
 
 void __init omap5xxx_check_revision(void)
@@ -547,8 +559,10 @@ void __init omap5xxx_check_revision(void)
 		omap_revision = OMAP5430_REV_ES1_0;
 	}
 
-	pr_info("OMAP%04x ES%d.0\n",
-			omap_rev() >> 16, ((omap_rev() >> 12) & 0xf));
+	sprintf(soc_name, "OMAP%04x", omap_rev() >> 16);
+	sprintf(soc_rev, "ES%d.0", (omap_rev() >> 12) & 0xf);
+
+	pr_info("%s %s\n", soc_name, soc_rev);
 }
 
 /*
-- 
1.7.9.5

