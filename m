Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752599AbaJ0TAI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2014 15:00:08 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:52478 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752770AbaJ0S7h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2014 14:59:37 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Trond Myklebust <trond.myklebust@primarydata.com>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13 061/105] NFSv4: Fix lock recovery when CREATE_SESSION/SETCLIENTID_CONFIRM fails
Date: Mon, 27 Oct 2014 11:56:36 -0700
Message-Id: <1414436240-13879-62-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1414436240-13879-1-git-send-email-kamal@canonical.com>
References: <1414436240-13879-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11.10 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Trond Myklebust <trond.myklebust@primarydata.com>

commit a4339b7b686b4acc8b6de2b07d7bacbe3ae44b83 upstream.

If a NFSv4.x server returns NFS4ERR_STALE_CLIENTID in response to a
CREATE_SESSION or SETCLIENTID_CONFIRM in order to tell us that it rebooted
a second time, then the client will currently take this to mean that it must
declare all locks to be stale, and hence ineligible for reboot recovery.

RFC3530 and RFC5661 both suggest that the client should instead rely on the
server to respond to inelegible open share, lock and delegation reclaim
requests with NFS4ERR_NO_GRACE in this situation.

Signed-off-by: Trond Myklebust <trond.myklebust@primarydata.com>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 fs/nfs/nfs4state.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/fs/nfs/nfs4state.c b/fs/nfs/nfs4state.c
index 5d02d74..931ac3d 100644
--- a/fs/nfs/nfs4state.c
+++ b/fs/nfs/nfs4state.c
@@ -1796,7 +1796,6 @@ static int nfs4_handle_reclaim_lease_error(struct nfs_client *clp, int status)
 		break;
 	case -NFS4ERR_STALE_CLIENTID:
 		clear_bit(NFS4CLNT_LEASE_CONFIRM, &clp->cl_state);
-		nfs4_state_clear_reclaim_reboot(clp);
 		nfs4_state_start_reclaim_reboot(clp);
 		break;
 	case -NFS4ERR_CLID_INUSE:
-- 
1.9.1

