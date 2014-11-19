Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933136AbaKSU7p (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Nov 2014 15:59:45 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:56115 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932686AbaKSUyU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Nov 2014 15:54:20 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Trond Myklebust <trond.myklebust@primarydata.com>
Subject: [PATCH 3.17 105/141] NFSv4: Ensure that we call FREE_STATEID when NFSv4.x stateids are revoked
Date: Wed, 19 Nov 2014 12:52:08 -0800
Message-Id: <20141119205154.079894245@linuxfoundation.org>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <20141119205150.700188369@linuxfoundation.org>
References: <20141119205150.700188369@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Trond Myklebust <trond.myklebust@primarydata.com>

commit c606bb8857921d3ecf4d353942d6cc7e116cc75a upstream.

NFSv4.x (x>0) requires us to call TEST_STATEID+FREE_STATEID if a stateid is
revoked. We will currently fail to do this if the stateid is a delegation.

http://lkml.kernel.org/r/CAN-5tyHwG=Cn2Q9KsHWadewjpTTy_K26ee+UnSvHvG4192p-Xw@mail.gmail.com
Signed-off-by: Trond Myklebust <trond.myklebust@primarydata.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/nfs/filelayout/filelayout.c |    3 ---
 fs/nfs/nfs4proc.c              |    8 --------
 2 files changed, 11 deletions(-)

--- a/fs/nfs/filelayout/filelayout.c
+++ b/fs/nfs/filelayout/filelayout.c
@@ -145,9 +145,6 @@ static int filelayout_async_handle_error
 	case -NFS4ERR_DELEG_REVOKED:
 	case -NFS4ERR_ADMIN_REVOKED:
 	case -NFS4ERR_BAD_STATEID:
-		if (state == NULL)
-			break;
-		nfs_remove_bad_delegation(state->inode);
 	case -NFS4ERR_OPENMODE:
 		if (state == NULL)
 			break;
--- a/fs/nfs/nfs4proc.c
+++ b/fs/nfs/nfs4proc.c
@@ -360,11 +360,6 @@ static int nfs4_handle_exception(struct
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
@@ -4849,9 +4844,6 @@ nfs4_async_handle_error(struct rpc_task
 		case -NFS4ERR_DELEG_REVOKED:
 		case -NFS4ERR_ADMIN_REVOKED:
 		case -NFS4ERR_BAD_STATEID:
-			if (state == NULL)
-				break;
-			nfs_remove_bad_delegation(state->inode);
 		case -NFS4ERR_OPENMODE:
 			if (state == NULL)
 				break;


