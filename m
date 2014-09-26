Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756958AbaIZKbV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Sep 2014 06:31:21 -0400
Received: from cantor2.suse.de ([195.135.220.15]:33004 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754770AbaIZJqC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Sep 2014 05:46:02 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
        Trond Myklebust <trond.myklebust@primarydata.com>,
        Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 029/142] NFSv4: Fix problems with close in the presence of a delegation
Date: Fri, 26 Sep 2014 11:44:00 +0200
Message-Id: <24bafe7dfd3771f280cbd3074b1dfff62aa7715d.1411724723.git.jslaby@suse.cz>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <406eb8e630446eff74211cba53a536f232bbefd1.1411724723.git.jslaby@suse.cz>
References: <406eb8e630446eff74211cba53a536f232bbefd1.1411724723.git.jslaby@suse.cz>
In-Reply-To: <cover.1411724723.git.jslaby@suse.cz>
References: <cover.1411724723.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Trond Myklebust <trond.myklebust@primarydata.com>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

commit aee7af356e151494d5014f57b33460b162f181b5 upstream.

In the presence of delegations, we can no longer assume that the
state->n_rdwr, state->n_rdonly, state->n_wronly reflect the open
stateid share mode, and so we need to calculate the initial value
for calldata->arg.fmode using the state->flags.

Reported-by: James Drews <drews@engr.wisc.edu>
Fixes: 88069f77e1ac5 (NFSv41: Fix a potential state leakage when...)
Signed-off-by: Trond Myklebust <trond.myklebust@primarydata.com>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 fs/nfs/nfs4proc.c | 17 ++++++++++++-----
 1 file changed, 12 insertions(+), 5 deletions(-)

diff --git a/fs/nfs/nfs4proc.c b/fs/nfs/nfs4proc.c
index 40062e42c955..067d8c90eb1a 100644
--- a/fs/nfs/nfs4proc.c
+++ b/fs/nfs/nfs4proc.c
@@ -2532,6 +2532,7 @@ static void nfs4_close_prepare(struct rpc_task *task, void *data)
 	struct nfs4_closedata *calldata = data;
 	struct nfs4_state *state = calldata->state;
 	struct inode *inode = calldata->inode;
+	bool is_rdonly, is_wronly, is_rdwr;
 	int call_close = 0;
 
 	dprintk("%s: begin!\n", __func__);
@@ -2539,18 +2540,24 @@ static void nfs4_close_prepare(struct rpc_task *task, void *data)
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
-- 
2.1.0

