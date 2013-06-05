Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751993Ab3FEFnr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Jun 2013 01:43:47 -0400
Received: from mail-pd0-f179.google.com ([209.85.192.179]:34435 "EHLO
	mail-pd0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751268Ab3FEFnm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Jun 2013 01:43:42 -0400
From: Ming Lei <ming.lei@canonical.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, Ming Lei <ming.lei@canonical.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 3/3] firmware loader: allow distribution to choose default search paths
Date: Wed,  5 Jun 2013 13:42:49 +0800
Message-Id: <1370410969-15328-4-git-send-email-ming.lei@canonical.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1370410969-15328-1-git-send-email-ming.lei@canonical.com>
References: <1370410969-15328-1-git-send-email-ming.lei@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

For some distributions(e.g. android), firmware images aren't put
under kernel built-in search paths, so introduce one Kconfig
option to allow distributions or users to choose its specific default
search paths, which are always tried before searching from kernel
built-in paths in direct loading.

Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Ming Lei <ming.lei@canonical.com>
---
 drivers/base/Kconfig          |   12 +++++++
 drivers/base/firmware_class.c |   76 ++++++++++++++++++++++++++++++++++++-----
 2 files changed, 80 insertions(+), 8 deletions(-)

diff --git a/drivers/base/Kconfig b/drivers/base/Kconfig
index 07abd9d..5b0c909 100644
--- a/drivers/base/Kconfig
+++ b/drivers/base/Kconfig
@@ -156,6 +156,18 @@ config FW_LOADER_USER_HELPER
 	  no longer required unless you have a special firmware file that
 	  resides in a non-standard path.
 
+config FW_CUSTOMIZED_PATH
+	string "default firmware search paths for direct loading"
+	help
+	  On some distribution(e.g. android), firmware images aren't
+	  put under kernel built-in search paths, so provide this option
+	  for distributions to choose a distribution specific firmware
+	  search path. The option allows to choose more than one path,
+	  and paths are seperated with semicolon(e.g. on android, the
+	  option might look as "/etc/firmware;/vendor/firmware").
+
+	  If you are unsure about this, don't choose here.
+
 config DEBUG_DRIVER
 	bool "Driver Core verbose debug messages"
 	depends on DEBUG_KERNEL
diff --git a/drivers/base/firmware_class.c b/drivers/base/firmware_class.c
index c743409..50b5913 100644
--- a/drivers/base/firmware_class.c
+++ b/drivers/base/firmware_class.c
@@ -267,6 +267,9 @@ static void fw_free_buf(struct firmware_buf *buf)
 static char fw_path_para[256];
 static const char * const fw_path[] = {
 	fw_path_para,
+#ifdef CONFIG_FW_CUSTOMIZED_PATH
+	CONFIG_FW_CUSTOMIZED_PATH,
+#endif
 	"/lib/firmware/updates/" UTS_RELEASE,
 	"/lib/firmware/updates",
 	"/lib/firmware/" UTS_RELEASE,
@@ -314,6 +317,59 @@ static bool fw_read_file_contents(struct file *file, struct firmware_buf *fw_buf
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
+#ifdef CONFIG_FW_CUSTOMIZED_PATH
+/* The path in @paths is seperated by ';' */
+static bool fw_get_fw_file_from_paths(const char *paths, char *path,
+				      struct firmware_buf *buf)
+{
+	int len, start, end;
+	char *pos;
+
+	end = -1;
+	do {
+		start = end + 1;
+		pos = strchr(&paths[start], ';');
+		if (pos) {
+			end = (int)(pos - paths);
+			len = end - start;
+		} else {
+			len = strlen(&paths[start]);
+		}
+
+		if (PATH_MAX < len + strlen(buf->fw_id))
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
+#else
+static bool fw_get_fw_file_from_paths(const char *paths, char *path,
+				      struct firmware_buf *buf)
+{
+	return false;
+}
+#endif
+
 static bool fw_get_filesystem_firmware(struct device *device,
 				       struct firmware_buf *buf)
 {
@@ -322,19 +378,23 @@ static bool fw_get_filesystem_firmware(struct device *device,
 	char *path = __getname();
 
 	for (i = 0; i < ARRAY_SIZE(fw_path); i++) {
-		struct file *file;
 
 		/* skip the unset customized path */
 		if (!fw_path[i][0])
 			continue;
 
-		snprintf(path, PATH_MAX, "%s/%s", fw_path[i], buf->fw_id);
-
-		file = filp_open(path, O_RDONLY, 0);
-		if (IS_ERR(file))
-			continue;
-		success = fw_read_file_contents(file, buf);
-		fput(file);
+		/*
+		 * If CONFIG_FW_CUSTOMIZED_PATH is set, search from
+		 * these paths first
+		 */
+		if (i == 1 && ARRAY_SIZE(fw_path) > 5) {
+			success = fw_get_fw_file_from_paths(fw_path[1],
+							    path, buf);
+		} else {
+			snprintf(path, PATH_MAX, "%s/%s", fw_path[i],
+				 buf->fw_id);
+			success = fw_get_file_firmware(path, buf);
+		}
 		if (success)
 			break;
 	}
-- 
1.7.9.5

