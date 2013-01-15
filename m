Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932987Ab3AOXwc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2013 18:52:32 -0500
Received: from mail.kernel.org ([198.145.19.201]:45694 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933028Ab3AOWtf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2013 17:49:35 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Trond Myklebust <Trond.Myklebust@netapp.com>,
        Stanislav Kinsbursky <skinsbursky@parallels.com>
Subject: [ 042/171] SUNRPC: Fix validity issues with rpc_pipefs sb->s_fs_info
Date: Tue, 15 Jan 2013 14:43:27 -0800
Message-Id: <20130115224316.455938534@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.336.g94702dd
In-Reply-To: <20130115224313.394976595@linuxfoundation.org>
References: <20130115224313.394976595@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 net/sunrpc/rpc_pipe.c |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

--- a/net/sunrpc/rpc_pipe.c
+++ b/net/sunrpc/rpc_pipe.c
@@ -1157,14 +1157,19 @@ static void rpc_kill_sb(struct super_blo
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
 


