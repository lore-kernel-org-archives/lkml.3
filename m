Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754509AbbAZKFT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jan 2015 05:05:19 -0500
Received: from nasmtp01.atmel.com ([192.199.1.245]:26447 "EHLO
	DVREDG01.corp.atmel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754304AbbAZKFO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jan 2015 05:05:14 -0500
From: Wenyou Yang <wenyou.yang@atmel.com>
To: <nicolas.ferre@atmel.com>, <linux@arm.linux.org.uk>
CC: <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        <alexandre.belloni@free-electrons.com>, <sylvain.rochet@finsecur.com>,
        <peda@axentia.se>, <wenyou.yang@atmel.com>
Subject: [PATCH 1/7] pm: at91: achieve the memory controller's type from the dts file.
Date: Mon, 26 Jan 2015 18:04:24 +0800
Message-ID: <1422266664-24416-1-git-send-email-wenyou.yang@atmel.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1422266617-24381-1-git-send-email-wenyou.yang@atmel.com>
References: <1422266617-24381-1-git-send-email-wenyou.yang@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Instead of achieve the ram controller's tpye through the SoC,
through the sram controller configuration, it is more sensible.

Signed-off-by: Wenyou Yang <wenyou.yang@atmel.com>
---
 arch/arm/mach-at91/generic.h |    5 +++++
 arch/arm/mach-at91/pm.c      |    9 +--------
 arch/arm/mach-at91/setup.c   |   28 ++++++++++++++++++++++++----
 3 files changed, 30 insertions(+), 12 deletions(-)

diff --git a/arch/arm/mach-at91/generic.h b/arch/arm/mach-at91/generic.h
index a8ee83e..41796bf 100644
--- a/arch/arm/mach-at91/generic.h
+++ b/arch/arm/mach-at91/generic.h
@@ -44,4 +44,9 @@ void __init at91_sam9g45_pm_init(void) { }
 void __init at91_sam9x5_pm_init(void) { }
 #endif
 
+struct at91_pm_struct {
+	unsigned long uhp_udp_mask;
+	int memctrl;
+};
+
 #endif /* _AT91_GENERIC_H */
diff --git a/arch/arm/mach-at91/pm.c b/arch/arm/mach-at91/pm.c
index 7473978..f75dc32 100644
--- a/arch/arm/mach-at91/pm.c
+++ b/arch/arm/mach-at91/pm.c
@@ -35,10 +35,7 @@
 #include "generic.h"
 #include "pm.h"
 
-static struct {
-	unsigned long uhp_udp_mask;
-	int memctrl;
-} at91_pm_data;
+struct at91_pm_struct at91_pm_data;
 
 static int at91_pm_valid_state(suspend_state_t state)
 {
@@ -287,14 +284,12 @@ void __init at91_rm9200_pm_init(void)
 	at91_ramc_write(0, AT91RM9200_SDRAMC_LPR, 0);
 
 	at91_pm_data.uhp_udp_mask = AT91RM9200_PMC_UHP | AT91RM9200_PMC_UDP;
-	at91_pm_data.memctrl = AT91_MEMCTRL_MC;
 
 	at91_pm_init();
 }
 
 void __init at91_sam9260_pm_init(void)
 {
-	at91_pm_data.memctrl = AT91_MEMCTRL_SDRAMC;
 	at91_pm_data.uhp_udp_mask = AT91SAM926x_PMC_UHP | AT91SAM926x_PMC_UDP;
 	return at91_pm_init();
 }
@@ -302,13 +297,11 @@ void __init at91_sam9260_pm_init(void)
 void __init at91_sam9g45_pm_init(void)
 {
 	at91_pm_data.uhp_udp_mask = AT91SAM926x_PMC_UHP;
-	at91_pm_data.memctrl = AT91_MEMCTRL_DDRSDR;
 	return at91_pm_init();
 }
 
 void __init at91_sam9x5_pm_init(void)
 {
 	at91_pm_data.uhp_udp_mask = AT91SAM926x_PMC_UHP | AT91SAM926x_PMC_UDP;
-	at91_pm_data.memctrl = AT91_MEMCTRL_DDRSDR;
 	return at91_pm_init();
 }
diff --git a/arch/arm/mach-at91/setup.c b/arch/arm/mach-at91/setup.c
index b8dba9f..7924663 100644
--- a/arch/arm/mach-at91/setup.c
+++ b/arch/arm/mach-at91/setup.c
@@ -26,6 +26,8 @@
 #include "generic.h"
 #include "pm.h"
 
+extern struct at91_pm_struct	at91_pm_data;
+
 struct at91_init_soc __initdata at91_boot_soc;
 
 struct at91_socinfo at91_soc_initdata;
@@ -361,11 +363,25 @@ void __init at91_ioremap_matrix(u32 base_addr)
 		panic(pr_fmt("Impossible to ioremap at91_matrix_base\n"));
 }
 
+struct at91_ramc_of_data {
+	u8 ramc_type;
+};
+
+static const struct at91_ramc_of_data at91rm9200_ramc_of_data = {
+	.ramc_type = AT91_MEMCTRL_MC,
+};
+static const struct at91_ramc_of_data at91sam9260_ramc_of_data = {
+	.ramc_type = AT91_MEMCTRL_SDRAMC,
+};
+static const struct at91_ramc_of_data at91sam9g45_ramc_of_data = {
+	.ramc_type = AT91_MEMCTRL_DDRSDR,
+};
+
 static struct of_device_id ramc_ids[] = {
-	{ .compatible = "atmel,at91rm9200-sdramc" },
-	{ .compatible = "atmel,at91sam9260-sdramc" },
-	{ .compatible = "atmel,at91sam9g45-ddramc" },
-	{ .compatible = "atmel,sama5d3-ddramc" },
+	{ .compatible = "atmel,at91rm9200-sdramc", .data = &at91rm9200_ramc_of_data },
+	{ .compatible = "atmel,at91sam9260-sdramc", .data = &at91sam9260_ramc_of_data },
+	{ .compatible = "atmel,at91sam9g45-ddramc", .data = &at91sam9g45_ramc_of_data },
+	{ .compatible = "atmel,sama5d3-ddramc", .data = &at91sam9g45_ramc_of_data },
 	{ /*sentinel*/ }
 };
 
@@ -374,12 +390,16 @@ static void at91_dt_ramc(void)
 	struct device_node *np;
 	const struct of_device_id *of_id;
 	int idx = 0;
+	const struct at91_ramc_of_data *of_data;
 
 	for_each_matching_node_and_match(np, ramc_ids, &of_id) {
 		at91_ramc_base[idx] = of_iomap(np, 0);
 		if (!at91_ramc_base[idx])
 			panic(pr_fmt("unable to map ramc[%d] cpu registers\n"), idx);
 
+		of_data = of_id->data;
+		at91_pm_data.memctrl = of_data->ramc_type;
+
 		idx++;
 	}
 
-- 
1.7.9.5

