Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753369AbbAZFyv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jan 2015 00:54:51 -0500
Received: from mailout4.samsung.com ([203.254.224.34]:58847 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751810AbbAZFys (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jan 2015 00:54:48 -0500
X-AuditID: cbfee61b-f79d76d0000024d6-20-54c5d6a63210
From: Chao Yu <chao2.yu@samsung.com>
To: Jaegeuk Kim <jaegeuk@kernel.org>, Changman Lee <cm224.lee@samsung.com>
Cc: linux-f2fs-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: [f2fs-dev][PATCH v2 07/10] f2fs: add a mount option for rb-tree extent
 cache
Date: Mon, 26 Jan 2015 13:53:14 +0800
Message-id: <006301d0392c$96dec330$c49c4990$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-index: AdA5EFvFaIzM7Q04R1y6T3OW90W4Ow==
Content-language: zh-cn
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrMLMWRmVeSWpSXmKPExsVy+t9jQd1l146GGOy8r29xbV8jk8WT9bOY
	LS4tcre4vGsOmwOLx6ZVnWweuxd8ZvLo27KK0ePzJrkAligum5TUnMyy1CJ9uwSujPsLvjAX
	XBWvuD/3K2MD4xGhLkZODgkBE4l11/awQthiEhfurWfrYuTiEBKYzijxZuNcZgjnB6NEw5tH
	7CBVbAIqEss7/jOB2CICXhKT9p9gAbGZBTwkGju+g00SFgiX+PvsMlicRUBVov3MMbB6XgFL
	idfb/7NA2IISPybfg+rVkli/8zgThC0vsXnNW2aIixQkdpx9zQixS09i64kWRogacYmNR26x
	TGAUmIVk1Cwko2YhGTULScsCRpZVjKKpBckFxUnpuUZ6xYm5xaV56XrJ+bmbGMFB/Ux6B+Oq
	BotDjAIcjEo8vBqNR0OEWBPLiitzDzFKcDArifCWTwEK8aYkVlalFuXHF5XmpBYfYpTmYFES
	51WybwsREkhPLEnNTk0tSC2CyTJxcEo1MPYnqFx88d4rR6ePN40/6NL2Q6mTM/1nc3T0Hd93
	P/raGtYNiXW7xJ4tFpiYkTO9V/iXq3+MehW3VkuO1LG7C38+d713z2STQZU8a8ZT48buBNFS
	jrTVPtF9jB8npJsvM0l+vLBhaiLzCs/nAZdMsp//5Q//E/Lrq6pJX9mszx/Pcfbu7Lf7p8RS
	nJFoqMVcVJwIAM+4Jx9mAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds a mount option 'extent_cache' in f2fs.

It tries to use a rb-tree based extent cache to cache more mapping information
with less memory if this option is set, otherwise we will use the original one
extent info cache.

Suggested-by: Changman Lee <cm224.lee@samsung.com>
Signed-off-by: Chao Yu <chao2.yu@samsung.com>
---
 Documentation/filesystems/f2fs.txt | 4 ++++
 fs/f2fs/f2fs.h                     | 1 +
 fs/f2fs/super.c                    | 7 +++++++
 3 files changed, 12 insertions(+)

diff --git a/Documentation/filesystems/f2fs.txt b/Documentation/filesystems/f2fs.txt
index e0950c4..87ae1a2 100644
--- a/Documentation/filesystems/f2fs.txt
+++ b/Documentation/filesystems/f2fs.txt
@@ -138,6 +138,10 @@ nobarrier              This option can be used if underlying storage guarantees
 fastboot               This option is used when a system wants to reduce mount
                        time as much as possible, even though normal performance
 		       can be sacrificed.
+extent_cache           Enable an extent cache based on rb-tree, it can cache
+                       as many as extent which map between contiguous logical
+                       address and physical address per inode, resulting in
+                       increasing the cache hit ratio.
 
 ================================================================================
 DEBUGFS ENTRIES
diff --git a/fs/f2fs/f2fs.h b/fs/f2fs/f2fs.h
index a77b30f..fe74286 100644
--- a/fs/f2fs/f2fs.h
+++ b/fs/f2fs/f2fs.h
@@ -50,6 +50,7 @@
 #define F2FS_MOUNT_FLUSH_MERGE		0x00000400
 #define F2FS_MOUNT_NOBARRIER		0x00000800
 #define F2FS_MOUNT_FASTBOOT		0x00001000
+#define F2FS_MOUNT_EXTENT_CACHE		0x00002000
 
 #define clear_opt(sbi, option)	(sbi->mount_opt.opt &= ~F2FS_MOUNT_##option)
 #define set_opt(sbi, option)	(sbi->mount_opt.opt |= F2FS_MOUNT_##option)
diff --git a/fs/f2fs/super.c b/fs/f2fs/super.c
index 5706c17..1b88b59 100644
--- a/fs/f2fs/super.c
+++ b/fs/f2fs/super.c
@@ -56,6 +56,7 @@ enum {
 	Opt_flush_merge,
 	Opt_nobarrier,
 	Opt_fastboot,
+	Opt_extent_cache,
 	Opt_err,
 };
 
@@ -76,6 +77,7 @@ static match_table_t f2fs_tokens = {
 	{Opt_flush_merge, "flush_merge"},
 	{Opt_nobarrier, "nobarrier"},
 	{Opt_fastboot, "fastboot"},
+	{Opt_extent_cache, "extent_cache"},
 	{Opt_err, NULL},
 };
 
@@ -357,6 +359,9 @@ static int parse_options(struct super_block *sb, char *options)
 		case Opt_fastboot:
 			set_opt(sbi, FASTBOOT);
 			break;
+		case Opt_extent_cache:
+			set_opt(sbi, EXTENT_CACHE);
+			break;
 		default:
 			f2fs_msg(sb, KERN_ERR,
 				"Unrecognized mount option \"%s\" or missing value",
@@ -589,6 +594,8 @@ static int f2fs_show_options(struct seq_file *seq, struct dentry *root)
 		seq_puts(seq, ",nobarrier");
 	if (test_opt(sbi, FASTBOOT))
 		seq_puts(seq, ",fastboot");
+	if (test_opt(sbi, EXTENT_CACHE))
+		seq_puts(seq, ",extent_cache");
 	seq_printf(seq, ",active_logs=%u", sbi->active_logs);
 
 	return 0;
-- 
2.2.1


