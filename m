Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754308AbaBTMvv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Feb 2014 07:51:51 -0500
Received: from mga09.intel.com ([134.134.136.24]:1716 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754184AbaBTMvs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Feb 2014 07:51:48 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,512,1389772800"; 
   d="scan'208";a="486547625"
From: Heikki Krogerus <heikki.krogerus@linux.intel.com>
To: Johannes Berg <johannes@sipsolutions.net>,
        "David S. Miller" <davem@davemloft.net>
Cc: Chen-Yu Tsai <wens@csie.org>, Rhyland Klein <rklein@nvidia.com>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        Linus Walleij <linus.walleij@linaro.org>,
        Alexandre Courbot <gnurou@gmail.com>
Subject: [PATCH 2/4] net: rfkill: gpio: remove gpio names
Date: Thu, 20 Feb 2014 14:51:35 +0200
Message-Id: <1392900697-27577-3-git-send-email-heikki.krogerus@linux.intel.com>
X-Mailer: git-send-email 1.9.0.rc3
In-Reply-To: <1392900697-27577-1-git-send-email-heikki.krogerus@linux.intel.com>
References: <1392900697-27577-1-git-send-email-heikki.krogerus@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There is no use for them in this driver. This will fix a
static checker warning..

net/rfkill/rfkill-gpio.c:144 rfkill_gpio_probe()
	warn: variable dereferenced before check 'rfkill->name'

This will also make sure that when DT support is added,
"gpios" property can be used as no con_id labels are
provided.

Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Heikki Krogerus <heikki.krogerus@linux.intel.com>
---
 net/rfkill/rfkill-gpio.c | 19 ++-----------------
 1 file changed, 2 insertions(+), 17 deletions(-)

diff --git a/net/rfkill/rfkill-gpio.c b/net/rfkill/rfkill-gpio.c
index 0adda44..ad5e354 100644
--- a/net/rfkill/rfkill-gpio.c
+++ b/net/rfkill/rfkill-gpio.c
@@ -36,8 +36,6 @@ struct rfkill_gpio_data {
 	struct gpio_desc	*shutdown_gpio;
 
 	struct rfkill		*rfkill_dev;
-	char			*reset_name;
-	char			*shutdown_name;
 	struct clk		*clk;
 
 	bool			clk_enabled;
@@ -89,7 +87,6 @@ static int rfkill_gpio_probe(struct platform_device *pdev)
 	struct rfkill_gpio_data *rfkill;
 	struct gpio_desc *gpio;
 	int ret;
-	int len;
 
 	rfkill = devm_kzalloc(&pdev->dev, sizeof(*rfkill), GFP_KERNEL);
 	if (!rfkill)
@@ -106,21 +103,9 @@ static int rfkill_gpio_probe(struct platform_device *pdev)
 		return -ENODEV;
 	}
 
-	len = strlen(rfkill->name);
-	rfkill->reset_name = devm_kzalloc(&pdev->dev, len + 7, GFP_KERNEL);
-	if (!rfkill->reset_name)
-		return -ENOMEM;
-
-	rfkill->shutdown_name = devm_kzalloc(&pdev->dev, len + 10, GFP_KERNEL);
-	if (!rfkill->shutdown_name)
-		return -ENOMEM;
-
-	snprintf(rfkill->reset_name, len + 6 , "%s_reset", rfkill->name);
-	snprintf(rfkill->shutdown_name, len + 9, "%s_shutdown", rfkill->name);
-
 	rfkill->clk = devm_clk_get(&pdev->dev, NULL);
 
-	gpio = devm_gpiod_get_index(&pdev->dev, rfkill->reset_name, 0);
+	gpio = devm_gpiod_get_index(&pdev->dev, NULL, 0);
 	if (!IS_ERR(gpio)) {
 		ret = gpiod_direction_output(gpio, 0);
 		if (ret)
@@ -128,7 +113,7 @@ static int rfkill_gpio_probe(struct platform_device *pdev)
 		rfkill->reset_gpio = gpio;
 	}
 
-	gpio = devm_gpiod_get_index(&pdev->dev, rfkill->shutdown_name, 1);
+	gpio = devm_gpiod_get_index(&pdev->dev, NULL, 1);
 	if (!IS_ERR(gpio)) {
 		ret = gpiod_direction_output(gpio, 0);
 		if (ret)
-- 
1.9.0.rc3

