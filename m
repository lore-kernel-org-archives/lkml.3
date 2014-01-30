Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752853AbaA3Kq1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Jan 2014 05:46:27 -0500
Received: from bombadil.infradead.org ([198.137.202.9]:51217 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751445AbaA3KqY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Jan 2014 05:46:24 -0500
Date: Thu, 30 Jan 2014 02:46:19 -0800
From: Christoph Hellwig <hch@infradead.org>
To: Sage Weil <sage@inktank.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Dave Jones <davej@redhat.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        ceph-devel@vger.kernel.org,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        Christoph Hellwig <hch@infradead.org>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Guangliang Zhao <lucienchao@gmail.com>,
        Li Wang <li.wang@ubuntykylin.com>, zheng.z.yan@intel.com
Subject: Re: [GIT PULL] Ceph updates for -rc1
Message-ID: <20140130104619.GA13139@infradead.org>
References: <alpine.DEB.2.00.1401281032560.16427@cobra.newdream.net>
 <20140128211021.GB1377@redhat.com>
 <CA+55aFxmQZ+sAC+_a=QXUSVQ1e=cSVkeZVL4d8kawFp9N5eS-w@mail.gmail.com>
 <alpine.DEB.2.00.1401282145410.17720@cobra.newdream.net>
 <alpine.DEB.2.00.1401290623040.27886@cobra.newdream.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.1401290623040.27886@cobra.newdream.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 29, 2014 at 06:30:00AM -0800, Sage Weil wrote:
> The set_acl inode_operation wasn't getting set, and the prototype needed 
> to be adjusted a bit (it doesn't take a dentry anymore).  All seems to be 
> well with the below patch.

Btw, there's a few minor bits that should go on top of yours:

 - ->get_acl only gets called after we checked for a cached ACL, so no
   need to call get_cached_acl again.
 - no need to check IS_POSIXACL in ->get_acl, without that it should
   never get set as all the callers that set it already have the check.
 - you should be able to use the full posix_acl_create in CEPH

Untested patch below:

diff --git a/fs/ceph/acl.c b/fs/ceph/acl.c
index 66d377a..9ab312e 100644
--- a/fs/ceph/acl.c
+++ b/fs/ceph/acl.c
@@ -66,13 +66,6 @@ struct posix_acl *ceph_get_acl(struct inode *inode, int type)
 	char *value = NULL;
 	struct posix_acl *acl;
 
-	if (!IS_POSIXACL(inode))
-		return NULL;
-
-	acl = ceph_get_cached_acl(inode, type);
-	if (acl != ACL_NOT_CACHED)
-		return acl;
-
 	switch (type) {
 	case ACL_TYPE_ACCESS:
 		name = POSIX_ACL_XATTR_ACCESS;
@@ -190,41 +183,24 @@ out:
 
 int ceph_init_acl(struct dentry *dentry, struct inode *inode, struct inode *dir)
 {
-	struct posix_acl *acl = NULL;
-	int ret = 0;
-
-	if (!S_ISLNK(inode->i_mode)) {
-		if (IS_POSIXACL(dir)) {
-			acl = ceph_get_acl(dir, ACL_TYPE_DEFAULT);
-			if (IS_ERR(acl)) {
-				ret = PTR_ERR(acl);
-				goto out;
-			}
-		}
+	struct posix_acl *default_acl, *acl;
+	int error;
 
-		if (!acl)
-			inode->i_mode &= ~current_umask();
-	}
+	error = posix_acl_create(dir, &inode->i_mode, &default_acl, &acl);
+	if (error)
+		return error;
 
-	if (IS_POSIXACL(dir) && acl) {
-		if (S_ISDIR(inode->i_mode)) {
-			ret = ceph_set_acl(inode, acl, ACL_TYPE_DEFAULT);
-			if (ret)
-				goto out_release;
-		}
-		ret = __posix_acl_create(&acl, GFP_NOFS, &inode->i_mode);
-		if (ret < 0)
-			goto out;
-		else if (ret > 0)
-			ret = ceph_set_acl(inode, acl, ACL_TYPE_ACCESS);
-		else
-			cache_no_acl(inode);
-	} else {
+	if (!default_acl && !acl)
 		cache_no_acl(inode);
-	}
 
-out_release:
-	posix_acl_release(acl);
-out:
-	return ret;
+	if (default_acl) {
+		error = ceph_set_acl(inode, default_acl, ACL_TYPE_DEFAULT);
+		posix_acl_release(default_acl);
+	}
+	if (acl) {
+		if (!error)
+			error = ceph_set_acl(inode, acl, ACL_TYPE_ACCESS);
+		posix_acl_release(acl);
+	}
+	return error;
 }
