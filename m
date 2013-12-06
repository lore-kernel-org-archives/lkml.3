Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161709Ab3LFXcc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Dec 2013 18:32:32 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:48876 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932596Ab3LFXTw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Dec 2013 18:19:52 -0500
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Stanislav Kinsbursky <skinsbursky@parallels.com>,
        Trond Myklebust <Trond.Myklebust@netapp.com>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.8 098/152] SUNRPC: fix races on PipeFS UMOUNT notifications
Date: Fri,  6 Dec 2013 15:10:22 -0800
Message-Id: <1386371476-2477-99-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1386371476-2477-1-git-send-email-kamal@canonical.com>
References: <1386371476-2477-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.14 -stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 net/sunrpc/clnt.c     | 5 +----
 net/sunrpc/rpc_pipe.c | 2 +-
 2 files changed, 2 insertions(+), 5 deletions(-)

diff --git a/net/sunrpc/clnt.c b/net/sunrpc/clnt.c
index 716aa41..1a3bd4d 100644
--- a/net/sunrpc/clnt.c
+++ b/net/sunrpc/clnt.c
@@ -240,8 +240,6 @@ static struct rpc_clnt *rpc_get_client_for_event(struct net *net, int event)
 			continue;
 		if (rpc_clnt_skip_event(clnt, event))
 			continue;
-		if (atomic_inc_not_zero(&clnt->cl_count) == 0)
-			continue;
 		spin_unlock(&sn->rpc_client_lock);
 		return clnt;
 	}
@@ -258,7 +256,6 @@ static int rpc_pipefs_event(struct notifier_block *nb, unsigned long event,
 
 	while ((clnt = rpc_get_client_for_event(sb->s_fs_info, event))) {
 		error = __rpc_pipefs_event(clnt, event, sb);
-		rpc_release_client(clnt);
 		if (error)
 			break;
 	}
@@ -635,8 +632,8 @@ rpc_free_client(struct rpc_clnt *clnt)
 			rcu_dereference(clnt->cl_xprt)->servername);
 	if (clnt->cl_parent != clnt)
 		rpc_release_client(clnt->cl_parent);
-	rpc_unregister_client(clnt);
 	rpc_clnt_remove_pipedir(clnt);
+	rpc_unregister_client(clnt);
 	rpc_free_iostats(clnt->cl_metrics);
 	kfree(clnt->cl_principal);
 	clnt->cl_metrics = NULL;
diff --git a/net/sunrpc/rpc_pipe.c b/net/sunrpc/rpc_pipe.c
index fd10981..05bd864 100644
--- a/net/sunrpc/rpc_pipe.c
+++ b/net/sunrpc/rpc_pipe.c
@@ -1157,12 +1157,12 @@ static void rpc_kill_sb(struct super_block *sb)
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
-- 
1.8.3.2

