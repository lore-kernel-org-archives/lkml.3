Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761859Ab3EBUrA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 May 2013 16:47:00 -0400
Received: from mail-oa0-f41.google.com ([209.85.219.41]:59444 "EHLO
	mail-oa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755048Ab3EBUq5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 May 2013 16:46:57 -0400
Message-ID: <5182D186.7060306@gmail.com>
Date: Thu, 02 May 2013 15:50:14 -0500
From: Chris Fries <ccfries@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.26) Gecko/20120131 Thunderbird/3.1.18
MIME-Version: 1.0
To: jason.hrycay@motorola.com, c.fries@motorola.com, jaegeuk.kim@samsung.com,
        linux-f2fs-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: [PATCH 2/2] f2fs: Recover when journal contains deleted files
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Chris Fries <C.Fries@motorola.com>

When recovering a journal file with fsync data for files that have
been deleted, don't bail out on recovery.

Signed-off-by: Chris Fries <C.Fries@motorola.com>
Reviewed-by: Russell Knize <rknize2@motorola.com>
Reviewed-by: Jason Hrycay <jason.hrycay@motorola.com>
---
  fs/f2fs/recovery.c | 9 +++++++--
  1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/fs/f2fs/recovery.c b/fs/f2fs/recovery.c
index f16d12d..c3a7ab0 100644
--- a/fs/f2fs/recovery.c
+++ b/fs/f2fs/recovery.c
@@ -53,7 +53,7 @@ static int recover_dentry(struct page *ipage, struct 
inode *inode)

      dir = f2fs_iget(inode->i_sb, le32_to_cpu(raw_inode->i_pino));
      if (IS_ERR(dir)) {
-        err = -EINVAL;
+        err = PTR_ERR(dir);
          goto out;
      }

@@ -157,7 +157,12 @@ static int find_fsync_dnodes(struct f2fs_sb_info 
*sbi, struct list_head *head)
          if (IS_INODE(page)) {
              err = recover_inode(entry->inode, page);
              if (err)
-                goto unlock_out;
+                if (err == -ENOENT)
+                    goto next;
+                else {
+                    err = -EINVAL;
+                    goto unlock_out;
+                }
          }
  next:
          /* check next segment */
-- 
1.8.0

