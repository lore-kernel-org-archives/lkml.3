Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752589AbaBLAB7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Feb 2014 19:01:59 -0500
Received: from gloria.sntech.de ([95.129.55.99]:54655 "EHLO gloria.sntech.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751507AbaBLAB6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Feb 2014 19:01:58 -0500
From: Heiko =?ISO-8859-1?Q?St=FCbner?= <heiko@sntech.de>
To: grant.likely@linaro.org
Cc: robh+dt@kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, Liam Girdwood <lgirdwood@gmail.com>,
        Mark Brown <broonie@kernel.org>
Subject: [PATCH 2/3] regulator: gpio-regulator: do not open-code counting and access of dt array elements
Date: Wed, 12 Feb 2014 01:01:08 +0100
Message-ID: <1553563.pNlhnjkCFL@phil>
User-Agent: KMail/4.11.3 (Linux/3.11-2-amd64; KDE/4.11.3; x86_64; ; )
In-Reply-To: <2573561.oCYNnnL0gm@phil>
References: <2573561.oCYNnnL0gm@phil>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Heiko Stuebner <heiko.stuebner@bqreaders.com>

Open coding the counting of elements in a dt-property is abstracted by the newly
introduced of_property_count_uXX_elems functions. Additionally the raw iteration
over the states element exposes the endian conversion and dtb-format details,
which according to Mark Rutland "would be nice to limit [...] to of_ helper
functions".

Thus change gpio-regulator to use the helper for element counting and
of_property_read_u32_index for retrieval of individual values.

This makes it possible to remove the raw access to the states property entirely.

Signed-off-by: Heiko Stuebner <heiko.stuebner@bqreaders.com>
---
 drivers/regulator/gpio-regulator.c |   15 ++++++---------
 1 file changed, 6 insertions(+), 9 deletions(-)

diff --git a/drivers/regulator/gpio-regulator.c b/drivers/regulator/gpio-regulator.c
index ac3a8c7..500aa3b 100644
--- a/drivers/regulator/gpio-regulator.c
+++ b/drivers/regulator/gpio-regulator.c
@@ -136,7 +136,6 @@ static struct gpio_regulator_config *
 of_get_gpio_regulator_config(struct device *dev, struct device_node *np)
 {
 	struct gpio_regulator_config *config;
-	struct property *prop;
 	const char *regtype;
 	int proplen, gpio, i;
 	int ret;
@@ -191,14 +190,12 @@ of_get_gpio_regulator_config(struct device *dev, struct device_node *np)
 	}
 
 	/* Fetch states. */
-	prop = of_find_property(np, "states", NULL);
-	if (!prop) {
+	proplen = of_property_count_u32_elems(np, "states");
+	if (proplen < 0) {
 		dev_err(dev, "No 'states' property found\n");
 		return ERR_PTR(-EINVAL);
 	}
 
-	proplen = prop->length / sizeof(int);
-
 	config->states = devm_kzalloc(dev,
 				sizeof(struct gpio_regulator_state)
 				* (proplen / 2),
@@ -207,10 +204,10 @@ of_get_gpio_regulator_config(struct device *dev, struct device_node *np)
 		return ERR_PTR(-ENOMEM);
 
 	for (i = 0; i < proplen / 2; i++) {
-		config->states[i].value =
-			be32_to_cpup((int *)prop->value + (i * 2));
-		config->states[i].gpios =
-			be32_to_cpup((int *)prop->value + (i * 2 + 1));
+		of_property_read_u32_index(np, "states", i * 2,
+					   &config->states[i].value);
+		of_property_read_u32_index(np, "states", i * 2 + 1,
+					   &config->states[i].gpios);
 	}
 	config->nr_states = i;
 
-- 
1.7.10.4


