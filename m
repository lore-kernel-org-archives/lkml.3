Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754902AbaD1Bby (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Apr 2014 21:31:54 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:42873 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752538AbaD1B3V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Apr 2014 21:29:21 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "Matthew Rahtz" <mrahtz@rapitasystems.com>,
        "J. Bruce Fields" <bfields@redhat.com>
Date: Mon, 28 Apr 2014 02:11:22 +0100
Message-ID: <lsq.1398647482.821474566@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [PATCH 3.2 64/94] nfsd: notify_change needs elevated write count
In-Reply-To: <lsq.1398647481.453080089@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.249
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.58-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: "J. Bruce Fields" <bfields@redhat.com>

commit 9f67f189939eccaa54f3d2c9cf10788abaf2d584 upstream.

Looks like this bug has been here since these write counts were
introduced, not sure why it was just noticed now.

Thanks also to Jan Kara for pointing out the problem.

Reported-by: Matthew Rahtz <mrahtz@rapitasystems.com>
Signed-off-by: J. Bruce Fields <bfields@redhat.com>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 fs/nfsd/vfs.c | 9 +++++++++
 1 file changed, 9 insertions(+)

--- a/fs/nfsd/vfs.c
+++ b/fs/nfsd/vfs.c
@@ -406,6 +406,7 @@ nfsd_setattr(struct svc_rqst *rqstp, str
 	int		ftype = 0;
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

