Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754785AbaDKVZH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Apr 2014 17:25:07 -0400
Received: from terminus.zytor.com ([198.137.202.10]:47819 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751286AbaDKVZE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Apr 2014 17:25:04 -0400
Message-ID: <53485D95.9030301@zytor.com>
Date: Fri, 11 Apr 2014 14:24:37 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Andy Lutomirski <luto@amacapital.net>, Brian Gerst <brgerst@gmail.com>,
        Ingo Molnar <mingo@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>, stable@vger.kernel.org,
        "H. Peter Anvin" <hpa@linux.intel.com>
Subject: Re: [tip:x86/urgent] x86-64, modify_ldt: Ban 16-bit segments on 64-bit
 kernels
References: <tip-kicdm89kzw9lldryb1br9od0@git.kernel.org> <CAMzpN2jx4H4p8fQr-WHxVyCHhWi0iO3WZZKyxYD7Dfa7pWkEgg@mail.gmail.com> <53483487.6030103@zytor.com> <53485BB8.1000106@mit.edu>
In-Reply-To: <53485BB8.1000106@mit.edu>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/11/2014 02:16 PM, Andy Lutomirski wrote:
> On 04/11/2014 11:29 AM, H. Peter Anvin wrote:
>> On 04/11/2014 11:27 AM, Brian Gerst wrote:
>>> Is this bug really still present in modern CPUs?  This change breaks
>>> running 16-bit apps in Wine.  I have a few really old games I like to
>>> play on occasion, and I don't have a copy of Win 3.11 to put in a VM.
>>
>> It is not a bug, per se, but an architectural definition issue, and it
>> is present in all x86 processors from all vendors.
>>
>> Yes, it does break running 16-bit apps in Wine, although Wine could be
>> modified to put 16-bit apps in a container.  However, this is at best a
>> marginal use case.
> 
> I wonder if there's an easy-ish good-enough fix:
> 
> Allocate some percpu space in the fixmap.  (OK, this is ugly, but
> kvmclock already does it, so it's possible.)  To return to 16-bit
> userspace, make sure interrupts are off, copy the whole iret descriptor
> to the current cpu's fixmap space, change rsp to point to that space,
> and then do the iret.
> 
> This won't restore the correct value to the high bits of [er]sp, but it
> will at least stop leaking anything interesting to userspace.
> 

This would fix the infoleak, at the cost of allocating a chunk of memory
for each CPU.  It doesn't fix the functionality problem.

If we're going to do a workaround I would prefer to do something that
fixes both, but it is highly nontrivial.

This is a writeup I did to a select audience before this was public:

> Hello,
> 
> It appears we have an information leak on x86-64 by which at least bits
> [31:16] of the kernel stack address leaks to user space (some silicon
> including the 64-bit Pentium 4 leaks [63:16]).  This is due to the the
> behavior of IRET when returning to a 16-bit segment: IRET restores only
> the bottom 16 bits of the stack pointer.
> 
> This is known on 32 bits and we, in fact, have a workaround for it
> ("espfix") there.  We do not, however, have the equivalent on 64 bits,
> nor does it seem that it is very easy to construct a workaround (see below.)
> 
> This is both a functionality problem (16-bit code gets the upper bits of
> %esp corrupted when the kernel is invoked) and an information leak.  The
> 32-bit workaround was labeled as a fix for the functionality problem,
> but it of course also addresses the leak.
> 
> On 64 bits, the easiest mitigation seems to be to make modify_ldt()
> refuse to install a 16-bit segment when running on a 64-bit kernel.
> 16-bit support is already somewhat crippled on 64 bits since there is no
> V86 support; obviously, for "full service" support we can always set up
> a virtual machine -- most (but sadly, not all) 64-bit parts are also
> virtualization capable.
> 
> I would have suggested rejecting modify_ldt() entirely, to reduce attack
> surface, except that some early versions of 32-bit NPTL glibc use
> modify_ldt() to exclusion of all other methods of establishing the
> thread pointer, so in order to stay compatible with those we would need
> to allow 32-bit segments via modify_ldt() still.
> 
> However, there is no doubt this will break some legitimate users of
> 16-bit segments, e.g. Wine for 16-bit Windows apps (which don't work on
> 64-bit Windows either, for what it is worth.)
> 
> We may very well have other infoleaks that dwarf this, but the kernel
> stack address is a relatively high value item for exploits.
> 
> Some workarounds I have considered:
> 
> a. Using paging in a similar way to the 32-bit segment base workaround
> 
> This one requires a very large swath of virtual user space (depending on
> allocation policy, as much as 4 GiB per CPU.)  The "per CPU" requirement
> comes in as locking is not feasible -- as we return to user space there
> is nowhere to release the lock.
> 
> b. Return to user space via compatibility mode
> 
> As the kernel lives above the 4 GiB virtual mark, a transition through
> compatibility mode is not practical.  This would require the kernel to
> reserve virtual address space below the 4 GiB mark, which may interfere
> with the application, especially an application launched as a 64-bit
> application.
> 
> c. Trampoline in kernel space
> 
> A trampoline in kernel space is not feasible since all ring transition
> instructions capable of returning to 16-bit mode require the use of the
> stack.
> 
> d. Trampoline in user space
> 
> A return to the vdso with values set up in registers r8-r15 would enable
> a trampoline in user space.  Unfortunately there is no way
> to do a far JMP entirely with register state so this would require
> touching user space memory, possibly in an unsafe manner.
> 
> The most likely variant is to use the address of the 16-bit user stack
> and simply hope that this is a safe thing to do.
> 
> This appears to be the most feasible workaround if a workaround is
> deemed necessary.
> 
> e. Transparently run 16-bit code segments inside a lightweight VMM
> 
> The complexity of this solution versus the realized value is staggering.
> It also doesn't work on non-virtualization-capable hardware (including
> running on top of a VMM which doesn't support nested virtualization.)
> 
> 	-hpa

