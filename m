Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753805AbbAELwR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jan 2015 06:52:17 -0500
Received: from mailout1.w1.samsung.com ([210.118.77.11]:42803 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753297AbbAELuv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jan 2015 06:50:51 -0500
X-AuditID: cbfec7f4-b7f126d000001e9a-73-54aa7a98169f
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
To: Liam Girdwood <lgirdwood@gmail.com>, Mark Brown <broonie@kernel.org>,
        linux-kernel@vger.kernel.org, Kukjin Kim <kgene@kernel.org>,
        devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org
Cc: Kyungmin Park <kyungmin.park@samsung.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Krzysztof Kozlowski <k.kozlowski@samsung.com>
Subject: [PATCH v5 1/5] regulator: Copy config passed during registration
Date: Mon, 05 Jan 2015 12:48:41 +0100
Message-id: <1420458525-22576-2-git-send-email-k.kozlowski@samsung.com>
X-Mailer: git-send-email 1.9.1
In-reply-to: <1420458525-22576-1-git-send-email-k.kozlowski@samsung.com>
References: <1420458525-22576-1-git-send-email-k.kozlowski@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmplluLIzCtJLcpLzFFi42I5/e/4Zd0ZVatCDFbPZ7bYOGM9q8XUh0/Y
	LOYfOcdq8fqFoUX/49fMFmeb3rBbfLvSwWSx6fE1VovLu+awWcw4v4/Jgctj56y77B6bVnWy
	eWxeUu/Rt2UVo8fnTXIBrFFcNimpOZllqUX6dglcGX0TrzIW3BGoeLHsEmsD43HeLkZODgkB
	E4lTM5+yQNhiEhfurWfrYuTiEBJYyiixY+dZFginj0ni97z3bCBVbALGEpuXLwGrEhH4wCix
	atIPVhCHWWAao8SFU9+ZQaqEBTwl5l98yw5iswioSvRNuQcW5xVwl/i4bTcbxD45iZPHJrOC
	2JwCHhJdTz+B1QgB1Uzb2cw8gZF3ASPDKkbR1NLkguKk9FxDveLE3OLSvHS95PzcTYyQoPuy
	g3HxMatDjAIcjEo8vB4nVoYIsSaWFVfmHmKU4GBWEuF9lb4qRIg3JbGyKrUoP76oNCe1+BAj
	EwenVAOjj9U6t73c8yo9lu6/o61Q0P5nQ7rfk1BnR+Vli5+H9Xjsycpw1li56MMEB+OG1WfD
	61OntK6W4kub+mSO7vEuH2Fu2+9p+e+yXCY4TvZxNurWk9w/LTpk+XbFG//E190+p563drbg
	q6SPaR/7PjbIf76zxML8zs/feqX6a95d99j3c1rvA5vLSizFGYmGWsxFxYkAQpfkcRgCAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Copy the 'regulator_config' structure passed to regulator_register()
function so the driver could safely modify it after parsing init data.

The driver may want to change the config as a result of specific init
data parsed by regulator core (e.g. when core handled parsing device
tree).

Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
---
 drivers/regulator/core.c | 18 +++++++++++++++---
 1 file changed, 15 insertions(+), 3 deletions(-)

diff --git a/drivers/regulator/core.c b/drivers/regulator/core.c
index e225711bb8bc..c13b557a560e 100644
--- a/drivers/regulator/core.c
+++ b/drivers/regulator/core.c
@@ -3581,20 +3581,21 @@ static void rdev_init_debugfs(struct regulator_dev *rdev)
  */
 struct regulator_dev *
 regulator_register(const struct regulator_desc *regulator_desc,
-		   const struct regulator_config *config)
+		   const struct regulator_config *cfg)
 {
 	const struct regulation_constraints *constraints = NULL;
 	const struct regulator_init_data *init_data;
+	struct regulator_config *config = NULL;
 	static atomic_t regulator_no = ATOMIC_INIT(0);
 	struct regulator_dev *rdev;
 	struct device *dev;
 	int ret, i;
 	const char *supply = NULL;
 
-	if (regulator_desc == NULL || config == NULL)
+	if (regulator_desc == NULL || cfg == NULL)
 		return ERR_PTR(-EINVAL);
 
-	dev = config->dev;
+	dev = cfg->dev;
 	WARN_ON(!dev);
 
 	if (regulator_desc->name == NULL || regulator_desc->ops == NULL)
@@ -3624,6 +3625,16 @@ regulator_register(const struct regulator_desc *regulator_desc,
 	if (rdev == NULL)
 		return ERR_PTR(-ENOMEM);
 
+	/*
+	 * Duplicate the config so the driver could override it after
+	 * parsing init data.
+	 */
+	config = kmemdup(cfg, sizeof(*cfg), GFP_KERNEL);
+	if (config == NULL) {
+		kfree(rdev);
+		return ERR_PTR(-ENOMEM);
+	}
+
 	init_data = regulator_of_get_init_data(dev, regulator_desc,
 					       &rdev->dev.of_node);
 	if (!init_data) {
@@ -3752,6 +3763,7 @@ add_dev:
 	rdev_init_debugfs(rdev);
 out:
 	mutex_unlock(&regulator_list_mutex);
+	kfree(config);
 	return rdev;
 
 unset_supplies:
-- 
1.9.1

