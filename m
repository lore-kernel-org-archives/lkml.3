Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753040AbaEBPq0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 May 2014 11:46:26 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:44306 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751764AbaEBPqS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 May 2014 11:46:18 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Trond Myklebust <trond.myklebust@primarydata.com>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13 107/151] NFSv4: Fix a use-after-free problem in open()
Date: Fri,  2 May 2014 08:38:15 -0700
Message-Id: <1399045139-4531-108-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1399045139-4531-1-git-send-email-kamal@canonical.com>
References: <1399045139-4531-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11.1 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Trond Myklebust <trond.myklebust@primarydata.com>

commit e911b8158ee1def8153849b1641b736026b036e0 upstream.

If we interrupt the nfs4_wait_for_completion_rpc_task() call in
nfs4_run_open_task(), then we don't prevent the RPC call from
completing. So freeing up the opendata->f_attr.mdsthreshold
in the error path in _nfs4_do_open() leads to a use-after-free
when the XDR decoder tries to decode the mdsthreshold information
from the server.

Fixes: 82be417aa37c0 (NFSv4.1 cache mdsthreshold values on OPEN)
Tested-by: Steve Dickson <SteveD@redhat.com>
Signed-off-by: Trond Myklebust <trond.myklebust@primarydata.com>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 fs/nfs/nfs4proc.c | 19 ++++++++++---------
 1 file changed, 10 insertions(+), 9 deletions(-)

diff --git a/fs/nfs/nfs4proc.c b/fs/nfs/nfs4proc.c
index 0e90bf0..134691e 100644
--- a/fs/nfs/nfs4proc.c
+++ b/fs/nfs/nfs4proc.c
@@ -1070,6 +1070,7 @@ static void nfs4_opendata_free(struct kref *kref)
 	dput(p->dentry);
 	nfs_sb_deactive(sb);
 	nfs_fattr_free_names(&p->f_attr);
+	kfree(p->f_attr.mdsthreshold);
 	kfree(p);
 }
 
@@ -2246,10 +2247,12 @@ static int _nfs4_do_open(struct inode *dir,
 		}
 	}
 
-	if (ctx_th && server->attr_bitmask[2] & FATTR4_WORD2_MDSTHRESHOLD) {
-		opendata->f_attr.mdsthreshold = pnfs_mdsthreshold_alloc();
-		if (!opendata->f_attr.mdsthreshold)
-			goto err_free_label;
+	if (server->attr_bitmask[2] & FATTR4_WORD2_MDSTHRESHOLD) {
+		if (!opendata->f_attr.mdsthreshold) {
+			opendata->f_attr.mdsthreshold = pnfs_mdsthreshold_alloc();
+			if (!opendata->f_attr.mdsthreshold)
+				goto err_free_label;
+		}
 		opendata->o_arg.open_bitmap = &nfs4_pnfs_open_bitmap[0];
 	}
 	if (dentry->d_inode != NULL)
@@ -2277,11 +2280,10 @@ static int _nfs4_do_open(struct inode *dir,
 	if (opendata->file_created)
 		*opened |= FILE_CREATED;
 
-	if (pnfs_use_threshold(ctx_th, opendata->f_attr.mdsthreshold, server))
+	if (pnfs_use_threshold(ctx_th, opendata->f_attr.mdsthreshold, server)) {
 		*ctx_th = opendata->f_attr.mdsthreshold;
-	else
-		kfree(opendata->f_attr.mdsthreshold);
-	opendata->f_attr.mdsthreshold = NULL;
+		opendata->f_attr.mdsthreshold = NULL;
+	}
 
 	nfs4_label_free(olabel);
 
@@ -2291,7 +2293,6 @@ static int _nfs4_do_open(struct inode *dir,
 err_free_label:
 	nfs4_label_free(olabel);
 err_opendata_put:
-	kfree(opendata->f_attr.mdsthreshold);
 	nfs4_opendata_put(opendata);
 err_put_state_owner:
 	nfs4_put_state_owner(sp);
-- 
1.9.1

