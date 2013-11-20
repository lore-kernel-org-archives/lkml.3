Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752949Ab3KTI7I (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Nov 2013 03:59:08 -0500
Received: from mail-we0-f179.google.com ([74.125.82.179]:51556 "EHLO
	mail-we0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750858Ab3KTI7D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Nov 2013 03:59:03 -0500
From: Linus Walleij <linus.walleij@linaro.org>
To: linux-kernel@vger.kernel.org, Daniel Lezcano <daniel.lezcano@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>
Cc: Linus Walleij <linus.walleij@linaro.org>
Subject: [PATCH] clksrc-of: warn if no clock sources are found
Date: Wed, 20 Nov 2013 09:58:56 +0100
Message-Id: <1384937936-14267-1-git-send-email-linus.walleij@linaro.org>
X-Mailer: git-send-email 1.8.3.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Many platforms rely on clocksource_of_init() being implicitly
called for registering clock sources and will get zero warnings
if no working clock source is available. Let's print a critical
error message if no clock source is found.

Acked-by: Lee Jones <lee.jones@linaro.org>
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
---
 drivers/clocksource/clksrc-of.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/clocksource/clksrc-of.c b/drivers/clocksource/clksrc-of.c
index 35639cf4e5a2..a30b42c3ac3b 100644
--- a/drivers/clocksource/clksrc-of.c
+++ b/drivers/clocksource/clksrc-of.c
@@ -28,6 +28,7 @@ void __init clocksource_of_init(void)
 	struct device_node *np;
 	const struct of_device_id *match;
 	clocksource_of_init_fn init_func;
+	unsigned clocksources = 0;
 
 	for_each_matching_node_and_match(np, __clksrc_of_table, &match) {
 		if (!of_device_is_available(np))
@@ -36,5 +37,8 @@ void __init clocksource_of_init(void)
 		init_func = match->data;
 		init_func(np);
 		of_node_put(np);
+		clocksources++;
 	}
+	if (!clocksources)
+		pr_crit("%s: no matching clocksources found\n", __func__);
 }
-- 
1.8.3.1

