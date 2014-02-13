Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752265AbaBMVdl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Feb 2014 16:33:41 -0500
Received: from gloria.sntech.de ([95.129.55.99]:49763 "EHLO gloria.sntech.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752209AbaBMVdf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Feb 2014 16:33:35 -0500
From: Heiko =?ISO-8859-1?Q?St=FCbner?= <heiko@sntech.de>
To: Mark Brown <broonie@kernel.org>
Cc: linux-kernel@vger.kernel.org, Liam Girdwood <lgirdwood@gmail.com>
Subject: [PATCH v2 RESEND] regulator: gpio-regulator: fix forgotten gpios-states reading
Date: Thu, 13 Feb 2014 22:32:41 +0100
Message-ID: <1902047.iQ5LV1fbbb@phil>
User-Agent: KMail/4.11.3 (Linux/3.11-2-amd64; KDE/4.11.3; x86_64; ; )
In-Reply-To: <20140213210956.GE28112@sirena.org.uk>
References: <9348920.79Ktlcbcai@phil> <1528469.iBzMKAUgWB@phil> <20140213210956.GE28112@sirena.org.uk>
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
Looks like I missed the dev_warn addition from 2014-02-11 in v1.
Patch applies against topic/gpio.

 drivers/regulator/gpio-regulator.c |   22 +++++++++++++---------
 1 file changed, 13 insertions(+), 9 deletions(-)

diff --git a/drivers/regulator/gpio-regulator.c b/drivers/regulator/gpio-regulator.c
index 9fd5561..989b23b 100644
--- a/drivers/regulator/gpio-regulator.c
+++ b/drivers/regulator/gpio-regulator.c
@@ -171,13 +171,14 @@ of_get_gpio_regulator_config(struct device *dev, struct device_node *np)
 	if (!config->gpios)
 		return ERR_PTR(-ENOMEM);
 
-	prop = of_find_property(np, "gpios-states", NULL);
-	if (prop) {
-		proplen = prop->length / sizeof(int);
-		if (proplen != config->nr_gpios) {
-			dev_warn(dev, "gpios <-> gpios-states mismatch\n");
-			prop = NULL;
-		}
+	proplen = of_property_count_u32_elems(np, "gpios-states");
+	/* optional property */
+	if (proplen < 0)
+		proplen = 0;
+
+	if (proplen > 0 && proplen != config->nr_gpios) {
+		dev_warn(dev, "gpios <-> gpios-states mismatch\n");
+		proplen = 0;
 	}
 
 	for (i = 0; i < config->nr_gpios; i++) {
@@ -185,8 +186,11 @@ of_get_gpio_regulator_config(struct device *dev, struct device_node *np)
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


