Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755847Ab3FRNSa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Jun 2013 09:18:30 -0400
Received: from smtp4.epfl.ch ([128.178.224.219]:37319 "HELO smtp4.epfl.ch"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S932195Ab3FRNS1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Jun 2013 09:18:27 -0400
From: Florian Vaussard <florian.vaussard@epfl.ch>
To: Grant Likely <grant.likely@linaro.org>,
        Rob Herring <rob.herring@calxeda.com>,
        Samuel Ortiz <sameo@linux.intel.com>
Cc: Kevin Hilman <khilman@linaro.org>, Rob Landley <rob@landley.net>,
        Peter Ujfalusi <peter.ujfalusi@ti.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Tero Kristo <t-kristo@ti.com>, devicetree-discuss@lists.ozlabs.org,
        linux-arm-kernel@lists.infradead.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Florian Vaussard <florian.vaussard@epfl.ch>
Subject: [PATCH v2 5/5] mfd: twl4030-power: Fix relocking on error
Date: Tue, 18 Jun 2013 15:18:00 +0200
Message-Id: <1371561480-28325-6-git-send-email-florian.vaussard@epfl.ch>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1371561480-28325-1-git-send-email-florian.vaussard@epfl.ch>
References: <1371561480-28325-1-git-send-email-florian.vaussard@epfl.ch>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If an error occurs when loading power scripts or resources, the
registers are not correctly relocked. Fix it.

Signed-off-by: Florian Vaussard <florian.vaussard@epfl.ch>
---
 drivers/mfd/twl4030-power.c |   12 ++++++++----
 1 files changed, 8 insertions(+), 4 deletions(-)

diff --git a/drivers/mfd/twl4030-power.c b/drivers/mfd/twl4030-power.c
index 1c19d82..a8b33c9 100644
--- a/drivers/mfd/twl4030-power.c
+++ b/drivers/mfd/twl4030-power.c
@@ -558,6 +558,7 @@ int twl4030_power_probe(struct platform_device *pdev)
 	struct twl4030_power_data *pdata = pdev->dev.platform_data;
 	struct device_node *node = pdev->dev.of_node;
 	int err = 0;
+	int err2 = 0;
 	u8 val;
 
 	if (!pdata && !node) {
@@ -581,12 +582,12 @@ int twl4030_power_probe(struct platform_device *pdev)
 		err = twl4030_power_configure_scripts(pdata);
 		if (err) {
 			pr_err("TWL4030 failed to load scripts\n");
-			return err;
+			goto relock;
 		}
 		err = twl4030_power_configure_resources(pdata);
 		if (err) {
 			pr_err("TWL4030 failed to configure resource\n");
-			return err;
+			goto relock;
 		}
 	}
 
@@ -612,10 +613,13 @@ int twl4030_power_probe(struct platform_device *pdev)
 	}
 
 relock:
-	err = twl_i2c_write_u8(TWL_MODULE_PM_MASTER, 0,
+	err2 = twl_i2c_write_u8(TWL_MODULE_PM_MASTER, 0,
 			       TWL4030_PM_MASTER_PROTECT_KEY);
-	if (err)
+	if (err2) {
 		pr_err("TWL4030 Unable to relock registers\n");
+		return err2;
+	}
+
 	return err;
 }
 
-- 
1.7.5.4

