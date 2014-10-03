Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760143AbaJCXbJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Oct 2014 19:31:09 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:46474 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757383AbaJCWDz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Oct 2014 18:03:55 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Steve Dickson <steved@redhat.com>,
        Trond Myklebust <trond.myklebust@primarydata.com>
Subject: [PATCH 3.14 106/238] NFSv4: nfs4_state_manager() vs. nfs_server_remove_lists()
Date: Fri,  3 Oct 2014 14:30:21 -0700
Message-Id: <20141003212917.071114795@linuxfoundation.org>
X-Mailer: git-send-email 2.1.2
In-Reply-To: <20141003212913.680985295@linuxfoundation.org>
References: <20141003212913.680985295@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.14-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/nfs/nfs4client.c |   38 ++++++++++++++++++++------------------
 1 file changed, 20 insertions(+), 18 deletions(-)

--- a/fs/nfs/nfs4client.c
+++ b/fs/nfs/nfs4client.c
@@ -482,6 +482,16 @@ int nfs40_walk_client_list(struct nfs_cl
 
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
@@ -501,15 +511,6 @@ int nfs40_walk_client_list(struct nfs_cl
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
 
@@ -615,6 +616,16 @@ int nfs41_walk_client_list(struct nfs_cl
 
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
@@ -640,15 +651,6 @@ int nfs41_walk_client_list(struct nfs_cl
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
 


