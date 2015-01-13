Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752615AbbAMNtM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jan 2015 08:49:12 -0500
Received: from exprod5og122.obsmtp.com ([64.18.0.192]:37680 "EHLO
	exprod5og122.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752437AbbAMNtK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jan 2015 08:49:10 -0500
From: Semen Protsenko <semen.protsenko@globallogic.com>
To: Linus Walleij <linus.walleij@linaro.org>,
        Alexandre Courbot <gnurou@gmail.com>
Cc: Grant Likely <grant.likely@linaro.org>,
        Mark Rutland <mark.rutland@arm.com>, linux-gpio@vger.kernel.org,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
        Marc Zyngier <maz@misterjones.org>,
        Grygorii Strashko <grygorii.strashko@globallogic.com>,
        Illia Smyrnov <illia.smyrnov@globallogic.com>
Subject: [PATCH 1/4] gpio: max732x: Add device tree support
Date: Tue, 13 Jan 2015 15:41:42 +0200
Message-Id: <1421156505-16600-2-git-send-email-semen.protsenko@globallogic.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1421156505-16600-1-git-send-email-semen.protsenko@globallogic.com>
References: <1421156505-16600-1-git-send-email-semen.protsenko@globallogic.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Semen Protsenko <semen.protsenko@globallogic.com>
---
 drivers/gpio/gpio-max732x.c |   62 +++++++++++++++++++++++++++++++++++--------
 1 file changed, 51 insertions(+), 11 deletions(-)

diff --git a/drivers/gpio/gpio-max732x.c b/drivers/gpio/gpio-max732x.c
index 6c67622..a642f78 100644
--- a/drivers/gpio/gpio-max732x.c
+++ b/drivers/gpio/gpio-max732x.c
@@ -21,6 +21,7 @@
 #include <linux/irq.h>
 #include <linux/i2c.h>
 #include <linux/i2c/max732x.h>
+#include <linux/of.h>
 
 
 /*
@@ -116,6 +117,22 @@ static const struct i2c_device_id max732x_id[] = {
 };
 MODULE_DEVICE_TABLE(i2c, max732x_id);
 
+#ifdef CONFIG_OF
+static const struct of_device_id max732x_of_table[] = {
+	{ .compatible = "maxim,max7319" },
+	{ .compatible = "maxim,max7320" },
+	{ .compatible = "maxim,max7321" },
+	{ .compatible = "maxim,max7322" },
+	{ .compatible = "maxim,max7323" },
+	{ .compatible = "maxim,max7324" },
+	{ .compatible = "maxim,max7325" },
+	{ .compatible = "maxim,max7326" },
+	{ .compatible = "maxim,max7327" },
+	{ }
+};
+MODULE_DEVICE_TABLE(of, max732x_of_table);
+#endif
+
 struct max732x_chip {
 	struct gpio_chip gpio_chip;
 
@@ -457,10 +474,12 @@ static int max732x_irq_setup(struct max732x_chip *chip,
 	int has_irq = max732x_features[id->driver_data] >> 32;
 	int ret;
 
-	if (pdata->irq_base && has_irq != INT_NONE) {
+	if (((pdata && pdata->irq_base) || client->irq)
+			&& has_irq != INT_NONE) {
 		int lvl;
 
-		chip->irq_base = pdata->irq_base;
+		if (pdata)
+			chip->irq_base = pdata->irq_base;
 		chip->irq_features = has_irq;
 		mutex_init(&chip->irq_lock);
 
@@ -515,7 +534,7 @@ static int max732x_irq_setup(struct max732x_chip *chip,
 	struct max732x_platform_data *pdata = dev_get_platdata(&client->dev);
 	int has_irq = max732x_features[id->driver_data] >> 32;
 
-	if (pdata->irq_base && has_irq != INT_NONE)
+	if (((pdata && pdata->irq_base) || client->irq) && has_irq != INT_NONE)
 		dev_warn(&client->dev, "interrupt support not compiled in\n");
 
 	return 0;
@@ -574,28 +593,47 @@ static int max732x_setup_gpio(struct max732x_chip *chip,
 	return port;
 }
 
+static struct max732x_platform_data *of_gpio_max732x(struct device *dev)
+{
+	struct max732x_platform_data *pdata;
+
+	pdata = devm_kzalloc(dev, sizeof(*pdata), GFP_KERNEL);
+	if (!pdata)
+		return NULL;
+
+	pdata->gpio_base = -1;
+
+	return pdata;
+}
+
 static int max732x_probe(struct i2c_client *client,
 				   const struct i2c_device_id *id)
 {
 	struct max732x_platform_data *pdata;
+	struct device_node *node;
 	struct max732x_chip *chip;
 	struct i2c_client *c;
 	uint16_t addr_a, addr_b;
 	int ret, nr_port;
 
 	pdata = dev_get_platdata(&client->dev);
-	if (pdata == NULL) {
+	node = client->dev.of_node;
+
+	if (!pdata && node)
+		pdata = of_gpio_max732x(&client->dev);
+
+	if (!pdata) {
 		dev_dbg(&client->dev, "no platform data\n");
 		return -EINVAL;
 	}
 
-	chip = devm_kzalloc(&client->dev, sizeof(struct max732x_chip),
-			GFP_KERNEL);
+	chip = devm_kzalloc(&client->dev, sizeof(*chip), GFP_KERNEL);
 	if (chip == NULL)
 		return -ENOMEM;
 	chip->client = client;
 
 	nr_port = max732x_setup_gpio(chip, id, pdata->gpio_base);
+	chip->gpio_chip.dev = &client->dev;
 
 	addr_a = (client->addr & 0x0f) | 0x60;
 	addr_b = (client->addr & 0x0f) | 0x50;
@@ -643,7 +681,7 @@ static int max732x_probe(struct i2c_client *client,
 	if (ret)
 		goto out_failed;
 
-	if (pdata->setup) {
+	if (pdata && pdata->setup) {
 		ret = pdata->setup(client, chip->gpio_chip.base,
 				chip->gpio_chip.ngpio, pdata->context);
 		if (ret < 0)
@@ -664,9 +702,10 @@ static int max732x_remove(struct i2c_client *client)
 {
 	struct max732x_platform_data *pdata = dev_get_platdata(&client->dev);
 	struct max732x_chip *chip = i2c_get_clientdata(client);
-	int ret;
 
-	if (pdata->teardown) {
+	if (pdata && pdata->teardown) {
+		int ret;
+
 		ret = pdata->teardown(client, chip->gpio_chip.base,
 				chip->gpio_chip.ngpio, pdata->context);
 		if (ret < 0) {
@@ -689,8 +728,9 @@ static int max732x_remove(struct i2c_client *client)
 
 static struct i2c_driver max732x_driver = {
 	.driver = {
-		.name	= "max732x",
-		.owner	= THIS_MODULE,
+		.name		= "max732x",
+		.owner		= THIS_MODULE,
+		.of_match_table	= of_match_ptr(max732x_of_table),
 	},
 	.probe		= max732x_probe,
 	.remove		= max732x_remove,
-- 
1.7.9.5

