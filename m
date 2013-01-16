Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932325Ab3APQF0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jan 2013 11:05:26 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:36261 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932307Ab3APQFW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jan 2013 11:05:22 -0500
From: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: NeilBrown <neilb@suse.de>, "J. Bruce Fields" <bfields@redhat.com>,
        Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
Subject: [PATCH 123/222] nfsd: avoid permission checks on EXCLUSIVE_CREATE replay
Date: Wed, 16 Jan 2013 13:55:23 -0200
Message-Id: <1358351822-7675-124-git-send-email-herton.krzesinski@canonical.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1358351822-7675-1-git-send-email-herton.krzesinski@canonical.com>
References: <1358351822-7675-1-git-send-email-herton.krzesinski@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.3 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Neil Brown <neilb@suse.de>

commit 7007c90fb9fef593b4aeaeee57e6a6754276c97c upstream.

With NFSv4, if we create a file then open it we explicit avoid checking
the permissions on the file during the open because the fact that we
created it ensures we should be allow to open it (the create and the
open should appear to be a single operation).

However if the reply to an EXCLUSIVE create gets lots and the client
resends the create, the current code will perform the permission check -
because it doesn't realise that it did the open already..

This patch should fix this.

Note that I haven't actually seen this cause a problem.  I was just
looking at the code trying to figure out a different EXCLUSIVE open
related issue, and this looked wrong.

(Fix confirmed with pynfs 4.0 test OPEN4--bfields)

Signed-off-by: NeilBrown <neilb@suse.de>
[bfields: use OWNER_OVERRIDE and update for 4.1]
Signed-off-by: J. Bruce Fields <bfields@redhat.com>
Signed-off-by: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
---
 fs/nfsd/nfs4proc.c |    8 +++++---
 fs/nfsd/vfs.c      |   10 ++++++++--
 2 files changed, 13 insertions(+), 5 deletions(-)

diff --git a/fs/nfsd/nfs4proc.c b/fs/nfsd/nfs4proc.c
index 987e719..dd0308d 100644
--- a/fs/nfsd/nfs4proc.c
+++ b/fs/nfsd/nfs4proc.c
@@ -194,6 +194,7 @@ static __be32
 do_open_lookup(struct svc_rqst *rqstp, struct svc_fh *current_fh, struct nfsd4_open *open)
 {
 	struct svc_fh *resfh;
+	int accmode;
 	__be32 status;
 
 	resfh = kmalloc(sizeof(struct svc_fh), GFP_KERNEL);
@@ -253,9 +254,10 @@ do_open_lookup(struct svc_rqst *rqstp, struct svc_fh *current_fh, struct nfsd4_o
 	/* set reply cache */
 	fh_copy_shallow(&open->op_openowner->oo_owner.so_replay.rp_openfh,
 			&resfh->fh_handle);
-	if (!open->op_created)
-		status = do_open_permission(rqstp, resfh, open,
-					    NFSD_MAY_NOP);
+	accmode = NFSD_MAY_NOP;
+	if (open->op_created)
+		accmode |= NFSD_MAY_OWNER_OVERRIDE;
+	status = do_open_permission(rqstp, resfh, open, accmode);
 	set_change_info(&open->op_cinfo, current_fh);
 	fh_dup2(current_fh, resfh);
 out:
diff --git a/fs/nfsd/vfs.c b/fs/nfsd/vfs.c
index c8bd9c3..0191ede 100644
--- a/fs/nfsd/vfs.c
+++ b/fs/nfsd/vfs.c
@@ -1477,13 +1477,19 @@ do_nfsd_create(struct svc_rqst *rqstp, struct svc_fh *fhp,
 		case NFS3_CREATE_EXCLUSIVE:
 			if (   dchild->d_inode->i_mtime.tv_sec == v_mtime
 			    && dchild->d_inode->i_atime.tv_sec == v_atime
-			    && dchild->d_inode->i_size  == 0 )
+			    && dchild->d_inode->i_size  == 0 ) {
+				if (created)
+					*created = 1;
 				break;
+			}
 		case NFS4_CREATE_EXCLUSIVE4_1:
 			if (   dchild->d_inode->i_mtime.tv_sec == v_mtime
 			    && dchild->d_inode->i_atime.tv_sec == v_atime
-			    && dchild->d_inode->i_size  == 0 )
+			    && dchild->d_inode->i_size  == 0 ) {
+				if (created)
+					*created = 1;
 				goto set_attr;
+			}
 			 /* fallthru */
 		case NFS3_CREATE_GUARDED:
 			err = nfserr_exist;
-- 
1.7.9.5

