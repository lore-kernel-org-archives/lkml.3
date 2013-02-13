Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760184Ab3BMTpG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2013 14:45:06 -0500
Received: from mail.tpi.com ([70.99.223.143]:1648 "EHLO mail.tpi.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757438Ab3BMTo7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2013 14:44:59 -0500
From: Tim Gardner <tim.gardner@canonical.com>
To: linux-kernel@vger.kernel.org
Cc: Tim Gardner <tim.gardner@canonical.com>, Mark Fasheh <mfasheh@suse.com>,
        Joel Becker <jlbec@evilplan.org>, ocfs2-devel@oss.oracle.com
Subject: [PATCH 2/2 linux-next] ocfs2: ocfs2_begin_truncate_log_recovery(): consolidate status error logging
Date: Wed, 13 Feb 2013 12:44:36 -0700
Message-Id: <1360784676-74994-2-git-send-email-tim.gardner@canonical.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1360784676-74994-1-git-send-email-tim.gardner@canonical.com>
References: <1360784676-74994-1-git-send-email-tim.gardner@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Cc: Mark Fasheh <mfasheh@suse.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: ocfs2-devel@oss.oracle.com
Signed-off-by: Tim Gardner <tim.gardner@canonical.com>
---
 fs/ocfs2/alloc.c |   12 +++++-------
 1 file changed, 5 insertions(+), 7 deletions(-)

diff --git a/fs/ocfs2/alloc.c b/fs/ocfs2/alloc.c
index 42c0e49..1689ca1 100644
--- a/fs/ocfs2/alloc.c
+++ b/fs/ocfs2/alloc.c
@@ -6090,10 +6090,8 @@ int ocfs2_begin_truncate_log_recovery(struct ocfs2_super *osb,
 	trace_ocfs2_begin_truncate_log_recovery(slot_num);
 
 	status = ocfs2_get_truncate_log_info(osb, slot_num, &tl_inode, &tl_bh);
-	if (status < 0) {
-		mlog_errno(status);
+	if (status < 0)
 		goto bail;
-	}
 
 	di = (struct ocfs2_dinode *) tl_bh->b_data;
 
@@ -6109,7 +6107,6 @@ int ocfs2_begin_truncate_log_recovery(struct ocfs2_super *osb,
 		*tl_copy = kmalloc(tl_bh->b_size, GFP_KERNEL);
 		if (!(*tl_copy)) {
 			status = -ENOMEM;
-			mlog_errno(status);
 			goto bail;
 		}
 
@@ -6123,10 +6120,8 @@ int ocfs2_begin_truncate_log_recovery(struct ocfs2_super *osb,
 
 		ocfs2_compute_meta_ecc(osb->sb, tl_bh->b_data, &di->i_check);
 		status = ocfs2_write_block(osb, tl_bh, INODE_CACHE(tl_inode));
-		if (status < 0) {
-			mlog_errno(status);
+		if (status < 0)
 			goto bail;
-		}
 	}
 
 bail:
@@ -6134,6 +6129,9 @@ bail:
 		iput(tl_inode);
 	brelse(tl_bh);
 
+	if (status < 0)
+		mlog_errno(status);
+
 	kfree(*tl_copy);
 	*tl_copy = NULL;
 
-- 
1.7.9.5

