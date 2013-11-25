Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755437Ab3KYOEj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Nov 2013 09:04:39 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:58999 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754348Ab3KYNxs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Nov 2013 08:53:48 -0500
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
Message-ID: <lsq.1385387069.867812735@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [PATCH 3.2 25/87] nfsd: vfs_llseek() with 32 or 64 bit offsets
 (hashes)
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

commit 06effdbb49af5f6c7d20affaec74603914acc768 upstream.

Use 32-bit or 64-bit llseek() hashes for directory offsets depending on
the NFS version. NFSv2 gets 32-bit hashes only.

NOTE: This patch got rather complex as Christoph asked to set the
filp->f_mode flag in the open call or immediatly after dentry_open()
in nfsd_open() to avoid races.
Personally I still do not see a reason for that and in my opinion
FMODE_32BITHASH/FMODE_64BITHASH flags could be set nfsd_readdir(), as it
follows directly after nfsd_open() without a chance of races.

Signed-off-by: Bernd Schubert <bernd.schubert@itwm.fraunhofer.de>
Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
Acked-by: J. Bruce Fields <bfields@redhat.com>
Signed-off-by: Jonathan Nieder <jrnieder@gmail.com>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 fs/nfsd/vfs.c |   15 +++++++++++++--
 fs/nfsd/vfs.h |    2 ++
 2 files changed, 15 insertions(+), 2 deletions(-)

--- a/fs/nfsd/vfs.c
+++ b/fs/nfsd/vfs.c
@@ -786,9 +786,15 @@ nfsd_open(struct svc_rqst *rqstp, struct
 	if (IS_ERR(*filp)) {
 		host_err = PTR_ERR(*filp);
 		*filp = NULL;
-	} else
+	} else {
 		host_err = ima_file_check(*filp, may_flags);
 
+		if (may_flags & NFSD_MAY_64BIT_COOKIE)
+			(*filp)->f_mode |= FMODE_64BITHASH;
+		else
+			(*filp)->f_mode |= FMODE_32BITHASH;
+	}
+
 out_nfserr:
 	err = nfserrno(host_err);
 out:
@@ -2018,8 +2024,13 @@ nfsd_readdir(struct svc_rqst *rqstp, str
 	__be32		err;
 	struct file	*file;
 	loff_t		offset = *offsetp;
+	int             may_flags = NFSD_MAY_READ;
+
+	/* NFSv2 only supports 32 bit cookies */
+	if (rqstp->rq_vers > 2)
+		may_flags |= NFSD_MAY_64BIT_COOKIE;
 
-	err = nfsd_open(rqstp, fhp, S_IFDIR, NFSD_MAY_READ, &file);
+	err = nfsd_open(rqstp, fhp, S_IFDIR, may_flags, &file);
 	if (err)
 		goto out;
 
--- a/fs/nfsd/vfs.h
+++ b/fs/nfsd/vfs.h
@@ -27,6 +27,8 @@
 #define NFSD_MAY_BYPASS_GSS		0x400
 #define NFSD_MAY_READ_IF_EXEC		0x800
 
+#define NFSD_MAY_64BIT_COOKIE		0x1000 /* 64 bit readdir cookies for >= NFSv3 */
+
 #define NFSD_MAY_CREATE		(NFSD_MAY_EXEC|NFSD_MAY_WRITE)
 #define NFSD_MAY_REMOVE		(NFSD_MAY_EXEC|NFSD_MAY_WRITE|NFSD_MAY_TRUNC)
 

