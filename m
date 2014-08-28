Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751650AbaH1Of4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Aug 2014 10:35:56 -0400
Received: from mail-qg0-f50.google.com ([209.85.192.50]:51945 "EHLO
	mail-qg0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751546AbaH1Ofx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Aug 2014 10:35:53 -0400
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: lee.jones@linaro.org, kernel@stlinux.com, wsa@the-dreams.de,
        grant.likely@linaro.org, linux-i2c@vger.kernel.org,
        devicetree@vger.kernel.org, linus.walleij@linaro.org
Subject: [PATCH 1/8] i2c: Add pointer dereference protection to i2c_match_id()
Date: Thu, 28 Aug 2014 15:35:31 +0100
Message-Id: <1409236538-21274-2-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1409236538-21274-1-git-send-email-lee.jones@linaro.org>
References: <1409236538-21274-1-git-send-email-lee.jones@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Here we're providing dereference protection for i2c_match_id(), which
saves us having to do it each time it's called.  We're also stripping
out the (now) needless checks in i2c_device_match().  This patch paves
the way for other, similar code trimming.

Acked-by: Grant Likely <grant.likely@linaro.org>
Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 drivers/i2c/i2c-core.c | 12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

diff --git a/drivers/i2c/i2c-core.c b/drivers/i2c/i2c-core.c
index 632057a..d3c8e9f 100644
--- a/drivers/i2c/i2c-core.c
+++ b/drivers/i2c/i2c-core.c
@@ -83,6 +83,9 @@ void i2c_transfer_trace_unreg(void)
 static const struct i2c_device_id *i2c_match_id(const struct i2c_device_id *id,
 						const struct i2c_client *client)
 {
+	if (!(id && client))
+		return NULL;
+
 	while (id->name[0]) {
 		if (strcmp(client->name, id->name) == 0)
 			return id;
@@ -96,8 +99,6 @@ static int i2c_device_match(struct device *dev, struct device_driver *drv)
 	struct i2c_client	*client = i2c_verify_client(dev);
 	struct i2c_driver	*driver;
 
-	if (!client)
-		return 0;
 
 	/* Attempt an OF style match */
 	if (of_driver_match_device(dev, drv))
@@ -108,9 +109,10 @@ static int i2c_device_match(struct device *dev, struct device_driver *drv)
 		return 1;
 
 	driver = to_i2c_driver(drv);
-	/* match on an id table if there is one */
-	if (driver->id_table)
-		return i2c_match_id(driver->id_table, client) != NULL;
+
+	/* Finally an I2C match */
+	if (i2c_match_id(driver->id_table, client))
+		return 1;
 
 	return 0;
 }
-- 
1.9.1

