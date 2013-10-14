Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756287Ab3JNKxA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Oct 2013 06:53:00 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:45327 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1755807Ab3JNKw7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Oct 2013 06:52:59 -0400
X-IronPort-AV: E=Sophos;i="4.93,491,1378828800"; 
   d="scan'208";a="8751305"
Message-ID: <525BCBAF.1010003@cn.fujitsu.com>
Date: Mon, 14 Oct 2013 18:47:11 +0800
From: Gu Zheng <guz.fnst@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:7.0.1) Gecko/20110930 Thunderbird/7.0.1
MIME-Version: 1.0
To: Kim <jaegeuk.kim@samsung.com>
CC: f2fs <linux-f2fs-devel@lists.sourceforge.net>,
        fsdevel <linux-fsdevel@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH RESEND] f2fs: introduce function read_raw_super_block()
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/10/14 18:50:20,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/10/14 18:50:21,
	Serialize complete at 2013/10/14 18:50:21
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Introduce function read_raw_super_block() to hide reading raw super block and
the retry routine if the first sb is invalid.

Signed-off-by: Gu Zheng <guz.fnst@cn.fujitsu.com>
---
 fs/f2fs/super.c |   54 +++++++++++++++++++++++++++++++++---------------------
 1 files changed, 33 insertions(+), 21 deletions(-)

diff --git a/fs/f2fs/super.c b/fs/f2fs/super.c
index 3b786c8..5e913de 100644
--- a/fs/f2fs/super.c
+++ b/fs/f2fs/super.c
@@ -746,30 +746,46 @@ static void init_sb_info(struct f2fs_sb_info *sbi)
 		atomic_set(&sbi->nr_pages[i], 0);
 }
 
-static int validate_superblock(struct super_block *sb,
-		struct f2fs_super_block **raw_super,
-		struct buffer_head **raw_super_buf, sector_t block)
+/* Read f2fs raw super block.
+ * Because we have two copies of super block, so read the first one at first,
+ * if the first one is invalid, move to read the second one.
+ */
+static int read_raw_super_block(struct super_block *sb,
+			struct f2fs_super_block **raw_super,
+			struct buffer_head **raw_super_buf)
 {
-	const char *super = (block == 0 ? "first" : "second");
+	int block = 0;
 
-	/* read f2fs raw super block */
+retry:
 	*raw_super_buf = sb_bread(sb, block);
 	if (!*raw_super_buf) {
-		f2fs_msg(sb, KERN_ERR, "unable to read %s superblock",
-				super);
-		return -EIO;
+		f2fs_msg(sb, KERN_ERR, "Unable to read %dth superblock",
+				block + 1);
+		if (block == 0) {
+			block++;
+			goto retry;
+		} else {
+			return -EIO;
+		}
 	}
 
 	*raw_super = (struct f2fs_super_block *)
 		((char *)(*raw_super_buf)->b_data + F2FS_SUPER_OFFSET);
 
 	/* sanity checking of raw super */
-	if (!sanity_check_raw_super(sb, *raw_super))
-		return 0;
+	if (sanity_check_raw_super(sb, *raw_super)) {
+		brelse(*raw_super_buf);
+		f2fs_msg(sb, KERN_ERR, "Can't find a valid F2FS filesystem "
+				"in %dth superblock", block + 1);
+		if(block == 0) {
+			block++;
+			goto retry;
+		} else {
+			return -EINVAL;
+		}
+	}
 
-	f2fs_msg(sb, KERN_ERR, "Can't find a valid F2FS filesystem "
-				"in %s superblock", super);
-	return -EINVAL;
+	return 0;
 }
 
 static int f2fs_fill_super(struct super_block *sb, void *data, int silent)
@@ -791,14 +807,10 @@ static int f2fs_fill_super(struct super_block *sb, void *data, int silent)
 		goto free_sbi;
 	}
 
-	err = validate_superblock(sb, &raw_super, &raw_super_buf, 0);
-	if (err) {
-		brelse(raw_super_buf);
-		/* check secondary superblock when primary failed */
-		err = validate_superblock(sb, &raw_super, &raw_super_buf, 1);
-		if (err)
-			goto free_sb_buf;
-	}
+	err = read_raw_super_block(sb, &raw_super, &raw_super_buf);
+	if (err)
+		goto free_sbi;
+
 	sb->s_fs_info = sbi;
 	/* init some FS parameters */
 	sbi->active_logs = NR_CURSEG_TYPE;
-- 
1.7.7

