Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932971AbaJWUbF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Oct 2014 16:31:05 -0400
Received: from mail-la0-f48.google.com ([209.85.215.48]:49715 "EHLO
	mail-la0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753498AbaJWUbC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Oct 2014 16:31:02 -0400
MIME-Version: 1.0
In-Reply-To: <1414092624.2363.13.camel@redhat.com>
References: <1414037043-30647-1-git-send-email-eparis@redhat.com>
 <54494B74.2080504@amacapital.net> <1414091732.2363.11.camel@redhat.com>
 <CALCETrWQNuGr=Sf7X4E6ZkJQ+diJao30=CeH4xd0T855TgX+rg@mail.gmail.com> <1414092624.2363.13.camel@redhat.com>
From: Andy Lutomirski <luto@amacapital.net>
Date: Thu, 23 Oct 2014 13:30:40 -0700
Message-ID: <CALCETrUNcLV1=QR_LmJhy-0Y8a6BtjYzdXH9cS1QQD5yyhnA9A@mail.gmail.com>
Subject: Re: [PATCH] i386/audit: stop scribbling on the stack frame
To: Eric Paris <eparis@redhat.com>
Cc: Richard Guy Briggs <rgb@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        X86 ML <x86@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-audit@redhat.com
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 23, 2014 at 12:30 PM, Eric Paris <eparis@redhat.com> wrote:
> On Thu, 2014-10-23 at 12:20 -0700, Andy Lutomirski wrote:
>> On Thu, Oct 23, 2014 at 12:15 PM, Eric Paris <eparis@redhat.com> wrote:
>> > On Thu, 2014-10-23 at 11:39 -0700, Andy Lutomirski wrote:
>> >> On 10/22/2014 09:04 PM, Eric Paris wrote:
>> >> > git commit b4f0d3755c5e9cc86292d5fd78261903b4f23d4a was very very dumb.
>> >> > It was writing over %esp/pt_regs semi-randomly on i686  with the expected
>> >> > "system can't boot" results.  As noted in:
>> >> >
>> >> > https://bugs.freedesktop.org/show_bug.cgi?id=85277
>> >> >
>> >> > This patch stops fscking with pt_regs.  Instead it sets up the registers
>> >> > for the call to __audit_syscall_entry in the most obvious conceivable
>> >> > way.  It then does just a tiny tiny touch of magic.  We need to get what
>> >> > started in PT_EDX into 0(%esp) and PT_ESI into 4(%esp).  This is as easy
>> >> > as a pair of pushes.
>> >> >
>> >> > After the call to __audit_syscall_entry all we need to do is get that
>> >> > now useless junk off the stack (pair of pops) and reload %eax with the
>> >> > original syscall so other stuff can keep going about it's business.
>> >> >
>> >> > Signed-off-by: Eric Paris <eparis@redhat.com>
>> >> > Cc: Thomas Gleixner <tglx@linutronix.de>
>> >> > Cc: Ingo Molnar <mingo@redhat.com>
>> >> > Cc: "H. Peter Anvin" <hpa@zytor.com>
>> >> > Cc: x86@kernel.org
>> >> > Cc: linux-kernel@vger.kernel.org
>> >> > Cc: linux-audit@redhat.com
>> >> > ---
>> >> >  arch/x86/kernel/entry_32.S | 15 +++++++--------
>> >> >  1 file changed, 7 insertions(+), 8 deletions(-)
>> >> >
>> >> > diff --git a/arch/x86/kernel/entry_32.S b/arch/x86/kernel/entry_32.S
>> >> > index f9e3fab..fb01d22 100644
>> >> > --- a/arch/x86/kernel/entry_32.S
>> >> > +++ b/arch/x86/kernel/entry_32.S
>> >> > @@ -447,15 +447,14 @@ sysenter_exit:
>> >> >  sysenter_audit:
>> >> >     testl $(_TIF_WORK_SYSCALL_ENTRY & ~_TIF_SYSCALL_AUDIT),TI_flags(%ebp)
>> >> >     jnz syscall_trace_entry
>> >> > -   addl $4,%esp
>> >> > -   CFI_ADJUST_CFA_OFFSET -4
>> >> > -   movl %esi,4(%esp)               /* 5th arg: 4th syscall arg */
>> >> > -   movl %edx,(%esp)                /* 4th arg: 3rd syscall arg */
>> >> > -   /* %ecx already in %ecx            3rd arg: 2nd syscall arg */
>> >> > -   movl %ebx,%edx                  /* 2nd arg: 1st syscall arg */
>> >> > -   /* %eax already in %eax            1st arg: syscall number */
>> >> > +   /* movl PT_EAX(%esp), %eax      already set, syscall number: 1st arg to audit */
>> >> > +   movl PT_EBX(%esp), %edx         /* ebx/a0: 2nd arg to audit */
>> >> > +   /* movl PT_ECX(%esp), %ecx      already set, a1: 3nd arg to audit */
>> >> > +   pushl_cfi PT_ESI(%esp)          /* a3: 5th arg */
>> >> > +   pushl_cfi PT_EDX+4(%esp)        /* a2: 4th arg */
>> >> >     call __audit_syscall_entry
>> >> > -   pushl_cfi %ebx
>> >> > +   popl_cfi %ecx /* get that remapped edx off the stack */
>> >> > +   popl_cfi %ecx /* get that remapped esi off the stack */
>> >> >     movl PT_EAX(%esp),%eax          /* reload syscall number */
>> >> >     jmp sysenter_do_call
>> >> >
>> >> >
>> >>
>> >> This looks reasonably likely to be correct, but this code is complicated
>> >> and now ever slower.
>> >
>> > I guess I could just use push/pop and do the CFI_ADJUST_CFA_OFFSET by
>> > hand.  But I figured this was reasonable enough...
>> >
>>
>> I'm not complaining about your new assembly in particular.  There's
>> just too much assembly in there in general.
>>
>> But I feel like I'm missing something in the new code.  Aren't you
>> corrupting ecx with those popl_cfi insns?
>
> After the call __audit_syscall_entry aren't they already polluted?
> Isn't that the reason we need to reload EAX?  You can verify this leaves
> things in a similar state (although slightly differently polluted) than
> before it got screwed up.  Here is diff between before the breakage and
> what I propose we do now.
>
> (I admit I don't understand how the pushl_cfi %ebx wasn't messing up
> PT_EBX)
>
> /me anxiously awaits x86 guy to tell me how dumb I am....
>

hpa, do you have time to figure this out?  I don't know the 32-bit ABI
well enough, nor will I have time to disassemble things or find and
read the spec to figure this out in the next few days.

--Andy

> $ git diff a17c8b54dc738c4fda31e8be0302cd131a04c19f -- arch/x86/kernel/entry_32.S
> diff --git a/arch/x86/kernel/entry_32.S b/arch/x86/kernel/entry_32.S
> index 0d0c9d4..fb01d22 100644
> --- a/arch/x86/kernel/entry_32.S
> +++ b/arch/x86/kernel/entry_32.S
> @@ -447,16 +447,14 @@ sysenter_exit:
>  sysenter_audit:
>         testl $(_TIF_WORK_SYSCALL_ENTRY & ~_TIF_SYSCALL_AUDIT),TI_flags(%ebp)
>         jnz syscall_trace_entry
> -       addl $4,%esp
> -       CFI_ADJUST_CFA_OFFSET -4
> -       /* %esi already in 8(%esp)         6th arg: 4th syscall arg */
> -       /* %edx already in 4(%esp)         5th arg: 3rd syscall arg */
> -       /* %ecx already in 0(%esp)         4th arg: 2nd syscall arg */
> -       movl %ebx,%ecx                  /* 3rd arg: 1st syscall arg */
> -       movl %eax,%edx                  /* 2nd arg: syscall number */
> -       movl $AUDIT_ARCH_I386,%eax      /* 1st arg: audit arch */
> +       /* movl PT_EAX(%esp), %eax      already set, syscall number: 1st arg to audit */
> +       movl PT_EBX(%esp), %edx         /* ebx/a0: 2nd arg to audit */
> +       /* movl PT_ECX(%esp), %ecx      already set, a1: 3nd arg to audit */
> +       pushl_cfi PT_ESI(%esp)          /* a3: 5th arg */
> +       pushl_cfi PT_EDX+4(%esp)        /* a2: 4th arg */
>         call __audit_syscall_entry
> -       pushl_cfi %ebx
> +       popl_cfi %ecx /* get that remapped edx off the stack */
> +       popl_cfi %ecx /* get that remapped esi off the stack */
>         movl PT_EAX(%esp),%eax          /* reload syscall number */
>         jmp sysenter_do_call
>
>



-- 
Andy Lutomirski
AMA Capital Management, LLC
