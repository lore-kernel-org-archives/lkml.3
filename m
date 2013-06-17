Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755438Ab3FQRuc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Jun 2013 13:50:32 -0400
Received: from hqemgate03.nvidia.com ([216.228.121.140]:16470 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753735Ab3FQRuY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Jun 2013 13:50:24 -0400
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Mon, 17 Jun 2013 10:50:22 -0700
From: Tuomas Tynkkynen <ttynkkynen@nvidia.com>
To: Samuel Ortiz <sameo@linux.intel.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
CC: <linux-tegra@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-i2c@vger.kernel.org>, Linus Walleij <linus.walleij@linaro.org>,
        Tuomas Tynkkynen <ttynkkynen@nvidia.com>
Subject: [PATCH 1/2] mfd: tps65910: Fix crash in i2c_driver .probe
Date: Mon, 17 Jun 2013 20:47:36 +0300
Message-ID: <1371491257-23791-2-git-send-email-ttynkkynen@nvidia.com>
X-Mailer: git-send-email 1.8.1.5
In-Reply-To: <1371491257-23791-1-git-send-email-ttynkkynen@nvidia.com>
References: <1371491257-23791-1-git-send-email-ttynkkynen@nvidia.com>
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

Signed-off-by: Tuomas Tynkkynen <ttynkkynen@nvidia.com>
---
 drivers/mfd/tps65910.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/drivers/mfd/tps65910.c b/drivers/mfd/tps65910.c
index d792772..a62c30d 100644
--- a/drivers/mfd/tps65910.c
+++ b/drivers/mfd/tps65910.c
@@ -461,16 +461,18 @@ static int tps65910_i2c_probe(struct i2c_client *i2c,
 	struct tps65910_board *of_pmic_plat_data = NULL;
 	struct tps65910_platform_data *init_data;
 	int ret = 0;
-	int chip_id = id->driver_data;
+	int chip_id = -1;
 
 	pmic_plat_data = dev_get_platdata(&i2c->dev);
 
-	if (!pmic_plat_data && i2c->dev.of_node) {
+	if (id) {
+		chip_id = id->driver_data;
+	} else if (i2c->dev.of_node) {
 		pmic_plat_data = tps65910_parse_dt(i2c, &chip_id);
 		of_pmic_plat_data = pmic_plat_data;
 	}
 
-	if (!pmic_plat_data)
+	if (!pmic_plat_data || chip_id < 0)
 		return -EINVAL;
 
 	init_data = devm_kzalloc(&i2c->dev, sizeof(*init_data), GFP_KERNEL);
-- 
1.8.1.5

