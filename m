Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752695Ab3GSEUJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Jul 2013 00:20:09 -0400
Received: from cdptpa-omtalb.mail.rr.com ([75.180.132.120]:62081 "EHLO
	cdptpa-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750762Ab3GSEUH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Jul 2013 00:20:07 -0400
X-Authority-Analysis: v=2.0 cv=XpZ4yC59 c=1 sm=0 a=5PSfXkOkj72WnCKlALcm0g==:17 a=TdnGSLw78-UA:10 a=wom5GMh1gUkA:10 a=JAC9rv6GoXkA:10 a=zz6odIEfzeQA:10 a=kj9zAlcOel0A:10 a=7kYe3NcsAAAA:8 a=KGjhK52YXX0A:10 a=0hxCC45AfUoA:10 a=GmbTdPaSZtpEZQ5Ku5gA:9 a=CjuIK1q_8ugA:10 a=-XA83Ip703gA:10 a=5PSfXkOkj72WnCKlALcm0g==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 67.246.44.123
Date: Fri, 19 Jul 2013 00:19:58 -0400
From: "Daniel M. Weeks" <dan@danweeks.net>
To: Grant Likely <grant.likely@linaro.org>,
        Linus Walleij <linus.walleij@linaro.org>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] gpio-mcp23s08: i2c: auto-select base if no DT match or
 platform data
Message-ID: <20130719041952.GA29001@dev.danweeks.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The call to gpiochip_add made by this driver is capable of auto-selecting a
base if one is not provided. However, it was not called unless there was
already a DT entry or platform data. This patch calls it even if the base is
not already known so that gpiochip_add can attempt to find a usable base.

Signed-off-by: Daniel M. Weeks <dan@danweeks.net>
---
 drivers/gpio/gpio-mcp23s08.c | 9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

diff --git a/drivers/gpio/gpio-mcp23s08.c b/drivers/gpio/gpio-mcp23s08.c
index 6a4470b..87ed6bf 100644
--- a/drivers/gpio/gpio-mcp23s08.c
+++ b/drivers/gpio/gpio-mcp23s08.c
@@ -520,14 +520,13 @@ static int mcp230xx_probe(struct i2c_client *client,
 
 	match = of_match_device(of_match_ptr(mcp23s08_i2c_of_match),
 					&client->dev);
-	if (match) {
+	pdata = client->dev.platform_data;
+	if (match || !pdata) {
 		base = -1;
 		pullups = 0;
 	} else {
-		pdata = client->dev.platform_data;
-		if (!pdata || !gpio_is_valid(pdata->base)) {
-			dev_dbg(&client->dev,
-					"invalid or missing platform data\n");
+		if (!gpio_is_valid(pdata->base)) {
+			dev_dbg(&client->dev, "invalid platform data\n");
 			return -EINVAL;
 		}
 		base = pdata->base;
-- 
Daniel M. Weeks
