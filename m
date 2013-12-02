Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752807Ab3LBNQQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Dec 2013 08:16:16 -0500
Received: from mail-pd0-f180.google.com ([209.85.192.180]:45286 "EHLO
	mail-pd0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751696Ab3LBNQN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Dec 2013 08:16:13 -0500
Message-ID: <529C8818.2090002@gmail.com>
Date: Mon, 02 Dec 2013 21:16:08 +0800
From: Younger Liu <younger.liucn@gmail.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:24.0) Gecko/20100101 Thunderbird/24.1.1
MIME-Version: 1.0
To: Jaegeuk Kim <jaegeuk.kim@samsung.com>
CC: f2fs <linux-f2fs-devel@lists.sourceforge.net>,
        kernel <linux-kernel@vger.kernel.org>,
        fs-devel <linux-fsdevel@vger.kernel.org>
Subject: [PATCH 0/2] f2fs: remove debufs dir if debugfs_create_file() failed
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Younger Liu <liuyiyang@hisense.com>

When debugfs_create_file() failed in f2fs_create_root_stats(),
debugfs_root should be removed.

Signed-off-by: Younger Liu <liuyiyang@hisense.com>
Cc: Younger Liu <younger.liucn@gmail.com>
Cc: Jaegeuk Kim <jaegeuk.kim@samsung.com>
---
 fs/f2fs/debug.c |   20 +++++++++++++++++---
 1 file changed, 17 insertions(+), 3 deletions(-)

diff --git a/fs/f2fs/debug.c b/fs/f2fs/debug.c
index a84b0a8..d27b689 100644
--- a/fs/f2fs/debug.c
+++ b/fs/f2fs/debug.c
@@ -340,10 +340,24 @@ void f2fs_destroy_stats(struct f2fs_sb_info *sbi)
 
 void __init f2fs_create_root_stats(void)
 {
+    struct dentry *file;
+
     debugfs_root = debugfs_create_dir("f2fs", NULL);
-    if (debugfs_root)
-        debugfs_create_file("status", S_IRUGO, debugfs_root,
-                     NULL, &stat_fops);
+    if (!debugfs_root)
+        goto bail;
+
+    file = debugfs_create_file("status", S_IRUGO,
+            debugfs_root, NULL, &stat_fops);
+    if (!file)
+        goto free_debugfs_dir;
+
+    return;
+
+free_debugfs_dir:
+    debugfs_remove(debugfs_root);
+
+bail:
+    return;
 }
 
 void f2fs_destroy_root_stats(void)
-- 
1.7.9.5


