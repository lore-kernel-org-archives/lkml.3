Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936581AbaFIJdT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jun 2014 05:33:19 -0400
Received: from ip4-83-240-18-248.cust.nbox.cz ([83.240.18.248]:59137 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S936263AbaFIJ1G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jun 2014 05:27:06 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Mikulas Patocka <mpatocka@redhat.com>,
        James Hogan <james.hogan@imgtec.com>, Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 110/146] metag: fix memory barriers
Date: Mon,  9 Jun 2014 10:50:45 +0200
Message-Id: <2578456a5961b2976892a51a165dab44b1114921.1402303821.git.jslaby@suse.cz>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <ebe219e45dcf94c1a34281167427cff4d742faef.1402303820.git.jslaby@suse.cz>
References: <ebe219e45dcf94c1a34281167427cff4d742faef.1402303820.git.jslaby@suse.cz>
In-Reply-To: <cover.1402303820.git.jslaby@suse.cz>
References: <cover.1402303820.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mikulas Patocka <mpatocka@redhat.com>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

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
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
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
1.9.3

