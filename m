Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752603AbaKWWv7 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Nov 2014 17:51:59 -0500
Received: from mail-qg0-f52.google.com ([209.85.192.52]:63835 "EHLO
	mail-qg0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752488AbaKWWv5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Nov 2014 17:51:57 -0500
MIME-Version: 1.0
In-Reply-To: <20141122080515.1fbd62ef@gandalf.local.home>
References: <20141121095037.2f5a4d4f@gandalf.local.home>
	<CA+55aFx3AZpdU2YxFrNXvhWqJ2PyhyQBqTi7v_9hGH1UV-aY4g@mail.gmail.com>
	<20141122080515.1fbd62ef@gandalf.local.home>
Date: Sun, 23 Nov 2014 14:51:57 -0800
X-Google-Sender-Auth: aecrTZOht-e1byeYh931gWOt-lg
Message-ID: <CA+55aFwF+qCGSKdGaEgW4p6N65GZ5_XTV=1NbtWDvxnd5yYLiw@mail.gmail.com>
Subject: Re: [GIT PULL] ftrace/x86: Add frames pointers to trampoline as necessary
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Ingo Molnar <mingo@kernel.org>, "H. Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>, stable <stable@vger.kernel.org>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Nov 22, 2014 at 5:05 AM, Steven Rostedt <rostedt@goodmis.org> wrote:
>
> Honestly, I did it this way because it was the simplest way to do it.

So the thing is, I already dislike the whole setup, and your patch
just makes it worse.

And part of the problem is that there is *already* too many stupid
layers of indirection, and "setup" macros.

And yes, they really look pretty stupid.

There's MCOUNT_SAVE_FRAME, which is supposed to create a frame, but,
as you found out, doesn't actually do a good job of creating a real
frame, despite its name.

It's also in a really stupid place, excuse my french. Why is it in
that header file?

Then there's "ftrace_caller_setup", which uses MCOUNT_SAVE_FRAME, and
sets up %rsi/rdi to have the parent/rip stuff.

And that one does a particularly bad job *too*, since it's used in
only two of the four places that want this, with the other two doing
the whole thing by hand (look for things like

        movq RIP(%rsp), %rsi
        subq $MCOUNT_INSN_SIZE, %rsi

being duplicated..)

And it's also being particularly stupid about this all, because of the
horrible MCOUNT_SAVE_FRAME placement somewhere else. That
MCOUNT_SAVE_FRAME macro actually loads that %rip value into %rdx, but
because of the extra indirection and odd extra macro in a header file
(even though that one *.S file is the only apparent user),
"ftrace_caller_setup" doesn't actually realize that, and instead just
reloads it from where the previous macro just saved it. So the code it
generates just looks bad too.

And now your patch adds a *third* macro, to make up for the fact that
the first macro did a bad job.

You already have too many of these macros, and they are already ugly.
Why not just *fix* the existing macro, instead of adding yet another
layer of confusion and horror?

> If you want, I can add more comments to explain all this.

I'd really prefer the underlying problem to be fixed, not more
explanations for odd code choices.

Why can't MCOUNT_SAVE_FRAME just save the frame right? Maybe even do
it unconditionally - the cost of setting up a frame is not that huge,
and it might be better to have more understandable code and avoid yet
another ifdef for a config option.

And while at it, why not move it to where it's used, and maybe make it
not scream?

And maybe "ftrace_caller_setup" could be fixed so that the two cases
that now do that magic MCOUNT_INSN_SIZE stuff could use it?

Looking at that file, I just get the heebie-jeebies. It's like a
Halloween house of horrors of macros and #ifdefs. I'd really prefer
for a fix to not just be band-aid that makes it even worse.

                   Linus
