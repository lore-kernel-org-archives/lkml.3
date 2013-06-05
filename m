Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757008Ab3FERsK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Jun 2013 13:48:10 -0400
Received: from kdh-gw.itdev.co.uk ([89.21.227.133]:15426 "EHLO
	hermes.kdh.itdev.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756982Ab3FERsH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Jun 2013 13:48:07 -0400
From: Nick Dyer <nick.dyer@itdev.co.uk>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Daniel Kurtz <djkurtz@chromium.org>,
        Henrik Rydberg <rydberg@euromail.se>,
        Joonyoung Shim <jy0922.shim@samsung.com>, Alan.Bowens@atmel.com,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
        pmeerw@pmeerw.net, bleung@chromium.org, olofj@chromium.org
Cc: Nick Dyer <nick.dyer@itdev.co.uk>
Subject: [PATCH 30/53] Input: atmel_mxt_ts - Handle bootloader previously unlocked
Date: Wed,  5 Jun 2013 18:37:23 +0100
Message-Id: <1370453866-16534-31-git-send-email-nick.dyer@itdev.co.uk>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1370453866-16534-1-git-send-email-nick.dyer@itdev.co.uk>
References: <1370453866-16534-1-git-send-email-nick.dyer@itdev.co.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Nick Dyer <nick.dyer@itdev.co.uk>
Acked-by: Benson Leung <bleung@chromium.org>
---
 drivers/input/touchscreen/atmel_mxt_ts.c |   28 +++++++++++++++++++---------
 1 file changed, 19 insertions(+), 9 deletions(-)

diff --git a/drivers/input/touchscreen/atmel_mxt_ts.c b/drivers/input/touchscreen/atmel_mxt_ts.c
index c18803a..125fe2f 100644
--- a/drivers/input/touchscreen/atmel_mxt_ts.c
+++ b/drivers/input/touchscreen/atmel_mxt_ts.c
@@ -459,14 +459,15 @@ static u8 mxt_get_bootloader_version(struct mxt_data *data, u8 val)
 	}
 }
 
-static int mxt_check_bootloader(struct mxt_data *data, unsigned int state)
+static int mxt_check_bootloader(struct mxt_data *data, unsigned int state,
+				bool wait)
 {
 	struct device *dev = &data->client->dev;
 	u8 val;
 	int ret;
 
 recheck:
-	if (state != MXT_WAITING_BOOTLOAD_CMD) {
+	if (wait) {
 		/*
 		 * In application update mode, the interrupt
 		 * line signals state transitions. We must wait for the
@@ -1616,15 +1617,24 @@ static int mxt_load_fw(struct device *dev, const char *fn)
 	mxt_free_object_table(data);
 	INIT_COMPLETION(data->bl_completion);
 
-	ret = mxt_check_bootloader(data, MXT_WAITING_BOOTLOAD_CMD);
-	if (ret)
-		goto disable_irq;
+	ret = mxt_check_bootloader(data, MXT_WAITING_BOOTLOAD_CMD, false);
+	if (ret) {
+		/* Bootloader may still be unlocked from previous update
+		 * attempt */
+		ret = mxt_check_bootloader(data, MXT_WAITING_FRAME_DATA, false);
+		if (ret)
+			goto disable_irq;
+	} else {
+		dev_info(dev, "Unlocking bootloader\n");
 
-	/* Unlock bootloader */
-	mxt_unlock_bootloader(data);
+		/* Unlock bootloader */
+		ret = mxt_unlock_bootloader(data);
+		if (ret)
+			goto disable_irq;
+	}
 
 	while (pos < fw->size) {
-		ret = mxt_check_bootloader(data, MXT_WAITING_FRAME_DATA);
+		ret = mxt_check_bootloader(data, MXT_WAITING_FRAME_DATA, true);
 		if (ret)
 			goto disable_irq;
 
@@ -1638,7 +1648,7 @@ static int mxt_load_fw(struct device *dev, const char *fn)
 		if (ret)
 			goto disable_irq;
 
-		ret = mxt_check_bootloader(data, MXT_FRAME_CRC_PASS);
+		ret = mxt_check_bootloader(data, MXT_FRAME_CRC_PASS, true);
 		if (ret) {
 			retry++;
 
-- 
1.7.10.4

