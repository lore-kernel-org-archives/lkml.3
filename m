Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755061Ab3KNQPm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Nov 2013 11:15:42 -0500
Received: from mail-pd0-f175.google.com ([209.85.192.175]:45802 "EHLO
	mail-pd0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754829Ab3KNQOs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Nov 2013 11:14:48 -0500
From: Peng Tao <bergwolf@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, "John L. Hammond" <john.hammond@intel.com>,
        Peng Tao <bergwolf@gmail.com>,
        Andreas Dilger <andreas.dilger@intel.com>
Subject: [PATCH 06/40] staging/lustre/llite: use correct FID in ll_och_fill()
Date: Fri, 15 Nov 2013 00:13:08 +0800
Message-Id: <1384445622-12346-7-git-send-email-bergwolf@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1384445622-12346-1-git-send-email-bergwolf@gmail.com>
References: <1384445622-12346-1-git-send-email-bergwolf@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "John L. Hammond" <john.hammond@intel.com>

When ll_intent_file_open() is called on a file with a stale dentry,
ll_och_fill() may incorrectly use the FID from the struct
ll_inode_info rather than the FID from the response body (which is the
correct FID for the close). Fix this, remove the ll_inode_info
parameter from ll_och_fill(), and move the call to ll_ioepoch_open()
from ll_och_fill() to ll_local_open().

Intel-bug-id: https://jira.hpdd.intel.com/browse/LU-3233
Lustre-change: http://review.whamcloud.com/6695
Signed-off-by: John L. Hammond <john.hammond@intel.com>
Reviewed-by: Fan Yong <fan.yong@intel.com>
Reviewed-by: Mike Pershin <mike.pershin@intel.com>
Reviewed-by: Oleg Drokin <oleg.drokin@intel.com>
Signed-off-by: Peng Tao <bergwolf@gmail.com>
Signed-off-by: Andreas Dilger <andreas.dilger@intel.com>
---
 drivers/staging/lustre/lustre/llite/file.c |   25 ++++++++-----------------
 1 file changed, 8 insertions(+), 17 deletions(-)

diff --git a/drivers/staging/lustre/lustre/llite/file.c b/drivers/staging/lustre/lustre/llite/file.c
index 56d9d36..eab9f03 100644
--- a/drivers/staging/lustre/lustre/llite/file.c
+++ b/drivers/staging/lustre/lustre/llite/file.c
@@ -431,22 +431,17 @@ void ll_ioepoch_open(struct ll_inode_info *lli, __u64 ioepoch)
 	}
 }
 
-static int ll_och_fill(struct obd_export *md_exp, struct ll_inode_info *lli,
-		       struct lookup_intent *it, struct obd_client_handle *och)
+static int ll_och_fill(struct obd_export *md_exp, struct lookup_intent *it,
+		       struct obd_client_handle *och)
 {
 	struct ptlrpc_request *req = it->d.lustre.it_data;
 	struct mdt_body *body;
 
-	LASSERT(och);
-
 	body = req_capsule_server_get(&req->rq_pill, &RMF_MDT_BODY);
-	LASSERT(body != NULL);		      /* reply already checked out */
-
-	memcpy(&och->och_fh, &body->handle, sizeof(body->handle));
+	och->och_fh = body->handle;
+	och->och_fid = body->fid1;
 	och->och_magic = OBD_CLIENT_HANDLE_MAGIC;
-	och->och_fid = lli->lli_fid;
 	och->och_flags = it->it_flags;
-	ll_ioepoch_open(lli, body->ioepoch);
 
 	return md_set_open_replay_data(md_exp, och, req);
 }
@@ -466,15 +461,12 @@ int ll_local_open(struct file *file, struct lookup_intent *it,
 		struct mdt_body *body;
 		int rc;
 
-		rc = ll_och_fill(ll_i2sbi(inode)->ll_md_exp, lli, it, och);
-		if (rc)
+		rc = ll_och_fill(ll_i2sbi(inode)->ll_md_exp, it, och);
+		if (rc != 0)
 			return rc;
 
 		body = req_capsule_server_get(&req->rq_pill, &RMF_MDT_BODY);
-		if ((it->it_flags & FMODE_WRITE) &&
-		    (body->valid & OBD_MD_FLSIZE))
-			CDEBUG(D_INODE, "Epoch "LPU64" opened on "DFID"\n",
-			       lli->lli_ioepoch, PFID(&lli->lli_fid));
+		ll_ioepoch_open(lli, body->ioepoch);
 	}
 
 	LUSTRE_FPRIVATE(file) = fd;
@@ -1482,8 +1474,7 @@ int ll_release_openhandle(struct dentry *dentry, struct lookup_intent *it)
 	if (!och)
 		GOTO(out, rc = -ENOMEM);
 
-	ll_och_fill(ll_i2sbi(inode)->ll_md_exp,
-		    ll_i2info(inode), it, och);
+	ll_och_fill(ll_i2sbi(inode)->ll_md_exp, it, och);
 
 	rc = ll_close_inode_openhandle(ll_i2sbi(inode)->ll_md_exp,
 				       inode, och);
-- 
1.7.9.5

