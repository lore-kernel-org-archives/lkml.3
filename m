Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752707Ab3EMDmX (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 May 2013 23:42:23 -0400
Received: from mail-ia0-f169.google.com ([209.85.210.169]:60132 "EHLO
	mail-ia0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751929Ab3EMDmV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 May 2013 23:42:21 -0400
Message-ID: <51906213.2020005@gmail.com>
Date: Sun, 12 May 2013 22:46:27 -0500
From: Chris Fries <ccfries@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.26) Gecko/20120131 Thunderbird/3.1.18
MIME-Version: 1.0
To: jaegeuk.kim@samsung.com, linux-f2fs-devel@lists.sourceforge.net,
        linux-kernel@vger.kernel.org, rknize2@motorola.com,
        jason.hrycay@motorola.com
Subject: [PATCH] f2fs: Remove BUG_ON in dec_valid_node_count
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Chris Fries <C.Fries@motorola.com>

Panic loops while running LTP fsstress has been able to get
a disk into two different panic loops from dec_valid_node_count.
f2fs.h:714  BUG_ON(sbi->total_valid_node_count < count);

Once, it happens during recovery itself, and the disk would cause
a panic every time it mounted.

Another time, it would happen during garbage collection, so the disk
would cause a panic within 200 seconds of mounting.

Removing this BUG_ON hasn't shown any side effects, so let's take it
out and monitor.

Signed-off-by: Chris Fries <C.Fries@motorola.com>

---
 fs/f2fs/f2fs.h | 18 +++++++++++++++---
 1 file changed, 15 insertions(+), 3 deletions(-)

diff --git a/fs/f2fs/f2fs.h b/fs/f2fs/f2fs.h
index e80a87c..b8e9679 100644
--- a/fs/f2fs/f2fs.h
+++ b/fs/f2fs/f2fs.h
@@ -722,9 +722,21 @@ static inline void dec_valid_node_count(struct f2fs_sb_info *sbi,
 {
 	spin_lock(&sbi->stat_lock);
 
-	BUG_ON(sbi->total_valid_block_count < count);
-	BUG_ON(sbi->total_valid_node_count < count);
-	BUG_ON(inode->i_blocks < count);
+	if (sbi->total_valid_block_count < count) {
+		WARN(1, "F2FS: total_valid_block_count too small- %d vs %d\n",
+			(unsigned int)sbi->total_valid_block_count, count);
+		count = sbi->total_valid_block_count;
+	}
+	if (sbi->total_valid_node_count < count) {
+		WARN(1, "F2FS: total_valid_node_count too small- %d vs %d\n",
+			sbi->total_valid_node_count, count);
+		count = sbi->total_valid_node_count;
+	}
+	if (inode->i_blocks < count) {
+		WARN(1, "F2FS: inode->i_blocks too small - %d vs %d\n",
+			(unsigned int)inode->i_blocks, count);
+		count = sbi->total_valid_node_count;
+	}
 
 	inode->i_blocks -= count;
 	sbi->total_valid_node_count -= count;
-- 
1.8.0

