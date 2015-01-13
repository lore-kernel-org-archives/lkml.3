Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751709AbbAMIfY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jan 2015 03:35:24 -0500
Received: from mail-wi0-f174.google.com ([209.85.212.174]:43669 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751592AbbAMIfW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jan 2015 03:35:22 -0500
MIME-Version: 1.0
In-Reply-To: <20150112183955.GO13360@arm.com>
References: <1420986751-30364-1-git-send-email-r.peniaev@gmail.com>
	<1420986751-30364-2-git-send-email-r.peniaev@gmail.com>
	<20150112183955.GO13360@arm.com>
Date: Tue, 13 Jan 2015 17:35:20 +0900
Message-ID: <CACZ9PQXW9G4Vw-dcPwkdVE=uoYmDYEQnJWDnnpup1LxC3s5QPg@mail.gmail.com>
Subject: Re: [PATCH 1/2] ARM: entry-common: fix forgotten set of thread_info->syscall
From: Roman Peniaev <r.peniaev@gmail.com>
To: Will Deacon <will.deacon@arm.com>
Cc: Russell King <linux@arm.linux.org.uk>,
        Stefano Stabellini <stefano.stabellini@eu.citrix.com>,
        Marc Zyngier <Marc.Zyngier@arm.com>,
        Catalin Marinas <Catalin.Marinas@arm.com>,
        Sekhar Nori <nsekhar@ti.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        Christoffer Dall <christoffer.dall@linaro.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 13, 2015 at 3:39 AM, Will Deacon <will.deacon@arm.com> wrote:
> On Sun, Jan 11, 2015 at 02:32:30PM +0000, Roman Pen wrote:
>> thread_info->syscall is used only for ptrace, but syscall number
>> is also used by syscall_get_nr and returned to userspace by the
>> following proc file access:
>>
>>  $ cat /proc/self/syscall
>>  0 0x3 0xbe928bd8 0x1000 0x0 0xac9e0 0x3 0xbe928bb4 0xb6f5dfbc
>>  ^
>> The first number is the syscall number, currently it is zero.
>> Patch fixes this:
>>
>>  $ cat /proc/self/syscall
>>  3 0x3 0xbefc7bd8 0x1000 0x0 0xac9e0 0x3 0xbefc7bb4 0xb6e82fbc
>>  ^
>> Right, read syscall
>
> Yes, it seems that despite requiring CONFIG_HAVE_ARCH_TRACEHOOK,
> the /proc code requires syscall_get_nr to work regardless of
> TIF_SYSCALL_TRACE.
>
>> Signed-off-by: Roman Pen <r.peniaev@gmail.com>
>> Cc: Russell King <linux@arm.linux.org.uk>
>> Cc: Marc Zyngier <marc.zyngier@arm.com>
>> Cc: Catalin Marinas <catalin.marinas@arm.com>
>> Cc: Christoffer Dall <christoffer.dall@linaro.org>
>> Cc: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
>> Cc: Sekhar Nori <nsekhar@ti.com>
>> Cc: linux-arm-kernel@lists.infradead.org
>> Cc: linux-kernel@vger.kernel.org
>> Cc: stable@vger.kernel.org
>> ---
>>  arch/arm/kernel/asm-offsets.c  | 1 +
>>  arch/arm/kernel/entry-common.S | 1 +
>>  2 files changed, 2 insertions(+)
>>
>> diff --git a/arch/arm/kernel/asm-offsets.c b/arch/arm/kernel/asm-offsets.c
>> index 2d2d608..6911bad 100644
>> --- a/arch/arm/kernel/asm-offsets.c
>> +++ b/arch/arm/kernel/asm-offsets.c
>> @@ -70,6 +70,7 @@ int main(void)
>>    DEFINE(TI_CPU,             offsetof(struct thread_info, cpu));
>>    DEFINE(TI_CPU_DOMAIN,              offsetof(struct thread_info, cpu_domain));
>>    DEFINE(TI_CPU_SAVE,                offsetof(struct thread_info, cpu_context));
>> +  DEFINE(TI_SYSCALL,         offsetof(struct thread_info, syscall));
>>    DEFINE(TI_USED_CP,         offsetof(struct thread_info, used_cp));
>>    DEFINE(TI_TP_VALUE,                offsetof(struct thread_info, tp_value));
>>    DEFINE(TI_FPSTATE,         offsetof(struct thread_info, fpstate));
>> diff --git a/arch/arm/kernel/entry-common.S b/arch/arm/kernel/entry-common.S
>> index f8ccc21..89452ff 100644
>> --- a/arch/arm/kernel/entry-common.S
>> +++ b/arch/arm/kernel/entry-common.S
>> @@ -189,6 +189,7 @@ ENTRY(vector_swi)
>>  #endif
>>
>>  local_restart:
>> +     str scno, [tsk, #TI_SYSCALL]            @ set syscall number
>>       ldr     r10, [tsk, #TI_FLAGS]           @ check for syscall tracing
>>       stmdb   sp!, {r4, r5}                   @ push fifth and sixth args
>
> Do we definitely want to update scno on syscall restarting?


Good question.

First thing to mention is __sys_trace will trace 'restart_syscall',
not the real syscall we are going to restart.

E.g. in test application we do infinite poll and then send STOP and
CONT to this app:

    test-243   [002] ...1  1792.067726: sys_enter: NR 168 (0, 0,
ffffffff, 0, 0, 0)
    test-243   [002] ...1  1802.299073: sys_exit: NR 168 = -516
    test-243   [004] ...1  1814.716264: sys_enter: NR 0 (0, 0,
ffffffff, 0, 0, 0)
    test-243   [004] ...1  2183.687225: sys_exit: NR 0 = -516

the poll was restarted and trace shows that we are in restart_syscall.

Is that expected?

And the second thing is that my next patch did some tweaks in
'syscall_trace_enter', where we take scno not from param we passed,
but from thread_info->syscall we previously set.

So, regarding your question, if I set scno only once - I will break
previous behavior, and __sys_trace will trace the syscall we restarted.

And I think this is what we need, because according to the
'syscall_trace_enter' code we do 'secure_computing' and
'audit_syscall_entry', which definitely expect original syscall, not
the 'restart_syscall'.


--
Roman
