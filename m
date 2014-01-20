Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753890AbaATMZu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jan 2014 07:25:50 -0500
Received: from mx1.redhat.com ([209.132.183.28]:57204 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753630AbaATMZF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jan 2014 07:25:05 -0500
From: Steven Whitehouse <swhiteho@redhat.com>
To: linux-kernel@vger.kernel.org, cluster-devel@redhat.com
Cc: "J. Bruce Fields" <bfields@fieldses.org>,
        "J. Bruce Fields" <bfields@redhat.com>,
        Steven Whitehouse <swhiteho@redhat.com>
Subject: [PATCH 24/24] GFS2: revert "GFS2: d_splice_alias() can't return error"
Date: Mon, 20 Jan 2014 12:23:47 +0000
Message-Id: <1390220627-1571-25-git-send-email-swhiteho@redhat.com>
In-Reply-To: <1390220627-1571-1-git-send-email-swhiteho@redhat.com>
References: <1390220627-1571-1-git-send-email-swhiteho@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "J. Bruce Fields" <bfields@fieldses.org>

0d0d110720d7960b77c03c9f2597faaff4b484ae asserts that "d_splice_alias()
can't return error unless it was given an IS_ERR(inode)".

That was true of the implementation of d_splice_alias, but this is
really a problem with d_splice_alias: at a minimum it should be able to
return -ELOOP in the case where inserting the given dentry would cause a
directory loop.

Signed-off-by: J. Bruce Fields <bfields@redhat.com>
Signed-off-by: Steven Whitehouse <swhiteho@redhat.com>

diff --git a/fs/gfs2/inode.c b/fs/gfs2/inode.c
index b8956f2..890588c 100644
--- a/fs/gfs2/inode.c
+++ b/fs/gfs2/inode.c
@@ -604,6 +604,9 @@ static int gfs2_create_inode(struct inode *dir, struct dentry *dentry,
 	error = PTR_ERR(inode);
 	if (!IS_ERR(inode)) {
 		d = d_splice_alias(inode, dentry);
+		error = PTR_ERR(d);
+		if (IS_ERR(d))
+			goto fail_gunlock;
 		error = 0;
 		if (file) {
 			if (S_ISREG(inode->i_mode)) {
@@ -799,6 +802,11 @@ static struct dentry *__gfs2_lookup(struct inode *dir, struct dentry *dentry,
 	}
 
 	d = d_splice_alias(inode, dentry);
+	if (IS_ERR(d)) {
+		iput(inode);
+		gfs2_glock_dq_uninit(&gh);
+		return d;
+	}
 	if (file && S_ISREG(inode->i_mode))
 		error = finish_open(file, dentry, gfs2_open_common, opened);
 
-- 
1.8.3.1

