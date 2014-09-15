Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753875AbaIOJdT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Sep 2014 05:33:19 -0400
Received: from mx1.redhat.com ([209.132.183.28]:60650 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753823AbaIOJdP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Sep 2014 05:33:15 -0400
From: Steven Whitehouse <swhiteho@redhat.com>
To: linux-kernel@vger.kernel.org, cluster-devel@redhat.com
Cc: Al Viro <viro@ZenIV.linux.org.uk>, stable@vger.kernel.org.#.v3.14+,
        Al Viro <viro@ZenIV.linux.org.uk>,
        Steven Whitehouse <swhiteho@redhat.com>
Subject: [PATCH 6/6] GFS2: fix d_splice_alias() misuses
Date: Mon, 15 Sep 2014 10:32:48 +0100
Message-Id: <1410773568-1573-7-git-send-email-swhiteho@redhat.com>
In-Reply-To: <1410773568-1573-1-git-send-email-swhiteho@redhat.com>
References: <1410773568-1573-1-git-send-email-swhiteho@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Al Viro <viro@ZenIV.linux.org.uk>

Callers of d_splice_alias(dentry, inode) don't need iput(), neither
on success nor on failure.  Either the reference to inode is stored
in a previously negative dentry, or it's dropped.  In either case
inode reference the caller used to hold is consumed.

__gfs2_lookup() does iput() in case when d_splice_alias() has failed.
Double iput() if we ever hit that.  And gfs2_create_inode() ends up
not only with double iput(), but with link count dropped to zero - on
an inode it has just found in directory.

Cc: stable@vger.kernel.org # v3.14+
Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Steven Whitehouse <swhiteho@redhat.com>

diff --git a/fs/gfs2/inode.c b/fs/gfs2/inode.c
index 9317ddc..fc8ac2e 100644
--- a/fs/gfs2/inode.c
+++ b/fs/gfs2/inode.c
@@ -626,8 +626,10 @@ static int gfs2_create_inode(struct inode *dir, struct dentry *dentry,
 	if (!IS_ERR(inode)) {
 		d = d_splice_alias(inode, dentry);
 		error = PTR_ERR(d);
-		if (IS_ERR(d))
+		if (IS_ERR(d)) {
+			inode = ERR_CAST(d);
 			goto fail_gunlock;
+		}
 		error = 0;
 		if (file) {
 			if (S_ISREG(inode->i_mode)) {
@@ -856,7 +858,6 @@ static struct dentry *__gfs2_lookup(struct inode *dir, struct dentry *dentry,
 
 	d = d_splice_alias(inode, dentry);
 	if (IS_ERR(d)) {
-		iput(inode);
 		gfs2_glock_dq_uninit(&gh);
 		return d;
 	}
-- 
1.8.3.1

