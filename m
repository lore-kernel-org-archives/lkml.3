Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751132AbaKXBQc (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Nov 2014 20:16:32 -0500
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.225]:30607 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750783AbaKXBQb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Nov 2014 20:16:31 -0500
Date: Sun, 23 Nov 2014 20:16:07 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Ingo Molnar <mingo@kernel.org>, "H. Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>, stable <stable@vger.kernel.org>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Subject: Re: [GIT PULL] ftrace/x86: Add frames pointers to trampoline as
 necessary
Message-ID: <20141123201607.22388841@gandalf.local.home>
In-Reply-To: <CA+55aFwF+qCGSKdGaEgW4p6N65GZ5_XTV=1NbtWDvxnd5yYLiw@mail.gmail.com>
References: <20141121095037.2f5a4d4f@gandalf.local.home>
	<CA+55aFx3AZpdU2YxFrNXvhWqJ2PyhyQBqTi7v_9hGH1UV-aY4g@mail.gmail.com>
	<20141122080515.1fbd62ef@gandalf.local.home>
	<CA+55aFwF+qCGSKdGaEgW4p6N65GZ5_XTV=1NbtWDvxnd5yYLiw@mail.gmail.com>
X-Mailer: Claws Mail 3.10.1 (GTK+ 2.24.25; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.130:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 23 Nov 2014 14:51:57 -0800
Linus Torvalds <torvalds@linux-foundation.org> wrote:

> On Sat, Nov 22, 2014 at 5:05 AM, Steven Rostedt <rostedt@goodmis.org> wrote:
> >
> > Honestly, I did it this way because it was the simplest way to do it.
> 
> So the thing is, I already dislike the whole setup, and your patch
> just makes it worse.
> 
> And part of the problem is that there is *already* too many stupid
> layers of indirection, and "setup" macros.
> 
> And yes, they really look pretty stupid.
> 
> There's MCOUNT_SAVE_FRAME, which is supposed to create a frame, but,
> as you found out, doesn't actually do a good job of creating a real
> frame, despite its name.

Well, the MCOUNT_SAVE_FRAME is used to set up an "mcount frame" which
is different than a function call frame. Probably bad naming there, but
mcount implementation for compilers suffers from horrible
documentation, that is, lack of documentation.

This isn't an excuse, just an explanation of the history of that macro
name. It use to all be hand coded, and the macro came about in trying
to remove some duplicate code. I agree we should remove it from the
header file.

> 
> It's also in a really stupid place, excuse my french. Why is it in
> that header file?

Probably historical reasons. I could move it.

> 
> Then there's "ftrace_caller_setup", which uses MCOUNT_SAVE_FRAME, and
> sets up %rsi/rdi to have the parent/rip stuff.
> 
> And that one does a particularly bad job *too*, since it's used in
> only two of the four places that want this, with the other two doing
> the whole thing by hand (look for things like
> 
>         movq RIP(%rsp), %rsi
>         subq $MCOUNT_INSN_SIZE, %rsi
> 
> being duplicated..)

The other two places is for the static function tracing (where the call
to "mcount" is never modified into a nop, and suffers horrible
performance issues when tracing isn't enabled). And the function graph
tracer, which does something different with the parent pointer. It uses
the address of the parent as that is how it hijacks the return from the
function to trace the exit code. This is similar to what kprobes does
to trace function returns as well.


> 
> And it's also being particularly stupid about this all, because of the
> horrible MCOUNT_SAVE_FRAME placement somewhere else. That
> MCOUNT_SAVE_FRAME macro actually loads that %rip value into %rdx, but
> because of the extra indirection and odd extra macro in a header file
> (even though that one *.S file is the only apparent user),
> "ftrace_caller_setup" doesn't actually realize that, and instead just
> reloads it from where the previous macro just saved it. So the code it
> generates just looks bad too.
> 
> And now your patch adds a *third* macro, to make up for the fact that
> the first macro did a bad job.
> 
> You already have too many of these macros, and they are already ugly.
> Why not just *fix* the existing macro, instead of adding yet another
> layer of confusion and horror?
> 
> > If you want, I can add more comments to explain all this.
> 
> I'd really prefer the underlying problem to be fixed, not more
> explanations for odd code choices.
> 
> Why can't MCOUNT_SAVE_FRAME just save the frame right? Maybe even do
> it unconditionally - the cost of setting up a frame is not that huge,
> and it might be better to have more understandable code and avoid yet
> another ifdef for a config option.

If frame pointers are not enabled, I rather avoid setting them up, as
function tracing has such a huge overhead, pretty much every single op
is noticeable.

> 
> And while at it, why not move it to where it's used, and maybe make it
> not scream?
> 
> And maybe "ftrace_caller_setup" could be fixed so that the two cases
> that now do that magic MCOUNT_INSN_SIZE stuff could use it?
> 
> Looking at that file, I just get the heebie-jeebies. It's like a
> Halloween house of horrors of macros and #ifdefs. I'd really prefer
> for a fix to not just be band-aid that makes it even worse.

OK, I'll try to take some time tomorrow to see if I can clean up that
code. But anything I do will not be 3.18 or stable compatible. It would
require a redesign. This fix is the only thing I can think of for
pushing in for this late in the -rc release as well as to stable. But I
will definitely work on something to make things better.

I'm fine if you don't want to pull this change until I come up with a
better solution for my 3.19 queue. But I would not feel comfortable
with anything bigger to go into stable.

-- Steve

