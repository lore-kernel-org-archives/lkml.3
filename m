Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752714AbaKDTqA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2014 14:46:00 -0500
Received: from terminus.zytor.com ([198.137.202.10]:60933 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752386AbaKDTp7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Nov 2014 14:45:59 -0500
Date: Tue, 4 Nov 2014 11:45:45 -0800
From: tip-bot for Jan Beulich <tipbot@zytor.com>
Message-ID: <tip-97b67ae559947f1e208439a1bf6a734da3087006@git.kernel.org>
Cc: jbeulich@suse.com, JBeulich@suse.com, tglx@linutronix.de, hpa@zytor.com,
        linux-kernel@vger.kernel.org, mingo@kernel.org
Reply-To: mingo@kernel.org, linux-kernel@vger.kernel.org, JBeulich@suse.com,
        tglx@linutronix.de, hpa@zytor.com, jbeulich@suse.com
In-Reply-To: <5458A1780200007800044A9D@mail.emea.novell.com>
References: <5458A1780200007800044A9D@mail.emea.novell.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/boot] x86-64:
  Use RIP-relative addressing for most per-CPU accesses
Git-Commit-ID: 97b67ae559947f1e208439a1bf6a734da3087006
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  97b67ae559947f1e208439a1bf6a734da3087006
Gitweb:     http://git.kernel.org/tip/97b67ae559947f1e208439a1bf6a734da3087006
Author:     Jan Beulich <JBeulich@suse.com>
AuthorDate: Tue, 4 Nov 2014 08:50:48 +0000
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Tue, 4 Nov 2014 20:43:14 +0100

x86-64: Use RIP-relative addressing for most per-CPU accesses

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
Link: http://lkml.kernel.org/r/5458A1780200007800044A9D@mail.emea.novell.com
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 arch/x86/include/asm/percpu.h | 59 ++++++++++++++++++++++++++++++++-----------
 arch/x86/kernel/vmlinux.lds.S |  2 ++
 2 files changed, 46 insertions(+), 15 deletions(-)

diff --git a/arch/x86/include/asm/percpu.h b/arch/x86/include/asm/percpu.h
index 74da317..e0ba66c 100644
--- a/arch/x86/include/asm/percpu.h
+++ b/arch/x86/include/asm/percpu.h
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
diff --git a/arch/x86/kernel/vmlinux.lds.S b/arch/x86/kernel/vmlinux.lds.S
index 49edf2d..00bf300 100644
--- a/arch/x86/kernel/vmlinux.lds.S
+++ b/arch/x86/kernel/vmlinux.lds.S
@@ -186,6 +186,8 @@ SECTIONS
 	 * start another segment - init.
 	 */
 	PERCPU_VADDR(INTERNODE_CACHE_BYTES, 0, :percpu)
+	ASSERT(SIZEOF(.data..percpu) < CONFIG_PHYSICAL_START,
+	       "per-CPU data too large - increase CONFIG_PHYSICAL_START")
 #endif
 
 	INIT_TEXT_SECTION(PAGE_SIZE)
