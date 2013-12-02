Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752375Ab3LBOkn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Dec 2013 09:40:43 -0500
Received: from cantor2.suse.de ([195.135.220.15]:46593 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752789Ab3LBOia (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Dec 2013 09:38:30 -0500
From: Takashi Iwai <tiwai@suse.de>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH v4 1/4] firmware: Introduce request_firmware_direct()
Date: Mon,  2 Dec 2013 15:38:16 +0100
Message-Id: <1385995099-11901-2-git-send-email-tiwai@suse.de>
X-Mailer: git-send-email 1.8.4.4
In-Reply-To: <1385995099-11901-1-git-send-email-tiwai@suse.de>
References: <1385995099-11901-1-git-send-email-tiwai@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When CONFIG_FW_LOADER_USER_HELPER is set, request_firmware() falls
back to the usermode helper for loading via udev when the direct
loading fails.  But the recent udev takes way too long timeout (60
seconds) for non-existing firmware.  This is unacceptable for the
drivers like microcode loader where they load firmwares optionally,
i.e. it's no error even if no requested file exists.

This patch provides a new helper function, request_firmware_direct().
It behaves as same as request_firmware() except for that it doesn't
fall back to usermode helper but returns an error immediately if the
f/w can't be loaded directly in kernel.

Without CONFIG_FW_LOADER_USER_HELPER=y, request_firmware_direct() is
just an alias of request_firmware(), due to obvious reason.

Tested-by: Prarit Bhargava <prarit@redhat.com>
Acked-by: Ming Lei <ming.lei@canonical.com>
Acked-by: Borislav Petkov <bp@suse.de>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
---
 drivers/base/firmware_class.c | 41 ++++++++++++++++++++++++++++++++++-------
 include/linux/firmware.h      |  7 +++++++
 2 files changed, 41 insertions(+), 7 deletions(-)

diff --git a/drivers/base/firmware_class.c b/drivers/base/firmware_class.c
index eb8fb94ae2c5..1af03648daf8 100644
--- a/drivers/base/firmware_class.c
+++ b/drivers/base/firmware_class.c
@@ -1061,7 +1061,7 @@ static int assign_firmware_buf(struct firmware *fw, struct device *device,
 /* called from request_firmware() and request_firmware_work_func() */
 static int
 _request_firmware(const struct firmware **firmware_p, const char *name,
-		  struct device *device, bool uevent, bool nowait)
+		  struct device *device, bool uevent, bool nowait, bool fallback)
 {
 	struct firmware *fw;
 	long timeout;
@@ -1095,11 +1095,14 @@ _request_firmware(const struct firmware **firmware_p, const char *name,
 
 	ret = fw_get_filesystem_firmware(device, fw->priv);
 	if (ret) {
-		dev_warn(device, "Direct firmware load failed with error %d\n",
-			 ret);
-		dev_warn(device, "Falling back to user helper\n");
-		ret = fw_load_from_user_helper(fw, name, device,
+		if (fallback) {
+			dev_warn(device,
+				 "Direct firmware load failed with error %d\n",
+				 ret);
+			dev_warn(device, "Falling back to user helper\n");
+			ret = fw_load_from_user_helper(fw, name, device,
 					       uevent, nowait, timeout);
+		}
 	}
 
 	/* don't cache firmware handled without uevent */
@@ -1146,12 +1149,36 @@ request_firmware(const struct firmware **firmware_p, const char *name,
 
 	/* Need to pin this module until return */
 	__module_get(THIS_MODULE);
-	ret = _request_firmware(firmware_p, name, device, true, false);
+	ret = _request_firmware(firmware_p, name, device, true, false, true);
 	module_put(THIS_MODULE);
 	return ret;
 }
 EXPORT_SYMBOL(request_firmware);
 
+#ifdef CONFIG_FW_LOADER_USER_HELPER
+/**
+ * request_firmware: - load firmware directly without usermode helper
+ * @firmware_p: pointer to firmware image
+ * @name: name of firmware file
+ * @device: device for which firmware is being loaded
+ *
+ * This function works pretty much like request_firmware(), but this doesn't
+ * fall back to usermode helper even if the firmware couldn't be loaded
+ * directly from fs.  Hence it's useful for loading optional firmwares, which
+ * aren't always present, without extra long timeouts of udev.
+ **/
+int request_firmware_direct(const struct firmware **firmware_p,
+			    const char *name, struct device *device)
+{
+	int ret;
+	__module_get(THIS_MODULE);
+	ret = _request_firmware(firmware_p, name, device, true, false, false);
+	module_put(THIS_MODULE);
+	return ret;
+}
+EXPORT_SYMBOL_GPL(request_firmware_direct);
+#endif
+
 /**
  * release_firmware: - release the resource associated with a firmware image
  * @fw: firmware resource to release
@@ -1185,7 +1212,7 @@ static void request_firmware_work_func(struct work_struct *work)
 	fw_work = container_of(work, struct firmware_work, work);
 
 	_request_firmware(&fw, fw_work->name, fw_work->device,
-			  fw_work->uevent, true);
+			  fw_work->uevent, true, true);
 	fw_work->cont(fw, fw_work->context);
 	put_device(fw_work->device); /* taken in request_firmware_nowait() */
 
diff --git a/include/linux/firmware.h b/include/linux/firmware.h
index e154c1005cd1..59529330efd6 100644
--- a/include/linux/firmware.h
+++ b/include/linux/firmware.h
@@ -68,4 +68,11 @@ static inline void release_firmware(const struct firmware *fw)
 
 #endif
 
+#ifdef CONFIG_FW_LOADER_USER_HELPER
+int request_firmware_direct(const struct firmware **fw, const char *name,
+			    struct device *device);
+#else
+#define request_firmware_direct	request_firmware
+#endif
+
 #endif
-- 
1.8.4.4

