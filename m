Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755558AbaEHTwL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 May 2014 15:52:11 -0400
Received: from mx1.redhat.com ([209.132.183.28]:7681 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755023AbaEHTwJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 May 2014 15:52:09 -0400
Date: Thu, 8 May 2014 15:51:37 -0400 (EDT)
From: Mikulas Patocka <mpatocka@redhat.com>
X-X-Sender: mpatocka@file01.intranet.prod.int.rdu2.redhat.com
To: James Hogan <james.hogan@imgtec.com>, linux-metag@vger.kernel.org
cc: linux-kernel@vger.kernel.org, Peter Zijlstra <peterz@infradead.org>
Subject: [PATCH] metag: fix memory barriers
Message-ID: <alpine.LRH.2.02.1405081546110.4346@file01.intranet.prod.int.rdu2.redhat.com>
User-Agent: Alpine 2.02 (LRH 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Volatile access doesn't really imply the compiler barrier. Volatile access
is only ordered with respect to other volatile accesses, it isn't ordered
with respect to general memory accesses. Gcc may reorder memory accesses
around volatile access, as we can see in this simple example (if we
compile it with optimization, both increments of *b will be collapsed to
just one):

void fn(volatile int *a, long *b)
{
	(*b)++;
	*a = 10;
	(*b)++;
}

Consequently, we need the compiler barrier after a write to the volatile
variable, to make sure that the compiler doesn't reorder the volatile
write with something else.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Cc: stable@vger.kernel.org

---
 arch/metag/include/asm/barrier.h |    3 +++
 1 file changed, 3 insertions(+)

Index: linux-3.15-rc4/arch/metag/include/asm/barrier.h
===================================================================
--- linux-3.15-rc4.orig/arch/metag/include/asm/barrier.h	2014-05-08 16:23:17.000000000 +0200
+++ linux-3.15-rc4/arch/metag/include/asm/barrier.h	2014-05-08 16:24:01.000000000 +0200
@@ -15,6 +15,7 @@ static inline void wr_fence(void)
 	volatile int *flushptr = (volatile int *) LINSYSEVENT_WR_FENCE;
 	barrier();
 	*flushptr = 0;
+	barrier();
 }
 
 #else /* CONFIG_METAG_META21 */
@@ -35,6 +36,7 @@ static inline void wr_fence(void)
 	*flushptr = 0;
 	*flushptr = 0;
 	*flushptr = 0;
+	barrier();
 }
 
 #endif /* !CONFIG_METAG_META21 */
@@ -68,6 +70,7 @@ static inline void fence(void)
 	volatile int *flushptr = (volatile int *) LINSYSEVENT_WR_ATOMIC_UNLOCK;
 	barrier();
 	*flushptr = 0;
+	barrier();
 }
 #define smp_mb()        fence()
 #define smp_rmb()       fence()
