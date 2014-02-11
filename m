Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752266AbaBKQ0f (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Feb 2014 11:26:35 -0500
Received: from smtp.codeaurora.org ([198.145.11.231]:46698 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752069AbaBKQ01 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Feb 2014 11:26:27 -0500
From: Josh Cartwright <joshc@codeaurora.org>
To: Andrew Victor <linux@maxim.org.za>,
        Nicolas Ferre <nicolas.ferre@atmel.com>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>
Cc: devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        Russell King <linux@arm.linux.org.uk>,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH 3/8] ARM: at91: make use of of_find_matching_node_and_match
Date: Tue, 11 Feb 2014 10:24:01 -0600
Message-Id: <1392135847-30791-4-git-send-email-joshc@codeaurora.org>
X-Mailer: git-send-email 1.8.5.4
In-Reply-To: <1392135847-30791-1-git-send-email-joshc@codeaurora.org>
References: <1392135847-30791-1-git-send-email-joshc@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Instead of the of_find_matching_node()/of_match_node() pair, which requires two
iterations through the match table, make use of of_find_matching_node_and_match(),
which only iterates through the table once.

While we're here, mark the rtsc id table const.

Signed-off-by: Josh Cartwright <joshc@codeaurora.org>
---
 arch/arm/mach-at91/setup.c | 16 ++++------------
 1 file changed, 4 insertions(+), 12 deletions(-)

diff --git a/arch/arm/mach-at91/setup.c b/arch/arm/mach-at91/setup.c
index f7ca97b..e884de8 100644
--- a/arch/arm/mach-at91/setup.c
+++ b/arch/arm/mach-at91/setup.c
@@ -352,7 +352,7 @@ void __init at91_ioremap_matrix(u32 base_addr)
 }
 
 #if defined(CONFIG_OF)
-static struct of_device_id rstc_ids[] = {
+static const struct of_device_id rstc_ids[] = {
 	{ .compatible = "atmel,at91sam9260-rstc", .data = at91sam9_alt_restart },
 	{ .compatible = "atmel,at91sam9g45-rstc", .data = at91sam9g45_restart },
 	{ /*sentinel*/ }
@@ -363,7 +363,7 @@ static void at91_dt_rstc(void)
 	struct device_node *np;
 	const struct of_device_id *of_id;
 
-	np = of_find_matching_node(NULL, rstc_ids);
+	np = of_find_matching_node_and_match(NULL, rstc_ids, &of_id);
 	if (!np)
 		panic("unable to find compatible rstc node in dtb\n");
 
@@ -371,10 +371,6 @@ static void at91_dt_rstc(void)
 	if (!at91_rstc_base)
 		panic("unable to map rstc cpu registers\n");
 
-	of_id = of_match_node(rstc_ids, np);
-	if (!of_id)
-		panic("AT91: rtsc no restart function available\n");
-
 	arm_pm_restart = of_id->data;
 
 	of_node_put(np);
@@ -392,7 +388,7 @@ static void at91_dt_ramc(void)
 	struct device_node *np;
 	const struct of_device_id *of_id;
 
-	np = of_find_matching_node(NULL, ramc_ids);
+	np = of_find_matching_node_and_match(NULL, ramc_ids, &of_id);
 	if (!np)
 		panic("unable to find compatible ram controller node in dtb\n");
 
@@ -402,11 +398,7 @@ static void at91_dt_ramc(void)
 	/* the controller may have 2 banks */
 	at91_ramc_base[1] = of_iomap(np, 1);
 
-	of_id = of_match_node(ramc_ids, np);
-	if (!of_id)
-		pr_warn("AT91: ramc no standby function available\n");
-	else
-		at91_pm_set_standby(of_id->data);
+	at91_pm_set_standby(of_id->data);
 
 	of_node_put(np);
 }
-- 
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
hosted by The Linux Foundation

