Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754633Ab3FQRsd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Jun 2013 13:48:33 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:50639 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754446Ab3FQRfm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Jun 2013 13:35:42 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Rob Herring <rob.herring@calxeda.com>, Will Deacon <will.deacon@arm.com>,
        Russell King <rmk+kernel@arm.linux.org.uk>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 53/84] ARM: 7747/1: pcpu: ensure __my_cpu_offset cannot be re-ordered across barrier()
Date: Mon, 17 Jun 2013 10:30:57 -0700
Message-Id: <1371490288-23167-54-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1371490288-23167-1-git-send-email-kamal@canonical.com>
References: <1371490288-23167-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.3 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Will Deacon <will.deacon@arm.com>

commit 509eb76ebf9771abc9fe51859382df2571f11447 upstream.

__my_cpu_offset is non-volatile, since we want its value to be cached
when we access several per-cpu variables in a row with preemption
disabled. This means that we rely on preempt_{en,dis}able to hazard
with the operation via the barrier() macro, so that we can't end up
migrating CPUs without reloading the per-cpu offset.

Unfortunately, GCC doesn't treat a "memory" clobber on a non-volatile
asm block as a side-effect, and will happily re-order it before other
memory clobbers (including those in prempt_disable()) and cache the
value. This has been observed to break the cmpxchg logic in the slub
allocator, leading to livelock in kmem_cache_alloc in mainline kernels.

This patch adds a dummy memory input operand to __my_cpu_offset,
forcing it to be ordered with respect to the barrier() macro.

Cc: Rob Herring <rob.herring@calxeda.com>
Reviewed-by: Nicolas Pitre <nico@linaro.org>
Signed-off-by: Will Deacon <will.deacon@arm.com>
Signed-off-by: Russell King <rmk+kernel@arm.linux.org.uk>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 arch/arm/include/asm/percpu.h | 11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

diff --git a/arch/arm/include/asm/percpu.h b/arch/arm/include/asm/percpu.h
index 968c0a1..209e650 100644
--- a/arch/arm/include/asm/percpu.h
+++ b/arch/arm/include/asm/percpu.h
@@ -30,8 +30,15 @@ static inline void set_my_cpu_offset(unsigned long off)
 static inline unsigned long __my_cpu_offset(void)
 {
 	unsigned long off;
-	/* Read TPIDRPRW */
-	asm("mrc p15, 0, %0, c13, c0, 4" : "=r" (off) : : "memory");
+	register unsigned long *sp asm ("sp");
+
+	/*
+	 * Read TPIDRPRW.
+	 * We want to allow caching the value, so avoid using volatile and
+	 * instead use a fake stack read to hazard against barrier().
+	 */
+	asm("mrc p15, 0, %0, c13, c0, 4" : "=r" (off) : "Q" (*sp));
+
 	return off;
 }
 #define __my_cpu_offset __my_cpu_offset()
-- 
1.8.1.2

