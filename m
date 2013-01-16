Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756780Ab3APP6a (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jan 2013 10:58:30 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:35678 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752850Ab3APP6Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jan 2013 10:58:25 -0500
From: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Trond Myklebust <Trond.Myklebust@netapp.com>,
        Stanislav Kinsbursky <skinsbursky@parallels.com>,
        Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
Subject: [PATCH 015/222] SUNRPC: Fix validity issues with rpc_pipefs sb->s_fs_info
Date: Wed, 16 Jan 2013 13:53:35 -0200
Message-Id: <1358351822-7675-16-git-send-email-herton.krzesinski@canonical.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1358351822-7675-1-git-send-email-herton.krzesinski@canonical.com>
References: <1358351822-7675-1-git-send-email-herton.krzesinski@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.3 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Trond Myklebust <Trond.Myklebust@netapp.com>

commit 642fe4d00db56d65060ce2fd4c105884414acb16 upstream.

rpc_kill_sb() must defer calling put_net() until after the notifier
has been called, since most (all?) of the notifier callbacks assume
that sb->s_fs_info points to a valid net namespace. It also must not
call put_net() if the call to rpc_fill_super was unsuccessful.

Bugzilla: https://bugzilla.kernel.org/show_bug.cgi?id=48421

Signed-off-by: Trond Myklebust <Trond.Myklebust@netapp.com>
Cc: Stanislav Kinsbursky <skinsbursky@parallels.com>
[ herton: adjust context ]
Signed-off-by: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
---
 net/sunrpc/rpc_pipe.c |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/net/sunrpc/rpc_pipe.c b/net/sunrpc/rpc_pipe.c
index 21fde99..2a419f1 100644
--- a/net/sunrpc/rpc_pipe.c
+++ b/net/sunrpc/rpc_pipe.c
@@ -1152,14 +1152,19 @@ static void rpc_kill_sb(struct super_block *sb)
 	struct sunrpc_net *sn = net_generic(net, sunrpc_net_id);
 
 	mutex_lock(&sn->pipefs_sb_lock);
+	if (sn->pipefs_sb != sb) {
+		mutex_unlock(&sn->pipefs_sb_lock);
+		goto out;
+	}
 	sn->pipefs_sb = NULL;
 	mutex_unlock(&sn->pipefs_sb_lock);
-	put_net(net);
 	dprintk("RPC:	sending pipefs UMOUNT notification for net %p%s\n", net,
 								NET_NAME(net));
 	blocking_notifier_call_chain(&rpc_pipefs_notifier_list,
 					   RPC_PIPEFS_UMOUNT,
 					   sb);
+	put_net(net);
+out:
 	kill_litter_super(sb);
 }
 
-- 
1.7.9.5

