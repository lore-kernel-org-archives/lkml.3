Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753051AbaBSJbH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Feb 2014 04:31:07 -0500
Received: from mailout3.samsung.com ([203.254.224.33]:63004 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752412AbaBSJbB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Feb 2014 04:31:01 -0500
X-AuditID: cbfee68e-b7f566d000002344-22-530479d183f3
From: Jaegeuk Kim <jaegeuk.kim@samsung.com>
Cc: Jaegeuk Kim <jaegeuk.kim@samsung.com>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net
Subject: [PATCH] f2fs: fix to do build_stat prior to the recovery procedure
Date: Wed, 19 Feb 2014 18:29:23 +0900
Message-id: <1392802163-25825-1-git-send-email-jaegeuk.kim@samsung.com>
X-Mailer: git-send-email 1.8.4.474.g128a96c
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrCLMWRmVeSWpSXmKPExsVy+t8zQ92LlSzBBq8nKVtc3/WXyeLSIneL
	PXtPslhc3jWHzYHFY/eCz0wefVtWMXp83iQXwBzFZZOSmpNZllqkb5fAlbH61wqWgl6pimOH
	1zE2MO4X7WLk5JAQMJG4+3YvE4QtJnHh3nq2LkYuDiGBZYwSe2ceYIIpuvyxgQUisYhR4tSh
	fmYIp5NJYsHco+xdjBwcbALaEpv3G4A0iAgwSyyYep4RpIZZYAKjxP9F71lAEsIC3hIPp3eB
	1bMIqEosnRIHEuYVcJfYtbCBDWKZtsS25xPBeiUEHrNJnHz8lBEkwSIgIPFt8iEWkF4JAVmJ
	TQeYIeolJQ6uuMEygVFwASPDKkbR1ILkguKk9CIjveLE3OLSvHS95PzcTYyQEOzbwXjzgPUh
	xmSgcROZpUST84EhnFcSb2hsZmRhamJqbGRuaUaasJI476KHSUFCAumJJanZqakFqUXxRaU5
	qcWHGJk4OKUaGF0t9ipsaP849flWrgqdzt3Lllq/FJud+f6LvUSbf1eJ4gdrzViLO5cdLu9g
	977/Z8F0u6NmERYJHTuKgsqbH99pMtnQErpiqduu+tbSovJ5STdV/a0tOVxaC5yFN4h+K4ux
	5WdhS+3YeOmjSEb4ps+rt4buu1j4aNm7tOrfa8yzNK6t+L35uBJLcUaioRZzUXEiAPA0lKlX	AgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrIIsWRmVeSWpSXmKPExsVy+t9jAd2LlSzBBhs/yVlc3/WXyeLSIneL
	PXtPslhc3jWHzYHFY/eCz0wefVtWMXp83iQXwBzVwGiTkZqYklqkkJqXnJ+SmZduq+QdHO8c
	b2pmYKhraGlhrqSQl5ibaqvk4hOg65aZA7RNSaEsMacUKBSQWFyspG+HaUJoiJuuBUxjhK5v
	SBBcj5EBGkhYx5ix+tcKloJeqYpjh9cxNjDuF+1i5OSQEDCRuPyxgQXCFpO4cG89WxcjF4eQ
	wCJGiVOH+pkhnE4miQVzj7J3MXJwsAloS2zebwDSICLALLFg6nlGkBpmgQmMEv8XvQebJCzg
	LfFwehdYPYuAqsTSKXEgYV4Bd4ldCxvYIJZpS2x7PpFxAiP3AkaGVYyiqQXJBcVJ6blGesWJ
	ucWleel6yfm5mxjBAf5MegfjqgaLQ4wCHIxKPLweL5iDhVgTy4orcw8xSnAwK4nw3oljCRbi
	TUmsrEotyo8vKs1JLT7EmAy0fCKzlGhyPjD68kriDY1NzIwsjcwsjEzMzUkTVhLnPdhqHSgk
	kJ5YkpqdmlqQWgSzhYmDU6qBkXmJ6IeVSw8cq59/b+lKqY2hl4VEu0oadgcnaRz9wrL19tuC
	T88/SsZ8f3Hr2P+z/iYflb8aCwoIOi2vX6samsqzR171s8p02fXL/p/2cxJTrZ/rdXzvAs4v
	B0WlZ++P++bUVWzzbN2Shke8zR8leMSzQ20XX3hh+3DX1QT/Ba3f7/5bLnM+LkCJpTgj0VCL
	uag4EQBXg93RtAIAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

At the end of the recovery procedure, write_checkpoint is called and updates
the cp count which is managed by f2fs stat.
But, previously build_stat() is called after the recovery procedure, which
results in:

BUG: unable to handle kernel NULL pointer dereference at 000000000000012c
IP: [<ffffffffa03b1030>] write_checkpoint+0x720/0xbc0 [f2fs]
Call Trace:
 [<ffffffff810a6b44>] ? mark_held_locks+0x74/0x140
 [<ffffffff8109a3e0>] ? __init_waitqueue_head+0x60/0x60
 [<ffffffffa03bf036>] recover_fsync_data+0x656/0xf20 [f2fs]
 [<ffffffff812ee3eb>] ? security_d_instantiate+0x1b/0x30
 [<ffffffffa03aeb4d>] f2fs_fill_super+0x94d/0xa00 [f2fs]
 [<ffffffff811a9825>] mount_bdev+0x1a5/0x1f0
 [<ffffffff8114915e>] ? __get_free_pages+0xe/0x40
 [<ffffffffa03ae200>] ? f2fs_remount+0x130/0x130 [f2fs]
 [<ffffffffa03aa575>] f2fs_mount+0x15/0x20 [f2fs]
 [<ffffffff811aa713>] mount_fs+0x43/0x1b0
 [<ffffffff811c7124>] vfs_kern_mount+0x74/0x160
 [<ffffffff811c5cb1>] ? __get_fs_type+0x51/0x60
 [<ffffffff811c9727>] do_mount+0x237/0xb50
 [<ffffffff811c936a>] ? copy_mount_options+0x3a/0x170

So, this patche changes the order of recovery_fsync_data() and
f2fs_build_stats().

Signed-off-by: Jaegeuk Kim <jaegeuk.kim@samsung.com>
---
 fs/f2fs/super.c | 48 ++++++++++++++++++++++++------------------------
 1 file changed, 24 insertions(+), 24 deletions(-)

diff --git a/fs/f2fs/super.c b/fs/f2fs/super.c
index 1a85f83..475560e 100644
--- a/fs/f2fs/super.c
+++ b/fs/f2fs/super.c
@@ -989,28 +989,9 @@ static int f2fs_fill_super(struct super_block *sb, void *data, int silent)
 		goto free_root_inode;
 	}
 
-	/* recover fsynced data */
-	if (!test_opt(sbi, DISABLE_ROLL_FORWARD)) {
-		err = recover_fsync_data(sbi);
-		if (err)
-			f2fs_msg(sb, KERN_ERR,
-				"Cannot recover all fsync data errno=%ld", err);
-	}
-
-	/*
-	 * If filesystem is not mounted as read-only then
-	 * do start the gc_thread.
-	 */
-	if (!(sb->s_flags & MS_RDONLY)) {
-		/* After POR, we can run background GC thread.*/
-		err = start_gc_thread(sbi);
-		if (err)
-			goto free_gc;
-	}
-
 	err = f2fs_build_stats(sbi);
 	if (err)
-		goto free_gc;
+		goto free_root_inode;
 
 	if (f2fs_proc_root)
 		sbi->s_proc = proc_mkdir(sb->s_id, f2fs_proc_root);
@@ -1032,17 +1013,36 @@ static int f2fs_fill_super(struct super_block *sb, void *data, int silent)
 	err = kobject_init_and_add(&sbi->s_kobj, &f2fs_ktype, NULL,
 							"%s", sb->s_id);
 	if (err)
-		goto fail;
+		goto free_proc;
 
+	/* recover fsynced data */
+	if (!test_opt(sbi, DISABLE_ROLL_FORWARD)) {
+		err = recover_fsync_data(sbi);
+		if (err)
+			f2fs_msg(sb, KERN_ERR,
+				"Cannot recover all fsync data errno=%ld", err);
+	}
+
+	/*
+	 * If filesystem is not mounted as read-only then
+	 * do start the gc_thread.
+	 */
+	if (!(sb->s_flags & MS_RDONLY)) {
+		/* After POR, we can run background GC thread.*/
+		err = start_gc_thread(sbi);
+		if (err)
+			goto free_kobj;
+	}
 	return 0;
-fail:
+
+free_kobj:
+	kobject_del(&sbi->s_kobj);
+free_proc:
 	if (sbi->s_proc) {
 		remove_proc_entry("segment_info", sbi->s_proc);
 		remove_proc_entry(sb->s_id, f2fs_proc_root);
 	}
 	f2fs_destroy_stats(sbi);
-free_gc:
-	stop_gc_thread(sbi);
 free_root_inode:
 	dput(sb->s_root);
 	sb->s_root = NULL;
-- 
1.8.4.474.g128a96c

