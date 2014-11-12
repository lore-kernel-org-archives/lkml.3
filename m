Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756062AbaKLEUz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2014 23:20:55 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:58419 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753027AbaKLBUl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2014 20:20:41 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Benjamin Coddington <bcodding@redhat.com>,
        Trond Myklebust <trond.myklebust@primarydata.com>
Subject: [PATCH 3.17 027/319] lockd: Try to reconnect if statd has moved
Date: Wed, 12 Nov 2014 10:12:45 +0900
Message-Id: <20141112010957.166839616@linuxfoundation.org>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <20141112010952.553519040@linuxfoundation.org>
References: <20141112010952.553519040@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Benjamin Coddington <bcodding@redhat.com>

commit 173b3afceebe76fa2205b2c8808682d5b541fe3c upstream.

If rpc.statd is restarted, upcalls to monitor hosts can fail with
ECONNREFUSED.  In that case force a lookup of statd's new port and retry the
upcall.

Signed-off-by: Benjamin Coddington <bcodding@redhat.com>
Signed-off-by: Trond Myklebust <trond.myklebust@primarydata.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/lockd/mon.c |    6 ++++++
 1 file changed, 6 insertions(+)

--- a/fs/lockd/mon.c
+++ b/fs/lockd/mon.c
@@ -159,6 +159,12 @@ static int nsm_mon_unmon(struct nsm_hand
 
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


