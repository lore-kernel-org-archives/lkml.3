Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932343AbaE3M13 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 May 2014 08:27:29 -0400
Received: from mail-ie0-f177.google.com ([209.85.223.177]:34033 "EHLO
	mail-ie0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754555AbaE3M0w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 May 2014 08:26:52 -0400
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        wsa@the-dreams.de
Cc: grant.likely@linaro.org, linus.walleij@linaro.org,
        linux-i2c@vger.kernel.org, Lee Jones <lee.jones@linaro.org>
Subject: [PATCH] i2c: Make I2C ID tables non-mandatory for DT'ed and/or ACPI'ed devices
Date: Fri, 30 May 2014 13:26:37 +0100
Message-Id: <1401452797-29521-3-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1401452797-29521-1-git-send-email-lee.jones@linaro.org>
References: <1401452797-29521-1-git-send-email-lee.jones@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently the I2C framework insists on devices supplying an I2C ID
table.  Many of the devices which do so unnecessarily adding quite a
few wasted lines to kernel code.  This patch allows drivers a means
to 'not' supply the aforementioned table and match on either DT
and/or ACPI match tables instead.

Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 drivers/i2c/i2c-core.c | 20 ++++++++++++++++++--
 1 file changed, 18 insertions(+), 2 deletions(-)

diff --git a/drivers/i2c/i2c-core.c b/drivers/i2c/i2c-core.c
index 7c7f4b8..49c534d 100644
--- a/drivers/i2c/i2c-core.c
+++ b/drivers/i2c/i2c-core.c
@@ -260,13 +260,29 @@ static int i2c_device_probe(struct device *dev)
 {
 	struct i2c_client	*client = i2c_verify_client(dev);
 	struct i2c_driver	*driver;
+	const struct of_device_id *of_match	= dev->driver->of_match_table;
+	const struct acpi_device_id *acpi_match	= dev->driver->acpi_match_table;
+	const struct i2c_device_id *id;
 	int status;
 
 	if (!client)
 		return 0;
 
 	driver = to_i2c_driver(dev->driver);
-	if (!driver->probe || !driver->id_table)
+	if (!driver->probe)
+		return -EINVAL;
+
+	/*
+	 * An I2C ID table is not madatory, if and only if, a suitable Device
+	 * Tree and/or ACPI match table entry is supplied for the probing
+	 * device.
+	 */
+	if (driver->id_table)
+		id = i2c_match_id(driver->id_table, client);
+	else if (of_match_device(of_match, dev) ||
+		 acpi_match_device(acpi_match, dev))
+		id = NULL;
+	else
 		return -ENODEV;
 
 	if (!device_can_wakeup(&client->dev))
@@ -275,7 +291,7 @@ static int i2c_device_probe(struct device *dev)
 	dev_dbg(dev, "probe\n");
 
 	acpi_dev_pm_attach(&client->dev, true);
-	status = driver->probe(client, i2c_match_id(driver->id_table, client));
+	status = driver->probe(client, id);
 	if (status)
 		acpi_dev_pm_detach(&client->dev, true);
 
-- 
1.8.3.2

