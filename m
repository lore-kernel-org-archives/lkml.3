Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752974AbaKDIuz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2014 03:50:55 -0500
Received: from mail.emea.novell.com ([130.57.118.101]:51896 "EHLO
	mail.emea.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752092AbaKDIuw convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-linux-kernel@vger.kernel.org:3:1>);
	Tue, 4 Nov 2014 03:50:52 -0500
Message-Id: <5458A1780200007800044A9D@mail.emea.novell.com>
X-Mailer: Novell GroupWise Internet Agent 14.0.1 
Date: Tue, 04 Nov 2014 08:50:48 +0000
From: "Jan Beulich" <JBeulich@suse.com>
To: <mingo@elte.hu>, <tglx@linutronix.de>, <hpa@zytor.com>
Cc: <linux-kernel@vger.kernel.org>
Subject: [PATCH 2/2] x86-64: use RIP-relative addressing for most
 per-CPU accesses
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Observing that per-CPU data (in the SMP case) is reachable by
exploiting 64-bit address wraparound (building on the default kernel
load address being at 16Mb), the one byte shorter RIP-relative
addressing form can be used for most per-CPU accesses. The one
exception are the "stable" reads, where the use of the "P" operand
modifier prevents the compiler from using RIP-relative addressing, but
is unavoidable due to the use of the "p" constraint (side note: with
gcc 4.9.x the intended effect of this isn't being achieved anymore,
see gcc bug 63637).

With the dependency on the minimum kernel load address, arbitrarily
low values for CONFIG_PHYSICAL_START are now no longer possible. A
link time assertion is being added, directing to the need to increase
that value when it triggers.

Signed-off-by: Jan Beulich <jbeulich@suse.com>
---
 arch/x86/include/asm/percpu.h |   59 +++++++++++++++++++++++++++++++-----------
 arch/x86/kernel/vmlinux.lds.S |    2 +
 2 files changed, 46 insertions(+), 15 deletions(-)

--- 3.18-rc3-x86_64-PCrel-per-CPU.orig/arch/x86/include/asm/percpu.h
+++ 3.18-rc3-x86_64-PCrel-per-CPU/arch/x86/include/asm/percpu.h
@@ -64,7 +64,7 @@
 #define __percpu_prefix		""
 #endif
 
-#define __percpu_arg(x)		__percpu_prefix "%P" #x
+#define __percpu_arg(x)		__percpu_prefix "%" #x
 
 /*
  * Initialized pointers to per-cpu variables needed for the boot
@@ -179,29 +179,58 @@ do {									\
 	}								\
 } while (0)
 
-#define percpu_from_op(op, var, constraint)		\
+#define percpu_from_op(op, var)				\
 ({							\
 	typeof(var) pfo_ret__;				\
 	switch (sizeof(var)) {				\
 	case 1:						\
 		asm(op "b "__percpu_arg(1)",%0"		\
 		    : "=q" (pfo_ret__)			\
-		    : constraint);			\
+		    : "m" (var));			\
 		break;					\
 	case 2:						\
 		asm(op "w "__percpu_arg(1)",%0"		\
 		    : "=r" (pfo_ret__)			\
-		    : constraint);			\
+		    : "m" (var));			\
 		break;					\
 	case 4:						\
 		asm(op "l "__percpu_arg(1)",%0"		\
 		    : "=r" (pfo_ret__)			\
-		    : constraint);			\
+		    : "m" (var));			\
 		break;					\
 	case 8:						\
 		asm(op "q "__percpu_arg(1)",%0"		\
 		    : "=r" (pfo_ret__)			\
-		    : constraint);			\
+		    : "m" (var));			\
+		break;					\
+	default: __bad_percpu_size();			\
+	}						\
+	pfo_ret__;					\
+})
+
+#define percpu_stable_op(op, var)			\
+({							\
+	typeof(var) pfo_ret__;				\
+	switch (sizeof(var)) {				\
+	case 1:						\
+		asm(op "b "__percpu_arg(P1)",%0"	\
+		    : "=q" (pfo_ret__)			\
+		    : "p" (&(var)));			\
+		break;					\
+	case 2:						\
+		asm(op "w "__percpu_arg(P1)",%0"	\
+		    : "=r" (pfo_ret__)			\
+		    : "p" (&(var)));			\
+		break;					\
+	case 4:						\
+		asm(op "l "__percpu_arg(P1)",%0"	\
+		    : "=r" (pfo_ret__)			\
+		    : "p" (&(var)));			\
+		break;					\
+	case 8:						\
+		asm(op "q "__percpu_arg(P1)",%0"	\
+		    : "=r" (pfo_ret__)			\
+		    : "p" (&(var)));			\
 		break;					\
 	default: __bad_percpu_size();			\
 	}						\
@@ -359,11 +388,11 @@ do {									\
  * per-thread variables implemented as per-cpu variables and thus
  * stable for the duration of the respective task.
  */
-#define this_cpu_read_stable(var)	percpu_from_op("mov", var, "p" (&(var)))
+#define this_cpu_read_stable(var)	percpu_stable_op("mov", var)
 
-#define raw_cpu_read_1(pcp)		percpu_from_op("mov", (pcp), "m"(pcp))
-#define raw_cpu_read_2(pcp)		percpu_from_op("mov", (pcp), "m"(pcp))
-#define raw_cpu_read_4(pcp)		percpu_from_op("mov", (pcp), "m"(pcp))
+#define raw_cpu_read_1(pcp)		percpu_from_op("mov", pcp)
+#define raw_cpu_read_2(pcp)		percpu_from_op("mov", pcp)
+#define raw_cpu_read_4(pcp)		percpu_from_op("mov", pcp)
 
 #define raw_cpu_write_1(pcp, val)	percpu_to_op("mov", (pcp), val)
 #define raw_cpu_write_2(pcp, val)	percpu_to_op("mov", (pcp), val)
@@ -381,9 +410,9 @@ do {									\
 #define raw_cpu_xchg_2(pcp, val)	percpu_xchg_op(pcp, val)
 #define raw_cpu_xchg_4(pcp, val)	percpu_xchg_op(pcp, val)
 
-#define this_cpu_read_1(pcp)		percpu_from_op("mov", (pcp), "m"(pcp))
-#define this_cpu_read_2(pcp)		percpu_from_op("mov", (pcp), "m"(pcp))
-#define this_cpu_read_4(pcp)		percpu_from_op("mov", (pcp), "m"(pcp))
+#define this_cpu_read_1(pcp)		percpu_from_op("mov", pcp)
+#define this_cpu_read_2(pcp)		percpu_from_op("mov", pcp)
+#define this_cpu_read_4(pcp)		percpu_from_op("mov", pcp)
 #define this_cpu_write_1(pcp, val)	percpu_to_op("mov", (pcp), val)
 #define this_cpu_write_2(pcp, val)	percpu_to_op("mov", (pcp), val)
 #define this_cpu_write_4(pcp, val)	percpu_to_op("mov", (pcp), val)
@@ -435,7 +464,7 @@ do {									\
  * 32 bit must fall back to generic operations.
  */
 #ifdef CONFIG_X86_64
-#define raw_cpu_read_8(pcp)			percpu_from_op("mov", (pcp), "m"(pcp))
+#define raw_cpu_read_8(pcp)			percpu_from_op("mov", pcp)
 #define raw_cpu_write_8(pcp, val)		percpu_to_op("mov", (pcp), val)
 #define raw_cpu_add_8(pcp, val)			percpu_add_op((pcp), val)
 #define raw_cpu_and_8(pcp, val)			percpu_to_op("and", (pcp), val)
@@ -444,7 +473,7 @@ do {									\
 #define raw_cpu_xchg_8(pcp, nval)		percpu_xchg_op(pcp, nval)
 #define raw_cpu_cmpxchg_8(pcp, oval, nval)	percpu_cmpxchg_op(pcp, oval, nval)
 
-#define this_cpu_read_8(pcp)			percpu_from_op("mov", (pcp), "m"(pcp))
+#define this_cpu_read_8(pcp)			percpu_from_op("mov", pcp)
 #define this_cpu_write_8(pcp, val)		percpu_to_op("mov", (pcp), val)
 #define this_cpu_add_8(pcp, val)		percpu_add_op((pcp), val)
 #define this_cpu_and_8(pcp, val)		percpu_to_op("and", (pcp), val)
--- 3.18-rc3-x86_64-PCrel-per-CPU.orig/arch/x86/kernel/vmlinux.lds.S
+++ 3.18-rc3-x86_64-PCrel-per-CPU/arch/x86/kernel/vmlinux.lds.S
@@ -186,6 +186,8 @@ SECTIONS
 	 * start another segment - init.
 	 */
 	PERCPU_VADDR(INTERNODE_CACHE_BYTES, 0, :percpu)
+	ASSERT(SIZEOF(.data..percpu) < CONFIG_PHYSICAL_START,
+	       "per-CPU data too large - increase CONFIG_PHYSICAL_START")
 #endif
 
 	INIT_TEXT_SECTION(PAGE_SIZE)


