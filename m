Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932195AbaGAJfR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jul 2014 05:35:17 -0400
Received: from top.free-electrons.com ([176.31.233.9]:33603 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S932075AbaGAJfO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jul 2014 05:35:14 -0400
From: Maxime Ripard <maxime.ripard@free-electrons.com>
To: linux@maxim.org.za, Nicolas Ferre <nicolas.ferre@atmel.com>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Daniel Lezcano <daniel.lezcano@linaro.org>
Cc: Boris Brezillon <boris@free-electrons.com>,
        Alexandre Belloni <alexandre.belloni@free-electrons.com>,
        Thomas Petazzoni <thomas@free-electrons.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Maxime Ripard <maxime.ripard@free-electrons.com>
Subject: [PATCH v2 04/14] AT91: PIT: Use of_have_populated_dt instead of CONFIG_OF
Date: Tue,  1 Jul 2014 11:33:17 +0200
Message-Id: <1404207208-14513-5-git-send-email-maxime.ripard@free-electrons.com>
X-Mailer: git-send-email 2.0.0
In-Reply-To: <1404207208-14513-1-git-send-email-maxime.ripard@free-electrons.com>
References: <1404207208-14513-1-git-send-email-maxime.ripard@free-electrons.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Until now, the machines, even when CONFIG_OF was enabled, were calling
at91sam926x_ioremap_pit to try to map the PIT address using the defined
physical address.

Obviously, with DT, it's not appropriate anymore, and some code was added to
the function to deal with this case.

Unfortunately, this code was conditionned on CONFIG_OF, which can be enabled,
even though no DT was actually used, which would result in such a case, to this
code being executed, without any reason.

Moreover, the logic that was here before to bail out of the function just check
in the DT to see if the PIT node is there, which is the case in all our DTSI.

All this can be made much more straightforward just by using
of_have_populated_dt to bail out.

Signed-off-by: Maxime Ripard <maxime.ripard@free-electrons.com>
---
 arch/arm/mach-at91/at91sam926x_time.c | 10 ++--------
 1 file changed, 2 insertions(+), 8 deletions(-)

diff --git a/arch/arm/mach-at91/at91sam926x_time.c b/arch/arm/mach-at91/at91sam926x_time.c
index 2e6f1a37ab90..b87a12f05540 100644
--- a/arch/arm/mach-at91/at91sam926x_time.c
+++ b/arch/arm/mach-at91/at91sam926x_time.c
@@ -279,15 +279,9 @@ void __init at91sam926x_pit_init(void)
 
 void __init at91sam926x_ioremap_pit(u32 addr)
 {
-#if defined(CONFIG_OF)
-	struct device_node *np =
-		of_find_matching_node(NULL, pit_timer_ids);
-
-	if (np) {
-		of_node_put(np);
+	if (of_have_populated_dt())
 		return;
-	}
-#endif
+
 	pit_base_addr = ioremap(addr, 16);
 
 	if (!pit_base_addr)
-- 
2.0.0

