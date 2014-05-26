Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752042AbaEZU1X (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 May 2014 16:27:23 -0400
Received: from mail-lb0-f181.google.com ([209.85.217.181]:38731 "EHLO
	mail-lb0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751472AbaEZU1U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 May 2014 16:27:20 -0400
To: lgirdwood@gmail.com, broonie@kernel.org
Subject: [PATCH] of_regulator: use of_property_read_{bool|u32}()
Cc: grant.likely@linaro.org, robh+dt@kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
From: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
Organization: Cogent Embedded
Date: Tue, 27 May 2014 00:27:19 +0400
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201405270027.20092.sergei.shtylyov@cogentembedded.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use more compact of_property_read_{bool|u32}() calls instead of the
of_{find|get}_property() calls in of_get_regulation_constraints() where
possible (note that of_property_read_{bool|u32}() were already used to read
some properties).

Signed-off-by: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>

---
The patch is against Mark Brown's 'regulator.git' repo's 'for-next' branch.

 drivers/regulator/of_regulator.c |   37 ++++++++++++++-----------------------
 1 file changed, 14 insertions(+), 23 deletions(-)

Index: regulator/drivers/regulator/of_regulator.c
===================================================================
--- regulator.orig/drivers/regulator/of_regulator.c
+++ regulator/drivers/regulator/of_regulator.c
@@ -19,9 +19,7 @@
 static void of_get_regulation_constraints(struct device_node *np,
 					struct regulator_init_data **init_data)
 {
-	const __be32 *min_uV, *max_uV, *uV_offset;
-	const __be32 *min_uA, *max_uA, *ramp_delay;
-	struct property *prop;
+	const __be32 *min_uV, *max_uV;
 	struct regulation_constraints *constraints = &(*init_data)->constraints;
 	int ret;
 	u32 pval;
@@ -42,36 +40,29 @@ static void of_get_regulation_constraint
 	if (min_uV && max_uV && constraints->min_uV == constraints->max_uV)
 		constraints->apply_uV = true;
 
-	uV_offset = of_get_property(np, "regulator-microvolt-offset", NULL);
-	if (uV_offset)
-		constraints->uV_offset = be32_to_cpu(*uV_offset);
-	min_uA = of_get_property(np, "regulator-min-microamp", NULL);
-	if (min_uA)
-		constraints->min_uA = be32_to_cpu(*min_uA);
-	max_uA = of_get_property(np, "regulator-max-microamp", NULL);
-	if (max_uA)
-		constraints->max_uA = be32_to_cpu(*max_uA);
+	if (!of_property_read_u32(np, "regulator-microvolt-offset", &pval))
+		constraints->uV_offset = pval;
+	if (!of_property_read_u32(np, "regulator-min-microamp", &pval))
+		constraints->min_uA = pval;
+	if (!of_property_read_u32(np, "regulator-max-microamp", &pval))
+		constraints->max_uA = pval;
 
 	/* Current change possible? */
 	if (constraints->min_uA != constraints->max_uA)
 		constraints->valid_ops_mask |= REGULATOR_CHANGE_CURRENT;
 
-	if (of_find_property(np, "regulator-boot-on", NULL))
-		constraints->boot_on = true;
-
-	if (of_find_property(np, "regulator-always-on", NULL))
-		constraints->always_on = true;
-	else /* status change should be possible if not always on. */
+	constraints->boot_on = of_property_read_bool(np, "regulator-boot-on");
+	constraints->always_on = of_property_read_bool(np, "regulator-always-on");
+	if (!constraints->always_on) /* status change should be possible. */
 		constraints->valid_ops_mask |= REGULATOR_CHANGE_STATUS;
 
 	if (of_property_read_bool(np, "regulator-allow-bypass"))
 		constraints->valid_ops_mask |= REGULATOR_CHANGE_BYPASS;
 
-	prop = of_find_property(np, "regulator-ramp-delay", NULL);
-	if (prop && prop->value) {
-		ramp_delay = prop->value;
-		if (*ramp_delay)
-			constraints->ramp_delay = be32_to_cpu(*ramp_delay);
+	ret = of_property_read_u32(np, "regulator-ramp-delay", &pval);
+	if (!ret) {
+		if (pval)
+			constraints->ramp_delay = pval;
 		else
 			constraints->ramp_disable = true;
 	}
