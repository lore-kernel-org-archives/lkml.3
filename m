Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756458Ab3BAIN1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Feb 2013 03:13:27 -0500
Received: from mail-da0-f45.google.com ([209.85.210.45]:36451 "EHLO
	mail-da0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756146Ab3BAIMd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Feb 2013 03:12:33 -0500
From: Daniel Kurtz <djkurtz@chromium.org>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Henrik Rydberg <rydberg@euromail.se>,
        Benson Leung <bleung@chromium.org>, Yufeng Shen <miletus@chromium.org>,
        Nick Dyer <nick.dyer@itdev.co.uk>
Cc: Joonyoung Shim <jy0922.shim@samsung.com>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org, olofj@chromium.org
Subject: [PATCH 09/10] Input: atmel_mxt_ts - wait for CHG after bootloader resets
Date: Fri,  1 Feb 2013 16:11:51 +0800
Message-Id: <1359706312-24642-10-git-send-email-djkurtz@chromium.org>
X-Mailer: git-send-email 1.8.1
In-Reply-To: <1359706312-24642-1-git-send-email-djkurtz@chromium.org>
References: <1359706312-24642-1-git-send-email-djkurtz@chromium.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Benson Leung <bleung@chromium.org>

Rather than msleep for MXT_RESET_TIME and MXT_FWRESET_TIME
during the transition to bootloader mode and the transition
back from app, wait for the CHG assert to indicate that the
transition is done.

This change replaces the msleep with a wait for completion that
the mxt_interrupt handler signals.

This improves firmware update time by 300 ms as we no longer
wait longer than necessary for each reset.

Signed-off-by: Benson Leung <bleung@chromium.org>
---
 drivers/input/touchscreen/atmel_mxt_ts.c | 19 +++++++++++++++----
 1 file changed, 15 insertions(+), 4 deletions(-)

diff --git a/drivers/input/touchscreen/atmel_mxt_ts.c b/drivers/input/touchscreen/atmel_mxt_ts.c
index d0f91ff..ef867d3 100644
--- a/drivers/input/touchscreen/atmel_mxt_ts.c
+++ b/drivers/input/touchscreen/atmel_mxt_ts.c
@@ -634,6 +634,7 @@ static bool mxt_is_T9_message(struct mxt_data *data, struct mxt_message *msg)
 static int mxt_enter_bl(struct mxt_data *data)
 {
 	struct i2c_client *client = data->client;
+	struct device *dev = &client->dev;
 	int ret;
 
 	if (mxt_in_bootloader(data))
@@ -662,8 +663,19 @@ static int mxt_enter_bl(struct mxt_data *data)
 		data->input_dev = NULL;
 	}
 
+	INIT_COMPLETION(data->bl_completion);
 	enable_irq(data->irq);
-	msleep(MXT_RESET_TIME);
+
+	/* Wait for CHG assert to indicate successful reset into bootloader */
+	ret = mxt_wait_for_chg(data, MXT_RESET_TIME);
+	if (ret) {
+		dev_err(dev, "Failed waiting for reset to bootloader.\n");
+		if (client->addr == MXT_BOOT_LOW)
+			client->addr = MXT_APP_LOW;
+		else
+			client->addr = MXT_APP_HIGH;
+		return ret;
+	}
 	return 0;
 }
 
@@ -676,10 +688,10 @@ static void mxt_exit_bl(struct mxt_data *data)
 	if (!mxt_in_bootloader(data))
 		return;
 
-	disable_irq(data->irq);
 	/* Wait for reset */
-	msleep(MXT_FWRESET_TIME);
+	mxt_wait_for_chg(data, MXT_FWRESET_TIME);
 
+	disable_irq(data->irq);
 	if (client->addr == MXT_BOOT_LOW)
 		client->addr = MXT_APP_LOW;
 	else
@@ -1122,7 +1134,6 @@ static int mxt_load_fw(struct device *dev, const char *fn)
 	if (ret)
 		goto out;
 
-	INIT_COMPLETION(data->bl_completion);
 	/* Unlock bootloader */
 	ret = mxt_unlock_bootloader(client);
 	if (ret)
-- 
1.8.1

