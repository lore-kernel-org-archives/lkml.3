Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754506AbaA0U1h (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Jan 2014 15:27:37 -0500
Received: from mail-pa0-f42.google.com ([209.85.220.42]:40390 "EHLO
	mail-pa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754087AbaA0U1f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Jan 2014 15:27:35 -0500
Message-ID: <52E6C134.3050608@mit.edu>
Date: Mon, 27 Jan 2014 12:27:32 -0800
From: Andy Lutomirski <luto@amacapital.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Qiaowei Ren <qiaowei.ren@intel.com>, "H. Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>
CC: X86 ML <x86@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v3 1/4] x86, mpx: add documentation on Intel MPX
References: <1390727338-20487-1-git-send-email-qiaowei.ren@intel.com> <1390727338-20487-2-git-send-email-qiaowei.ren@intel.com>
In-Reply-To: <1390727338-20487-2-git-send-email-qiaowei.ren@intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/26/2014 01:08 AM, Qiaowei Ren wrote:
> This patch adds the Documentation/x86/intel_mpx.txt file with some
> information about Intel MPX.
> 
> Signed-off-by: Qiaowei Ren <qiaowei.ren@intel.com>
> ---
>  Documentation/x86/intel_mpx.txt |  226 +++++++++++++++++++++++++++++++++++++++
>  1 files changed, 226 insertions(+), 0 deletions(-)
>  create mode 100644 Documentation/x86/intel_mpx.txt
> 
> diff --git a/Documentation/x86/intel_mpx.txt b/Documentation/x86/intel_mpx.txt
> new file mode 100644
> index 0000000..052001c
> --- /dev/null
> +++ b/Documentation/x86/intel_mpx.txt
> @@ -0,0 +1,226 @@
> +1. Intel(R) MPX Overview
> +========================
> +
> +
> +Intel(R) Memory Protection Extensions (Intel(R) MPX) is a new
> +capability introduced into Intel Architecture. Intel MPX provides
> +hardware features that can be used in conjunction with compiler
> +changes to check memory references, for those references whose
> +compile-time normal intentions are usurped at runtime due to
> +buffer overflow or underflow.
> +
> +Two of the most important goals of Intel MPX are to provide
> +this capability at very low performance overhead for newly
> +compiled code, and to provide compatibility mechanisms with
> +legacy software components. MPX architecture is designed
> +allow a machine (i.e., the processor(s) and the OS software)
> +to run both MPX enabled software and legacy software that
> +is MPX unaware. In such a case, the legacy software does not
> +benefit from MPX, but it also does not experience any change
> +in functionality or reduction in performance.
> +
> +Intel(R) MPX Programming Model
> +------------------------------
> +
> +Intel MPX introduces new registers and new instructions that
> +operate on these registers. Some of the registers added are
> +bounds registers which store a pointer's lower bound and upper
> +bound limits. Whenever the pointer is used, the requested
> +reference is checked against the pointer's associated bounds,
> +thereby preventing out-of-bound memory access (such as buffer
> +overflows and overruns). Out-of-bounds memory references
> +initiate a #BR exception which can then be handled in an
> +appropriate manner.
> +
> +Loading and Storing Bounds using Translation
> +--------------------------------------------
> +
> +Intel MPX defines two instructions for load/store of the linear
> +address of a pointer to a buffer, along with the bounds of the
> +buffer into a paging structure of extended bounds. Specifically
> +when storing extended bounds, the processor will perform address
> +translation of the address where the pointer is stored to an
> +address in the Bound Table (BT) to determine the store location
> +of extended bounds. Loading of an extended bounds performs the
> +reverse sequence.
> +
> +The structure in memory to load/store an extended bound is a
> +4-tuple consisting of lower bound, upper bound, pointer value
> +and a reserved field. Bound loads and stores access 32-bit or
> +64-bit operand size according to the operation mode. Thus,
> +a bound table entry is 4*32 bits in 32-bit mode and 4*64 bits
> +in 64-bit mode.
> +
> +The linear address of a bound table is stored in a Bound
> +Directory (BD) entry. And the linear address of the bound
> +directory is derived from either BNDCFGU or BNDCFGS registers.
> +Bounds in memory are stored in Bound Tables (BT) as an extended
> +bound, which are accessed via Bound Directory (BD) and address
> +translation performed by BNDLDX/BNDSTX instructions.
> +
> +Bounds Directory (BD) and Bounds Tables (BT) are stored in
> +application memory and are allocated by the application (in case
> +of kernel use, the structures will be in kernel memory). The
> +bound directory and each instance of bound table are in contiguous
> +linear memory.
> +
> +XSAVE/XRESTOR Support of Intel MPX State
> +----------------------------------------
> +
> +Enabling Intel MPX requires an OS to manage two bits in XCR0:
> +  - BNDREGS for saving and restoring registers BND0-BND3,
> +  - BNDCSR for saving and restoring the user-mode configuration
> +(BNDCFGU) and the status register (BNDSTATUS).
> +
> +The reason for having two separate bits is that BND0-BND3 is
> +likely to be volatile state, while BNDCFGU and BNDSTATUS are not.
> +Therefore, an OS has flexibility in handling these two states
> +differently in saving or restoring them.
> +
> +For details about the Intel MPX instructions, see "Intel(R)
> +Architecture Instruction Set Extensions Programming Reference".
> +
> +
> +2. How to get the advantage of MPX 
> +==================================
> +
> +
> +To get the advantage of MPX, changes are required in
> +the OS kernel, binutils, compiler, system libraries support.
> +
> +MPX support in the GNU toolchain
> +--------------------------------
> +
> +This section describes changes in GNU Binutils, GCC and Glibc
> +to support MPX.
> +
> +The first step of MPX support is to implement support for new
> +hardware features in binutils and the GCC.
> +
> +The second step is implementation of MPX instrumentation pass
> +in the GCC compiler which is responsible for instrumenting all
> +memory accesses with pointer checks. Compiler changes for runtime
> +bound checks include:
> +
> +  * Bounds creation for statically allocated objects, objects
> +    allocated on the stack and statically initialized pointers.
> +
> +  * MPX support in ABI: ABI extension allows passing bounds for
> +    the pointers passed as function arguments and provide returned
> +    bounds with the pointers.
> +
> +  * Bounds table content management: each pointer is stored into
> +    the memory should have its bounds stored in the corresponding
> +    row of the bounds table; compiler generates appropriate code
> +    to have the bounds table in the consistent state.
> +
> +  * Memory accesses instrumentation: compiler analyzes data flow
> +    to compute bounds corresponding to each memory access and
> +    inserts code to check used address against computed bounds.
> +
> +Dynamically created objects in heap using memory allocators need
> +to set bounds for objects (buffers) at allocation time. So the
> +next step is to add MPX support into standard memory allocators
> +in Glibc.
> +
> +To have the full protection, an application has to use libraries
> +compiled with MPX instrumentation. It means we had to compile
> +Glibc with the MPX enabled GCC compiler because it is used in
> +most applications. Also we had to add MPX instrumentation to all
> +the necessary Glibc routines (e.g. memcpy) written on assembler.
> +
> +New GCC option -fmpx is introduced to utilize MPX instructions.
> +Also binutils with MPX enabled should be used to get binaries
> +with memory protection.
> +
> +Consider following simple test for MPX compiled program:
> +
> +	int main(int argc, char* argv)
> +	{
> +		int buf[100];
> +		return buf[argc];
> +	}
> +
> +Snippet of the original assembler output (compiled with -O2):
> +
> +	movslq  %edi, %rdi
> +	movl    -120(%rsp,%rdi,4), %eax  // memory access buf[argc]
> +
> +Compile test as follows: mpx-gcc/gcc test.c -fmpx -O2.
> +
> +Resulted assembler snippet:
> +
> +        movl    $399, %edx	// load array length to edx
> +        movslq  %edi, %rdi	// rdi contains value of argc 
> +        leaq    -104(%rsp), %rax	// load start address of buf to rax
> +        bndmk   (%rax,%rdx), %bnd0	//  create bounds for buf
> +        bndcl   (%rax,%rdi,4), %bnd0	// check that memory access doesn't
> +					// violate buf's low bound
> +        bndcu   3(%rax,%rdi,4), %bnd0	// check that memory access doesn't
> +					// violate buf's upper bound
> +        movl    -104(%rsp,%rdi,4), %eax	// original memory access
> +
> +Code looks pretty clear. Note only that we added displacement 3 for
> +upper bound checking since we have 4 byte (integer) access here.

I know I'm off topic here, but is using MPX for a trivial case like this
actually faster than just comparing argc to 100 and branching to a fault
handler function on failure?

> +
> +Several MPX specific compiler options besides -fmpx were introduced
> +in the compiler. Most of them, like -fmpx-check-read and
> +-fmpx-check-write, control number of inserted runtime bound checks.
> +Also developers always can use intrinsics to insert MPX instructions
> +manually.
> +
> +Currently GCC compiler sources with MPX support is available in a
> +separate branch in common GCC SVN repository. See GCC SVN page
> +(http://gcc.gnu.org/svn.html) for details.
> +
> +Currently no hardware with MPX ISA is available but it is always
> +possible to use SDE (Intel(R) software Development Emulator) instead,
> +which can be downloaded from
> +http://software.intel.com/en-us/articles/intel-software-development-emulator
> +
> +MPX runtime support
> +-------------------
> +
> +Enabling an application to use MPX will generally not require source
> +code updates but there is some runtime code needed in order to make
> +use of MPX. For most applications this runtime support will be available
> +by linking to a library supplied by the compiler or possibly it will
> +come directly from the OS once OS versions that support MPX are available.
> +
> +The runtime is responsible for configuring and enabling MPX. The
> +configuration and enabling of MPX consists of the runtime writing
> +the base address of the Bound Directory(BD) to the BNDCFGU register
> +and setting the enable bit.
> +
> +MPX kernel support
> +------------------
> +
> +MPX kernel code has mainly the following responsibilities.
> +
> +1) Providing handlers for bounds faults (#BR).
> +
> +When MPX is enabled, there are 2 new situations that can generate
> +#BR faults. If a bounds overflow occurs then a #BR is generated.
> +The fault handler will decode MPX instructions to get violation
> +address and set this address into extended struct siginfo.

Can you document exactly where the insn address and pointer value end
up?  (If it's in the (IMO hideous) cr2 field in ucontext, this needs to
be documented.  If it's somewhere useful in siginfo, that should also be
documented to save people the time it takes to figure it out.)

