Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753864AbaJGNoi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Oct 2014 09:44:38 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:56316 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751266AbaJGNoh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Oct 2014 09:44:37 -0400
Date: Tue, 7 Oct 2014 14:43:50 +0100
From: Mark Rutland <mark.rutland@arm.com>
To: Arun Chandran <achandran@mvista.com>
Cc: Catalin Marinas <Catalin.Marinas@arm.com>,
        Will Deacon <Will.Deacon@arm.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Anton Blanchard <anton@samba.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>
Subject: Re: [PATCH v1] Arm64: ASLR: fix text randomization
Message-ID: <20141007134349.GR24725@leverpostej>
References: <1412685628-27178-1-git-send-email-achandran@mvista.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1412685628-27178-1-git-send-email-achandran@mvista.com>
Thread-Topic: [PATCH v1] Arm64: ASLR: fix text randomization
Accept-Language: en-GB, en-US
Content-Language: en-US
acceptlanguage: en-GB, en-US
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 07, 2014 at 01:40:28PM +0100, Arun Chandran wrote:
> This is due to incorrect definition of ELF_ET_DYN_BASE. It
> introduces randomization for text even if user does a "echo 0 >
> /proc/sys/kernel/randomize_va_space"

Interesting.

It looks like this was a copy of what powerpc and s390 do (authors
Cc'd), and the generic support came later. powerpc gained support in
501cb16d3cfdcca9 (powerpc: Randomise PIEs), but the generic support was
enabled later in e39f560239984c30 (fs: binfmt_elf: create Kconfig
variable for PIE randomization).

The policy of disabling PIE randomization was added in a3defbe5c337dbc6
(binfmt_elf: fix PIE execution with randomization disabled), after the
powerpc implementation, but before the x86 implementation was made
generic.

I wasn't able to spot where the randomness came from in the
ARCH_BINFMT_ELF_RANDOMIZE_PIE case, so it's not clear to me if the
generic implementation behaves identically other than disabling
randomization when told to via proc.

Assuming it behaves similarly enough, it looks like arm64, powerpc, and
s390 should all be moved over.

> 
> Signed-off-by: Arun Chandran <achandran@mvista.com>
> ---
> This can be tested using the code below
> 
> #include <stdio.h>
> 
> int main(int argc, char *argv)
> {
>     printf("main = %p\n", main);
>     return 0;
> }
> 
> * compile it possition independently 
>   aarch64-linux-gnu-gcc -fPIE -pie aslr.c -o aslr
> 
> * run it on the target
> 
> 	# ./aslr
> 	main = 0x7f87138950
> 	# ./aslr
> 	main = 0x7f94a10950
> 	# ./aslr
> 	main = 0x7f94fee950
> 	# ./aslr text
> 	main = 0x7f8cb72950
> 
> 	# echo 0 > /proc/sys/kernel/randomize_va_space 
> 	# ./aslr text
> 	main = 0x5555555950
> 	# ./aslr 
> 	main = 0x5555555950
> 	# ./aslr 
> 	main = 0x5555555950
> 	# ./aslr 
> 	main = 0x5555555950

It would be worth pointing out that this is after your patch is applied.
Before your patch I get randomized VAs even after writing 0 to
randomize_va_spave.

> ---
>  arch/arm64/Kconfig           |    1 +
>  arch/arm64/include/asm/elf.h |    4 ++--
>  2 files changed, 3 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/arm64/Kconfig b/arch/arm64/Kconfig
> index fd4e81a..a2eefc9 100644
> --- a/arch/arm64/Kconfig
> +++ b/arch/arm64/Kconfig
> @@ -1,5 +1,6 @@
>  config ARM64
>  	def_bool y
> +	select ARCH_BINFMT_ELF_RANDOMIZE_PIE
>  	select ARCH_HAS_ATOMIC64_DEC_IF_POSITIVE
>  	select ARCH_HAS_SG_CHAIN
>  	select ARCH_HAS_TICK_BROADCAST if GENERIC_CLOCKEVENTS_BROADCAST
> diff --git a/arch/arm64/include/asm/elf.h b/arch/arm64/include/asm/elf.h
> index 01d3aab..1f65be3 100644
> --- a/arch/arm64/include/asm/elf.h
> +++ b/arch/arm64/include/asm/elf.h
> @@ -126,7 +126,7 @@ typedef struct user_fpsimd_state elf_fpregset_t;
>   * that it will "exec", and that there is sufficient room for the brk.
>   */
>  extern unsigned long randomize_et_dyn(unsigned long base);
> -#define ELF_ET_DYN_BASE	(randomize_et_dyn(2 * TASK_SIZE_64 / 3))
> +#define ELF_ET_DYN_BASE	(2 * TASK_SIZE_64 / 3)
>  
>  /*
>   * When the program starts, a1 contains a pointer to a function to be
> @@ -169,7 +169,7 @@ extern unsigned long arch_randomize_brk(struct mm_struct *mm);
>  #define COMPAT_ELF_PLATFORM		("v8l")
>  #endif
>  
> -#define COMPAT_ELF_ET_DYN_BASE		(randomize_et_dyn(2 * TASK_SIZE_32 / 3))
> +#define COMPAT_ELF_ET_DYN_BASE		(2 * TASK_SIZE_32 / 3)
>  
>  /* AArch32 registers. */
>  #define COMPAT_ELF_NGREG		18
> -- 
> 1.7.9.5

Given randomize_et_dyn is no longer used after this patch, I think it
should be dropped from arch/arm64/kernel/process.c.

Thanks,
Mark.
