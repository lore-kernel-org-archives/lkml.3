Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754402Ab3EPBIV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 May 2013 21:08:21 -0400
Received: from g1t0026.austin.hp.com ([15.216.28.33]:33164 "EHLO
	g1t0026.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752546Ab3EPBIN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 May 2013 21:08:13 -0400
From: Davidlohr Bueso <davidlohr.bueso@hp.com>
To: akpm@linux-foundation.org
Cc: torvalds@linux-foundation.org, riel@redhat.com,
        linux-kernel@vger.kernel.org, Davidlohr Bueso <davidlohr.bueso@hp.com>
Subject: [PATCH 02/11] ipc: introduce ipc object locking helpers
Date: Wed, 15 May 2013 18:08:01 -0700
Message-Id: <1368666490-29055-3-git-send-email-davidlohr.bueso@hp.com>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1368666490-29055-1-git-send-email-davidlohr.bueso@hp.com>
References: <1368666490-29055-1-git-send-email-davidlohr.bueso@hp.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Simple helpers around the (kern_ipc_perm *)->lock spinlock.

Signed-off-by: Davidlohr Bueso <davidlohr.bueso@hp.com>
---
 ipc/util.h | 20 +++++++++++++++-----
 1 file changed, 15 insertions(+), 5 deletions(-)

diff --git a/ipc/util.h b/ipc/util.h
index 2b0bdd5..da65e8a 100644
--- a/ipc/util.h
+++ b/ipc/util.h
@@ -159,23 +159,33 @@ static inline int ipc_checkid(struct kern_ipc_perm *ipcp, int uid)
 	return uid / SEQ_MULTIPLIER != ipcp->seq;
 }
 
-static inline void ipc_lock_by_ptr(struct kern_ipc_perm *perm)
+static inline void ipc_lock_object(struct kern_ipc_perm *perm)
 {
-	rcu_read_lock();
 	spin_lock(&perm->lock);
 }
 
-static inline void ipc_unlock(struct kern_ipc_perm *perm)
+static inline void ipc_unlock_object(struct kern_ipc_perm *perm)
 {
 	spin_unlock(&perm->lock);
-	rcu_read_unlock();
 }
 
-static inline void ipc_lock_object(struct kern_ipc_perm *perm)
+static inline void ipc_assert_locked_object(struct kern_ipc_perm *perm)
 {
+	assert_spin_locked(&perm->lock);
+}
+
+static inline void ipc_lock_by_ptr(struct kern_ipc_perm *perm)
+{
+	rcu_read_lock();
 	spin_lock(&perm->lock);
 }
 
+static inline void ipc_unlock(struct kern_ipc_perm *perm)
+{
+	spin_unlock(&perm->lock);
+	rcu_read_unlock();
+}
+
 struct kern_ipc_perm *ipc_lock_check(struct ipc_ids *ids, int id);
 struct kern_ipc_perm *ipc_obtain_object_check(struct ipc_ids *ids, int id);
 int ipcget(struct ipc_namespace *ns, struct ipc_ids *ids,
-- 
1.7.11.7

