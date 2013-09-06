Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751857Ab3IFTgh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Sep 2013 15:36:37 -0400
Received: from charlotte.tuxdriver.com ([70.61.120.58]:58859 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750760Ab3IFTgg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Sep 2013 15:36:36 -0400
From: Neil Horman <nhorman@tuxdriver.com>
To: linux-kernel@vger.kernel.org
Cc: Neil Horman <nhorman@tuxdriver.com>, Ming Lei <ming.lei@canonical.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH] firmware: Be a bit more verbose about direct firmware loading failure
Date: Fri,  6 Sep 2013 15:36:08 -0400
Message-Id: <1378496168-3684-1-git-send-email-nhorman@tuxdriver.com>
X-Mailer: git-send-email 1.8.1.4
X-Spam-Score: -2.9 (--)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The direct firmware loading interface is a bit quiet about failures.  Failures
that occur during loading are masked if firmware exists in multiple locations,
and may be masked entirely in the event that we fall back to the user mode
helper code.  It would be nice to see some of the more unexpected errors get
logged, so in the event that you expect the direct firmware loader to work (like
if CONFIG_FW_LOADER_USER_HELPER is enabled), and something goes wrong, you can
figure out what happened.

Signed-off-by: Neil Horman <nhorman@tuxdriver.com>
CC: Ming Lei <ming.lei@canonical.com>
CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/base/firmware_class.c | 38 +++++++++++++++++++++++++-------------
 1 file changed, 25 insertions(+), 13 deletions(-)

diff --git a/drivers/base/firmware_class.c b/drivers/base/firmware_class.c
index 10a4467..eb8fb94 100644
--- a/drivers/base/firmware_class.c
+++ b/drivers/base/firmware_class.c
@@ -282,31 +282,35 @@ static noinline_for_stack long fw_file_size(struct file *file)
 	return st.size;
 }
 
-static bool fw_read_file_contents(struct file *file, struct firmware_buf *fw_buf)
+static int fw_read_file_contents(struct file *file, struct firmware_buf *fw_buf)
 {
 	long size;
 	char *buf;
+	int rc;
 
 	size = fw_file_size(file);
 	if (size <= 0)
-		return false;
+		return -EINVAL;
 	buf = vmalloc(size);
 	if (!buf)
-		return false;
-	if (kernel_read(file, 0, buf, size) != size) {
+		return -ENOMEM;
+	rc = kernel_read(file, 0, buf, size);
+	if (rc != size) {
+		if (rc > 0)
+			rc = -EIO;
 		vfree(buf);
-		return false;
+		return rc;
 	}
 	fw_buf->data = buf;
 	fw_buf->size = size;
-	return true;
+	return 0;
 }
 
-static bool fw_get_filesystem_firmware(struct device *device,
+static int fw_get_filesystem_firmware(struct device *device,
 				       struct firmware_buf *buf)
 {
 	int i;
-	bool success = false;
+	int rc = -ENOENT;
 	char *path = __getname();
 
 	for (i = 0; i < ARRAY_SIZE(fw_path); i++) {
@@ -321,14 +325,17 @@ static bool fw_get_filesystem_firmware(struct device *device,
 		file = filp_open(path, O_RDONLY, 0);
 		if (IS_ERR(file))
 			continue;
-		success = fw_read_file_contents(file, buf);
+		rc = fw_read_file_contents(file, buf);
 		fput(file);
-		if (success)
+		if (rc)
+			dev_warn(device, "firmware, attempted to load %s, but failed with error %d\n",
+				path, rc);
+		else
 			break;
 	}
 	__putname(path);
 
-	if (success) {
+	if (!rc) {
 		dev_dbg(device, "firmware: direct-loading firmware %s\n",
 			buf->fw_id);
 		mutex_lock(&fw_lock);
@@ -337,7 +344,7 @@ static bool fw_get_filesystem_firmware(struct device *device,
 		mutex_unlock(&fw_lock);
 	}
 
-	return success;
+	return rc;
 }
 
 /* firmware holds the ownership of pages */
@@ -1086,9 +1093,14 @@ _request_firmware(const struct firmware **firmware_p, const char *name,
 		}
 	}
 
-	if (!fw_get_filesystem_firmware(device, fw->priv))
+	ret = fw_get_filesystem_firmware(device, fw->priv);
+	if (ret) {
+		dev_warn(device, "Direct firmware load failed with error %d\n",
+			 ret);
+		dev_warn(device, "Falling back to user helper\n");
 		ret = fw_load_from_user_helper(fw, name, device,
 					       uevent, nowait, timeout);
+	}
 
 	/* don't cache firmware handled without uevent */
 	if (!ret)
-- 
1.8.1.4

