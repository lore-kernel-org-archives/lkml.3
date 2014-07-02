Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964891AbaGBQzN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jul 2014 12:55:13 -0400
Received: from mail-pa0-f41.google.com ([209.85.220.41]:50228 "EHLO
	mail-pa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964867AbaGBQzL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jul 2014 12:55:11 -0400
From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
To: ming.lei@canonical.com, gregkh@linuxfoundation.org
Cc: linux-kernel@vger.kernel.org, "Luis R. Rodriguez" <mcgrof@suse.com>,
        Tom Gundersen <teg@jklm.no>, Abhay Salunke <Abhay_Salunke@dell.com>,
        Stefan Roese <sr@denx.de>, Arnd Bergmann <arnd@arndb.de>,
        Kay Sievers <kay@vrfy.org>, Takashi Iwai <tiwai@suse.de>
Subject: [PATCH v3] firmware loader: inform direct failure when udev loader is disabled
Date: Wed,  2 Jul 2014 09:55:05 -0700
Message-Id: <1404320105-8481-1-git-send-email-mcgrof@do-not-panic.com>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Luis R. Rodriguez" <mcgrof@suse.com>

Now that the udev firmware loader is optional request_firmware()
will not provide any information on the kernel ring buffer if
direct firmware loading failed and udev firmware loading is disabled.
If no information is needed request_firmware_direct() should be used
for optional firmware, at which point drivers can take on the onus
over informing of any failures, if udev firmware loading is disabled
though we should at the very least provide some sort of information
as when the udev loader was enabled by default back in the days.

With this change with a simple firmware load test module [0]:

Example output without FW_LOADER_USER_HELPER_FALLBACK

platform fake-dev.0: Direct firmware load for fake.bin failed
with error -2

Example with FW_LOADER_USER_HELPER_FALLBACK

platform fake-dev.0: Direct firmware load for fake.bin failed with error -2
platform fake-dev.0: Falling back to user helper

Without this change without FW_LOADER_USER_HELPER_FALLBACK we
get no output logged upon failure.

Cc: Tom Gundersen <teg@jklm.no>
Cc: Ming Lei <ming.lei@canonical.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Abhay Salunke <Abhay_Salunke@dell.com>
Cc: Stefan Roese <sr@denx.de>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Kay Sievers <kay@vrfy.org>
Cc: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Luis R. Rodriguez <mcgrof@suse.com>
---

Use FW_OPT_NO_WARN instead.

 drivers/base/firmware_class.c | 13 +++++++------
 include/linux/firmware.h      | 15 ++++++++-------
 2 files changed, 15 insertions(+), 13 deletions(-)

diff --git a/drivers/base/firmware_class.c b/drivers/base/firmware_class.c
index 46ea5f4..08e67cc 100644
--- a/drivers/base/firmware_class.c
+++ b/drivers/base/firmware_class.c
@@ -109,6 +109,7 @@ static inline long firmware_loading_timeout(void)
 #else
 #define FW_OPT_FALLBACK		0
 #endif
+#define FW_OPT_NO_WARN	(1U << 3)
 
 struct firmware_cache {
 	/* firmware_buf instance will be added into the below list */
@@ -1116,10 +1117,11 @@ _request_firmware(const struct firmware **firmware_p, const char *name,
 
 	ret = fw_get_filesystem_firmware(device, fw->priv);
 	if (ret) {
-		if (opt_flags & FW_OPT_USERHELPER) {
+		if (!(opt_flags & FW_OPT_NO_WARN))
 			dev_warn(device,
-				 "Direct firmware load failed with error %d\n",
-				 ret);
+				 "Direct firmware load for %s failed with error %d\n",
+				 name, ret);
+		if (opt_flags & FW_OPT_USERHELPER) {
 			dev_warn(device, "Falling back to user helper\n");
 			ret = fw_load_from_user_helper(fw, name, device,
 						       opt_flags, timeout);
@@ -1176,7 +1178,6 @@ request_firmware(const struct firmware **firmware_p, const char *name,
 }
 EXPORT_SYMBOL(request_firmware);
 
-#ifdef CONFIG_FW_LOADER_USER_HELPER_FALLBACK
 /**
  * request_firmware: - load firmware directly without usermode helper
  * @firmware_p: pointer to firmware image
@@ -1193,12 +1194,12 @@ int request_firmware_direct(const struct firmware **firmware_p,
 {
 	int ret;
 	__module_get(THIS_MODULE);
-	ret = _request_firmware(firmware_p, name, device, FW_OPT_UEVENT);
+	ret = _request_firmware(firmware_p, name, device,
+				FW_OPT_UEVENT | FW_OPT_NO_WARN);
 	module_put(THIS_MODULE);
 	return ret;
 }
 EXPORT_SYMBOL_GPL(request_firmware_direct);
-#endif
 
 /**
  * release_firmware: - release the resource associated with a firmware image
diff --git a/include/linux/firmware.h b/include/linux/firmware.h
index 67e5b80..5c41c5e 100644
--- a/include/linux/firmware.h
+++ b/include/linux/firmware.h
@@ -45,6 +45,8 @@ int request_firmware_nowait(
 	struct module *module, bool uevent,
 	const char *name, struct device *device, gfp_t gfp, void *context,
 	void (*cont)(const struct firmware *fw, void *context));
+int request_firmware_direct(const struct firmware **fw, const char *name,
+			    struct device *device);
 
 void release_firmware(const struct firmware *fw);
 #else
@@ -66,13 +68,12 @@ static inline void release_firmware(const struct firmware *fw)
 {
 }
 
-#endif
+static inline int request_firmware_direct(const struct firmware **fw,
+					  const char *name,
+					  struct device *device)
+{
+	return -EINVAL;
+}
 
-#ifdef CONFIG_FW_LOADER_USER_HELPER_FALLBACK
-int request_firmware_direct(const struct firmware **fw, const char *name,
-			    struct device *device);
-#else
-#define request_firmware_direct	request_firmware
 #endif
-
 #endif
-- 
2.0.0

