Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762529AbbA1FTH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2015 00:19:07 -0500
Received: from mail.kernel.org ([198.145.29.136]:37749 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760097AbbA1EQ3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2015 23:16:29 -0500
From: lizf@kernel.org
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
        Trond Myklebust <trond.myklebust@primarydata.com>,
        Zefan Li <lizefan@huawei.com>
Subject: [PATCH 3.4 034/177] NFSv4: fix open/lock state recovery error handling
Date: Wed, 28 Jan 2015 12:07:14 +0800
Message-Id: <1422418236-12852-67-git-send-email-lizf@kernel.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1422418050-12581-1-git-send-email-lizf@kernel.org>
References: <1422418050-12581-1-git-send-email-lizf@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Trond Myklebust <trond.myklebust@primarydata.com>

3.4.106-rc1 review patch.  If anyone has any objections, please let me know.

------------------


commit df817ba35736db2d62b07de6f050a4db53492ad8 upstream.

The current open/lock state recovery unfortunately does not handle errors
such as NFS4ERR_CONN_NOT_BOUND_TO_SESSION correctly. Instead of looping,
just proceeds as if the state manager is finished recovering.
This patch ensures that we loop back, handle higher priority errors
and complete the open/lock state recovery.

Signed-off-by: Trond Myklebust <trond.myklebust@primarydata.com>
Signed-off-by: Zefan Li <lizefan@huawei.com>
---
 fs/nfs/nfs4state.c | 16 ++++++----------
 1 file changed, 6 insertions(+), 10 deletions(-)

diff --git a/fs/nfs/nfs4state.c b/fs/nfs/nfs4state.c
index 461816b..c4600b5 100644
--- a/fs/nfs/nfs4state.c
+++ b/fs/nfs/nfs4state.c
@@ -1515,7 +1515,8 @@ restart:
 			if (status < 0) {
 				set_bit(ops->owner_flag_bit, &sp->so_flags);
 				nfs4_put_state_owner(sp);
-				return nfs4_recovery_handle_error(clp, status);
+				status = nfs4_recovery_handle_error(clp, status);
+				return (status != 0) ? status : -EAGAIN;
 			}
 
 			nfs4_put_state_owner(sp);
@@ -1524,7 +1525,7 @@ restart:
 		spin_unlock(&clp->cl_lock);
 	}
 	rcu_read_unlock();
-	return status;
+	return 0;
 }
 
 static int nfs4_check_lease(struct nfs_client *clp)
@@ -1796,23 +1797,18 @@ static void nfs4_state_manager(struct nfs_client *clp)
 		if (test_bit(NFS4CLNT_RECLAIM_REBOOT, &clp->cl_state)) {
 			status = nfs4_do_reclaim(clp,
 				clp->cl_mvops->reboot_recovery_ops);
-			if (test_bit(NFS4CLNT_LEASE_EXPIRED, &clp->cl_state) ||
-			    test_bit(NFS4CLNT_SESSION_RESET, &clp->cl_state))
-				continue;
-			nfs4_state_end_reclaim_reboot(clp);
-			if (test_bit(NFS4CLNT_RECLAIM_NOGRACE, &clp->cl_state))
+			if (status == -EAGAIN)
 				continue;
 			if (status < 0)
 				goto out_error;
+			nfs4_state_end_reclaim_reboot(clp);
 		}
 
 		/* Now recover expired state... */
 		if (test_and_clear_bit(NFS4CLNT_RECLAIM_NOGRACE, &clp->cl_state)) {
 			status = nfs4_do_reclaim(clp,
 				clp->cl_mvops->nograce_recovery_ops);
-			if (test_bit(NFS4CLNT_LEASE_EXPIRED, &clp->cl_state) ||
-			    test_bit(NFS4CLNT_SESSION_RESET, &clp->cl_state) ||
-			    test_bit(NFS4CLNT_RECLAIM_REBOOT, &clp->cl_state))
+			if (status == -EAGAIN)
 				continue;
 			if (status < 0)
 				goto out_error;
-- 
1.9.1

