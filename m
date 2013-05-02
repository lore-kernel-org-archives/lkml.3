Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933028Ab3EBUp1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 May 2013 16:45:27 -0400
Received: from mail-oa0-f54.google.com ([209.85.219.54]:52571 "EHLO
	mail-oa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758893Ab3EBUpZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 May 2013 16:45:25 -0400
Message-ID: <5182D128.6090408@gmail.com>
Date: Thu, 02 May 2013 15:48:40 -0500
From: Chris Fries <ccfries@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.26) Gecko/20120131 Thunderbird/3.1.18
MIME-Version: 1.0
To: c.fries@motorola.com, jason.hrycay@motorola.com,
        linux-f2fs-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org,
        jaegeuk.kim@samsung.com
Subject: [PATCH 1/2] f2fs: Continue to mount after failing recovery
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Chris Fries <C.Fries@motorola.com>

When unable to roll forward the journal, we shouldn't bail out and
not mount, we should continue to attempt the mount.  Bad recovery data
is likely unrecoverable at this point, and requiring the user to try
to mount again doesn't solve any issues.

Signed-off-by: Chris Fries <C.Fries@motorola.com>
Reviewed-by: Russell Knize <rknize2@motorola.com>
Reviewed-by: Jason Hrycay <jason.hrycay@motorola.com>
---
  fs/f2fs/super.c | 7 +++----
  1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/fs/f2fs/super.c b/fs/f2fs/super.c
index 2643c49..d8f7ed3 100644
--- a/fs/f2fs/super.c
+++ b/fs/f2fs/super.c
@@ -649,10 +649,9 @@ static int f2fs_fill_super(struct super_block *sb, 
void *data, int silent)
      /* recover fsynced data */
      if (!test_opt(sbi, DISABLE_ROLL_FORWARD)) {
          err = recover_fsync_data(sbi);
-        if (err) {
-            f2fs_msg(sb, KERN_ERR, "Failed to recover fsync data");
-            goto free_root_inode;
-        }
+        if (err)
+            f2fs_msg(sb, KERN_ERR,
+                "Cannot recover all fsync data, continue\n");
      }

      /* After POR, we can run background GC thread */
-- 
1.8.0

