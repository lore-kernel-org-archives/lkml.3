Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755774AbaDKVxK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Apr 2014 17:53:10 -0400
Received: from mail-pa0-f52.google.com ([209.85.220.52]:38264 "EHLO
	mail-pa0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755348AbaDKVxF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Apr 2014 17:53:05 -0400
Message-ID: <5348643F.1020405@mit.edu>
Date: Fri, 11 Apr 2014 14:53:03 -0700
From: Andy Lutomirski <luto@amacapital.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: "H. Peter Anvin" <hpa@zytor.com>, Andy Lutomirski <luto@amacapital.net>,
        Brian Gerst <brgerst@gmail.com>, Ingo Molnar <mingo@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>, stable@vger.kernel.org,
        "H. Peter Anvin" <hpa@linux.intel.com>
Subject: Re: [tip:x86/urgent] x86-64, modify_ldt: Ban 16-bit segments on 64-bit
 kernels
References: <tip-kicdm89kzw9lldryb1br9od0@git.kernel.org> <CAMzpN2jx4H4p8fQr-WHxVyCHhWi0iO3WZZKyxYD7Dfa7pWkEgg@mail.gmail.com> <53483487.6030103@zytor.com> <53485BB8.1000106@mit.edu> <53485D95.9030301@zytor.com>
In-Reply-To: <53485D95.9030301@zytor.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/11/2014 02:24 PM, H. Peter Anvin wrote:
> On 04/11/2014 02:16 PM, Andy Lutomirski wrote:
>> I wonder if there's an easy-ish good-enough fix:
>>
>> Allocate some percpu space in the fixmap.  (OK, this is ugly, but
>> kvmclock already does it, so it's possible.)  To return to 16-bit
>> userspace, make sure interrupts are off, copy the whole iret descriptor
>> to the current cpu's fixmap space, change rsp to point to that space,
>> and then do the iret.
>>
>> This won't restore the correct value to the high bits of [er]sp, but it
>> will at least stop leaking anything interesting to userspace.
>>
> 
> This would fix the infoleak, at the cost of allocating a chunk of memory
> for each CPU.  It doesn't fix the functionality problem.
> 
> If we're going to do a workaround I would prefer to do something that
> fixes both, but it is highly nontrivial.
> 
> This is a writeup I did to a select audience before this was public:
> 
>> Hello,
>>
>> This is both a functionality problem (16-bit code gets the upper bits of
>> %esp corrupted when the kernel is invoked) and an information leak.  The
>> 32-bit workaround was labeled as a fix for the functionality problem,
>> but it of course also addresses the leak.

How big of a functionality problem is it?  Apparently it doesn't break
16-bit code on wine.

Since the high bits of esp have been corrupted on x86_64 since the
beginning, there's no regression issue here if an eventual fix writes
less meaningful crap to those bits -- I see no real reason to try to put
the correct values in there.


>> I would have suggested rejecting modify_ldt() entirely, to reduce attack
>> surface, except that some early versions of 32-bit NPTL glibc use
>> modify_ldt() to exclusion of all other methods of establishing the
>> thread pointer, so in order to stay compatible with those we would need
>> to allow 32-bit segments via modify_ldt() still.

I actually use modify_ldt for amusement: it's the only way I know of to
issue real 32-bit syscalls from 64-bit userspace.  Yes, this isn't
really a legitimate use case.

>>
>> a. Using paging in a similar way to the 32-bit segment base workaround
>>
>> This one requires a very large swath of virtual user space (depending on
>> allocation policy, as much as 4 GiB per CPU.)  The "per CPU" requirement
>> comes in as locking is not feasible -- as we return to user space there
>> is nowhere to release the lock.

Why not just 4k per CPU?  Write the pfn to the pte, invlpg, update rsp,
iret.  This leaks the CPU number, but that's all.

To me, this sounds like the easiest solution, so long as rsp is known to
be sufficiently far from a page boundary.

These ptes could even be read-only to limit the extra exposure to
known-address attacks.

If you want a fully correct solution, you can use a fancier allocation
policy that can fit quite a few cpus per 4G :)

>>
>> d. Trampoline in user space
>>
>> A return to the vdso with values set up in registers r8-r15 would enable
>> a trampoline in user space.  Unfortunately there is no way
>> to do a far JMP entirely with register state so this would require
>> touching user space memory, possibly in an unsafe manner.
>>
>> The most likely variant is to use the address of the 16-bit user stack
>> and simply hope that this is a safe thing to do.
>>
>> This appears to be the most feasible workaround if a workaround is
>> deemed necessary.

Eww.

--Andy
