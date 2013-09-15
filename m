Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754084Ab3IOUtT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Sep 2013 16:49:19 -0400
Received: from ring0.de ([91.143.88.219]:38790 "EHLO smtp.ring0.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752787Ab3IOUtQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Sep 2013 16:49:16 -0400
X-Spam-Report: * -1.9 BAYES_00 BODY: Spamwahrscheinlichkeit nach Bayes-Test: 0-1%
	*      [score: 0.0000]
From: Sebastian Reichel <sre@debian.org>
To: Sebastian Reichel <sre@ring0.de>, Linus Walleij <linus.walleij@linaro.org>,
        Shubhrajyoti Datta <omaplinuxkernel@gmail.com>,
        Carlos Chinea <cch.devel@gmail.com>, Paul Walmsley <paul@pwsan.com>
Cc: Kevin Hilman <khilman@deeprootsystems.com>,
        Tony Lindgren <tony@atomide.com>,
        Russell King <linux@arm.linux.org.uk>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <rob.herring@calxeda.com>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Rob Landley <rob@landley.net>,
        =?UTF-8?q?=27Beno=C3=AEt=20Cousson=27?= <bcousson@baylibre.com>,
        devicetree@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-omap@vger.kernel.org, Sebastian Reichel <sre@debian.org>
Subject: [RFCv2 1/3] ARM: OMAP2+: hwmod-data: Add SSI information
Date: Sun, 15 Sep 2013 22:44:14 +0200
Message-Id: <1379277856-24571-2-git-send-email-sre@debian.org>
X-Mailer: git-send-email 1.8.4.rc3
In-Reply-To: <1379277856-24571-1-git-send-email-sre@debian.org>
References: <1379277856-24571-1-git-send-email-sre@debian.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds Synchronous Serial Interface (SSI) hwmod support for
OMAP34xx SoCs.

Signed-off-by: Sebastian Reichel <sre@debian.org>
---
 arch/arm/mach-omap2/omap_hwmod_3xxx_data.c | 48 ++++++++++++++++++++++++++++++
 1 file changed, 48 insertions(+)

diff --git a/arch/arm/mach-omap2/omap_hwmod_3xxx_data.c b/arch/arm/mach-omap2/omap_hwmod_3xxx_data.c
index 0c3a427..9e56fab 100644
--- a/arch/arm/mach-omap2/omap_hwmod_3xxx_data.c
+++ b/arch/arm/mach-omap2/omap_hwmod_3xxx_data.c
@@ -3693,6 +3693,53 @@ static struct omap_hwmod_ocp_if omap3xxx_l4_core__aes = {
 	.user		= OCP_USER_MPU | OCP_USER_SDMA,
 };
 
+/*
+ * 'ssi' class
+ * synchronous serial interface (multichannel and full-duplex serial if)
+ */
+
+static struct omap_hwmod_class_sysconfig omap34xx_ssi_sysc = {
+	.rev_offs	= 0x0000,
+	.sysc_offs	= 0x0010,
+	.syss_offs	= 0x0014,
+	.sysc_flags	= (SYSC_HAS_AUTOIDLE | SYSC_HAS_EMUFREE |
+			   SYSC_HAS_MIDLEMODE | SYSC_HAS_SIDLEMODE |
+			   SYSC_HAS_SOFTRESET | SYSS_HAS_RESET_STATUS),
+	.idlemodes	= (SIDLE_FORCE | SIDLE_NO | SIDLE_SMART |
+			   SIDLE_SMART_WKUP | MSTANDBY_FORCE | MSTANDBY_NO |
+			   MSTANDBY_SMART | MSTANDBY_SMART_WKUP),
+	.sysc_fields	= &omap_hwmod_sysc_type1,
+};
+
+static struct omap_hwmod_class omap34xx_ssi_hwmod_class = {
+	.name	= "ssi",
+	.sysc	= &omap34xx_ssi_sysc,
+};
+
+static struct omap_hwmod omap34xx_ssi_hwmod = {
+	.name		= "ssi",
+	.class		= &omap34xx_ssi_hwmod_class,
+	.clkdm_name	= "core_l4_clkdm",
+	.main_clk	= "ssi_ssr_fck",
+	.prcm		= {
+		.omap2 = {
+			.prcm_reg_id		= 1,
+			.module_bit		= OMAP3430_EN_SSI_SHIFT,
+			.module_offs		= CORE_MOD,
+			.idlest_reg_id		= 1,
+			.idlest_idle_bit	= OMAP3430ES2_ST_SSI_IDLE_SHIFT,
+		},
+	},
+};
+
+/* L4 CORE -> SSI */
+static struct omap_hwmod_ocp_if omap34xx_l4_core__ssi = {
+	.master		= &omap3xxx_l4_core_hwmod,
+	.slave		= &omap34xx_ssi_hwmod,
+	.clk		= "ssi_ick",
+	.user		= OCP_USER_MPU | OCP_USER_SDMA,
+};
+
 static struct omap_hwmod_ocp_if *omap3xxx_hwmod_ocp_ifs[] __initdata = {
 	&omap3xxx_l3_main__l4_core,
 	&omap3xxx_l3_main__l4_per,
@@ -3818,6 +3865,7 @@ static struct omap_hwmod_ocp_if *omap34xx_hwmod_ocp_ifs[] __initdata = {
 #ifdef CONFIG_OMAP_IOMMU_IVA2
 	&omap3xxx_l3_main__mmu_iva,
 #endif
+	&omap34xx_l4_core__ssi,
 	NULL
 };
 
-- 
1.8.4.rc3

