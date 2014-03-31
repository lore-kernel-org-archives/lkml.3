Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754332AbaCaNYp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Mar 2014 09:24:45 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:35785 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754288AbaCaNYk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Mar 2014 09:24:40 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Konstantin Khlebnikov <k.khlebnikov@samsung.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.5 55/71] ipc/msg: fix race around refcount
Date: Mon, 31 Mar 2014 14:23:01 +0100
Message-Id: <1396272197-13394-56-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1396272197-13394-1-git-send-email-luis.henriques@canonical.com>
References: <1396272197-13394-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.33 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Konstantin Khlebnikov <k.khlebnikov@samsung.com>

[fixed differently in 6062a8dc0517bce23e3c2f7d2fea5e22411269a3 upstream.]

In older kernels (before v3.10) ipc_rcu_hdr->refcount was non-atomic int.
There was possuble double-free bug: do_msgsnd() calls ipc_rcu_putref() under
msq->q_perm->lock and RCU, while freequeue() calls it while it holds only
'rw_mutex', so there is no sinchronization between them. Two function
decrements '2' non-atomically, they both can get '0' as result.

do_msgsnd()					freequeue()

msq = msg_lock_check(ns, msqid);
...
ipc_rcu_getref(msq);
msg_unlock(msq);
schedule();
						(caller locks spinlock)
						expunge_all(msq, -EIDRM);
						ss_wakeup(&msq->q_senders, 1);
						msg_rmid(ns, msq);
						msg_unlock(msq);
ipc_lock_by_ptr(&msq->q_perm);
ipc_rcu_putref(msq);				ipc_rcu_putref(msq);
< both may get get --(...)->refcount == 0 >

This patch locks ipc_lock and RCU around ipc_rcu_putref in freequeue.
( RCU protects memory for spin_unlock() )

Similar bugs might be in other users of ipc_rcu_putref().

In the mainline this has been fixed in v3.10 indirectly in commmit
6062a8dc0517bce23e3c2f7d2fea5e22411269a3
("ipc,sem: fine grained locking for semtimedop") by Rik van Riel.
That commit optimized locking and converted refcount into atomic.

I'm not sure that anybody should care about this bug: it's very-very unlikely
and no longer exists in actual mainline. I've found this just by looking into
the code, probably this never happens in real life.

Signed-off-by: Konstantin Khlebnikov <k.khlebnikov@samsung.com>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 ipc/msg.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/ipc/msg.c b/ipc/msg.c
index 7385de2..25f1a61 100644
--- a/ipc/msg.c
+++ b/ipc/msg.c
@@ -296,7 +296,9 @@ static void freeque(struct ipc_namespace *ns, struct kern_ipc_perm *ipcp)
 	}
 	atomic_sub(msq->q_cbytes, &ns->msg_bytes);
 	security_msg_queue_free(msq);
+	ipc_lock_by_ptr(&msq->q_perm);
 	ipc_rcu_putref(msq);
+	ipc_unlock(&msq->q_perm);
 }
 
 /*
-- 
1.9.1

