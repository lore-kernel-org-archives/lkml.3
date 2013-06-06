Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933217Ab3FFMCh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Jun 2013 08:02:37 -0400
Received: from mail-pa0-f45.google.com ([209.85.220.45]:45257 "EHLO
	mail-pa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933112Ab3FFMCf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Jun 2013 08:02:35 -0400
From: Ming Lei <ming.lei@canonical.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, Ming Lei <ming.lei@canonical.com>,
        Takashi Iwai <tiwai@suse.de>
Subject: [PATCH v1 3/4] firmware loader: allow distribution to choose default search paths
Date: Thu,  6 Jun 2013 20:01:49 +0800
Message-Id: <1370520110-32293-4-git-send-email-ming.lei@canonical.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1370520110-32293-1-git-send-email-ming.lei@canonical.com>
References: <1370520110-32293-1-git-send-email-ming.lei@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

For some distributions(e.g. android), firmware images aren't put
under kernel built-in search paths, so introduce one Kconfig
option to allow distributions or users to choose its specific default
search paths, which are always tried before searching from kernel
built-in paths in direct loading.

Also this patch introduces fw_get_fw_file_from_paths to cover all
search paths, and fw_get_filesystem_firmware is simpified a bit.

Cc: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Ming Lei <ming.lei@canonical.com>
---
 drivers/base/Kconfig          |   14 ++++++++++
 drivers/base/firmware_class.c |   61 ++++++++++++++++++++++++++++++++++-------
 2 files changed, 65 insertions(+), 10 deletions(-)

diff --git a/drivers/base/Kconfig b/drivers/base/Kconfig
index 07abd9d..2be10e4 100644
--- a/drivers/base/Kconfig
+++ b/drivers/base/Kconfig
@@ -156,6 +156,20 @@ config FW_LOADER_USER_HELPER
 	  no longer required unless you have a special firmware file that
 	  resides in a non-standard path.
 
+config FW_CUSTOMIZED_PATH
+	string "default firmware search paths for direct loading"
+	help
+	  On some distribution(e.g. android), firmware images aren't
+	  put under kernel built-in search paths, so provide this option
+	  for distributions to choose a distribution specific firmware
+	  search path. The option allows to choose more than one path,
+	  and paths are seperated with colon like $PATH(e.g. on android,
+	  the option might look as "/etc/firmware:/vendor/firmware").
+	  Each path should be a absolute path, and relative path will be
+	  ignored.
+
+	  If you are unsure about this, don't choose here.
+
 config DEBUG_DRIVER
 	bool "Driver Core verbose debug messages"
 	depends on DEBUG_KERNEL
diff --git a/drivers/base/firmware_class.c b/drivers/base/firmware_class.c
index 6ede229..051db83 100644
--- a/drivers/base/firmware_class.c
+++ b/drivers/base/firmware_class.c
@@ -265,8 +265,13 @@ static void fw_free_buf(struct firmware_buf *buf)
 
 /* direct firmware loading support */
 static char fw_path_para[256];
+
+/* search runtime paths first, then static pre-defined paths */
 static const char * const fw_path[] = {
 	fw_path_para,
+#ifdef CONFIG_FW_CUSTOMIZED_PATH
+	CONFIG_FW_CUSTOMIZED_PATH,
+#endif
 	"/lib/firmware/updates/" UTS_RELEASE,
 	"/lib/firmware/updates",
 	"/lib/firmware/" UTS_RELEASE,
@@ -314,6 +319,50 @@ static bool fw_read_file_contents(struct file *file, struct firmware_buf *fw_buf
 	return true;
 }
 
+static bool fw_get_file_firmware(const char *path,
+				 struct firmware_buf *buf)
+{
+	struct file *file;
+	bool success;
+
+	file = filp_open(path, O_RDONLY, 0);
+	if (IS_ERR(file))
+		return false;
+	success = fw_read_file_contents(file, buf);
+	fput(file);
+
+	return success;
+}
+
+/* The path in @paths is seperated by ';' */
+static bool fw_get_file_fw_from_paths(const char *paths, char *path,
+				      struct firmware_buf *buf)
+{
+	int len, start, end = -1;
+	char *pos;
+
+	do {
+		start = end + 1;
+		pos = strchr(&paths[start], ':');
+		if (pos) {
+			end = (int)(pos - paths);
+			len = end - start;
+		} else {
+			len = strlen(&paths[start]);
+		}
+
+		if (len <= 0 || PATH_MAX < len + 1 + strlen(buf->fw_id))
+			continue;
+		strncpy(path, &paths[start], len);
+		snprintf(&path[len], PATH_MAX - len, "/%s", buf->fw_id);
+
+		if (fw_get_file_firmware(path, buf))
+			return true;
+	} while (pos && end < strlen(paths) - 1);
+
+	return false;
+}
+
 static bool fw_get_filesystem_firmware(struct device *device,
 				       struct firmware_buf *buf)
 {
@@ -322,19 +371,11 @@ static bool fw_get_filesystem_firmware(struct device *device,
 	char *path = __getname();
 
 	for (i = 0; i < ARRAY_SIZE(fw_path); i++) {
-		struct file *file;
-
 		/* skip the unset customized path */
 		if (!fw_path[i][0])
 			continue;
-
-		snprintf(path, PATH_MAX, "%s/%s", fw_path[i], buf->fw_id);
-
-		file = filp_open(path, O_RDONLY, 0);
-		if (IS_ERR(file))
-			continue;
-		success = fw_read_file_contents(file, buf);
-		fput(file);
+		success = fw_get_file_fw_from_paths(fw_path[i], path,
+						    buf);
 		if (success)
 			break;
 	}
-- 
1.7.9.5

