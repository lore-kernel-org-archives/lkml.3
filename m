Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751754AbaKVNF3 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Nov 2014 08:05:29 -0500
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.231]:33281 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750822AbaKVNF2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Nov 2014 08:05:28 -0500
Date: Sat, 22 Nov 2014 08:05:15 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Ingo Molnar <mingo@kernel.org>, "H. Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>, stable <stable@vger.kernel.org>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Subject: Re: [GIT PULL] ftrace/x86: Add frames pointers to trampoline as
 necessary
Message-ID: <20141122080515.1fbd62ef@gandalf.local.home>
In-Reply-To: <CA+55aFx3AZpdU2YxFrNXvhWqJ2PyhyQBqTi7v_9hGH1UV-aY4g@mail.gmail.com>
References: <20141121095037.2f5a4d4f@gandalf.local.home>
	<CA+55aFx3AZpdU2YxFrNXvhWqJ2PyhyQBqTi7v_9hGH1UV-aY4g@mail.gmail.com>
X-Mailer: Claws Mail 3.10.1 (GTK+ 2.24.25; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.142:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 21 Nov 2014 17:35:10 -0800
Linus Torvalds <torvalds@linux-foundation.org> wrote:

> On Fri, Nov 21, 2014 at 6:50 AM, Steven Rostedt <rostedt@goodmis.org> wrote:
> > +.macro create_frame parent rip
> > +#ifdef CC_USING_FENTRY
> > +       pushq \parent
> > +       pushq %rbp
> > +       movq %rsp, %rbp
> 
> This is a very strange frame.
> 
> Why do you do the "pushq \parent" at all? Why isn't this just a *real*
> frame and add it to MCOUNT_SAVE_FRAME.
> 
> You seem to create this fake frame-within-a-frame thing. It's not clear why.
> 

Honestly, I did it this way because it was the simplest way to do it.

There's three different setups this covers:

1) frame pointers and mcount

2) frame pointers and fentry

3) no frame pointers and fentry

(mcount forces frame pointers, so there's no "no frame pointers and
mcount)

You probably know all this but I'm writing this for anyone else that
might be reading this. And also let you know what I understand, which
might be wrong too ;-)

With #3 we don't need to do anything. But when frame pointers
are enabled, we have in the main code:

1) mcount

func:
		push %rbp
		mov %rsp %rbp
		[...]
		call mcount

2) fentry

func:
		call fentry
		push %rbp
		mov %rsp %rbp


On mcount, the frame pointer of the parent is pushed to the stack, with
fentry it is not.

Now when fentry is called, the stack is:

	address of return-to-parent-addr
	address of return-to-func-addr

 If fentry does just:

fentry:
		push %rbp
		mov  %rsp %rbp

Then the stack trace will see after %rbp the return to func, but it
will never see the return to parent, and the parent will be missing
from the stack trace.

At a minimum, fentry needs:

fentry:
		push 8(%rsp)    // Return to parent, not func
		push %rbp
		mov  %rsp %rbp
		push 16(%rbp)	// Return to func:
		push %rbp
		mov  %rsp %rbp

With mcount, the call is done after the parent frame pointer is setup,
so we only really need to

mcount:
		push %rbp
		mov  %rsp %rbp

My version adds an extra push %rip in the mcount case but is the same
in the fentry case which is now the default.

The ftrace_caller_setup took a little bit to get right. I'm nervous
about modifying that and breaking something. Better yet, after that is
called, the parent rip is placed in %rsi and the func rip is placed in
%rdi. By doing it the way I did it, it made it nice and convenient that
I could just make a couple of macros that handle all three cases.

If you want, I can add more comments to explain all this.

-- Steve
