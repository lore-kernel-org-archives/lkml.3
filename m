Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935233AbaICW5s (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Sep 2014 18:57:48 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:46333 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933077AbaICW0B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Sep 2014 18:26:01 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Trond Myklebust <trond.myklebust@primarydata.com>
Subject: [PATCH 3.16 123/125] NFSv4: Dont clear the open state when we just did an OPEN_DOWNGRADE
Date: Wed,  3 Sep 2014 15:08:00 -0700
Message-Id: <20140903220627.389106646@linuxfoundation.org>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <20140903220623.649748296@linuxfoundation.org>
References: <20140903220623.649748296@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Trond Myklebust <trond.myklebust@primarydata.com>

commit 412f6c4c26fb1eba8844290663837561ac53fa6e upstream.

If we did an OPEN_DOWNGRADE, then the right thing to do on success, is
to apply the new open mode to the struct nfs4_state. Instead, we were
unconditionally clearing the state, making it appear to our state
machinery as if we had just performed a CLOSE.

Fixes: 226056c5c312b (NFSv4: Use correct locking when updating nfs4_state...)
Signed-off-by: Trond Myklebust <trond.myklebust@primarydata.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/nfs/nfs4proc.c |    9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

--- a/fs/nfs/nfs4proc.c
+++ b/fs/nfs/nfs4proc.c
@@ -2545,6 +2545,7 @@ static void nfs4_close_done(struct rpc_t
 	struct nfs4_closedata *calldata = data;
 	struct nfs4_state *state = calldata->state;
 	struct nfs_server *server = NFS_SERVER(calldata->inode);
+	nfs4_stateid *res_stateid = NULL;
 
 	dprintk("%s: begin!\n", __func__);
 	if (!nfs4_sequence_done(task, &calldata->res.seq_res))
@@ -2555,12 +2556,12 @@ static void nfs4_close_done(struct rpc_t
 	 */
 	switch (task->tk_status) {
 		case 0:
-			if (calldata->roc)
+			res_stateid = &calldata->res.stateid;
+			if (calldata->arg.fmode == 0 && calldata->roc)
 				pnfs_roc_set_barrier(state->inode,
 						     calldata->roc_barrier);
-			nfs_clear_open_stateid(state, &calldata->res.stateid, 0);
 			renew_lease(server, calldata->timestamp);
-			goto out_release;
+			break;
 		case -NFS4ERR_ADMIN_REVOKED:
 		case -NFS4ERR_STALE_STATEID:
 		case -NFS4ERR_OLD_STATEID:
@@ -2574,7 +2575,7 @@ static void nfs4_close_done(struct rpc_t
 				goto out_release;
 			}
 	}
-	nfs_clear_open_stateid(state, NULL, calldata->arg.fmode);
+	nfs_clear_open_stateid(state, res_stateid, calldata->arg.fmode);
 out_release:
 	nfs_release_seqid(calldata->arg.seqid);
 	nfs_refresh_inode(calldata->inode, calldata->res.fattr);


