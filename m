Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762766AbbA1FXI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2015 00:23:08 -0500
Received: from mail.kernel.org ([198.145.29.136]:37440 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933530AbbA1EPf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2015 23:15:35 -0500
From: lizf@kernel.org
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Benjamin Coddington <bcodding@redhat.com>,
        Trond Myklebust <trond.myklebust@primarydata.com>,
        Zefan Li <lizefan@huawei.com>
Subject: [PATCH 3.4 025/177] lockd: Try to reconnect if statd has moved
Date: Wed, 28 Jan 2015 12:06:57 +0800
Message-Id: <1422418236-12852-50-git-send-email-lizf@kernel.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1422418050-12581-1-git-send-email-lizf@kernel.org>
References: <1422418050-12581-1-git-send-email-lizf@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Benjamin Coddington <bcodding@redhat.com>

3.4.106-rc1 review patch.  If anyone has any objections, please let me know.

------------------


commit 173b3afceebe76fa2205b2c8808682d5b541fe3c upstream.

If rpc.statd is restarted, upcalls to monitor hosts can fail with
ECONNREFUSED.  In that case force a lookup of statd's new port and retry the
upcall.

Signed-off-by: Benjamin Coddington <bcodding@redhat.com>
Signed-off-by: Trond Myklebust <trond.myklebust@primarydata.com>
Signed-off-by: Zefan Li <lizefan@huawei.com>
---
 fs/lockd/mon.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/fs/lockd/mon.c b/fs/lockd/mon.c
index 606a8dd..0a68e0b 100644
--- a/fs/lockd/mon.c
+++ b/fs/lockd/mon.c
@@ -114,6 +114,12 @@ static int nsm_mon_unmon(struct nsm_handle *nsm, u32 proc, struct nsm_res *res,
 
 	msg.rpc_proc = &clnt->cl_procinfo[proc];
 	status = rpc_call_sync(clnt, &msg, 0);
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
1.9.1

