Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751920AbaI3WXU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Sep 2014 18:23:20 -0400
Received: from mail-lb0-f171.google.com ([209.85.217.171]:40118 "EHLO
	mail-lb0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751479AbaI3WXT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Sep 2014 18:23:19 -0400
Message-ID: <542B2D53.1080109@fds-team.de>
Date: Wed, 01 Oct 2014 00:23:15 +0200
From: Sebastian Lackner <sebastian@fds-team.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.1.2
MIME-Version: 1.0
To: Andy Lutomirski <luto@amacapital.net>
CC: Thomas Gleixner <tglx@linutronix.de>, X86 ML <x86@kernel.org>,
        Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        Anish Bhatt <anish@chelsio.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Chuck Ebbert <cebbert.lkml@gmail.com>, stable@kernel.org
Subject: Re: [PATCH 1/2] x86_64,entry: Filter RFLAGS.NT on entry from userspace
References: <cover.1412105369.git.luto@amacapital.net> <c4b7904ef2ddd3dec27400d18bcd00badb4dcedf.1412105369.git.luto@amacapital.net> <542B2305.9060805@fds-team.de> <CALCETrX86zeONHsf74yKseddXUc1BMHHAFaGKgU82HuU9+_PjQ@mail.gmail.com>
In-Reply-To: <CALCETrX86zeONHsf74yKseddXUc1BMHHAFaGKgU82HuU9+_PjQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 30.09.2014 23:45, Andy Lutomirski wrote:
> On Tue, Sep 30, 2014 at 2:39 PM, Sebastian Lackner
> <sebastian@fds-team.de> wrote:
>> On 30.09.2014 21:40, Andy Lutomirski wrote:
>>> what would happen.  Apparently Wine sometimes does this (!), and, if
>>> an IRET return happens, Wine will segfault.
>>>
>>> I think that Wine should be fixed to stop setting NT when a syscall
>>> happens, but handling NT more gracefully is still nice.
>>>
>>
>> Just to give some more background about this issue: Wine has no influence
>> if the NT flag is set or not - as Wine doesn't trace each individual opcode,
>> there is no chance to know, if a Windows program messes up the EFLAGS. This
>> happens in closed source Windows applications, so its not really Wines fault.
> 
> I don't buy this explanation at all.  Surely Wine is responsible for
> all system calls that happen.  There's only a problem when NT is set
> and a system call happens.

Wine maps all the Windows API calls to their corresponding Linux equivalent shared
library, you will rarely find any direct syscalls. This means it would involve adding
special code to clear NT at the beginning of _each_ function, which can be called
directly from the Windows application. Also callbacks to/from native code would have
to be protected...

I doubt that gcc will ever add such a feature, but even if there would be something
like that, it still wouldn't be a good solution - lot more overhead than a kernel
solution. ;)

> 
>>
>> I think the current approach should be fine, but if other people prefer one of
>> the solutions without additional overhead on syscall entry:
>>
>> At least for Wine it would also be absolutely fine, when the application would
>> just get a proper signal (if adding the retry IRET is too complicated). I've
>> attached the url to an additional example program, which shows that currently
>> the signal handler is unable to process such a fault, and a proof-of-concept
>> patch to clear the NT flags at least for the signal handler. Such a patch
>> doesn't fix the potential issues with EFI though.
>>
>> Example program:
>> http://ix.io/ezl
>>
>> Proof-of-concept patch:
>> http://ix.io/ezm
> 
> This patch would make more sense if you only cleared it from the
> actual regs, not the saved regs.  User code can do the latter on its
> own.

Maybe I misunderstood the comments in the source, but it sounded like
regs->flags contains the flags which are used to enter the signal handler ?!
(which would mean that they are saved on the stack and used for the following IRET)

Having the NT flag still set at this point would cause immediately another
recursive fault, if the signal handler tries to run any syscall, which is
most probably not what the developer wants.

> 
> It would certainly be possible to clear NT and retry IRET if IRET
> fails with NT set.  This would have no overhead for anything relevant.
> That would be this alternative from my 0/2 email:
> 
>  - Don't filter NT on sysenter.  Instead, filter it on EFI entry
>    and modify the IRET code to retry without NT set if NT was set.

Yup, I saw that, but I'm not sure how small the overhead really is.
Is it sufficient to check the NT flag and retry? What about other instructions,
which could also cause a #GP, it wouldn't make sense to retry them, even if
the NT flag is set (for some unknown reason). Not sure if it will cause any
harm, but at least retry _only_ IRET instructions sounds a bit complicated.

> 
> Thomas hpa, etc: any thoughts?
> 
>>
>> Regards,
>> Sebastian
>>
> 
> 
> 

