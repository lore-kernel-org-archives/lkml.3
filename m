Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757218Ab3A2OrB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jan 2013 09:47:01 -0500
Received: from cantor2.suse.de ([195.135.220.15]:59359 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757068Ab3A2Oq7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jan 2013 09:46:59 -0500
From: Takashi Iwai <tiwai@suse.de>
To: Ming Lei <ming.lei@canonical.com>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 4/4] firmware: Ignore abort check when no user-helper is used
Date: Tue, 29 Jan 2013 15:46:54 +0100
Message-Id: <1359470814-7993-5-git-send-email-tiwai@suse.de>
X-Mailer: git-send-email 1.8.1.1
In-Reply-To: <1359470814-7993-1-git-send-email-tiwai@suse.de>
References: <1359470814-7993-1-git-send-email-tiwai@suse.de>
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
index 8c40257..9753a78 100644
--- a/drivers/base/firmware_class.c
+++ b/drivers/base/firmware_class.c
@@ -447,6 +447,9 @@ static void fw_load_abort(struct firmware_priv *fw_priv)
 	complete_all(&buf->completion);
 }
 
+#define is_fw_load_aborted(buf)	\
+	test_bit(FW_STATUS_ABORT, &(buf)->status)
+
 static int loading_timeout = 60;	/* In seconds */
 
 static inline long firmware_loading_timeout(void)
@@ -914,6 +917,10 @@ fw_load_from_user_helper(struct firmware *firmware, const char *name,
 {
 	return -ENOENT;
 }
+
+/* No abort during direct loading */
+#define is_fw_load_aborted(buf) false
+
 #endif /* CONFIG_FW_LOADER_USER_HELPER */
 
 
@@ -924,7 +931,7 @@ static int sync_cached_firmware_buf(struct firmware_buf *buf)
 
 	mutex_lock(&fw_lock);
 	while (!test_bit(FW_STATUS_DONE, &buf->status)) {
-		if (test_bit(FW_STATUS_ABORT, &buf->status)) {
+		if (is_fw_load_aborted(buf)) {
 			ret = -ENOENT;
 			break;
 		}
@@ -986,7 +993,7 @@ static int assign_firmware_buf(struct firmware *fw, struct device *device)
 	struct firmware_buf *buf = fw->priv;
 
 	mutex_lock(&fw_lock);
-	if (!buf->size || test_bit(FW_STATUS_ABORT, &buf->status)) {
+	if (!buf->size || is_fw_load_aborted(buf)) {
 		mutex_unlock(&fw_lock);
 		return -ENOENT;
 	}
-- 
1.8.1.1

