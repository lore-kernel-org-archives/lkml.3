Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754360Ab3FGNa2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Jun 2013 09:30:28 -0400
Received: from smtp.citrix.com ([66.165.176.89]:59539 "EHLO SMTP.CITRIX.COM"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752900Ab3FGNa0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Jun 2013 09:30:26 -0400
X-IronPort-AV: E=Sophos;i="4.87,822,1363132800"; 
   d="scan'208";a="29870051"
Date: Fri, 7 Jun 2013 14:26:22 +0100
From: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
X-X-Sender: sstabellini@kaball.uk.xensource.com
To: Catalin Marinas <catalin.marinas@arm.com>
CC: <linux-arm-kernel@lists.infradead.org>, <xen-devel@lists.xensource.com>,
        <linux-kernel@vger.kernel.org>,
        Stefano Stabellini <Stefano.Stabellini@eu.citrix.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Will Deacon <will.deacon@arm.com>, Arnd Bergmann <arnd@arndb.de>,
        Ian Campbell <Ian.Campbell@citrix.com>
Subject: [GIT PULL] Introduce Xen support to ARM64
Message-ID: <alpine.DEB.2.02.1306071142300.4589@kaball.uk.xensource.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Catalin,
the following changes since commit dcdbe33add56cb659ebf21fb9b6577507e21d952:

  Merge branch 'mn10300' (mn10300 fixes from David Howells) (2013-05-30 13:39:01 +0900)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/sstabellini/xen.git xen-arm64-3.1-tag

Stefano Stabellini (6):
      arm/xen: define xen_remap as ioremap_cached
      arm64/xen: introduce asm/xen header files on arm64
      arm64/xen: implement ioremap_cached on arm64
      arm64/xen: use XEN_IO_PROTO_ABI_ARM on ARM64
      arm64/xen: introduce CONFIG_XEN and hypercall.S on ARM64
      MAINTAINERS: add myself as arm64/xen maintainer

 MAINTAINERS                             |    7 ++
 arch/arm/include/asm/xen/page.h         |    3 +-
 arch/arm64/Kconfig                      |   10 +++
 arch/arm64/Makefile                     |    1 +
 arch/arm64/include/asm/hypervisor.h     |    6 ++
 arch/arm64/include/asm/io.h             |    2 +
 arch/arm64/include/asm/sync_bitops.h    |   26 +++++++++
 arch/arm64/include/asm/xen/events.h     |   21 +++++++
 arch/arm64/include/asm/xen/hypercall.h  |    1 +
 arch/arm64/include/asm/xen/hypervisor.h |    1 +
 arch/arm64/include/asm/xen/interface.h  |    1 +
 arch/arm64/include/asm/xen/page.h       |    1 +
 arch/arm64/xen/Makefile                 |    2 +
 arch/arm64/xen/hypercall.S              |   92 +++++++++++++++++++++++++++++++
 include/xen/interface/io/protocols.h    |    2 +-
 15 files changed, 173 insertions(+), 3 deletions(-)
 create mode 100644 arch/arm64/include/asm/hypervisor.h
 create mode 100644 arch/arm64/include/asm/sync_bitops.h
 create mode 100644 arch/arm64/include/asm/xen/events.h
 create mode 100644 arch/arm64/include/asm/xen/hypercall.h
 create mode 100644 arch/arm64/include/asm/xen/hypervisor.h
 create mode 100644 arch/arm64/include/asm/xen/interface.h
 create mode 100644 arch/arm64/include/asm/xen/page.h
 create mode 100644 arch/arm64/xen/Makefile
 create mode 100644 arch/arm64/xen/hypercall.S


This is v3 of the series with a couple of Acked-by more in the commit
messages and two lines better aligned with tabs equal to 8 characters.
Full diff below.


diff --git a/MAINTAINERS b/MAINTAINERS
index fd3a495..95a6a51 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -9096,6 +9096,13 @@ S:	Supported
 F:	arch/arm/xen/
 F:	arch/arm/include/asm/xen/
 
+XEN HYPERVISOR ARM64
+M:	Stefano Stabellini <stefano.stabellini@eu.citrix.com>
+L:	xen-devel@lists.xensource.com (moderated for non-subscribers)
+S:	Supported
+F:	arch/arm64/xen/
+F:	arch/arm64/include/asm/xen/
+
 XEN NETWORK BACKEND DRIVER
 M:	Ian Campbell <ian.campbell@citrix.com>
 L:	xen-devel@lists.xensource.com (moderated for non-subscribers)
diff --git a/arch/arm/include/asm/xen/page.h b/arch/arm/include/asm/xen/page.h
index 30cdacb..359a7b5 100644
--- a/arch/arm/include/asm/xen/page.h
+++ b/arch/arm/include/asm/xen/page.h
@@ -1,7 +1,6 @@
 #ifndef _ASM_ARM_XEN_PAGE_H
 #define _ASM_ARM_XEN_PAGE_H
 
-#include <asm/mach/map.h>
 #include <asm/page.h>
 #include <asm/pgtable.h>
 
@@ -88,6 +87,6 @@ static inline bool set_phys_to_machine(unsigned long pfn, unsigned long mfn)
 	return __set_phys_to_machine(pfn, mfn);
 }
 
-#define xen_remap(cookie, size) __arm_ioremap((cookie), (size), MT_MEMORY);
+#define xen_remap(cookie, size) ioremap_cached((cookie), (size));
 
 #endif /* _ASM_ARM_XEN_PAGE_H */
diff --git a/arch/arm64/Kconfig b/arch/arm64/Kconfig
index 56b3f6d..b5d6ada 100644
--- a/arch/arm64/Kconfig
+++ b/arch/arm64/Kconfig
@@ -182,6 +182,16 @@ config HW_PERF_EVENTS
 
 source "mm/Kconfig"
 
+config XEN_DOM0
+	def_bool y
+	depends on XEN
+
+config XEN
+	bool "Xen guest support on ARM64 (EXPERIMENTAL)"
+	depends on ARM64 && OF
+	help
+	  Say Y if you want to run Linux in a Virtual Machine on Xen on ARM64.
+
 endmenu
 
 menu "Boot options"
diff --git a/arch/arm64/Makefile b/arch/arm64/Makefile
index c95c5cb..79dd13d 100644
--- a/arch/arm64/Makefile
+++ b/arch/arm64/Makefile
@@ -37,6 +37,7 @@ TEXT_OFFSET := 0x00080000
 export	TEXT_OFFSET GZFLAGS
 
 core-y		+= arch/arm64/kernel/ arch/arm64/mm/
+core-$(CONFIG_XEN)		+= arch/arm64/xen/
 libs-y		:= arch/arm64/lib/ $(libs-y)
 libs-y		+= $(LIBGCC)
 
diff --git a/arch/arm64/include/asm/hypervisor.h b/arch/arm64/include/asm/hypervisor.h
new file mode 100644
index 0000000..d2c7904
--- /dev/null
+++ b/arch/arm64/include/asm/hypervisor.h
@@ -0,0 +1,6 @@
+#ifndef _ASM_ARM64_HYPERVISOR_H
+#define _ASM_ARM64_HYPERVISOR_H
+
+#include <asm/xen/hypervisor.h>
+
+#endif
diff --git a/arch/arm64/include/asm/io.h b/arch/arm64/include/asm/io.h
index 2e12258..1d12f89 100644
--- a/arch/arm64/include/asm/io.h
+++ b/arch/arm64/include/asm/io.h
@@ -228,10 +228,12 @@ extern void __iounmap(volatile void __iomem *addr);
 #define PROT_DEFAULT		(PTE_TYPE_PAGE | PTE_AF | PTE_DIRTY)
 #define PROT_DEVICE_nGnRE	(PROT_DEFAULT | PTE_PXN | PTE_UXN | PTE_ATTRINDX(MT_DEVICE_nGnRE))
 #define PROT_NORMAL_NC		(PROT_DEFAULT | PTE_ATTRINDX(MT_NORMAL_NC))
+#define PROT_NORMAL		(PROT_DEFAULT | PTE_ATTRINDX(MT_NORMAL))
 
 #define ioremap(addr, size)		__ioremap((addr), (size), __pgprot(PROT_DEVICE_nGnRE))
 #define ioremap_nocache(addr, size)	__ioremap((addr), (size), __pgprot(PROT_DEVICE_nGnRE))
 #define ioremap_wc(addr, size)		__ioremap((addr), (size), __pgprot(PROT_NORMAL_NC))
+#define ioremap_cached(addr, size)	__ioremap((addr), (size), __pgprot(PROT_NORMAL))
 #define iounmap				__iounmap
 
 #define PROT_SECT_DEFAULT	(PMD_TYPE_SECT | PMD_SECT_AF)
diff --git a/arch/arm64/include/asm/sync_bitops.h b/arch/arm64/include/asm/sync_bitops.h
new file mode 100644
index 0000000..8da0bf4
--- /dev/null
+++ b/arch/arm64/include/asm/sync_bitops.h
@@ -0,0 +1,26 @@
+#ifndef __ASM_SYNC_BITOPS_H__
+#define __ASM_SYNC_BITOPS_H__
+
+#include <asm/bitops.h>
+#include <asm/cmpxchg.h>
+
+/* sync_bitops functions are equivalent to the SMP implementation of the
+ * original functions, independently from CONFIG_SMP being defined.
+ *
+ * We need them because _set_bit etc are not SMP safe if !CONFIG_SMP. But
+ * under Xen you might be communicating with a completely external entity
+ * who might be on another CPU (e.g. two uniprocessor guests communicating
+ * via event channels and grant tables). So we need a variant of the bit
+ * ops which are SMP safe even on a UP kernel.
+ */
+
+#define sync_set_bit(nr, p)            set_bit(nr, p)
+#define sync_clear_bit(nr, p)          clear_bit(nr, p)
+#define sync_change_bit(nr, p)         change_bit(nr, p)
+#define sync_test_and_set_bit(nr, p)   test_and_set_bit(nr, p)
+#define sync_test_and_clear_bit(nr, p) test_and_clear_bit(nr, p)
+#define sync_test_and_change_bit(nr, p)        test_and_change_bit(nr, p)
+#define sync_test_bit(nr, addr)                test_bit(nr, addr)
+#define sync_cmpxchg                   cmpxchg
+
+#endif
diff --git a/arch/arm64/include/asm/xen/events.h b/arch/arm64/include/asm/xen/events.h
new file mode 100644
index 0000000..8655321
--- /dev/null
+++ b/arch/arm64/include/asm/xen/events.h
@@ -0,0 +1,21 @@
+#ifndef _ASM_ARM64_XEN_EVENTS_H
+#define _ASM_ARM64_XEN_EVENTS_H
+
+#include <asm/ptrace.h>
+#include <asm/atomic.h>
+
+enum ipi_vector {
+	XEN_PLACEHOLDER_VECTOR,
+
+	/* Xen IPIs go here */
+	XEN_NR_IPIS,
+};
+
+static inline int xen_irqs_disabled(struct pt_regs *regs)
+{
+	return raw_irqs_disabled_flags((unsigned long) regs->pstate);
+}
+
+#define xchg_xen_ulong(ptr, val) xchg((ptr), (val))
+
+#endif /* _ASM_ARM64_XEN_EVENTS_H */
diff --git a/arch/arm64/include/asm/xen/hypercall.h b/arch/arm64/include/asm/xen/hypercall.h
new file mode 100644
index 0000000..74b0c42
--- /dev/null
+++ b/arch/arm64/include/asm/xen/hypercall.h
@@ -0,0 +1 @@
+#include <../../arm/include/asm/xen/hypercall.h>
diff --git a/arch/arm64/include/asm/xen/hypervisor.h b/arch/arm64/include/asm/xen/hypervisor.h
new file mode 100644
index 0000000..f263da8
--- /dev/null
+++ b/arch/arm64/include/asm/xen/hypervisor.h
@@ -0,0 +1 @@
+#include <../../arm/include/asm/xen/hypervisor.h>
diff --git a/arch/arm64/include/asm/xen/interface.h b/arch/arm64/include/asm/xen/interface.h
new file mode 100644
index 0000000..44457ae
--- /dev/null
+++ b/arch/arm64/include/asm/xen/interface.h
@@ -0,0 +1 @@
+#include <../../arm/include/asm/xen/interface.h>
diff --git a/arch/arm64/include/asm/xen/page.h b/arch/arm64/include/asm/xen/page.h
new file mode 100644
index 0000000..bed87ec
--- /dev/null
+++ b/arch/arm64/include/asm/xen/page.h
@@ -0,0 +1 @@
+#include <../../arm/include/asm/xen/page.h>
diff --git a/arch/arm64/xen/Makefile b/arch/arm64/xen/Makefile
new file mode 100644
index 0000000..be24040
--- /dev/null
+++ b/arch/arm64/xen/Makefile
@@ -0,0 +1,2 @@
+xen-arm-y	+= $(addprefix ../../arm/xen/, enlighten.o grant-table.o)
+obj-y		:= xen-arm.o hypercall.o
diff --git a/arch/arm64/xen/hypercall.S b/arch/arm64/xen/hypercall.S
new file mode 100644
index 0000000..2816c47
--- /dev/null
+++ b/arch/arm64/xen/hypercall.S
@@ -0,0 +1,92 @@
+/******************************************************************************
+ * hypercall.S
+ *
+ * Xen hypercall wrappers
+ *
+ * Stefano Stabellini <stefano.stabellini@eu.citrix.com>, Citrix, 2012
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License version 2
+ * as published by the Free Software Foundation; or, when distributed
+ * separately from the Linux kernel or incorporated into other
+ * software packages, subject to the following license:
+ *
+ * Permission is hereby granted, free of charge, to any person obtaining a copy
+ * of this source file (the "Software"), to deal in the Software without
+ * restriction, including without limitation the rights to use, copy, modify,
+ * merge, publish, distribute, sublicense, and/or sell copies of the Software,
+ * and to permit persons to whom the Software is furnished to do so, subject to
+ * the following conditions:
+ *
+ * The above copyright notice and this permission notice shall be included in
+ * all copies or substantial portions of the Software.
+ *
+ * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
+ * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
+ * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
+ * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
+ * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
+ * FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS
+ * IN THE SOFTWARE.
+ */
+
+/*
+ * The Xen hypercall calling convention is very similar to the procedure
+ * call standard for the ARM 64-bit architecture: the first parameter is
+ * passed in x0, the second in x1, the third in x2, the fourth in x3 and
+ * the fifth in x4.
+ *
+ * The hypercall number is passed in x16.
+ *
+ * The return value is in x0.
+ *
+ * The hvc ISS is required to be 0xEA1, that is the Xen specific ARM
+ * hypercall tag.
+ *
+ * Parameter structs passed to hypercalls are laid out according to
+ * the ARM 64-bit EABI standard.
+ */
+
+#include <linux/linkage.h>
+#include <asm/assembler.h>
+#include <xen/interface/xen.h>
+
+
+#define XEN_IMM 0xEA1
+
+#define HYPERCALL_SIMPLE(hypercall)		\
+ENTRY(HYPERVISOR_##hypercall)			\
+	mov x16, #__HYPERVISOR_##hypercall;	\
+	hvc XEN_IMM;				\
+	ret;					\
+ENDPROC(HYPERVISOR_##hypercall)
+
+#define HYPERCALL0 HYPERCALL_SIMPLE
+#define HYPERCALL1 HYPERCALL_SIMPLE
+#define HYPERCALL2 HYPERCALL_SIMPLE
+#define HYPERCALL3 HYPERCALL_SIMPLE
+#define HYPERCALL4 HYPERCALL_SIMPLE
+#define HYPERCALL5 HYPERCALL_SIMPLE
+
+                .text
+
+HYPERCALL2(xen_version);
+HYPERCALL3(console_io);
+HYPERCALL3(grant_table_op);
+HYPERCALL2(sched_op);
+HYPERCALL2(event_channel_op);
+HYPERCALL2(hvm_op);
+HYPERCALL2(memory_op);
+HYPERCALL2(physdev_op);
+HYPERCALL3(vcpu_op);
+
+ENTRY(privcmd_call)
+	mov x16, x0
+	mov x0, x1
+	mov x1, x2
+	mov x2, x3
+	mov x3, x4
+	mov x4, x5
+	hvc XEN_IMM
+	ret
+ENDPROC(privcmd_call);
diff --git a/include/xen/interface/io/protocols.h b/include/xen/interface/io/protocols.h
index 0eafaf2..056744b 100644
--- a/include/xen/interface/io/protocols.h
+++ b/include/xen/interface/io/protocols.h
@@ -15,7 +15,7 @@
 # define XEN_IO_PROTO_ABI_NATIVE XEN_IO_PROTO_ABI_IA64
 #elif defined(__powerpc64__)
 # define XEN_IO_PROTO_ABI_NATIVE XEN_IO_PROTO_ABI_POWERPC64
-#elif defined(__arm__)
+#elif defined(__arm__) || defined(__aarch64__)
 # define XEN_IO_PROTO_ABI_NATIVE XEN_IO_PROTO_ABI_ARM
 #else
 # error arch fixup needed here
