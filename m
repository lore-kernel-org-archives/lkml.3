Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756824Ab3CYDkh (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Mar 2013 23:40:37 -0400
Received: from ozlabs.org ([203.10.76.45]:46308 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756245Ab3CYDkg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Mar 2013 23:40:36 -0400
From: Michael Neuling <mikey@neuling.org>
To: Andi Kleen <andi@firstfloor.org>
cc: linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, x86@kernel.org,
        Andi Kleen <ak@linux.intel.com>
Subject: Re: [PATCH 02/29] x86, tsx: Add RTM intrinsics
In-reply-to: <1364001923-10796-3-git-send-email-andi@firstfloor.org>
References: <1364001923-10796-1-git-send-email-andi@firstfloor.org> <1364001923-10796-3-git-send-email-andi@firstfloor.org>
Comments: In-reply-to Andi Kleen <andi@firstfloor.org>
   message dated "Fri, 22 Mar 2013 18:24:56 -0700."
X-Mailer: MH-E 8.2; nmh 1.5; GNU Emacs 23.4.1
Date: Mon, 25 Mar 2013 14:40:34 +1100
Message-ID: <30471.1364182834@ale.ozlabs.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> From: Andi Kleen <ak@linux.intel.com>
> 
> This adds the basic RTM (Restricted Transactional Memory)
> intrinsics for TSX, implemented with alternative() so that they can be
> transparently used without checking CPUID first.
> 
> When the CPU does not support TSX we just always jump to the abort handler.
> 
> These intrinsics are only expected to be used by some low level code
> that presents higher level interface (like locks).
> 
> This is using the same interface as gcc and icc. There's a way to implement
> the intrinsics more efficiently with newer compilers that support asm goto,
> but to avoid undue dependencies on new tool chains this is not used here.
> 
> Also the current way looks slightly nicer, at the cost of only two more
> instructions.
> 
> Also don't require a TSX aware assembler -- all new instructions are implemented
> with .byte.
> 
> Signed-off-by: Andi Kleen <ak@linux.intel.com>
> ---
>  arch/x86/include/asm/rtm.h |   82 ++++++++++++++++++++++++++++++++++++++++++++
>  1 files changed, 82 insertions(+), 0 deletions(-)
>  create mode 100644 arch/x86/include/asm/rtm.h
> 
> diff --git a/arch/x86/include/asm/rtm.h b/arch/x86/include/asm/rtm.h
> new file mode 100644
> index 0000000..7075a04
> --- /dev/null
> +++ b/arch/x86/include/asm/rtm.h
> @@ -0,0 +1,82 @@
> +#ifndef _RTM_OFFICIAL_H
> +#define _RTM_OFFICIAL_H 1
> +
> +#include <linux/compiler.h>
> +#include <asm/alternative.h>
> +#include <asm/cpufeature.h>
> +#include <asm/nops.h>
> +
> +/*
> + * RTM -- restricted transactional memory ISA
> + *
> + * Official RTM intrinsics interface matching gcc/icc, but works
> + * on older gcc compatible compilers and binutils.
> + *
> + * _xbegin() starts a transaction. When it returns a value different
> + * from _XBEGIN_STARTED a non transactional fallback path
> + * should be executed.
> + *
> + * This is a special kernel variant that supports binary patching.
> + * When the CPU does not support RTM we always jump to the abort handler.
> + * And _xtest() always returns 0.
> +
> + * This means these intrinsics can be used without checking cpu_has_rtm
> + * first.
> + *
> + * This is the low level interface mapping directly to the instructions.
> + * Usually kernel code will use a higher level abstraction instead (like locks)
> + *
> + * Note this can be implemented more efficiently on compilers that support
> + * "asm goto". But we don't want to require this right now.
> + */
> +
> +#define _XBEGIN_STARTED		(~0u)
> +#define _XABORT_EXPLICIT	(1 << 0)
> +#define _XABORT_RETRY		(1 << 1)
> +#define _XABORT_CONFLICT	(1 << 2)
> +#define _XABORT_CAPACITY	(1 << 3)
> +#define _XABORT_DEBUG		(1 << 4)
> +#define _XABORT_NESTED		(1 << 5)
> +#define _XABORT_CODE(x)		(((x) >> 24) & 0xff)
> +
> +#define _XABORT_SOFTWARE	-5	/* not part of ISA */
> +
> +static __always_inline int _xbegin(void)
> +{
> +	int ret;
> +	alternative_io("mov %[fallback],%[ret] ; " ASM_NOP6,
> +		       "mov %[started],%[ret] ; "
> +		       ".byte 0xc7,0xf8 ; .long 0 # XBEGIN 0",
> +		       X86_FEATURE_RTM,
> +		       [ret] "=a" (ret),
> +		       [fallback] "i" (_XABORT_SOFTWARE),
> +		       [started] "i" (_XBEGIN_STARTED) : "memory");
> +	return ret;
> +}

So ppc can do something like this.  Stealing from
Documentation/powerpc/transactional_memory.txt, ppc transactions looks
like this:

  tbegin
  beq   abort_handler

  ld    r4, SAVINGS_ACCT(r3)
  ld    r5, CURRENT_ACCT(r3)
  subi  r5, r5, 1
  addi  r4, r4, 1
  std   r4, SAVINGS_ACCT(r3)
  std   r5, CURRENT_ACCT(r3)

  tend

  b     continue

abort_handler:
  ... test for odd failures ...

  /* Retry the transaction if it failed because it conflicted with
   * someone else: */
  b     begin_move_money

The abort handler can then see the failure reason via an SPR/status
register TEXASR.  There are bits in there to specify faulure modes like:

  - software failure code (set in the kernel/hypervisor.  see
      arch/powerpc/include/asm/reg.h)
        #define TM_CAUSE_RESCHED        0xfe
        #define TM_CAUSE_TLBI           0xfc
        #define TM_CAUSE_FAC_UNAV       0xfa
        #define TM_CAUSE_SYSCALL        0xf9 /* Persistent */
        #define TM_CAUSE_MISC           0xf6
        #define TM_CAUSE_SIGNAL         0xf4
  - Failure persistent
  - Disallowed (like disallowed instruction)
  - Nested overflow
  - footprint overflow
  - self induced conflict
  - non-transaction conflict
  - transaction conflict
  - instruction fetch conflict
  - tabort instruction
  - falure while transaction was suspended 

Some of these overlap with the x86 but I think the fidelity could be
improved.

FYI the TM spec can be downloaded here:
  https://www.power.org/documentation/power-isa-transactional-memory/

You're example code looks like this:

static __init int rtm_test(void)
{
	unsigned status;

	pr_info("simple rtm test\n");
	if ((status = _xbegin()) == _XBEGIN_STARTED) {
		x++;
		_xend();
		pr_info("transaction committed\n");
	} else {
		pr_info("transaction aborted %x\n", status);
	}
	return 0;
}

Firstly, I think we can do something like this with the ppc mnemonics,
so I think the overall idea is ok with me. 

Secondly, can we make xbegin just return true/false and get the status
later if needed?

Something like (changing the 'x' names too)

	if (tmbegin()){
		x++;
		tmend();
		pr_info("transaction committed\n");
	} else {
		pr_info("transaction aborted %x\n", tmstatus());
	}
	return 0;

Looks cleaner to me.

> +
> +static __always_inline void _xend(void)
> +{
> +	/* Not patched because these should be not executed in fallback */
> +	asm volatile(".byte 0x0f,0x01,0xd5 # XEND" : : : "memory");
> +}
> +

ppc == tend... should be fine, other than the name.

> +static __always_inline void _xabort(const unsigned int status)
> +{
> +	alternative_input(ASM_NOP3,
> +			  ".byte 0xc6,0xf8,%P0 # XABORT",
> +			  X86_FEATURE_RTM,
> +			  "i" (status) : "memory");
> +}
> +

ppc == tabort... should be fine, other than the name.


> +static __always_inline int _xtest(void)
> +{
> +	unsigned char out;
> +	alternative_io("xor %0,%0 ; " ASM_NOP5,
> +		       ".byte 0x0f,0x01,0xd6 ; setnz %0 # XTEST",
> +		       X86_FEATURE_RTM,
> +		       "=r" (out),
> +		       "i" (0) : "memory");
> +	return out;
> +}
> +
> +#endif

ppc = tcheck... should be fine, other than the name.

Mikey
