Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752066AbbALHQc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2015 02:16:32 -0500
Received: from mailout4.samsung.com ([203.254.224.34]:32111 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751760AbbALHQb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2015 02:16:31 -0500
X-AuditID: cbfee61a-f79c06d000004e71-89-54b374cd1049
From: Chao Yu <chao2.yu@samsung.com>
To: Jaegeuk Kim <jaegeuk@kernel.org>, Changman Lee <cm224.lee@samsung.com>
Cc: linux-f2fs-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: [f2fs-dev][RFC PATCH 07/10] f2fs: add a mount option for rb-tree
 extent cache
Date: Mon, 12 Jan 2015 15:15:45 +0800
Message-id: <000b01d02e37$b08b42e0$11a1c8a0$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-index: AdAuG8CjitxjIcJuQByXOsUEf0ADkw==
Content-language: zh-cn
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrMLMWRmVeSWpSXmKPExsVy+t9jQd1zJZtDDHa/YbS4tq+RyeLJ+lnM
	FpcWuVtc3jWHzYHFY9OqTjaP3Qs+M3n0bVnF6PF5k1wASxSXTUpqTmZZapG+XQJXxvWb71gK
	rotX/OudytrAeFSoi5GTQ0LARGLD7+esELaYxIV769m6GLk4hASmM0o8XnCVBcL5wSgx4fkv
	sCo2ARWJ5R3/mUBsEQEviUn7T7CA2MwCHhKNHd/BaoQFIiQWPusEi7MIqEo8OzEBzOYVsJT4
	O+MoI4QtKPFj8j2oXi2J9TuPM0HY8hKb17xlhrhIQWLH2deMELv0JPZvWsYOUSMusfHILZYJ
	jAKzkIyahWTULCSjZiFpWcDIsopRNLUguaA4KT3XUK84Mbe4NC9dLzk/dxMjOKifSe1gXNlg
	cYhRgINRiYfXQmpziBBrYllxZe4hRgkOZiUR3jBroBBvSmJlVWpRfnxRaU5q8SFGaQ4WJXFe
	Jfu2ECGB9MSS1OzU1ILUIpgsEwenVAOjoMdNsSl37309bVhxl5H9xLuu3d8fuaWp/GRMlnjw
	fObPiZHPap/eiWZxuKr174Tw4f7aZM6JVyxOPSvsdy4Un5q8xVfrSffdJX/W/jF9qxX9dB7j
	tWKeVgmGYxIVN+Ysv6HvceAi/9LIx9vc64/lzTOREfvAF+fF99/wppjWnsiPO4TWZS3jUWIp
	zkg01GIuKk4EADLOxk1mAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds a mount option 'extent_cache' in f2fs.

It is try to use a rb-tree based extent cache to cache more mapping information
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
index 6decfd2..d065ff1 100644
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
index 8b8de7f..5041e719 100644
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
@@ -583,6 +588,8 @@ static int f2fs_show_options(struct seq_file *seq, struct dentry *root)
 		seq_puts(seq, ",nobarrier");
 	if (test_opt(sbi, FASTBOOT))
 		seq_puts(seq, ",fastboot");
+	if (test_opt(sbi, EXTENT_CACHE))
+		seq_puts(seq, ",extent_cache");
 	seq_printf(seq, ",active_logs=%u", sbi->active_logs);
 
 	return 0;
-- 
2.2.1


