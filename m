Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752115AbaDPCQ5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Apr 2014 22:16:57 -0400
Received: from mail-pa0-f41.google.com ([209.85.220.41]:47287 "EHLO
	mail-pa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750983AbaDPCQy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Apr 2014 22:16:54 -0400
From: Guenter Roeck <linux@roeck-us.net>
To: Florian Fainelli <f.fainelli@gmail.com>
Cc: Chris Healy <chealy@imsco-us.com>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, Guenter Roeck <linux@roeck-us.net>
Subject: [PATCH 1/3] net: mdio-gpio: Use devm_ functions where possible
Date: Tue, 15 Apr 2014 19:16:40 -0700
Message-Id: <1397614602-29694-2-git-send-email-linux@roeck-us.net>
X-Mailer: git-send-email 1.7.9.7
In-Reply-To: <1397614602-29694-1-git-send-email-linux@roeck-us.net>
References: <1397614602-29694-1-git-send-email-linux@roeck-us.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This simplifies error path and deinit/removal functions.

Signed-off-by: Guenter Roeck <linux@roeck-us.net>
---
 drivers/net/phy/mdio-gpio.c |   19 +++++--------------
 1 file changed, 5 insertions(+), 14 deletions(-)

diff --git a/drivers/net/phy/mdio-gpio.c b/drivers/net/phy/mdio-gpio.c
index e701433..e853066 100644
--- a/drivers/net/phy/mdio-gpio.c
+++ b/drivers/net/phy/mdio-gpio.c
@@ -110,7 +110,7 @@ static struct mii_bus *mdio_gpio_bus_init(struct device *dev,
 	struct mdio_gpio_info *bitbang;
 	int i;
 
-	bitbang = kzalloc(sizeof(*bitbang), GFP_KERNEL);
+	bitbang = devm_kzalloc(dev, sizeof(*bitbang), GFP_KERNEL);
 	if (!bitbang)
 		goto out;
 
@@ -121,7 +121,7 @@ static struct mii_bus *mdio_gpio_bus_init(struct device *dev,
 
 	new_bus = alloc_mdio_bitbang(&bitbang->ctrl);
 	if (!new_bus)
-		goto out_free_bitbang;
+		goto out;
 
 	new_bus->name = "GPIO Bitbanged MDIO",
 
@@ -138,11 +138,11 @@ static struct mii_bus *mdio_gpio_bus_init(struct device *dev,
 
 	snprintf(new_bus->id, MII_BUS_ID_SIZE, "gpio-%x", bus_id);
 
-	if (gpio_request(bitbang->mdc, "mdc"))
+	if (devm_gpio_request(dev, bitbang->mdc, "mdc"))
 		goto out_free_bus;
 
-	if (gpio_request(bitbang->mdio, "mdio"))
-		goto out_free_mdc;
+	if (devm_gpio_request(dev, bitbang->mdio, "mdio"))
+		goto out_free_bus;
 
 	gpio_direction_output(bitbang->mdc, 0);
 
@@ -150,12 +150,8 @@ static struct mii_bus *mdio_gpio_bus_init(struct device *dev,
 
 	return new_bus;
 
-out_free_mdc:
-	gpio_free(bitbang->mdc);
 out_free_bus:
 	free_mdio_bitbang(new_bus);
-out_free_bitbang:
-	kfree(bitbang);
 out:
 	return NULL;
 }
@@ -163,13 +159,8 @@ out:
 static void mdio_gpio_bus_deinit(struct device *dev)
 {
 	struct mii_bus *bus = dev_get_drvdata(dev);
-	struct mdio_gpio_info *bitbang = bus->priv;
 
-	dev_set_drvdata(dev, NULL);
-	gpio_free(bitbang->mdio);
-	gpio_free(bitbang->mdc);
 	free_mdio_bitbang(bus);
-	kfree(bitbang);
 }
 
 static void mdio_gpio_bus_destroy(struct device *dev)
-- 
1.7.9.7

