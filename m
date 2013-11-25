Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755508Ab3KYNLS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Nov 2013 08:11:18 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:57360 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755004Ab3KYNJS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Nov 2013 08:09:18 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Andy Adamson <andros@netapp.com>,
        Trond Myklebust <Trond.Myklebust@netapp.com>,
        Ben Hutchings <ben@decadent.org.uk>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.5 76/78] SUNRPC handle EKEYEXPIRED in call_refreshresult
Date: Mon, 25 Nov 2013 13:07:03 +0000
Message-Id: <1385384825-21681-77-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1385384825-21681-1-git-send-email-luis.henriques@canonical.com>
References: <1385384825-21681-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.26 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Andy Adamson <andros@netapp.com>

commit eb96d5c97b0825d542e9c4ba5e0a22b519355166 upstream.

Currently, when an RPCSEC_GSS context has expired or is non-existent
and the users (Kerberos) credentials have also expired or are non-existent,
the client receives the -EKEYEXPIRED error and tries to refresh the context
forever.  If an application is performing I/O, or other work against the share,
the application hangs, and the user is not prompted to refresh/establish their
credentials. This can result in a denial of service for other users.

Users are expected to manage their Kerberos credential lifetimes to mitigate
this issue.

Move the -EKEYEXPIRED handling into the RPC layer. Try tk_cred_retry number
of times to refresh the gss_context, and then return -EACCES to the application.

Signed-off-by: Andy Adamson <andros@netapp.com>
Signed-off-by: Trond Myklebust <Trond.Myklebust@netapp.com>
Cc: Ben Hutchings <ben@decadent.org.uk>
[ luis: backported to 3.5 based on bwh backport to 3.2:
  - adjusted context
  - dropped changes to nfs4_handle_reclaim_lease_error() ]
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 fs/nfs/nfs3proc.c       |  6 +++---
 fs/nfs/nfs4filelayout.c |  1 -
 fs/nfs/nfs4proc.c       | 18 ------------------
 fs/nfs/nfs4state.c      | 22 ----------------------
 fs/nfs/proc.c           | 43 -------------------------------------------
 net/sunrpc/clnt.c       |  1 +
 6 files changed, 4 insertions(+), 87 deletions(-)

diff --git a/fs/nfs/nfs3proc.c b/fs/nfs/nfs3proc.c
index fda63e9..c7eb313 100644
--- a/fs/nfs/nfs3proc.c
+++ b/fs/nfs/nfs3proc.c
@@ -24,14 +24,14 @@
 
 #define NFSDBG_FACILITY		NFSDBG_PROC
 
-/* A wrapper to handle the EJUKEBOX and EKEYEXPIRED error messages */
+/* A wrapper to handle the EJUKEBOX error messages */
 static int
 nfs3_rpc_wrapper(struct rpc_clnt *clnt, struct rpc_message *msg, int flags)
 {
 	int res;
 	do {
 		res = rpc_call_sync(clnt, msg, flags);
-		if (res != -EJUKEBOX && res != -EKEYEXPIRED)
+		if (res != -EJUKEBOX)
 			break;
 		freezable_schedule_timeout_killable(NFS_JUKEBOX_RETRY_TIME);
 		res = -ERESTARTSYS;
@@ -44,7 +44,7 @@ nfs3_rpc_wrapper(struct rpc_clnt *clnt, struct rpc_message *msg, int flags)
 static int
 nfs3_async_handle_jukebox(struct rpc_task *task, struct inode *inode)
 {
-	if (task->tk_status != -EJUKEBOX && task->tk_status != -EKEYEXPIRED)
+	if (task->tk_status != -EJUKEBOX)
 		return 0;
 	if (task->tk_status == -EJUKEBOX)
 		nfs_inc_stats(inode, NFSIOS_DELAY);
diff --git a/fs/nfs/nfs4filelayout.c b/fs/nfs/nfs4filelayout.c
index e134029..8445359 100644
--- a/fs/nfs/nfs4filelayout.c
+++ b/fs/nfs/nfs4filelayout.c
@@ -169,7 +169,6 @@ static int filelayout_async_handle_error(struct rpc_task *task,
 		break;
 	case -NFS4ERR_DELAY:
 	case -NFS4ERR_GRACE:
-	case -EKEYEXPIRED:
 		rpc_delay(task, FILELAYOUT_POLL_RETRY_MAX);
 		break;
 	case -NFS4ERR_RETRY_UNCACHED_REP:
diff --git a/fs/nfs/nfs4proc.c b/fs/nfs/nfs4proc.c
index 594ec86..a89661e 100644
--- a/fs/nfs/nfs4proc.c
+++ b/fs/nfs/nfs4proc.c
@@ -341,7 +341,6 @@ static int nfs4_handle_exception(struct nfs_server *server, int errorcode, struc
 			}
 		case -NFS4ERR_GRACE:
 		case -NFS4ERR_DELAY:
-		case -EKEYEXPIRED:
 			ret = nfs4_delay(server->client, &exception->timeout);
 			if (ret != 0)
 				break;
@@ -1371,13 +1370,6 @@ int nfs4_open_delegation_recall(struct nfs_open_context *ctx, struct nfs4_state
 				nfs_inode_find_state_and_recover(state->inode,
 						stateid);
 				nfs4_schedule_stateid_recovery(server, state);
-			case -EKEYEXPIRED:
-				/*
-				 * User RPCSEC_GSS context has expired.
-				 * We cannot recover this stateid now, so
-				 * skip it and allow recovery thread to
-				 * proceed.
-				 */
 			case -ENOMEM:
 				err = 0;
 				goto out;
@@ -3949,7 +3941,6 @@ nfs4_async_handle_error(struct rpc_task *task, const struct nfs_server *server,
 		case -NFS4ERR_DELAY:
 			nfs_inc_server_stats(server, NFSIOS_DELAY);
 		case -NFS4ERR_GRACE:
-		case -EKEYEXPIRED:
 			rpc_delay(task, NFS4_POLL_RETRY_MAX);
 			task->tk_status = 0;
 			return -EAGAIN;
@@ -4906,15 +4897,6 @@ int nfs4_lock_delegation_recall(struct nfs4_state *state, struct file_lock *fl)
 				nfs4_schedule_stateid_recovery(server, state);
 				err = 0;
 				goto out;
-			case -EKEYEXPIRED:
-				/*
-				 * User RPCSEC_GSS context has expired.
-				 * We cannot recover this stateid now, so
-				 * skip it and allow recovery thread to
-				 * proceed.
-				 */
-				err = 0;
-				goto out;
 			case -ENOMEM:
 			case -NFS4ERR_DENIED:
 				/* kill_proc(fl->fl_pid, SIGLOST, 1); */
diff --git a/fs/nfs/nfs4state.c b/fs/nfs/nfs4state.c
index 9bc63d3..e9c3916 100644
--- a/fs/nfs/nfs4state.c
+++ b/fs/nfs/nfs4state.c
@@ -1315,14 +1315,6 @@ restart:
 				/* Mark the file as being 'closed' */
 				state->state = 0;
 				break;
-			case -EKEYEXPIRED:
-				/*
-				 * User RPCSEC_GSS context has expired.
-				 * We cannot recover this stateid now, so
-				 * skip it and allow recovery thread to
-				 * proceed.
-				 */
-				break;
 			case -NFS4ERR_ADMIN_REVOKED:
 			case -NFS4ERR_STALE_STATEID:
 			case -NFS4ERR_BAD_STATEID:
@@ -1475,14 +1467,6 @@ static void nfs4_state_start_reclaim_nograce(struct nfs_client *clp)
 	nfs4_state_mark_reclaim_helper(clp, nfs4_state_mark_reclaim_nograce);
 }
 
-static void nfs4_warn_keyexpired(const char *s)
-{
-	printk_ratelimited(KERN_WARNING "Error: state manager"
-			" encountered RPCSEC_GSS session"
-			" expired against NFSv4 server %s.\n",
-			s);
-}
-
 static int nfs4_recovery_handle_error(struct nfs_client *clp, int error)
 {
 	switch (error) {
@@ -1516,10 +1500,6 @@ static int nfs4_recovery_handle_error(struct nfs_client *clp, int error)
 		case -NFS4ERR_CONN_NOT_BOUND_TO_SESSION:
 			set_bit(NFS4CLNT_BIND_CONN_TO_SESSION, &clp->cl_state);
 			break;
-		case -EKEYEXPIRED:
-			/* Nothing we can do */
-			nfs4_warn_keyexpired(clp->cl_hostname);
-			break;
 		default:
 			dprintk("%s: failed to handle error %d for server %s\n",
 					__func__, error, clp->cl_hostname);
@@ -1627,8 +1607,6 @@ static int nfs4_handle_reclaim_lease_error(struct nfs_client *clp, int status)
 		dprintk("%s: exit with error %d for server %s\n",
 				__func__, -EPROTONOSUPPORT, clp->cl_hostname);
 		return -EPROTONOSUPPORT;
-	case -EKEYEXPIRED:
-		nfs4_warn_keyexpired(clp->cl_hostname);
 	case -NFS4ERR_NOT_SAME: /* FixMe: implement recovery
 				 * in nfs4_exchange_id */
 	default:
diff --git a/fs/nfs/proc.c b/fs/nfs/proc.c
index 617c741..b6d96f3 100644
--- a/fs/nfs/proc.c
+++ b/fs/nfs/proc.c
@@ -47,39 +47,6 @@
 #define NFSDBG_FACILITY		NFSDBG_PROC
 
 /*
- * wrapper to handle the -EKEYEXPIRED error message. This should generally
- * only happen if using krb5 auth and a user's TGT expires. NFSv2 doesn't
- * support the NFSERR_JUKEBOX error code, but we handle this situation in the
- * same way that we handle that error with NFSv3.
- */
-static int
-nfs_rpc_wrapper(struct rpc_clnt *clnt, struct rpc_message *msg, int flags)
-{
-	int res;
-	do {
-		res = rpc_call_sync(clnt, msg, flags);
-		if (res != -EKEYEXPIRED)
-			break;
-		freezable_schedule_timeout_killable(NFS_JUKEBOX_RETRY_TIME);
-		res = -ERESTARTSYS;
-	} while (!fatal_signal_pending(current));
-	return res;
-}
-
-#define rpc_call_sync(clnt, msg, flags)	nfs_rpc_wrapper(clnt, msg, flags)
-
-static int
-nfs_async_handle_expired_key(struct rpc_task *task)
-{
-	if (task->tk_status != -EKEYEXPIRED)
-		return 0;
-	task->tk_status = 0;
-	rpc_restart_call(task);
-	rpc_delay(task, NFS_JUKEBOX_RETRY_TIME);
-	return 1;
-}
-
-/*
  * Bare-bones access to getattr: this is for nfs_read_super.
  */
 static int
@@ -364,8 +331,6 @@ static void nfs_proc_unlink_rpc_prepare(struct rpc_task *task, struct nfs_unlink
 
 static int nfs_proc_unlink_done(struct rpc_task *task, struct inode *dir)
 {
-	if (nfs_async_handle_expired_key(task))
-		return 0;
 	nfs_mark_for_revalidate(dir);
 	return 1;
 }
@@ -385,8 +350,6 @@ static int
 nfs_proc_rename_done(struct rpc_task *task, struct inode *old_dir,
 		     struct inode *new_dir)
 {
-	if (nfs_async_handle_expired_key(task))
-		return 0;
 	nfs_mark_for_revalidate(old_dir);
 	nfs_mark_for_revalidate(new_dir);
 	return 1;
@@ -642,9 +605,6 @@ static int nfs_read_done(struct rpc_task *task, struct nfs_read_data *data)
 {
 	struct inode *inode = data->header->inode;
 
-	if (nfs_async_handle_expired_key(task))
-		return -EAGAIN;
-
 	nfs_invalidate_atime(inode);
 	if (task->tk_status >= 0) {
 		nfs_refresh_inode(inode, data->res.fattr);
@@ -671,9 +631,6 @@ static int nfs_write_done(struct rpc_task *task, struct nfs_write_data *data)
 {
 	struct inode *inode = data->header->inode;
 
-	if (nfs_async_handle_expired_key(task))
-		return -EAGAIN;
-
 	if (task->tk_status >= 0)
 		nfs_post_op_update_inode_force_wcc(inode, data->res.fattr);
 	return 0;
diff --git a/net/sunrpc/clnt.c b/net/sunrpc/clnt.c
index 631a75d..6b0dd20 100644
--- a/net/sunrpc/clnt.c
+++ b/net/sunrpc/clnt.c
@@ -1334,6 +1334,7 @@ call_refreshresult(struct rpc_task *task)
 		return;
 	case -ETIMEDOUT:
 		rpc_delay(task, 3*HZ);
+	case -EKEYEXPIRED:
 	case -EAGAIN:
 		status = -EACCES;
 		if (!task->tk_cred_retry)
-- 
1.8.3.2

