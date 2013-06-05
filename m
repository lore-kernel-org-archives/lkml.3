Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753912Ab3FEK2u (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Jun 2013 06:28:50 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:53381 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752756Ab3FEK2t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Jun 2013 06:28:49 -0400
MIME-Version: 1.0
In-Reply-To: <CACVXFVNpH2H0wxfmbeVY--Q+1UnNT1rq_Rwr-3ou3Nddq2EWXw@mail.gmail.com>
References: <1370410969-15328-1-git-send-email-ming.lei@canonical.com>
	<1370410969-15328-4-git-send-email-ming.lei@canonical.com>
	<s5hbo7lrq2a.wl%tiwai@suse.de>
	<CACVXFVNpH2H0wxfmbeVY--Q+1UnNT1rq_Rwr-3ou3Nddq2EWXw@mail.gmail.com>
Date: Wed, 5 Jun 2013 18:28:46 +0800
Message-ID: <CACVXFVN5L6ZO2nT2o+JVqG-OUu-+ods3wgV=G4imWd7GNM5M6g@mail.gmail.com>
Subject: Re: [PATCH 3/3] firmware loader: allow distribution to choose default
 search paths
From: Ming Lei <ming.lei@canonical.com>
To: Takashi Iwai <tiwai@suse.de>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Wed, Jun 5, 2013 at 5:35 PM, Ming Lei <ming.lei@canonical.com> wrote:
>
> Looks we can let fw_get_fw_file_from_paths() handle all
> predefined paths(CONFIG_FW_CUSTOMIZED_PATH and
> kernel built-in paths), then fw_get_filesystem_firmware()
> may become simple, just check fw_path_para and all
> other paths by fw_get_fw_file_from_paths(). How about the
> idea?

So follows the revised patch for review, which should be cleaner
than before, :-)

Any comments?

---
 drivers/base/Kconfig          |   14 +++++++
 drivers/base/firmware_class.c |   87 +++++++++++++++++++++++++++++------------
 2 files changed, 76 insertions(+), 25 deletions(-)

diff --git a/drivers/base/Kconfig b/drivers/base/Kconfig
index 07abd9d..b66e63e 100644
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
+	  and paths are seperated with semicolon(e.g. on android, the
+	  option might look as "/etc/firmware;/vendor/firmware"). Each
+	  path should be a absolute path, and relative path will be
+	  ignored.
+
+	  If you are unsure about this, don't choose here.
+
 config DEBUG_DRIVER
 	bool "Driver Core verbose debug messages"
 	depends on DEBUG_KERNEL
diff --git a/drivers/base/firmware_class.c b/drivers/base/firmware_class.c
index c743409..218dc1b 100644
--- a/drivers/base/firmware_class.c
+++ b/drivers/base/firmware_class.c
@@ -265,13 +265,14 @@ static void fw_free_buf(struct firmware_buf *buf)

 /* direct firmware loading support */
 static char fw_path_para[256];
-static const char * const fw_path[] = {
-	fw_path_para,
-	"/lib/firmware/updates/" UTS_RELEASE,
-	"/lib/firmware/updates",
-	"/lib/firmware/" UTS_RELEASE,
-	"/lib/firmware"
-};
+static const char * const fw_paths =
+#ifdef CONFIG_FW_CUSTOMIZED_PATH
+	CONFIG_FW_CUSTOMIZED_PATH ";"
+#endif
+	"/lib/firmware/updates/" UTS_RELEASE ";"
+	"/lib/firmware/updates;"
+	"/lib/firmware/" UTS_RELEASE ";"
+	"/lib/firmware";

 /*
  * Typical usage is that passing 'firmware_class.path=$CUSTOMIZED_PATH'
@@ -314,30 +315,66 @@ static bool fw_read_file_contents(struct file
*file, struct firmware_buf *fw_buf
 	return true;
 }

-static bool fw_get_filesystem_firmware(struct device *device,
-				       struct firmware_buf *buf)
+static bool fw_get_file_firmware(const char *path,
+				 struct firmware_buf *buf)
 {
-	int i;
-	bool success = false;
-	char *path = __getname();
+	struct file *file;
+	bool success;
+
+	file = filp_open(path, O_RDONLY, 0);
+	if (IS_ERR(file))
+		return false;
+	success = fw_read_file_contents(file, buf);
+	fput(file);

-	for (i = 0; i < ARRAY_SIZE(fw_path); i++) {
-		struct file *file;
+	return success;
+}

-		/* skip the unset customized path */
-		if (!fw_path[i][0])
-			continue;
+/* The path in @paths is seperated by ';' */
+static bool fw_get_fw_file_from_paths(const char *paths, char *path,
+				      struct firmware_buf *buf)
+{
+	int len, start, end = -1;
+	char *pos;
+
+	if (!paths[0])
+		return false;

-		snprintf(path, PATH_MAX, "%s/%s", fw_path[i], buf->fw_id);
+	do {
+		start = end + 1;
+		pos = strchr(&paths[start], ';');
+		if (pos) {
+			end = (int)(pos - paths);
+			len = end - start;
+		} else {
+			len = strlen(&paths[start]);
+		}

-		file = filp_open(path, O_RDONLY, 0);
-		if (IS_ERR(file))
+		if (len <= 0 || PATH_MAX < len + strlen(buf->fw_id))
 			continue;
-		success = fw_read_file_contents(file, buf);
-		fput(file);
-		if (success)
-			break;
-	}
+		strncpy(path, &paths[start], len);
+		snprintf(&path[len], PATH_MAX - len, "/%s", buf->fw_id);
+		/* don't search relative path */
+		if (strstr(path, ".."))
+			continue;
+
+		if (fw_get_file_firmware(path, buf))
+			return true;
+	} while (pos && end < strlen(paths) - 1);
+
+	return false;
+}
+
+static bool fw_get_filesystem_firmware(struct device *device,
+				       struct firmware_buf *buf)
+{
+	bool success = false;
+	char *path = __getname();
+
+	/* search runtime paths first, then static pre-defined paths */
+	success = fw_get_fw_file_from_paths(fw_path_para, path, buf);
+	if (!success)
+		success = fw_get_fw_file_from_paths(fw_paths, path, buf);
 	__putname(path);

 	if (success) {
-- 
1.7.9.5


Thanks,
--
Ming Lei
