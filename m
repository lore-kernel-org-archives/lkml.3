Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753377AbaCaMIp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Mar 2014 08:08:45 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:45794 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752533AbaCaMIh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Mar 2014 08:08:37 -0400
From: Charles Keepax <ckeepax@opensource.wolfsonmicro.com>
To: broonie@kernel.org
Cc: lee.jones@linaro.org, robh+dt@kernel.org, pawel.moll@arm.com,
        mark.rutland@arm.com, ijc+devicetree@hellion.org.uk,
        galak@codeaurora.org, rob@landley.net, sameo@linux.intel.com,
        lgirdwood@gmail.com, ckeepax@opensource.wolfsonmicro.com,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 1/6] mfd: arizona: Factor out read of device tree GPIOs
Date: Mon, 31 Mar 2014 12:59:42 +0100
Message-Id: <1396267187-30580-2-git-send-email-ckeepax@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.7.2.5
In-Reply-To: <1396267187-30580-1-git-send-email-ckeepax@opensource.wolfsonmicro.com>
References: <1396267187-30580-1-git-send-email-ckeepax@opensource.wolfsonmicro.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch factors out the reading of GPIOs for the Arizona devices
into a helper function.

Signed-off-by: Charles Keepax <ckeepax@opensource.wolfsonmicro.com>
---
 drivers/mfd/arizona-core.c       |   33 ++++++++++++++++++++++++---------
 include/linux/mfd/arizona/core.h |    3 +++
 2 files changed, 27 insertions(+), 9 deletions(-)

diff --git a/drivers/mfd/arizona-core.c b/drivers/mfd/arizona-core.c
index a45aab9..8ad4373 100644
--- a/drivers/mfd/arizona-core.c
+++ b/drivers/mfd/arizona-core.c
@@ -512,19 +512,34 @@ int arizona_of_get_type(struct device *dev)
 }
 EXPORT_SYMBOL_GPL(arizona_of_get_type);
 
+int arizona_of_get_named_gpio(struct arizona *arizona, const char *prop,
+			      bool mandatory, int *gpio)
+{
+	int ret;
+
+	ret = of_get_named_gpio(arizona->dev->of_node, prop, 0);
+	*gpio = ret;
+	if (ret >= 0)
+		return ret;
+
+	*gpio = 0;
+
+	if (mandatory)
+		dev_err(arizona->dev,
+			"Mandatory DT gpio %s missing/malformed: %d\n",
+			prop, ret);
+
+	return ret;
+}
+EXPORT_SYMBOL_GPL(arizona_of_get_named_gpio);
+
 static int arizona_of_get_core_pdata(struct arizona *arizona)
 {
+	struct arizona_pdata *pdata = &arizona->pdata;
 	int ret, i;
 
-	arizona->pdata.reset = of_get_named_gpio(arizona->dev->of_node,
-						 "wlf,reset", 0);
-	if (arizona->pdata.reset < 0)
-		arizona->pdata.reset = 0;
-
-	arizona->pdata.ldoena = of_get_named_gpio(arizona->dev->of_node,
-						  "wlf,ldoena", 0);
-	if (arizona->pdata.ldoena < 0)
-		arizona->pdata.ldoena = 0;
+	arizona_of_get_named_gpio(arizona, "wlf,reset", true, &pdata->reset);
+	arizona_of_get_named_gpio(arizona, "wlf,ldoena", true, &pdata->ldoena);
 
 	ret = of_property_read_u32_array(arizona->dev->of_node,
 					 "wlf,gpio-defaults",
diff --git a/include/linux/mfd/arizona/core.h b/include/linux/mfd/arizona/core.h
index 5cf8b91..16150cc 100644
--- a/include/linux/mfd/arizona/core.h
+++ b/include/linux/mfd/arizona/core.h
@@ -124,4 +124,7 @@ int wm5102_patch(struct arizona *arizona);
 int wm5110_patch(struct arizona *arizona);
 int wm8997_patch(struct arizona *arizona);
 
+extern int arizona_of_get_named_gpio(struct arizona *arizona, const char *prop,
+				     bool mandatory, int *gpio);
+
 #endif
-- 
1.7.2.5

