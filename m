Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754227Ab3FJRSj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Jun 2013 13:18:39 -0400
Received: from mail-bk0-f49.google.com ([209.85.214.49]:59115 "EHLO
	mail-bk0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752023Ab3FJRRS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Jun 2013 13:17:18 -0400
From: Manfred Spraul <manfred@colorfullife.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Rik van Riel <riel@redhat.com>,
        Davidlohr Bueso <davidlohr.bueso@hp.com>, hhuang@redhat.com,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Mike Galbraith <efault@gmx.de>,
        Manfred Spraul <manfred@colorfullife.com>
Subject: [PATCH 1/6] ipc/util.c, ipc_rcu_alloc: cacheline align allocation
Date: Mon, 10 Jun 2013 19:16:46 +0200
Message-Id: <1370884611-3861-2-git-send-email-manfred@colorfullife.com>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1370884611-3861-1-git-send-email-manfred@colorfullife.com>
References: <1370884611-3861-1-git-send-email-manfred@colorfullife.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Enforce that ipc_rcu_alloc returns a cacheline aligned pointer on SMP.

Rational:
The SysV sem code tries to move the main spinlock into a seperate cacheline
(____cacheline_aligned_in_smp). This works only if ipc_rcu_alloc returns
cacheline aligned pointers.
vmalloc and kmalloc return cacheline algined pointers, the implementation
of ipc_rcu_alloc breaks that.

Andrew: Could you merge it into -akpm and then forward it towards Linus' tree?

Signed-off-by: Manfred Spraul <manfred@colorfullife.com>
---
 ipc/util.c | 13 +++++++------
 1 file changed, 7 insertions(+), 6 deletions(-)

diff --git a/ipc/util.c b/ipc/util.c
index 809ec5e..9623c8e 100644
--- a/ipc/util.c
+++ b/ipc/util.c
@@ -469,9 +469,7 @@ void ipc_free(void* ptr, int size)
 struct ipc_rcu {
 	struct rcu_head rcu;
 	atomic_t refcount;
-	/* "void *" makes sure alignment of following data is sane. */
-	void *data[0];
-};
+} ____cacheline_aligned_in_smp;
 
 /**
  *	ipc_rcu_alloc	-	allocate ipc and rcu space 
@@ -489,12 +487,14 @@ void *ipc_rcu_alloc(int size)
 	if (unlikely(!out))
 		return NULL;
 	atomic_set(&out->refcount, 1);
-	return out->data;
+	return out+1;
 }
 
 int ipc_rcu_getref(void *ptr)
 {
-	return atomic_inc_not_zero(&container_of(ptr, struct ipc_rcu, data)->refcount);
+	struct ipc_rcu *p = ((struct ipc_rcu*)ptr)-1;
+
+	return atomic_inc_not_zero(&p->refcount);
 }
 
 /**
@@ -508,7 +508,7 @@ static void ipc_schedule_free(struct rcu_head *head)
 
 void ipc_rcu_putref(void *ptr)
 {
-	struct ipc_rcu *p = container_of(ptr, struct ipc_rcu, data);
+	struct ipc_rcu *p = ((struct ipc_rcu*)ptr)-1;
 
 	if (!atomic_dec_and_test(&p->refcount))
 		return;
-- 
1.8.1.4

