Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751708AbaBLXtq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Feb 2014 18:49:46 -0500
Received: from gloria.sntech.de ([95.129.55.99]:39527 "EHLO gloria.sntech.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750862AbaBLXtp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Feb 2014 18:49:45 -0500
From: Heiko =?ISO-8859-1?Q?St=FCbner?= <heiko@sntech.de>
To: Mark Brown <broonie@kernel.org>
Cc: linux-kernel@vger.kernel.org, Liam Girdwood <lgirdwood@gmail.com>
Subject: [PATCH] regulator: gpio-regulator: fix forgotten gpios-states reading
Date: Thu, 13 Feb 2014 00:48:52 +0100
Message-ID: <9348920.79Ktlcbcai@phil>
User-Agent: KMail/4.11.3 (Linux/3.11-2-amd64; KDE/4.11.3; x86_64; ; )
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Heiko Stuebner <heiko.stuebner@bqreaders.com>

Commit 934624d6e9f0 ("regulator: gpio-regulator: do not open-code counting
and access of dt array elements") forgot to convert the recently added
gpios-states property using the same pattern.

Convert this instance to use the of-helpers too, resolving the build error.

Signed-off-by: Heiko Stuebner <heiko.stuebner@bqreaders.com>
---
 drivers/regulator/gpio-regulator.c |   19 +++++++++----------
 1 file changed, 9 insertions(+), 10 deletions(-)

diff --git a/drivers/regulator/gpio-regulator.c b/drivers/regulator/gpio-regulator.c
index 500aa3b..64b4413 100644
--- a/drivers/regulator/gpio-regulator.c
+++ b/drivers/regulator/gpio-regulator.c
@@ -171,22 +171,21 @@ of_get_gpio_regulator_config(struct device *dev, struct device_node *np)
 	if (!config->gpios)
 		return ERR_PTR(-ENOMEM);
 
-	prop = of_find_property(np, "gpios-states", NULL);
-	if (prop) {
-		proplen = prop->length / sizeof(int);
-		if (proplen != config->nr_gpios) {
-			/* gpios <-> gpios-states mismatch */
-			prop = NULL;
-		}
-	}
+	proplen = of_property_count_u32_elems(np, "gpios-states");
+	/* check gpios <-> gpios-states mismatch */
+	if (proplen != config->nr_gpios)
+		proplen = 0;
 
 	for (i = 0; i < config->nr_gpios; i++) {
 		gpio = of_get_named_gpio(np, "gpios", i);
 		if (gpio < 0)
 			break;
 		config->gpios[i].gpio = gpio;
-		if (prop && be32_to_cpup((int *)prop->value + i))
-			config->gpios[i].flags = GPIOF_OUT_INIT_HIGH;
+		if (proplen > 0) {
+			of_property_read_u32_index(np, "gpios-states", i, &ret);
+			if (ret)
+				config->gpios[i].flags = GPIOF_OUT_INIT_HIGH;
+		}
 	}
 
 	/* Fetch states. */
-- 
1.7.10.4


