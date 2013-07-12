Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757887Ab3GLWvl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Jul 2013 18:51:41 -0400
Received: from smtp.outflux.net ([198.145.64.163]:57107 "EHLO smtp.outflux.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757418Ab3GLWvk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Jul 2013 18:51:40 -0400
Date: Fri, 12 Jul 2013 15:50:17 -0700
From: Kees Cook <keescook@chromium.org>
To: linux-kernel@vger.kernel.org
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
        Yinghai Lu <yinghai@kernel.org>, Seiji Aguchi <seiji.aguchi@hds.com>,
        Fenghua Yu <fenghua.yu@intel.com>, Kees Cook <keescook@chromium.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Suresh Siddha <suresh.b.siddha@intel.com>,
        PaX Team <pageexec@gmail.com>
Subject: [PATCH v3] x86: make sure IDT is page aligned
Message-ID: <20130712225017.GA5366@www.outflux.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-HELO: www.outflux.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since the IDT is referenced from a fixmap, make sure it is page aligned.
Merge with 32-bit one, since it was already aligned to deal with F00F bug.
This avoids the risk of it ever being moved in the bss and having the
mapping be offset, resulting in calling incorrect handlers.

Signed-off-by: Kees Cook <keescook@chromium.org>
Reported-by: PaX Team <pageexec@gmail.com>
Cc: stable@vger.kernel.org
---
v3:
 - merge 32-bit and 64-bit idt_table definition
v2:
 - 32-bit was already aligned
---
 arch/x86/kernel/head_64.S |    4 ----
 arch/x86/kernel/traps.c   |    7 ++-----
 2 files changed, 2 insertions(+), 9 deletions(-)

diff --git a/arch/x86/kernel/head_64.S b/arch/x86/kernel/head_64.S
index 5e4d8a8..317b8cc 100644
--- a/arch/x86/kernel/head_64.S
+++ b/arch/x86/kernel/head_64.S
@@ -514,10 +514,6 @@ ENTRY(phys_base)
 	
 	.section .bss, "aw", @nobits
 	.align L1_CACHE_BYTES
-ENTRY(idt_table)
-	.skip IDT_ENTRIES * 16
-
-	.align L1_CACHE_BYTES
 ENTRY(debug_idt_table)
 	.skip IDT_ENTRIES * 16
 
diff --git a/arch/x86/kernel/traps.c b/arch/x86/kernel/traps.c
index b0865e8..0952614 100644
--- a/arch/x86/kernel/traps.c
+++ b/arch/x86/kernel/traps.c
@@ -68,13 +68,10 @@
 #include <asm/setup.h>
 
 asmlinkage int system_call(void);
+#endif
 
-/*
- * The IDT has to be page-aligned to simplify the Pentium
- * F0 0F bug workaround.
- */
+/* The IDT has to be page-aligned to keep it aligned with its fixmap. */
 gate_desc idt_table[NR_VECTORS] __page_aligned_data = { { { { 0, 0 } } }, };
-#endif
 
 DECLARE_BITMAP(used_vectors, NR_VECTORS);
 EXPORT_SYMBOL_GPL(used_vectors);
-- 
1.7.9.5


-- 
Kees Cook
Chrome OS Security
