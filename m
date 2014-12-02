Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933627AbaLBT0J (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Dec 2014 14:26:09 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:46873 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933589AbaLBT0C (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Dec 2014 14:26:02 -0500
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Trond Myklebust <trond.myklebust@primarydata.com>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13.y-ckt 079/121] NFSv4: Ensure that we call FREE_STATEID when NFSv4.x stateids are revoked
Date: Tue,  2 Dec 2014 11:19:18 -0800
Message-Id: <1417548000-1794-80-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1417548000-1794-1-git-send-email-kamal@canonical.com>
References: <1417548000-1794-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11-ckt12 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Trond Myklebust <trond.myklebust@primarydata.com>

commit c606bb8857921d3ecf4d353942d6cc7e116cc75a upstream.

NFSv4.x (x>0) requires us to call TEST_STATEID+FREE_STATEID if a stateid is
revoked. We will currently fail to do this if the stateid is a delegation.

http://lkml.kernel.org/r/CAN-5tyHwG=Cn2Q9KsHWadewjpTTy_K26ee+UnSvHvG4192p-Xw@mail.gmail.com
Signed-off-by: Trond Myklebust <trond.myklebust@primarydata.com>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 fs/nfs/nfs4filelayout.c | 3 ---
 fs/nfs/nfs4proc.c       | 8 --------
 2 files changed, 11 deletions(-)

diff --git a/fs/nfs/nfs4filelayout.c b/fs/nfs/nfs4filelayout.c
index b86464b..d5e4bd9 100644
--- a/fs/nfs/nfs4filelayout.c
+++ b/fs/nfs/nfs4filelayout.c
@@ -153,9 +153,6 @@ static int filelayout_async_handle_error(struct rpc_task *task,
 	case -NFS4ERR_DELEG_REVOKED:
 	case -NFS4ERR_ADMIN_REVOKED:
 	case -NFS4ERR_BAD_STATEID:
-		if (state == NULL)
-			break;
-		nfs_remove_bad_delegation(state->inode);
 	case -NFS4ERR_OPENMODE:
 		if (state == NULL)
 			break;
diff --git a/fs/nfs/nfs4proc.c b/fs/nfs/nfs4proc.c
index 322c416..cc27e1f 100644
--- a/fs/nfs/nfs4proc.c
+++ b/fs/nfs/nfs4proc.c
@@ -360,11 +360,6 @@ static int nfs4_handle_exception(struct nfs_server *server, int errorcode, struc
 		case -NFS4ERR_DELEG_REVOKED:
 		case -NFS4ERR_ADMIN_REVOKED:
 		case -NFS4ERR_BAD_STATEID:
-			if (inode != NULL && nfs4_have_delegation(inode, FMODE_READ)) {
-				nfs_remove_bad_delegation(inode);
-				exception->retry = 1;
-				break;
-			}
 			if (state == NULL)
 				break;
 			ret = nfs4_schedule_stateid_recovery(server, state);
@@ -4792,9 +4787,6 @@ nfs4_async_handle_error(struct rpc_task *task, const struct nfs_server *server,
 		case -NFS4ERR_DELEG_REVOKED:
 		case -NFS4ERR_ADMIN_REVOKED:
 		case -NFS4ERR_BAD_STATEID:
-			if (state == NULL)
-				break;
-			nfs_remove_bad_delegation(state->inode);
 		case -NFS4ERR_OPENMODE:
 			if (state == NULL)
 				break;
-- 
1.9.1

