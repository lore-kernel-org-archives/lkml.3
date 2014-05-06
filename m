Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754456AbaEFVsw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 May 2014 17:48:52 -0400
Received: from mail-vc0-f169.google.com ([209.85.220.169]:56307 "EHLO
	mail-vc0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751753AbaEFVsv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 May 2014 17:48:51 -0400
MIME-Version: 1.0
In-Reply-To: <CALCETrVHj1rd=ma-dW8C9RNyQNj3smRAyevWJSQXmvgshbQb6w@mail.gmail.com>
References: <e94ab903e725eaf9d98e56f3043878bde7fc1b58.1399408110.git.luto@amacapital.net>
	<CA+55aFy6NzQOfyne4xLqQQCvuhpi-KSXnJNLjXTRc7+4ChPAnQ@mail.gmail.com>
	<CA+55aFw_Dj7Lx_bE0B3mDxMUNz_K1yc=saziC9dmA_dKSkFWiw@mail.gmail.com>
	<CA+55aFwix8dSDQ1N1Qu2-9rzGxWeeGAv4fSPVQWGo1YNzJoCoA@mail.gmail.com>
	<CALCETrVHj1rd=ma-dW8C9RNyQNj3smRAyevWJSQXmvgshbQb6w@mail.gmail.com>
Date: Tue, 6 May 2014 14:48:50 -0700
X-Google-Sender-Auth: 2l8u7XME4WkCL8HIxb16pAQgJDE
Message-ID: <CA+55aFx8UQGS_anYJrSkkzeM+vx97-2sAUTTE6ZxDJNUKTkD0Q@mail.gmail.com>
Subject: Re: [ABOMINATION] x86: Fast interrupt return to userspace
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Andy Lutomirski <luto@amacapital.net>
Cc: Thomas Gleixner <tglx@linutronix.de>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "the arch/x86 maintainers" <x86@kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>, Gleb Natapov <gleb@kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 6, 2014 at 2:34 PM, Andy Lutomirski <luto@amacapital.net> wrote:
>
> I don't think that's enough to fix this -- interrupts may not have
> been on in the first place, I think.  I wonder if __put_user_inatomic
> would work here.

That might be the way to go, yes.

And in addition to the CS value you should probably check that TF and
RF are clear in eflags, and possibly other things too that the sysret
doesn't get right compared to iret.

> Also, sysexit might be better than sysret.  And I categorically refuse
> to add any new feature that requires vsyscall=native, so this would
> have to use the vdso instead.  Plus it's awful.

Yeah, it's disgusting. I think it is worth fixing to get better
numbers (it *would* be very interesting to hear whether this plus the
kernel 'retq' thing actually makes real device interrupt overhead
lower), but I'd be very wary of using it in production.

> Is there actual interest in turning something like this into a real
> patch?  It would almost certainly have to default off and no one sane
> would ever use it except for special-purpose machines.

I don't think it's necessarily worth actually merging, but maybe a
couple of improvements makes it go from "disgusting and unmergeable"
to just "disgusting". The "avoid iret for return to kernel mode" thing
might be more easily merged (but needs similar CS content checks to
make sure we're ok with BIOS/EFI execution environments)

            Linus
