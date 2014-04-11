Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932376AbaDKJ72 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Apr 2014 05:59:28 -0400
Received: from cn.fujitsu.com ([59.151.112.132]:4747 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S932217AbaDKJ7Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Apr 2014 05:59:24 -0400
X-IronPort-AV: E=Sophos;i="4.97,841,1389715200"; 
   d="scan'208";a="29145753"
Message-ID: <5347BAC3.3090608@cn.fujitsu.com>
Date: Fri, 11 Apr 2014 17:49:55 +0800
From: Gu Zheng <guz.fnst@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:7.0.1) Gecko/20110930 Thunderbird/7.0.1
MIME-Version: 1.0
To: Kim <jaegeuk.kim@samsung.com>
CC: f2fs <linux-f2fs-devel@lists.sourceforge.net>,
        fsdevel <linux-fsdevel@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH 4/7] f2fs: enable flush_merge only in f2fs is not read-only
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.167.226.100]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Enable flush_merge only in f2fs is not read-only, so does the mount
option show.

Signed-off-by: Gu Zheng <guz.fnst@cn.fujitsu.com>
---
 fs/f2fs/segment.c |    3 +--
 fs/f2fs/super.c   |    4 ++--
 2 files changed, 3 insertions(+), 4 deletions(-)

diff --git a/fs/f2fs/segment.c b/fs/f2fs/segment.c
index ff8f987..6672570 100644
--- a/fs/f2fs/segment.c
+++ b/fs/f2fs/segment.c
@@ -1858,10 +1858,9 @@ int build_segment_manager(struct f2fs_sb_info *sbi)
 	sm_info->nr_discards = 0;
 	sm_info->max_discards = 0;
 
-	if (test_opt(sbi, FLUSH_MERGE)) {
+	if (test_opt(sbi, FLUSH_MERGE) && !f2fs_readonly(sbi->sb)) {
 		spin_lock_init(&sm_info->issue_lock);
 		init_waitqueue_head(&sm_info->flush_wait_queue);
-
 		sm_info->f2fs_issue_flush = kthread_run(issue_flush_thread, sbi,
 				"f2fs_flush-%u:%u", MAJOR(dev), MINOR(dev));
 		if (IS_ERR(sm_info->f2fs_issue_flush))
diff --git a/fs/f2fs/super.c b/fs/f2fs/super.c
index c756923..5e20d2a 100644
--- a/fs/f2fs/super.c
+++ b/fs/f2fs/super.c
@@ -514,7 +514,7 @@ static int f2fs_show_options(struct seq_file *seq, struct dentry *root)
 {
 	struct f2fs_sb_info *sbi = F2FS_SB(root->d_sb);
 
-	if (!(root->d_sb->s_flags & MS_RDONLY) && test_opt(sbi, BG_GC))
+	if (!f2fs_readonly(sbi->sb) && test_opt(sbi, BG_GC))
 		seq_printf(seq, ",background_gc=%s", "on");
 	else
 		seq_printf(seq, ",background_gc=%s", "off");
@@ -542,7 +542,7 @@ static int f2fs_show_options(struct seq_file *seq, struct dentry *root)
 		seq_puts(seq, ",disable_ext_identify");
 	if (test_opt(sbi, INLINE_DATA))
 		seq_puts(seq, ",inline_data");
-	if (test_opt(sbi, FLUSH_MERGE))
+	if (!f2fs_readonly(sbi->sb) && test_opt(sbi, FLUSH_MERGE))
 		seq_puts(seq, ",flush_merge");
 	seq_printf(seq, ",active_logs=%u", sbi->active_logs);
 
-- 
1.7.7

