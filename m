Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932842AbaFCMBD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jun 2014 08:01:03 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:43615 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932746AbaFCLlv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jun 2014 07:41:51 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Mikulas Patocka <mpatocka@redhat.com>,
        James Hogan <james.hogan@imgtec.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 079/138] metag: fix memory barriers
Date: Tue,  3 Jun 2014 12:38:45 +0100
Message-Id: <1401795584-22664-80-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1401795584-22664-1-git-send-email-luis.henriques@canonical.com>
References: <1401795584-22664-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.11 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mikulas Patocka <mpatocka@redhat.com>

commit 2425ce84026c385b73ae72039f90d042d49e0394 upstream.

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
Acked-by: Peter Zijlstra <peterz@infradead.org>
Signed-off-by: James Hogan <james.hogan@imgtec.com>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 arch/metag/include/asm/barrier.h | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/arch/metag/include/asm/barrier.h b/arch/metag/include/asm/barrier.h
index c90bfc6bf648..e355a4c10968 100644
--- a/arch/metag/include/asm/barrier.h
+++ b/arch/metag/include/asm/barrier.h
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
-- 
1.9.1

