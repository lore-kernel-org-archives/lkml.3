Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756668AbaBRPeW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Feb 2014 10:34:22 -0500
Received: from mfb01-md.ns.itscom.net ([175.177.155.109]:39092 "EHLO
	mfb01-md.ns.itscom.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756451AbaBRPeU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Feb 2014 10:34:20 -0500
X-Greylist: delayed 383 seconds by postgrey-1.27 at vger.kernel.org; Tue, 18 Feb 2014 10:34:20 EST
From: "J. R. Okajima" <hooanon05g@gmail.com>
To: "J. Bruce Fields" <bfields@redhat.com>
cc: Jeff Layton <jlayton@redhat.com>, linux-kernel@vger.kernel.org
Subject: [PATCH] NFSD, lost nfserrno() call in nfsd_setattr()
Date: Wed, 19 Feb 2014 00:27:53 +0900
Message-ID: <20699.1392737273@jrobl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


There is a regression in
	208d0ac 2014-01-07 nfsd4: break only delegations when appropriate
which deletes an nfserrno() call in nfsd_setattr() (by accident,
probably), and NFSD becomes ignoring an error from VFS.

Here is a patch to fix it.

J. R. Okajima


diff --git a/fs/nfsd/vfs.c b/fs/nfsd/vfs.c
index 017d3cb..6d7be3f 100644
--- a/fs/nfsd/vfs.c
+++ b/fs/nfsd/vfs.c
@@ -449,6 +449,7 @@ nfsd_setattr(struct svc_rqst *rqstp, struct svc_fh *fhp, struct iattr *iap,
 	fh_lock(fhp);
 	host_err = notify_change(dentry, iap, NULL);
 	fh_unlock(fhp);
+	err = nfserrno(host_err);
 
 out_put_write_access:
 	if (size_change)
