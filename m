Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751413AbaDMB0B (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Apr 2014 21:26:01 -0400
Received: from mail-qg0-f49.google.com ([209.85.192.49]:42218 "EHLO
	mail-qg0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750806AbaDMB0A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Apr 2014 21:26:00 -0400
MIME-Version: 1.0
In-Reply-To: <5349D44C.9070105@zytor.com>
References: <tip-kicdm89kzw9lldryb1br9od0@git.kernel.org> <CAMzpN2jx4H4p8fQr-WHxVyCHhWi0iO3WZZKyxYD7Dfa7pWkEgg@mail.gmail.com>
 <53483487.6030103@zytor.com> <53485BB8.1000106@mit.edu> <53485D95.9030301@zytor.com>
 <1397345179.1772.105823721.224E1140@webmail.messagingengine.com>
 <5349CCE3.3000003@zytor.com> <1397346568.13490.105824481.72FA2B8D@webmail.messagingengine.com>
 <5349D44C.9070105@zytor.com>
From: Andy Lutomirski <luto@amacapital.net>
Date: Sat, 12 Apr 2014 18:25:39 -0700
Message-ID: <CALCETrVwTTO43xQb8EiGdN-s8a04qU92p-t-Luo5z6aYVAvZig@mail.gmail.com>
Subject: Re: [tip:x86/urgent] x86-64, modify_ldt: Ban 16-bit segments on
 64-bit kernels
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Alexander van Heukelum <heukelum@fastmail.fm>,
        Brian Gerst <brgerst@gmail.com>, Ingo Molnar <mingo@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>, stable@jasper.es
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Apr 12, 2014 at 5:03 PM, H. Peter Anvin <hpa@zytor.com> wrote:
>>
>> No self modifying code... The far jump must be in the indirect form
>> anyhow. The CS:EIP must be accessible from user mode, but not
>> necessarily from compatibility mode. So the trampoline (the jump)
>> and data (CS:EIP) can live pretty much anywhere in virtual memory.
>> But indeed, I see what you meant now.
>>
>
> This is, in fact, exactly then what I was suggesting, except that data
> is passed directly in memory rather than in a register and letting user
> space sort it out (this could be in the vdso, but the vdso may be > 4 GB
> so it has to be in 64-bit mode until the last instruction.)  The
> difference isn't huge; mostly an implementation detail.

I'm a bit confused as to exactly what everyone is suggesting.  I don't
think there's any instruction that can do a direct far jump to an
address stored in a register.

ISTM it does matter whether SS or CS is the offending selector.  If
it's SS, then the possible trampoline sequences are:

MOV SS, ??? / POP SS / LSS
JMP/RET

or

IRET (!)


If it's CS, then we just need a far JMP or a RET or an IRET.  The far
JMP is kind of nice since we can at least use RIP-relative addressing

What are the interrupt shadow rules?  I thought IRET did not block interrupts.

>
> A signal arriving while in the user space trampoline could seriously
> complicate life.

Agreed.

Note that we're not really guaranteed to have a trampoline at all.
The vdso isn't there in CONFIG_COMPAT_VDSO mode, although the number
of users of this "feature" on OpenSUSE 9 is probably zero.

--Andy
