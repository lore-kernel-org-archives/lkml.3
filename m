Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752958AbaIJO3z (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Sep 2014 10:29:55 -0400
Received: from mail-qc0-f171.google.com ([209.85.216.171]:33587 "EHLO
	mail-qc0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752285AbaIJO3P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Sep 2014 10:29:15 -0400
From: Jeff Layton <jlayton@primarydata.com>
To: linux-fsdevel@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Al Viro <viro@ZenIV.linux.org.uk>,
        Christoph Hellwig <hch@infradead.org>, bfields@fieldses.org
Subject: [RFC PATCH 11/12] nfsd: convert to file_lock_context
Date: Wed, 10 Sep 2014 10:28:49 -0400
Message-Id: <1410359330-27564-12-git-send-email-jlayton@primarydata.com>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1410359330-27564-1-git-send-email-jlayton@primarydata.com>
References: <1410359330-27564-1-git-send-email-jlayton@primarydata.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Jeff Layton <jlayton@primarydata.com>
---
 fs/nfsd/nfs4state.c | 18 +++++++++++-------
 1 file changed, 11 insertions(+), 7 deletions(-)

diff --git a/fs/nfsd/nfs4state.c b/fs/nfsd/nfs4state.c
index c4c8d0621dde..4fc1a2f98d1e 100644
--- a/fs/nfsd/nfs4state.c
+++ b/fs/nfsd/nfs4state.c
@@ -5490,10 +5490,11 @@ out_nfserr:
 static bool
 check_for_locks(struct nfs4_file *fp, struct nfs4_lockowner *lowner)
 {
-	struct file_lock **flpp;
+	struct file_lock *fl;
 	int status = false;
 	struct file *filp = find_any_file(fp);
 	struct inode *inode;
+	struct file_lock_context *flctx;
 
 	if (!filp) {
 		/* Any valid lock stateid should have some sort of access */
@@ -5502,15 +5503,18 @@ check_for_locks(struct nfs4_file *fp, struct nfs4_lockowner *lowner)
 	}
 
 	inode = file_inode(filp);
+	flctx = inode->i_flctx;
 
-	spin_lock(&inode->i_lock);
-	for (flpp = &inode->i_flock; *flpp != NULL; flpp = &(*flpp)->fl_next) {
-		if ((*flpp)->fl_owner == (fl_owner_t)lowner) {
-			status = true;
-			break;
+	if (flctx) {
+		spin_lock(&flctx->flc_lock);
+		list_for_each_entry(fl, &flctx->flc_posix, fl_list) {
+			if (fl->fl_owner == (fl_owner_t)lowner) {
+				status = true;
+				break;
+			}
 		}
+		spin_unlock(&flctx->flc_lock);
 	}
-	spin_unlock(&inode->i_lock);
 	fput(filp);
 	return status;
 }
-- 
1.9.3

