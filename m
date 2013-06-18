Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932166Ab3FRKPC (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Jun 2013 06:15:02 -0400
Received: from hqemgate04.nvidia.com ([216.228.121.35]:17716 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755716Ab3FRKO7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Jun 2013 06:14:59 -0400
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Tue, 18 Jun 2013 03:13:24 -0700
From: Tuomas Tynkkynen <ttynkkynen@nvidia.com>
To: Samuel Ortiz <sameo@linux.intel.com>, Mark Brown <broonie@kernel.org>,
        Wolfram Sang <wsa@the-dreams.de>
CC: <linux-tegra@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-i2c@vger.kernel.org>, Linus Walleij <linus.walleij@linaro.org>,
        Tuomas Tynkkynen <ttynkkynen@nvidia.com>
Subject: [PATCH v2 2/2] regulator: tps62360: Fix crash in i2c_driver .probe
Date: Tue, 18 Jun 2013 13:14:41 +0300
Message-ID: <1371550481-28126-3-git-send-email-ttynkkynen@nvidia.com>
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

Tested-by: Stephen Warren <swarren@nvidia.com>
Reviewed-by: Stephen Warren <swarren@nvidia.com>
Signed-off-by: Tuomas Tynkkynen <ttynkkynen@nvidia.com>
---
 v2: Added Stephen's Tested-by & Reviewed-by

 drivers/regulator/tps62360-regulator.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/regulator/tps62360-regulator.c b/drivers/regulator/tps62360-regulator.c
index 612919c..a490d5b 100644
--- a/drivers/regulator/tps62360-regulator.c
+++ b/drivers/regulator/tps62360-regulator.c
@@ -351,7 +351,6 @@ static int tps62360_probe(struct i2c_client *client,
 	int chip_id;
 
 	pdata = client->dev.platform_data;
-	chip_id = id->driver_data;
 
 	if (client->dev.of_node) {
 		const struct of_device_id *match;
@@ -364,6 +363,11 @@ static int tps62360_probe(struct i2c_client *client,
 		chip_id = (int)match->data;
 		if (!pdata)
 			pdata = of_get_tps62360_platform_data(&client->dev);
+	} else if (id) {
+		chip_id = id->driver_data;
+	} else {
+		dev_err(&client->dev, "No device tree match or id table match found\n");
+		return -ENODEV;
 	}
 
 	if (!pdata) {
@@ -402,7 +406,7 @@ static int tps62360_probe(struct i2c_client *client,
 		return -ENODEV;
 	}
 
-	tps->desc.name = id->name;
+	tps->desc.name = client->name;
 	tps->desc.id = 0;
 	tps->desc.ops = &tps62360_dcdc_ops;
 	tps->desc.type = REGULATOR_VOLTAGE;
-- 
1.8.1.5

