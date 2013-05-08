Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753299Ab3EHG5U (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 May 2013 02:57:20 -0400
Received: from cantor2.suse.de ([195.135.220.15]:42009 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752748Ab3EHG4t (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 May 2013 02:56:49 -0400
From: Takashi Iwai <tiwai@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Ming Lei <ming.lei@canonical.com>
Subject: [PATCH 1/3] firmware: Avoid superfluous usermodehelper lock
Date: Wed,  8 May 2013 08:56:35 +0200
Message-Id: <1367996197-32748-2-git-send-email-tiwai@suse.de>
X-Mailer: git-send-email 1.8.2.1
In-Reply-To: <1367996197-32748-1-git-send-email-tiwai@suse.de>
References: <1367996197-32748-1-git-send-email-tiwai@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When a firmware file can be loaded directly, there is no good reason
to lock usermodehelper.  It's needed only when the direct fw load
fails and falls back to the user-mode helper.

Signed-off-by: Takashi Iwai <tiwai@suse.de>
---
 drivers/base/firmware_class.c | 42 +++++++++++++++++++++++-------------------
 1 file changed, 23 insertions(+), 19 deletions(-)

diff --git a/drivers/base/firmware_class.c b/drivers/base/firmware_class.c
index 4b1f926..9e1d39e 100644
--- a/drivers/base/firmware_class.c
+++ b/drivers/base/firmware_class.c
@@ -1006,7 +1006,7 @@ _request_firmware(const struct firmware **firmware_p, const char *name,
 		  struct device *device, bool uevent, bool nowait)
 {
 	struct firmware *fw;
-	long timeout;
+	bool usermode_locked = false;
 	int ret;
 
 	if (!firmware_p)
@@ -1017,31 +1017,35 @@ _request_firmware(const struct firmware **firmware_p, const char *name,
 		goto out;
 
 	ret = 0;
-	timeout = firmware_loading_timeout();
-	if (nowait) {
-		timeout = usermodehelper_read_lock_wait(timeout);
-		if (!timeout) {
-			dev_dbg(device, "firmware: %s loading timed out\n",
-				name);
-			ret = -EBUSY;
-			goto out;
-		}
-	} else {
-		ret = usermodehelper_read_trylock();
-		if (WARN_ON(ret)) {
-			dev_err(device, "firmware: %s will not be loaded\n",
-				name);
-			goto out;
+	if (!fw_get_filesystem_firmware(device, fw->priv)) {
+		long timeout = firmware_loading_timeout();
+		if (nowait) {
+			timeout = usermodehelper_read_lock_wait(timeout);
+			if (!timeout) {
+				dev_dbg(device, "firmware: %s loading timed out\n",
+					name);
+				ret = -EBUSY;
+				goto out;
+			}
+		} else {
+			ret = usermodehelper_read_trylock();
+			if (WARN_ON(ret)) {
+				dev_err(device, "firmware: %s will not be loaded\n",
+					name);
+				goto out;
+			}
 		}
-	}
 
-	if (!fw_get_filesystem_firmware(device, fw->priv))
+		usermode_locked = true;
 		ret = fw_load_from_user_helper(fw, name, device,
 					       uevent, nowait, timeout);
+	}
+
 	if (!ret)
 		ret = assign_firmware_buf(fw, device);
 
-	usermodehelper_read_unlock();
+	if (usermode_locked)
+		usermodehelper_read_unlock();
 
  out:
 	if (ret < 0) {
-- 
1.8.2.1

