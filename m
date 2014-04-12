Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756902AbaDLXhi (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Apr 2014 19:37:38 -0400
Received: from out5-smtp.messagingengine.com ([66.111.4.29]:45933 "EHLO
	out5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750833AbaDLXhg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Apr 2014 19:37:36 -0400
X-Greylist: delayed 675 seconds by postgrey-1.27 at vger.kernel.org; Sat, 12 Apr 2014 19:37:36 EDT
Message-Id: <1397345179.1772.105823721.224E1140@webmail.messagingengine.com>
X-Sasl-Enc: xAGwK7XowtLIJHOMj+EgTPjl5nyF1CPKu0VsAiic7FVL 1397345179
From: Alexander van Heukelum <heukelum@fastmail.fm>
To: "H. Peter Anvin" <hpa@zytor.com>, Andy Lutomirski <luto@amacapital.net>,
        Brian Gerst <brgerst@gmail.com>, Ingo Molnar <mingo@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>, stable@jasper.es
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Type: text/plain
X-Mailer: MessagingEngine.com Webmail Interface - ajax-5be85a12
Subject: Re: [tip:x86/urgent] x86-64,
 modify_ldt: Ban 16-bit segments on 64-bit kernels
Date: Sun, 13 Apr 2014 01:26:19 +0200
In-Reply-To: <53485D95.9030301@zytor.com>
References: <tip-kicdm89kzw9lldryb1br9od0@git.kernel.org>
 <CAMzpN2jx4H4p8fQr-WHxVyCHhWi0iO3WZZKyxYD7Dfa7pWkEgg@mail.gmail.com>
 <53483487.6030103@zytor.com> <53485BB8.1000106@mit.edu>
 <53485D95.9030301@zytor.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

> This is a writeup I did to a select audience before this was public:

I'ld like to add an option d.2. for your consideration. Can you think of a
fundamental problem with it?

Greetings,
    Alexander

> > Some workarounds I have considered:
> > 
> > a. Using paging in a similar way to the 32-bit segment base workaround
> > 
> > This one requires a very large swath of virtual user space (depending on
> > allocation policy, as much as 4 GiB per CPU.)  The "per CPU" requirement
> > comes in as locking is not feasible -- as we return to user space there
> > is nowhere to release the lock.
> > 
> > b. Return to user space via compatibility mode
> > 
> > As the kernel lives above the 4 GiB virtual mark, a transition through
> > compatibility mode is not practical.  This would require the kernel to
> > reserve virtual address space below the 4 GiB mark, which may interfere
> > with the application, especially an application launched as a 64-bit
> > application.
> > 
> > c. Trampoline in kernel space
> > 
> > A trampoline in kernel space is not feasible since all ring transition
> > instructions capable of returning to 16-bit mode require the use of the
> > stack.

"16 bit mode" -> "a mode with 16-bit stack"

> > d. Trampoline in user space
> > 
> > A return to the vdso with values set up in registers r8-r15 would enable
> > a trampoline in user space.  Unfortunately there is no way
> > to do a far JMP entirely with register state so this would require
> > touching user space memory, possibly in an unsafe manner.

d.2. trampoline in user space via long mode

Return from the kernel to a user space trampoline via long mode.
The kernel changes the stack frame just before executing the iret
instruction. (the CS and RIP slots are set to run the trampoline code,
where CS is a long mode segment.) The trampoline code in userspace
is set up to this single instruction: a far jump to the final CS:EIP
(compatibility mode).

Because the IRET is now returning to long mode, all registers are
restored fully. The stack cannot be used at this point, but the far
jump doesn't need stack and it will/should make the stack valid
immediately after execution. The IRET enables interrupts, so the
far jump is in the interrupt shadow: it won't be seen, unless it causes
an exception.

> > The most likely variant is to use the address of the 16-bit user stack
> > and simply hope that this is a safe thing to do.
> > 
> > This appears to be the most feasible workaround if a workaround is
> > deemed necessary.
> > 
> > e. Transparently run 16-bit code segments inside a lightweight VMM

"16-bit code" -> "code with 16-bit stack"

> > The complexity of this solution versus the realized value is staggering.
> > It also doesn't work on non-virtualization-capable hardware (including
> > running on top of a VMM which doesn't support nested virtualization.)
> > 
> > 	-hpa
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 
> 
