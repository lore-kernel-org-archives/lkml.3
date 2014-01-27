Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753413AbaA0HmY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Jan 2014 02:42:24 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:43552 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750895AbaA0HmX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Jan 2014 02:42:23 -0500
Date: Mon, 27 Jan 2014 07:42:09 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Peter Anvin <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>,
        the arch/x86 maintainers <x86@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [RFC] de-asmify the x86-64 system call slowpath
Message-ID: <20140127074208.GB10323@ZenIV.linux.org.uk>
References: <CA+55aFzNxTtvNX7zqBELHs489e5mEx1sM=i=red=aQAGviXrNw@mail.gmail.com>
 <20140127002255.GA10323@ZenIV.linux.org.uk>
 <CA+55aFzCtJ5gfw__3A=zkjJdv9Ag2CAmtHG5MnrRnCZYqz7EQA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFzCtJ5gfw__3A=zkjJdv9Ag2CAmtHG5MnrRnCZYqz7EQA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jan 26, 2014 at 08:32:09PM -0800, Linus Torvalds wrote:
> On Sun, Jan 26, 2014 at 4:22 PM, Al Viro <viro@zeniv.linux.org.uk> wrote:
> >
> > Umm...  Can't uprobe_notify_resume() modify regs as well?
> 
> Probably.
> 
> .. and on the other hand, we should actually be able to use 'sysret'
> for signal handling on x86-64, because while sysret destroys %rcx and
> doesn't allow for returning to odd modes, for calling a signal handler
> I don't think we really care..

I'm afraid we might:

 * When user can change the frames always force IRET. That is because
 * it deals with uncanonical addresses better. SYSRET has trouble
 * with them due to bugs in both AMD and Intel CPUs.

IIRC, that was about SYSRET with something unpleasant left in RCX, which
comes from regs->ip, which is set to sa_handler by __setup_rt_frame().
And we do not normalize or validate that - not in __setup_rt_frame() and
not at sigaction(2) time.  Something about GPF triggered and buggering
attacker-chosen memory area?  I don't remember details, but IIRC the
conclusion had been "just don't go there"...

Note that we can manipulate regs->ip and regs->sp, regardless of validation
at sigaction(2) or __setup_rt_frame() - just have the sucker ptraced, send
it a signal and it'll stop on delivery.  Then tracer can use ptrace to modify
registers and issue PTRACE_CONT with zero signal.  Voila - regs->[is]p
set to arbitrary values, no signal handlers triggered...
