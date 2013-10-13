Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754780Ab3JMMCY (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Oct 2013 08:02:24 -0400
Received: from terminus.zytor.com ([198.137.202.10]:43731 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754667Ab3JMMCS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Oct 2013 08:02:18 -0400
Date: Sun, 13 Oct 2013 05:02:06 -0700
From: tip-bot for Kees Cook <tipbot@zytor.com>
Message-ID: <tip-6145cfe394a7f138f6b64491c5663f97dba12450@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        keescook@chromium.org, tglx@linutronix.de, hpa@linux.intel.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        keescook@chromium.org, tglx@linutronix.de, hpa@linux.intel.com
In-Reply-To: <1381450698-28710-7-git-send-email-keescook@chromium.org>
References: <1381450698-28710-7-git-send-email-keescook@chromium.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/kaslr] x86, kaslr:
  Raise the maximum virtual address to -1 GiB on x86_64
Git-Commit-ID: 6145cfe394a7f138f6b64491c5663f97dba12450
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.1 (terminus.zytor.com [127.0.0.1]); Sun, 13 Oct 2013 05:02:13 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  6145cfe394a7f138f6b64491c5663f97dba12450
Gitweb:     http://git.kernel.org/tip/6145cfe394a7f138f6b64491c5663f97dba12450
Author:     Kees Cook <keescook@chromium.org>
AuthorDate: Thu, 10 Oct 2013 17:18:18 -0700
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Sun, 13 Oct 2013 03:13:13 -0700

x86, kaslr: Raise the maximum virtual address to -1 GiB on x86_64

On 64-bit, this raises the maximum location to -1 GiB (from -1.5 GiB),
the upper limit currently, since the kernel fixmap page mappings need
to be moved to use the other 1 GiB (which would be the theoretical
limit when building with -mcmodel=kernel).

Signed-off-by: Kees Cook <keescook@chromium.org>
Link: http://lkml.kernel.org/r/1381450698-28710-7-git-send-email-keescook@chromium.org
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
---
 arch/x86/Kconfig                        | 16 +++++++++++++---
 arch/x86/include/asm/page_64_types.h    | 15 ++++++++++++---
 arch/x86/include/asm/pgtable_64_types.h |  2 +-
 arch/x86/mm/init_32.c                   |  3 +++
 4 files changed, 29 insertions(+), 7 deletions(-)

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index 992701d..51f4399 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -1746,13 +1746,23 @@ config RANDOMIZE_BASE
 config RANDOMIZE_BASE_MAX_OFFSET
 	hex "Maximum ASLR offset allowed"
 	depends on RANDOMIZE_BASE
-	default "0x10000000"
-	range 0x0 0x10000000
+	range 0x0 0x20000000 if X86_32
+	default "0x20000000" if X86_32
+	range 0x0 0x40000000 if X86_64
+	default "0x40000000" if X86_64
 	---help---
 	 Determines the maximal offset in bytes that will be applied to the
 	 kernel when Address Space Layout Randomization (ASLR) is active.
 	 Must be less than or equal to the actual physical memory on the
-	 system. This must be a power of two.
+	 system. This must be a multiple of CONFIG_PHYSICAL_ALIGN.
+
+	 On 32-bit this is limited to 512MiB.
+
+	 On 64-bit this is limited by how the kernel fixmap page table is
+	 positioned, so this cannot be larger that 1GiB currently. Normally
+	 there is a 512MiB to 1.5GiB split between kernel and modules. When
+	 this is raised above the 512MiB default, the modules area will
+	 shrink to compensate, up to the current maximum 1GiB to 1GiB split.
 
 # Relocation on x86 needs some additional build support
 config X86_NEED_RELOCS
diff --git a/arch/x86/include/asm/page_64_types.h b/arch/x86/include/asm/page_64_types.h
index 43dcd80..8de6d9c 100644
--- a/arch/x86/include/asm/page_64_types.h
+++ b/arch/x86/include/asm/page_64_types.h
@@ -39,9 +39,18 @@
 #define __VIRTUAL_MASK_SHIFT	47
 
 /*
- * Kernel image size is limited to 512 MB (see level2_kernel_pgt in
- * arch/x86/kernel/head_64.S), and it is mapped here:
+ * Kernel image size is limited to 1GiB due to the fixmap living in the
+ * next 1GiB (see level2_kernel_pgt in arch/x86/kernel/head_64.S). Use
+ * 512MiB by default, leaving 1.5GiB for modules once the page tables
+ * are fully set up. If kernel ASLR is configured, it can extend the
+ * kernel page table mapping, reducing the size of the modules area.
  */
-#define KERNEL_IMAGE_SIZE	(512 * 1024 * 1024)
+#define KERNEL_IMAGE_SIZE_DEFAULT      (512 * 1024 * 1024)
+#if defined(CONFIG_RANDOMIZE_BASE) && \
+	CONFIG_RANDOMIZE_BASE_MAX_OFFSET > KERNEL_IMAGE_SIZE_DEFAULT
+#define KERNEL_IMAGE_SIZE   CONFIG_RANDOMIZE_BASE_MAX_OFFSET
+#else
+#define KERNEL_IMAGE_SIZE      KERNEL_IMAGE_SIZE_DEFAULT
+#endif
 
 #endif /* _ASM_X86_PAGE_64_DEFS_H */
diff --git a/arch/x86/include/asm/pgtable_64_types.h b/arch/x86/include/asm/pgtable_64_types.h
index 2d88344..c883bf7 100644
--- a/arch/x86/include/asm/pgtable_64_types.h
+++ b/arch/x86/include/asm/pgtable_64_types.h
@@ -58,7 +58,7 @@ typedef struct { pteval_t pte; } pte_t;
 #define VMALLOC_START    _AC(0xffffc90000000000, UL)
 #define VMALLOC_END      _AC(0xffffe8ffffffffff, UL)
 #define VMEMMAP_START	 _AC(0xffffea0000000000, UL)
-#define MODULES_VADDR    _AC(0xffffffffa0000000, UL)
+#define MODULES_VADDR    (__START_KERNEL_map + KERNEL_IMAGE_SIZE)
 #define MODULES_END      _AC(0xffffffffff000000, UL)
 #define MODULES_LEN   (MODULES_END - MODULES_VADDR)
 
diff --git a/arch/x86/mm/init_32.c b/arch/x86/mm/init_32.c
index 4287f1f..5bdc543 100644
--- a/arch/x86/mm/init_32.c
+++ b/arch/x86/mm/init_32.c
@@ -806,6 +806,9 @@ void __init mem_init(void)
 	BUILD_BUG_ON(VMALLOC_START			>= VMALLOC_END);
 #undef high_memory
 #undef __FIXADDR_TOP
+#ifdef CONFIG_RANDOMIZE_BASE
+	BUILD_BUG_ON(CONFIG_RANDOMIZE_BASE_MAX_OFFSET > KERNEL_IMAGE_SIZE);
+#endif
 
 #ifdef CONFIG_HIGHMEM
 	BUG_ON(PKMAP_BASE + LAST_PKMAP*PAGE_SIZE	> FIXADDR_START);
