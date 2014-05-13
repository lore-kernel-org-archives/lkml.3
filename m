Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933197AbaEMKCv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2014 06:02:51 -0400
Received: from ip4-83-240-18-248.cust.nbox.cz ([83.240.18.248]:60814 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760069AbaEMJ24 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2014 05:28:56 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, "J. Bruce Fields" <bfields@redhat.com>,
        Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 061/182] nfsd: notify_change needs elevated write count
Date: Tue, 13 May 2014 11:26:53 +0200
Message-Id: <564680c1eabc4d4a8f9af7618f79a995914a6ea7.1399973152.git.jslaby@suse.cz>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <7aa1bde8f6143b2db33e6567a8c3a4debaa246f4.1399973152.git.jslaby@suse.cz>
References: <7aa1bde8f6143b2db33e6567a8c3a4debaa246f4.1399973152.git.jslaby@suse.cz>
In-Reply-To: <cover.1399973152.git.jslaby@suse.cz>
References: <cover.1399973152.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "J. Bruce Fields" <bfields@redhat.com>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

commit 9f67f189939eccaa54f3d2c9cf10788abaf2d584 upstream.

Looks like this bug has been here since these write counts were
introduced, not sure why it was just noticed now.

Thanks also to Jan Kara for pointing out the problem.

Reported-by: Matthew Rahtz <mrahtz@rapitasystems.com>
Signed-off-by: J. Bruce Fields <bfields@redhat.com>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 fs/nfsd/vfs.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/fs/nfsd/vfs.c b/fs/nfsd/vfs.c
index 72cb28e73ca0..e9a80e4553a3 100644
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
1.9.3

