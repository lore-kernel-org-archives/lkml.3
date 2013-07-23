Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935021Ab3GWWjl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jul 2013 18:39:41 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:41768 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934093Ab3GWW1m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jul 2013 18:27:42 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Stanislav Kinsbursky <skinsbursky@parallels.com>,
        Trond Myklebust <Trond.Myklebust@netapp.com>
Subject: [ 068/103] SUNRPC: fix races on PipeFS UMOUNT notifications
Date: Tue, 23 Jul 2013 15:26:19 -0700
Message-Id: <20130723220426.853989725@linuxfoundation.org>
X-Mailer: git-send-email 1.8.3.rc0.20.gb99dd2e
In-Reply-To: <20130723220418.532514378@linuxfoundation.org>
References: <20130723220418.532514378@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Stanislav Kinsbursky <skinsbursky@parallels.com>

commit adb6fa7ffe9031857ec14b8aab75c9ab65556cbc upstream.

CPU#0                                   CPU#1
-----------------------------           -----------------------------
rpc_kill_sb
sn->pipefs_sb = NULL                    rpc_release_client
(UMOUNT_EVENT)                          rpc_free_auth
rpc_pipefs_event
rpc_get_client_for_event
!atomic_inc_not_zero(cl_count)
<skip the client>
                                        atomic_inc(cl_count)
                                        rpc_free_client
                                        rpc_clnt_remove_pipedir
                                        <skip client dir removing>

To fix this, this patch does the following:

1) Calls RPC_PIPEFS_UMOUNT notification with sn->pipefs_sb_lock being held.
2) Removes SUNRPC client from the list AFTER pipes destroying.
3) Doesn't hold RPC client on notification: if client in the list, then it
can't be destroyed while sn->pipefs_sb_lock in hold by notification caller.

Signed-off-by: Stanislav Kinsbursky <skinsbursky@parallels.com>
Signed-off-by: Trond Myklebust <Trond.Myklebust@netapp.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 net/sunrpc/clnt.c     |    5 +----
 net/sunrpc/rpc_pipe.c |    2 +-
 2 files changed, 2 insertions(+), 5 deletions(-)

--- a/net/sunrpc/clnt.c
+++ b/net/sunrpc/clnt.c
@@ -236,8 +236,6 @@ static struct rpc_clnt *rpc_get_client_f
 			continue;
 		if (rpc_clnt_skip_event(clnt, event))
 			continue;
-		if (atomic_inc_not_zero(&clnt->cl_count) == 0)
-			continue;
 		spin_unlock(&sn->rpc_client_lock);
 		return clnt;
 	}
@@ -254,7 +252,6 @@ static int rpc_pipefs_event(struct notif
 
 	while ((clnt = rpc_get_client_for_event(sb->s_fs_info, event))) {
 		error = __rpc_pipefs_event(clnt, event, sb);
-		rpc_release_client(clnt);
 		if (error)
 			break;
 	}
@@ -641,8 +638,8 @@ rpc_free_client(struct rpc_clnt *clnt)
 			rcu_dereference(clnt->cl_xprt)->servername);
 	if (clnt->cl_parent != clnt)
 		rpc_release_client(clnt->cl_parent);
-	rpc_unregister_client(clnt);
 	rpc_clnt_remove_pipedir(clnt);
+	rpc_unregister_client(clnt);
 	rpc_free_iostats(clnt->cl_metrics);
 	kfree(clnt->cl_principal);
 	clnt->cl_metrics = NULL;
--- a/net/sunrpc/rpc_pipe.c
+++ b/net/sunrpc/rpc_pipe.c
@@ -1165,12 +1165,12 @@ static void rpc_kill_sb(struct super_blo
 		goto out;
 	}
 	sn->pipefs_sb = NULL;
-	mutex_unlock(&sn->pipefs_sb_lock);
 	dprintk("RPC:       sending pipefs UMOUNT notification for net %p%s\n",
 		net, NET_NAME(net));
 	blocking_notifier_call_chain(&rpc_pipefs_notifier_list,
 					   RPC_PIPEFS_UMOUNT,
 					   sb);
+	mutex_unlock(&sn->pipefs_sb_lock);
 	put_net(net);
 out:
 	kill_litter_super(sb);


