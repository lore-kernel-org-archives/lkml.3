Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754481AbaA0WrE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Jan 2014 17:47:04 -0500
Received: from mail-vb0-f43.google.com ([209.85.212.43]:65110 "EHLO
	mail-vb0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754141AbaA0WrC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Jan 2014 17:47:02 -0500
MIME-Version: 1.0
In-Reply-To: <CA+55aFyajjkCtRiTOS2AbFOWi7qt2FUnW6T3iG9nXqoZ0O9Ljg@mail.gmail.com>
References: <CA+55aFzNxTtvNX7zqBELHs489e5mEx1sM=i=red=aQAGviXrNw@mail.gmail.com>
 <20140127002255.GA10323@ZenIV.linux.org.uk> <CA+55aFzCtJ5gfw__3A=zkjJdv9Ag2CAmtHG5MnrRnCZYqz7EQA@mail.gmail.com>
 <20140127074208.GB10323@ZenIV.linux.org.uk> <52E6D866.604@amacapital.net>
 <CA+55aFzWRjNC4kPeVad3isOOW+vZhnzX0Gk5_8QzD16GZEw5Kg@mail.gmail.com>
 <20140127223257.GE10323@ZenIV.linux.org.uk> <CA+55aFyajjkCtRiTOS2AbFOWi7qt2FUnW6T3iG9nXqoZ0O9Ljg@mail.gmail.com>
From: Andy Lutomirski <luto@amacapital.net>
Date: Mon, 27 Jan 2014 14:46:40 -0800
Message-ID: <CALCETrUXjFYd7ZC958WoNk1mnPCw2kw5jt-Ywo309EObnuqFAg@mail.gmail.com>
Subject: Re: [RFC] de-asmify the x86-64 system call slowpath
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Al Viro <viro@zeniv.linux.org.uk>, Peter Anvin <hpa@zytor.com>,
        Ingo Molnar <mingo@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>,
        "the arch/x86 maintainers" <x86@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 27, 2014 at 2:43 PM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
> On Mon, Jan 27, 2014 at 2:32 PM, Al Viro <viro@zeniv.linux.org.uk> wrote:
>>
>> do_signal() is also a place where arbitrary changes to regs might've
>> been done by tracer, so regs->cs might need to be checked in the same
>> place where we validate regs->rip ;-/
>
> Fair enough. But it would still be really easy, and make the common
> case signal delivery a bit faster.
>
> Now, sadly, most signal delivery is then followed by sigreturn (the
> exceptions being dying or doing a longjmp), so we'd still get the
> iretq then. But it would cut the iretq's related to signals in half.
>
> We *could* try to do sigreturn with sysret and a small trampoline too,
> of course. But I'm not sure how far I'd want to take it.

I once spent a while thinking about how to do this.  The best I could
come up with was to use something like 'ret 128' for the trampoline.
(The issue here is that there's no good place to shove a global
variable with the missing register values, fs and gs aren't really
available for these games, and the red zone is in the way.)

I think that sysret for sigreturn is probably not very interesting.
On the other hand, sysret for #PF might be a huge win, despite being
even scarier.

(Or someone could politely ask Intel for a couple of non-serializing
msrs that set the values of rcx and whatever other registers get
clobbered by sysret.)

--Andy
