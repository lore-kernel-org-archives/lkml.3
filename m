Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756912Ab3KYN7Z (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Nov 2013 08:59:25 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:59000 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754448Ab3KYNxw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Nov 2013 08:53:52 -0500
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org,
        "Bernd Schubert" <bernd.schubert@itwm.fraunhofer.de>,
        "Theodore Ts'o" <tytso@mit.edu>,
        "Jonathan Nieder" <jrnieder@gmail.com>,
        "J. Bruce Fields" <bfields@redhat.com>
Date: Mon, 25 Nov 2013 13:44:29 +0000
Message-ID: <lsq.1385387069.718473425@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [PATCH 3.2 24/87] nfsd: rename 'int access' to 'int may_flags' in
 nfsd_open()
In-Reply-To: <lsq.1385387069.559528559@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.212
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.53-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Bernd Schubert <bernd.schubert@itwm.fraunhofer.de>

commit 999448a8c0202d8c41711c92385323520644527b upstream.

Just rename this variable, as the next patch will add a flag and
'access' as variable name would not be correct any more.

Signed-off-by: Bernd Schubert <bernd.schubert@itwm.fraunhofer.de>
Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
Acked-by: J. Bruce Fields <bfields@redhat.com>
Signed-off-by: Jonathan Nieder <jrnieder@gmail.com>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 fs/nfsd/vfs.c |   18 ++++++++++--------
 1 file changed, 10 insertions(+), 8 deletions(-)

--- a/fs/nfsd/vfs.c
+++ b/fs/nfsd/vfs.c
@@ -726,12 +726,13 @@ static int nfsd_open_break_lease(struct
 
 /*
  * Open an existing file or directory.
- * The access argument indicates the type of open (read/write/lock)
+ * The may_flags argument indicates the type of open (read/write/lock)
+ * and additional flags.
  * N.B. After this call fhp needs an fh_put
  */
 __be32
 nfsd_open(struct svc_rqst *rqstp, struct svc_fh *fhp, int type,
-			int access, struct file **filp)
+			int may_flags, struct file **filp)
 {
 	struct dentry	*dentry;
 	struct inode	*inode;
@@ -746,7 +747,7 @@ nfsd_open(struct svc_rqst *rqstp, struct
 	 * and (hopefully) checked permission - so allow OWNER_OVERRIDE
 	 * in case a chmod has now revoked permission.
 	 */
-	err = fh_verify(rqstp, fhp, type, access | NFSD_MAY_OWNER_OVERRIDE);
+	err = fh_verify(rqstp, fhp, type, may_flags | NFSD_MAY_OWNER_OVERRIDE);
 	if (err)
 		goto out;
 
@@ -757,7 +758,7 @@ nfsd_open(struct svc_rqst *rqstp, struct
 	 * or any access when mandatory locking enabled
 	 */
 	err = nfserr_perm;
-	if (IS_APPEND(inode) && (access & NFSD_MAY_WRITE))
+	if (IS_APPEND(inode) && (may_flags & NFSD_MAY_WRITE))
 		goto out;
 	/*
 	 * We must ignore files (but only files) which might have mandatory
@@ -770,12 +771,12 @@ nfsd_open(struct svc_rqst *rqstp, struct
 	if (!inode->i_fop)
 		goto out;
 
-	host_err = nfsd_open_break_lease(inode, access);
+	host_err = nfsd_open_break_lease(inode, may_flags);
 	if (host_err) /* NOMEM or WOULDBLOCK */
 		goto out_nfserr;
 
-	if (access & NFSD_MAY_WRITE) {
-		if (access & NFSD_MAY_READ)
+	if (may_flags & NFSD_MAY_WRITE) {
+		if (may_flags & NFSD_MAY_READ)
 			flags = O_RDWR|O_LARGEFILE;
 		else
 			flags = O_WRONLY|O_LARGEFILE;
@@ -786,7 +787,8 @@ nfsd_open(struct svc_rqst *rqstp, struct
 		host_err = PTR_ERR(*filp);
 		*filp = NULL;
 	} else
-		host_err = ima_file_check(*filp, access);
+		host_err = ima_file_check(*filp, may_flags);
+
 out_nfserr:
 	err = nfserrno(host_err);
 out:

