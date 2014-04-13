Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756803AbaDMADr (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Apr 2014 20:03:47 -0400
Received: from terminus.zytor.com ([198.137.202.10]:58210 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750833AbaDMADq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Apr 2014 20:03:46 -0400
Message-ID: <5349D44C.9070105@zytor.com>
Date: Sat, 12 Apr 2014 17:03:24 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Alexander van Heukelum <heukelum@fastmail.fm>,
        Andy Lutomirski <luto@amacapital.net>, Brian Gerst <brgerst@gmail.com>,
        Ingo Molnar <mingo@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>, stable@jasper.es
Subject: Re: [tip:x86/urgent] x86-64, modify_ldt: Ban 16-bit segments on 64-bit
 kernels
References: <tip-kicdm89kzw9lldryb1br9od0@git.kernel.org> <CAMzpN2jx4H4p8fQr-WHxVyCHhWi0iO3WZZKyxYD7Dfa7pWkEgg@mail.gmail.com> <53483487.6030103@zytor.com> <53485BB8.1000106@mit.edu> <53485D95.9030301@zytor.com> <1397345179.1772.105823721.224E1140@webmail.messagingengine.com> <5349CCE3.3000003@zytor.com> <1397346568.13490.105824481.72FA2B8D@webmail.messagingengine.com>
In-Reply-To: <1397346568.13490.105824481.72FA2B8D@webmail.messagingengine.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/12/2014 04:49 PM, Alexander van Heukelum wrote:
> On Sun, Apr 13, 2014, at 1:31, H. Peter Anvin wrote:
>>>>> d. Trampoline in user space
>>>>>
>>>>> A return to the vdso with values set up in registers r8-r15 would enable
>>>>> a trampoline in user space.  Unfortunately there is no way
>>>>> to do a far JMP entirely with register state so this would require
>>>>> touching user space memory, possibly in an unsafe manner.
>>>
>>> d.2. trampoline in user space via long mode
>>>
>>> Return from the kernel to a user space trampoline via long mode.
>>> The kernel changes the stack frame just before executing the iret
>>> instruction. (the CS and RIP slots are set to run the trampoline code,
>>> where CS is a long mode segment.) The trampoline code in userspace
>>> is set up to this single instruction: a far jump to the final CS:EIP
>>> (compatibility mode).
>>
>> This still requires user space memory that the kernel can write to.
>> Long mode is actually exactly identical to what I was suggesting above,
>> except that I would avoid using self-modifying code in favor of just
>> parameterization using the high registers.
> 
> No self modifying code... The far jump must be in the indirect form
> anyhow. The CS:EIP must be accessible from user mode, but not
> necessarily from compatibility mode. So the trampoline (the jump)
> and data (CS:EIP) can live pretty much anywhere in virtual memory.
> But indeed, I see what you meant now.
> 

This is, in fact, exactly then what I was suggesting, except that data
is passed directly in memory rather than in a register and letting user
space sort it out (this could be in the vdso, but the vdso may be > 4 GB
so it has to be in 64-bit mode until the last instruction.)  The
difference isn't huge; mostly an implementation detail.

A signal arriving while in the user space trampoline could seriously
complicate life.

	-hpa

