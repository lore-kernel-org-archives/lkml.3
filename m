Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754233AbaEHMst (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 May 2014 08:48:49 -0400
Received: from mx1.redhat.com ([209.132.183.28]:31470 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753071AbaEHMso (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 May 2014 08:48:44 -0400
Date: Thu, 8 May 2014 07:48:16 -0500
From: Josh Poimboeuf <jpoimboe@redhat.com>
To: Ingo Molnar <mingo@kernel.org>
Cc: David Lang <david@lang.hm>, Frederic Weisbecker <fweisbec@gmail.com>,
        Seth Jennings <sjenning@redhat.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@redhat.com>,
        Jiri Slaby <jslaby@suse.cz>, linux-kernel@vger.kernel.org,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [RFC PATCH 0/2] kpatch: dynamic kernel patching
Message-ID: <20140508124816.GA23565@treble.redhat.com>
References: <20140506121211.GA4125@treble.redhat.com>
 <20140506140516.GF2099@localhost.localdomain>
 <20140506145010.GA6702@treble.redhat.com>
 <20140507122444.GB12234@gmail.com>
 <20140507154114.GA31555@treble.redhat.com>
 <20140507155754.GA15221@gmail.com>
 <alpine.DEB.2.02.1405071552520.5876@nftneq.ynat.uz>
 <20140508061220.GB31184@gmail.com>
 <alpine.DEB.2.02.1405072348580.17457@nftneq.ynat.uz>
 <20140508070814.GA31856@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20140508070814.GA31856@gmail.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 08, 2014 at 09:08:15AM +0200, Ingo Molnar wrote:
> 
> * David Lang <david@lang.hm> wrote:
> 
> > On Thu, 8 May 2014, Ingo Molnar wrote:
> > 
> > >>>
> > >>>No!
> > >>>
> > >>>A patch to the kernel source is 'safe' if it results in a correctly
> > >>>patched kernel source. Full stop!
> > >>>
> > >>>Live patching does not enter into this question, ever. The correctness
> > >>>of a patch to the source does not depend on 'live patching'
> > >>>considerations in any way, shape or form.
> > >>>
> > >>>Any mechanism that tries to blur these lines is broken by design.
> > >>>
> > >>>My claim is that if a patch is correct/safe in the old fashioned way,
> > >>>then a fundamental principle is that a live patching subsystem must
> > >>>either safely apply, or safely reject the live patching attempt,
> > >>>independently from any user input.
> > >>>
> > >>>It's similar to how kprobes (or ftrace) will safely reject or perform
> > >>>a live patching of the kernel.
> > >>>
> > >>>So for example, there's this recent upstream kernel fix:
> > >>>
> > >>>3ca9e5d36afb agp: info leak in agpioc_info_wrap()
> > >>>
> > >>>which fixes an information leak. The 'patch' is Git commit
> > >>>3ca9e5d36afb (i.e. it patches a very specific incoming kernel source
> > >>>tree that results in a specific outgoing source tree), and we know
> > >>>it's safe and correct.
> > >>>
> > >>>Any live patching subsystem must make sure that if this patch is
> > >>>live-patched, that this attempt is either rejected safely or performed
> > >>>safely.
> > >>>
> > >>>"We think/hope it won't blow up in most cases and we automated some
> > >>>checks halfways" or "the user must know what he is doing" is really
> > >>>not something that I think is a good concept for something as fragile
> > >>>as live patching.
> > >>
> > >>In that case you will have to reject any kernel patch that changes
> > >>any memory structure, because it's impossible as a general rule to
> > >>say that changing memory structures is going to be safe (or even
> > >>possible) to change.
> > >>
> > >>that includes any access to memory that moves around a lock
> > >
> > >Initially restricting it to such patches would be a good beginning -
> > >most of the security fixes are just failed checks, i.e. they don't
> > >typically even change any external (not on stack) memory structure,
> > >right?
> > 
> > in terms of hit-patching kernels you are correct.
> > 
> > but that's a far cry from what it sounded like you were demanding 
> > (that it must handle any kernel patch)
> 
> No, I was not demanding that at all, my suggestion was:
> 
>    > My claim is that if a patch is correct/safe in the old fashioned 
>    > way, then a fundamental principle is that a live patching 
>    > subsystem must either safely apply, or safely reject the live 
>    > patching attempt, independently from any user input.
> 
> Note the 'if'. It could start simple and stupid, and only allow cases 
> where we know the patch must be trivially safe (because it does not do 
> much in terms of disturbing globally visible state). That needs some 
> tooling help, but apparently tooling help is in place already.
> 
> And then we can complicate it from there - but have a reasonably 
> robust starting point that we _know_ works (as long as the 
> implementation is correct).

I really wonder if detecting a "trivially safe" patch is even possible.

Where do you draw the line with the following patches?

- add a call to another function which modifies global data

- add an early return or a goto which changes the way the function
  modifies (or no longer modifies) global data

- touch a local stack variable which results in global data being
  modified later in the function

- return a different value which causes the function's caller to modify
  data

-- 
Josh
