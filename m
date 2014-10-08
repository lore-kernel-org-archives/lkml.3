Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753954AbaJHGv6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Oct 2014 02:51:58 -0400
Received: from mail-lb0-f170.google.com ([209.85.217.170]:35040 "EHLO
	mail-lb0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751056AbaJHGv4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Oct 2014 02:51:56 -0400
MIME-Version: 1.0
In-Reply-To: <20141007134349.GR24725@leverpostej>
References: <1412685628-27178-1-git-send-email-achandran@mvista.com>
	<20141007134349.GR24725@leverpostej>
Date: Wed, 8 Oct 2014 12:21:54 +0530
Message-ID: <CAFdej01hex6aeNNjdA1uDodEQ-d=JhsoqFJHkPvnKY+xbzZmxw@mail.gmail.com>
Subject: Re: [PATCH v1] Arm64: ASLR: fix text randomization
From: Arun Chandran <achandran@mvista.com>
To: Mark Rutland <mark.rutland@arm.com>
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
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Mark,

On Tue, Oct 7, 2014 at 7:13 PM, Mark Rutland <mark.rutland@arm.com> wrote:
>
> On Tue, Oct 07, 2014 at 01:40:28PM +0100, Arun Chandran wrote:
> > This is due to incorrect definition of ELF_ET_DYN_BASE. It
> > introduces randomization for text even if user does a "echo 0 >
> > /proc/sys/kernel/randomize_va_space"
>
> Interesting.
>
> It looks like this was a copy of what powerpc and s390 do (authors
> Cc'd), and the generic support came later. powerpc gained support in
> 501cb16d3cfdcca9 (powerpc: Randomise PIEs), but the generic support was
> enabled later in e39f560239984c30 (fs: binfmt_elf: create Kconfig
> variable for PIE randomization).
>

I did not understand why they need a special architecture randomize_et_dyn()
function to handle the situation.

I have tested PIE on arm and x86 (which don't have a randomize_et_dyn()) and
it works as expected.

>
> The policy of disabling PIE randomization was added in a3defbe5c337dbc6
> (binfmt_elf: fix PIE execution with randomization disabled), after the
> powerpc implementation, but before the x86 implementation was made
> generic.

Thought about extending the policy(a3defbe5c337dbc6) to arm64 by doing

#############
diff --git a/arch/arm64/include/asm/elf.h b/arch/arm64/include/asm/elf.h
index 01d3aab..401b1e8 100644
--- a/arch/arm64/include/asm/elf.h
+++ b/arch/arm64/include/asm/elf.h
@@ -127,6 +127,7 @@ typedef struct user_fpsimd_state elf_fpregset_t;
  */
 extern unsigned long randomize_et_dyn(unsigned long base);
 #define ELF_ET_DYN_BASE        (randomize_et_dyn(2 * TASK_SIZE_64 / 3))
+#define ARM64_ELF_ET_CONST_BASE                (2 * TASK_SIZE_64 / 3)

 /*
  * When the program starts, a1 contains a pointer to a function to be
diff --git a/arch/arm64/kernel/process.c b/arch/arm64/kernel/process.c
index 29d4869..5115f80 100644
--- a/arch/arm64/kernel/process.c
+++ b/arch/arm64/kernel/process.c
@@ -406,5 +406,8 @@ unsigned long arch_randomize_brk(struct mm_struct *mm)

 unsigned long randomize_et_dyn(unsigned long base)
 {
-       return randomize_base(base);
+       if (current->flags & PF_RANDOMIZE)
+               return randomize_base(base);
+       else
+               return ARM64_ELF_ET_CONST_BASE;
 }
##############

then discarded it after seeing the same thing works on x86 and arm.
In arm64(and in ppc and s390) why we need a special randomize_et_dyn()?

>
>
> I wasn't able to spot where the randomness came from in the
> ARCH_BINFMT_ELF_RANDOMIZE_PIE case, so it's not clear to me if the
> generic implementation behaves identically other than disabling
> randomization when told to via proc.

I also don't know from where it is coming; but it works on arm and x86 :)
>
>
> Assuming it behaves similarly enough, it looks like arm64, powerpc, and
> s390 should all be moved over.
>
> >
> > Signed-off-by: Arun Chandran <achandran@mvista.com>
> > ---
> > This can be tested using the code below
> >
> > #include <stdio.h>
> >
> > int main(int argc, char *argv)
> > {
> >     printf("main = %p\n", main);
> >     return 0;
> > }
> >
> > * compile it possition independently
> >   aarch64-linux-gnu-gcc -fPIE -pie aslr.c -o aslr
> >
> > * run it on the target
> >
> >       # ./aslr
> >       main = 0x7f87138950
> >       # ./aslr
> >       main = 0x7f94a10950
> >       # ./aslr
> >       main = 0x7f94fee950
> >       # ./aslr text
> >       main = 0x7f8cb72950
> >
> >       # echo 0 > /proc/sys/kernel/randomize_va_space
> >       # ./aslr text
> >       main = 0x5555555950
> >       # ./aslr
> >       main = 0x5555555950
> >       # ./aslr
> >       main = 0x5555555950
> >       # ./aslr
> >       main = 0x5555555950
>
> It would be worth pointing out that this is after your patch is applied.
> Before your patch I get randomized VAs even after writing 0 to
> randomize_va_spave.

Ok.

--Arun
