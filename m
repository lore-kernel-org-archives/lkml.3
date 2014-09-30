Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753750AbaI3VqN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Sep 2014 17:46:13 -0400
Received: from mail-lb0-f172.google.com ([209.85.217.172]:58169 "EHLO
	mail-lb0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751567AbaI3VqL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Sep 2014 17:46:11 -0400
MIME-Version: 1.0
In-Reply-To: <542B2305.9060805@fds-team.de>
References: <cover.1412105369.git.luto@amacapital.net> <c4b7904ef2ddd3dec27400d18bcd00badb4dcedf.1412105369.git.luto@amacapital.net>
 <542B2305.9060805@fds-team.de>
From: Andy Lutomirski <luto@amacapital.net>
Date: Tue, 30 Sep 2014 14:45:48 -0700
Message-ID: <CALCETrX86zeONHsf74yKseddXUc1BMHHAFaGKgU82HuU9+_PjQ@mail.gmail.com>
Subject: Re: [PATCH 1/2] x86_64,entry: Filter RFLAGS.NT on entry from userspace
To: Sebastian Lackner <sebastian@fds-team.de>
Cc: Thomas Gleixner <tglx@linutronix.de>, X86 ML <x86@kernel.org>,
        Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        Anish Bhatt <anish@chelsio.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Chuck Ebbert <cebbert.lkml@gmail.com>, stable@kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 30, 2014 at 2:39 PM, Sebastian Lackner
<sebastian@fds-team.de> wrote:
> On 30.09.2014 21:40, Andy Lutomirski wrote:
>> what would happen.  Apparently Wine sometimes does this (!), and, if
>> an IRET return happens, Wine will segfault.
>>
>> I think that Wine should be fixed to stop setting NT when a syscall
>> happens, but handling NT more gracefully is still nice.
>>
>
> Just to give some more background about this issue: Wine has no influence
> if the NT flag is set or not - as Wine doesn't trace each individual opcode,
> there is no chance to know, if a Windows program messes up the EFLAGS. This
> happens in closed source Windows applications, so its not really Wines fault.

I don't buy this explanation at all.  Surely Wine is responsible for
all system calls that happen.  There's only a problem when NT is set
and a system call happens.

>
> I think the current approach should be fine, but if other people prefer one of
> the solutions without additional overhead on syscall entry:
>
> At least for Wine it would also be absolutely fine, when the application would
> just get a proper signal (if adding the retry IRET is too complicated). I've
> attached the url to an additional example program, which shows that currently
> the signal handler is unable to process such a fault, and a proof-of-concept
> patch to clear the NT flags at least for the signal handler. Such a patch
> doesn't fix the potential issues with EFI though.
>
> Example program:
> http://ix.io/ezl
>
> Proof-of-concept patch:
> http://ix.io/ezm

This patch would make more sense if you only cleared it from the
actual regs, not the saved regs.  User code can do the latter on its
own.

It would certainly be possible to clear NT and retry IRET if IRET
fails with NT set.  This would have no overhead for anything relevant.
That would be this alternative from my 0/2 email:

 - Don't filter NT on sysenter.  Instead, filter it on EFI entry
   and modify the IRET code to retry without NT set if NT was set.

Thomas hpa, etc: any thoughts?

>
> Regards,
> Sebastian
>



-- 
Andy Lutomirski
AMA Capital Management, LLC
