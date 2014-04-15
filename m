Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751037AbaDOHWO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Apr 2014 03:22:14 -0400
Received: from mirror2.csie.ntu.edu.tw ([140.112.30.76]:36232 "EHLO
	mirror2.csie.ntu.edu.tw" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750865AbaDOHWM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Apr 2014 03:22:12 -0400
X-Greylist: delayed 2393 seconds by postgrey-1.27 at vger.kernel.org; Tue, 15 Apr 2014 03:22:12 EDT
From: Chen-Yu Tsai <wens@csie.org>
To: Linus Walleij <linus.walleij@linaro.org>,
        Johannes Berg <johannes@sipsolutions.net>,
        "John W. Linville" <linville@tuxdriver.com>,
        Maxime Ripard <maxime.ripard@free-electrons.com>
Cc: Chen-Yu Tsai <wens@csie.org>, Arnd Bergmann <arnd@arndb.de>,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        Alexandre Courbot <gnurou@gmail.com>,
        Stephen Warren <swarren@wwwdotorg.org>, linux-gpio@vger.kernel.org,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-sunxi@googlegroups.com
Subject: [PATCH 2/7] gpiolib: Support purely name based gpiod lookup in device trees
Date: Tue, 15 Apr 2014 14:41:36 +0800
Message-Id: <1397544101-18135-3-git-send-email-wens@csie.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1397544101-18135-1-git-send-email-wens@csie.org>
References: <1397544101-18135-1-git-send-email-wens@csie.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch enables gpio-names based gpiod lookup in device tree usage,
which ignores the index passed to gpiod_get_index. If this fails, fall
back to the original function-index ("con_id"-gpios) based lookup scheme,
for backward compatibility and any drivers needing more than one GPIO
for any function.

Signed-off-by: Chen-Yu Tsai <wens@csie.org>
---
 drivers/gpio/gpiolib.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/drivers/gpio/gpiolib.c b/drivers/gpio/gpiolib.c
index 761013f..956f01e 100644
--- a/drivers/gpio/gpiolib.c
+++ b/drivers/gpio/gpiolib.c
@@ -2585,8 +2585,13 @@ static struct gpio_desc *of_find_gpio(struct device *dev, const char *con_id,
 	else
 		snprintf(prop_name, 32, "gpios");
 
-	desc = of_get_named_gpiod_flags(dev->of_node, prop_name, idx,
-					&of_flags);
+	/* try gpio-names based lookup first */
+	desc = of_get_gpiod_flags_by_name(dev->of_node, con_id, &of_flags);
+
+	/* fallback to function based lookup */
+	if (IS_ERR(desc))
+		desc = of_get_named_gpiod_flags(dev->of_node, prop_name, idx,
+				&of_flags);
 
 	if (IS_ERR(desc))
 		return desc;
-- 
1.9.1

