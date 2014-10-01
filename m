Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751556AbaJAAiv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Sep 2014 20:38:51 -0400
Received: from mail-la0-f48.google.com ([209.85.215.48]:39408 "EHLO
	mail-la0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751182AbaJAAiu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Sep 2014 20:38:50 -0400
MIME-Version: 1.0
In-Reply-To: <20140930192741.73144817@as>
References: <cover.1412105369.git.luto@amacapital.net> <c4b7904ef2ddd3dec27400d18bcd00badb4dcedf.1412105369.git.luto@amacapital.net>
 <20140930192741.73144817@as>
From: Andy Lutomirski <luto@amacapital.net>
Date: Tue, 30 Sep 2014 17:38:27 -0700
Message-ID: <CALCETrWSG7p_t9WLnbWUjKNzr9bP77NpE7qpqMWzhV1BBYCZeg@mail.gmail.com>
Subject: Re: [PATCH 1/2] x86_64,entry: Filter RFLAGS.NT on entry from userspace
To: Chuck Ebbert <cebbert.lkml@gmail.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, X86 ML <x86@kernel.org>,
        Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        Sebastian Lackner <sebastian@fds-team.de>,
        Anish Bhatt <anish@chelsio.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        stable@kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 30, 2014 at 5:27 PM, Chuck Ebbert <cebbert.lkml@gmail.com> wrote:
> On Tue, 30 Sep 2014 12:40:35 -0700
> Andy Lutomirski <luto@amacapital.net> wrote:
>
>> The NT flag doesn't do anything in long mode other than causing IRET
>> to #GP.  Oddly, CPL3 code can still net NT using popf.
>>
>> Entry via hardware or software interrupt clears NT automatically, so
>> the only relevant entries are fast syscalls.
>>
>> This patch programs the CPU to clear NT on entry via SYSCALL (both
>> 32-bit and 64-bit, by my reading of the AMD APM).  It also clears NT
>> (and some other flags) in software on SYSENTER.
>>
>> I haven't touched anything on 32-bit kernels.
>>
>> If user code causes kernel code to run with NT set, then there's at
>> least some (small) chance that it could cause trouble.  For example,
>> user code could cause a call to EFI code with NT set, and who knows
>> what would happen.  Apparently Wine sometimes does this (!), and, if
>> an IRET return happens, Wine will segfault.
>>
>> I think that Wine should be fixed to stop setting NT when a syscall
>> happens, but handling NT more gracefully is still nice.
>>
>> The syscall mask change comes from a variant of this patch by Anish
>> Bhatt.
>>
>> Cc: stable@kernel.org
>> Reported-by: Anish Bhatt <anish@chelsio.com>
>> Signed-off-by: Andy Lutomirski <luto@amacapital.net>
>> ---
>>  arch/x86/ia32/ia32entry.S    | 10 +++++++++-
>>  arch/x86/kernel/cpu/common.c |  2 +-
>>  2 files changed, 10 insertions(+), 2 deletions(-)
>>
>> diff --git a/arch/x86/ia32/ia32entry.S b/arch/x86/ia32/ia32entry.S
>> index 4299eb05023c..079f42a7ad58 100644
>> --- a/arch/x86/ia32/ia32entry.S
>> +++ b/arch/x86/ia32/ia32entry.S
>> @@ -143,7 +143,15 @@ ENTRY(ia32_sysenter_target)
>>       pushq_cfi %r10
>>       CFI_REL_OFFSET rip,0
>>       pushq_cfi %rax
>> -     cld
>> +
>> +     /*
>> +      * Sysenter doesn't filter flags, so we should filter them
>> +      * ourselves.
>> +      */
>> +     pushfq_cfi
>> +     andl $~(X86_EFLAGS_TF|X86_EFLAGS_DF|X86_EFLAGS_NT|X86_EFLAGS_IOPL),(%rsp)
>> +     popfq_cfi
>
> Can't you just push a constant and pop that onto flags instead? It's
> not like we care what's in there on entry to the kernel.

I don't see why not.  I'll test on Xen just to be sure.

--Andy
