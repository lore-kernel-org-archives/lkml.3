Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752619AbaBSApY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Feb 2014 19:45:24 -0500
Received: from mailout4.samsung.com ([203.254.224.34]:36706 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750851AbaBSApW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Feb 2014 19:45:22 -0500
X-AuditID: cbfee68f-b7f156d00000276c-5c-5303fe9e17a2
From: Jaegeuk Kim <jaegeuk.kim@samsung.com>
Cc: Jaegeuk Kim <jaegeuk.kim@samsung.com>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net
Subject: [PATCH] f2fs: fix not to write data pages on the page reclaiming path
Date: Wed, 19 Feb 2014 09:43:45 +0900
Message-id: <1392770625-23082-1-git-send-email-jaegeuk.kim@samsung.com>
X-Mailer: git-send-email 1.8.4.474.g128a96c
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrCLMWRmVeSWpSXmKPExsVy+t8zI915/5iDDS4cNrO4vusvk8WlRe4W
	e/aeZLG4vGsOmwOLx+4Fn5k8+rasYvT4vEkugDmKyyYlNSezLLVI3y6BK+PskybGgqPiFad6
	P7I1MO4V7mLk5JAQMJH42XKQBcIWk7hwbz1bFyMXh5DAMkaJl53v2GGKzl5dwAyRWMQo8eDU
	RCaQhJBAJ5PEjCtpXYwcHGwC2hKb9xuAhEUEmCUWTD3PCFLPLDCBUeL/ovdgG4QF/CQW9vUw
	g9gsAqoSKxc/BZvDK+AuMbV9BdQybYltzyeCNUsI3GeT6H91nQmiQUDi2+RDLCDLJARkJTYd
	YIaol5Q4uOIGywRGwQWMDKsYRVMLkguKk9KLjPWKE3OLS/PS9ZLzczcxQkKwfwfj3QPWhxiT
	gcZNZJYSTc4HhnBeSbyhsZmRhamJqbGRuaUZacJK4rz3HyYFCQmkJ5akZqemFqQWxReV5qQW
	H2Jk4uCUamAsqfzWt+VNK7/31CcfDgom5Tl2inE/X/Tf54pZ3LN+6w3Hip7/rbuv+zumtEnM
	Q9orRsxfOog95sXKsyXVP34vWb63okO8ek9II4foNFdJL5fcq2pRvs/Os71hir/UOUXxQuBX
	LytRtoLSvkdrjPcW/TJtq3tZ1K399Jb01jaGT902M+bOE1FiKc5INNRiLipOBABt3YuOVwIA	AA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrIIsWRmVeSWpSXmKPExsVy+t9jAd15/5iDDdZtNbK4vusvk8WlRe4W
	e/aeZLG4vGsOmwOLx+4Fn5k8+rasYvT4vEkugDmqgdEmIzUxJbVIITUvOT8lMy/dVsk7ON45
	3tTMwFDX0NLCXEkhLzE31VbJxSdA1y0zB2ibkkJZYk4pUCggsbhYSd8O04TQEDddC5jGCF3f
	kCC4HiMDNJCwjjHj7JMmxoKj4hWnej+yNTDuFe5i5OSQEDCROHt1ATOELSZx4d56ti5GLg4h
	gUWMEg9OTWQCSQgJdDJJzLiS1sXIwcEmoC2xeb8BSFhEgFliwdTzjCD1zAITGCX+L3rPApIQ
	FvCTWNjXAzaURUBVYuXip2BzeAXcJaa2r2CHWKYtse35RMYJjNwLGBlWMYqmFiQXFCel5xrp
	FSfmFpfmpesl5+duYgQH+DPpHYyrGiwOMQpwMCrx8Hq8YA4WYk0sK67MPcQowcGsJMLb8Bwo
	xJuSWFmVWpQfX1Sak1p8iDEZaPtEZinR5Hxg9OWVxBsam5gZWRqZWRiZmJuTJqwkznuw1TpQ
	SCA9sSQ1OzW1ILUIZgsTB6dUA2PNqUVvDzZzrBblcGz0v/glrGBNG5vjkzO6Ls/er3yX+pL5
	bb8/94aWpSkyovzLXyWdLv30yD8u27VNUz3TepEHi8a1pyUebsEMh5UWbm9bJ/e6NL34+uVY
	/6SZbkzRIZVrjwXvKClO27PlXZLPLdZryU9fF9XNua7Wfnvaby9dGY+kpwnMnUosxRmJhlrM
	RcWJAFtsdgi0AgAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Even if f2fs_write_data_page is called by the page reclaiming path, we should
not write the page to provide enough free segments for the worst case scenario.
Otherwise, f2fs can face with no free segment while gc is conducted, resulting
in:

 ------------[ cut here ]------------
 kernel BUG at /home/zeus/f2fs_test/src/fs/f2fs/segment.c:565!
 RIP: 0010:[<ffffffffa02c3b11>]  [<ffffffffa02c3b11>] new_curseg+0x331/0x340 [f2fs]
 Call Trace:
  allocate_segment_by_default+0x204/0x280 [f2fs]
  allocate_data_block+0x108/0x210 [f2fs]
  write_data_page+0x8a/0xc0 [f2fs]
  do_write_data_page+0xe1/0x2a0 [f2fs]
  move_data_page+0x8a/0xf0 [f2fs]
  f2fs_gc+0x446/0x970 [f2fs]
  f2fs_balance_fs+0xb6/0xd0 [f2fs]
  f2fs_write_begin+0x50/0x350 [f2fs]
  ? unlock_page+0x27/0x30
  ? unlock_page+0x27/0x30
  generic_file_buffered_write+0x10a/0x280
  ? file_update_time+0xa3/0xf0
  __generic_file_aio_write+0x1c8/0x3d0
  ? generic_file_aio_write+0x52/0xb0
  ? generic_file_aio_write+0x52/0xb0
  generic_file_aio_write+0x65/0xb0
  do_sync_write+0x5a/0x90
  vfs_write+0xc5/0x1f0
  SyS_write+0x55/0xa0
  system_call_fastpath+0x16/0x1b

Signed-off-by: Jaegeuk Kim <jaegeuk.kim@samsung.com>
---
 fs/f2fs/data.c | 40 ++++++++++++++++------------------------
 1 file changed, 16 insertions(+), 24 deletions(-)

diff --git a/fs/f2fs/data.c b/fs/f2fs/data.c
index b401be7..388a92e 100644
--- a/fs/f2fs/data.c
+++ b/fs/f2fs/data.c
@@ -805,38 +805,30 @@ static int f2fs_write_data_page(struct page *page,
 
 	zero_user_segment(page, offset, PAGE_CACHE_SIZE);
 write:
-	if (unlikely(sbi->por_doing)) {
-		err = AOP_WRITEPAGE_ACTIVATE;
+	if (unlikely(sbi->por_doing))
 		goto redirty_out;
-	}
 
 	/* Dentry blocks are controlled by checkpoint */
 	if (S_ISDIR(inode->i_mode)) {
 		inode_dec_dirty_dents(inode);
 		err = do_write_data_page(page, &fio);
-	} else {
-		f2fs_lock_op(sbi);
-
-		if (f2fs_has_inline_data(inode) || f2fs_may_inline(inode)) {
-			err = f2fs_write_inline_data(inode, page, offset);
-			f2fs_unlock_op(sbi);
-			goto out;
-		} else {
-			err = do_write_data_page(page, &fio);
-		}
-
-		f2fs_unlock_op(sbi);
-		need_balance_fs = true;
+		goto done;
 	}
-	if (err == -ENOENT)
-		goto out;
-	else if (err)
+
+	if (wbc->for_reclaim && has_not_enough_free_secs(sbi, 0))
 		goto redirty_out;
 
-	if (wbc->for_reclaim) {
-		f2fs_submit_merged_bio(sbi, DATA, WRITE);
-		need_balance_fs = false;
-	}
+	need_balance_fs = true;
+
+	f2fs_lock_op(sbi);
+	if (f2fs_has_inline_data(inode) || f2fs_may_inline(inode))
+		err = f2fs_write_inline_data(inode, page, offset);
+	else
+		err = do_write_data_page(page, &fio);
+	f2fs_unlock_op(sbi);
+done:
+	if (err && err != -ENOENT)
+		goto redirty_out;
 
 	clear_cold_data(page);
 out:
@@ -848,7 +840,7 @@ out:
 redirty_out:
 	wbc->pages_skipped++;
 	set_page_dirty(page);
-	return err;
+	return AOP_WRITEPAGE_ACTIVATE;
 }
 
 #define MAX_DESIRED_PAGES_WP	4096
-- 
1.8.4.474.g128a96c

