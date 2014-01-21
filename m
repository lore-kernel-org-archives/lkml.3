Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755174AbaAUQs7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jan 2014 11:48:59 -0500
Received: from sauhun.de ([89.238.76.85]:35239 "EHLO pokefinder.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754713AbaAUQs5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jan 2014 11:48:57 -0500
From: Wolfram Sang <wsa@the-dreams.de>
To: linux-i2c@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        Wolfram Sang <wsa@the-dreams.de>
Subject: [PATCH] i2c: rely on driver core when sanitizing devices
Date: Tue, 21 Jan 2014 17:48:34 +0100
Message-Id: <1390322914-14191-1-git-send-email-wsa@the-dreams.de>
X-Mailer: git-send-email 1.8.5.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit 0998d0631001 (device-core: Ensure drvdata = NULL when no driver
is bound) modified the driver core to always clear .driver and .drvdata
on remove or probe error. No need for the I2C core to do it.

Reported-by: Linus Torvalds <torvalds@linux-foundation.org>
Reported-by: Mika Westerberg <mika.westerberg@linux.intel.com>
Signed-off-by: Wolfram Sang <wsa@the-dreams.de>
---
 drivers/i2c/i2c-core.c | 13 ++++---------
 1 file changed, 4 insertions(+), 9 deletions(-)

diff --git a/drivers/i2c/i2c-core.c b/drivers/i2c/i2c-core.c
index d74c0b3..dd3a4db 100644
--- a/drivers/i2c/i2c-core.c
+++ b/drivers/i2c/i2c-core.c
@@ -256,10 +256,9 @@ static int i2c_device_probe(struct device *dev)
 
 	acpi_dev_pm_attach(&client->dev, true);
 	status = driver->probe(client, i2c_match_id(driver->id_table, client));
-	if (status) {
-		i2c_set_clientdata(client, NULL);
+	if (status)
 		acpi_dev_pm_detach(&client->dev, true);
-	}
+
 	return status;
 }
 
@@ -267,7 +266,7 @@ static int i2c_device_remove(struct device *dev)
 {
 	struct i2c_client	*client = i2c_verify_client(dev);
 	struct i2c_driver	*driver;
-	int			status;
+	int status = 0;
 
 	if (!client || !dev->driver)
 		return 0;
@@ -276,12 +275,8 @@ static int i2c_device_remove(struct device *dev)
 	if (driver->remove) {
 		dev_dbg(dev, "remove\n");
 		status = driver->remove(client);
-	} else {
-		dev->driver = NULL;
-		status = 0;
 	}
-	if (status == 0)
-		i2c_set_clientdata(client, NULL);
+
 	acpi_dev_pm_detach(&client->dev, true);
 	return status;
 }
-- 
1.8.5.1

