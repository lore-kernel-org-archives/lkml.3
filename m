Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758830Ab3APQql (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jan 2013 11:46:41 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:36164 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758333Ab3APQEQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jan 2013 11:04:16 -0500
From: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: NeilBrown <neilb@suse.de>, Trond Myklebust <Trond.Myklebust@netapp.com>,
        Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
Subject: [PATCH 106/222] NFS: avoid NULL dereference in nfs_destroy_server
Date: Wed, 16 Jan 2013 13:55:06 -0200
Message-Id: <1358351822-7675-107-git-send-email-herton.krzesinski@canonical.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1358351822-7675-1-git-send-email-herton.krzesinski@canonical.com>
References: <1358351822-7675-1-git-send-email-herton.krzesinski@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.3 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: NeilBrown <neilb@suse.de>

commit f259613a1e4b44a0cf85a5dafd931be96ee7c9e5 upstream.

In rare circumstances, nfs_clone_server() of a v2 or v3 server can get
an error between setting server->destory (to nfs_destroy_server), and
calling nfs_start_lockd (which will set server->nlm_host).

If this happens, nfs_clone_server will call nfs_free_server which
will call nfs_destroy_server and thence nlmclnt_done(NULL).  This
causes the NULL to be dereferenced.

So add a guard to only call nlmclnt_done() if ->nlm_host is not NULL.

The other guards there are irrelevant as nlm_host can only be non-NULL
if one of these flags are set - so remove those tests.  (Thanks to Trond
for this suggestion).

This is suitable for any stable kernel since 2.6.25.

Signed-off-by: NeilBrown <neilb@suse.de>
Signed-off-by: Trond Myklebust <Trond.Myklebust@netapp.com>
Signed-off-by: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
---
 fs/nfs/client.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/fs/nfs/client.c b/fs/nfs/client.c
index f005b5b..ede78be 100644
--- a/fs/nfs/client.c
+++ b/fs/nfs/client.c
@@ -689,8 +689,7 @@ static int nfs_create_rpc_client(struct nfs_client *clp,
  */
 static void nfs_destroy_server(struct nfs_server *server)
 {
-	if (!(server->flags & NFS_MOUNT_LOCAL_FLOCK) ||
-			!(server->flags & NFS_MOUNT_LOCAL_FCNTL))
+	if (server->nlm_host)
 		nlmclnt_done(server->nlm_host);
 }
 
-- 
1.7.9.5

