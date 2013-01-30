Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754894Ab3A3Kf0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jan 2013 05:35:26 -0500
Received: from cantor2.suse.de ([195.135.220.15]:41751 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754841Ab3A3KfX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jan 2013 05:35:23 -0500
From: Takashi Iwai <tiwai@suse.de>
To: Ming Lei <ming.lei@canonical.com>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 4/4] firmware: Ignore abort check when no user-helper is used
Date: Wed, 30 Jan 2013 11:35:09 +0100
Message-Id: <1359542109-3043-5-git-send-email-tiwai@suse.de>
X-Mailer: git-send-email 1.8.1.1
In-Reply-To: <1359542109-3043-1-git-send-email-tiwai@suse.de>
References: <1359542109-3043-1-git-send-email-tiwai@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

FW_STATUS_ABORT can be set only during the user-helper invocation,
thus we can ignore the check when CONFIG_HW_LOADER_USER_HELPER is
disabled.

Signed-off-by: Takashi Iwai <tiwai@suse.de>
---
 drivers/base/firmware_class.c | 11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

diff --git a/drivers/base/firmware_class.c b/drivers/base/firmware_class.c
index ff631ef..f1caad7 100644
--- a/drivers/base/firmware_class.c
+++ b/drivers/base/firmware_class.c
@@ -454,6 +454,9 @@ static void fw_load_abort(struct firmware_priv *fw_priv)
 	complete_all(&buf->completion);
 }
 
+#define is_fw_load_aborted(buf)	\
+	test_bit(FW_STATUS_ABORT, &(buf)->status)
+
 static ssize_t firmware_timeout_show(struct class *class,
 				     struct class_attribute *attr,
 				     char *buf)
@@ -891,6 +894,10 @@ fw_load_from_user_helper(struct firmware *firmware, const char *name,
 {
 	return -ENOENT;
 }
+
+/* No abort during direct loading */
+#define is_fw_load_aborted(buf) false
+
 #endif /* CONFIG_FW_LOADER_USER_HELPER */
 
 
@@ -901,7 +908,7 @@ static int sync_cached_firmware_buf(struct firmware_buf *buf)
 
 	mutex_lock(&fw_lock);
 	while (!test_bit(FW_STATUS_DONE, &buf->status)) {
-		if (test_bit(FW_STATUS_ABORT, &buf->status)) {
+		if (is_fw_load_aborted(buf)) {
 			ret = -ENOENT;
 			break;
 		}
@@ -963,7 +970,7 @@ static int assign_firmware_buf(struct firmware *fw, struct device *device)
 	struct firmware_buf *buf = fw->priv;
 
 	mutex_lock(&fw_lock);
-	if (!buf->size || test_bit(FW_STATUS_ABORT, &buf->status)) {
+	if (!buf->size || is_fw_load_aborted(buf)) {
 		mutex_unlock(&fw_lock);
 		return -ENOENT;
 	}
-- 
1.8.1.1

