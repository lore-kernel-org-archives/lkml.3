Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754848Ab3HPOhN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Aug 2013 10:37:13 -0400
Received: from relay2.sgi.com ([192.48.179.30]:50747 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752261Ab3HPOed (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Aug 2013 10:34:33 -0400
From: Alex Thorlton <athorlton@sgi.com>
To: linux-kernel@vger.kernel.org
Cc: Alex Thorlton <athorlton@sgi.com>, Ingo Molnar <mingo@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Mel Gorman <mgorman@suse.de>,
        "Kirill A . Shutemov" <kirill.shutemov@linux.intel.com>,
        Rik van Riel <riel@redhat.com>, Johannes Weiner <hannes@cmpxchg.org>,
        "Eric W . Biederman" <ebiederm@xmission.com>,
        Sedat Dilek <sedat.dilek@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Dave Jones <davej@redhat.com>,
        Michael Kerrisk <mtk.manpages@gmail.com>,
        "Paul E . McKenney" <paulmck@linux.vnet.ibm.com>,
        David Howells <dhowells@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Al Viro <viro@zeniv.linux.org.uk>, Oleg Nesterov <oleg@redhat.com>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Kees Cook <keescook@chromium.org>, Robin Holt <holt@sgi.com>
Subject: [PATCH 4/8] x86: Add clear_page_nocache
Date: Fri, 16 Aug 2013 09:34:00 -0500
Message-Id: <1376663644-153546-5-git-send-email-athorlton@sgi.com>
X-Mailer: git-send-email 1.7.12.4
In-Reply-To: <1376663644-153546-1-git-send-email-athorlton@sgi.com>
References: <87wqo050fc.fsf@tassilo.jf.intel.com>
 <1376663644-153546-1-git-send-email-athorlton@sgi.com>
In-Reply-To: <87wqo050fc.fsf@tassilo.jf.intel.com>
References: <87wqo050fc.fsf@tassilo.jf.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Conflicts:
	arch/x86/mm/fault.c
---
 arch/x86/include/asm/page.h          |  2 ++
 arch/x86/include/asm/string_32.h     |  5 +++++
 arch/x86/include/asm/string_64.h     |  5 +++++
 arch/x86/lib/Makefile                |  1 +
 arch/x86/lib/clear_page_nocache_32.S | 30 ++++++++++++++++++++++++++++++
 arch/x86/lib/clear_page_nocache_64.S | 29 +++++++++++++++++++++++++++++
 arch/x86/mm/fault.c                  |  7 +++++++
 7 files changed, 79 insertions(+)
 create mode 100644 arch/x86/lib/clear_page_nocache_32.S
 create mode 100644 arch/x86/lib/clear_page_nocache_64.S

diff --git a/arch/x86/include/asm/page.h b/arch/x86/include/asm/page.h
index c878924..ccec9c3 100644
--- a/arch/x86/include/asm/page.h
+++ b/arch/x86/include/asm/page.h
@@ -33,6 +33,8 @@ static inline void copy_user_page(void *to, void *from, unsigned long vaddr,
 	copy_page(to, from);
 }
 
+void clear_user_highpage_nocache(struct page *page, unsigned long vaddr);
+
 #define __alloc_zeroed_user_highpage(movableflags, vma, vaddr) \
 	alloc_page_vma(GFP_HIGHUSER | __GFP_ZERO | movableflags, vma, vaddr)
 #define __HAVE_ARCH_ALLOC_ZEROED_USER_HIGHPAGE
diff --git a/arch/x86/include/asm/string_32.h b/arch/x86/include/asm/string_32.h
index 3d3e835..3f2fbcf 100644
--- a/arch/x86/include/asm/string_32.h
+++ b/arch/x86/include/asm/string_32.h
@@ -3,6 +3,8 @@
 
 #ifdef __KERNEL__
 
+#include <linux/linkage.h>
+
 /* Let gcc decide whether to inline or use the out of line functions */
 
 #define __HAVE_ARCH_STRCPY
@@ -337,6 +339,9 @@ void *__constant_c_and_count_memset(void *s, unsigned long pattern,
 #define __HAVE_ARCH_MEMSCAN
 extern void *memscan(void *addr, int c, size_t size);
 
+#define ARCH_HAS_USER_NOCACHE 1
+asmlinkage void clear_page_nocache(void *page);
+
 #endif /* __KERNEL__ */
 
 #endif /* _ASM_X86_STRING_32_H */
diff --git a/arch/x86/include/asm/string_64.h b/arch/x86/include/asm/string_64.h
index 19e2c46..ca23d1d 100644
--- a/arch/x86/include/asm/string_64.h
+++ b/arch/x86/include/asm/string_64.h
@@ -3,6 +3,8 @@
 
 #ifdef __KERNEL__
 
+#include <linux/linkage.h>
+
 /* Written 2002 by Andi Kleen */
 
 /* Only used for special circumstances. Stolen from i386/string.h */
@@ -63,6 +65,9 @@ char *strcpy(char *dest, const char *src);
 char *strcat(char *dest, const char *src);
 int strcmp(const char *cs, const char *ct);
 
+#define ARCH_HAS_USER_NOCACHE 1
+asmlinkage void clear_page_nocache(void *page);
+
 #endif /* __KERNEL__ */
 
 #endif /* _ASM_X86_STRING_64_H */
diff --git a/arch/x86/lib/Makefile b/arch/x86/lib/Makefile
index 96b2c66..e48776c 100644
--- a/arch/x86/lib/Makefile
+++ b/arch/x86/lib/Makefile
@@ -23,6 +23,7 @@ lib-y += memcpy_$(BITS).o
 lib-$(CONFIG_SMP) += rwlock.o
 lib-$(CONFIG_RWSEM_XCHGADD_ALGORITHM) += rwsem.o
 lib-$(CONFIG_INSTRUCTION_DECODER) += insn.o inat.o
+lib-y += clear_page_nocache_$(BITS).o
 
 obj-y += msr.o msr-reg.o msr-reg-export.o
 
diff --git a/arch/x86/lib/clear_page_nocache_32.S b/arch/x86/lib/clear_page_nocache_32.S
new file mode 100644
index 0000000..2394e0c
--- /dev/null
+++ b/arch/x86/lib/clear_page_nocache_32.S
@@ -0,0 +1,30 @@
+#include <linux/linkage.h>
+#include <asm/dwarf2.h>
+
+/*
+ * Zero a page avoiding the caches
+ * rdi	page
+ */
+ENTRY(clear_page_nocache)
+	CFI_STARTPROC
+	mov    %eax,%edi
+	xorl   %eax,%eax
+	movl   $4096/64,%ecx
+	.p2align 4
+.Lloop:
+	decl	%ecx
+#define PUT(x) movnti %eax,x*8(%edi) ; movnti %eax,x*8+4(%edi)
+	PUT(0)
+	PUT(1)
+	PUT(2)
+	PUT(3)
+	PUT(4)
+	PUT(5)
+	PUT(6)
+	PUT(7)
+	lea	64(%edi),%edi
+	jnz	.Lloop
+	nop
+	ret
+	CFI_ENDPROC
+ENDPROC(clear_page_nocache)
diff --git a/arch/x86/lib/clear_page_nocache_64.S b/arch/x86/lib/clear_page_nocache_64.S
new file mode 100644
index 0000000..ee16d15
--- /dev/null
+++ b/arch/x86/lib/clear_page_nocache_64.S
@@ -0,0 +1,29 @@
+#include <linux/linkage.h>
+#include <asm/dwarf2.h>
+
+/*
+ * Zero a page avoiding the caches
+ * rdi	page
+ */
+ENTRY(clear_page_nocache)
+	CFI_STARTPROC
+	xorl   %eax,%eax
+	movl   $4096/64,%ecx
+	.p2align 4
+.Lloop:
+	decl	%ecx
+#define PUT(x) movnti %rax,x*8(%rdi)
+	movnti %rax,(%rdi)
+	PUT(1)
+	PUT(2)
+	PUT(3)
+	PUT(4)
+	PUT(5)
+	PUT(6)
+	PUT(7)
+	leaq	64(%rdi),%rdi
+	jnz	.Lloop
+	nop
+	ret
+	CFI_ENDPROC
+ENDPROC(clear_page_nocache)
diff --git a/arch/x86/mm/fault.c b/arch/x86/mm/fault.c
index 654be4a..a088ed7 100644
--- a/arch/x86/mm/fault.c
+++ b/arch/x86/mm/fault.c
@@ -1230,3 +1230,10 @@ do_page_fault(struct pt_regs *regs, unsigned long error_code)
 	__do_page_fault(regs, error_code);
 	exception_exit(prev_state);
 }
+
+void clear_user_highpage_nocache(struct page *page, unsigned long vaddr)
+{
+	void *p = kmap_atomic(page, KM_USER0);
+	clear_page_nocache(p);
+	kunmap_atomic(p);
+}
-- 
1.7.12.4

