Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758026Ab3HBITf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Aug 2013 04:19:35 -0400
Received: from svenfoo.org ([82.94.215.22]:44929 "EHLO mail.zonque.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756131Ab3HBIT3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Aug 2013 04:19:29 -0400
From: Daniel Mack <zonque@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: lgirdwood@gmail.com, broonie@kernel.org, Daniel Mack <zonque@gmail.com>
Subject: [PATCH 1/3] regulators: max8660: use i2c_id->driver_data rather than ->name
Date: Fri,  2 Aug 2013 10:19:15 +0200
Message-Id: <1375431557-3096-1-git-send-email-zonque@gmail.com>
X-Mailer: git-send-email 1.8.3.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Introduce an enum and denote the device type via struct i2c_id's
driver_data field rather than comparing strings.

Signed-off-by: Daniel Mack <zonque@gmail.com>
---
 drivers/regulator/max8660.c | 13 ++++++++++---
 1 file changed, 10 insertions(+), 3 deletions(-)

diff --git a/drivers/regulator/max8660.c b/drivers/regulator/max8660.c
index d428ef9..ba3b8af 100644
--- a/drivers/regulator/max8660.c
+++ b/drivers/regulator/max8660.c
@@ -305,6 +305,11 @@ static const struct regulator_desc max8660_reg[] = {
 	},
 };
 
+enum {
+	MAX8660 = 0,
+	MAX8661 = 1,
+};
+
 static int max8660_probe(struct i2c_client *client,
 				   const struct i2c_device_id *i2c_id)
 {
@@ -313,6 +318,7 @@ static int max8660_probe(struct i2c_client *client,
 	struct regulator_config config = { };
 	struct max8660 *max8660;
 	int boot_on, i, id, ret = -EINVAL;
+	unsigned int type;
 
 	if (pdata->num_subdevs > MAX8660_V_END) {
 		dev_err(&client->dev, "Too many regulators found!\n");
@@ -327,6 +333,7 @@ static int max8660_probe(struct i2c_client *client,
 
 	max8660->client = client;
 	rdev = max8660->rdev;
+	type = i2c_id->driver_data;
 
 	if (pdata->en34_is_high) {
 		/* Simulate always on */
@@ -376,7 +383,7 @@ static int max8660_probe(struct i2c_client *client,
 			break;
 
 		case MAX8660_V7:
-			if (!strcmp(i2c_id->name, "max8661")) {
+			if (type == MAX8661) {
 				dev_err(&client->dev, "Regulator not on this chip!\n");
 				goto err_out;
 			}
@@ -431,8 +438,8 @@ static int max8660_remove(struct i2c_client *client)
 }
 
 static const struct i2c_device_id max8660_id[] = {
-	{ "max8660", 0 },
-	{ "max8661", 0 },
+	{ .name = "max8660", .driver_data = MAX8660 },
+	{ .name = "max8661", .driver_data = MAX8661 },
 	{ }
 };
 MODULE_DEVICE_TABLE(i2c, max8660_id);
-- 
1.8.3.1

