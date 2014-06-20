Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935189AbaFTRfk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jun 2014 13:35:40 -0400
Received: from mout.gmx.net ([212.227.15.15]:54828 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756925AbaFTRfi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jun 2014 13:35:38 -0400
Message-ID: <53A470E1.6090004@gmx.de>
Date: Fri, 20 Jun 2014 19:35:29 +0200
From: =?UTF-8?B?VG9yYWxmIEbDtnJzdGVy?= <toralf.foerster@gmx.de>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Andy Lutomirski <luto@amacapital.net>, "H. Peter Anvin" <hpa@zytor.com>
CC: Richard Weinberger <richard@nod.at>, X86 ML <x86@kernel.org>,
        Eric Paris <eparis@redhat.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: 3.15: kernel BUG at kernel/auditsc.c:1525!
References: <539F1C59.6070308@gmx.de> <CAFLxGvyqPzbmfz1-WxP7z02=V-V5=p5b09HYPOFOS7Qj8eUHGw@mail.gmail.com> <CALCETrXqjHPvKw=wcdnxQWO0Y140B=a0E7eh4+PoERvU=z909w@mail.gmail.com> <539F297F.7010904@nod.at> <CALCETrU+TmaEjPSHz1LwQJvVDp8fqoDs3O4b+3gS_ewthiwnMA@mail.gmail.com> <539F2B2D.6050105@gmx.de> <CALCETrVw6f7iy4qTMgSt8k9N4rOWJ_mm9LbrtVZ9YFORacriSQ@mail.gmail.com> <539F3077.7040005@gmx.de> <CALCETrUUC6g_y4nJkSYo7MrKB8ehyXgnnuBHxGCDrq1d4zp2BQ@mail.gmail.com> <539F35A0.2050002@gmx.de> <CALCETrVseO=n6TH-msfTHRqB-OMPs_32nRELVYc=V1ZDmvFXVA@mail.gmail.com> <539F567F.2050802@gmx.de> <539F5702.5050104@nod.at> <CALCETrW7U4AHG-a9oPbOt31z3wgzhjSu8b+yGpdM4+vNinKgsA@mail.gmail.com> <539F6646.4040605@zytor.com> <CALCETrXhmLGvD0ff2HhRmL33UnYvb7eEbEqREANLYYDTJcwN7Q@mail.gmail.com>
In-Reply-To: <CALCETrXhmLGvD0ff2HhRmL33UnYvb7eEbEqREANLYYDTJcwN7Q@mail.gmail.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Provags-ID: V03:K0:s7+78HeBztdVxJQLTgHb1A1vjt3UMclXXPgo0iDLi1IwsMIrBlX
 eo5uXPZAJKCgXfUd9ykuhvyGPjXuNSCEt/GZIsQE8t3EEJvqoe9L/WrhopgxVENeKEUXi8n
 ExMOXqeQUgsDcbL6Bf/aCJoqHeV2Mstj4S7+6A4DOYd2Ay8RMoyLTHACJ63qrQt83NJ/fof
 tWQeylxHja8INjrQ7x5Gw==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/20/2014 05:41 PM, Andy Lutomirski wrote:
> On Mon, Jun 16, 2014 at 2:48 PM, H. Peter Anvin <hpa@zytor.com> wrote:
>> On 06/16/2014 02:35 PM, Andy Lutomirski wrote:
>>>
>>> To hpa, etc:  It appears that entry_32.S is missing any call to the
>>> audit exit hook on the badsys path.  If I'm diagnosing this bug report
>>> correctly, this causes OOPSes.
>>>
>>> The the world at large: it's increasingly apparent that no one (except
>>> maybe the blackhats) has ever scrutinized the syscall auditing code.
>>> This is two old severe bugs in the code that have probably been there
>>> for a long time.
>>>
>>
>> Yes, the audit code is a total mess.
>>
>>> The bad syscall nr paths are their own incomprehensible route
>>> through the entry control flow.  Rearrange them to work just like
>>> syscalls that return -ENOSYS.
>>
>> I have to admit... it sort of lends itself to a solution like this:
>>
>>         /* For the 64-bit case, analogous code for 32 bits */
>>         movl $__NR_syscall_max+1,%ecx   # *Not* __NR_syscall_max
>>         cmpq %rcx,%rax
>>         cmovae %rcx,%rax
>>         movq %r10,%rcx
>>         call *sys_call_table(,%rax,8)
>>
>> ... and having an extra (invalid) system call slot in the syscall table
>> beyond the end instead of branching off separately.
>>
>> (Note: we could use either cmova or cmovae, and either the 32- or 64-bit
>> form... the reason why is left as an exercise to the reader.)
> 
> This is CVE-2014-4508, and it's probably worth fixing.
> 
> Is my patch good?  I can resent and cc stable if needed.
> 
> --Andy
> 
I'm running my system since the time you sent it to me w/o any problems with that patch on top of 3.15.1 :



tfoerste@n22 ~/devel/linux $ cat ~/devel/priv/0001-x86_32-entry-Fix-badsys-paths.patch 

>From 8b43bd2118d876cb3163e8f7d9cd8253da649335 Mon Sep 17 00:00:00 2001
Message-Id: <8b43bd2118d876cb3163e8f7d9cd8253da649335.1402954406.git.luto@amacapital.net>
From: Andy Lutomirski <luto@amacapital.net>
Date: Mon, 16 Jun 2014 14:28:19 -0700
Subject: [PATCH] x86_32,entry: Fix badsys paths
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

The bad syscall nr paths are their own incomprehensible route
through the entry control flow.  Rearrange them to work just like
syscalls that return -ENOSYS.

This should fix an OOPS in the audit code when auditing is enabled
and bad syscall nrs are used.

Reported-by: Toralf Förster <toralf.foerster@gmx.de>
Signed-off-by: Andy Lutomirski <luto@amacapital.net>
---




-- 
Toralf

