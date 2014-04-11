Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754837AbaDKWAF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Apr 2014 18:00:05 -0400
Received: from mga09.intel.com ([134.134.136.24]:6544 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750838AbaDKWAC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Apr 2014 18:00:02 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,844,1389772800"; 
   d="scan'208";a="491577766"
Message-ID: <534865DF.2090703@linux.intel.com>
Date: Fri, 11 Apr 2014 14:59:59 -0700
From: "H. Peter Anvin" <hpa@linux.intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Andy Lutomirski <luto@amacapital.net>, "H. Peter Anvin" <hpa@zytor.com>,
        Brian Gerst <brgerst@gmail.com>, Ingo Molnar <mingo@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>, stable@vger.kernel.org
Subject: Re: [tip:x86/urgent] x86-64, modify_ldt: Ban 16-bit segments on 64-bit
 kernels
References: <tip-kicdm89kzw9lldryb1br9od0@git.kernel.org> <CAMzpN2jx4H4p8fQr-WHxVyCHhWi0iO3WZZKyxYD7Dfa7pWkEgg@mail.gmail.com> <53483487.6030103@zytor.com> <53485BB8.1000106@mit.edu> <53485D95.9030301@zytor.com> <5348643F.1020405@mit.edu>
In-Reply-To: <5348643F.1020405@mit.edu>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/11/2014 02:53 PM, Andy Lutomirski wrote:
> 
> How big of a functionality problem is it?  Apparently it doesn't break
> 16-bit code on wine.
> 

It breaks *some* 16-bit code.  This is actually the reason that 32 bits
has the espfix workaround - it wasn't identified as an infoleak at the time.

> Since the high bits of esp have been corrupted on x86_64 since the
> beginning, there's no regression issue here if an eventual fix writes
> less meaningful crap to those bits -- I see no real reason to try to put
> the correct values in there.

It is a regression vs. the 32-bit kernel, and if we're going to support
16-bit code we should arguably support 16-bit code correctly.

This is actually how I stumbled onto this problem in the first place: it
broke a compiler test suite for gcc -m16 I was working on.  The
workaround for *that* was to run in a VM instead.

>>> I would have suggested rejecting modify_ldt() entirely, to reduce attack
>>> surface, except that some early versions of 32-bit NPTL glibc use
>>> modify_ldt() to exclusion of all other methods of establishing the
>>> thread pointer, so in order to stay compatible with those we would need
>>> to allow 32-bit segments via modify_ldt() still.
> 
> I actually use modify_ldt for amusement: it's the only way I know of to
> issue real 32-bit syscalls from 64-bit userspace.  Yes, this isn't
> really a legitimate use case.

That's actually wrong on no less than two levels:

1. You can issue real 32-bit system calls from 64-bit user space simply
   by invoking int $0x80; it works in 64-bit mode as well.

2. Even if you want to be in 32-bit mode you can simply call via
   __USER32_CS, you don't need an LDT entry.

> Why not just 4k per CPU?  Write the pfn to the pte, invlpg, update rsp,
> iret.  This leaks the CPU number, but that's all.
> 
> To me, this sounds like the easiest solution, so long as rsp is known to
> be sufficiently far from a page boundary.
> 
> These ptes could even be read-only to limit the extra exposure to
> known-address attacks.
> 
> If you want a fully correct solution, you can use a fancier allocation
> policy that can fit quite a few cpus per 4G :)

It's damned hard, because you don't have a logical place to
*deallocate*.  That's what ends up killing you.

Also, you will need to port over the equivalent to the espfix recovery
code from 32 bits (what happens if IRET takes an exception), so it is
nontrivial.

>>> d. Trampoline in user space
>>>
>>> A return to the vdso with values set up in registers r8-r15 would enable
>>> a trampoline in user space.  Unfortunately there is no way
>>> to do a far JMP entirely with register state so this would require
>>> touching user space memory, possibly in an unsafe manner.
>>>
>>> The most likely variant is to use the address of the 16-bit user stack
>>> and simply hope that this is a safe thing to do.
>>>
>>> This appears to be the most feasible workaround if a workaround is
>>> deemed necessary.
> 
> Eww.

I don't think any of the options are anything but.

	-hpa




