Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756907AbaCQRe2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Mar 2014 13:34:28 -0400
Received: from kdh-gw.itdev.co.uk ([89.21.227.133]:19851 "EHLO
	hermes.kdh.itdev.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756480AbaCQRdc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Mar 2014 13:33:32 -0400
From: Nick Dyer <nick.dyer@itdev.co.uk>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: Yufeng Shen <miletus@google.com>, Daniel Kurtz <djkurtz@chromium.org>,
        Henrik Rydberg <rydberg@euromail.se>,
        Joonyoung Shim <jy0922.shim@samsung.com>,
        Alan Bowens <Alan.Bowens@atmel.com>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org, Peter Meerwald <pmeerw@pmeerw.net>,
        Benson Leung <bleung@chromium.org>,
        Olof Johansson <olofj@chromium.org>, Nick Dyer <nick.dyer@itdev.co.uk>
Subject: [PATCH 07/22] Input: atmel_mxt_ts - wait for CHG after bootloader resets
Date: Mon, 17 Mar 2014 17:26:40 +0000
Message-Id: <1395077215-10922-8-git-send-email-nick.dyer@itdev.co.uk>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1395077215-10922-1-git-send-email-nick.dyer@itdev.co.uk>
References: <1395077215-10922-1-git-send-email-nick.dyer@itdev.co.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Benson Leung <bleung@chromium.org>

Rather than msleep for MXT_RESET_TIME and MXT_FWRESET_TIME during the
transition to bootloader mode and the transition back from app, wait for the
CHG assert to indicate that the transition is done.

This change replaces the msleep with a wait for completion that the
mxt_interrupt handler signals.

Also add CHG poll after last firmware frame - some bootloader versions will
assert the interrupt line after the final frame, in testing this meant that
the driver attempts to read the info block too early whilst the chip is still
resetting.

This improves firmware update time as we no longer wait longer than necessary
for each reset.

Signed-off-by: Benson Leung <bleung@chromium.org>
Signed-off-by: Daniel Kurtz <djkurtz@chromium.org>
Signed-off-by: Nick Dyer <nick.dyer@itdev.co.uk>
Acked-by: Yufeng Shen <miletus@chromium.org>
Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
---
 drivers/input/touchscreen/atmel_mxt_ts.c | 22 +++++++++++++++-------
 1 file changed, 15 insertions(+), 7 deletions(-)

diff --git a/drivers/input/touchscreen/atmel_mxt_ts.c b/drivers/input/touchscreen/atmel_mxt_ts.c
index 7f51d39..d5b3043 100644
--- a/drivers/input/touchscreen/atmel_mxt_ts.c
+++ b/drivers/input/touchscreen/atmel_mxt_ts.c
@@ -181,8 +181,8 @@
 #define MXT_BACKUP_VALUE	0x55
 #define MXT_BACKUP_TIME		50	/* msec */
 #define MXT_RESET_TIME		200	/* msec */
-
-#define MXT_FWRESET_TIME	175	/* msec */
+#define MXT_FW_RESET_TIME	3000	/* msec */
+#define MXT_FW_CHG_TIMEOUT	300	/* msec */
 
 /* Command to unlock bootloader */
 #define MXT_UNLOCK_CMD_MSB	0xaa
@@ -375,7 +375,7 @@ recheck:
 		 * CHG assertion before reading the status byte.
 		 * Once the status byte has been read, the line is deasserted.
 		 */
-		ret = mxt_wait_for_chg(data, 300);
+		ret = mxt_wait_for_chg(data, MXT_FW_CHG_TIMEOUT);
 		if (ret) {
 			/*
 			 * TODO: handle -ERESTARTSYS better by terminating
@@ -1047,6 +1047,18 @@ static int mxt_load_fw(struct device *dev, const char *fn)
 		dev_dbg(dev, "Updated %d bytes / %zd bytes\n", pos, fw->size);
 	}
 
+	/* Wait for flash. */
+	ret = mxt_wait_for_chg(data, MXT_FW_RESET_TIME);
+	if (ret)
+		goto disable_irq;
+
+	/*
+	 * Wait for device to reset. Some bootloader versions do not assert
+	 * the CHG line after bootloading has finished, so ignore potential
+	 * errors.
+	 */
+	mxt_wait_for_chg(data, MXT_FW_RESET_TIME);
+
 	data->in_bootloader = false;
 
 disable_irq:
@@ -1075,10 +1087,6 @@ static ssize_t mxt_update_fw_store(struct device *dev,
 		count = error;
 	} else {
 		dev_dbg(dev, "The firmware update succeeded\n");
-
-		/* Wait for reset */
-		msleep(MXT_FWRESET_TIME);
-
 		mxt_free_object_table(data);
 
 		mxt_initialize(data);
-- 
1.8.3.2

