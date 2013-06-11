Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756629Ab3FKUDu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Jun 2013 16:03:50 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:41886 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756610Ab3FKUDs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Jun 2013 16:03:48 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Nicolas Pitre <nico@linaro.org>, Rob Herring <rob.herring@calxeda.com>,
        Will Deacon <will.deacon@arm.com>,
        Russell King <rmk+kernel@arm.linux.org.uk>
Subject: [ 41/79] ARM: 7747/1: pcpu: ensure __my_cpu_offset cannot be re-ordered across barrier()
Date: Tue, 11 Jun 2013 13:03:07 -0700
Message-Id: <20130611195321.311576154@linuxfoundation.org>
X-Mailer: git-send-email 1.8.3.254.g5578ad7
In-Reply-To: <20130611195312.352656079@linuxfoundation.org>
References: <20130611195312.352656079@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.9-stable review patch.  If anyone has any objections, please let me know.

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

Reviewed-by: Nicolas Pitre <nico@linaro.org>
Cc: Rob Herring <rob.herring@calxeda.com>
Signed-off-by: Will Deacon <will.deacon@arm.com>
Signed-off-by: Russell King <rmk+kernel@arm.linux.org.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/arm/include/asm/percpu.h |   11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

--- a/arch/arm/include/asm/percpu.h
+++ b/arch/arm/include/asm/percpu.h
@@ -30,8 +30,15 @@ static inline void set_my_cpu_offset(uns
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


