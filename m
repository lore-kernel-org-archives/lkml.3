Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753254AbaCJJhe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Mar 2014 05:37:34 -0400
Received: from mailout4.w1.samsung.com ([210.118.77.14]:21269 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752204AbaCJJhb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Mar 2014 05:37:31 -0400
X-AuditID: cbfec7f5-b7fc96d000004885-ee-531d87d8008d
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
To: Liam Girdwood <lgirdwood@gmail.com>, Mark Brown <broonie@kernel.org>,
        linux-kernel@vger.kernel.org
Cc: Krzysztof Kozlowski <k.kozlowski@samsung.com>
Subject: [PATCH] regulator: max8660: Remove regulator_dev pointer from state
 container
Date: Mon, 10 Mar 2014 10:37:19 +0100
Message-id: <1394444239-6425-1-git-send-email-k.kozlowski@samsung.com>
X-Mailer: git-send-email 1.7.9.5
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrKJMWRmVeSWpSXmKPExsVy+t/xK7o32mWDDZonaFtMffiEzeL1C0OL
	b1c6mCwu75rD5sDisXPWXXaPTas62Tz6tqxi9Pi8SS6AJYrLJiU1J7MstUjfLoErY+PqV4wF
	R4Qqpj+7yNLA+Juvi5GTQ0LAROLT2a+sELaYxIV769lAbCGBpYwSE5+yQNh9TBILvpWC2GwC
	xhKbly8BqxERyJDYPG8qWC+zgKHEz3d/2LsYOTiEBSIkLndzgIRZBFQljp66wAxi8wq4SRxb
	v4UZpERCQEFiziSbCYzcCxgZVjGKppYmFxQnpeca6RUn5haX5qXrJefnbmKEeP3rDsalx6wO
	MQpwMCrx8B54KxMsxJpYVlyZe4hRgoNZSYT3YatssBBvSmJlVWpRfnxRaU5q8SFGJg5OqQbG
	Gc8Y3s84+m+7qL97hMndLttGk6iFP862B9+6frHNtSf7yHKuafwcTstKXvrcOPVd8L4o83zV
	+nfPTk1RVmtQv5dS9ae/QKCLucl1q6buVcNPrVwX75wtzKgvmuuVOfX2S+5rj/ROPTvaobBg
	veMFZaHwsxyWVnIBm2Mb13NryVxbNCl00S1RJZbijERDLeai4kQATbZzwNgBAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Don't store pointer to regulator_dev returned by
devm_regulator_register() in state container. It isn't used anywhere
outside of max8660_probe() function.

Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
---
 drivers/regulator/max8660.c |   16 ++++++----------
 1 file changed, 6 insertions(+), 10 deletions(-)

diff --git a/drivers/regulator/max8660.c b/drivers/regulator/max8660.c
index 8d94d3d7f97f..36fb1060cd7b 100644
--- a/drivers/regulator/max8660.c
+++ b/drivers/regulator/max8660.c
@@ -81,7 +81,6 @@ enum {
 struct max8660 {
 	struct i2c_client *client;
 	u8 shadow_regs[MAX8660_N_REGS];		/* as chip is write only */
-	struct regulator_dev *rdev[];
 };
 
 static int max8660_write(struct max8660 *max8660, u8 reg, u8 mask, u8 val)
@@ -373,7 +372,6 @@ static inline int max8660_pdata_from_dt(struct device *dev,
 static int max8660_probe(struct i2c_client *client,
 				   const struct i2c_device_id *i2c_id)
 {
-	struct regulator_dev **rdev;
 	struct device *dev = &client->dev;
 	struct max8660_platform_data *pdata = dev_get_platdata(dev);
 	struct regulator_config config = { };
@@ -406,14 +404,11 @@ static int max8660_probe(struct i2c_client *client,
 		return -EINVAL;
 	}
 
-	max8660 = devm_kzalloc(dev, sizeof(struct max8660) +
-			sizeof(struct regulator_dev *) * MAX8660_V_END,
-			GFP_KERNEL);
+	max8660 = devm_kzalloc(dev, sizeof(struct max8660), GFP_KERNEL);
 	if (!max8660)
 		return -ENOMEM;
 
 	max8660->client = client;
-	rdev = max8660->rdev;
 
 	if (pdata->en34_is_high) {
 		/* Simulate always on */
@@ -481,6 +476,7 @@ static int max8660_probe(struct i2c_client *client,
 
 	/* Finally register devices */
 	for (i = 0; i < pdata->num_subdevs; i++) {
+		struct regulator_dev *rdev;
 
 		id = pdata->subdevs[i].id;
 
@@ -489,13 +485,13 @@ static int max8660_probe(struct i2c_client *client,
 		config.of_node = of_node[i];
 		config.driver_data = max8660;
 
-		rdev[i] = devm_regulator_register(&client->dev,
+		rdev = devm_regulator_register(&client->dev,
 						  &max8660_reg[id], &config);
-		if (IS_ERR(rdev[i])) {
-			ret = PTR_ERR(rdev[i]);
+		if (IS_ERR(rdev)) {
+			ret = PTR_ERR(rdev);
 			dev_err(&client->dev, "failed to register %s\n",
 				max8660_reg[id].name);
-			return PTR_ERR(rdev[i]);
+			return PTR_ERR(rdev);
 		}
 	}
 
-- 
1.7.9.5

