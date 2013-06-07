Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752584Ab3FGGTj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Jun 2013 02:19:39 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:5487 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1750771Ab3FGGTi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Jun 2013 02:19:38 -0400
X-IronPort-AV: E=Sophos;i="4.87,820,1363104000"; 
   d="scan'208";a="7488979"
Message-ID: <51B17AD5.6060908@cn.fujitsu.com>
Date: Fri, 07 Jun 2013 14:16:53 +0800
From: Gu Zheng <guz.fnst@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:7.0.1) Gecko/20110930 Thunderbird/7.0.1
MIME-Version: 1.0
To: jaegeuk.kim@samsung.com
CC: linux-f2fs-devel@lists.sourceforge.net,
        linux-kernel <linux-kernel@vger.kernel.org>, guz.fnst@cn.fujitsu.com
Subject: [PATCH] f2fs: Set sb->s_fs_info before calling parse_options()
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/06/07 14:17:46,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/06/07 14:17:48,
	Serialize complete at 2013/06/07 14:17:48
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In f2fs_fill_super(), set sb->s_fs_info before calling parse_options(), then we can get
f2fs_sb_info via F2FS_SB(sb) in parse_options().
So that the second argument "sbi" of func parse_options() is no longer needed.

Signed-off-by: Gu Zheng <guz.fnst@cn.fujitsu.com>
---
 fs/f2fs/super.c |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/fs/f2fs/super.c b/fs/f2fs/super.c
index 8555f7d..58516b5 100644
--- a/fs/f2fs/super.c
+++ b/fs/f2fs/super.c
@@ -303,9 +303,9 @@ static const struct export_operations f2fs_export_ops = {
 	.get_parent = f2fs_get_parent,
 };
 
-static int parse_options(struct super_block *sb, struct f2fs_sb_info *sbi,
-				char *options)
+static int parse_options(struct super_block *sb, char *options)
 {
+	struct f2fs_sb_info *sbi = F2FS_SB(sb);
 	substring_t args[MAX_OPT_ARGS];
 	char *p;
 	int arg = 0;
@@ -541,6 +541,7 @@ static int f2fs_fill_super(struct super_block *sb, void *data, int silent)
 		if (err)
 			goto free_sb_buf;
 	}
+	sb->s_fs_info = sbi;
 	/* init some FS parameters */
 	sbi->active_logs = NR_CURSEG_TYPE;
 
@@ -553,7 +554,7 @@ static int f2fs_fill_super(struct super_block *sb, void *data, int silent)
 	set_opt(sbi, POSIX_ACL);
 #endif
 	/* parse mount options */
-	err = parse_options(sb, sbi, (char *)data);
+	err = parse_options(sb, (char *)data);
 	if (err)
 		goto free_sb_buf;
 
@@ -565,7 +566,6 @@ static int f2fs_fill_super(struct super_block *sb, void *data, int silent)
 	sb->s_xattr = f2fs_xattr_handlers;
 	sb->s_export_op = &f2fs_export_ops;
 	sb->s_magic = F2FS_SUPER_MAGIC;
-	sb->s_fs_info = sbi;
 	sb->s_time_gran = 1;
 	sb->s_flags = (sb->s_flags & ~MS_POSIXACL) |
 		(test_opt(sbi, POSIX_ACL) ? MS_POSIXACL : 0);
-- 
1.7.7
