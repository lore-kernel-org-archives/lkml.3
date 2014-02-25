Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753301AbaBYMWx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Feb 2014 07:22:53 -0500
Received: from mga14.intel.com ([143.182.124.37]:35456 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753151AbaBYMWu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Feb 2014 07:22:50 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,540,1389772800"; 
   d="scan'208";a="481424988"
From: Heikki Krogerus <heikki.krogerus@linux.intel.com>
To: Johannes Berg <johannes@sipsolutions.net>,
        "David S. Miller" <davem@davemloft.net>
Cc: Chen-Yu Tsai <wens@csie.org>, Rhyland Klein <rklein@nvidia.com>,
        Marc Dietrich <marvin24@gmx.de>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Arnd Bergmann <arnd@arndb.de>, Alexandre Courbot <gnurou@gmail.com>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-tegra@vger.kernel.org
Subject: [PATCHv2 3/5] net: rfkill: gpio: remove gpio names
Date: Tue, 25 Feb 2014 14:22:28 +0200
Message-Id: <1393330950-7283-4-git-send-email-heikki.krogerus@linux.intel.com>
X-Mailer: git-send-email 1.9.0.rc3
In-Reply-To: <1393330950-7283-1-git-send-email-heikki.krogerus@linux.intel.com>
References: <1393330950-7283-1-git-send-email-heikki.krogerus@linux.intel.com>
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

