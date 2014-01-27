Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754322AbaA0XJK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Jan 2014 18:09:10 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:44469 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753413AbaA0XJJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Jan 2014 18:09:09 -0500
Date: Mon, 27 Jan 2014 23:07:53 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andy Lutomirski <luto@amacapital.net>, Peter Anvin <hpa@zytor.com>,
        Ingo Molnar <mingo@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>,
        the arch/x86 maintainers <x86@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [RFC] de-asmify the x86-64 system call slowpath
Message-ID: <20140127230753.GF10323@ZenIV.linux.org.uk>
References: <CA+55aFzNxTtvNX7zqBELHs489e5mEx1sM=i=red=aQAGviXrNw@mail.gmail.com>
 <20140127002255.GA10323@ZenIV.linux.org.uk>
 <CA+55aFzCtJ5gfw__3A=zkjJdv9Ag2CAmtHG5MnrRnCZYqz7EQA@mail.gmail.com>
 <20140127074208.GB10323@ZenIV.linux.org.uk>
 <52E6D866.604@amacapital.net>
 <CA+55aFzWRjNC4kPeVad3isOOW+vZhnzX0Gk5_8QzD16GZEw5Kg@mail.gmail.com>
 <20140127223257.GE10323@ZenIV.linux.org.uk>
 <CA+55aFyajjkCtRiTOS2AbFOWi7qt2FUnW6T3iG9nXqoZ0O9Ljg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFyajjkCtRiTOS2AbFOWi7qt2FUnW6T3iG9nXqoZ0O9Ljg@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 27, 2014 at 02:43:14PM -0800, Linus Torvalds wrote:
> On Mon, Jan 27, 2014 at 2:32 PM, Al Viro <viro@zeniv.linux.org.uk> wrote:
> >
> > do_signal() is also a place where arbitrary changes to regs might've
> > been done by tracer, so regs->cs might need to be checked in the same
> > place where we validate regs->rip ;-/
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

The problem with validation is that we'll suddenly become sensitive to
hard-to-estimate pile of hardware bugs ;-/  E.g. which AMD-specific
errata is that comment in entry_64.S about?  The one I kinda-sorta
remember is Intel-specific, and that was about uncanonical RIP; looking
for AMD one has turned #353 (with suggested workaround being "have bit 16 set
in whatever you put into R11"), but I've no idea whether that's the only
potential issue there...
