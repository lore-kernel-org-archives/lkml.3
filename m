Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754015Ab3L0BGS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Dec 2013 20:06:18 -0500
Received: from mail-ie0-f201.google.com ([209.85.223.201]:57789 "EHLO
	mail-ie0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753042Ab3L0BGQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Dec 2013 20:06:16 -0500
From: Andrew Bresticker <abrestic@chromium.org>
To: Anton Vorontsov <anton@enomsg.org>, David Woodhouse <dwmw2@infradead.org>,
        Rhyland Klein <rklein@nvidia.com>
Cc: linux-kernel@vger.kernel.org, Andrew Bresticker <abrestic@chromium.org>
Subject: [PATCH] sbs-battery: make writes to ManufacturerAccess optional
Date: Thu, 26 Dec 2013 17:06:07 -0800
Message-Id: <1388106367-26373-1-git-send-email-abrestic@chromium.org>
X-Mailer: git-send-email 1.8.5.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

According to the Smart Battery Data Specification, the use
of ManufacturerAcess (register 0x0) is implementation-defined.
It appears that some batteries use writes to this register
in order to implement certain functionality, but others may
simply NAK all writes to it.  As a result, write failures to
ManufacturerAccess should not be used as an indicator of battery
presence.

Signed-off-by: Andrew Bresticker <abrestic@chromium.org>
---
 drivers/power/sbs-battery.c | 12 ++----------
 1 file changed, 2 insertions(+), 10 deletions(-)

diff --git a/drivers/power/sbs-battery.c b/drivers/power/sbs-battery.c
index b5f2a76..1240a9c 100644
--- a/drivers/power/sbs-battery.c
+++ b/drivers/power/sbs-battery.c
@@ -228,13 +228,8 @@ static int sbs_get_battery_presence_and_health(
 	/* Write to ManufacturerAccess with
 	 * ManufacturerAccess command and then
 	 * read the status */
-	ret = sbs_write_word_data(client, sbs_data[REG_MANUFACTURER_DATA].addr,
+	sbs_write_word_data(client, sbs_data[REG_MANUFACTURER_DATA].addr,
 					MANUFACTURER_ACCESS_STATUS);
-	if (ret < 0) {
-		if (psp == POWER_SUPPLY_PROP_PRESENT)
-			val->intval = 0; /* battery removed */
-		return ret;
-	}
 
 	ret = sbs_read_word_data(client, sbs_data[REG_MANUFACTURER_DATA].addr);
 	if (ret < 0)
@@ -827,16 +822,13 @@ static int sbs_suspend(struct device *dev)
 {
 	struct i2c_client *client = to_i2c_client(dev);
 	struct sbs_info *chip = i2c_get_clientdata(client);
-	s32 ret;
 
 	if (chip->poll_time > 0)
 		cancel_delayed_work_sync(&chip->work);
 
 	/* write to manufacturer access with sleep command */
-	ret = sbs_write_word_data(client, sbs_data[REG_MANUFACTURER_DATA].addr,
+	sbs_write_word_data(client, sbs_data[REG_MANUFACTURER_DATA].addr,
 		MANUFACTURER_ACCESS_SLEEP);
-	if (chip->is_present && ret < 0)
-		return ret;
 
 	return 0;
 }
-- 
1.8.5.1

