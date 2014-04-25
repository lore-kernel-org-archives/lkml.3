Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752715AbaDYP5B (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Apr 2014 11:57:01 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:33832 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751666AbaDYPzt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Apr 2014 11:55:49 -0400
From: Charles Keepax <ckeepax@opensource.wolfsonmicro.com>
To: broonie@kernel.org
Cc: lgirdwood@gmail.com, linux-kernel@vger.kernel.org,
        patches@opensource.wolfsonmicro.com,
        Charles Keepax <ckeepax@opensource.wolfsonmicro.com>
Subject: [PATCH 2/2] regulator: arizona-ldo1: Fix build errors for when CONFIG_OF not defined
Date: Fri, 25 Apr 2014 16:55:41 +0100
Message-Id: <1398441341-19436-2-git-send-email-ckeepax@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1398441341-19436-1-git-send-email-ckeepax@opensource.wolfsonmicro.com>
References: <1398441341-19436-1-git-send-email-ckeepax@opensource.wolfsonmicro.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Some of the OF handling functions do not have empty alternatives defined
if CONFIG_OF is not defined. This patch ifdefs out the offending code.

Reported-by: Randy Dunlap <rdunlap@infradead.org>
Signed-off-by: Charles Keepax <ckeepax@opensource.wolfsonmicro.com>
---
 drivers/regulator/arizona-ldo1.c |   20 +++++++++++++++++++-
 1 file changed, 19 insertions(+), 1 deletion(-)

diff --git a/drivers/regulator/arizona-ldo1.c b/drivers/regulator/arizona-ldo1.c
index d3787e1..051db72f 100644
--- a/drivers/regulator/arizona-ldo1.c
+++ b/drivers/regulator/arizona-ldo1.c
@@ -179,6 +179,7 @@ static const struct regulator_init_data arizona_ldo1_default = {
 	.num_consumer_supplies = 1,
 };
 
+#if IS_ENABLED(CONFIG_OF)
 static int arizona_ldo1_of_get_pdata(struct arizona *arizona,
 				     struct regulator_config *config)
 {
@@ -215,6 +216,22 @@ static int arizona_ldo1_of_get_pdata(struct arizona *arizona,
 	return 0;
 }
 
+static void arizona_ldo1_of_put_pdata(struct regulator_config *config)
+{
+	of_node_put(config->of_node);
+}
+#else
+static int arizona_ldo1_of_get_pdata(struct arizona *arizona,
+				     struct regulator_config *config)
+{
+	return 0;
+}
+
+static void arizona_ldo1_of_put_pdata(struct regulator_config *config)
+{
+}
+#endif
+
 static int arizona_ldo1_probe(struct platform_device *pdev)
 {
 	struct arizona *arizona = dev_get_drvdata(pdev->dev.parent);
@@ -286,7 +303,8 @@ static int arizona_ldo1_probe(struct platform_device *pdev)
 		return ret;
 	}
 
-	of_node_put(config.of_node);
+	if (IS_ENABLED(CONFIG_OF))
+		arizona_ldo1_of_put_pdata(&config);
 
 	platform_set_drvdata(pdev, ldo1);
 
-- 
1.7.9.5

