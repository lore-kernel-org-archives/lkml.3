Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752569Ab3CREe5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Mar 2013 00:34:57 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:33705 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752290Ab3CREbN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Mar 2013 00:31:13 -0400
Message-Id: <20130318042146.676612230@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Mon, 18 Mar 2013 04:22:08 +0000
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: akpm@linux-foundation.org,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Guenter Roeck <linux@roeck-us.net>
Subject: [ 24/82] hwmon: (sht15) Check return value of regulator_enable()
In-Reply-To: <20130318042144.234468645@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:d98f:da4e:f620:7bea
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mark Brown <broonie@opensource.wolfsonmicro.com>

commit 3e78080f81481aa8340374d5a37ae033c1cf4272 upstream.

Not having power is a pretty serious error so check that we are able to
enable the supply and error out if we can't.

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
[bwh: Backported to 3.2: driver does not use the devm API to manage
 memory, so goto err_free_data rather than returning on error]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/hwmon/sht15.c |    8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

--- a/drivers/hwmon/sht15.c
+++ b/drivers/hwmon/sht15.c
@@ -926,7 +926,13 @@ static int __devinit sht15_probe(struct
 		if (voltage)
 			data->supply_uV = voltage;
 
-		regulator_enable(data->reg);
+		ret = regulator_enable(data->reg);
+		if (ret != 0) {
+			dev_err(&pdev->dev,
+				"failed to enable regulator: %d\n", ret);
+			goto err_free_data;
+		}
+
 		/*
 		 * Setup a notifier block to update this if another device
 		 * causes the voltage to change


