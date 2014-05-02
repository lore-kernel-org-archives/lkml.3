Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753665AbaEBP4O (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 May 2014 11:56:14 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:44223 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753866AbaEBPp0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 May 2014 11:45:26 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: "J. Bruce Fields" <bfields@redhat.com>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13 097/151] nfsd: notify_change needs elevated write count
Date: Fri,  2 May 2014 08:38:05 -0700
Message-Id: <1399045139-4531-98-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1399045139-4531-1-git-send-email-kamal@canonical.com>
References: <1399045139-4531-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11.1 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: "J. Bruce Fields" <bfields@redhat.com>

commit 9f67f189939eccaa54f3d2c9cf10788abaf2d584 upstream.

Looks like this bug has been here since these write counts were
introduced, not sure why it was just noticed now.

Thanks also to Jan Kara for pointing out the problem.

Reported-by: Matthew Rahtz <mrahtz@rapitasystems.com>
Signed-off-by: J. Bruce Fields <bfields@redhat.com>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 fs/nfsd/vfs.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/fs/nfsd/vfs.c b/fs/nfsd/vfs.c
index 7eea63c..6896f7d 100644
--- a/fs/nfsd/vfs.c
+++ b/fs/nfsd/vfs.c
@@ -407,6 +407,7 @@ nfsd_setattr(struct svc_rqst *rqstp, struct svc_fh *fhp, struct iattr *iap,
 	umode_t		ftype = 0;
 	__be32		err;
 	int		host_err;
+	bool		get_write_count;
 	int		size_change = 0;
 
 	if (iap->ia_valid & (ATTR_ATIME | ATTR_MTIME | ATTR_SIZE))
@@ -414,10 +415,18 @@ nfsd_setattr(struct svc_rqst *rqstp, struct svc_fh *fhp, struct iattr *iap,
 	if (iap->ia_valid & ATTR_SIZE)
 		ftype = S_IFREG;
 
+	/* Callers that do fh_verify should do the fh_want_write: */
+	get_write_count = !fhp->fh_dentry;
+
 	/* Get inode */
 	err = fh_verify(rqstp, fhp, ftype, accmode);
 	if (err)
 		goto out;
+	if (get_write_count) {
+		host_err = fh_want_write(fhp);
+		if (host_err)
+			return nfserrno(host_err);
+	}
 
 	dentry = fhp->fh_dentry;
 	inode = dentry->d_inode;
-- 
1.9.1

