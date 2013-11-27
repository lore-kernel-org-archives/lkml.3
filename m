Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759298Ab3K0BKG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Nov 2013 20:10:06 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:39663 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758859Ab3K0A7z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Nov 2013 19:59:55 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Miklos Szeredi <mszeredi@suse.cz>,
        Steven Whitehouse <swhiteho@redhat.com>
Subject: [PATCH 3.12 115/116] GFS2: fix dentry leaks
Date: Tue, 26 Nov 2013 16:58:08 -0800
Message-Id: <20131127005744.892516021@linuxfoundation.org>
X-Mailer: git-send-email 1.8.5.rc3
In-Reply-To: <20131127005736.915454872@linuxfoundation.org>
References: <20131127005736.915454872@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Miklos Szeredi <miklos@szeredi.hu>

commit 5ca1db41ecdeb0358b968265fadb755213558a85 upstream.

We need to dput() the result of d_splice_alias(), unless it is passed to
finish_no_open().

Edited by Steven Whitehouse in order to make it apply to the current
GFS2 git tree, and taking account of a prerequisite patch which hasn't
been applied.

Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
Signed-off-by: Steven Whitehouse <swhiteho@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/gfs2/inode.c |   26 ++++++++++++++++----------
 1 file changed, 16 insertions(+), 10 deletions(-)

--- a/fs/gfs2/inode.c
+++ b/fs/gfs2/inode.c
@@ -585,12 +585,14 @@ static int gfs2_create_inode(struct inod
 		d = d_splice_alias(inode, dentry);
 		error = 0;
 		if (file) {
-			if (d == NULL)
-				d = dentry;
-			if (S_ISREG(inode->i_mode))
-				error = finish_open(file, d, gfs2_open_common, opened);
-			else
+			if (S_ISREG(inode->i_mode)) {
+				WARN_ON(d != NULL);
+				error = finish_open(file, dentry, gfs2_open_common, opened);
+			} else {
 				error = finish_no_open(file, d);
+			}
+		} else {
+			dput(d);
 		}
 		gfs2_glock_dq_uninit(ghs);
 		return error;
@@ -779,8 +781,10 @@ static struct dentry *__gfs2_lookup(stru
 		error = finish_open(file, dentry, gfs2_open_common, opened);
 
 	gfs2_glock_dq_uninit(&gh);
-	if (error)
+	if (error) {
+		dput(d);
 		return ERR_PTR(error);
+	}
 	return d;
 }
 
@@ -1161,14 +1165,16 @@ static int gfs2_atomic_open(struct inode
 	d = __gfs2_lookup(dir, dentry, file, opened);
 	if (IS_ERR(d))
 		return PTR_ERR(d);
-	if (d == NULL)
-		d = dentry;
-	if (d->d_inode) {
+	if (d != NULL)
+		dentry = d;
+	if (dentry->d_inode) {
 		if (!(*opened & FILE_OPENED))
-			return finish_no_open(file, d);
+			return finish_no_open(file, dentry);
+		dput(d);
 		return 0;
 	}
 
+	BUG_ON(d != NULL);
 	if (!(flags & O_CREAT))
 		return -ENOENT;
 


