Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752030AbaDYPzt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Apr 2014 11:55:49 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:33827 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751125AbaDYPzs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Apr 2014 11:55:48 -0400
From: Charles Keepax <ckeepax@opensource.wolfsonmicro.com>
To: broonie@kernel.org
Cc: lgirdwood@gmail.com, linux-kernel@vger.kernel.org,
        patches@opensource.wolfsonmicro.com,
        Charles Keepax <ckeepax@opensource.wolfsonmicro.com>
Subject: [PATCH 1/2] regulator: arizona-micsupp: Fix build errors with CONFIG_OF not defined
Date: Fri, 25 Apr 2014 16:55:40 +0100
Message-Id: <1398441341-19436-1-git-send-email-ckeepax@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Some of the OF handling functions do not have empty alternatives defined
if CONFIG_OF is not defined. This patch ifdefs out the offending code.

Reported-by: Randy Dunlap <rdunlap@infradead.org>
Signed-off-by: Charles Keepax <ckeepax@opensource.wolfsonmicro.com>
---
 drivers/regulator/arizona-micsupp.c |   20 +++++++++++++++++++-
 1 file changed, 19 insertions(+), 1 deletion(-)

diff --git a/drivers/regulator/arizona-micsupp.c b/drivers/regulator/arizona-micsupp.c
index b80ebbe..19d0b2c 100644
--- a/drivers/regulator/arizona-micsupp.c
+++ b/drivers/regulator/arizona-micsupp.c
@@ -196,6 +196,7 @@ static const struct regulator_init_data arizona_micsupp_ext_default = {
 	.num_consumer_supplies = 1,
 };
 
+#if IS_ENABLED(CONFIG_OF)
 static int arizona_micsupp_of_get_pdata(struct arizona *arizona,
 					struct regulator_config *config)
 {
@@ -222,6 +223,22 @@ static int arizona_micsupp_of_get_pdata(struct arizona *arizona,
 	return 0;
 }
 
+static void arizona_micsupp_of_put_pdata(struct regulator_config *config)
+{
+	of_node_put(config->of_node);
+}
+#else
+static int arizona_micsupp_of_get_pdata(struct arizona *arizona,
+					struct regulator_config *config)
+{
+	return 0;
+}
+
+static void arizona_micsupp_of_put_pdata(struct regulator_config *config)
+{
+}
+#endif
+
 static int arizona_micsupp_probe(struct platform_device *pdev)
 {
 	struct arizona *arizona = dev_get_drvdata(pdev->dev.parent);
@@ -288,7 +305,8 @@ static int arizona_micsupp_probe(struct platform_device *pdev)
 		return ret;
 	}
 
-	of_node_put(config.of_node);
+	if (IS_ENABLED(CONFIG_OF))
+		arizona_micsupp_of_put_pdata(&config);
 
 	platform_set_drvdata(pdev, micsupp);
 
-- 
1.7.9.5

