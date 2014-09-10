Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751874AbaIJOth (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Sep 2014 10:49:37 -0400
Received: from ducie-dc1.codethink.co.uk ([185.25.241.215]:58701 "EHLO
	ducie-dc1.codethink.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751611AbaIJOtf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Sep 2014 10:49:35 -0400
From: Rob Jones <rob.jones@codethink.co.uk>
To: linux-kernel@vger.kernel.org
Cc: ocfs2-devel@oss.oracle.com, dan.carpenter@oracle.com,
        akpm@linux-foundation.org, jlbec@evilplan.org, mfasheh@suse.com,
        linux-kernel@codethink.co.uk, rob.jones@codethink.co.uk
Subject: [PATCH 1/3] fs: ocfs2: use seq_open_private() not seq_open()
Date: Wed, 10 Sep 2014 15:49:16 +0100
Message-Id: <1410360558-28399-2-git-send-email-rob.jones@codethink.co.uk>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1410360558-28399-1-git-send-email-rob.jones@codethink.co.uk>
References: <1410360558-28399-1-git-send-email-rob.jones@codethink.co.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Reduce boilerplate code by using seq_open_private() instead of seq_open()

Signed-off-by: Rob Jones <rob.jones@codethink.co.uk>
---
 fs/ocfs2/dlm/dlmdebug.c |   39 ++++++++++++++-------------------------
 1 file changed, 14 insertions(+), 25 deletions(-)

diff --git a/fs/ocfs2/dlm/dlmdebug.c b/fs/ocfs2/dlm/dlmdebug.c
index e33cd7a..38ca17e 100644
--- a/fs/ocfs2/dlm/dlmdebug.c
+++ b/fs/ocfs2/dlm/dlmdebug.c
@@ -647,41 +647,30 @@ static const struct seq_operations debug_lockres_ops = {
 static int debug_lockres_open(struct inode *inode, struct file *file)
 {
 	struct dlm_ctxt *dlm = inode->i_private;
-	int ret = -ENOMEM;
-	struct seq_file *seq;
-	struct debug_lockres *dl = NULL;
+	struct debug_lockres *dl;
+	void *buf;
 
-	dl = kzalloc(sizeof(struct debug_lockres), GFP_KERNEL);
-	if (!dl) {
-		mlog_errno(ret);
+	buf = kmalloc(PAGE_SIZE, GFP_KERNEL);
+	if (!buf)
 		goto bail;
-	}
 
-	dl->dl_len = PAGE_SIZE;
-	dl->dl_buf = kmalloc(dl->dl_len, GFP_KERNEL);
-	if (!dl->dl_buf) {
-		mlog_errno(ret);
-		goto bail;
-	}
+	dl = __seq_open_private(file, &debug_lockres_ops, sizeof(*dl));
+	if (!dl)
+		goto bailfree;
 
-	ret = seq_open(file, &debug_lockres_ops);
-	if (ret) {
-		mlog_errno(ret);
-		goto bail;
-	}
-
-	seq = file->private_data;
-	seq->private = dl;
+	dl->dl_len = PAGE_SIZE;
+	dl->dl_buf = buf;
 
 	dlm_grab(dlm);
 	dl->dl_ctxt = dlm;
 
 	return 0;
+
+bailfree:
+	kfree(buf);
 bail:
-	if (dl)
-		kfree(dl->dl_buf);
-	kfree(dl);
-	return ret;
+	mlog_errno(-ENOMEM);
+	return -ENOMEM;
 }
 
 static int debug_lockres_release(struct inode *inode, struct file *file)
-- 
1.7.10.4

