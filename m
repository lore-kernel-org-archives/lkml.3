Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757313Ab3KYOGJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Nov 2013 09:06:09 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:58928 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754252Ab3KYNxr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Nov 2013 08:53:47 -0500
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "Chris Metcalf" <cmetcalf@tilera.com>
Date: Mon, 25 Nov 2013 13:44:29 +0000
Message-ID: <lsq.1385387069.735047398@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [PATCH 3.2 40/87] tile: use a more conservative __my_cpu_offset
 in CONFIG_PREEMPT
In-Reply-To: <lsq.1385387069.559528559@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.212
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.53-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Chris Metcalf <cmetcalf@tilera.com>

commit f862eefec0b68e099a9fa58d3761ffb10bad97e1 upstream.

It turns out the kernel relies on barrier() to force a reload of the
percpu offset value.  Since we can't easily modify the definition of
barrier() to include "tp" as an output register, we instead provide a
definition of __my_cpu_offset as extended assembly that includes a fake
stack read to hazard against barrier(), forcing gcc to know that it
must reread "tp" and recompute anything based on "tp" after a barrier.

This fixes observed hangs in the slub allocator when we are looping
on a percpu cmpxchg_double.

A similar fix for ARMv7 was made in June in change 509eb76ebf97.

Signed-off-by: Chris Metcalf <cmetcalf@tilera.com>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 arch/tile/include/asm/percpu.h | 34 +++++++++++++++++++++++++++++++---
 1 file changed, 31 insertions(+), 3 deletions(-)

--- a/arch/tile/include/asm/percpu.h
+++ b/arch/tile/include/asm/percpu.h
@@ -15,9 +15,37 @@
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
+ * The 'U' constraint is like 'm' but disallows postincrement.
+ */
+static inline unsigned long __my_cpu_offset(void)
+{
+	unsigned long tp;
+	register unsigned long *sp asm("sp");
+	asm("move %0, tp" : "=r" (tp) : "U" (*sp));
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
 

