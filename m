Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755558AbaBGM0x (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Feb 2014 07:26:53 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:42109 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753701AbaBGLvF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Feb 2014 06:51:05 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Trond Myklebust <trond.myklebust@primarydata.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 146/233] NFSv4.1: Handle errors correctly in nfs41_walk_client_list
Date: Fri,  7 Feb 2014 11:46:05 +0000
Message-Id: <1391773652-25214-147-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1391773652-25214-1-git-send-email-luis.henriques@canonical.com>
References: <1391773652-25214-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.4 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Trond Myklebust <trond.myklebust@primarydata.com>

commit 64590daa9e0dfb3aad89e3ab9230683b76211d5b upstream.

Both nfs41_walk_client_list and nfs40_walk_client_list expect the
'status' variable to be set to the value -NFS4ERR_STALE_CLIENTID
if the loop fails to find a match.
The problem is that the 'pos->cl_cons_state > NFS_CS_READY' changes
the value of 'status', and sets it either to the value '0' (which
indicates success), or to the value EINTR.

Signed-off-by: Trond Myklebust <trond.myklebust@primarydata.com>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 fs/nfs/nfs4client.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/fs/nfs/nfs4client.c b/fs/nfs/nfs4client.c
index 90dce91..3ae4d8c 100644
--- a/fs/nfs/nfs4client.c
+++ b/fs/nfs/nfs4client.c
@@ -329,9 +329,10 @@ int nfs40_walk_client_list(struct nfs_client *new,
 			prev = pos;
 
 			status = nfs_wait_client_init_complete(pos);
-			spin_lock(&nn->nfs_client_lock);
 			if (status < 0)
-				continue;
+				goto out;
+			status = -NFS4ERR_STALE_CLIENTID;
+			spin_lock(&nn->nfs_client_lock);
 		}
 		if (pos->cl_cons_state != NFS_CS_READY)
 			continue;
@@ -469,7 +470,8 @@ int nfs41_walk_client_list(struct nfs_client *new,
 			}
 			spin_lock(&nn->nfs_client_lock);
 			if (status < 0)
-				continue;
+				break;
+			status = -NFS4ERR_STALE_CLIENTID;
 		}
 		if (pos->cl_cons_state != NFS_CS_READY)
 			continue;
-- 
1.8.3.2

