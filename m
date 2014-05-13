Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932779AbaEMJ77 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2014 05:59:59 -0400
Received: from ip4-83-240-18-248.cust.nbox.cz ([83.240.18.248]:60826 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760074AbaEMJ24 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2014 05:28:56 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
        Trond Myklebust <trond.myklebust@primarydata.com>,
        Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 056/182] NFSv4: Fix a use-after-free problem in open()
Date: Tue, 13 May 2014 11:26:48 +0200
Message-Id: <c637626054eb5df8f5efa0abad438ab9ce64c933.1399973152.git.jslaby@suse.cz>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <7aa1bde8f6143b2db33e6567a8c3a4debaa246f4.1399973152.git.jslaby@suse.cz>
References: <7aa1bde8f6143b2db33e6567a8c3a4debaa246f4.1399973152.git.jslaby@suse.cz>
In-Reply-To: <cover.1399973152.git.jslaby@suse.cz>
References: <cover.1399973152.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Trond Myklebust <trond.myklebust@primarydata.com>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

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
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 fs/nfs/nfs4proc.c | 19 ++++++++++---------
 1 file changed, 10 insertions(+), 9 deletions(-)

diff --git a/fs/nfs/nfs4proc.c b/fs/nfs/nfs4proc.c
index bcd42fbc04e7..40062e42c955 100644
--- a/fs/nfs/nfs4proc.c
+++ b/fs/nfs/nfs4proc.c
@@ -1064,6 +1064,7 @@ static void nfs4_opendata_free(struct kref *kref)
 	dput(p->dentry);
 	nfs_sb_deactive(sb);
 	nfs_fattr_free_names(&p->f_attr);
+	kfree(p->f_attr.mdsthreshold);
 	kfree(p);
 }
 
@@ -2236,10 +2237,12 @@ static int _nfs4_do_open(struct inode *dir,
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
@@ -2267,11 +2270,10 @@ static int _nfs4_do_open(struct inode *dir,
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
 
@@ -2281,7 +2283,6 @@ static int _nfs4_do_open(struct inode *dir,
 err_free_label:
 	nfs4_label_free(olabel);
 err_opendata_put:
-	kfree(opendata->f_attr.mdsthreshold);
 	nfs4_opendata_put(opendata);
 err_put_state_owner:
 	nfs4_put_state_owner(sp);
-- 
1.9.3

