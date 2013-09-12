Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756693Ab3ILTzi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Sep 2013 15:55:38 -0400
Received: from mail-bk0-f51.google.com ([209.85.214.51]:51483 "EHLO
	mail-bk0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751883Ab3ILTzg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Sep 2013 15:55:36 -0400
Date: Thu, 12 Sep 2013 21:55:33 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [GIT PULL] perf fixes
Message-ID: <20130912195532.GA32644@gmail.com>
References: <20130912133855.GA23780@gmail.com>
 <CA+55aFwgyjqRHxLaWGxxsg_v07FrxbVTeLdHTGp7MfeSRjrKsQ@mail.gmail.com>
 <CA+55aFyCeXXr=57em8CC_Uzfk5PvOw0RHyA309wuOP-oDL7VxA@mail.gmail.com>
 <20130912184341.GA11400@ghostprotocols.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130912184341.GA11400@ghostprotocols.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Arnaldo Carvalho de Melo <acme@ghostprotocols.net> wrote:

> Em Thu, Sep 12, 2013 at 11:10:37AM -0700, Linus Torvalds escreveu:
> > On Thu, Sep 12, 2013 at 11:03 AM, Linus Torvalds <torvalds@linux-foundation.org> wrote:
> > > When I compiled "perf" at the same time as doing a big kernel compile,
> > > the kernel compile failed
>  
> > Oops. That may actually have been me being a bit *too* eager with a
> > "make allmodconfig" build. I can't reproduce it, and I'm starting to
> > suspect that I instead had two kernel compiles going, not one kernel
> > compile and a tools/perf/ compile.
>  
> >   "Yo Dawg, I heard you like kernel compiles, so I put a kernel
> > compile in your kernel compile so that you can compile the kernel
> > while you compile the kernel".
> 
> :-)
>  
> > But at least the "make install" problem is repeatable, though.
> 
> Well, I just tried it, and the only thing that gets rebuilt are the CHK 
> environment tests that try to figure out what can be built into perf, 
> i.e. perl, python, libaudit, etc.
> 
> Its something that annoys me as well, but not so much as to make me 
> figure out how to make those be done only if some source file changed.
> 
> But then, if you remove, say, libelf from your system so that you get a 
> perf tool that uses just /proc/kallsyms, it wouldn't detect it...

I don't think package removal is a particularly common usecase.

> Perhaps in that case we should say: want a new build with a different 
> environment? Do a 'make clean' first.

Exactly. The most common pattern is:

   make
   # see warnings about missing dependencies
   install missing packages

   make
   # no warnings, happy camper

Downgrades, package removals almost never happen in real life, let alone 
in typical build flows.

So in the simplest approximation, if we detected just the best-case: 'all 
libraries are present, we can do a full build' case and cached that fact 
across builds (and cleared the cached flag on 'make clean'), that would 
help speeding up the main usecase already.

But a cached flag per _successful_ config/feature-tests.mak testcase would 
work well too. I.e. only repeat checks that failed in the past. Once it 
succeeds there's no need to re-check.

Independent of all this is the the bug of repeat checks Linus noticed, 
that's indeed annoying and should be fixed separately of any feature test 
cache.

Thanks,

	Ingo
