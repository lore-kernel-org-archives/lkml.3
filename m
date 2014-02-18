Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754100AbaBRXGd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Feb 2014 18:06:33 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:51067 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753234AbaBRWqz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Feb 2014 17:46:55 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Trond Myklebust <trond.myklebust@primarydata.com>
Subject: [PATCH 3.12 06/32] NFSv4.1: nfs4_destroy_session must call rpc_destroy_waitqueue
Date: Tue, 18 Feb 2014 14:47:06 -0800
Message-Id: <20140218224500.286168167@linuxfoundation.org>
X-Mailer: git-send-email 1.8.5.1.163.gd7aced9
In-Reply-To: <20140218224500.101465031@linuxfoundation.org>
References: <20140218224500.101465031@linuxfoundation.org>
User-Agent: quilt/0.61-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Trond Myklebust <trond.myklebust@primarydata.com>

commit 20b9a9024540a775395d5d1f41eec0ec6ec41f9b upstream.

There may still be timers active on the session waitqueues. Make sure
that we kill them before freeing the memory.

Signed-off-by: Trond Myklebust <trond.myklebust@primarydata.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/nfs/nfs4client.c  |    2 +-
 fs/nfs/nfs4session.c |   25 ++++++++++++++++++++-----
 fs/nfs/nfs4session.h |    2 +-
 3 files changed, 22 insertions(+), 7 deletions(-)

--- a/fs/nfs/nfs4client.c
+++ b/fs/nfs/nfs4client.c
@@ -169,7 +169,7 @@ void nfs41_shutdown_client(struct nfs_cl
 void nfs40_shutdown_client(struct nfs_client *clp)
 {
 	if (clp->cl_slot_tbl) {
-		nfs4_release_slot_table(clp->cl_slot_tbl);
+		nfs4_shutdown_slot_table(clp->cl_slot_tbl);
 		kfree(clp->cl_slot_tbl);
 	}
 }
--- a/fs/nfs/nfs4session.c
+++ b/fs/nfs/nfs4session.c
@@ -231,14 +231,23 @@ out:
 	return ret;
 }
 
+/*
+ * nfs4_release_slot_table - release all slot table entries
+ */
+static void nfs4_release_slot_table(struct nfs4_slot_table *tbl)
+{
+	nfs4_shrink_slot_table(tbl, 0);
+}
+
 /**
- * nfs4_release_slot_table - release resources attached to a slot table
+ * nfs4_shutdown_slot_table - release resources attached to a slot table
  * @tbl: slot table to shut down
  *
  */
-void nfs4_release_slot_table(struct nfs4_slot_table *tbl)
+void nfs4_shutdown_slot_table(struct nfs4_slot_table *tbl)
 {
-	nfs4_shrink_slot_table(tbl, 0);
+	nfs4_release_slot_table(tbl);
+	rpc_destroy_wait_queue(&tbl->slot_tbl_waitq);
 }
 
 /**
@@ -422,7 +431,7 @@ void nfs41_update_target_slotid(struct n
 	spin_unlock(&tbl->slot_tbl_lock);
 }
 
-static void nfs4_destroy_session_slot_tables(struct nfs4_session *session)
+static void nfs4_release_session_slot_tables(struct nfs4_session *session)
 {
 	nfs4_release_slot_table(&session->fc_slot_table);
 	nfs4_release_slot_table(&session->bc_slot_table);
@@ -450,7 +459,7 @@ int nfs4_setup_session_slot_tables(struc
 	if (status && tbl->slots == NULL)
 		/* Fore and back channel share a connection so get
 		 * both slot tables or neither */
-		nfs4_destroy_session_slot_tables(ses);
+		nfs4_release_session_slot_tables(ses);
 	return status;
 }
 
@@ -470,6 +479,12 @@ struct nfs4_session *nfs4_alloc_session(
 	return session;
 }
 
+static void nfs4_destroy_session_slot_tables(struct nfs4_session *session)
+{
+	nfs4_shutdown_slot_table(&session->fc_slot_table);
+	nfs4_shutdown_slot_table(&session->bc_slot_table);
+}
+
 void nfs4_destroy_session(struct nfs4_session *session)
 {
 	struct rpc_xprt *xprt;
--- a/fs/nfs/nfs4session.h
+++ b/fs/nfs/nfs4session.h
@@ -74,7 +74,7 @@ enum nfs4_session_state {
 
 extern int nfs4_setup_slot_table(struct nfs4_slot_table *tbl,
 		unsigned int max_reqs, const char *queue);
-extern void nfs4_release_slot_table(struct nfs4_slot_table *tbl);
+extern void nfs4_shutdown_slot_table(struct nfs4_slot_table *tbl);
 extern struct nfs4_slot *nfs4_alloc_slot(struct nfs4_slot_table *tbl);
 extern void nfs4_free_slot(struct nfs4_slot_table *tbl, struct nfs4_slot *slot);
 extern void nfs4_slot_tbl_drain_complete(struct nfs4_slot_table *tbl);


