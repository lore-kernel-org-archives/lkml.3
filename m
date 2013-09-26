Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753868Ab3IZRis (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Sep 2013 13:38:48 -0400
Received: from usmamail.tilera.com ([12.216.194.151]:34205 "EHLO
	USMAMAIL.TILERA.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753447Ab3IZRiq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Sep 2013 13:38:46 -0400
Message-ID: <201309261738.r8QHcGZX007708@farm-0012.internal.tilera.com>
From: Chris Metcalf <cmetcalf@tilera.com>
Date: Thu, 26 Sep 2013 13:24:53 -0400
Subject: [PATCH] tile: use a more conservative __my_cpu_offset in CONFIG_PREEMPT
To: <linux-kernel@vger.kernel.org>, Tejun Heo <tj@kernel.org>,
        Christoph Lameter <cl@linux-foundation.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>
CC: Rob Herring <rob.herring@calxeda.com>, Nicolas Pitre <nico@linaro.org>,
        Will Deacon <will.deacon@arm.com>,
        Linus Torvalds <torvalds@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It turns out the kernel relies on barrier() to force a reload of the
percpu offset value.  Since we can't easily modify the definition of
barrier() to include "tp" as an output register, we instead provide a
definition of __my_cpu_offset as extended assembly that includes a fake
stack read to hazard against barrier(), forcing gcc to know that it
must reread "tp" and recompute anything based on "tp" after a barrier.

This fixes observed hangs in the slub allocator when we are looping
on a percpu cmpxchg_double.

A similar fix for ARMv7 was made in June in change 509eb76ebf97.

Cc: stable@vger.kernel.org
Signed-off-by: Chris Metcalf <cmetcalf@tilera.com>
---
Ben Herrenschmidt offered to look into extending barrier() in some
per-architecture way, but for now this patch is the minimal thing to
fix the bug in 3.12 and earlier, so I'm planning to push it as-is.

 arch/tile/include/asm/percpu.h | 33 ++++++++++++++++++++++++++++++---
 1 file changed, 30 insertions(+), 3 deletions(-)

diff --git a/arch/tile/include/asm/percpu.h b/arch/tile/include/asm/percpu.h
index 63294f5..de121d3 100644
--- a/arch/tile/include/asm/percpu.h
+++ b/arch/tile/include/asm/percpu.h
@@ -15,9 +15,36 @@
 #ifndef _ASM_TILE_PERCPU_H
 #define _ASM_TILE_PERCPU_H
 
-register unsigned long __my_cpu_offset __asm__("tp");
-#define __my_cpu_offset __my_cpu_offset
-#define set_my_cpu_offset(tp) (__my_cpu_offset = (tp))
+register unsigned long my_cpu_offset_reg asm("tp");
+
+#ifdef CONFIG_PREEMPT
+/*
+ * For full preemption, we can't just use the register variable
+ * directly, since we need barrier() to hazard against it, causing the
+ * compiler to reload anything computed from a previous "tp" value.
+ * But we also don't want to use volatile asm, since we'd like the
+ * compiler to be able to cache the value across multiple percpu reads.
+ * So we use a fake stack read as a hazard against barrier().
+ */
+static inline unsigned long __my_cpu_offset(void)
+{
+	unsigned long tp;
+	register unsigned long *sp asm("sp");
+	asm("move %0, tp" : "=r" (tp) : "m" (*sp));
+	return tp;
+}
+#define __my_cpu_offset __my_cpu_offset()
+#else
+/*
+ * We don't need to hazard against barrier() since "tp" doesn't ever
+ * change with PREEMPT_NONE, and with PREEMPT_VOLUNTARY it only
+ * changes at function call points, at which we are already re-reading
+ * the value of "tp" due to "my_cpu_offset_reg" being a global variable.
+ */
+#define __my_cpu_offset my_cpu_offset_reg
+#endif
+
+#define set_my_cpu_offset(tp) (my_cpu_offset_reg = (tp))
 
 #include <asm-generic/percpu.h>
 
-- 
1.8.3.1

