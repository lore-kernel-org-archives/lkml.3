Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753401Ab3A3Aj0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jan 2013 19:39:26 -0500
Received: from mail-la0-f52.google.com ([209.85.215.52]:41812 "EHLO
	mail-la0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753250Ab3A3AjL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jan 2013 19:39:11 -0500
From: Ruslan Bilovol <ruslan.bilovol@ti.com>
To: linux-arm-kernel@lists.infradead.org, linux-omap@vger.kernel.org,
        linux-kernel@vger.kernel.org, tony@atomide.com, linux@arm.linux.org.uk,
        eduardo.valentin@ti.com
Subject: [RFC PATCH v2 2/2] ARM: OMAP4: setup SoC model name during ID initialisation
Date: Wed, 30 Jan 2013 02:38:57 +0200
Message-Id: <1359506337-21619-3-git-send-email-ruslan.bilovol@ti.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1359506337-21619-1-git-send-email-ruslan.bilovol@ti.com>
References: <1359506337-21619-1-git-send-email-ruslan.bilovol@ti.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Set up the SoC model name during OMAP ID initialisation
so it will be displayed in /proc/cpuinfo:

/ # cat proc/cpuinfo
[...]
CPU variant     : 0x2
CPU part        : 0xc09
CPU revision    : 10

SoC name        : OMAP4470 ES1.0 HS

Hardware        : OMAP4 Blaze Tablet
Revision        : 20edb4
[...]

Signed-off-by: Ruslan Bilovol <ruslan.bilovol@ti.com>
---
 arch/arm/mach-omap2/id.c |   18 ++++++++++++++++--
 1 file changed, 16 insertions(+), 2 deletions(-)

diff --git a/arch/arm/mach-omap2/id.c b/arch/arm/mach-omap2/id.c
index 45cc7ed4..b1fba35 100644
--- a/arch/arm/mach-omap2/id.c
+++ b/arch/arm/mach-omap2/id.c
@@ -20,6 +20,7 @@
 #include <linux/io.h>
 
 #include <asm/cputype.h>
+#include <asm/setup.h>
 
 #include "common.h"
 
@@ -33,8 +34,17 @@
 
 static unsigned int omap_revision;
 static const char *cpu_rev;
+static char omap_soc_model_name[80];
 u32 omap_features;
 
+static const char const *omap_types[] = {
+	[OMAP2_DEVICE_TYPE_TEST]	= "TST",
+	[OMAP2_DEVICE_TYPE_EMU]		= "EMU",
+	[OMAP2_DEVICE_TYPE_SEC]		= "HS",
+	[OMAP2_DEVICE_TYPE_GP]		= "GP",
+	[OMAP2_DEVICE_TYPE_BAD]		= "BAD",
+};
+
 unsigned int omap_rev(void)
 {
 	return omap_revision;
@@ -502,8 +512,12 @@ void __init omap4xxx_check_revision(void)
 		omap_revision = OMAP4430_REV_ES2_3;
 	}
 
-	pr_info("OMAP%04x ES%d.%d\n", omap_rev() >> 16,
-		((omap_rev() >> 12) & 0xf), ((omap_rev() >> 8) & 0xf));
+	sprintf(omap_soc_model_name, "OMAP%04x ES%d.%d %s", omap_rev() >> 16,
+			((omap_rev() >> 12) & 0xf), ((omap_rev() >> 8) & 0xf),
+			omap_types[omap_type()]);
+	set_soc_model_name(omap_soc_model_name);
+
+	pr_info("%s\n", omap_soc_model_name);
 }
 
 void __init omap5xxx_check_revision(void)
-- 
1.7.9.5

