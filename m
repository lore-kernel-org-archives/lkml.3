Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932150Ab3FRKO4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Jun 2013 06:14:56 -0400
Received: from hqemgate03.nvidia.com ([216.228.121.140]:17084 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756001Ab3FRKOy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Jun 2013 06:14:54 -0400
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Tue, 18 Jun 2013 03:13:22 -0700
From: Tuomas Tynkkynen <ttynkkynen@nvidia.com>
To: Samuel Ortiz <sameo@linux.intel.com>, Mark Brown <broonie@kernel.org>,
        Wolfram Sang <wsa@the-dreams.de>
CC: <linux-tegra@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-i2c@vger.kernel.org>, Linus Walleij <linus.walleij@linaro.org>,
        Tuomas Tynkkynen <ttynkkynen@nvidia.com>
Subject: [PATCH v2 1/2] mfd: tps65910: Fix crash in i2c_driver .probe
Date: Tue, 18 Jun 2013 13:14:40 +0300
Message-ID: <1371550481-28126-2-git-send-email-ttynkkynen@nvidia.com>
X-Mailer: git-send-email 1.8.1.5
In-Reply-To: <1371550481-28126-1-git-send-email-ttynkkynen@nvidia.com>
References: <1371550481-28126-1-git-send-email-ttynkkynen@nvidia.com>
X-NVConfidentiality: public
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit "i2c: core: make it possible to match a pure device tree driver"
changed semantics of the i2c probing for device tree devices.
Device tree probed devices now get a NULL i2c_device_id pointer.
This caused kernel panics due to NULL dereference.

Moves the of_match_device call from tps65910_parse_dt to .probe to
allow the chip type to be detected from device tree but with the
device parameters coming from platform data.

Signed-off-by: Tuomas Tynkkynen <ttynkkynen@nvidia.com>
---
 v2: Don't overwrite platform data from DT 

 drivers/mfd/tps65910.c | 39 +++++++++++++++++++++------------------
 1 file changed, 21 insertions(+), 18 deletions(-)

diff --git a/drivers/mfd/tps65910.c b/drivers/mfd/tps65910.c
index d792772..61147b4 100644
--- a/drivers/mfd/tps65910.c
+++ b/drivers/mfd/tps65910.c
@@ -384,22 +384,13 @@ static struct of_device_id tps65910_of_match[] = {
 MODULE_DEVICE_TABLE(of, tps65910_of_match);
 
 static struct tps65910_board *tps65910_parse_dt(struct i2c_client *client,
-						int *chip_id)
+						int chip_id)
 {
 	struct device_node *np = client->dev.of_node;
 	struct tps65910_board *board_info;
 	unsigned int prop;
-	const struct of_device_id *match;
 	int ret = 0;
 
-	match = of_match_device(tps65910_of_match, &client->dev);
-	if (!match) {
-		dev_err(&client->dev, "Failed to find matching dt id\n");
-		return NULL;
-	}
-
-	*chip_id  = (int)match->data;
-
 	board_info = devm_kzalloc(&client->dev, sizeof(*board_info),
 			GFP_KERNEL);
 	if (!board_info) {
@@ -410,13 +401,13 @@ static struct tps65910_board *tps65910_parse_dt(struct i2c_client *client,
 	ret = of_property_read_u32(np, "ti,vmbch-threshold", &prop);
 	if (!ret)
 		board_info->vmbch_threshold = prop;
-	else if (*chip_id == TPS65911)
+	else if (chip_id == TPS65911)
 		dev_warn(&client->dev, "VMBCH-Threshold not specified");
 
 	ret = of_property_read_u32(np, "ti,vmbch2-threshold", &prop);
 	if (!ret)
 		board_info->vmbch2_threshold = prop;
-	else if (*chip_id == TPS65911)
+	else if (chip_id == TPS65911)
 		dev_warn(&client->dev, "VMBCH2-Threshold not specified");
 
 	prop = of_property_read_bool(np, "ti,en-ck32k-xtal");
@@ -432,7 +423,7 @@ static struct tps65910_board *tps65910_parse_dt(struct i2c_client *client,
 #else
 static inline
 struct tps65910_board *tps65910_parse_dt(struct i2c_client *client,
-					 int *chip_id)
+					 int chip_id)
 {
 	return NULL;
 }
@@ -461,16 +452,28 @@ static int tps65910_i2c_probe(struct i2c_client *i2c,
 	struct tps65910_board *of_pmic_plat_data = NULL;
 	struct tps65910_platform_data *init_data;
 	int ret = 0;
-	int chip_id = id->driver_data;
+	int chip_id = -1;
 
 	pmic_plat_data = dev_get_platdata(&i2c->dev);
 
-	if (!pmic_plat_data && i2c->dev.of_node) {
-		pmic_plat_data = tps65910_parse_dt(i2c, &chip_id);
-		of_pmic_plat_data = pmic_plat_data;
+	if (id) {
+		chip_id = id->driver_data;
+	} else if (i2c->dev.of_node) {
+		const struct of_device_id *match;
+		match = of_match_device(tps65910_of_match, &i2c->dev);
+		if (!match) {
+			dev_err(&i2c->dev, "Failed to find matching dt id\n");
+			return -EINVAL;
+		}
+		chip_id  = (int)match->data;
+
+		if (!pmic_plat_data) {
+			pmic_plat_data = tps65910_parse_dt(i2c, chip_id);
+			of_pmic_plat_data = pmic_plat_data;
+		}
 	}
 
-	if (!pmic_plat_data)
+	if (!pmic_plat_data || chip_id < 0)
 		return -EINVAL;
 
 	init_data = devm_kzalloc(&i2c->dev, sizeof(*init_data), GFP_KERNEL);
-- 
1.8.1.5

