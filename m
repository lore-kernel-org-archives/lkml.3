Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933647Ab3LERsL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Dec 2013 12:48:11 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:38330 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757303Ab3LERhn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Dec 2013 12:37:43 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Christoph Hellwig <hch@lst.de>, "J. Bruce Fields" <bfields@redhat.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.5 60/90] nfsd: split up nfsd_setattr
Date: Thu,  5 Dec 2013 17:35:42 +0000
Message-Id: <1386264972-5399-61-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1386264972-5399-1-git-send-email-luis.henriques@canonical.com>
References: <1386264972-5399-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.27 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Christoph Hellwig <hch@infradead.org>

commit 818e5a22e907fbae75e9c1fd78233baec9fa64b6 upstream.

Split out two helpers to make the code more readable and easier to verify
for correctness.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: J. Bruce Fields <bfields@redhat.com>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 fs/nfsd/vfs.c | 144 ++++++++++++++++++++++++++++++++++------------------------
 1 file changed, 84 insertions(+), 60 deletions(-)

diff --git a/fs/nfsd/vfs.c b/fs/nfsd/vfs.c
index 20c5092..5a34e9e 100644
--- a/fs/nfsd/vfs.c
+++ b/fs/nfsd/vfs.c
@@ -297,41 +297,12 @@ commit_metadata(struct svc_fh *fhp)
 }
 
 /*
- * Set various file attributes.
- * N.B. After this call fhp needs an fh_put
+ * Go over the attributes and take care of the small differences between
+ * NFS semantics and what Linux expects.
  */
-__be32
-nfsd_setattr(struct svc_rqst *rqstp, struct svc_fh *fhp, struct iattr *iap,
-	     int check_guard, time_t guardtime)
+static void
+nfsd_sanitize_attrs(struct inode *inode, struct iattr *iap)
 {
-	struct dentry	*dentry;
-	struct inode	*inode;
-	int		accmode = NFSD_MAY_SATTR;
-	umode_t		ftype = 0;
-	__be32		err;
-	int		host_err;
-	int		size_change = 0;
-
-	if (iap->ia_valid & (ATTR_ATIME | ATTR_MTIME | ATTR_SIZE))
-		accmode |= NFSD_MAY_WRITE|NFSD_MAY_OWNER_OVERRIDE;
-	if (iap->ia_valid & ATTR_SIZE)
-		ftype = S_IFREG;
-
-	/* Get inode */
-	err = fh_verify(rqstp, fhp, ftype, accmode);
-	if (err)
-		goto out;
-
-	dentry = fhp->fh_dentry;
-	inode = dentry->d_inode;
-
-	/* Ignore any mode updates on symlinks */
-	if (S_ISLNK(inode->i_mode))
-		iap->ia_valid &= ~ATTR_MODE;
-
-	if (!iap->ia_valid)
-		goto out;
-
 	/*
 	 * NFSv2 does not differentiate between "set-[ac]time-to-now"
 	 * which only requires access, and "set-[ac]time-to-X" which
@@ -341,8 +312,7 @@ nfsd_setattr(struct svc_rqst *rqstp, struct svc_fh *fhp, struct iattr *iap,
 	 * convert to "set to now" instead of "set to explicit time"
 	 *
 	 * We only call inode_change_ok as the last test as technically
-	 * it is not an interface that we should be using.  It is only
-	 * valid if the filesystem does not define it's own i_op->setattr.
+	 * it is not an interface that we should be using.
 	 */
 #define BOTH_TIME_SET (ATTR_ATIME_SET | ATTR_MTIME_SET)
 #define	MAX_TOUCH_TIME_ERROR (30*60)
@@ -368,30 +338,6 @@ nfsd_setattr(struct svc_rqst *rqstp, struct svc_fh *fhp, struct iattr *iap,
 			iap->ia_valid &= ~BOTH_TIME_SET;
 		}
 	}
-	    
-	/*
-	 * The size case is special.
-	 * It changes the file as well as the attributes.
-	 */
-	if (iap->ia_valid & ATTR_SIZE) {
-		if (iap->ia_size < inode->i_size) {
-			err = nfsd_permission(rqstp, fhp->fh_export, dentry,
-					NFSD_MAY_TRUNC|NFSD_MAY_OWNER_OVERRIDE);
-			if (err)
-				goto out;
-		}
-
-		host_err = get_write_access(inode);
-		if (host_err)
-			goto out_nfserr;
-
-		size_change = 1;
-		host_err = locks_verify_truncate(inode, NULL, iap->ia_size);
-		if (host_err) {
-			put_write_access(inode);
-			goto out_nfserr;
-		}
-	}
 
 	/* sanitize the mode change */
 	if (iap->ia_valid & ATTR_MODE) {
@@ -414,8 +360,86 @@ nfsd_setattr(struct svc_rqst *rqstp, struct svc_fh *fhp, struct iattr *iap,
 			iap->ia_valid |= (ATTR_KILL_SUID | ATTR_KILL_SGID);
 		}
 	}
+}
 
-	/* Change the attributes. */
+static __be32
+nfsd_get_write_access(struct svc_rqst *rqstp, struct svc_fh *fhp,
+		struct iattr *iap)
+{
+	struct inode *inode = fhp->fh_dentry->d_inode;
+	int host_err;
+
+	if (iap->ia_size < inode->i_size) {
+		__be32 err;
+
+		err = nfsd_permission(rqstp, fhp->fh_export, fhp->fh_dentry,
+				NFSD_MAY_TRUNC | NFSD_MAY_OWNER_OVERRIDE);
+		if (err)
+			return err;
+	}
+
+	host_err = get_write_access(inode);
+	if (host_err)
+		goto out_nfserrno;
+
+	host_err = locks_verify_truncate(inode, NULL, iap->ia_size);
+	if (host_err)
+		goto out_put_write_access;
+	return 0;
+
+out_put_write_access:
+	put_write_access(inode);
+out_nfserrno:
+	return nfserrno(host_err);
+}
+
+/*
+ * Set various file attributes.  After this call fhp needs an fh_put.
+ */
+__be32
+nfsd_setattr(struct svc_rqst *rqstp, struct svc_fh *fhp, struct iattr *iap,
+	     int check_guard, time_t guardtime)
+{
+	struct dentry	*dentry;
+	struct inode	*inode;
+	int		accmode = NFSD_MAY_SATTR;
+	umode_t		ftype = 0;
+	__be32		err;
+	int		host_err;
+	int		size_change = 0;
+
+	if (iap->ia_valid & (ATTR_ATIME | ATTR_MTIME | ATTR_SIZE))
+		accmode |= NFSD_MAY_WRITE|NFSD_MAY_OWNER_OVERRIDE;
+	if (iap->ia_valid & ATTR_SIZE)
+		ftype = S_IFREG;
+
+	/* Get inode */
+	err = fh_verify(rqstp, fhp, ftype, accmode);
+	if (err)
+		goto out;
+
+	dentry = fhp->fh_dentry;
+	inode = dentry->d_inode;
+
+	/* Ignore any mode updates on symlinks */
+	if (S_ISLNK(inode->i_mode))
+		iap->ia_valid &= ~ATTR_MODE;
+
+	if (!iap->ia_valid)
+		goto out;
+
+	nfsd_sanitize_attrs(inode, iap);
+
+	/*
+	 * The size case is special, it changes the file in addition to the
+	 * attributes.
+	 */
+	if (iap->ia_valid & ATTR_SIZE) {
+		err = nfsd_get_write_access(rqstp, fhp, iap);
+		if (err)
+			goto out;
+		size_change = 1;
+	}
 
 	iap->ia_valid |= ATTR_CTIME;
 
-- 
1.8.3.2

