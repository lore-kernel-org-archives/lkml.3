Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756671AbaEDQmh (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 May 2014 12:42:37 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:36036 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754014AbaEDPlk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 May 2014 11:41:40 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Steve Dickson <SteveD@redhat.com>,
        Trond Myklebust <trond.myklebust@primarydata.com>
Subject: [PATCH 3.14 069/158] NFSv4: Fix a use-after-free problem in open()
Date: Sun,  4 May 2014 11:39:38 -0400
Message-Id: <20140504154039.300909793@linuxfoundation.org>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <20140504154029.975081050@linuxfoundation.org>
References: <20140504154029.975081050@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.14-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/nfs/nfs4proc.c |   19 ++++++++++---------
 1 file changed, 10 insertions(+), 9 deletions(-)

--- a/fs/nfs/nfs4proc.c
+++ b/fs/nfs/nfs4proc.c
@@ -1068,6 +1068,7 @@ static void nfs4_opendata_free(struct kr
 	dput(p->dentry);
 	nfs_sb_deactive(sb);
 	nfs_fattr_free_names(&p->f_attr);
+	kfree(p->f_attr.mdsthreshold);
 	kfree(p);
 }
 
@@ -2244,10 +2245,12 @@ static int _nfs4_do_open(struct inode *d
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
@@ -2275,11 +2278,10 @@ static int _nfs4_do_open(struct inode *d
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
 
@@ -2289,7 +2291,6 @@ static int _nfs4_do_open(struct inode *d
 err_free_label:
 	nfs4_label_free(olabel);
 err_opendata_put:
-	kfree(opendata->f_attr.mdsthreshold);
 	nfs4_opendata_put(opendata);
 err_put_state_owner:
 	nfs4_put_state_owner(sp);


