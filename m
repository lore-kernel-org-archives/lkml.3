Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756227Ab3BAIMf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Feb 2013 03:12:35 -0500
Received: from mail-da0-f44.google.com ([209.85.210.44]:35987 "EHLO
	mail-da0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755975Ab3BAIMX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Feb 2013 03:12:23 -0500
From: Daniel Kurtz <djkurtz@chromium.org>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Henrik Rydberg <rydberg@euromail.se>,
        Benson Leung <bleung@chromium.org>, Yufeng Shen <miletus@chromium.org>,
        Nick Dyer <nick.dyer@itdev.co.uk>
Cc: Joonyoung Shim <jy0922.shim@samsung.com>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org, olofj@chromium.org,
        Daniel Kurtz <djkurtz@chromium.org>
Subject: [PATCH 06/10] Input: atmel_mxt_ts - destroy state before fw update and restore after
Date: Fri,  1 Feb 2013 16:11:48 +0800
Message-Id: <1359706312-24642-7-git-send-email-djkurtz@chromium.org>
X-Mailer: git-send-email 1.8.1
In-Reply-To: <1359706312-24642-1-git-send-email-djkurtz@chromium.org>
References: <1359706312-24642-1-git-send-email-djkurtz@chromium.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

After firmware update, the device may have a completely different object
table which corresponds to an input device with different properties.
So, destroy the old state before firmware update, and completely
reinitialize the driver afterward.

Two benefits of this:
 1) Since there is no input device during fw update, no need to worry
about device open/close events.
 2) If firmware update fails, the device and driver will still be in
bootloader mode and an improperly configured input device will not exist.

Signed-off-by: Daniel Kurtz <djkurtz@chromium.org>
---
 drivers/input/touchscreen/atmel_mxt_ts.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/drivers/input/touchscreen/atmel_mxt_ts.c b/drivers/input/touchscreen/atmel_mxt_ts.c
index 76a25d3..c74f5a5 100644
--- a/drivers/input/touchscreen/atmel_mxt_ts.c
+++ b/drivers/input/touchscreen/atmel_mxt_ts.c
@@ -1001,6 +1001,13 @@ static int mxt_load_fw(struct device *dev, const char *fn)
 		client->addr = MXT_BOOT_HIGH;
 
 bootloader_ready:
+	/* Free any driver state. It will get reinitialized after fw update. */
+	mxt_free_object_table(data);
+	if (data->input_dev) {
+		input_unregister_device(data->input_dev);
+		data->input_dev = NULL;
+	}
+
 	ret = mxt_check_bootloader(client, MXT_WAITING_BOOTLOAD_CMD);
 	if (ret)
 		goto out;
@@ -1068,9 +1075,8 @@ static ssize_t mxt_update_fw_store(struct device *dev,
 		/* Wait for reset */
 		msleep(MXT_FWRESET_TIME);
 
-		mxt_free_object_table(data);
-
 		mxt_initialize(data);
+		mxt_input_dev_create(data);
 	}
 
 	enable_irq(data->irq);
-- 
1.8.1

