Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755507AbaEDPtz (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 May 2014 11:49:55 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:36838 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755034AbaEDPmz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 May 2014 11:42:55 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Matthew Rahtz <mrahtz@rapitasystems.com>,
        "J. Bruce Fields" <bfields@redhat.com>
Subject: [PATCH 3.4 19/43] nfsd: notify_change needs elevated write count
Date: Sun,  4 May 2014 11:42:13 -0400
Message-Id: <20140504154226.842447576@linuxfoundation.org>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <20140504154224.211508175@linuxfoundation.org>
References: <20140504154224.211508175@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: "J. Bruce Fields" <bfields@redhat.com>

commit 9f67f189939eccaa54f3d2c9cf10788abaf2d584 upstream.

Looks like this bug has been here since these write counts were
introduced, not sure why it was just noticed now.

Thanks also to Jan Kara for pointing out the problem.

Reported-by: Matthew Rahtz <mrahtz@rapitasystems.com>
Signed-off-by: J. Bruce Fields <bfields@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/nfsd/vfs.c |    9 +++++++++
 1 file changed, 9 insertions(+)

--- a/fs/nfsd/vfs.c
+++ b/fs/nfsd/vfs.c
@@ -406,6 +406,7 @@ nfsd_setattr(struct svc_rqst *rqstp, str
 	umode_t		ftype = 0;
 	__be32		err;
 	int		host_err;
+	bool		get_write_count;
 	int		size_change = 0;
 
 	if (iap->ia_valid & (ATTR_ATIME | ATTR_MTIME | ATTR_SIZE))
@@ -413,10 +414,18 @@ nfsd_setattr(struct svc_rqst *rqstp, str
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


