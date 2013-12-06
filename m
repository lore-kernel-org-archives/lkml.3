Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759344Ab3LFXqE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Dec 2013 18:46:04 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:48520 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161897Ab3LFXPK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Dec 2013 18:15:10 -0500
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Christoph Hellwig <hch@lst.de>, "J. Bruce Fields" <bfields@redhat.com>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.8 137/152] nfsd: make sure to balance get/put_write_access
Date: Fri,  6 Dec 2013 15:11:01 -0800
Message-Id: <1386371476-2477-138-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1386371476-2477-1-git-send-email-kamal@canonical.com>
References: <1386371476-2477-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.14 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Christoph Hellwig <hch@infradead.org>

commit 987da4791052fa298b7cfcde4dea9f6f2bbc786b upstream.

Use a straight goto error label style in nfsd_setattr to make sure
we always do the put_write_access call after we got it earlier.

Note that the we have been failing to do that in the case
nfsd_break_lease() returns an error, a bug introduced into 2.6.38 with
6a76bebefe15d9a08864f824d7f8d5beaf37c997 "nfsd4: break lease on nfsd
setattr".

Signed-off-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: J. Bruce Fields <bfields@redhat.com>
[ kamal: backport to 3.8 (notify_change args) ]
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 fs/nfsd/vfs.c | 29 +++++++++++++++--------------
 1 file changed, 15 insertions(+), 14 deletions(-)

diff --git a/fs/nfsd/vfs.c b/fs/nfsd/vfs.c
index 4fc2843..59f1e77 100644
--- a/fs/nfsd/vfs.c
+++ b/fs/nfsd/vfs.c
@@ -443,27 +443,28 @@ nfsd_setattr(struct svc_rqst *rqstp, struct svc_fh *fhp, struct iattr *iap,
 
 	iap->ia_valid |= ATTR_CTIME;
 
-	err = nfserr_notsync;
-	if (!check_guard || guardtime == inode->i_ctime.tv_sec) {
-		host_err = nfsd_break_lease(inode);
-		if (host_err)
-			goto out_nfserr;
-		fh_lock(fhp);
-
-		host_err = notify_change(dentry, iap);
-		err = nfserrno(host_err);
-		fh_unlock(fhp);
+	if (check_guard && guardtime != inode->i_ctime.tv_sec) {
+		err = nfserr_notsync;
+		goto out_put_write_access;
 	}
+
+	host_err = nfsd_break_lease(inode);
+	if (host_err)
+		goto out_put_write_access_nfserror;
+
+	fh_lock(fhp);
+	host_err = notify_change(dentry, iap);
+	fh_unlock(fhp);
+
+out_put_write_access_nfserror:
+	err = nfserrno(host_err);
+out_put_write_access:
 	if (size_change)
 		put_write_access(inode);
 	if (!err)
 		commit_metadata(fhp);
 out:
 	return err;
-
-out_nfserr:
-	err = nfserrno(host_err);
-	goto out;
 }
 
 #if defined(CONFIG_NFSD_V2_ACL) || \
-- 
1.8.3.2

