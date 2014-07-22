Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756419AbaGVS33 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2014 14:29:29 -0400
Received: from smtp.outflux.net ([198.145.64.163]:51729 "EHLO smtp.outflux.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755832AbaGVS32 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2014 14:29:28 -0400
From: Kees Cook <keescook@chromium.org>
To: linux-kernel@vger.kernel.org
Cc: Kees Cook <keescook@chromium.org>, Ming Lei <ming.lei@canonical.com>,
        Takashi Iwai <tiwai@suse.de>, James Morris <james.l.morris@oracle.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-security-module@vger.kernel.org
Subject: [PATCH v3 2/2] firmware_class: perform new LSM checks
Date: Tue, 22 Jul 2014 11:29:01 -0700
Message-Id: <1406053741-22795-3-git-send-email-keescook@chromium.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1406053741-22795-1-git-send-email-keescook@chromium.org>
References: <1406053741-22795-1-git-send-email-keescook@chromium.org>
X-HELO: www.outflux.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This attaches LSM hooks to the existing firmware loading interfaces:
filesystem-found firmware and demand-loaded blobs. On errors, loads
are aborted and the failure code is returned to userspace.

Signed-off-by: Kees Cook <keescook@chromium.org>
Acked-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/base/firmware_class.c |   30 ++++++++++++++++++++++++++----
 1 file changed, 26 insertions(+), 4 deletions(-)

diff --git a/drivers/base/firmware_class.c b/drivers/base/firmware_class.c
index d276e33880be..63f165c59da8 100644
--- a/drivers/base/firmware_class.c
+++ b/drivers/base/firmware_class.c
@@ -28,6 +28,7 @@
 #include <linux/suspend.h>
 #include <linux/syscore_ops.h>
 #include <linux/reboot.h>
+#include <linux/security.h>
 
 #include <generated/utsrelease.h>
 
@@ -308,12 +309,17 @@ static int fw_read_file_contents(struct file *file, struct firmware_buf *fw_buf)
 	if (rc != size) {
 		if (rc > 0)
 			rc = -EIO;
-		vfree(buf);
-		return rc;
+		goto fail;
 	}
+	rc = security_kernel_fw_from_file(file, buf, size);
+	if (rc)
+		goto fail;
 	fw_buf->data = buf;
 	fw_buf->size = size;
 	return 0;
+fail:
+	vfree(buf);
+	return rc;
 }
 
 static int fw_get_filesystem_firmware(struct device *device,
@@ -617,6 +623,7 @@ static ssize_t firmware_loading_store(struct device *dev,
 {
 	struct firmware_priv *fw_priv = to_firmware_priv(dev);
 	struct firmware_buf *fw_buf;
+	ssize_t written = count;
 	int loading = simple_strtol(buf, NULL, 10);
 	int i;
 
@@ -640,6 +647,8 @@ static ssize_t firmware_loading_store(struct device *dev,
 		break;
 	case 0:
 		if (test_bit(FW_STATUS_LOADING, &fw_buf->status)) {
+			int rc;
+
 			set_bit(FW_STATUS_DONE, &fw_buf->status);
 			clear_bit(FW_STATUS_LOADING, &fw_buf->status);
 
@@ -649,10 +658,23 @@ static ssize_t firmware_loading_store(struct device *dev,
 			 * see the mapped 'buf->data' once the loading
 			 * is completed.
 			 * */
-			if (fw_map_pages_buf(fw_buf))
+			rc = fw_map_pages_buf(fw_buf);
+			if (rc)
 				dev_err(dev, "%s: map pages failed\n",
 					__func__);
+			else
+				rc = security_kernel_fw_from_file(NULL,
+						fw_buf->data, fw_buf->size);
+
+			/*
+			 * Same logic as fw_load_abort, only the DONE bit
+			 * is ignored and we set ABORT only on failure.
+			 */
 			list_del_init(&fw_buf->pending_list);
+			if (rc) {
+				set_bit(FW_STATUS_ABORT, &fw_buf->status);
+				written = rc;
+			}
 			complete_all(&fw_buf->completion);
 			break;
 		}
@@ -666,7 +688,7 @@ static ssize_t firmware_loading_store(struct device *dev,
 	}
 out:
 	mutex_unlock(&fw_lock);
-	return count;
+	return written;
 }
 
 static DEVICE_ATTR(loading, 0644, firmware_loading_show, firmware_loading_store);
-- 
1.7.9.5

