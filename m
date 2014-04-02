Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933035AbaDBUOL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Apr 2014 16:14:11 -0400
Received: from ip4-83-240-18-248.cust.nbox.cz ([83.240.18.248]:42881 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758955AbaDBUNc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Apr 2014 16:13:32 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Andy Adamson <andros@netapp.com>,
        Trond Myklebust <trond.myklebust@primarydata.com>,
        Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 20/40] NFSv4.1 free slot before resending I/O to MDS
Date: Wed,  2 Apr 2014 22:13:06 +0200
Message-Id: <b6be966d5571c7844fee177581c7468035f79e23.1396469191.git.jslaby@suse.cz>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <4c74007da904cc0411d788200034b2fb4c9e0d01.1396469191.git.jslaby@suse.cz>
References: <4c74007da904cc0411d788200034b2fb4c9e0d01.1396469191.git.jslaby@suse.cz>
In-Reply-To: <cover.1396469191.git.jslaby@suse.cz>
References: <cover.1396469191.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andy Adamson <andros@netapp.com>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

commit f9c96fcc501a43dbc292b17fc0ded4b54e63b79d upstream.

Fix a dynamic session slot leak where a slot is preallocated and I/O is
resent through the MDS.

Signed-off-by: Andy Adamson <andros@netapp.com>
Signed-off-by: Trond Myklebust <trond.myklebust@primarydata.com>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 fs/nfs/nfs4_fs.h        |  1 +
 fs/nfs/nfs4filelayout.c | 10 ++++++++--
 fs/nfs/nfs4proc.c       |  3 ++-
 3 files changed, 11 insertions(+), 3 deletions(-)

diff --git a/fs/nfs/nfs4_fs.h b/fs/nfs/nfs4_fs.h
index 28842abafab4..fdfd59157dce 100644
--- a/fs/nfs/nfs4_fs.h
+++ b/fs/nfs/nfs4_fs.h
@@ -249,6 +249,7 @@ static inline struct nfs4_session *nfs4_get_session(const struct nfs_server *ser
 extern int nfs41_setup_sequence(struct nfs4_session *session,
 		struct nfs4_sequence_args *args, struct nfs4_sequence_res *res,
 		struct rpc_task *task);
+extern int nfs41_sequence_done(struct rpc_task *, struct nfs4_sequence_res *);
 extern int nfs4_proc_create_session(struct nfs_client *, struct rpc_cred *);
 extern int nfs4_proc_destroy_session(struct nfs4_session *, struct rpc_cred *);
 extern int nfs4_proc_get_lease_time(struct nfs_client *clp,
diff --git a/fs/nfs/nfs4filelayout.c b/fs/nfs/nfs4filelayout.c
index 6e245d13de10..394b0a0c54bf 100644
--- a/fs/nfs/nfs4filelayout.c
+++ b/fs/nfs/nfs4filelayout.c
@@ -335,8 +335,11 @@ static void filelayout_read_call_done(struct rpc_task *task, void *data)
 	dprintk("--> %s task->tk_status %d\n", __func__, task->tk_status);
 
 	if (test_bit(NFS_IOHDR_REDO, &rdata->header->flags) &&
-	    task->tk_status == 0)
+	    task->tk_status == 0) {
+		if (rdata->res.seq_res.sr_slot != NULL)
+			nfs41_sequence_done(task, &rdata->res.seq_res);
 		return;
+	}
 
 	/* Note this may cause RPC to be resent */
 	rdata->header->mds_ops->rpc_call_done(task, data);
@@ -442,8 +445,11 @@ static void filelayout_write_call_done(struct rpc_task *task, void *data)
 	struct nfs_write_data *wdata = data;
 
 	if (test_bit(NFS_IOHDR_REDO, &wdata->header->flags) &&
-	    task->tk_status == 0)
+	    task->tk_status == 0) {
+		if (wdata->res.seq_res.sr_slot != NULL)
+			nfs41_sequence_done(task, &wdata->res.seq_res);
 		return;
+	}
 
 	/* Note this may cause RPC to be resent */
 	wdata->header->mds_ops->rpc_call_done(task, data);
diff --git a/fs/nfs/nfs4proc.c b/fs/nfs/nfs4proc.c
index 9edb753d9e3a..bcd42fbc04e7 100644
--- a/fs/nfs/nfs4proc.c
+++ b/fs/nfs/nfs4proc.c
@@ -585,7 +585,7 @@ out_unlock:
 		nfs41_server_notify_highest_slotid_update(session->clp);
 }
 
-static int nfs41_sequence_done(struct rpc_task *task, struct nfs4_sequence_res *res)
+int nfs41_sequence_done(struct rpc_task *task, struct nfs4_sequence_res *res)
 {
 	struct nfs4_session *session;
 	struct nfs4_slot *slot;
@@ -685,6 +685,7 @@ out_retry:
 	rpc_delay(task, NFS4_POLL_RETRY_MAX);
 	return 0;
 }
+EXPORT_SYMBOL_GPL(nfs41_sequence_done);
 
 static int nfs4_sequence_done(struct rpc_task *task,
 			       struct nfs4_sequence_res *res)
-- 
1.9.1

