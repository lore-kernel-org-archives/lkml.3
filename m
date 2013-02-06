Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757950Ab3BFTAX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Feb 2013 14:00:23 -0500
Received: from mail-ee0-f41.google.com ([74.125.83.41]:60622 "EHLO
	mail-ee0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755877Ab3BFTAS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Feb 2013 14:00:18 -0500
From: Ruslan Bilovol <ruslan.bilovol@ti.com>
To: tony@atomide.com, linux@arm.linux.org.uk,
        linux-arm-kernel@lists.infradead.org, linux-omap@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2 1/2] ARM: OMAP2+: SoC name and revision unification
Date: Wed,  6 Feb 2013 20:59:55 +0200
Message-Id: <1360177196-18196-2-git-send-email-ruslan.bilovol@ti.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1360177196-18196-1-git-send-email-ruslan.bilovol@ti.com>
References: <1360177196-18196-1-git-send-email-ruslan.bilovol@ti.com>
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
 arch/arm/mach-omap2/id.c |   89 ++++++++++++++++++++++++++--------------------
 1 file changed, 51 insertions(+), 38 deletions(-)

diff --git a/arch/arm/mach-omap2/id.c b/arch/arm/mach-omap2/id.c
index 8a68f1e..b16a432 100644
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
 
@@ -181,8 +187,7 @@ void __init omap2xxx_check_revision(void)
 
 static void __init omap3_cpuinfo(void)
 {
-	const char *cpu_name;
-
+	const char *omap3_soc_name;
 	/*
 	 * OMAP3430 and OMAP3530 are assumed to be same.
 	 *
@@ -191,28 +196,30 @@ static void __init omap3_cpuinfo(void)
 	 * and CPU class bits.
 	 */
 	if (cpu_is_omap3630()) {
-		cpu_name = "OMAP3630";
+		omap3_soc_name = "OMAP3630";
 	} else if (soc_is_am35xx()) {
-		cpu_name = (omap3_has_sgx()) ? "AM3517" : "AM3505";
+		omap3_soc_name = (omap3_has_sgx()) ? "AM3517" : "AM3505";
 	} else if (cpu_is_ti816x()) {
-		cpu_name = "TI816X";
+		omap3_soc_name = "TI816X";
 	} else if (soc_is_am335x()) {
-		cpu_name =  "AM335X";
+		omap3_soc_name =  "AM335X";
 	} else if (cpu_is_ti814x()) {
-		cpu_name = "TI814X";
+		omap3_soc_name = "TI814X";
 	} else if (omap3_has_iva() && omap3_has_sgx()) {
 		/* OMAP3430, OMAP3525, OMAP3515, OMAP3503 devices */
-		cpu_name = "OMAP3430/3530";
+		omap3_soc_name = "OMAP3430/3530";
 	} else if (omap3_has_iva()) {
-		cpu_name = "OMAP3525";
+		omap3_soc_name = "OMAP3525";
 	} else if (omap3_has_sgx()) {
-		cpu_name = "OMAP3515";
+		omap3_soc_name = "OMAP3515";
 	} else {
-		cpu_name = "OMAP3503";
+		omap3_soc_name = "OMAP3503";
 	}
 
+	sprintf(soc_name, "%s", omap3_soc_name);
+
 	/* Print verbose information */
-	pr_info("%s ES%s (", cpu_name, cpu_rev);
+	pr_info("%s %s (", soc_name, soc_rev);
 
 	OMAP3_SHOW_FEATURE(l2cache);
 	OMAP3_SHOW_FEATURE(iva);
@@ -291,6 +298,7 @@ void __init ti81xx_check_features(void)
 
 void __init omap3xxx_check_revision(void)
 {
+	const char *omap3_soc_rev;
 	u32 cpuid, idcode;
 	u16 hawkeye;
 	u8 rev;
@@ -303,7 +311,7 @@ void __init omap3xxx_check_revision(void)
 	cpuid = read_cpuid(CPUID_ID);
 	if ((((cpuid >> 4) & 0xfff) == 0xc08) && ((cpuid & 0xf) == 0x0)) {
 		omap_revision = OMAP3430_REV_ES1_0;
-		cpu_rev = "1.0";
+		omap3_soc_rev = "ES1.0";
 		return;
 	}
 
@@ -324,26 +332,26 @@ void __init omap3xxx_check_revision(void)
 		case 0: /* Take care of early samples */
 		case 1:
 			omap_revision = OMAP3430_REV_ES2_0;
-			cpu_rev = "2.0";
+			omap3_soc_rev = "ES2.0";
 			break;
 		case 2:
 			omap_revision = OMAP3430_REV_ES2_1;
-			cpu_rev = "2.1";
+			omap3_soc_rev = "ES2.1";
 			break;
 		case 3:
 			omap_revision = OMAP3430_REV_ES3_0;
-			cpu_rev = "3.0";
+			omap3_soc_rev = "ES3.0";
 			break;
 		case 4:
 			omap_revision = OMAP3430_REV_ES3_1;
-			cpu_rev = "3.1";
+			omap3_soc_rev = "ES3.1";
 			break;
 		case 7:
 		/* FALLTHROUGH */
 		default:
 			/* Use the latest known revision as default */
 			omap_revision = OMAP3430_REV_ES3_1_2;
-			cpu_rev = "3.1.2";
+			omap3_soc_rev = "ES3.1.2";
 		}
 		break;
 	case 0xb868:
@@ -356,13 +364,13 @@ void __init omap3xxx_check_revision(void)
 		switch (rev) {
 		case 0:
 			omap_revision = AM35XX_REV_ES1_0;
-			cpu_rev = "1.0";
+			omap3_soc_rev = "ES1.0";
 			break;
 		case 1:
 		/* FALLTHROUGH */
 		default:
 			omap_revision = AM35XX_REV_ES1_1;
-			cpu_rev = "1.1";
+			omap3_soc_rev = "ES1.1";
 		}
 		break;
 	case 0xb891:
@@ -371,30 +379,30 @@ void __init omap3xxx_check_revision(void)
 		switch(rev) {
 		case 0: /* Take care of early samples */
 			omap_revision = OMAP3630_REV_ES1_0;
-			cpu_rev = "1.0";
+			omap3_soc_rev = "1.0";
 			break;
 		case 1:
 			omap_revision = OMAP3630_REV_ES1_1;
-			cpu_rev = "1.1";
+			omap3_soc_rev = "ES1.1";
 			break;
 		case 2:
 		/* FALLTHROUGH */
 		default:
 			omap_revision = OMAP3630_REV_ES1_2;
-			cpu_rev = "1.2";
+			omap3_soc_rev = "ES1.2";
 		}
 		break;
 	case 0xb81e:
 		switch (rev) {
 		case 0:
 			omap_revision = TI8168_REV_ES1_0;
-			cpu_rev = "1.0";
+			omap3_soc_rev = "ES1.0";
 			break;
 		case 1:
 		/* FALLTHROUGH */
 		default:
 			omap_revision = TI8168_REV_ES1_1;
-			cpu_rev = "1.1";
+			omap3_soc_rev = "ES1.1";
 			break;
 		}
 		break;
@@ -402,13 +410,13 @@ void __init omap3xxx_check_revision(void)
 		switch (rev) {
 		case 0:
 			omap_revision = AM335X_REV_ES1_0;
-			cpu_rev = "1.0";
+			omap3_soc_rev = "1.0";
 			break;
 		case 1:
 		/* FALLTHROUGH */
 		default:
 			omap_revision = AM335X_REV_ES2_0;
-			cpu_rev = "2.0";
+			omap3_soc_rev = "2.0";
 			break;
 		}
 		break;
@@ -418,26 +426,27 @@ void __init omap3xxx_check_revision(void)
 		/* FALLTHROUGH */
 		case 1:
 			omap_revision = TI8148_REV_ES1_0;
-			cpu_rev = "1.0";
+			omap3_soc_rev = "ES1.0";
 			break;
 		case 2:
 			omap_revision = TI8148_REV_ES2_0;
-			cpu_rev = "2.0";
+			omap3_soc_rev = "ES2.0";
 			break;
 		case 3:
 		/* FALLTHROUGH */
 		default:
 			omap_revision = TI8148_REV_ES2_1;
-			cpu_rev = "2.1";
+			omap3_soc_rev = "ES2.1";
 			break;
 		}
 		break;
 	default:
 		/* Unknown default to latest silicon rev as default */
 		omap_revision = OMAP3630_REV_ES1_2;
-		cpu_rev = "1.2";
+		omap3_soc_rev = "ES1.2";
 		pr_warn("Warning: unknown chip type; assuming OMAP3630ES1.2\n");
 	}
+	sprintf(soc_rev, "%s", omap3_soc_rev);
 }
 
 void __init omap4xxx_check_revision(void)
@@ -512,8 +521,10 @@ void __init omap4xxx_check_revision(void)
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
@@ -547,8 +558,10 @@ void __init omap5xxx_check_revision(void)
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

