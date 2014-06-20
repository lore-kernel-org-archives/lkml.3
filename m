Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934617AbaFTPlr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jun 2014 11:41:47 -0400
Received: from mail-la0-f50.google.com ([209.85.215.50]:38028 "EHLO
	mail-la0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932228AbaFTPlp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jun 2014 11:41:45 -0400
MIME-Version: 1.0
In-Reply-To: <539F6646.4040605@zytor.com>
References: <539F1C59.6070308@gmx.de> <CAFLxGvyqPzbmfz1-WxP7z02=V-V5=p5b09HYPOFOS7Qj8eUHGw@mail.gmail.com>
 <CALCETrXqjHPvKw=wcdnxQWO0Y140B=a0E7eh4+PoERvU=z909w@mail.gmail.com>
 <539F297F.7010904@nod.at> <CALCETrU+TmaEjPSHz1LwQJvVDp8fqoDs3O4b+3gS_ewthiwnMA@mail.gmail.com>
 <539F2B2D.6050105@gmx.de> <CALCETrVw6f7iy4qTMgSt8k9N4rOWJ_mm9LbrtVZ9YFORacriSQ@mail.gmail.com>
 <539F3077.7040005@gmx.de> <CALCETrUUC6g_y4nJkSYo7MrKB8ehyXgnnuBHxGCDrq1d4zp2BQ@mail.gmail.com>
 <539F35A0.2050002@gmx.de> <CALCETrVseO=n6TH-msfTHRqB-OMPs_32nRELVYc=V1ZDmvFXVA@mail.gmail.com>
 <539F567F.2050802@gmx.de> <539F5702.5050104@nod.at> <CALCETrW7U4AHG-a9oPbOt31z3wgzhjSu8b+yGpdM4+vNinKgsA@mail.gmail.com>
 <539F6646.4040605@zytor.com>
From: Andy Lutomirski <luto@amacapital.net>
Date: Fri, 20 Jun 2014 08:41:23 -0700
Message-ID: <CALCETrXhmLGvD0ff2HhRmL33UnYvb7eEbEqREANLYYDTJcwN7Q@mail.gmail.com>
Subject: Re: 3.15: kernel BUG at kernel/auditsc.c:1525!
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Richard Weinberger <richard@nod.at>, X86 ML <x86@kernel.org>,
        =?UTF-8?Q?Toralf_F=C3=B6rster?= <toralf.foerster@gmx.de>,
        Eric Paris <eparis@redhat.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 16, 2014 at 2:48 PM, H. Peter Anvin <hpa@zytor.com> wrote:
> On 06/16/2014 02:35 PM, Andy Lutomirski wrote:
>>
>> To hpa, etc:  It appears that entry_32.S is missing any call to the
>> audit exit hook on the badsys path.  If I'm diagnosing this bug report
>> correctly, this causes OOPSes.
>>
>> The the world at large: it's increasingly apparent that no one (except
>> maybe the blackhats) has ever scrutinized the syscall auditing code.
>> This is two old severe bugs in the code that have probably been there
>> for a long time.
>>
>
> Yes, the audit code is a total mess.
>
>> The bad syscall nr paths are their own incomprehensible route
>> through the entry control flow.  Rearrange them to work just like
>> syscalls that return -ENOSYS.
>
> I have to admit... it sort of lends itself to a solution like this:
>
>         /* For the 64-bit case, analogous code for 32 bits */
>         movl $__NR_syscall_max+1,%ecx   # *Not* __NR_syscall_max
>         cmpq %rcx,%rax
>         cmovae %rcx,%rax
>         movq %r10,%rcx
>         call *sys_call_table(,%rax,8)
>
> ... and having an extra (invalid) system call slot in the syscall table
> beyond the end instead of branching off separately.
>
> (Note: we could use either cmova or cmovae, and either the 32- or 64-bit
> form... the reason why is left as an exercise to the reader.)

This is CVE-2014-4508, and it's probably worth fixing.

Is my patch good?  I can resent and cc stable if needed.

--Andy
