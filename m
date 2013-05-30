Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758007Ab3E3PFD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 May 2013 11:05:03 -0400
Received: from mail.skitlab.ru ([217.65.220.135]:41298 "EHLO mail.skitlab.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756361Ab3E3PEz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 May 2013 11:04:55 -0400
From: Aida Mynzhasova <aida.mynzhasova@skitlab.ru>
To: linux-omap@vger.kernel.org
Cc: tony@atomide.com, linux@arm.linux.org.uk,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH] ARM: OMAP: TI816X: add powerdomains for TI816x
Date: Thu, 30 May 2013 19:04:50 +0400
Message-Id: <1369926290-30404-1-git-send-email-aida.mynzhasova@skitlab.ru>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds required structures for powerdomain initialization on
the ti816x. It is impossible to use omap3430 structures in order to
initialize powerdomains on ti816x, because there are big differences
between PRCM module base address offsets on these CPUs.

Signed-off-by: Aida Mynzhasova <aida.mynzhasova@skitlab.ru>
---
 arch/arm/mach-omap2/powerdomains3xxx_data.c |   62 +++++++++++++++++++++++++++
 arch/arm/mach-omap2/prcm-common.h           |   11 +++++
 2 files changed, 73 insertions(+)

diff --git a/arch/arm/mach-omap2/powerdomains3xxx_data.c b/arch/arm/mach-omap2/powerdomains3xxx_data.c
index f0e14e9..e2d4bd8 100644
--- a/arch/arm/mach-omap2/powerdomains3xxx_data.c
+++ b/arch/arm/mach-omap2/powerdomains3xxx_data.c
@@ -336,6 +336,54 @@ static struct powerdomain dpll5_pwrdm = {
 	.voltdm		  = { .name = "core" },
 };
 
+static struct powerdomain device_81xx_pwrdm = {
+	.name		  = "device_pwrdm",
+	.prcm_offs	  = TI81XX_PRM_DEVICE_MOD,
+	.voltdm		  = { .name = "core" },
+};
+
+static struct powerdomain active_816x_pwrdm = {
+	.name		  = "active_pwrdm",
+	.prcm_offs	  = TI816X_PRM_ACTIVE_MOD,
+	.pwrsts		  = PWRSTS_OFF_ON,
+	.voltdm		  = { .name = "core" },
+};
+
+static struct powerdomain default_816x_pwrdm = {
+	.name		  = "default_pwrdm",
+	.prcm_offs	  = TI81XX_PRM_DEFAULT_MOD,
+	.pwrsts		  = PWRSTS_OFF_ON,
+	.voltdm		  = { .name = "core" },
+};
+
+static struct powerdomain ivahd0_816x_pwrdm = {
+	.name		  = "ivahd0_pwrdm",
+	.prcm_offs	  = TI816X_PRM_IVAHD0_MOD,
+	.pwrsts		  = PWRSTS_OFF_ON,
+	.voltdm		  = { .name = "mpu_iva" },
+};
+
+static struct powerdomain ivahd1_816x_pwrdm = {
+	.name		  = "ivahd1_pwrdm",
+	.prcm_offs	  = TI816X_PRM_IVAHD1_MOD,
+	.pwrsts		  = PWRSTS_OFF_ON,
+	.voltdm		  = { .name = "mpu_iva" },
+};
+
+static struct powerdomain ivahd2_816x_pwrdm = {
+	.name		  = "ivahd2_pwrdm",
+	.prcm_offs	  = TI816X_PRM_IVAHD2_MOD,
+	.pwrsts		  = PWRSTS_OFF_ON,
+	.voltdm		  = { .name = "mpu_iva" },
+};
+
+static struct powerdomain sgx_816x_pwrdm = {
+	.name		  = "sgx_pwrdm",
+	.prcm_offs	  = TI816X_PRM_SGX_MOD,
+	.pwrsts		  = PWRSTS_OFF_ON,
+	.voltdm		  = { .name = "core" },
+};
+
 /* As powerdomains are added or removed above, this list must also be changed */
 static struct powerdomain *powerdomains_omap3430_common[] __initdata = {
 	&wkup_omap2_pwrdm,
@@ -393,6 +441,17 @@ static struct powerdomain *powerdomains_am35x[] __initdata = {
 	NULL
 };
 
+static struct powerdomain *powerdomains_ti81xx[] __initdata = {
+	&device_81xx_pwrdm,
+	&active_816x_pwrdm,
+	&default_816x_pwrdm,
+	&ivahd0_816x_pwrdm,
+	&ivahd1_816x_pwrdm,
+	&ivahd2_816x_pwrdm,
+	&sgx_816x_pwrdm,
+	NULL
+};
+
 void __init omap3xxx_powerdomains_init(void)
 {
 	unsigned int rev;
@@ -406,6 +465,9 @@ void __init omap3xxx_powerdomains_init(void)
 
 	if (rev == AM35XX_REV_ES1_0 || rev == AM35XX_REV_ES1_1) {
 		pwrdm_register_pwrdms(powerdomains_am35x);
+	} else if (rev == TI8168_REV_ES1_0 || rev == TI8168_REV_ES1_1
+			|| rev == TI8168_REV_ES2_0 || rev == TI8168_REV_ES2_1) {
+		pwrdm_register_pwrdms(powerdomains_ti81xx);
 	} else {
 		pwrdm_register_pwrdms(powerdomains_omap3430_common);
 
diff --git a/arch/arm/mach-omap2/prcm-common.h b/arch/arm/mach-omap2/prcm-common.h
index c7d355f..ff1ac4a 100644
--- a/arch/arm/mach-omap2/prcm-common.h
+++ b/arch/arm/mach-omap2/prcm-common.h
@@ -48,6 +48,17 @@
 #define OMAP3430_NEON_MOD				0xb00
 #define OMAP3430ES2_USBHOST_MOD				0xc00
 
+/*
+ * TI81XX PRM module offsets
+ */
+#define TI81XX_PRM_DEVICE_MOD			0x0000
+#define TI816X_PRM_ACTIVE_MOD			0x0a00
+#define TI81XX_PRM_DEFAULT_MOD			0x0b00
+#define TI816X_PRM_IVAHD0_MOD			0x0c00
+#define TI816X_PRM_IVAHD1_MOD			0x0d00
+#define TI816X_PRM_IVAHD2_MOD			0x0e00
+#define TI816X_PRM_SGX_MOD				0x0f00
+
 /* 24XX register bits shared between CM & PRM registers */
 
 /* CM_FCLKEN1_CORE, CM_ICLKEN1_CORE, PM_WKEN1_CORE shared bits */
-- 
1.7.10.4

