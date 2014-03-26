Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753253AbaCZKMY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Mar 2014 06:12:24 -0400
Received: from mailout3.w1.samsung.com ([210.118.77.13]:26396 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750792AbaCZKMW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Mar 2014 06:12:22 -0400
X-AuditID: cbfec7f4-b7f796d000005a13-e5-5332a803a1f2
Subject: [PATCH < v3.10] ipc/msg: fix race around refcount
To: linux-kernel@vger.kernel.org
From: Konstantin Khlebnikov <k.khlebnikov@samsung.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, stable@vger.kernel.org
Date: Wed, 26 Mar 2014 14:12:19 +0400
Message-id: <20140326101218.11221.74072.stgit@buzz>
User-Agent: StGit/0.15
MIME-version: 1.0
Content-type: text/plain; charset=utf-8
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFupiluLIzCtJLcpLzFFi42I5/e/4NV3mFUbBBvc3aljMWb+GzeLHzl5W
	i8u75rBZLNj4iNGBxePEjN8sHn1bVjF6fN4kF8AcxWWTkpqTWZZapG+XwJXx5phnwXe+ip97
	NrM1MC7k6WLk5JAQMJGYcGkHG4QtJnHh3nogm4tDSGApo8T9r6uZIZxGJonPt94wglQJC1hJ
	zHtygQnEFhFQkNjc+4wVxGYTMJPYtu82WA2zgKvEyp+PwWwWAVWJo6s/s4DYvALGEtfvLwLb
	Jgq0bc2lk0wQcUGJH5PvAdVwAPWqS0yZkgsxRl5i85q3zBMY+WYhqZqFUDULSdUCRuZVjKKp
	pckFxUnpuYZ6xYm5xaV56XrJ+bmbGCHh92UH4+JjVocYBTgYlXh4LfoMg4VYE8uKK3MPMUpw
	MCuJ8AY3GwUL8aYkVlalFuXHF5XmpBYfYmTi4JRqYGyrULa8uHJeqY+Y/d4dhxlebdr28vzU
	yMXaU0IZTf+t21Qze6vXoRuzU9PcEi6cLBR89Vl+x7lOAW5OBaGDLd3fMg7asd2qa7Epktgv
	v2nrlCW7o98t1Wh4Hv5bvC031P1a1LSnorqz9s/fxHh486KbBlmPzq/RvM71UuyGzCKuhKKM
	RRNY9n5RYinOSDTUYi4qTgQArjOe/h0CAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

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
---
 ipc/msg.c |    2 ++
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

