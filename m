Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752854AbaFDLgo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jun 2014 07:36:44 -0400
Received: from mail.dev.rtsoft.ru ([213.79.90.226]:58914 "EHLO dev.rtsoft.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752788AbaFDLgL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jun 2014 07:36:11 -0400
From: nyushchenko@dev.rtsoft.ru
To: Grant Likely <grant.likely@linaro.org>, Rob Herring <robh+dt@kernel.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Thomas Gleixner <tglx@linutronix.de>, devicetree@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, lugovskoy@dev.rtsoft.ru,
        Nikita Yushchenko <nyushchenko@dev.rtsoft.ru>
Subject: [PATCH 07/21] gpio: use devm_irq_of_parse_and_map() where appropriate
Date: Wed,  4 Jun 2014 15:13:07 +0400
Message-Id: <1401880402-30091-8-git-send-email-nyushchenko@dev.rtsoft.ru>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1401880402-30091-1-git-send-email-nyushchenko@dev.rtsoft.ru>
References: <1401880402-30091-1-git-send-email-nyushchenko@dev.rtsoft.ru>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Nikita Yushchenko <nyushchenko@dev.rtsoft.ru>

This avoids leak of IRQ mapping on error paths, and makes it possible
to use devm_request_irq() without facing unmap-while-handler-installed
issues.

Signed-off-by: Nikita Yushchenko <nyushchenko@dev.rtsoft.ru>
---
 drivers/gpio/gpio-adnp.c     |    4 ++--
 drivers/gpio/gpio-mcp23s08.c |    5 ++++-
 2 files changed, 6 insertions(+), 3 deletions(-)

diff --git a/drivers/gpio/gpio-adnp.c b/drivers/gpio/gpio-adnp.c
index b2239d6..c10e224 100644
--- a/drivers/gpio/gpio-adnp.c
+++ b/drivers/gpio/gpio-adnp.c
@@ -546,8 +546,8 @@ static int adnp_i2c_probe(struct i2c_client *client,
 	if (err < 0)
 		return err;
 
-	client->irq = irq_of_parse_and_map(np, 0);
-	if (!client->irq)
+	client->irq = devm_irq_of_parse_and_map(&client->dev, np, 0);
+	if (client->irq <= 0)
 		return -EPROBE_DEFER;
 
 	adnp = devm_kzalloc(&client->dev, sizeof(*adnp), GFP_KERNEL);
diff --git a/drivers/gpio/gpio-mcp23s08.c b/drivers/gpio/gpio-mcp23s08.c
index 3d53fd6..b6f4217 100644
--- a/drivers/gpio/gpio-mcp23s08.c
+++ b/drivers/gpio/gpio-mcp23s08.c
@@ -779,7 +779,10 @@ static int mcp230xx_probe(struct i2c_client *client,
 	if (match || !pdata) {
 		base = -1;
 		pullups = 0;
-		client->irq = irq_of_parse_and_map(client->dev.of_node, 0);
+		client->irq = devm_irq_of_parse_and_map(&client->dev,
+				client->dev.of_node, 0);
+		if (client->irq < 0)
+			return client->irq;
 	} else {
 		if (!gpio_is_valid(pdata->base)) {
 			dev_dbg(&client->dev, "invalid platform data\n");
-- 
1.7.10.4

