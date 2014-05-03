Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753289AbaECSBL (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 May 2014 14:01:11 -0400
Received: from smtprelay05.ispgateway.de ([80.67.31.99]:57232 "EHLO
	smtprelay05.ispgateway.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752347AbaECSBI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 May 2014 14:01:08 -0400
From: Peter Feuerer <peter@piie.net>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Peter Feuerer <peter@piie.net>, Andrew Morton <akpm@linux-foundation.org>,
        Andreas Mohr <andi@lisas.de>, Borislav Petkov <bp@suse.de>
Subject: [PATCH v3 1/6] acerhdf: Adding support for "manual mode"
Date: Sat,  3 May 2014 19:59:21 +0200
Message-Id: <1399139966-10625-2-git-send-email-peter@piie.net>
X-Mailer: git-send-email 1.9.2
In-Reply-To: <1399139966-10625-1-git-send-email-peter@piie.net>
References: <1398561815-22033-1-git-send-email-peter@piie.net>
 <1399139966-10625-1-git-send-email-peter@piie.net>
X-Df-Sender: cGV0ZXJAcGlpZS5uZXQ=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Some Acer models require an additional command to turn off the fan after
bios mode has been enabled.  Adding new section in bios table to allow
support for those models, by writing an extra "manual mode" register.

Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Andreas Mohr <andi@lisas.de>
Cc: Borislav Petkov <bp@suse.de>
Signed-off-by: Peter Feuerer <peter@piie.net>
---
 drivers/platform/x86/acerhdf.c | 187 +++++++++++++++++++++++------------------
 1 file changed, 103 insertions(+), 84 deletions(-)

diff --git a/drivers/platform/x86/acerhdf.c b/drivers/platform/x86/acerhdf.c
index f94467c..dd63e93 100644
--- a/drivers/platform/x86/acerhdf.c
+++ b/drivers/platform/x86/acerhdf.c
@@ -50,7 +50,7 @@
  */
 #undef START_IN_KERNEL_MODE
 
-#define DRV_VER "0.5.26"
+#define DRV_VER "0.5.29"
 
 /*
  * According to the Atom N270 datasheet,
@@ -119,6 +119,17 @@ struct fancmd {
 	u8 cmd_auto;
 };
 
+struct manualcmd {
+	u8 mreg;
+	u8 moff;
+};
+
+/* default register and command to disable fan in manual mode */
+static const struct manualcmd mcmd = {
+	.mreg = 0x94,
+	.moff = 0xff,
+};
+
 /* BIOS settings */
 struct bios_settings_t {
 	const char *vendor;
@@ -127,105 +138,107 @@ struct bios_settings_t {
 	unsigned char fanreg;
 	unsigned char tempreg;
 	struct fancmd cmd;
+	int mcmd_enable;
 };
 
+
 /* Register addresses and values for different BIOS versions */
 static const struct bios_settings_t bios_tbl[] = {
 	/* AOA110 */
-	{"Acer", "AOA110", "v0.3109", 0x55, 0x58, {0x1f, 0x00} },
-	{"Acer", "AOA110", "v0.3114", 0x55, 0x58, {0x1f, 0x00} },
-	{"Acer", "AOA110", "v0.3301", 0x55, 0x58, {0xaf, 0x00} },
-	{"Acer", "AOA110", "v0.3304", 0x55, 0x58, {0xaf, 0x00} },
-	{"Acer", "AOA110", "v0.3305", 0x55, 0x58, {0xaf, 0x00} },
-	{"Acer", "AOA110", "v0.3307", 0x55, 0x58, {0xaf, 0x00} },
-	{"Acer", "AOA110", "v0.3308", 0x55, 0x58, {0x21, 0x00} },
-	{"Acer", "AOA110", "v0.3309", 0x55, 0x58, {0x21, 0x00} },
-	{"Acer", "AOA110", "v0.3310", 0x55, 0x58, {0x21, 0x00} },
+	{"Acer", "AOA110", "v0.3109", 0x55, 0x58, {0x1f, 0x00}, 0},
+	{"Acer", "AOA110", "v0.3114", 0x55, 0x58, {0x1f, 0x00}, 0},
+	{"Acer", "AOA110", "v0.3301", 0x55, 0x58, {0xaf, 0x00}, 0},
+	{"Acer", "AOA110", "v0.3304", 0x55, 0x58, {0xaf, 0x00}, 0},
+	{"Acer", "AOA110", "v0.3305", 0x55, 0x58, {0xaf, 0x00}, 0},
+	{"Acer", "AOA110", "v0.3307", 0x55, 0x58, {0xaf, 0x00}, 0},
+	{"Acer", "AOA110", "v0.3308", 0x55, 0x58, {0x21, 0x00}, 0},
+	{"Acer", "AOA110", "v0.3309", 0x55, 0x58, {0x21, 0x00}, 0},
+	{"Acer", "AOA110", "v0.3310", 0x55, 0x58, {0x21, 0x00}, 0},
 	/* AOA150 */
-	{"Acer", "AOA150", "v0.3114", 0x55, 0x58, {0x1f, 0x00} },
-	{"Acer", "AOA150", "v0.3301", 0x55, 0x58, {0x20, 0x00} },
-	{"Acer", "AOA150", "v0.3304", 0x55, 0x58, {0x20, 0x00} },
-	{"Acer", "AOA150", "v0.3305", 0x55, 0x58, {0x20, 0x00} },
-	{"Acer", "AOA150", "v0.3307", 0x55, 0x58, {0x20, 0x00} },
-	{"Acer", "AOA150", "v0.3308", 0x55, 0x58, {0x20, 0x00} },
-	{"Acer", "AOA150", "v0.3309", 0x55, 0x58, {0x20, 0x00} },
-	{"Acer", "AOA150", "v0.3310", 0x55, 0x58, {0x20, 0x00} },
+	{"Acer", "AOA150", "v0.3114", 0x55, 0x58, {0x1f, 0x00}, 0},
+	{"Acer", "AOA150", "v0.3301", 0x55, 0x58, {0x20, 0x00}, 0},
+	{"Acer", "AOA150", "v0.3304", 0x55, 0x58, {0x20, 0x00}, 0},
+	{"Acer", "AOA150", "v0.3305", 0x55, 0x58, {0x20, 0x00}, 0},
+	{"Acer", "AOA150", "v0.3307", 0x55, 0x58, {0x20, 0x00}, 0},
+	{"Acer", "AOA150", "v0.3308", 0x55, 0x58, {0x20, 0x00}, 0},
+	{"Acer", "AOA150", "v0.3309", 0x55, 0x58, {0x20, 0x00}, 0},
+	{"Acer", "AOA150", "v0.3310", 0x55, 0x58, {0x20, 0x00}, 0},
 	/* LT1005u */
-	{"Acer", "LT-10Q", "v0.3310", 0x55, 0x58, {0x20, 0x00} },
+	{"Acer", "LT-10Q", "v0.3310", 0x55, 0x58, {0x20, 0x00}, 0},
 	/* Acer 1410 */
-	{"Acer", "Aspire 1410", "v0.3108", 0x55, 0x58, {0x9e, 0x00} },
-	{"Acer", "Aspire 1410", "v0.3113", 0x55, 0x58, {0x9e, 0x00} },
-	{"Acer", "Aspire 1410", "v0.3115", 0x55, 0x58, {0x9e, 0x00} },
-	{"Acer", "Aspire 1410", "v0.3117", 0x55, 0x58, {0x9e, 0x00} },
-	{"Acer", "Aspire 1410", "v0.3119", 0x55, 0x58, {0x9e, 0x00} },
-	{"Acer", "Aspire 1410", "v0.3120", 0x55, 0x58, {0x9e, 0x00} },
-	{"Acer", "Aspire 1410", "v1.3204", 0x55, 0x58, {0x9e, 0x00} },
-	{"Acer", "Aspire 1410", "v1.3303", 0x55, 0x58, {0x9e, 0x00} },
-	{"Acer", "Aspire 1410", "v1.3308", 0x55, 0x58, {0x9e, 0x00} },
-	{"Acer", "Aspire 1410", "v1.3310", 0x55, 0x58, {0x9e, 0x00} },
-	{"Acer", "Aspire 1410", "v1.3314", 0x55, 0x58, {0x9e, 0x00} },
+	{"Acer", "Aspire 1410", "v0.3108", 0x55, 0x58, {0x9e, 0x00}, 0},
+	{"Acer", "Aspire 1410", "v0.3113", 0x55, 0x58, {0x9e, 0x00}, 0},
+	{"Acer", "Aspire 1410", "v0.3115", 0x55, 0x58, {0x9e, 0x00}, 0},
+	{"Acer", "Aspire 1410", "v0.3117", 0x55, 0x58, {0x9e, 0x00}, 0},
+	{"Acer", "Aspire 1410", "v0.3119", 0x55, 0x58, {0x9e, 0x00}, 0},
+	{"Acer", "Aspire 1410", "v0.3120", 0x55, 0x58, {0x9e, 0x00}, 0},
+	{"Acer", "Aspire 1410", "v1.3204", 0x55, 0x58, {0x9e, 0x00}, 0},
+	{"Acer", "Aspire 1410", "v1.3303", 0x55, 0x58, {0x9e, 0x00}, 0},
+	{"Acer", "Aspire 1410", "v1.3308", 0x55, 0x58, {0x9e, 0x00}, 0},
+	{"Acer", "Aspire 1410", "v1.3310", 0x55, 0x58, {0x9e, 0x00}, 0},
+	{"Acer", "Aspire 1410", "v1.3314", 0x55, 0x58, {0x9e, 0x00}, 0},
 	/* Acer 1810xx */
-	{"Acer", "Aspire 1810TZ", "v0.3108", 0x55, 0x58, {0x9e, 0x00} },
-	{"Acer", "Aspire 1810T",  "v0.3108", 0x55, 0x58, {0x9e, 0x00} },
-	{"Acer", "Aspire 1810TZ", "v0.3113", 0x55, 0x58, {0x9e, 0x00} },
-	{"Acer", "Aspire 1810T",  "v0.3113", 0x55, 0x58, {0x9e, 0x00} },
-	{"Acer", "Aspire 1810TZ", "v0.3115", 0x55, 0x58, {0x9e, 0x00} },
-	{"Acer", "Aspire 1810T",  "v0.3115", 0x55, 0x58, {0x9e, 0x00} },
-	{"Acer", "Aspire 1810TZ", "v0.3117", 0x55, 0x58, {0x9e, 0x00} },
-	{"Acer", "Aspire 1810T",  "v0.3117", 0x55, 0x58, {0x9e, 0x00} },
-	{"Acer", "Aspire 1810TZ", "v0.3119", 0x55, 0x58, {0x9e, 0x00} },
-	{"Acer", "Aspire 1810T",  "v0.3119", 0x55, 0x58, {0x9e, 0x00} },
-	{"Acer", "Aspire 1810TZ", "v0.3120", 0x55, 0x58, {0x9e, 0x00} },
-	{"Acer", "Aspire 1810T",  "v0.3120", 0x55, 0x58, {0x9e, 0x00} },
-	{"Acer", "Aspire 1810TZ", "v1.3204", 0x55, 0x58, {0x9e, 0x00} },
-	{"Acer", "Aspire 1810T",  "v1.3204", 0x55, 0x58, {0x9e, 0x00} },
-	{"Acer", "Aspire 1810TZ", "v1.3303", 0x55, 0x58, {0x9e, 0x00} },
-	{"Acer", "Aspire 1810T",  "v1.3303", 0x55, 0x58, {0x9e, 0x00} },
-	{"Acer", "Aspire 1810TZ", "v1.3308", 0x55, 0x58, {0x9e, 0x00} },
-	{"Acer", "Aspire 1810T",  "v1.3308", 0x55, 0x58, {0x9e, 0x00} },
-	{"Acer", "Aspire 1810TZ", "v1.3310", 0x55, 0x58, {0x9e, 0x00} },
-	{"Acer", "Aspire 1810T",  "v1.3310", 0x55, 0x58, {0x9e, 0x00} },
-	{"Acer", "Aspire 1810TZ", "v1.3314", 0x55, 0x58, {0x9e, 0x00} },
-	{"Acer", "Aspire 1810T",  "v1.3314", 0x55, 0x58, {0x9e, 0x00} },
+	{"Acer", "Aspire 1810TZ", "v0.3108", 0x55, 0x58, {0x9e, 0x00}, 0},
+	{"Acer", "Aspire 1810T",  "v0.3108", 0x55, 0x58, {0x9e, 0x00}, 0},
+	{"Acer", "Aspire 1810TZ", "v0.3113", 0x55, 0x58, {0x9e, 0x00}, 0},
+	{"Acer", "Aspire 1810T",  "v0.3113", 0x55, 0x58, {0x9e, 0x00}, 0},
+	{"Acer", "Aspire 1810TZ", "v0.3115", 0x55, 0x58, {0x9e, 0x00}, 0},
+	{"Acer", "Aspire 1810T",  "v0.3115", 0x55, 0x58, {0x9e, 0x00}, 0},
+	{"Acer", "Aspire 1810TZ", "v0.3117", 0x55, 0x58, {0x9e, 0x00}, 0},
+	{"Acer", "Aspire 1810T",  "v0.3117", 0x55, 0x58, {0x9e, 0x00}, 0},
+	{"Acer", "Aspire 1810TZ", "v0.3119", 0x55, 0x58, {0x9e, 0x00}, 0},
+	{"Acer", "Aspire 1810T",  "v0.3119", 0x55, 0x58, {0x9e, 0x00}, 0},
+	{"Acer", "Aspire 1810TZ", "v0.3120", 0x55, 0x58, {0x9e, 0x00}, 0},
+	{"Acer", "Aspire 1810T",  "v0.3120", 0x55, 0x58, {0x9e, 0x00}, 0},
+	{"Acer", "Aspire 1810TZ", "v1.3204", 0x55, 0x58, {0x9e, 0x00}, 0},
+	{"Acer", "Aspire 1810T",  "v1.3204", 0x55, 0x58, {0x9e, 0x00}, 0},
+	{"Acer", "Aspire 1810TZ", "v1.3303", 0x55, 0x58, {0x9e, 0x00}, 0},
+	{"Acer", "Aspire 1810T",  "v1.3303", 0x55, 0x58, {0x9e, 0x00}, 0},
+	{"Acer", "Aspire 1810TZ", "v1.3308", 0x55, 0x58, {0x9e, 0x00}, 0},
+	{"Acer", "Aspire 1810T",  "v1.3308", 0x55, 0x58, {0x9e, 0x00}, 0},
+	{"Acer", "Aspire 1810TZ", "v1.3310", 0x55, 0x58, {0x9e, 0x00}, 0},
+	{"Acer", "Aspire 1810T",  "v1.3310", 0x55, 0x58, {0x9e, 0x00}, 0},
+	{"Acer", "Aspire 1810TZ", "v1.3314", 0x55, 0x58, {0x9e, 0x00}, 0},
+	{"Acer", "Aspire 1810T",  "v1.3314", 0x55, 0x58, {0x9e, 0x00}, 0},
 	/* Acer 531 */
-	{"Acer", "AO531h", "v0.3104", 0x55, 0x58, {0x20, 0x00} },
-	{"Acer", "AO531h", "v0.3201", 0x55, 0x58, {0x20, 0x00} },
-	{"Acer", "AO531h", "v0.3304", 0x55, 0x58, {0x20, 0x00} },
+	{"Acer", "AO531h", "v0.3104", 0x55, 0x58, {0x20, 0x00}, 0},
+	{"Acer", "AO531h", "v0.3201", 0x55, 0x58, {0x20, 0x00}, 0},
+	{"Acer", "AO531h", "v0.3304", 0x55, 0x58, {0x20, 0x00}, 0},
 	/* Acer 751 */
-	{"Acer", "AO751h", "V0.3212", 0x55, 0x58, {0x21, 0x00} },
+	{"Acer", "AO751h", "V0.3212", 0x55, 0x58, {0x21, 0x00}, 0},
 	/* Acer 1825 */
-	{"Acer", "Aspire 1825PTZ", "V1.3118", 0x55, 0x58, {0x9e, 0x00} },
-	{"Acer", "Aspire 1825PTZ", "V1.3127", 0x55, 0x58, {0x9e, 0x00} },
+	{"Acer", "Aspire 1825PTZ", "V1.3118", 0x55, 0x58, {0x9e, 0x00}, 0},
+	{"Acer", "Aspire 1825PTZ", "V1.3127", 0x55, 0x58, {0x9e, 0x00}, 0},
 	/* Acer TravelMate 7730 */
-	{"Acer", "TravelMate 7730G", "v0.3509", 0x55, 0x58, {0xaf, 0x00} },
+	{"Acer", "TravelMate 7730G", "v0.3509", 0x55, 0x58, {0xaf, 0x00}, 0},
 	/* Gateway */
-	{"Gateway", "AOA110", "v0.3103",  0x55, 0x58, {0x21, 0x00} },
-	{"Gateway", "AOA150", "v0.3103",  0x55, 0x58, {0x20, 0x00} },
-	{"Gateway", "LT31",   "v1.3103",  0x55, 0x58, {0x9e, 0x00} },
-	{"Gateway", "LT31",   "v1.3201",  0x55, 0x58, {0x9e, 0x00} },
-	{"Gateway", "LT31",   "v1.3302",  0x55, 0x58, {0x9e, 0x00} },
-	{"Gateway", "LT31",   "v1.3303t", 0x55, 0x58, {0x9e, 0x00} },
+	{"Gateway", "AOA110", "v0.3103",  0x55, 0x58, {0x21, 0x00}, 0},
+	{"Gateway", "AOA150", "v0.3103",  0x55, 0x58, {0x20, 0x00}, 0},
+	{"Gateway", "LT31",   "v1.3103",  0x55, 0x58, {0x9e, 0x00}, 0},
+	{"Gateway", "LT31",   "v1.3201",  0x55, 0x58, {0x9e, 0x00}, 0},
+	{"Gateway", "LT31",   "v1.3302",  0x55, 0x58, {0x9e, 0x00}, 0},
+	{"Gateway", "LT31",   "v1.3303t", 0x55, 0x58, {0x9e, 0x00}, 0},
 	/* Packard Bell */
-	{"Packard Bell", "DOA150",  "v0.3104",  0x55, 0x58, {0x21, 0x00} },
-	{"Packard Bell", "DOA150",  "v0.3105",  0x55, 0x58, {0x20, 0x00} },
-	{"Packard Bell", "AOA110",  "v0.3105",  0x55, 0x58, {0x21, 0x00} },
-	{"Packard Bell", "AOA150",  "v0.3105",  0x55, 0x58, {0x20, 0x00} },
-	{"Packard Bell", "ENBFT",   "V1.3118",  0x55, 0x58, {0x9e, 0x00} },
-	{"Packard Bell", "ENBFT",   "V1.3127",  0x55, 0x58, {0x9e, 0x00} },
-	{"Packard Bell", "DOTMU",   "v1.3303",  0x55, 0x58, {0x9e, 0x00} },
-	{"Packard Bell", "DOTMU",   "v0.3120",  0x55, 0x58, {0x9e, 0x00} },
-	{"Packard Bell", "DOTMU",   "v0.3108",  0x55, 0x58, {0x9e, 0x00} },
-	{"Packard Bell", "DOTMU",   "v0.3113",  0x55, 0x58, {0x9e, 0x00} },
-	{"Packard Bell", "DOTMU",   "v0.3115",  0x55, 0x58, {0x9e, 0x00} },
-	{"Packard Bell", "DOTMU",   "v0.3117",  0x55, 0x58, {0x9e, 0x00} },
-	{"Packard Bell", "DOTMU",   "v0.3119",  0x55, 0x58, {0x9e, 0x00} },
-	{"Packard Bell", "DOTMU",   "v1.3204",  0x55, 0x58, {0x9e, 0x00} },
-	{"Packard Bell", "DOTMA",   "v1.3201",  0x55, 0x58, {0x9e, 0x00} },
-	{"Packard Bell", "DOTMA",   "v1.3302",  0x55, 0x58, {0x9e, 0x00} },
-	{"Packard Bell", "DOTMA",   "v1.3303t", 0x55, 0x58, {0x9e, 0x00} },
-	{"Packard Bell", "DOTVR46", "v1.3308",  0x55, 0x58, {0x9e, 0x00} },
+	{"Packard Bell", "DOA150",  "v0.3104",  0x55, 0x58, {0x21, 0x00}, 0},
+	{"Packard Bell", "DOA150",  "v0.3105",  0x55, 0x58, {0x20, 0x00}, 0},
+	{"Packard Bell", "AOA110",  "v0.3105",  0x55, 0x58, {0x21, 0x00}, 0},
+	{"Packard Bell", "AOA150",  "v0.3105",  0x55, 0x58, {0x20, 0x00}, 0},
+	{"Packard Bell", "ENBFT",   "V1.3118",  0x55, 0x58, {0x9e, 0x00}, 0},
+	{"Packard Bell", "ENBFT",   "V1.3127",  0x55, 0x58, {0x9e, 0x00}, 0},
+	{"Packard Bell", "DOTMU",   "v1.3303",  0x55, 0x58, {0x9e, 0x00}, 0},
+	{"Packard Bell", "DOTMU",   "v0.3120",  0x55, 0x58, {0x9e, 0x00}, 0},
+	{"Packard Bell", "DOTMU",   "v0.3108",  0x55, 0x58, {0x9e, 0x00}, 0},
+	{"Packard Bell", "DOTMU",   "v0.3113",  0x55, 0x58, {0x9e, 0x00}, 0},
+	{"Packard Bell", "DOTMU",   "v0.3115",  0x55, 0x58, {0x9e, 0x00}, 0},
+	{"Packard Bell", "DOTMU",   "v0.3117",  0x55, 0x58, {0x9e, 0x00}, 0},
+	{"Packard Bell", "DOTMU",   "v0.3119",  0x55, 0x58, {0x9e, 0x00}, 0},
+	{"Packard Bell", "DOTMU",   "v1.3204",  0x55, 0x58, {0x9e, 0x00}, 0},
+	{"Packard Bell", "DOTMA",   "v1.3201",  0x55, 0x58, {0x9e, 0x00}, 0},
+	{"Packard Bell", "DOTMA",   "v1.3302",  0x55, 0x58, {0x9e, 0x00}, 0},
+	{"Packard Bell", "DOTMA",   "v1.3303t", 0x55, 0x58, {0x9e, 0x00}, 0},
+	{"Packard Bell", "DOTVR46", "v1.3308",  0x55, 0x58, {0x9e, 0x00}, 0},
 	/* pewpew-terminator */
-	{"", "", "", 0, 0, {0, 0} }
+	{"", "", "", 0, 0, {0, 0}, 0}
 };
 
 static const struct bios_settings_t *bios_cfg __read_mostly;
@@ -275,6 +288,12 @@ static void acerhdf_change_fanstate(int state)
 	fanstate = state;
 
 	ec_write(bios_cfg->fanreg, cmd);
+
+	if (bios_cfg->mcmd_enable && state == ACERHDF_FAN_OFF) {
+		if (verbose)
+			pr_notice("turning off fan manually\n");
+		ec_write(mcmd.mreg, mcmd.moff);
+	}
 }
 
 static void acerhdf_check_param(struct thermal_zone_device *thermal)
-- 
1.9.2

