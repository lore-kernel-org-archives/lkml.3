Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752588Ab3BQTjw (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Feb 2013 14:39:52 -0500
Received: from e36.co.us.ibm.com ([32.97.110.154]:43732 "EHLO
	e36.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752395Ab3BQTjv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Feb 2013 14:39:51 -0500
Date: Sat, 16 Feb 2013 13:07:15 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Frederic Weisbecker <fweisbec@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>, Dave Jones <davej@redhat.com>,
        Hugh Dickins <hughd@google.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Paul McKenney <paul.mckenney@linaro.org>
Subject: Re: Debugging Thinkpad T430s occasional suspend failure.
Message-ID: <20130216210715.GC3094@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20130213193411.GA15928@redhat.com>
 <CA+55aFzmEDriX26Z7oJZg9yssFdCAaYwu6krmrwqfj2TBsxA4w@mail.gmail.com>
 <20130215011503.GA11914@redhat.com>
 <CA+55aFyVE0jyu9uw659ERw5E2DdOhwkQp3gk=gcXP0xrmMh9qA@mail.gmail.com>
 <20130215174435.GA2792@linux.vnet.ibm.com>
 <CA+55aFy8FeGMOnWwkfmyFYyVCw+k1LSVg7BG0tsTNZzqi5EKYg@mail.gmail.com>
 <CA+55aFwHtFeN97E-zW2QKQWH8vu=g29cxevvEnpEnHc8dx7oWA@mail.gmail.com>
 <CA+55aFyXo89LQ0mboxVYB5SJ08D8=Kv0=cqYHAd6-H7nmp=S-w@mail.gmail.com>
 <20130216192554.GB7035@linux.vnet.ibm.com>
 <CA+55aFy821kt0cz=nNB45e0K-hGUfairbTEgNP6E65jkA6bWaA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFy821kt0cz=nNB45e0K-hGUfairbTEgNP6E65jkA6bWaA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13021719-7606-0000-0000-0000087F1198
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Feb 16, 2013 at 11:46:59AM -0800, Linus Torvalds wrote:
> On Sat, Feb 16, 2013 at 11:25 AM, Paul E. McKenney
> <paulmck@linux.vnet.ibm.com> wrote:
> >
> > Sorry for the delay in testing this, but there was a need to upgrade
> > my laptop, and bozo here figured "why not go to 64 bits while I am at
> > it?" -- and then proceeded to learn the hard way that it is necessary
> > to do "make mrproper" before doing a build in 64-bit mode.  :-/
> 
> Hmm. Our object file dependency check includes checking that the
> compiler options are the same, but that's only true for normal C
> files. Some of the other rules do *not* test the full range of config
> options, so in general, if you change architecture etc models, you do
> indeed want to make sure that you do a "make distclean" (aka "make
> mrproper") or something like "git clean -dqfx".
> 
> For a number of other files, we just depend on the normal make
> timestamp logic, which means that "if the object file is newer than
> the sources", we'll trust it. Which obviously doesn't work for cases
> where the object file may have been generated under totally different
> architecture rules..
> 
> (That said, what kind of old environment did you do this in?
> stub32_sigaltstack was removed during the merge window, so I'm
> assuming you applied my patch on top of plain 3.7 or something?)

This was in a git tree 3.7-rc7.  And stub32_sigaltstack is now gone,
but perhaps I did something stupid that made it persist.

Ah, the previous time I did a build directly out of this git tree
might well have been before 3.8-rc, so maybe the .o file was from before?

> > The kernel build system's way of telling you this at the moment is:
> >
> > arch/x86/built-in.o:(.rodata+0x4990): undefined reference to `stub32_sigaltstack'
> 
> Adding Peter Anvin to the people, just in case he sees what's wrong
> with the system call stub generation that keeps excessively old object
> files around. If it's easy to fix, it might be worth trying to make it
> ok to switch from i386 to x86-64 and back in the same tree.
> 
> Peter? Not a big deal, but if you see something obvious, let's just
> try to fix it, ok?
> 
> > Anyway, with this patch, I see CPU stall warnings when running rcutorture
> > as shown below.  This is not a hard failure:
> 
> Yeah, there's something wrong with the patch, I didn't bother trying
> to figure it out for now. It also causes a hard failure with lockdep
> (or lock proving/debugging, I'm not sure which one triggered it) - and
> it happens too early to even see anything on the screen.

Glad that it is not just me, then.  ;-)

> So I'd like to make that "downgrade from hardirq to softirq" atomic,
> and I think it would clean up the crazy code too (currently it does a
> *lot* of back-and-forth on the preempt flags), but I clearly missed
> some case where we used a wrapper or two to add some tracepoint or a
> RCU scheduling point. And I'm not going to worry about it right now,
> since I'm preparing to make v3.8 soon.
> 
> But if somebody spots the bug, holler.

I must confess that your patch looked OK to me...

							Thanx, Paul

