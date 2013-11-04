Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752521Ab3KDLgg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Nov 2013 06:36:36 -0500
Received: from mx1.redhat.com ([209.132.183.28]:50445 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751638Ab3KDLgR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Nov 2013 06:36:17 -0500
From: Steven Whitehouse <swhiteho@redhat.com>
To: cluster-devel@redhat.com, linux-kernel@vger.kernel.org
Cc: Miklos Szeredi <mszeredi@suse.cz>, Steven Whitehouse <swhiteho@redhat.com>,
        stable@vger.kernel.org
Subject: [PATCH 01/19] GFS2: d_splice_alias() can't return error
Date: Mon,  4 Nov 2013 11:09:24 +0000
Message-Id: <1383563382-8535-2-git-send-email-swhiteho@redhat.com>
In-Reply-To: <1383563382-8535-1-git-send-email-swhiteho@redhat.com>
References: <1383563382-8535-1-git-send-email-swhiteho@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Miklos Szeredi <mszeredi@suse.cz>

unless it was given an IS_ERR(inode), which isn't the case here.  So clean
up the unnecessary error handling in gfs2_create_inode().

This paves the way for real fixes (hence the stable Cc).

Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
Signed-off-by: Steven Whitehouse <swhiteho@redhat.com>
Cc: stable@vger.kernel.org

diff --git a/fs/gfs2/inode.c b/fs/gfs2/inode.c
index 64915ee..6d7f976 100644
--- a/fs/gfs2/inode.c
+++ b/fs/gfs2/inode.c
@@ -584,7 +584,7 @@ static int gfs2_create_inode(struct inode *dir, struct dentry *dentry,
 	if (!IS_ERR(inode)) {
 		d = d_splice_alias(inode, dentry);
 		error = 0;
-		if (file && !IS_ERR(d)) {
+		if (file) {
 			if (d == NULL)
 				d = dentry;
 			if (S_ISREG(inode->i_mode))
@@ -593,8 +593,6 @@ static int gfs2_create_inode(struct inode *dir, struct dentry *dentry,
 				error = finish_no_open(file, d);
 		}
 		gfs2_glock_dq_uninit(ghs);
-		if (IS_ERR(d))
-			return PTR_ERR(d);
 		return error;
 	} else if (error != -ENOENT) {
 		goto fail_gunlock;
-- 
1.7.4.4

