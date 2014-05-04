Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753938AbaEDXqu (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 May 2014 19:46:50 -0400
Received: from mail-ee0-f41.google.com ([74.125.83.41]:44067 "EHLO
	mail-ee0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751695AbaEDXqt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 May 2014 19:46:49 -0400
Message-ID: <5366D163.9000503@redhat.com>
Date: Mon, 05 May 2014 01:46:43 +0200
From: Paolo Bonzini <pbonzini@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Andy Lutomirski <luto@amacapital.net>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        the arch/x86 maintainers <x86@kernel.org>,
        "H. Peter Anvin" <h.peter.anvin@intel.com>,
        Steven Rostedt <rostedt@goodmis.org>, Gleb Natapov <gleb@kernel.org>
Subject: Re: [RFC/HACK] x86: Fast return to kernel
References: <210a076ea197ae384705d2c02cfff12a951a62f8.1399057218.git.luto@amacapital.net>	<CA+55aFzfDgeFmzk18xJ+ZvCcm-qCsCtd4RrNxYi0CXdfNbZn_A@mail.gmail.com> <CA+55aFygkoYnJKdLas3WOq9q9pCEEk6mBOuj-zbLyLumdhStAA@mail.gmail.com>
In-Reply-To: <CA+55aFygkoYnJKdLas3WOq9q9pCEEk6mBOuj-zbLyLumdhStAA@mail.gmail.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Il 02/05/2014 21:51, Linus Torvalds ha scritto:
>> > Also, are you *really* sure that "popf" has the same one-instruction
>> > interrupt shadow that "sti" has? Because I'm not at all sure that is
>> > true, and it's not documented as far as I can tell. In contrast, the
>> > one-instruction shadow after "sti" very much _is_ documented.
> Yeah, I'm pretty sure about this. The only instructions with an
> interrupt shadow are "sti", "mov ss" and "pop ss".

Yep.

> There may be specific microarchitectures that do it for a "popf" that
> enables interrupts too, but that is not documented _anywhere_ I could
> find.
>
> Btw, on the "really easy to get wrong in emulation" note and looking
> at the kernel sources: it looks like KVM gets "pop ss" wrong, and only
> does the shadow on "mov ss".

Thanks, that's useful to know (and easy to fix).  Note that in practice 
arch/x86/kvm/emulate.c will only emulate POP SS in big real mode or if 
the stack is in MMIO memory.  The interrupt shadow will be handled by 
the processor in all other cases, and Intel calls the bit "Blocking by 
MOV SS" even if it also applies to POP SS.

Your suggested trick of splitting the return paths for IF=0/IF=1 can be 
also done like this:

	movq EFLAGS-ARGOFFSET(%rsp), %rdi
	btrq $9, %rdi		# Clear IF, save old value in CF
	movq %rdi, (%rsi)
	...
	popfq
	jnc	1f		# If IF was 0, just return
	sti			# Using STI gets us an interrupt shadow
1f:
	retq

Paolo
