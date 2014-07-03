Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758440AbaGCOUW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jul 2014 10:20:22 -0400
Received: from top.free-electrons.com ([176.31.233.9]:50937 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1758361AbaGCOUT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jul 2014 10:20:19 -0400
From: Maxime Ripard <maxime.ripard@free-electrons.com>
To: linux@maxim.org.za, Nicolas Ferre <nicolas.ferre@atmel.com>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        dwmw2@infradead.org, dbaryshkov@gmail.com
Cc: Boris Brezillon <boris@free-electrons.com>,
        Alexandre Belloni <alexandre.belloni@free-electrons.com>,
        Thomas Petazzoni <thomas@free-electrons.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org,
        Maxime Ripard <maxime.ripard@free-electrons.com>
Subject: [PATCH 12/18] AT91: DT: Remove poweroff DT probing
Date: Thu,  3 Jul 2014 16:14:53 +0200
Message-Id: <1404396906-25194-21-git-send-email-maxime.ripard@free-electrons.com>
X-Mailer: git-send-email 2.0.1
In-Reply-To: <1404396906-25194-1-git-send-email-maxime.ripard@free-electrons.com>
References: <1404396906-25194-1-git-send-email-maxime.ripard@free-electrons.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now that the poweroff code is a driver of its own, remove the DT probing in
mach-at91 and let the usual DT code do its job.

Signed-off-by: Maxime Ripard <maxime.ripard@free-electrons.com>
---
 arch/arm/mach-at91/setup.c | 77 ----------------------------------------------
 1 file changed, 77 deletions(-)

diff --git a/arch/arm/mach-at91/setup.c b/arch/arm/mach-at91/setup.c
index 771e0495bfe5..69967c21d5c0 100644
--- a/arch/arm/mach-at91/setup.c
+++ b/arch/arm/mach-at91/setup.c
@@ -385,82 +385,6 @@ static void at91_dt_ramc(void)
 	of_node_put(np);
 }
 
-static struct of_device_id shdwc_ids[] = {
-	{ .compatible = "atmel,at91sam9260-shdwc", },
-	{ .compatible = "atmel,at91sam9rl-shdwc", },
-	{ .compatible = "atmel,at91sam9x5-shdwc", },
-	{ /*sentinel*/ }
-};
-
-static const char *shdwc_wakeup_modes[] = {
-	[AT91_SHDW_WKMODE0_NONE]	= "none",
-	[AT91_SHDW_WKMODE0_HIGH]	= "high",
-	[AT91_SHDW_WKMODE0_LOW]		= "low",
-	[AT91_SHDW_WKMODE0_ANYLEVEL]	= "any",
-};
-
-const int at91_dtget_shdwc_wakeup_mode(struct device_node *np)
-{
-	const char *pm;
-	int err, i;
-
-	err = of_property_read_string(np, "atmel,wakeup-mode", &pm);
-	if (err < 0)
-		return AT91_SHDW_WKMODE0_ANYLEVEL;
-
-	for (i = 0; i < ARRAY_SIZE(shdwc_wakeup_modes); i++)
-		if (!strcasecmp(pm, shdwc_wakeup_modes[i]))
-			return i;
-
-	return -ENODEV;
-}
-
-static void at91_dt_shdwc(void)
-{
-	struct device_node *np;
-	int wakeup_mode;
-	u32 reg;
-	u32 mode = 0;
-
-	np = of_find_matching_node(NULL, shdwc_ids);
-	if (!np) {
-		pr_debug("unable to find compatible shutdown (shdwc) controller node in dtb\n");
-		return;
-	}
-
-	at91_shdwc_base = of_iomap(np, 0);
-	if (!at91_shdwc_base)
-		panic(pr_fmt("unable to map shdwc cpu registers\n"));
-
-	wakeup_mode = at91_dtget_shdwc_wakeup_mode(np);
-	if (wakeup_mode < 0) {
-		pr_warn("shdwc unknown wakeup mode\n");
-		goto end;
-	}
-
-	if (!of_property_read_u32(np, "atmel,wakeup-counter", &reg)) {
-		if (reg > AT91_SHDW_CPTWK0_MAX) {
-			pr_warn("shdwc wakeup counter 0x%x > 0x%x reduce it to 0x%x\n",
-				reg, AT91_SHDW_CPTWK0_MAX, AT91_SHDW_CPTWK0_MAX);
-			reg = AT91_SHDW_CPTWK0_MAX;
-		}
-		mode |= AT91_SHDW_CPTWK0_(reg);
-	}
-
-	if (of_property_read_bool(np, "atmel,wakeup-rtc-timer"))
-			mode |= AT91_SHDW_RTCWKEN;
-
-	if (of_property_read_bool(np, "atmel,wakeup-rtt-timer"))
-			mode |= AT91_SHDW_RTTWKEN;
-
-	at91_shdwc_write(AT91_SHDW_MR, wakeup_mode | mode);
-
-end:
-	pm_power_off = at91sam9_poweroff;
-
-	of_node_put(np);
-}
-
 void __init at91rm9200_dt_initialize(void)
 {
 	at91_dt_ramc();
@@ -478,7 +402,6 @@ void __init at91rm9200_dt_initialize(void)
 void __init at91_dt_initialize(void)
 {
 	at91_dt_ramc();
-	at91_dt_shdwc();
 
 	/* Init clock subsystem */
 	at91_dt_clock_init();
-- 
2.0.1

