Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757241Ab3APP74 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jan 2013 10:59:56 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:35811 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756351Ab3APP7y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jan 2013 10:59:54 -0500
From: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Bryan Schumaker <bjschuma@netapp.com>,
        Trond Myklebust <Trond.Myklebust@netapp.com>,
        Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
Subject: [PATCH 039/222] NFS: Add sequence_priviliged_ops for nfs4_proc_sequence()
Date: Wed, 16 Jan 2013 13:53:59 -0200
Message-Id: <1358351822-7675-40-git-send-email-herton.krzesinski@canonical.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1358351822-7675-1-git-send-email-herton.krzesinski@canonical.com>
References: <1358351822-7675-1-git-send-email-herton.krzesinski@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.3 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Bryan Schumaker <bjschuma@netapp.com>

commit 6bdb5f213c4344324f600dde885f25768fbd14db upstream.

If I mount an NFS v4.1 server to a single client multiple times and then
run xfstests over each mountpoint I usually get the client into a state
where recovery deadlocks.  The server informs the client of a
cb_path_down sequence error, the client then does a
bind_connection_to_session and checks the status of the lease.

I found that bind_connection_to_session sets the NFS4_SESSION_DRAINING
flag on the client, but this flag is never unset before
nfs4_check_lease() reaches nfs4_proc_sequence().  This causes the client
to deadlock, halting all NFS activity to the server.  nfs4_proc_sequence()
is only called by the state manager, so I can change it to run in privileged
mode to bypass the NFS4_SESSION_DRAINING check and avoid the deadlock.

Signed-off-by: Bryan Schumaker <bjschuma@netapp.com>
Signed-off-by: Trond Myklebust <Trond.Myklebust@netapp.com>
Signed-off-by: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
---
 fs/nfs/nfs4proc.c |   21 +++++++++++++++++----
 1 file changed, 17 insertions(+), 4 deletions(-)

diff --git a/fs/nfs/nfs4proc.c b/fs/nfs/nfs4proc.c
index 9b1ac5c..c1bad65 100644
--- a/fs/nfs/nfs4proc.c
+++ b/fs/nfs/nfs4proc.c
@@ -5937,13 +5937,26 @@ static void nfs41_sequence_prepare(struct rpc_task *task, void *data)
 	rpc_call_start(task);
 }
 
+static void nfs41_sequence_prepare_privileged(struct rpc_task *task, void *data)
+{
+	rpc_task_set_priority(task, RPC_PRIORITY_PRIVILEGED);
+	nfs41_sequence_prepare(task, data);
+}
+
 static const struct rpc_call_ops nfs41_sequence_ops = {
 	.rpc_call_done = nfs41_sequence_call_done,
 	.rpc_call_prepare = nfs41_sequence_prepare,
 	.rpc_release = nfs41_sequence_release,
 };
 
-static struct rpc_task *_nfs41_proc_sequence(struct nfs_client *clp, struct rpc_cred *cred)
+static const struct rpc_call_ops nfs41_sequence_privileged_ops = {
+	.rpc_call_done = nfs41_sequence_call_done,
+	.rpc_call_prepare = nfs41_sequence_prepare_privileged,
+	.rpc_release = nfs41_sequence_release,
+};
+
+static struct rpc_task *_nfs41_proc_sequence(struct nfs_client *clp, struct rpc_cred *cred,
+					     const struct rpc_call_ops *seq_ops)
 {
 	struct nfs4_sequence_data *calldata;
 	struct rpc_message msg = {
@@ -5953,7 +5966,7 @@ static struct rpc_task *_nfs41_proc_sequence(struct nfs_client *clp, struct rpc_
 	struct rpc_task_setup task_setup_data = {
 		.rpc_client = clp->cl_rpcclient,
 		.rpc_message = &msg,
-		.callback_ops = &nfs41_sequence_ops,
+		.callback_ops = seq_ops,
 		.flags = RPC_TASK_ASYNC | RPC_TASK_SOFT,
 	};
 
@@ -5980,7 +5993,7 @@ static int nfs41_proc_async_sequence(struct nfs_client *clp, struct rpc_cred *cr
 
 	if ((renew_flags & NFS4_RENEW_TIMEOUT) == 0)
 		return 0;
-	task = _nfs41_proc_sequence(clp, cred);
+	task = _nfs41_proc_sequence(clp, cred, &nfs41_sequence_ops);
 	if (IS_ERR(task))
 		ret = PTR_ERR(task);
 	else
@@ -5994,7 +6007,7 @@ static int nfs4_proc_sequence(struct nfs_client *clp, struct rpc_cred *cred)
 	struct rpc_task *task;
 	int ret;
 
-	task = _nfs41_proc_sequence(clp, cred);
+	task = _nfs41_proc_sequence(clp, cred, &nfs41_sequence_privileged_ops);
 	if (IS_ERR(task)) {
 		ret = PTR_ERR(task);
 		goto out;
-- 
1.7.9.5

