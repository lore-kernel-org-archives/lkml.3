Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932757Ab3FFLxI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Jun 2013 07:53:08 -0400
Received: from mail-pb0-f43.google.com ([209.85.160.43]:44292 "EHLO
	mail-pb0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754752Ab3FFLxG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Jun 2013 07:53:06 -0400
From: Ming Lei <ming.lei@canonical.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, Ming Lei <ming.lei@canonical.com>
Subject: [PATCH] firmware loader: fix compile warning
Date: Thu,  6 Jun 2013 19:52:54 +0800
Message-Id: <1370519574-32107-1-git-send-email-ming.lei@canonical.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The commit ddf1f0648e8c("firmware loader: fix build failure
with !CONFIG_FW_LOADER_USER_HELPER") introduces the below
warning:

drivers/base/firmware_class.c:921:13: warning:
'kill_requests_without_uevent' defined but not used [-Wunused-function]

So fix it by defining kill_requests_without_uevent() only if
CONFIG_PM_SLEEP is set.

Reported-by: Stephen Rothwell <sfr@canb.auug.org.au>
Signed-off-by: Ming Lei <ming.lei@canonical.com>
---
 drivers/base/firmware_class.c |    4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/base/firmware_class.c b/drivers/base/firmware_class.c
index c31fc29..47e3a22 100644
--- a/drivers/base/firmware_class.c
+++ b/drivers/base/firmware_class.c
@@ -917,6 +917,7 @@ static int fw_load_from_user_helper(struct firmware *firmware,
 	return _request_firmware_load(fw_priv, uevent, timeout);
 }
 
+#ifdef CONFIG_PM_SLEEP
 /* kill pending requests without uevent to avoid blocking suspend */
 static void kill_requests_without_uevent(void)
 {
@@ -930,6 +931,7 @@ static void kill_requests_without_uevent(void)
 	}
 	mutex_unlock(&fw_lock);
 }
+#endif
 
 #else /* CONFIG_FW_LOADER_USER_HELPER */
 static inline int
@@ -943,7 +945,9 @@ fw_load_from_user_helper(struct firmware *firmware, const char *name,
 /* No abort during direct loading */
 #define is_fw_load_aborted(buf) false
 
+#ifdef CONFIG_PM_SLEEP
 static inline void kill_requests_without_uevent(void) { }
+#endif
 
 #endif /* CONFIG_FW_LOADER_USER_HELPER */
 
-- 
1.7.9.5

