Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933716AbaJ1Dw0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2014 23:52:26 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:46551 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933619AbaJ1DwO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2014 23:52:14 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Trond Myklebust <trond.myklebust@primarydata.com>
Subject: [PATCH 3.10 26/43] NFSv4: fix open/lock state recovery error handling
Date: Tue, 28 Oct 2014 11:36:24 +0800
Message-Id: <20141028033524.524526315@linuxfoundation.org>
X-Mailer: git-send-email 2.1.2
In-Reply-To: <20141028033523.407092670@linuxfoundation.org>
References: <20141028033523.407092670@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Trond Myklebust <trond.myklebust@primarydata.com>

commit df817ba35736db2d62b07de6f050a4db53492ad8 upstream.

The current open/lock state recovery unfortunately does not handle errors
such as NFS4ERR_CONN_NOT_BOUND_TO_SESSION correctly. Instead of looping,
just proceeds as if the state manager is finished recovering.
This patch ensures that we loop back, handle higher priority errors
and complete the open/lock state recovery.

Signed-off-by: Trond Myklebust <trond.myklebust@primarydata.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/nfs/nfs4state.c |   16 ++++++----------
 1 file changed, 6 insertions(+), 10 deletions(-)

--- a/fs/nfs/nfs4state.c
+++ b/fs/nfs/nfs4state.c
@@ -1699,7 +1699,8 @@ restart:
 			if (status < 0) {
 				set_bit(ops->owner_flag_bit, &sp->so_flags);
 				nfs4_put_state_owner(sp);
-				return nfs4_recovery_handle_error(clp, status);
+				status = nfs4_recovery_handle_error(clp, status);
+				return (status != 0) ? status : -EAGAIN;
 			}
 
 			nfs4_put_state_owner(sp);
@@ -1708,7 +1709,7 @@ restart:
 		spin_unlock(&clp->cl_lock);
 	}
 	rcu_read_unlock();
-	return status;
+	return 0;
 }
 
 static int nfs4_check_lease(struct nfs_client *clp)
@@ -2173,14 +2174,11 @@ static void nfs4_state_manager(struct nf
 			section = "reclaim reboot";
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
@@ -2188,9 +2186,7 @@ static void nfs4_state_manager(struct nf
 			section = "reclaim nograce";
 			status = nfs4_do_reclaim(clp,
 				clp->cl_mvops->nograce_recovery_ops);
-			if (test_bit(NFS4CLNT_LEASE_EXPIRED, &clp->cl_state) ||
-			    test_bit(NFS4CLNT_SESSION_RESET, &clp->cl_state) ||
-			    test_bit(NFS4CLNT_RECLAIM_REBOOT, &clp->cl_state))
+			if (status == -EAGAIN)
 				continue;
 			if (status < 0)
 				goto out_error;


