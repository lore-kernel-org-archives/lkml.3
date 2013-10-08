Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753429Ab3JHB2d (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Oct 2013 21:28:33 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:56455 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751851Ab3JHB2b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Oct 2013 21:28:31 -0400
X-AuditID: cbfee68e-b7f756d000004512-fc-52535fbbae2c
From: Jaegeuk Kim <jaegeuk.kim@samsung.com>
Cc: Jaegeuk Kim <jaegeuk.kim@samsung.com>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net
Subject: [PATCH] f2fs: fix writing incorrect orphan blocks
Date: Tue, 08 Oct 2013 10:28:00 +0900
Message-id: <1381195680-30955-1-git-send-email-jaegeuk.kim@samsung.com>
X-Mailer: git-send-email 1.8.4.474.g128a96c
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrKLMWRmVeSWpSXmKPExsVy+t8zA93d8cFBBgvapC2u7/rLZHFpkbvF
	nr0nWSwu75rD5sDisXvBZyaPvi2rGD0+b5ILYI7isklJzcksSy3St0vgyljy9wdrwR+uiksd
	q5kaGM+ydzFyckgImEjcu9/PBmGLSVy4tx7I5uIQEljGKLHl5RY2mKLGk0fZIRKLGCU2/2ll
	hXCamSRu7ZvF2MXIwcEmoC2xeb8BSIOIALPEgqnnGUFqmAUmMEr8X/SeBSQhLGAlsXPzerCp
	LAKqEq9aVjKC2LwC7hLTvn5mgtimLbHt+USwZgmBx2wSi441s0I0CEh8m3yIBWSZhICsxKYD
	zBD1khIHV9xgmcAouICRYRWjaGpBckFxUnqRkV5xYm5xaV66XnJ+7iZGSBD27WC8ecD6EGMy
	0LiJzFKiyfnAIM4riTc0NjOyMDUxNTYytzQjTVhJnFetxTpQSCA9sSQ1OzW1ILUovqg0J7X4
	ECMTB6dUAyP7Pbalz+ROTX/bdHnf6aciAt98t99cxVu97slayZC6DZmC0Xfn/M3UDPtQNnO9
	XwPr1N3PAsokS9qtr0R/fe80tfJRpK91+Q6dxzPP9rOd7NsjWeb38KiZZArHy+4MTa9Pk9hO
	zN21pfRXye1msysf2jdEeq04dLHsWmuPd73lY+E1ve8k8oSUWIozEg21mIuKEwGVKZ0iWAIA	AA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrEIsWRmVeSWpSXmKPExsVy+t9jAd3d8cFBBrMXiFtc3/WXyeLSIneL
	PXtPslhc3jWHzYHFY/eCz0wefVtWMXp83iQXwBzVwGiTkZqYklqkkJqXnJ+SmZduq+QdHO8c
	b2pmYKhraGlhrqSQl5ibaqvk4hOg65aZA7RNSaEsMacUKBSQWFyspG+HaUJoiJuuBUxjhK5v
	SBBcj5EBGkhYx5ix5O8P1oI/XBWXOlYzNTCeZe9i5OSQEDCRaDx5FMoWk7hwbz1bFyMXh5DA
	IkaJzX9aWSGcZiaJW/tmMXYxcnCwCWhLbN5vANIgIsAssWDqeUaQGmaBCYwS/xe9ZwFJCAtY
	SezcDDKJk4NFQFXiVctKRhCbV8BdYtrXz0wQ27Qltj2fyDiBkXsBI8MqRtHUguSC4qT0XEO9
	4sTc4tK8dL3k/NxNjOAQfya1g3Flg8UhRgEORiUeXoHDQUFCrIllxZW5hxglOJiVRHgFjIKD
	hHhTEiurUovy44tKc1KLDzEmA22fyCwlmpwPjL+8knhDYxMzI0sjMwsjE3Nz0oSVxHkPtFoH
	CgmkJ5akZqemFqQWwWxh4uCUamBUK8lM+v7xx+YtBl8uacU/P7zyyZHkr9t3CWhNdj9QPMVW
	z6Q0IsH5U2wn9/wEtcsqDh7v/hs/X3o7vs9E8Z9v9dx6r1ZxXn3jAJF8i9o5gTNutk1Zrfyw
	5t4KsQv1t66n1t0/O/P7000K2y/v7+ebl+AieFTun0CbXfjvWVFz9tt57tr57J6kEktxRqKh
	FnNRcSIAdRXnabUCAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Previously, there was a erroneous scenario like below.
thread 1:                       thread 2:
 f2fs_unlink
  - acquire_orphan_inode
    : sbi->n_orphans++           write_checkpoint
                                 - block_operations
                                  : f2fs_lock_all
                                 - do_checkpoint
                                  : write orphan blocks with sbi->n_orphans
                                 - unblock_operations
  - f2fs_lock_op
  - release_orphan_inode
  - f2fs_unlock_op

During the checkpoint by thread 2, f2fs stores a wrong orphan block according
to the wrong sbi->n_orphans.
To avoid this, simply we should make cover acquire_orphan_inode too with
f2fs_lock_op.

Signed-off-by: Jaegeuk Kim <jaegeuk.kim@samsung.com>
---
 fs/f2fs/namei.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/f2fs/namei.c b/fs/f2fs/namei.c
index 29f73fd..575adac 100644
--- a/fs/f2fs/namei.c
+++ b/fs/f2fs/namei.c
@@ -228,14 +228,14 @@ static int f2fs_unlink(struct inode *dir, struct dentry *dentry)
 	if (!de)
 		goto fail;
 
+	f2fs_lock_op(sbi);
 	err = acquire_orphan_inode(sbi);
 	if (err) {
+		f2fs_unlock_op(sbi);
 		kunmap(page);
 		f2fs_put_page(page, 0);
 		goto fail;
 	}
-
-	f2fs_lock_op(sbi);
 	f2fs_delete_entry(de, page, inode);
 	f2fs_unlock_op(sbi);
 
-- 
1.8.4.474.g128a96c

