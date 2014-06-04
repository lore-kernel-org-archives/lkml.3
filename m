Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754754AbaFDXdn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jun 2014 19:33:43 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:40922 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754071AbaFDXYJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jun 2014 19:24:09 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Mikulas Patocka <mpatocka@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        James Hogan <james.hogan@imgtec.com>
Subject: [PATCH 3.10 081/103] metag: fix memory barriers
Date: Wed,  4 Jun 2014 16:25:44 -0700
Message-Id: <20140604232549.455641610@linuxfoundation.org>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <20140604232546.704156131@linuxfoundation.org>
References: <20140604232546.704156131@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/metag/include/asm/barrier.h |    3 +++
 1 file changed, 3 insertions(+)

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


