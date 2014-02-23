Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751311AbaBWGRi (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Feb 2014 01:17:38 -0500
Received: from mga14.intel.com ([143.182.124.37]:42691 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750883AbaBWGRW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Feb 2014 01:17:22 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,527,1389772800"; 
   d="scan'208";a="342951932"
From: Qiaowei Ren <qiaowei.ren@intel.com>
To: "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>
Cc: x86@kernel.org, linux-kernel@vger.kernel.org,
        Qiaowei Ren <qiaowei.ren@intel.com>
Subject: [PATCH v5 1/3] x86, mpx: add documentation on Intel MPX
Date: Sun, 23 Feb 2014 21:27:49 +0800
Message-Id: <1393162071-23995-2-git-send-email-qiaowei.ren@intel.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1393162071-23995-1-git-send-email-qiaowei.ren@intel.com>
References: <1393162071-23995-1-git-send-email-qiaowei.ren@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds the Documentation/x86/intel_mpx.txt file with some
information about Intel MPX.

Signed-off-by: Qiaowei Ren <qiaowei.ren@intel.com>
---
 Documentation/x86/intel_mpx.txt |  239 +++++++++++++++++++++++++++++++++++++++
 1 files changed, 239 insertions(+), 0 deletions(-)
 create mode 100644 Documentation/x86/intel_mpx.txt

diff --git a/Documentation/x86/intel_mpx.txt b/Documentation/x86/intel_mpx.txt
new file mode 100644
index 0000000..9af8636
--- /dev/null
+++ b/Documentation/x86/intel_mpx.txt
@@ -0,0 +1,239 @@
+1. Intel(R) MPX Overview
+========================
+
+
+Intel(R) Memory Protection Extensions (Intel(R) MPX) is a new
+capability introduced into Intel Architecture. Intel MPX provides
+hardware features that can be used in conjunction with compiler
+changes to check memory references, for those references whose
+compile-time normal intentions are usurped at runtime due to
+buffer overflow or underflow.
+
+Two of the most important goals of Intel MPX are to provide
+this capability at very low performance overhead for newly
+compiled code, and to provide compatibility mechanisms with
+legacy software components. MPX architecture is designed to
+allow a machine (i.e., the processor(s) and the OS software)
+to run both MPX enabled software and legacy software that
+is MPX unaware. In such a case, the legacy software does not
+benefit from MPX, but it also does not experience any change
+in functionality or reduction in performance.
+
+Intel(R) MPX Programming Model
+------------------------------
+
+Intel MPX introduces new registers and new instructions that
+operate on these registers. Some of the registers added are
+bounds registers which store a pointer's lower bound and upper
+bound limits. Whenever the pointer is used, the requested
+reference is checked against the pointer's associated bounds,
+thereby preventing out-of-bound memory access (such as buffer
+overflows and overruns). Out-of-bounds memory references
+initiate a #BR exception which can then be handled in an
+appropriate manner.
+
+Loading and Storing Bounds using Translation
+--------------------------------------------
+
+Intel MPX defines two instructions for load/store of the linear
+address of a pointer to a buffer, along with the bounds of the
+buffer into a paging structure of extended bounds. Specifically
+when storing extended bounds, the processor will perform address
+translation of the address where the pointer is stored to an
+address in the Bound Table (BT) to determine the store location
+of extended bounds. Loading of an extended bounds performs the
+reverse sequence.
+
+The structure in memory to load/store an extended bound is a
+4-tuple consisting of lower bound, upper bound, pointer value
+and a reserved field. Bound loads and stores access 32-bit or
+64-bit operand size according to the operation mode. Thus,
+a bound table entry is 4*32 bits in 32-bit mode and 4*64 bits
+in 64-bit mode.
+
+The linear address of a bound table is stored in a Bound
+Directory (BD) entry. The linear address of the bound
+directory is derived from either BNDCFGU or BNDCFGS registers.
+Bounds in memory are stored in Bound Tables (BT) as an extended
+bound, which are accessed via Bound Directory (BD) and address
+translation performed by BNDLDX/BNDSTX instructions.
+
+Bounds Directory (BD) and Bounds Tables (BT) are stored in
+application memory and are allocated by the application (in case
+of kernel use, the structures will be in kernel memory). The
+bound directory and each instance of bound table are in contiguous
+linear memory.
+
+XSAVE/XRESTOR Support of Intel MPX State
+----------------------------------------
+
+Enabling Intel MPX requires an OS to manage two bits in XCR0:
+  - BNDREGS for saving and restoring registers BND0-BND3,
+  - BNDCSR for saving and restoring the user-mode configuration
+(BNDCFGU) and the status register (BNDSTATUS).
+
+The reason for having two separate bits is that BND0-BND3 are
+likely to be volatile state, while BNDCFGU and BNDSTATUS are not.
+Therefore, an OS has flexibility in handling these two states
+differently in saving or restoring them.
+
+For details about the Intel MPX instructions, see "Intel(R)
+Architecture Instruction Set Extensions Programming Reference".
+
+
+2. How to get the advantage of MPX
+==================================
+
+
+To get the advantage of MPX, changes are required in
+the OS kernel, binutils, compiler, and system libraries support.
+
+MPX support in the GNU toolchain
+--------------------------------
+
+This section describes changes in GNU Binutils, GCC and Glibc
+to support MPX.
+
+The first step of MPX support is to implement support for new
+hardware features in binutils and the GCC.
+
+The second step is implementation of MPX instrumentation pass
+in the GCC compiler which is responsible for instrumenting all
+memory accesses with pointer checks. Compiler changes for runtime
+bound checks include:
+
+  * Bounds creation for statically allocated objects, objects
+    allocated on the stack and statically initialized pointers.
+
+  * MPX support in ABI: ABI extension allows passing bounds for
+    the pointers passed as function arguments and provides returned
+    bounds with the pointers.
+
+  * Bounds table content management: each pointer that is stored
+    into memory should have its bounds stored in the corresponding
+    row of the bounds table; compiler generates appropriate code
+    to have the bounds table in the consistent state.
+
+  * Memory accesses instrumentation: compiler analyzes data flow
+    to compute bounds corresponding to each memory access and
+    inserts code to check used address against computed bounds.
+
+Dynamically created objects in heap using memory allocators need
+to set bounds for objects (buffers) at allocation time. So the
+next step is to add MPX support into standard memory allocators
+in Glibc.
+
+To have full protection, an application has to use libraries
+compiled with MPX instrumentation. It means we had to compile
+Glibc with the MPX-enabled GCC compiler because it is used in
+most applications. Also we had to add MPX instrumentation to all
+the necessary Glibc routines (e.g. memcpy) written in assembler.
+
+A new GCC option -fmpx is introduced to utilize MPX instructions.
+Also binutils with MPX enabled should be used to get binaries
+with memory protection.
+
+Consider the following simple test for MPX compiled program:
+
+	int main(int argc, char* argv)
+	{
+		int buf[100];
+		return buf[argc];
+	}
+
+Snippet of the original assembler output (compiled with -O2):
+
+	movslq  %edi, %rdi
+	movl    -120(%rsp,%rdi,4), %eax  // memory access buf[argc]
+
+Compile test as follows: mpx-gcc/gcc test.c -fmpx -O2
+
+Resulted assembler snippet:
+
+        movl    $399, %edx
+        movslq  %edi, %rdi	// rdi contains value of argc
+        leaq    -104(%rsp), %rax	// load start address of buf to rax
+        bndmk   (%rax,%rdx), %bnd0	//  create bounds for buf
+        bndcl   (%rax,%rdi,4), %bnd0	// check that memory access doesn't
+					// violate buf's low bound
+        bndcu   3(%rax,%rdi,4), %bnd0	// check that memory access doesn't
+					// violate buf's upper bound
+        movl    -104(%rsp,%rdi,4), %eax	// original memory access
+
+Code looks pretty clear. Note only that we added displacement 3 for
+upper bound checking since we have 4 byte (integer) access here.
+
+Several MPX-specific compiler options besides -fmpx were introduced
+in the compiler. Most of them, like -fmpx-check-read and
+-fmpx-check-write, control number of inserted runtime bound checks.
+Also developers always can use intrinsics to insert MPX instructions
+manually.
+
+Currently GCC compiler sources with MPX support is available in a
+separate branch in common GCC SVN repository. See GCC SVN page
+(http://gcc.gnu.org/svn.html) for details.
+
+Currently no hardware with MPX ISA is available but it is always
+possible to use SDE (Intel(R) Software Development Emulator) instead,
+which can be downloaded from
+http://software.intel.com/en-us/articles/intel-software-development-emulator
+
+MPX runtime support
+-------------------
+
+Enabling an application to use MPX will generally not require source
+code updates but there is some runtime code needed in order to make
+use of MPX. For most applications this runtime support will be available
+by linking to a library supplied by the compiler or possibly it will
+come directly from the OS once OS versions that support MPX are available.
+
+The runtime is responsible for configuring and enabling MPX. The
+configuration and enabling of MPX consists of the runtime writing
+the base address of the Bound Directory(BD) to the BNDCFGU register
+and setting the enable bit.
+
+MPX kernel support
+------------------
+
+MPX kernel code has mainly the following responsibilities.
+
+1) Providing handlers for bounds faults (#BR).
+
+When MPX is enabled, there are 2 new situations that can generate
+#BR faults. If a bounds overflow occurs then a #BR is generated.
+The fault handler will decode MPX instructions to get violation
+address and set this address into extended struct siginfo.
+
+The _sigfault feild of struct siginfo is extended as follow:
+
+87		/* SIGILL, SIGFPE, SIGSEGV, SIGBUS */
+88		struct {
+89			void __user *_addr; /* faulting insn/memory ref. */
+90 #ifdef __ARCH_SI_TRAPNO
+91			int _trapno;	/* TRAP # which caused the signal */
+92 #endif
+93			short _addr_lsb; /* LSB of the reported address */
+94			struct {
+95				void __user *_lower;
+96				void __user *_upper;
+97			} _addr_bnd;
+98		} _sigfault;
+
+The '_addr' field refers to violation address, and new '_addr_and'
+field refers to the upper/lower bounds when a #BR is caused.
+
+The other case that generates a #BR is when a BNDSTX instruction
+attempts to save bounds to a BD entry marked as invalid. This is
+an indication that no BT exists for this entry. In this case the
+fault handler will allocate a new BT.
+
+2) Managing bounds memory.
+
+MPX defines 4 sets of bound registers. When an application needs
+more than 4 sets of bounds it uses the BNDSTX instruction to save
+the additional bounds out to memory. The kernel dynamically allocates
+the memory used to store these bounds. The bounds memory is organized
+into a 2-level structure consisting of a BD which contains pointers
+to a set of Bound Tables (BT) which contain the actual bound information.
+In order to minimize the Intel MPX memory usage the BTs are allocated
+on demand by the Intel MPX runtime.
-- 
1.7.1

