Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932642AbaGAOO6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jul 2014 10:14:58 -0400
Received: from mail-lb0-f179.google.com ([209.85.217.179]:36853 "EHLO
	mail-lb0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932620AbaGAOOz convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jul 2014 10:14:55 -0400
MIME-Version: 1.0
In-Reply-To: <20140701105250.GI5192@chrystal.home>
References: <CA+5PVA70nFS8JZkL0-Q-1HjFHT5NA04275_M4WstjQMrpT+hrQ@mail.gmail.com>
 <e09c499eade6fc321266dd6b54da7beb28d6991c.1403558229.git.luto@amacapital.net> <20140701105250.GI5192@chrystal.home>
From: Andy Lutomirski <luto@amacapital.net>
Date: Tue, 1 Jul 2014 07:14:33 -0700
Message-ID: <CALCETrU5KWZniGmP-Fo64pzWNOnFu1B0DRhuwrKWguHw8LHFiA@mail.gmail.com>
Subject: Re: [PATCH] x86_32,entry: Do syscall exit work on badsys (CVE-2014-4508)
To: Quentin Casasnovas <quentin.casasnovas@oracle.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Richard Weinberger <richard@nod.at>,
        X86 ML <x86@kernel.org>, Eric Paris <eparis@redhat.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        "security@kernel.org" <security@kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>, Borislav Petkov <bp@alien8.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 1, 2014 at 3:52 AM, Quentin Casasnovas
<quentin.casasnovas@oracle.com> wrote:
> On Mon, Jun 23, 2014 at 02:22:15PM -0700, Andy Lutomirski wrote:
>> The bad syscall nr paths are their own incomprehensible route
>> through the entry control flow.  Rearrange them to work just like
>> syscalls that return -ENOSYS.
>>
>> This fixes an OOPS in the audit code when fast-path auditing is
>> enabled and sysenter gets a bad syscall nr (CVE-2014-4508).
>>
>> This has probably been broken since Linux 2.6.27:
>> af0575bba0 i386 syscall audit fast-path
>>
>> Cc: stable@vger.kernel.org
>> Cc: Roland McGrath <roland@redhat.com>
>> Reported-by: Toralf Förster <toralf.foerster@gmx.de>
>> Signed-off-by: Andy Lutomirski <luto@amacapital.net>
>> ---
>>
>> I realize that the syscall audit fast path and badsys code, on 32-bit
>> x86 no less, is possibly one of the least fun things in the kernel to
>> review, but this is still a real security bug and should get fixed :(
>>
>> So I'm cc-ing a bunch of people and maybe someone will review it.
>>
>>  arch/x86/kernel/entry_32.S | 10 ++++++++--
>>  1 file changed, 8 insertions(+), 2 deletions(-)
>>
>> diff --git a/arch/x86/kernel/entry_32.S b/arch/x86/kernel/entry_32.S
>> index a2a4f46..f4258a5 100644
>> --- a/arch/x86/kernel/entry_32.S
>> +++ b/arch/x86/kernel/entry_32.S
>> @@ -431,9 +431,10 @@ sysenter_past_esp:
>>       jnz sysenter_audit
>>  sysenter_do_call:
>>       cmpl $(NR_syscalls), %eax
>> -     jae syscall_badsys
>> +     jae sysenter_badsys
>>       call *sys_call_table(,%eax,4)
>>       movl %eax,PT_EAX(%esp)
>> +sysenter_after_call:
>>       LOCKDEP_SYS_EXIT
>>       DISABLE_INTERRUPTS(CLBR_ANY)
>>       TRACE_IRQS_OFF
>> @@ -688,7 +689,12 @@ END(syscall_fault)
>>
>>  syscall_badsys:
>>       movl $-ENOSYS,PT_EAX(%esp)
>> -     jmp resume_userspace
>> +     jmp syscall_exit
>
> We're workig on preparing Ksplice updates for the last Fedora20 released
> kernel and stumbled on this patch.
>
> Apologies in advance if this is obvious, but would you mind explaining why
> the above change in 'syscall_badsys' is required? We're just concerned
> about doing the absolute minimum changes here if we can.

The audit code expects entry and exit hooks to match up correctly.
Without this fix, a bad syscall nr would call the entry hooks and then
return to userspace without calling the exit hooks, causing an oops on
the next syscall entry.

This is trivial to reproduce: just do 'auditctl -e 1' and then do syscall(1000).

>
>> +END(syscall_badsys)
>> +
>> +sysenter_badsys:
>> +     movl $-ENOSYS,PT_EAX(%esp)
>> +     jmp sysenter_after_call
>>  END(syscall_badsys)
>
> Although it probably doesn't hurt, you may want to change the above
> 'END(syscall_badsys)' to 'END(sysenter_badsys)'.

That's embarrassing.  Thanks.

--Andy

>
> Thanks,
> Quentin



-- 
Andy Lutomirski
AMA Capital Management, LLC
