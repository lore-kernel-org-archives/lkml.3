Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756596AbaICXhx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Sep 2014 19:37:53 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:45481 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932232AbaICWI3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Sep 2014 18:08:29 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        James Drews <drews@engr.wisc.edu>,
        Trond Myklebust <trond.myklebust@primarydata.com>
Subject: [PATCH 3.10 54/55] NFSv4: Fix problems with close in the presence of a delegation
Date: Wed,  3 Sep 2014 15:05:44 -0700
Message-Id: <20140903220502.477307449@linuxfoundation.org>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <20140903220453.653576908@linuxfoundation.org>
References: <20140903220453.653576908@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Trond Myklebust <trond.myklebust@primarydata.com>

commit aee7af356e151494d5014f57b33460b162f181b5 upstream.

In the presence of delegations, we can no longer assume that the
state->n_rdwr, state->n_rdonly, state->n_wronly reflect the open
stateid share mode, and so we need to calculate the initial value
for calldata->arg.fmode using the state->flags.

Reported-by: James Drews <drews@engr.wisc.edu>
Fixes: 88069f77e1ac5 (NFSv41: Fix a potential state leakage when...)
Signed-off-by: Trond Myklebust <trond.myklebust@primarydata.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/nfs/nfs4proc.c |   17 ++++++++++++-----
 1 file changed, 12 insertions(+), 5 deletions(-)

--- a/fs/nfs/nfs4proc.c
+++ b/fs/nfs/nfs4proc.c
@@ -2287,6 +2287,7 @@ static void nfs4_close_prepare(struct rp
 	struct nfs4_closedata *calldata = data;
 	struct nfs4_state *state = calldata->state;
 	struct inode *inode = calldata->inode;
+	bool is_rdonly, is_wronly, is_rdwr;
 	int call_close = 0;
 
 	dprintk("%s: begin!\n", __func__);
@@ -2294,18 +2295,24 @@ static void nfs4_close_prepare(struct rp
 		goto out_wait;
 
 	task->tk_msg.rpc_proc = &nfs4_procedures[NFSPROC4_CLNT_OPEN_DOWNGRADE];
-	calldata->arg.fmode = FMODE_READ|FMODE_WRITE;
 	spin_lock(&state->owner->so_lock);
+	is_rdwr = test_bit(NFS_O_RDWR_STATE, &state->flags);
+	is_rdonly = test_bit(NFS_O_RDONLY_STATE, &state->flags);
+	is_wronly = test_bit(NFS_O_WRONLY_STATE, &state->flags);
+	/* Calculate the current open share mode */
+	calldata->arg.fmode = 0;
+	if (is_rdonly || is_rdwr)
+		calldata->arg.fmode |= FMODE_READ;
+	if (is_wronly || is_rdwr)
+		calldata->arg.fmode |= FMODE_WRITE;
 	/* Calculate the change in open mode */
 	if (state->n_rdwr == 0) {
 		if (state->n_rdonly == 0) {
-			call_close |= test_bit(NFS_O_RDONLY_STATE, &state->flags);
-			call_close |= test_bit(NFS_O_RDWR_STATE, &state->flags);
+			call_close |= is_rdonly || is_rdwr;
 			calldata->arg.fmode &= ~FMODE_READ;
 		}
 		if (state->n_wronly == 0) {
-			call_close |= test_bit(NFS_O_WRONLY_STATE, &state->flags);
-			call_close |= test_bit(NFS_O_RDWR_STATE, &state->flags);
+			call_close |= is_wronly || is_rdwr;
 			calldata->arg.fmode &= ~FMODE_WRITE;
 		}
 	}


