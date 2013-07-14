Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753135Ab3GNTXx (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Jul 2013 15:23:53 -0400
Received: from claw.goop.org ([74.207.240.146]:49538 "EHLO claw.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753015Ab3GNTXj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Jul 2013 15:23:39 -0400
Message-ID: <51E2FAB9.9050900@goop.org>
Date: Sun, 14 Jul 2013 12:23:37 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130625 Thunderbird/17.0.7
MIME-Version: 1.0
To: Ramkumar Ramachandra <artagnon@gmail.com>
CC: LKML <linux-kernel@vger.kernel.org>, Andi Kleen <ak@linux.intel.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
        Eli Friedman <eli.friedman@gmail.com>,
        Jim Grosbach <grosbach@apple.com>, Stephen Checkoway <s@pahtak.org>,
        LLVMdev <llvmdev@cs.uiuc.edu>
Subject: Re: [PATCH] x86/asm: avoid mnemonics without type suffix
References: <1373806562-30422-1-git-send-email-artagnon@gmail.com>
In-Reply-To: <1373806562-30422-1-git-send-email-artagnon@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(resent without HTML)

On 07/14/2013 05:56 AM, Ramkumar Ramachandra wrote:
> 1c54d77 (x86: partial unification of asm-x86/bitops.h, 2008-01-30)
> changed a bunch of btrl/btsl instructions to btr/bts, with the following
> justification:
>
>   The inline assembly for the bit operations has been changed to remove
>   explicit sizing hints on the instructions, so the assembler will pick
>   the appropriate instruction forms depending on the architecture and
>   the context.
>
> Unfortunately, GNU as does no such thing, and the AT&T syntax manual
> [1] contains no references to any such inference.  As evidenced by the
> following experiment, gas always disambiguates btr/bts to btrl/btsl.
> Feed the following input to gas:
>
>   btrl	$1, 0
>   btr	$1, 0
>   btsl	$1, 0
>   bts	$1, 0

When I originally did those patches, I was careful make sure that we
didn't give implied sizes to operations with only immediate and/or
memory operands because - in general - gas can't infer the operation
size from such operands. However, in the case of the bit test/set
operations, the memory access size is not really derived from the
operation size (the SDM is a bit vague), and even if it were it would be
an operation rather than semantic difference.  So there's no real
problem with gas choosing 'l' as a default size in the absence of any
explicit override or constraint.

> Check that btr matches btrl, and bts matches btsl in both cases:
>
>   $ as --32 -a in.s
>   $ as --64 -a in.s
>
> To avoid giving readers the illusion of such an inference, and for
> clarity, change btr/bts back to btrl/btsl.  Also, llvm-mc refuses to
> disambiguate btr/bts automatically.

That sounds reasonable for all other operations because it makes a real
semantic difference, but overly strict for bit operations.

    J


> [1]: http://docs.oracle.com/cd/E19253-01/817-5477/817-5477.pdf
>
> Cc: Jeremy Fitzhardinge <jeremy@goop.org>
> Cc: Andi Kleen <ak@linux.intel.com>
> Cc: Linus Torvalds <torvalds@linux-foundation.org>
> Cc: Ingo Molnar <mingo@kernel.org>
> Cc: Thomas Gleixner <tglx@linutronix.de>
> Cc: Eli Friedman <eli.friedman@gmail.com>
> Cc: Jim Grosbach <grosbach@apple.com>
> Cc: Stephen Checkoway <s@pahtak.org>
> Cc: LLVMdev <llvmdev@cs.uiuc.edu>
> Signed-off-by: Ramkumar Ramachandra <artagnon@gmail.com>
> ---
>  We discussed this pretty extensively on LLVMDev, but I'm still not
>  sure that I haven't missed something.
>
>  arch/x86/include/asm/bitops.h | 16 ++++++++--------
>  arch/x86/include/asm/percpu.h |  2 +-
>  2 files changed, 9 insertions(+), 9 deletions(-)
>
> diff --git a/arch/x86/include/asm/bitops.h b/arch/x86/include/asm/bitops.h
> index 6dfd019..6ed3d1e 100644
> --- a/arch/x86/include/asm/bitops.h
> +++ b/arch/x86/include/asm/bitops.h
> @@ -67,7 +67,7 @@ set_bit(unsigned int nr, volatile unsigned long *addr)
>  			: "iq" ((u8)CONST_MASK(nr))
>  			: "memory");
>  	} else {
> -		asm volatile(LOCK_PREFIX "bts %1,%0"
> +		asm volatile(LOCK_PREFIX "btsl %1,%0"
>  			: BITOP_ADDR(addr) : "Ir" (nr) : "memory");
>  	}
>  }
> @@ -83,7 +83,7 @@ set_bit(unsigned int nr, volatile unsigned long *addr)
>   */
>  static inline void __set_bit(int nr, volatile unsigned long *addr)
>  {
> -	asm volatile("bts %1,%0" : ADDR : "Ir" (nr) : "memory");
> +	asm volatile("btsl %1,%0" : ADDR : "Ir" (nr) : "memory");
>  }
>  
>  /**
> @@ -104,7 +104,7 @@ clear_bit(int nr, volatile unsigned long *addr)
>  			: CONST_MASK_ADDR(nr, addr)
>  			: "iq" ((u8)~CONST_MASK(nr)));
>  	} else {
> -		asm volatile(LOCK_PREFIX "btr %1,%0"
> +		asm volatile(LOCK_PREFIX "btrl %1,%0"
>  			: BITOP_ADDR(addr)
>  			: "Ir" (nr));
>  	}
> @@ -126,7 +126,7 @@ static inline void clear_bit_unlock(unsigned nr, volatile unsigned long *addr)
>  
>  static inline void __clear_bit(int nr, volatile unsigned long *addr)
>  {
> -	asm volatile("btr %1,%0" : ADDR : "Ir" (nr));
> +	asm volatile("btrl %1,%0" : ADDR : "Ir" (nr));
>  }
>  
>  /*
> @@ -198,7 +198,7 @@ static inline int test_and_set_bit(int nr, volatile unsigned long *addr)
>  {
>  	int oldbit;
>  
> -	asm volatile(LOCK_PREFIX "bts %2,%1\n\t"
> +	asm volatile(LOCK_PREFIX "btsl %2,%1\n\t"
>  		     "sbb %0,%0" : "=r" (oldbit), ADDR : "Ir" (nr) : "memory");
>  
>  	return oldbit;
> @@ -230,7 +230,7 @@ static inline int __test_and_set_bit(int nr, volatile unsigned long *addr)
>  {
>  	int oldbit;
>  
> -	asm("bts %2,%1\n\t"
> +	asm("btsl %2,%1\n\t"
>  	    "sbb %0,%0"
>  	    : "=r" (oldbit), ADDR
>  	    : "Ir" (nr));
> @@ -249,7 +249,7 @@ static inline int test_and_clear_bit(int nr, volatile unsigned long *addr)
>  {
>  	int oldbit;
>  
> -	asm volatile(LOCK_PREFIX "btr %2,%1\n\t"
> +	asm volatile(LOCK_PREFIX "btrl %2,%1\n\t"
>  		     "sbb %0,%0"
>  		     : "=r" (oldbit), ADDR : "Ir" (nr) : "memory");
>  
> @@ -276,7 +276,7 @@ static inline int __test_and_clear_bit(int nr, volatile unsigned long *addr)
>  {
>  	int oldbit;
>  
> -	asm volatile("btr %2,%1\n\t"
> +	asm volatile("btrl %2,%1\n\t"
>  		     "sbb %0,%0"
>  		     : "=r" (oldbit), ADDR
>  		     : "Ir" (nr));
> diff --git a/arch/x86/include/asm/percpu.h b/arch/x86/include/asm/percpu.h
> index 0da5200..fda54c9 100644
> --- a/arch/x86/include/asm/percpu.h
> +++ b/arch/x86/include/asm/percpu.h
> @@ -490,7 +490,7 @@ do {									\
>  #define x86_test_and_clear_bit_percpu(bit, var)				\
>  ({									\
>  	int old__;							\
> -	asm volatile("btr %2,"__percpu_arg(1)"\n\tsbbl %0,%0"		\
> +	asm volatile("btrl %2,"__percpu_arg(1)"\n\tsbbl %0,%0"		\
>  		     : "=r" (old__), "+m" (var)				\
>  		     : "dIr" (bit));					\
>  	old__;								\

