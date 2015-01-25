Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757859AbbAYShD (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Jan 2015 13:37:03 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:57776 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755930AbbAYSKS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Jan 2015 13:10:18 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Chuck Lever <chuck.lever@oracle.com>,
        Trond Myklebust <trond.myklebust@primarydata.com>
Subject: [PATCH 3.18 125/183] NFSv4.1: Fix client id trunking on Linux
Date: Sun, 25 Jan 2015 10:07:27 -0800
Message-Id: <20150125180815.607133364@linuxfoundation.org>
X-Mailer: git-send-email 2.2.2
In-Reply-To: <20150125180810.160428929@linuxfoundation.org>
References: <20150125180810.160428929@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Trond Myklebust <trond.myklebust@primarydata.com>

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/nfs/nfs4client.c |   17 ++++++++---------
 1 file changed, 8 insertions(+), 9 deletions(-)

--- a/fs/nfs/nfs4client.c
+++ b/fs/nfs/nfs4client.c
@@ -572,20 +572,14 @@ static bool nfs4_match_clientids(struct
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
@@ -661,7 +655,12 @@ int nfs41_walk_client_list(struct nfs_cl
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


