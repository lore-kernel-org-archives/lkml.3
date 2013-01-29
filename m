Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756904Ab3A2Pyw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jan 2013 10:54:52 -0500
Received: from devils.ext.ti.com ([198.47.26.153]:43508 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756135Ab3A2Pyr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jan 2013 10:54:47 -0500
From: Ruslan Bilovol <ruslan.bilovol@ti.com>
To: <linux-arm-kernel@lists.infradead.org>, <linux-omap@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <tony@atomide.com>,
        <linux@arm.linux.org.uk>
Subject: [RFC PATCH 2/2] ARM: OMAP4: setup CPU model name during ID initialisation
Date: Tue, 29 Jan 2013 17:54:25 +0200
Message-ID: <1359474865-15408-3-git-send-email-ruslan.bilovol@ti.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1359474865-15408-1-git-send-email-ruslan.bilovol@ti.com>
References: <1359474865-15408-1-git-send-email-ruslan.bilovol@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Set up the CPU model name during OMAP ID initialisation
so it will be displayed in /proc/cpuinfo:

/ # cat proc/cpuinfo
processor       : 0
model name      : ARMv7 Processor rev 10 (v7l)
BogoMIPS        : 1590.23
Features        : swp half thumb fastmult vfp edsp thumbee neon vfpv3 tls
CPU implementer : 0x41
CPU name        : OMAP4470 ES1.0 HS
CPU architecture: 7
CPU variant     : 0x2
CPU part        : 0xc09
CPU revision    : 10
[...]

Signed-off-by: Ruslan Bilovol <ruslan.bilovol@ti.com>
---
 arch/arm/mach-omap2/id.c |   18 ++++++++++++++++--
 1 file changed, 16 insertions(+), 2 deletions(-)

diff --git a/arch/arm/mach-omap2/id.c b/arch/arm/mach-omap2/id.c
index 45cc7ed4..d1416e9 100644
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
+static char omap_cpu_model_name[80];
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
+	sprintf(omap_cpu_model_name, "OMAP%04x ES%d.%d %s", omap_rev() >> 16,
+			((omap_rev() >> 12) & 0xf), ((omap_rev() >> 8) & 0xf),
+			omap_types[omap_type()]);
+	set_cpu_model_name(omap_cpu_model_name);
+
+	pr_info("%s\n", omap_cpu_model_name);
 }
 
 void __init omap5xxx_check_revision(void)
-- 
1.7.9.5

