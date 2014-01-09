Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754701AbaAIMfx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jan 2014 07:35:53 -0500
Received: from mail-wi0-f170.google.com ([209.85.212.170]:54160 "EHLO
	mail-wi0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753165AbaAIMfJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jan 2014 07:35:09 -0500
From: Jean-Jacques Hiblot <jjhiblot@traphandler.com>
To: nicolas.ferre@atmel.com, b.brezillon@overkiz.com, arnd@arndb.de
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Jean-Jacques Hiblot <jjhiblot@traphandler.com>
Subject: [PATCH v2 06/12] at91: smc: Adds helper functions to validate and clip the smc timings.
Date: Thu,  9 Jan 2014 13:31:43 +0100
Message-Id: <1389270709-32662-7-git-send-email-jjhiblot@traphandler.com>
X-Mailer: git-send-email 1.8.5.2
In-Reply-To: <1389270709-32662-1-git-send-email-jjhiblot@traphandler.com>
References: <1389270709-32662-1-git-send-email-jjhiblot@traphandler.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patchs implememnts 2 functions to help with the configuration of a
chip-select's timing:
* sam9_smc_check_cs_configuration : checks that the values would fit in the
  registers.
* sam9_smc_clip_cs_configuration : clip the values to their maximum.

Signed-off-by: Jean-Jacques Hiblot <jjhiblot@traphandler.com>
---
 arch/arm/mach-at91/include/mach/at91sam9_smc.h |  2 +
 arch/arm/mach-at91/sam9_smc.c                  | 77 ++++++++++++++++++++++++++
 2 files changed, 79 insertions(+)

diff --git a/arch/arm/mach-at91/include/mach/at91sam9_smc.h b/arch/arm/mach-at91/include/mach/at91sam9_smc.h
index c3e29311..615ac56 100644
--- a/arch/arm/mach-at91/include/mach/at91sam9_smc.h
+++ b/arch/arm/mach-at91/include/mach/at91sam9_smc.h
@@ -47,6 +47,8 @@ extern void sam9_smc_read_mode(int id, int cs, struct sam9_smc_config *config);
 extern void sam9_smc_write_mode(int id, int cs, struct sam9_smc_config *config);
 extern void sam9_smc_cs_read(void __iomem *, struct sam9_smc_config *config);
 extern void sam9_smc_cs_configure(void __iomem *, struct sam9_smc_config *cfg);
+extern int sam9_smc_check_cs_configuration(struct sam9_smc_config *config);
+extern void sam9_smc_clip_cs_configuration(struct sam9_smc_config *config);
 #endif
 
 #define AT91_SMC_SETUP		0x00				/* Setup Register for CS n */
diff --git a/arch/arm/mach-at91/sam9_smc.c b/arch/arm/mach-at91/sam9_smc.c
index d7a6156..fe3c492 100644
--- a/arch/arm/mach-at91/sam9_smc.c
+++ b/arch/arm/mach-at91/sam9_smc.c
@@ -23,6 +23,83 @@
 
 static void __iomem *smc_base_addr[2];
 
+static int count_trailing_zeroes(u32 x)
+{
+	int ret = 0;
+	if (!(x & 0xFFFF)) {
+		ret += 16;
+		x = x >> 16;
+	}
+	if (!(x & 0xFF)) {
+		ret += 8;
+		x = x >> 8;
+	}
+	if (!(x & 0xF)) {
+		ret += 4;
+		x = x >> 4;
+	}
+	if (!(x & 0x3)) {
+		ret += 2;
+		x = x >> 2;
+	}
+	if (!(x & 0x1)) {
+		ret += 1;
+		x = x >> 1;
+	}
+	if (!(x & 0x1))
+		ret += 1;
+
+	return ret;
+}
+
+
+#define __CHECK_CFG(config, x, y)  do {\
+	if (x##_(config->y) > x) {\
+		pr_debug("error: %s (0x%x) is out of range\n", #y,\
+			config->y >> count_trailing_zeroes(x));\
+		return -EINVAL;\
+		} \
+	} while (0)
+
+int sam9_smc_check_cs_configuration(struct sam9_smc_config *config)
+{
+	__CHECK_CFG(config, AT91_SMC_NWESETUP, nwe_setup);
+	__CHECK_CFG(config, AT91_SMC_NCS_WRSETUP, ncs_write_setup);
+	__CHECK_CFG(config, AT91_SMC_NRDSETUP, nrd_setup);
+	__CHECK_CFG(config, AT91_SMC_NCS_RDSETUP, ncs_read_setup);
+	__CHECK_CFG(config, AT91_SMC_NWEPULSE, nwe_pulse);
+	__CHECK_CFG(config, AT91_SMC_NCS_WRPULSE, ncs_write_pulse);
+	__CHECK_CFG(config, AT91_SMC_NRDPULSE, nrd_pulse);
+	__CHECK_CFG(config, AT91_SMC_NCS_RDPULSE, ncs_read_pulse);
+	__CHECK_CFG(config, AT91_SMC_NWECYCLE, write_cycle);
+	__CHECK_CFG(config, AT91_SMC_NRDCYCLE, read_cycle);
+	__CHECK_CFG(config, AT91_SMC_TDF, tdf_cycles);
+	return 0;
+}
+
+#define __CLIP_CFG(config, x, y)  do {\
+	if (x##_(config->y) > x) {\
+		config->y = x >> count_trailing_zeroes(x);\
+		pr_debug("clipping %s to %d\n", #y, config->y);\
+		} \
+	} while (0)
+
+void sam9_smc_clip_cs_configuration(struct sam9_smc_config *config)
+{
+	__CLIP_CFG(config, AT91_SMC_NWESETUP, nwe_setup);
+	__CLIP_CFG(config, AT91_SMC_NCS_WRSETUP, ncs_write_setup);
+	__CLIP_CFG(config, AT91_SMC_NRDSETUP, nrd_setup);
+	__CLIP_CFG(config, AT91_SMC_NCS_RDSETUP, ncs_read_setup);
+	__CLIP_CFG(config, AT91_SMC_NWEPULSE, nwe_pulse);
+	__CLIP_CFG(config, AT91_SMC_NCS_WRPULSE, ncs_write_pulse);
+	__CLIP_CFG(config, AT91_SMC_NRDPULSE, nrd_pulse);
+	__CLIP_CFG(config, AT91_SMC_NCS_RDPULSE, ncs_read_pulse);
+	__CLIP_CFG(config, AT91_SMC_NWECYCLE, write_cycle);
+	__CLIP_CFG(config, AT91_SMC_NRDCYCLE, read_cycle);
+	__CLIP_CFG(config, AT91_SMC_TDF, tdf_cycles);
+
+}
+
 static void sam9_smc_cs_write_mode(void __iomem *base,
 					struct sam9_smc_config *config)
 {
-- 
1.8.5.2

