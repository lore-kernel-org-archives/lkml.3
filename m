Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965015AbaLLIGt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Dec 2014 03:06:49 -0500
Received: from comal.ext.ti.com ([198.47.26.152]:44541 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750757AbaLLIGr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Dec 2014 03:06:47 -0500
From: Kishon Vijay Abraham I <kishon@ti.com>
To: <linus.walleij@linaro.org>, <gnurou@gmail.com>,
        <linux-gpio@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <nsekhar@ti.com>
CC: <kishon@ti.com>, <linux-omap@vger.kernel.org>, <linux-mmc@vger.kernel.org>
Subject: [PATCH] gpio: pcf857x: restore the initial line state of all pcf lines
Date: Fri, 12 Dec 2014 13:36:41 +0530
Message-ID: <1418371601-22658-1-git-send-email-kishon@ti.com>
X-Mailer: git-send-email 1.7.9.5
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The reset values for all the PCF lines are high and hence on shutdown
we should drive all the lines high in order to bring it to the reset state.

This is actually required since pcf doesn't have a reset line and even after
warm reset (by invoking "reboot" in prompt) the pcf lines maintains it's
previous programmed state. This becomes a problem if the boards are designed
to work with the default initial state.

DRA7XX_evm uses PCF8575 and one of the PCF output lines feeds to MMC/SD and
this line should be driven high in order for the MMC/SD to be detected.
This line is modelled as regulator and the hsmmc driver takes care of enabling
and disabling it. In the case of 'reboot', during shutdown path as part of it's
cleanup process the hsmmc driver disables this regulator. This makes MMC boot
not functional.

Fixed it by driving high all the pcf lines.

Signed-off-by: Kishon Vijay Abraham I <kishon@ti.com>
---
 drivers/gpio/gpio-pcf857x.c |    9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/drivers/gpio/gpio-pcf857x.c b/drivers/gpio/gpio-pcf857x.c
index 236708a..00b15b2 100644
--- a/drivers/gpio/gpio-pcf857x.c
+++ b/drivers/gpio/gpio-pcf857x.c
@@ -448,6 +448,14 @@ static int pcf857x_remove(struct i2c_client *client)
 	return status;
 }
 
+static void pcf857x_shutdown(struct i2c_client *client)
+{
+	struct pcf857x *gpio = i2c_get_clientdata(client);
+
+	/* Drive all the I/O lines high */
+	gpio->write(gpio->client, BIT(gpio->chip.ngpio) - 1);
+}
+
 static struct i2c_driver pcf857x_driver = {
 	.driver = {
 		.name	= "pcf857x",
@@ -456,6 +464,7 @@ static struct i2c_driver pcf857x_driver = {
 	},
 	.probe	= pcf857x_probe,
 	.remove	= pcf857x_remove,
+	.shutdown = pcf857x_shutdown,
 	.id_table = pcf857x_id,
 };
 
-- 
1.7.9.5

