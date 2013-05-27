Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757478Ab3E0Ka0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 May 2013 06:30:26 -0400
Received: from mail-pb0-f42.google.com ([209.85.160.42]:53979 "EHLO
	mail-pb0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757411Ab3E0KaW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 May 2013 06:30:22 -0400
From: Ming Lei <ming.lei@canonical.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, Ming Lei <ming.lei@canonical.com>,
        Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 1/2] driver core: firmware loader: don't cache FW_ACTION_NOHOTPLUG firmware
Date: Mon, 27 May 2013 18:30:03 +0800
Message-Id: <1369650604-27941-2-git-send-email-ming.lei@canonical.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1369650604-27941-1-git-send-email-ming.lei@canonical.com>
References: <1369650604-27941-1-git-send-email-ming.lei@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Generally there are only two drivers which don't need uevent to
handle firmware loading, so don't cache these firmwares during
suspend for these drivers since doing that may block firmware
loading forever.

Both the two drivers are involved in private firmware images, so
they don't hit in direct loading too.

Cc: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Ming Lei <ming.lei@canonical.com>
---
 drivers/base/firmware_class.c |    9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/drivers/base/firmware_class.c b/drivers/base/firmware_class.c
index e650c25..64e7870 100644
--- a/drivers/base/firmware_class.c
+++ b/drivers/base/firmware_class.c
@@ -993,7 +993,8 @@ _request_firmware_prepare(struct firmware **firmware_p, const char *name,
 	return 1; /* need to load */
 }
 
-static int assign_firmware_buf(struct firmware *fw, struct device *device)
+static int assign_firmware_buf(struct firmware *fw, struct device *device,
+				bool skip_cache)
 {
 	struct firmware_buf *buf = fw->priv;
 
@@ -1010,7 +1011,7 @@ static int assign_firmware_buf(struct firmware *fw, struct device *device)
 	 * device may has been deleted already, but the problem
 	 * should be fixed in devres or driver core.
 	 */
-	if (device)
+	if (device && !skip_cache)
 		fw_add_devm_name(device, buf->fw_id);
 
 	/*
@@ -1066,8 +1067,10 @@ _request_firmware(const struct firmware **firmware_p, const char *name,
 	if (!fw_get_filesystem_firmware(device, fw->priv))
 		ret = fw_load_from_user_helper(fw, name, device,
 					       uevent, nowait, timeout);
+
+	/* don't cache firmware handled without uevent */
 	if (!ret)
-		ret = assign_firmware_buf(fw, device);
+		ret = assign_firmware_buf(fw, device, !uevent);
 
 	usermodehelper_read_unlock();
 
-- 
1.7.9.5

