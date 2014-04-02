Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030249AbaDBUQZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Apr 2014 16:16:25 -0400
Received: from ip4-83-240-18-248.cust.nbox.cz ([83.240.18.248]:42879 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758942AbaDBUNb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Apr 2014 16:13:31 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Trond Myklebust <Trond.Myklebust@netapp.com>,
        Trond Myklebust <Trond.Myklebust@primarydata.com>,
        Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 11/40] NFSv4.1: Prevent a 3-way deadlock between layoutreturn, open and state recovery
Date: Wed,  2 Apr 2014 22:12:57 +0200
Message-Id: <025cbea96f0894dddc811ff237a43df0c1db02db.1396469191.git.jslaby@suse.cz>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <4c74007da904cc0411d788200034b2fb4c9e0d01.1396469191.git.jslaby@suse.cz>
References: <4c74007da904cc0411d788200034b2fb4c9e0d01.1396469191.git.jslaby@suse.cz>
In-Reply-To: <cover.1396469191.git.jslaby@suse.cz>
References: <cover.1396469191.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Trond Myklebust <Trond.Myklebust@netapp.com>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

commit f22e5edd2244609aed3906207a62223e7707a34d upstream.

Andy Adamson reports:

The state manager is recovering expired state and recovery OPENs are being
processed. If kswapd is pruning inodes at the same time, a deadlock can occur
when kswapd calls evict_inode on an NFSv4.1 inode with a layout, and the
resultant layoutreturn gets an error that the state mangager is to handle,
causing the layoutreturn to wait on the (NFS client) cl_rpcwaitq.

At the same time an open is waiting for the inode deletion to complete in
__wait_on_freeing_inode.

If the open is either the open called by the state manager, or an open from
the same open owner that is holding the NFSv4 sequence id which causes the
OPEN from the state manager to wait for the sequence id on the Seqid_waitqueue,
then the state is deadlocked with kswapd.

The fix is simply to have layoutreturn ignore all errors except NFS4ERR_DELAY.
We already know that layouts are dropped on all server reboots, and that
it has to be coded to deal with the "forgetful client model" that doesn't
send layoutreturns.

Reported-by: Andy Adamson <andros@netapp.com>
Link: http://lkml.kernel.org/r/1385402270-14284-1-git-send-email-andros@netapp.com
Signed-off-by: Trond Myklebust <Trond.Myklebust@primarydata.com>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 fs/nfs/nfs4proc.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/fs/nfs/nfs4proc.c b/fs/nfs/nfs4proc.c
index 5a5fb98edb8a..9edb753d9e3a 100644
--- a/fs/nfs/nfs4proc.c
+++ b/fs/nfs/nfs4proc.c
@@ -7273,7 +7273,14 @@ static void nfs4_layoutreturn_done(struct rpc_task *task, void *calldata)
 		return;
 
 	server = NFS_SERVER(lrp->args.inode);
-	if (nfs4_async_handle_error(task, server, NULL) == -EAGAIN) {
+	switch (task->tk_status) {
+	default:
+		task->tk_status = 0;
+	case 0:
+		break;
+	case -NFS4ERR_DELAY:
+		if (nfs4_async_handle_error(task, server, NULL) != -EAGAIN)
+			break;
 		rpc_restart_call_prepare(task);
 		return;
 	}
-- 
1.9.1

