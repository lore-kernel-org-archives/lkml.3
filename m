Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933471Ab3GPSfm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jul 2013 14:35:42 -0400
Received: from smtp.outflux.net ([198.145.64.163]:37016 "EHLO smtp.outflux.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933000Ab3GPSfl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jul 2013 14:35:41 -0400
Date: Tue, 16 Jul 2013 11:34:41 -0700
From: Kees Cook <keescook@chromium.org>
To: linux-kernel@vger.kernel.org
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
        Yinghai Lu <yinghai@kernel.org>, Seiji Aguchi <seiji.aguchi@hds.com>,
        Fenghua Yu <fenghua.yu@intel.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Suresh Siddha <suresh.b.siddha@intel.com>,
        PaX Team <pageexec@gmail.com>
Subject: [PATCH v5] x86: make sure IDT is page aligned
Message-ID: <20130716183441.GA14232@www.outflux.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-HELO: www.outflux.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since the IDT is referenced from a fixmap, make sure it is page aligned.
Merge with 32-bit one, since it was already aligned to deal with F00F
bug. Since bss is cleared before IDT setup, it can live there. This also
moves the other *_idt_table variables into common locations.

This avoids the risk of the IDT ever being moved in the bss and having
the mapping be offset, resulting in calling incorrect handlers. In the
current upstream kernel this is not a manifested bug, but heavily patched
kernels (such as those using the PaX patch series) did encounter this bug.

Signed-off-by: Kees Cook <keescook@chromium.org>
Reported-by: PaX Team <pageexec@gmail.com>
---
v5:
 - add comments to all IDTs about alignment reasoning, suggested by Linus
v4:
 - rework using __page_aligned_bss, suggested by Yinghai LU
 - move all the other IDT variables as well, suggested by HPA
v3:
 - merge 32-bit and 64-bit idt_table definition
v2:
 - 32-bit was already aligned
---
 arch/x86/kernel/head_64.S    |   15 ---------------
 arch/x86/kernel/tracepoint.c |    6 ++----
 arch/x86/kernel/traps.c      |   12 ++++++------
 3 files changed, 8 insertions(+), 25 deletions(-)

diff --git a/arch/x86/kernel/head_64.S b/arch/x86/kernel/head_64.S
index 5e4d8a8..e1aabdb 100644
--- a/arch/x86/kernel/head_64.S
+++ b/arch/x86/kernel/head_64.S
@@ -512,21 +512,6 @@ ENTRY(phys_base)
 
 #include "../../x86/xen/xen-head.S"
 	
-	.section .bss, "aw", @nobits
-	.align L1_CACHE_BYTES
-ENTRY(idt_table)
-	.skip IDT_ENTRIES * 16
-
-	.align L1_CACHE_BYTES
-ENTRY(debug_idt_table)
-	.skip IDT_ENTRIES * 16
-
-#ifdef CONFIG_TRACING
-	.align L1_CACHE_BYTES
-ENTRY(trace_idt_table)
-	.skip IDT_ENTRIES * 16
-#endif
-
 	__PAGE_ALIGNED_BSS
 NEXT_PAGE(empty_zero_page)
 	.skip PAGE_SIZE
diff --git a/arch/x86/kernel/tracepoint.c b/arch/x86/kernel/tracepoint.c
index 4e584a8..1c113db 100644
--- a/arch/x86/kernel/tracepoint.c
+++ b/arch/x86/kernel/tracepoint.c
@@ -12,10 +12,8 @@ atomic_t trace_idt_ctr = ATOMIC_INIT(0);
 struct desc_ptr trace_idt_descr = { NR_VECTORS * 16 - 1,
 				(unsigned long) trace_idt_table };
 
-#ifndef CONFIG_X86_64
-gate_desc trace_idt_table[NR_VECTORS] __page_aligned_data
-					= { { { { 0, 0 } } }, };
-#endif
+/* No need to be aligned, but done to keep all IDTs defined the same way. */
+gate_desc trace_idt_table[NR_VECTORS] __page_aligned_bss;
 
 static int trace_irq_vector_refcount;
 static DEFINE_MUTEX(irq_vector_mutex);
diff --git a/arch/x86/kernel/traps.c b/arch/x86/kernel/traps.c
index b0865e8..1b23a1c 100644
--- a/arch/x86/kernel/traps.c
+++ b/arch/x86/kernel/traps.c
@@ -63,19 +63,19 @@
 #include <asm/x86_init.h>
 #include <asm/pgalloc.h>
 #include <asm/proto.h>
+
+/* No need to be aligned, but done to keep all IDTs defined the same way. */
+gate_desc debug_idt_table[NR_VECTORS] __page_aligned_bss;
 #else
 #include <asm/processor-flags.h>
 #include <asm/setup.h>
 
 asmlinkage int system_call(void);
-
-/*
- * The IDT has to be page-aligned to simplify the Pentium
- * F0 0F bug workaround.
- */
-gate_desc idt_table[NR_VECTORS] __page_aligned_data = { { { { 0, 0 } } }, };
 #endif
 
+/* Must be page-aligned because the real IDT is used in a fixmap. */
+gate_desc idt_table[NR_VECTORS] __page_aligned_bss;
+
 DECLARE_BITMAP(used_vectors, NR_VECTORS);
 EXPORT_SYMBOL_GPL(used_vectors);
 
-- 
1.7.9.5


-- 
Kees Cook
Chrome OS Security
