Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760300Ab3K0Bsw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Nov 2013 20:48:52 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:39084 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758039Ab3K0A5o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Nov 2013 19:57:44 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Christoph Hellwig <hch@lst.de>, "J. Bruce Fields" <bfields@redhat.com>
Subject: [PATCH 3.10 55/80] nfsd: make sure to balance get/put_write_access
Date: Tue, 26 Nov 2013 16:57:24 -0800
Message-Id: <20131127005644.767038068@linuxfoundation.org>
X-Mailer: git-send-email 1.8.5.rc3
In-Reply-To: <20131127005640.934155527@linuxfoundation.org>
References: <20131127005640.934155527@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/nfsd/vfs.c |   29 +++++++++++++++--------------
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


