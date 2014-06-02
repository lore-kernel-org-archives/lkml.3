Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755114AbaFBNlk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jun 2014 09:41:40 -0400
Received: from mail-ie0-f169.google.com ([209.85.223.169]:57359 "EHLO
	mail-ie0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755007AbaFBNl0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jun 2014 09:41:26 -0400
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        wsa@the-dreams.de
Cc: linus.walleij@linaro.org, grant.likely@linaro.org,
        linux-i2c@vger.kernel.org, Lee Jones <lee.jones@linaro.org>
Subject: [PATCH 3/3] i2c: Make I2C ID tables non-mandatory for DT'ed and/or ACPI'ed devices
Date: Mon,  2 Jun 2014 14:41:03 +0100
Message-Id: <1401716463-23457-4-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1401716463-23457-1-git-send-email-lee.jones@linaro.org>
References: <1401716463-23457-1-git-send-email-lee.jones@linaro.org>
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
 drivers/i2c/i2c-core.c | 13 ++++++++++++-
 1 file changed, 12 insertions(+), 1 deletion(-)

diff --git a/drivers/i2c/i2c-core.c b/drivers/i2c/i2c-core.c
index d0c7180..811b78f 100644
--- a/drivers/i2c/i2c-core.c
+++ b/drivers/i2c/i2c-core.c
@@ -271,7 +271,18 @@ static int i2c_device_probe(struct device *dev)
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
+	 *
+	 * TODO: Provide 'device type' to 'ACPI node' call and match here.
+	 */
+	if (!driver->id_table &&
+	    !of_match_device(dev->driver->of_match_table, dev))
 		return -ENODEV;
 
 	if (!device_can_wakeup(&client->dev))
-- 
1.8.3.2

