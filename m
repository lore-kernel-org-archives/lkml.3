Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754819AbaDFXkK (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Apr 2014 19:40:10 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:59487 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754750AbaDFXjI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Apr 2014 19:39:08 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org,
        "Konstantin Khlebnikov" <k.khlebnikov@samsung.com>
Date: Mon, 07 Apr 2014 00:35:48 +0100
Message-ID: <lsq.1396827348.345065834@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [PATCH 3.2 06/18] ipc/msg: fix race around refcount
In-Reply-To: <lsq.1396827347.462803115@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.2.102
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.57-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Konstantin Khlebnikov <k.khlebnikov@samsung.com>

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
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 ipc/msg.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/ipc/msg.c
+++ b/ipc/msg.c
@@ -296,7 +296,9 @@ static void freeque(struct ipc_namespace
 	}
 	atomic_sub(msq->q_cbytes, &ns->msg_bytes);
 	security_msg_queue_free(msq);
+	ipc_lock_by_ptr(&msq->q_perm);
 	ipc_rcu_putref(msq);
+	ipc_unlock(&msq->q_perm);
 }
 
 /*

