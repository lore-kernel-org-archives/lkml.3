Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935269AbaH0QHG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Aug 2014 12:07:06 -0400
Received: from top.free-electrons.com ([176.31.233.9]:53350 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S934941AbaH0QHE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Aug 2014 12:07:04 -0400
From: Alexandre Belloni <alexandre.belloni@free-electrons.com>
To: Nicolas Ferre <nicolas.ferre@atmel.com>
Cc: Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Maxime Ripard <maxime.ripard@free-electrons.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Alexandre Belloni <alexandre.belloni@free-electrons.com>
Subject: [PATCH] ARM: at91: fix ramc standby function registration
Date: Wed, 27 Aug 2014 18:06:51 +0200
Message-Id: <1409155611-7574-1-git-send-email-alexandre.belloni@free-electrons.com>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

After the for_each_matching_node loop, we end up with a null value for np. Then,
of_match_node() is not matching anything and we can't register the standby
function and "ramc no standby function available" is printed.

Fix that by selecting the first available standby function. For now,
at91_pm_set_standby doesn't support multiple different standby functions and no
existing SoCs have different RAM controllers.

Signed-off-by: Alexandre Belloni <alexandre.belloni@free-electrons.com>
---
 arch/arm/mach-at91/setup.c | 11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

diff --git a/arch/arm/mach-at91/setup.c b/arch/arm/mach-at91/setup.c
index 28ae63b8eb16..d2cade21ebd7 100644
--- a/arch/arm/mach-at91/setup.c
+++ b/arch/arm/mach-at91/setup.c
@@ -343,25 +343,28 @@ static void at91_dt_ramc(void)
 	struct device_node *np;
 	const struct of_device_id *of_id;
 	int idx = 0;
+	const void *standby = NULL;
 
-	for_each_matching_node(np, ramc_ids) {
+	for_each_matching_node_and_match(np, ramc_ids, &of_id) {
 		at91_ramc_base[idx] = of_iomap(np, 0);
 		if (!at91_ramc_base[idx])
 			panic(pr_fmt("unable to map ramc[%d] cpu registers\n"), idx);
 
+		if (!standby)
+			standby = of_id->data;
+
 		idx++;
 	}
 
 	if (!idx)
 		panic(pr_fmt("unable to find compatible ram controller node in dtb\n"));
 
-	of_id = of_match_node(ramc_ids, np);
-	if (!of_id) {
+	if (!standby) {
 		pr_warn("ramc no standby function available\n");
 		return;
 	}
 
-	at91_pm_set_standby(of_id->data);
+	at91_pm_set_standby(standby);
 }
 
 void __init at91rm9200_dt_initialize(void)
-- 
1.9.1

