Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752516AbaKGNAw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Nov 2014 08:00:52 -0500
Received: from bhuna.collabora.co.uk ([93.93.135.160]:44237 "EHLO
	bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752380AbaKGNAe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Nov 2014 08:00:34 -0500
From: Javier Martinez Canillas <javier.martinez@collabora.co.uk>
To: Mark Brown <broonie@kernel.org>
Cc: Kukjin Kim <kgene.kim@samsung.com>, Chanwoo Choi <cw00.choi@samsung.com>,
        Olof Johansson <olof@lixom.net>, Chris Zhong <zyw@rock-chips.com>,
        Krzysztof Kozlowski <k.kozlowski@samsung.com>,
        Abhilash Kesavan <kesavan.abhilash@gmail.com>,
        linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org,
        Javier Martinez Canillas <javier.martinez@collabora.co.uk>
Subject: [PATCH v5 5/5] regulator: of: Add support for parsing initial and suspend modes
Date: Fri,  7 Nov 2014 14:00:05 +0100
Message-Id: <1415365205-27630-6-git-send-email-javier.martinez@collabora.co.uk>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1415365205-27630-1-git-send-email-javier.martinez@collabora.co.uk>
References: <1415365205-27630-1-git-send-email-javier.martinez@collabora.co.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Some regulators support their operating mode to be changed on startup
or by consumers when the system is running while others only support
their operating mode to be changed while the system has entered in a
suspend state.

The regulator Device Tree binding documents a set of properties to
configure the regulators operating modes from a FDT. This patch builds
on (40e20d6 regulator: of: Add support for parsing regulator_state for
suspend state) and adds support to parse those properties and fill the
regulator constraints so the regulator core can call the right suspend
handlers when the system enters into sleep.

The modes are defined in the Device Tree using the hardware specific
modes supported by the regulators. Regulator drivers have to define a
translation function that is used to map the hardware specific modes
to the standard ones.

Signed-off-by: Javier Martinez Canillas <javier.martinez@collabora.co.uk>
---

Changes in v5: None

Changes in v4:
 - Parse the properties in the core and map using driver provided functions.
   Suggested by Mark Brown

Changes in v3:
 - Use the standard suspend states binding instead of custom properties.
   Suggested by Mark Brown

 drivers/regulator/of_regulator.c | 22 ++++++++++++++++++++--
 1 file changed, 20 insertions(+), 2 deletions(-)

diff --git a/drivers/regulator/of_regulator.c b/drivers/regulator/of_regulator.c
index cbc1d71..cd65885 100644
--- a/drivers/regulator/of_regulator.c
+++ b/drivers/regulator/of_regulator.c
@@ -25,7 +25,8 @@ static const char *const regulator_states[PM_SUSPEND_MAX + 1] = {
 };
 
 static void of_get_regulation_constraints(struct device_node *np,
-					struct regulator_init_data **init_data)
+					struct regulator_init_data **init_data,
+					const struct regulator_desc *desc)
 {
 	const __be32 *min_uV, *max_uV;
 	struct regulation_constraints *constraints = &(*init_data)->constraints;
@@ -81,6 +82,14 @@ static void of_get_regulation_constraints(struct device_node *np,
 	if (!ret)
 		constraints->enable_time = pval;
 
+	if (!of_property_read_u32(np, "regulator-initial-mode", &pval)) {
+		if (desc && desc->map_modes)
+			constraints->initial_mode = desc->map_modes(pval);
+		else
+			pr_warn("%s: failed to parse regulator-initial-mode\n",
+				np->name);
+	}
+
 	for (i = 0; i < ARRAY_SIZE(regulator_states); i++) {
 		switch (i) {
 		case PM_SUSPEND_MEM:
@@ -100,6 +109,15 @@ static void of_get_regulation_constraints(struct device_node *np,
 		if (!suspend_np || !suspend_state)
 			continue;
 
+		if (!of_property_read_u32(suspend_np, "regulator-mode",
+					  &pval)) {
+			if (desc && desc->map_modes)
+				suspend_state->mode = desc->map_modes(pval);
+			else
+				pr_warn("%s: failed to parse regulator-mode\n",
+					np->name);
+		}
+
 		if (of_property_read_bool(suspend_np,
 					"regulator-on-in-suspend"))
 			suspend_state->enabled = true;
@@ -140,7 +158,7 @@ struct regulator_init_data *of_get_regulator_init_data(struct device *dev,
 	if (!init_data)
 		return NULL; /* Out of memory? */
 
-	of_get_regulation_constraints(node, &init_data);
+	of_get_regulation_constraints(node, &init_data, desc);
 	return init_data;
 }
 EXPORT_SYMBOL_GPL(of_get_regulator_init_data);
-- 
2.1.0

