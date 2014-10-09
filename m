Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758563AbaJIVbk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Oct 2014 17:31:40 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:59331 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757559AbaJIVJG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Oct 2014 17:09:06 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Steve Dickson <steved@redhat.com>,
        Trond Myklebust <trond.myklebust@primarydata.com>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13 102/163] NFSv4: nfs4_state_manager() vs. nfs_server_remove_lists()
Date: Thu,  9 Oct 2014 14:02:07 -0700
Message-Id: <1412888588-26755-103-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1412888588-26755-1-git-send-email-kamal@canonical.com>
References: <1412888588-26755-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11.9 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Steve Dickson <steved@redhat.com>

commit 080af20cc945d110f9912d01cf6b66f94a375b8d upstream.

There is a race between nfs4_state_manager() and
nfs_server_remove_lists() that happens during a nfsv3 mount.

The v3 mount notices there is already a supper block so
nfs_server_remove_lists() called which uses the nfs_client_lock
spin lock to synchronize access to the client list.

At the same time nfs4_state_manager() is running through
the client list looking for work to do, using the same
lock. When nfs4_state_manager() wins the race to the
list, a v3 client pointer is found and not ignored
properly which causes the panic.

Moving some protocol checks before the state checking
avoids the panic.

Signed-off-by: Steve Dickson <steved@redhat.com>
Signed-off-by: Trond Myklebust <trond.myklebust@primarydata.com>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 fs/nfs/nfs4client.c | 38 ++++++++++++++++++++------------------
 1 file changed, 20 insertions(+), 18 deletions(-)

diff --git a/fs/nfs/nfs4client.c b/fs/nfs/nfs4client.c
index 4c7bd2c..af6013c 100644
--- a/fs/nfs/nfs4client.c
+++ b/fs/nfs/nfs4client.c
@@ -485,6 +485,16 @@ int nfs40_walk_client_list(struct nfs_client *new,
 
 	spin_lock(&nn->nfs_client_lock);
 	list_for_each_entry(pos, &nn->nfs_client_list, cl_share_link) {
+
+		if (pos->rpc_ops != new->rpc_ops)
+			continue;
+
+		if (pos->cl_proto != new->cl_proto)
+			continue;
+
+		if (pos->cl_minorversion != new->cl_minorversion)
+			continue;
+
 		/* If "pos" isn't marked ready, we can't trust the
 		 * remaining fields in "pos" */
 		if (pos->cl_cons_state > NFS_CS_READY) {
@@ -504,15 +514,6 @@ int nfs40_walk_client_list(struct nfs_client *new,
 		if (pos->cl_cons_state != NFS_CS_READY)
 			continue;
 
-		if (pos->rpc_ops != new->rpc_ops)
-			continue;
-
-		if (pos->cl_proto != new->cl_proto)
-			continue;
-
-		if (pos->cl_minorversion != new->cl_minorversion)
-			continue;
-
 		if (pos->cl_clientid != new->cl_clientid)
 			continue;
 
@@ -618,6 +619,16 @@ int nfs41_walk_client_list(struct nfs_client *new,
 
 	spin_lock(&nn->nfs_client_lock);
 	list_for_each_entry(pos, &nn->nfs_client_list, cl_share_link) {
+
+		if (pos->rpc_ops != new->rpc_ops)
+			continue;
+
+		if (pos->cl_proto != new->cl_proto)
+			continue;
+
+		if (pos->cl_minorversion != new->cl_minorversion)
+			continue;
+
 		/* If "pos" isn't marked ready, we can't trust the
 		 * remaining fields in "pos", especially the client
 		 * ID and serverowner fields.  Wait for CREATE_SESSION
@@ -643,15 +654,6 @@ int nfs41_walk_client_list(struct nfs_client *new,
 		if (pos->cl_cons_state != NFS_CS_READY)
 			continue;
 
-		if (pos->rpc_ops != new->rpc_ops)
-			continue;
-
-		if (pos->cl_proto != new->cl_proto)
-			continue;
-
-		if (pos->cl_minorversion != new->cl_minorversion)
-			continue;
-
 		if (!nfs4_match_clientids(pos, new))
 			continue;
 
-- 
1.9.1

