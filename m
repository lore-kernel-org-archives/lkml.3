Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754299Ab3GVBV4 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Jul 2013 21:21:56 -0400
Received: from g1t0029.austin.hp.com ([15.216.28.36]:18764 "EHLO
	g1t0029.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752964Ab3GVBVy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Jul 2013 21:21:54 -0400
From: Davidlohr Bueso <davidlohr.bueso@hp.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Davidlohr Bueso <davidlohr.bueso@hp.com>
Subject: [PATCH 2/4] ipc: drop ipc_lock_by_ptr
Date: Sun, 21 Jul 2013 18:21:41 -0700
Message-Id: <1374456103-25353-3-git-send-email-davidlohr.bueso@hp.com>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1374456103-25353-1-git-send-email-davidlohr.bueso@hp.com>
References: <1374456103-25353-1-git-send-email-davidlohr.bueso@hp.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

After previous cleanups and optimizations, this function is no longer
heavily used and we don't have a good reason to keep it. Update the
few remaining callers and get rid of it.

Signed-off-by: Davidlohr Bueso <davidlohr.bueso@hp.com>
---
 ipc/namespace.c | 3 ++-
 ipc/util.c      | 6 ++++--
 ipc/util.h      | 6 ------
 3 files changed, 6 insertions(+), 9 deletions(-)

diff --git a/ipc/namespace.c b/ipc/namespace.c
index 67dc744..aba9a58 100644
--- a/ipc/namespace.c
+++ b/ipc/namespace.c
@@ -89,7 +89,8 @@ void free_ipcs(struct ipc_namespace *ns, struct ipc_ids *ids,
 		perm = idr_find(&ids->ipcs_idr, next_id);
 		if (perm == NULL)
 			continue;
-		ipc_lock_by_ptr(perm);
+		rcu_read_lock();
+		ipc_lock_object(perm);
 		free(ns, perm);
 		total++;
 	}
diff --git a/ipc/util.c b/ipc/util.c
index 1ddadcf..9f6aa30 100644
--- a/ipc/util.c
+++ b/ipc/util.c
@@ -205,7 +205,8 @@ static struct kern_ipc_perm *ipc_findkey(struct ipc_ids *ids, key_t key)
 			continue;
 		}
 
-		ipc_lock_by_ptr(ipc);
+		rcu_read_lock();
+		ipc_lock_object(ipc);
 		return ipc;
 	}
 
@@ -838,7 +839,8 @@ static struct kern_ipc_perm *sysvipc_find_ipc(struct ipc_ids *ids, loff_t pos,
 		ipc = idr_find(&ids->ipcs_idr, pos);
 		if (ipc != NULL) {
 			*new_pos = pos + 1;
-			ipc_lock_by_ptr(ipc);
+			rcu_read_lock();
+			ipc_lock_object(ipc);
 			return ipc;
 		}
 	}
diff --git a/ipc/util.h b/ipc/util.h
index 0a362ff..14b0a2a 100644
--- a/ipc/util.h
+++ b/ipc/util.h
@@ -171,12 +171,6 @@ static inline void ipc_assert_locked_object(struct kern_ipc_perm *perm)
 	assert_spin_locked(&perm->lock);
 }
 
-static inline void ipc_lock_by_ptr(struct kern_ipc_perm *perm)
-{
-	rcu_read_lock();
-	ipc_lock_object(perm);
-}
-
 static inline void ipc_unlock(struct kern_ipc_perm *perm)
 {
 	ipc_unlock_object(perm);
-- 
1.7.11.7

