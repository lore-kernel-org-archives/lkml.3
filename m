Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752642AbaBLACg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Feb 2014 19:02:36 -0500
Received: from gloria.sntech.de ([95.129.55.99]:54668 "EHLO gloria.sntech.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752503AbaBLACe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Feb 2014 19:02:34 -0500
From: Heiko =?ISO-8859-1?Q?St=FCbner?= <heiko@sntech.de>
To: grant.likely@linaro.org
Cc: robh+dt@kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, Liam Girdwood <lgirdwood@gmail.com>,
        Mark Brown <broonie@kernel.org>
Subject: [PATCH 3/3] regulator: ti-abb-regulator: do not open-code counting and access of dt array elements
Date: Wed, 12 Feb 2014 01:01:42 +0100
Message-ID: <2193931.Kqcd3TrslU@phil>
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

Thus change ti-abb-regulator to use the helper for element counting and
of_property_read_u32_index for retrieval of individual values.

This makes it possible to remove the raw access to the property entirely.

Signed-off-by: Heiko Stuebner <heiko.stuebner@bqreaders.com>
---
 drivers/regulator/ti-abb-regulator.c |   43 ++++++++++++++++------------------
 1 file changed, 20 insertions(+), 23 deletions(-)

diff --git a/drivers/regulator/ti-abb-regulator.c b/drivers/regulator/ti-abb-regulator.c
index a97d0c5..804c83a 100644
--- a/drivers/regulator/ti-abb-regulator.c
+++ b/drivers/regulator/ti-abb-regulator.c
@@ -507,32 +507,24 @@ static int ti_abb_init_table(struct device *dev, struct ti_abb *abb,
 			     struct regulator_init_data *rinit_data)
 {
 	struct ti_abb_info *info;
-	const struct property *prop;
-	const __be32 *abb_info;
 	const u32 num_values = 6;
 	char *pname = "ti,abb_info";
-	u32 num_entries, i;
+	u32 i;
 	unsigned int *volt_table;
-	int min_uV = INT_MAX, max_uV = 0;
+	int num_entries, min_uV = INT_MAX, max_uV = 0;
 	struct regulation_constraints *c = &rinit_data->constraints;
 
-	prop = of_find_property(dev->of_node, pname, NULL);
-	if (!prop) {
-		dev_err(dev, "No '%s' property?\n", pname);
-		return -ENODEV;
-	}
-
-	if (!prop->value) {
-		dev_err(dev, "Empty '%s' property?\n", pname);
-		return -ENODATA;
-	}
-
 	/*
 	 * Each abb_info is a set of n-tuple, where n is num_values, consisting
 	 * of voltage and a set of detection logic for ABB information for that
 	 * voltage to apply.
 	 */
-	num_entries = prop->length / sizeof(u32);
+	num_entries = of_property_count_u32_elems(dev->of_node, pname);
+	if (num_entries < 0) {
+		dev_err(dev, "No '%s' property?\n", pname);
+		return -ENODEV;
+	}
+
 	if (!num_entries || (num_entries % num_values)) {
 		dev_err(dev, "All '%s' list entries need %d vals\n", pname,
 			num_values);
@@ -561,18 +553,23 @@ static int ti_abb_init_table(struct device *dev, struct ti_abb *abb,
 	/* We do not know where the OPP voltage is at the moment */
 	abb->current_info_idx = -EINVAL;
 
-	abb_info = prop->value;
 	for (i = 0; i < num_entries; i++, info++, volt_table++) {
 		u32 efuse_offset, rbb_mask, fbb_mask, vset_mask;
 		u32 efuse_val;
 
 		/* NOTE: num_values should equal to entries picked up here */
-		*volt_table = be32_to_cpup(abb_info++);
-		info->opp_sel = be32_to_cpup(abb_info++);
-		efuse_offset = be32_to_cpup(abb_info++);
-		rbb_mask = be32_to_cpup(abb_info++);
-		fbb_mask = be32_to_cpup(abb_info++);
-		vset_mask = be32_to_cpup(abb_info++);
+		of_property_read_u32_index(dev->of_node, pname, i * num_values,
+					   volt_table);
+		of_property_read_u32_index(dev->of_node, pname,
+					   i * num_values + 1, &info->opp_sel);
+		of_property_read_u32_index(dev->of_node, pname,
+					   i * num_values + 2, &efuse_offset);
+		of_property_read_u32_index(dev->of_node, pname,
+					   i * num_values + 3, &rbb_mask);
+		of_property_read_u32_index(dev->of_node, pname,
+					   i * num_values + 4, &fbb_mask);
+		of_property_read_u32_index(dev->of_node, pname,
+					   i * num_values + 5, &vset_mask);
 
 		dev_dbg(dev,
 			"[%d]v=%d ABB=%d ef=0x%x rbb=0x%x fbb=0x%x vset=0x%x\n",
-- 
1.7.10.4


