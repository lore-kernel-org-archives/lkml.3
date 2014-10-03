Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933311AbaJCXri (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Oct 2014 19:47:38 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:46298 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757254AbaJCWD3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Oct 2014 18:03:29 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Al Viro <viro@zeniv.linux.org.uk>,
        Steven Whitehouse <swhiteho@redhat.com>
Subject: [PATCH 3.16 296/357] GFS2: fix d_splice_alias() misuses
Date: Fri,  3 Oct 2014 14:31:22 -0700
Message-Id: <20141003212942.377284187@linuxfoundation.org>
X-Mailer: git-send-email 2.1.2
In-Reply-To: <20141003212933.458851516@linuxfoundation.org>
References: <20141003212933.458851516@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Al Viro <viro@ZenIV.linux.org.uk>

commit cfb2f9d5c921e38b0f12bb26fed10b877664444d upstream.

Callers of d_splice_alias(dentry, inode) don't need iput(), neither
on success nor on failure.  Either the reference to inode is stored
in a previously negative dentry, or it's dropped.  In either case
inode reference the caller used to hold is consumed.

__gfs2_lookup() does iput() in case when d_splice_alias() has failed.
Double iput() if we ever hit that.  And gfs2_create_inode() ends up
not only with double iput(), but with link count dropped to zero - on
an inode it has just found in directory.

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Steven Whitehouse <swhiteho@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/gfs2/inode.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/fs/gfs2/inode.c
+++ b/fs/gfs2/inode.c
@@ -626,8 +626,10 @@ static int gfs2_create_inode(struct inod
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
@@ -854,7 +856,6 @@ static struct dentry *__gfs2_lookup(stru
 
 	d = d_splice_alias(inode, dentry);
 	if (IS_ERR(d)) {
-		iput(inode);
 		gfs2_glock_dq_uninit(&gh);
 		return d;
 	}


