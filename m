Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759697Ab3FDCDH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Jun 2013 22:03:07 -0400
Received: from mail-pd0-f174.google.com ([209.85.192.174]:52212 "EHLO
	mail-pd0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758548Ab3FDCDF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Jun 2013 22:03:05 -0400
From: Ming Lei <ming.lei@canonical.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, Ming Lei <ming.lei@canonical.com>
Subject: [PATCH] firmware loader: fix build failure with !CONFIG_FW_LOADER_USER_HELPER
Date: Tue,  4 Jun 2013 10:01:13 +0800
Message-Id: <1370311273-18262-1-git-send-email-ming.lei@canonical.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fixes one build failure which is introduced by the patch
below:

	driver core: firmware loader: kill FW_ACTION_NOHOTPLUG requests
	before suspend

When CONFIG_FW_LOADER_USER_HELPER is unset, kill_requests_without_uevent()
should be nop because no userspace loading is involved.

Reported-by: kbuild test robot <fengguang.wu@intel.com>
Signed-off-by: Ming Lei <ming.lei@canonical.com>
---
 drivers/base/firmware_class.c |   31 +++++++++++++++++--------------
 1 file changed, 17 insertions(+), 14 deletions(-)

diff --git a/drivers/base/firmware_class.c b/drivers/base/firmware_class.c
index c415043..c31fc29 100644
--- a/drivers/base/firmware_class.c
+++ b/drivers/base/firmware_class.c
@@ -916,6 +916,21 @@ static int fw_load_from_user_helper(struct firmware *firmware,
 	fw_priv->buf = firmware->priv;
 	return _request_firmware_load(fw_priv, uevent, timeout);
 }
+
+/* kill pending requests without uevent to avoid blocking suspend */
+static void kill_requests_without_uevent(void)
+{
+	struct firmware_buf *buf;
+	struct firmware_buf *next;
+
+	mutex_lock(&fw_lock);
+	list_for_each_entry_safe(buf, next, &pending_fw_head, pending_list) {
+		if (!buf->need_uevent)
+			 fw_load_abort(buf);
+	}
+	mutex_unlock(&fw_lock);
+}
+
 #else /* CONFIG_FW_LOADER_USER_HELPER */
 static inline int
 fw_load_from_user_helper(struct firmware *firmware, const char *name,
@@ -928,6 +943,8 @@ fw_load_from_user_helper(struct firmware *firmware, const char *name,
 /* No abort during direct loading */
 #define is_fw_load_aborted(buf) false
 
+static inline void kill_requests_without_uevent(void) { }
+
 #endif /* CONFIG_FW_LOADER_USER_HELPER */
 
 
@@ -1414,20 +1431,6 @@ static void __device_uncache_fw_images(void)
 	spin_unlock(&fwc->name_lock);
 }
 
-/* kill pending requests without uevent to avoid blocking suspend */
-static void kill_requests_without_uevent(void)
-{
-	struct firmware_buf *buf;
-	struct firmware_buf *next;
-
-	mutex_lock(&fw_lock);
-	list_for_each_entry_safe(buf, next, &pending_fw_head, pending_list) {
-		if (!buf->need_uevent)
-			 fw_load_abort(buf);
-	}
-	mutex_unlock(&fw_lock);
-}
-
 /**
  * device_cache_fw_images - cache devices' firmware
  *
-- 
1.7.9.5

