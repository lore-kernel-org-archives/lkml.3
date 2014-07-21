Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933572AbaGUTHk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jul 2014 15:07:40 -0400
Received: from smtp.outflux.net ([198.145.64.163]:48599 "EHLO smtp.outflux.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933431AbaGUTGw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jul 2014 15:06:52 -0400
From: Kees Cook <keescook@chromium.org>
To: linux-kernel@vger.kernel.org
Cc: Kees Cook <keescook@chromium.org>,
        James Morris <james.l.morris@oracle.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Ming Lei <ming.lei@canonical.com>,
        linux-security-module@vger.kernel.org
Subject: [PATCH v2 2/2] firmware_class: perform new LSM checks
Date: Mon, 21 Jul 2014 12:06:41 -0700
Message-Id: <1405969601-4234-3-git-send-email-keescook@chromium.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1405969601-4234-1-git-send-email-keescook@chromium.org>
References: <1405969601-4234-1-git-send-email-keescook@chromium.org>
X-HELO: www.outflux.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This attaches LSM hooks to the existing firmware loading interfaces:
filesystem-found firmware and demand-loaded blobs.

Signed-off-by: Kees Cook <keescook@chromium.org>
Acked-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/base/firmware_class.c |   16 ++++++++++++++--
 1 file changed, 14 insertions(+), 2 deletions(-)

diff --git a/drivers/base/firmware_class.c b/drivers/base/firmware_class.c
index d276e33880be..7399bab71ced 100644
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
@@ -640,6 +646,12 @@ static ssize_t firmware_loading_store(struct device *dev,
 		break;
 	case 0:
 		if (test_bit(FW_STATUS_LOADING, &fw_buf->status)) {
+			if (security_kernel_fw_from_file(NULL, fw_buf->data,
+							 fw_buf->size)) {
+				fw_load_abort(fw_priv);
+				break;
+			}
+
 			set_bit(FW_STATUS_DONE, &fw_buf->status);
 			clear_bit(FW_STATUS_LOADING, &fw_buf->status);
 
-- 
1.7.9.5

