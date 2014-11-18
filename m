Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932336AbaKRPFu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Nov 2014 10:05:50 -0500
Received: from cantor2.suse.de ([195.135.220.15]:57207 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932073AbaKROJk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Nov 2014 09:09:40 -0500
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Benjamin Coddington <bcodding@redhat.com>,
        Trond Myklebust <trond.myklebust@primarydata.com>,
        Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 053/206] lockd: Try to reconnect if statd has moved
Date: Tue, 18 Nov 2014 15:06:48 +0100
Message-Id: <92d945892fb00d0e0e22c1bcc77da9413b1a1395.1416319692.git.jslaby@suse.cz>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <28f04bcc068a44c5641c727883947960fb8dcbd5.1416319692.git.jslaby@suse.cz>
References: <28f04bcc068a44c5641c727883947960fb8dcbd5.1416319692.git.jslaby@suse.cz>
In-Reply-To: <cover.1416319692.git.jslaby@suse.cz>
References: <cover.1416319692.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Benjamin Coddington <bcodding@redhat.com>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

commit 173b3afceebe76fa2205b2c8808682d5b541fe3c upstream.

If rpc.statd is restarted, upcalls to monitor hosts can fail with
ECONNREFUSED.  In that case force a lookup of statd's new port and retry the
upcall.

Signed-off-by: Benjamin Coddington <bcodding@redhat.com>
Signed-off-by: Trond Myklebust <trond.myklebust@primarydata.com>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 fs/lockd/mon.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/fs/lockd/mon.c b/fs/lockd/mon.c
index 1812f026960c..6ae664b489af 100644
--- a/fs/lockd/mon.c
+++ b/fs/lockd/mon.c
@@ -159,6 +159,12 @@ static int nsm_mon_unmon(struct nsm_handle *nsm, u32 proc, struct nsm_res *res,
 
 	msg.rpc_proc = &clnt->cl_procinfo[proc];
 	status = rpc_call_sync(clnt, &msg, RPC_TASK_SOFTCONN);
+	if (status == -ECONNREFUSED) {
+		dprintk("lockd:	NSM upcall RPC failed, status=%d, forcing rebind\n",
+				status);
+		rpc_force_rebind(clnt);
+		status = rpc_call_sync(clnt, &msg, RPC_TASK_SOFTCONN);
+	}
 	if (status < 0)
 		dprintk("lockd: NSM upcall RPC failed, status=%d\n",
 				status);
-- 
2.1.3

