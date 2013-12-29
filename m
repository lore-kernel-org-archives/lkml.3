Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755884Ab3L2CZm (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Dec 2013 21:25:42 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:55568 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753296Ab3L2CLC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Dec 2013 21:11:02 -0500
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "J. Bruce Fields" <bfields@redhat.com>,
        "Christoph Hellwig" <hch@infradead.org>,
        "Christoph Hellwig" <hch@lst.de>
Date: Sun, 29 Dec 2013 03:08:43 +0100
Message-ID: <lsq.1388282923.601886880@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [PATCH 3.2 073/185] nfsd: make sure to balance get/put_write_access
In-Reply-To: <lsq.1388282923.751256928@decadent.org.uk>
X-SA-Exim-Connect-IP: 31.18.200.85
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.54-rc1 review patch.  If anyone has any objections, please let me know.

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
[bwh: Backported to 3.2: notify_change() takes only 2 arguments]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 fs/nfsd/vfs.c | 29 +++++++++++++++--------------
 1 file changed, 15 insertions(+), 14 deletions(-)

--- a/fs/nfsd/vfs.c
+++ b/fs/nfsd/vfs.c
@@ -443,27 +443,28 @@ nfsd_setattr(struct svc_rqst *rqstp, str
 
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

