Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753264AbaCJIet (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Mar 2014 04:34:49 -0400
Received: from mailout3.w1.samsung.com ([210.118.77.13]:17382 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752421AbaCJIdC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Mar 2014 04:33:02 -0400
X-AuditID: cbfec7f5-b7fc96d000004885-c2-531d78bdc5b0
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
To: Liam Girdwood <lgirdwood@gmail.com>, Mark Brown <broonie@kernel.org>,
        linux-kernel@vger.kernel.org
Cc: Krzysztof Kozlowski <k.kozlowski@samsung.com>
Subject: [PATCH 7/8] regulator: max8952: Use managed regulator registration
Date: Mon, 10 Mar 2014 09:32:50 +0100
Message-id: <1394440371-29588-7-git-send-email-k.kozlowski@samsung.com>
X-Mailer: git-send-email 1.7.9.5
In-reply-to: <1394440371-29588-1-git-send-email-k.kozlowski@samsung.com>
References: <1394440371-29588-1-git-send-email-k.kozlowski@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrHJMWRmVeSWpSXmKPExsVy+t/xK7p7K2SDDY61i1tMffiEzeL1C0OL
	b1c6mCwu75rD5sDisXPWXXaPTas62Tz6tqxi9Pi8SS6AJYrLJiU1J7MstUjfLoEr49qbycwF
	byQq1jTNYGlg3CnSxcjJISFgIjF7SjsThC0mceHeejYQW0hgKaNE+5nkLkYuILuPSWL+4vnM
	IAk2AWOJzcuXgBWJCGRIbJ43lRXEZhYwlPj57g87iC0s4C3xceddsHoWAVWJ7mlbgeIcHLwC
	7hIf1muCmBICChJzJtmAVHAKeEgs2nOLHWKtu8Tuzh0sExh5FzAyrGIUTS1NLihOSs810itO
	zC0uzUvXS87P3cQICZOvOxiXHrM6xCjAwajEw3vgrUywEGtiWXFl7iFGCQ5mJRHejDjZYCHe
	lMTKqtSi/Pii0pzU4kOMTBycUg2Mgi8Cj0UK+y1PKEzqeX97/8qZDnI/NWrDBKSyF+0/uPmV
	XeaCXy7K74qOPDq96QTPVM/r4qUP1Q1ChRa/Pex4L1/0z5Se86pTNQsfXtGTmf6nwYtF4suE
	DW0ezv7cJd4la/nKnEufSbJcPzQt5w5HZ5WMiezi3cnvOZa8YAw8cXvzBdbtSb/uKbEUZyQa
	ajEXFScCAF1ys8LxAQAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use managed devm_regulator_register to simplify the driver probe and
driver remove functions. This allows removing from state container the
pointer to regulator_dev returned on registering the regulator.

Patch also removes from state container pointer to 'struct device' as it
is not used anywhere outside of max8952_pmic_probe() function.

Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
---
 drivers/regulator/max8952.c |   21 ++++++++-------------
 1 file changed, 8 insertions(+), 13 deletions(-)

diff --git a/drivers/regulator/max8952.c b/drivers/regulator/max8952.c
index 788e5ae2af1b..465f21f9d6ee 100644
--- a/drivers/regulator/max8952.c
+++ b/drivers/regulator/max8952.c
@@ -48,9 +48,7 @@ enum {
 
 struct max8952_data {
 	struct i2c_client	*client;
-	struct device		*dev;
 	struct max8952_platform_data *pdata;
-	struct regulator_dev	*rdev;
 
 	bool vid0;
 	bool vid1;
@@ -199,6 +197,7 @@ static int max8952_pmic_probe(struct i2c_client *client,
 	struct max8952_platform_data *pdata = dev_get_platdata(&client->dev);
 	struct regulator_config config = { };
 	struct max8952_data *max8952;
+	struct regulator_dev *rdev;
 
 	int ret = 0, err = 0;
 
@@ -219,10 +218,9 @@ static int max8952_pmic_probe(struct i2c_client *client,
 		return -ENOMEM;
 
 	max8952->client = client;
-	max8952->dev = &client->dev;
 	max8952->pdata = pdata;
 
-	config.dev = max8952->dev;
+	config.dev = &client->dev;
 	config.init_data = pdata->reg_data;
 	config.driver_data = max8952;
 	config.of_node = client->dev.of_node;
@@ -231,11 +229,11 @@ static int max8952_pmic_probe(struct i2c_client *client,
 	if (pdata->reg_data->constraints.boot_on)
 		config.ena_gpio_flags |= GPIOF_OUT_INIT_HIGH;
 
-	max8952->rdev = regulator_register(&regulator, &config);
+	rdev = devm_regulator_register(&client->dev, &regulator, &config);
 
-	if (IS_ERR(max8952->rdev)) {
-		ret = PTR_ERR(max8952->rdev);
-		dev_err(max8952->dev, "regulator init failed (%d)\n", ret);
+	if (IS_ERR(rdev)) {
+		ret = PTR_ERR(rdev);
+		dev_err(&client->dev, "regulator init failed (%d)\n", ret);
 		return ret;
 	}
 
@@ -263,7 +261,7 @@ static int max8952_pmic_probe(struct i2c_client *client,
 		err = 3;
 
 	if (err) {
-		dev_warn(max8952->dev, "VID0/1 gpio invalid: "
+		dev_warn(&client->dev, "VID0/1 gpio invalid: "
 				"DVS not available.\n");
 		max8952->vid0 = 0;
 		max8952->vid1 = 0;
@@ -274,7 +272,7 @@ static int max8952_pmic_probe(struct i2c_client *client,
 		/* Disable Pulldown of EN only */
 		max8952_write_reg(max8952, MAX8952_REG_CONTROL, 0x60);
 
-		dev_err(max8952->dev, "DVS modes disabled because VID0 and VID1"
+		dev_err(&client->dev, "DVS modes disabled because VID0 and VID1"
 				" do not have proper controls.\n");
 	} else {
 		/*
@@ -321,9 +319,6 @@ static int max8952_pmic_remove(struct i2c_client *client)
 {
 	struct max8952_data *max8952 = i2c_get_clientdata(client);
 	struct max8952_platform_data *pdata = max8952->pdata;
-	struct regulator_dev *rdev = max8952->rdev;
-
-	regulator_unregister(rdev);
 
 	gpio_free(pdata->gpio_vid0);
 	gpio_free(pdata->gpio_vid1);
-- 
1.7.9.5

