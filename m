Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932871AbbA2JwL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jan 2015 04:52:11 -0500
Received: from ip4-83-240-67-251.cust.nbox.cz ([83.240.67.251]:44813 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1759257AbbA2JEK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jan 2015 04:04:10 -0500
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
        Trond Myklebust <trond.myklebust@primarydata.com>,
        Chuck Lever <chuck.lever@oracle.com>, Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 103/176] NFSv4.1: Fix client id trunking on Linux
Date: Wed, 28 Jan 2015 15:28:53 +0100
Message-Id: <d43170104637ad8499f686064d08c49176fe1243.1422455352.git.jslaby@suse.cz>
X-Mailer: git-send-email 2.2.2
In-Reply-To: <ce4a451f616a1e7ab58cfeceea5e49c8b1c68c81.1422455352.git.jslaby@suse.cz>
References: <ce4a451f616a1e7ab58cfeceea5e49c8b1c68c81.1422455352.git.jslaby@suse.cz>
In-Reply-To: <cover.1422455352.git.jslaby@suse.cz>
References: <cover.1422455352.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Trond Myklebust <trond.myklebust@primarydata.com>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

commit 1fc0703af3143914a389bfa081c7acb09502ed5d upstream.

Currently, our trunking code will check for session trunking, but will
fail to detect client id trunking. This is a problem, because it means
that the client will fail to recognise that the two connections represent
shared state, even if they do not permit a shared session.
By removing the check for the server minor id, and only checking the
major id, we will end up doing the right thing in both cases: we close
down the new nfs_client and fall back to using the existing one.

Fixes: 05f4c350ee02e ("NFS: Discover NFSv4 server trunking when mounting")
Cc: Chuck Lever <chuck.lever@oracle.com>
Tested-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Trond Myklebust <trond.myklebust@primarydata.com>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 fs/nfs/nfs4client.c | 17 ++++++++---------
 1 file changed, 8 insertions(+), 9 deletions(-)

diff --git a/fs/nfs/nfs4client.c b/fs/nfs/nfs4client.c
index 531f1b48b46b..ce036f071302 100644
--- a/fs/nfs/nfs4client.c
+++ b/fs/nfs/nfs4client.c
@@ -561,20 +561,14 @@ static bool nfs4_match_clientids(struct nfs_client *a, struct nfs_client *b)
 }
 
 /*
- * Returns true if the server owners match
+ * Returns true if the server major ids match
  */
 static bool
-nfs4_match_serverowners(struct nfs_client *a, struct nfs_client *b)
+nfs4_check_clientid_trunking(struct nfs_client *a, struct nfs_client *b)
 {
 	struct nfs41_server_owner *o1 = a->cl_serverowner;
 	struct nfs41_server_owner *o2 = b->cl_serverowner;
 
-	if (o1->minor_id != o2->minor_id) {
-		dprintk("NFS: --> %s server owner minor IDs do not match\n",
-			__func__);
-		return false;
-	}
-
 	if (o1->major_id_sz != o2->major_id_sz)
 		goto out_major_mismatch;
 	if (memcmp(o1->major_id, o2->major_id, o1->major_id_sz) != 0)
@@ -650,7 +644,12 @@ int nfs41_walk_client_list(struct nfs_client *new,
 		if (!nfs4_match_clientids(pos, new))
 			continue;
 
-		if (!nfs4_match_serverowners(pos, new))
+		/*
+		 * Note that session trunking is just a special subcase of
+		 * client id trunking. In either case, we want to fall back
+		 * to using the existing nfs_client.
+		 */
+		if (!nfs4_check_clientid_trunking(pos, new))
 			continue;
 
 		atomic_inc(&pos->cl_count);
-- 
2.2.2

