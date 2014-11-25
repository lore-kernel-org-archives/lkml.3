Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754240AbaKYLox (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Nov 2014 06:44:53 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:58319 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753057AbaKYKlM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Nov 2014 05:41:12 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Benjamin Coddington <bcodding@redhat.com>,
        Trond Myklebust <trond.myklebust@primarydata.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.16.y-ckt 070/254] lockd: Try to reconnect if statd has moved
Date: Tue, 25 Nov 2014 10:37:00 +0000
Message-Id: <1416912004-5928-71-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1416912004-5928-1-git-send-email-luis.henriques@canonical.com>
References: <1416912004-5928-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.16
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.16.7-ckt2 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Benjamin Coddington <bcodding@redhat.com>

commit 173b3afceebe76fa2205b2c8808682d5b541fe3c upstream.

If rpc.statd is restarted, upcalls to monitor hosts can fail with
ECONNREFUSED.  In that case force a lookup of statd's new port and retry the
upcall.

Signed-off-by: Benjamin Coddington <bcodding@redhat.com>
Signed-off-by: Trond Myklebust <trond.myklebust@primarydata.com>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
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
2.1.0

