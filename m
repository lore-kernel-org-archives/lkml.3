Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751444AbaHJPAt (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Aug 2014 11:00:49 -0400
Received: from mx1.redhat.com ([209.132.183.28]:15597 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750986AbaHJPAq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Aug 2014 11:00:46 -0400
Message-ID: <53E7890F.4070109@redhat.com>
Date: Sun, 10 Aug 2014 17:00:31 +0200
From: Denys Vlasenko <dvlasenk@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Andy Lutomirski <luto@amacapital.net>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Oleg Nesterov <oleg@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, X86 ML <x86@kernel.org>,
        Alexei Starovoitov <ast@plumgrid.com>, Will Drewry <wad@chromium.org>,
        Kees Cook <keescook@chromium.org>
Subject: Re: [PATCH 17/17] x86: simplify iret stack handling on SYSCALL64
 fastpath
References: <1407519880-6719-1-git-send-email-dvlasenk@redhat.com> <1407519880-6719-18-git-send-email-dvlasenk@redhat.com> <CALCETrXDjOPR9kEwx9fJFFz=A1jRKPBbfpoe8XztchktrUaz0Q@mail.gmail.com>
In-Reply-To: <CALCETrXDjOPR9kEwx9fJFFz=A1jRKPBbfpoe8XztchktrUaz0Q@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/09/2014 12:59 AM, Andy Lutomirski wrote:
> On Sat, Aug 9, 2014 at 2:44 AM, Denys Vlasenko <dvlasenk@redhat.com> wrote:
>> Before this patch, rcx and r11 were saved in pt_regs->rcx
>> and pt_regs->r11. Which looks natural, but requires messy
>> shuffling to/from iret stack whenever ptrace or e.g. iopl
>> wants to modify return address or flags - because that's
>> how these registers are used by SYSCALL/SYSRET.
>>
>> This patch saves rcx and r11 in pt_regs->rip and pt_regs->flags,
>> and uses these values for SYSRET64 insn. Shuffling is eliminated.
>>
>> On slow path, the values are saved in both locations - thus, ptrace
>> can modify rcx, and on syscall exit rcx will be different from
>> return address... don't see why that can be useful but anyway,
>> it works.
>>
>> The lazy store of pt_regs->cs and pt_regs->ss is retained -
>> tests have shown that these insns do take ~2 cycles on fast path.
>>
>> FIXUP_TOP_OF_STACK and RESTORE_TOP_OF_STACK macros are replaced
>> by a simpler single macro, STORE_IRET_FRAME_CS_SS.
>>
>> stub_iopl is no longer needed: pt_regs->flags needs no fixing up.
>>
>> PER_CPU(old_rsp) usage is simplified - now it is used only
>> as temp storage, and userspace stack pointer is immediately stored
>> in pt_regs->sp on syscall entry, instead of being used later,
>> on syscall exit. This allows to get rid of thread_struct::usersp.
>>
>> Testing shows that syscall fast path is ~54.3 ns before
>> and after the patch (on 2.7 GHz Sandy Bridge CPU).
>>
>> Signed-off-by: Denys Vlasenko <dvlasenk@redhat.com>
>> CC: Linus Torvalds <torvalds@linux-foundation.org>
>> CC: Oleg Nesterov <oleg@redhat.com>
>> CC: "H. Peter Anvin" <hpa@zytor.com>
>> CC: Andy Lutomirski <luto@amacapital.net>
>> CC: Frederic Weisbecker <fweisbec@gmail.com>
>> CC: X86 ML <x86@kernel.org>
>> CC: Alexei Starovoitov <ast@plumgrid.com>
>> CC: Will Drewry <wad@chromium.org>
>> CC: Kees Cook <keescook@chromium.org>
>> CC: linux-kernel@vger.kernel.org
>> ---
>>  arch/x86/include/asm/calling.h   |  18 +++--
>>  arch/x86/include/asm/compat.h    |   2 +-
>>  arch/x86/include/asm/processor.h |   1 -
>>  arch/x86/include/asm/ptrace.h    |   8 +--
>>  arch/x86/kernel/entry_64.S       | 140 +++++++++++++++++----------------------
>>  arch/x86/kernel/process_64.c     |   8 +--
>>  arch/x86/syscalls/syscall_64.tbl |   2 +-
>>  arch/x86/um/sys_call_table_64.c  |   2 +-
>>  8 files changed, 78 insertions(+), 103 deletions(-)
>>
>> diff --git a/arch/x86/include/asm/calling.h b/arch/x86/include/asm/calling.h
>> index aa9113e..7afbcea 100644
>> --- a/arch/x86/include/asm/calling.h
>> +++ b/arch/x86/include/asm/calling.h
>> @@ -95,7 +95,7 @@ For 32-bit we have the following conventions - kernel is built with
>>         CFI_ADJUST_CFA_OFFSET 15*8+\addskip
>>         .endm
>>
>> -       .macro SAVE_C_REGS_HELPER offset=0 rcx=1 r8plus=1
>> +       .macro SAVE_C_REGS_HELPER offset=0 rcx=1 r8910=1 r11=1
>>         movq_cfi rdi, 14*8+\offset
>>         movq_cfi rsi, 13*8+\offset
>>         movq_cfi rdx, 12*8+\offset
>> @@ -103,21 +103,26 @@ For 32-bit we have the following conventions - kernel is built with
>>         movq_cfi rcx, 11*8+\offset
>>         .endif
>>         movq_cfi rax, 10*8+\offset
>> -       .if \r8plus
>> +       .if \r8910
>>         movq_cfi r8,  9*8+\offset
>>         movq_cfi r9,  8*8+\offset
>>         movq_cfi r10, 7*8+\offset
>> +       .endif
>> +       .if \r11
>>         movq_cfi r11, 6*8+\offset
>>         .endif
>>         .endm
>>         .macro SAVE_C_REGS offset=0
>> -       SAVE_C_REGS_HELPER \offset, 1, 1
>> +       SAVE_C_REGS_HELPER \offset, 1, 1, 1
>>         .endm
>>         .macro SAVE_C_REGS_EXCEPT_R891011
>> -       SAVE_C_REGS_HELPER 0, 1, 0
>> +       SAVE_C_REGS_HELPER 0, 1, 0, 0
>>         .endm
>>         .macro SAVE_C_REGS_EXCEPT_RCX_R891011
>> -       SAVE_C_REGS_HELPER 0, 0, 0
>> +       SAVE_C_REGS_HELPER 0, 0, 0, 0
>> +       .endm
>> +       .macro SAVE_C_REGS_EXCEPT_RCX_R11
>> +       SAVE_C_REGS_HELPER 0, 0, 1, 0
>>         .endm
>>
>>         .macro SAVE_EXTRA_REGS offset=0
>> @@ -171,6 +176,9 @@ For 32-bit we have the following conventions - kernel is built with
>>         .macro RESTORE_C_REGS_EXCEPT_RCX
>>         RESTORE_C_REGS_HELPER 1,0,1,1,1
>>         .endm
>> +       .macro RESTORE_C_REGS_EXCEPT_RCX_R11
>> +       RESTORE_C_REGS_HELPER 1,0,0,1,1
>> +       .endm
>>         .macro RESTORE_RSI_RDI
>>         RESTORE_C_REGS_HELPER 0,0,0,0,0
>>         .endm
>> diff --git a/arch/x86/include/asm/compat.h b/arch/x86/include/asm/compat.h
>> index 59c6c40..acdee09 100644
>> --- a/arch/x86/include/asm/compat.h
>> +++ b/arch/x86/include/asm/compat.h
>> @@ -301,7 +301,7 @@ static inline void __user *arch_compat_alloc_user_space(long len)
>>                 sp = task_pt_regs(current)->sp;
>>         } else {
>>                 /* -128 for the x32 ABI redzone */
>> -               sp = this_cpu_read(old_rsp) - 128;
>> +               sp = task_pt_regs(current)->sp - 128;
>>         }
>>
>>         return (void __user *)round_down(sp - len, 16);
>> diff --git a/arch/x86/include/asm/processor.h b/arch/x86/include/asm/processor.h
>> index a4ea023..33c86c6 100644
>> --- a/arch/x86/include/asm/processor.h
>> +++ b/arch/x86/include/asm/processor.h
>> @@ -474,7 +474,6 @@ struct thread_struct {
>>  #ifdef CONFIG_X86_32
>>         unsigned long           sysenter_cs;
>>  #else
>> -       unsigned long           usersp; /* Copy from PDA */
>>         unsigned short          es;
>>         unsigned short          ds;
>>         unsigned short          fsindex;
>> diff --git a/arch/x86/include/asm/ptrace.h b/arch/x86/include/asm/ptrace.h
>> index c822b35..271c779 100644
>> --- a/arch/x86/include/asm/ptrace.h
>> +++ b/arch/x86/include/asm/ptrace.h
>> @@ -140,12 +140,8 @@ static inline bool user_64bit_mode(struct pt_regs *regs)
>>  #endif
>>  }
>>
>> -#define current_user_stack_pointer()   this_cpu_read(old_rsp)
>> -/* ia32 vs. x32 difference */
>> -#define compat_user_stack_pointer()    \
>> -       (test_thread_flag(TIF_IA32)     \
>> -        ? current_pt_regs()->sp        \
>> -        : this_cpu_read(old_rsp))
>> +#define current_user_stack_pointer()   current_pt_regs()->sp
>> +#define compat_user_stack_pointer()    current_pt_regs()->sp
>>  #endif
>>
>>  #ifdef CONFIG_X86_32
>> diff --git a/arch/x86/kernel/entry_64.S b/arch/x86/kernel/entry_64.S
>> index 5d639a6..efe9780 100644
>> --- a/arch/x86/kernel/entry_64.S
>> +++ b/arch/x86/kernel/entry_64.S
>> @@ -24,8 +24,6 @@
>>   * - CFI macros are used to generate dwarf2 unwind information for better
>>   * backtraces. They don't change any code.
>>   * - ENTRY/END Define functions in the symbol table.
>> - * - FIXUP_TOP_OF_STACK/RESTORE_TOP_OF_STACK - Fix up the hardware stack
>> - * frame that is otherwise undefined after a SYSCALL
>>   * - TRACE_IRQ_* - Trace hard interrupt state for lock debugging.
>>   * - idtentry - Define exception entry points.
>>   */
>> @@ -121,29 +119,13 @@ ENDPROC(native_usergs_sysret64)
>>  #endif
>>
>>  /*
>> - * C code is not supposed to know about undefined top of stack. Every time
>> - * a C function with an pt_regs argument is called from the SYSCALL based
>> - * fast path FIXUP_TOP_OF_STACK is needed.
>> - * RESTORE_TOP_OF_STACK syncs the syscall state after any possible ptregs
>> - * manipulation.
>> + * struct pt_regs is not fully populated on the fast path
>> + * (rcx, r11, cs and ss are not filled in).
>> + * This macro populates segment registers in iret frame.
>>   */
>> -
>> -       /* %rsp:at FRAMEEND */
>> -       .macro FIXUP_TOP_OF_STACK tmp offset=0
>> -       movq PER_CPU_VAR(old_rsp),\tmp
>> -       movq \tmp,RSP+\offset(%rsp)
>> -       movq $__USER_DS,SS+\offset(%rsp)
>> -       movq $__USER_CS,CS+\offset(%rsp)
>> -       movq $-1,RCX+\offset(%rsp)
>> -       movq R11+\offset(%rsp),\tmp  /* get eflags */
>> -       movq \tmp,EFLAGS+\offset(%rsp)
>> -       .endm
>> -
>> -       .macro RESTORE_TOP_OF_STACK tmp offset=0
>> -       movq RSP+\offset(%rsp),\tmp
>> -       movq \tmp,PER_CPU_VAR(old_rsp)
>> -       movq EFLAGS+\offset(%rsp),\tmp
>> -       movq \tmp,R11+\offset(%rsp)
>> +       .macro STORE_IRET_FRAME_CS_SS offset=0
>> +       movq    $__USER_CS,CS+\offset(%rsp)
>> +       movq    $__USER_DS,SS+\offset(%rsp)
>>         .endm
>>
>>  /*
>> @@ -226,12 +208,16 @@ ENDPROC(native_usergs_sysret64)
>>   * Interrupts are off on entry.
>>   * Only called from user space.
>>   *
>> - * XXX if we had a free scratch register we could save the RSP into the stack frame
>> - *      and report it properly in ps. Unfortunately we haven't.
>> - *
>>   * When user can change the frames always force IRET. That is because
>>   * it deals with uncanonical addresses better. SYSRET has trouble
>>   * with them due to bugs in both AMD and Intel CPUs.
>> + *
>> + * When returning through fast path, userspace sees rcx = return address,
>> + * r11 = rflags. When returning through iret (e.g. if audit is active),
>> + * these registers may contain garbage.
>> + * For ptrace we manage to avoid that: when we hit slow path on entry,
>> + * we do save rcx and r11 in pt_regs, so ptrace on exit also sees them.
>> + * If slow path is entered only on exit, there will be garbage.
> 
> I don't like this.  At least the current code puts something
> deterministic in there (-1) for the slow path, even though it's wrong
> and makes the slow path behave visibly differently from the fast path.
> 
> Leaking uninitialized data here is extra bad, though.  Keep in mind
> that, when a syscall entry is interrupted before fully setting up
> pt_regs, the interrupt frame overlaps task_pt_regs, so it's possible,
> depending on the stack slot ordering, for a kernel secret
> (kernel_stack?) to end up somewhere in task_pt_regs.

It's easy to fix. We jump off fast path to slow path here:

        movl TI_flags+THREAD_INFO(%rsp,SIZEOF_PTREGS),%edx
        andl %edi,%edx
        jnz  sysret_careful

This is the only use of "sysret_careful" label.
Therefore, there we don't need to think about any other scenarios
besides "we are returning from syscall here".

My patch only fixes up segment regs:

 	/* Handle reschedules */
 	/* edx:	work, edi: workmask */
 sysret_careful:
+	STORE_IRET_FRAME_CS_SS
 	bt $TIF_NEED_RESCHED,%edx

pt_regs->rcx and ->r11 aren't initialized.

We can fix that e.g. by adding here four more insns:

        movq    RIP(%rsp),%rcx
        movq    %rcx,RCX(%rsp)
        movq    EFLAGS(%rsp),%rcx
        movq    %rcx,R11(%rsp)

similar to what my patch did on slow path on entry (see changes at
"tracesys" label).

Or we can just bite the bullet and save rcx and r11 on fast path
(there it will require just two insns). +2 cycles on most CPUs.

