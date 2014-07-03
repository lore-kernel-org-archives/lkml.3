Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758814AbaGCPIR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jul 2014 11:08:17 -0400
Received: from kdh-gw.itdev.co.uk ([89.21.227.133]:17759 "EHLO
	hermes.kdh.itdev.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757371AbaGCPIN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jul 2014 11:08:13 -0400
From: nick.dyer@itdev.co.uk
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: Yufeng Shen <miletus@google.com>, Daniel Kurtz <djkurtz@chromium.org>,
        Henrik Rydberg <rydberg@euromail.se>,
        Joonyoung Shim <jy0922.shim@samsung.com>,
        Alan Bowens <Alan.Bowens@atmel.com>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org, Peter Meerwald <pmeerw@pmeerw.net>,
        Benson Leung <bleung@chromium.org>,
        Olof Johansson <olofj@chromium.org>, Sekhar Nori <nsekhar@ti.com>,
        Nick Dyer <nick.dyer@itdev.co.uk>
Subject: [PATCH 09/15] Input: atmel_mxt_ts - handle bootloader previously unlocked
Date: Thu,  3 Jul 2014 16:01:31 +0100
Message-Id: <1404399697-26484-10-git-send-email-nick.dyer@itdev.co.uk>
X-Mailer: git-send-email 2.0.1
In-Reply-To: <1404399697-26484-1-git-send-email-nick.dyer@itdev.co.uk>
References: <1404399697-26484-1-git-send-email-nick.dyer@itdev.co.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Nick Dyer <nick.dyer@itdev.co.uk>

On a warm probe, the device might be in a state where an flash operation was
not completed.

Signed-off-by: Nick Dyer <nick.dyer@itdev.co.uk>
Acked-by: Benson Leung <bleung@chromium.org>
Acked-by: Yufeng Shen <miletus@chromium.org>
---
 drivers/input/touchscreen/atmel_mxt_ts.c | 27 ++++++++++++++++++---------
 1 file changed, 18 insertions(+), 9 deletions(-)

diff --git a/drivers/input/touchscreen/atmel_mxt_ts.c b/drivers/input/touchscreen/atmel_mxt_ts.c
index aa957d2..f9db3e1 100644
--- a/drivers/input/touchscreen/atmel_mxt_ts.c
+++ b/drivers/input/touchscreen/atmel_mxt_ts.c
@@ -453,14 +453,15 @@ static u8 mxt_get_bootloader_version(struct mxt_data *data, u8 val)
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
@@ -1726,15 +1727,23 @@ static int mxt_load_fw(struct device *dev, const char *fn)
 	mxt_free_object_table(data);
 	reinit_completion(&data->bl_completion);
 
-	ret = mxt_check_bootloader(data, MXT_WAITING_BOOTLOAD_CMD);
-	if (ret)
-		goto disable_irq;
+	ret = mxt_check_bootloader(data, MXT_WAITING_BOOTLOAD_CMD, false);
+	if (ret) {
+		/* Bootloader may still be unlocked from previous attempt */
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
 
@@ -1748,7 +1757,7 @@ static int mxt_load_fw(struct device *dev, const char *fn)
 		if (ret)
 			goto disable_irq;
 
-		ret = mxt_check_bootloader(data, MXT_FRAME_CRC_PASS);
+		ret = mxt_check_bootloader(data, MXT_FRAME_CRC_PASS, true);
 		if (ret) {
 			retry++;
 
-- 
2.0.1

