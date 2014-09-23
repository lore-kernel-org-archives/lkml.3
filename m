Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754742AbaIWCkN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Sep 2014 22:40:13 -0400
Received: from mail.kernel.org ([198.145.19.201]:38363 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753250AbaIWCkK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Sep 2014 22:40:10 -0400
From: Zefan Li <lizf@kernel.org>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
        Trond Myklebust <trond.myklebust@primarydata.com>,
        Zefan Li <lizefan@huawei.com>
Subject: [PATCH 3.4 28/45] NFSv4: Fix problems with close in the presence of a delegation
Date: Tue, 23 Sep 2014 10:31:30 +0800
Message-Id: <1411439507-30391-28-git-send-email-lizf@kernel.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1411439259-30224-1-git-send-email-lizf@kernel.org>
References: <1411439259-30224-1-git-send-email-lizf@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Trond Myklebust <trond.myklebust@primarydata.com>

3.4.104-rc1 review patch.  If anyone has any objections, please let me know.

------------------

commit aee7af356e151494d5014f57b33460b162f181b5 upstream.

In the presence of delegations, we can no longer assume that the
state->n_rdwr, state->n_rdonly, state->n_wronly reflect the open
stateid share mode, and so we need to calculate the initial value
for calldata->arg.fmode using the state->flags.

Reported-by: James Drews <drews@engr.wisc.edu>
Fixes: 88069f77e1ac5 (NFSv41: Fix a potential state leakage when...)
Signed-off-by: Trond Myklebust <trond.myklebust@primarydata.com>
[lizf: Backport to 3.4: adjust context]
Signed-off-by: Zefan Li <lizefan@huawei.com>
---
 fs/nfs/nfs4proc.c |   17 ++++++++++++-----
 1 file changed, 12 insertions(+), 5 deletions(-)

diff --git a/fs/nfs/nfs4proc.c b/fs/nfs/nfs4proc.c
index 934bb1c..01afcd5 100644
--- a/fs/nfs/nfs4proc.c
+++ b/fs/nfs/nfs4proc.c
@@ -2051,6 +2051,7 @@ static void nfs4_close_prepare(struct rpc_task *task, void *data)
 {
 	struct nfs4_closedata *calldata = data;
 	struct nfs4_state *state = calldata->state;
+	bool is_rdonly, is_wronly, is_rdwr;
 	int call_close = 0;
 
 	dprintk("%s: begin!\n", __func__);
@@ -2058,18 +2059,24 @@ static void nfs4_close_prepare(struct rpc_task *task, void *data)
 		return;
 
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
1.7.9.5

