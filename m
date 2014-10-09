Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758398AbaJIVm5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Oct 2014 17:42:57 -0400
Received: from mail-ig0-f169.google.com ([209.85.213.169]:34759 "EHLO
	mail-ig0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756036AbaJIVmy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Oct 2014 17:42:54 -0400
Message-ID: <5437015B.3010205@gmail.com>
Date: Thu, 09 Oct 2014 14:42:51 -0700
From: David Daney <ddaney.cavm@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130625 Thunderbird/17.0.7
MIME-Version: 1.0
To: Leonid Yegoshin <Leonid.Yegoshin@imgtec.com>
CC: linux-mips@linux-mips.org, Zubair.Kakakhel@imgtec.com,
        geert+renesas@glider.be, david.daney@cavium.com, peterz@infradead.org,
        paul.gortmaker@windriver.com, davidlohr@hp.com, macro@linux-mips.org,
        chenhc@lemote.com, richard@nod.at, zajec5@gmail.com,
        james.hogan@imgtec.com, keescook@chromium.org, alex@alex-smith.me.uk,
        tglx@linutronix.de, blogic@openwrt.org, jchandra@broadcom.com,
        paul.burton@imgtec.com, qais.yousef@imgtec.com,
        linux-kernel@vger.kernel.org, ralf@linux-mips.org,
        markos.chandras@imgtec.com, dengcheng.zhu@imgtec.com,
        manuel.lauss@gmail.com, akpm@linux-foundation.org,
        lars.persson@axis.com
Subject: Re: [PATCH v2 0/3] MIPS executable stack protection
References: <20141009195030.31230.58695.stgit@linux-yegoshin>
In-Reply-To: <20141009195030.31230.58695.stgit@linux-yegoshin>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/09/2014 01:00 PM, Leonid Yegoshin wrote:
> The following series implements an executable stack protection in MIPS.
>
> It sets up a per-thread 'VDSO' page and appropriate TLB support.
> Page is set write-protected from user and is maintained via kernel VA.
> MIPS FPU emulation is shifted to new page and stack is relieved for
> execute protection as is as all data pages in default setup during ELF
> binary initialization. The real protection is controlled by GLIBC and
> it can do stack protected now as it is done in other architectures and
> I learned today that GLIBC team is ready for this.

What does it mean to be 'ready'?  If they committed patches before there 
was kernel support, that it putting the cart before the horse.  GlibC's 
state cannot be used as valid reason for committing major kernel 
changes.  There would be no regression in any GLibC based system as a 
result of not merging this patch.

>
> Note: actual execute-protection depends from HW capability, of course.
>
> This patch is required for MIPS32/64 R2 emulation on MIPS R6 architecture.
> Without it 'ssh-keygen' crashes pretty fast on attempt to execute instruction
> in stack.

There is much more blocking MIPS32/64 R2 emulation on MIPS R6 than just 
this patch isn't there?

Also, if you are supporting MIPS R6, this patch doesn't even work, 
because it doesn't handle PC relative instructions at all.

>
> v2 changes:
>      - Added an optimization during mmap switch - doesn't switch if the same
>        thread is rescheduled and other threads don't intervene (Peter Zijlstra)
>      - Fixed uMIPS support (Paul Burton)
>      - Added unwinding of VDSO emulation stack at signal handler invocation,
>        hiding an emulation page (Andy Lutomirski note in other patch comments)
>
> ---
>
> Leonid Yegoshin (3):
>        MIPS: mips_flush_cache_range is added
>        MIPS: Setup an instruction emulation in VDSO protected page instead of user stack
>        MIPS: set stack/data protection as non-executable
>

The recent discussions on this subject, including many comments from 
Imgtec e-mail addresses, brought to light the need to use an instruction 
set emulator for newer MIPSr6 ISA processors.

In light of this, why does it make sense to merge this patch, instead of 
taking the approach of emulating the instructions in the delay slot?

David Daney


>
>   arch/mips/include/asm/cacheflush.h   |    3 +
>   arch/mips/include/asm/fpu_emulator.h |    2
>   arch/mips/include/asm/mmu.h          |    3 +
>   arch/mips/include/asm/page.h         |    2
>   arch/mips/include/asm/processor.h    |    2
>   arch/mips/include/asm/switch_to.h    |   14 +++
>   arch/mips/include/asm/thread_info.h  |    3 +
>   arch/mips/include/asm/tlbmisc.h      |    1
>   arch/mips/include/asm/vdso.h         |    3 +
>   arch/mips/kernel/process.c           |    7 ++
>   arch/mips/kernel/signal.c            |    4 +
>   arch/mips/kernel/vdso.c              |   41 +++++++++
>   arch/mips/math-emu/cp1emu.c          |    8 +-
>   arch/mips/math-emu/dsemul.c          |  153 ++++++++++++++++++++++++++++------
>   arch/mips/mm/c-octeon.c              |    8 ++
>   arch/mips/mm/c-r3k.c                 |    8 ++
>   arch/mips/mm/c-r4k.c                 |   43 ++++++++++
>   arch/mips/mm/c-tx39.c                |    9 ++
>   arch/mips/mm/cache.c                 |    4 +
>   arch/mips/mm/fault.c                 |    5 +
>   arch/mips/mm/tlb-r4k.c               |   42 +++++++++
>   21 files changed, 333 insertions(+), 32 deletions(-)
>

