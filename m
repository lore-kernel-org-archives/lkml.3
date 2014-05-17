Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751862AbaEQWqL (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 May 2014 18:46:11 -0400
Received: from jablonecka.jablonka.cz ([91.219.244.36]:39332 "EHLO
	jablonecka.jablonka.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751241AbaEQWqJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 May 2014 18:46:09 -0400
Date: Sun, 18 May 2014 00:46:03 +0200
From: Vojtech Pavlik <vojtech@suse.cz>
To: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: Jiri Kosina <jkosina@suse.cz>, Steven Rostedt <rostedt@goodmis.org>,
        Ingo Molnar <mingo@kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Josh Poimboeuf <jpoimboe@redhat.com>,
        Seth Jennings <sjenning@redhat.com>, Ingo Molnar <mingo@redhat.com>,
        Jiri Slaby <jslaby@suse.cz>, linux-kernel@vger.kernel.org,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: Re: [RFC PATCH 0/2] kpatch: dynamic kernel patching
Message-ID: <20140517224603.GA2544@suse.cz>
References: <cover.1398958771.git.jpoimboe@redhat.com>
 <20140505085537.GA32196@gmail.com>
 <20140505132638.GA14432@treble.redhat.com>
 <20140505141038.GA27403@localhost.localdomain>
 <20140505184304.GA15137@gmail.com>
 <5368CB6E.3090105@hitachi.com>
 <20140506082604.31928cb9@gandalf.local.home>
 <alpine.LNX.2.00.1405161822050.16459@pobox.suse.cz>
 <53765475.6040707@hitachi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <53765475.6040707@hitachi.com>
X-Bounce-Cookie: It's a lemon tree, dear Watson!
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, May 17, 2014 at 03:09:57AM +0900, Masami Hiramatsu wrote:
> (2014/05/17 1:27), Jiri Kosina wrote:
> > On Tue, 6 May 2014, Steven Rostedt wrote:
> > 
> >>> However, I also think if users can accept such freezing wait-time,
> >>> it means they can also accept kexec based "checkpoint-restart" patching.
> >>> So, I think the final goal of the kpatch will be live patching without
> >>> stopping the machine. I'm discussing the issue on github #138, but that is
> >>> off-topic. :)
> >>
> >> I agree with Ingo too. Being conservative at first is the right
> >> approach here. We should start out with a stop_machine making sure that
> >> everything is sane before we continue. Sure, that's not much different
> >> than a kexec, but lets take things one step at a time.
> >>
> >> ftrace did the stop_machine (and still does for some archs), and slowly
> >> moved to a more efficient method. kpatch/kgraft should follow suit.
> > 
> > I don't really agree here.
> > 
> > I actually believe that "lazy" switching kgraft is doing provides a little 
> > bit more in the sense of consistency than stop_machine()-based aproach.
> > 
> > Consider this scenario:
> > 
> > 	void foo()
> > 	{
> > 		for (i=0; i<10000; i++) {
> > 			bar(i);
> > 			something_else(i);
> > 		}
> > 	}
> 
> In this case, I'd recommend you to add foo() to replacing target
> as dummy. Then, kpatch can ensure foo() is actually not running. :)

The problem is: Where do you stop?

Adding the whole list of functions that transitively may ever call bar()
can be pretty much the whole kernel. And given that you can be calling
via pointer, you can't often even tell who is calling bar().

So yes, a developer could manually include foo() in the to be patched
list, so that it is checked that foo() isn't being executed while
patching.

But that would have to be done entirely manually after thoroughly
understanding the implications of the patch.

> > Let's say you want to live-patch bar(). With stop_machine()-based aproach, 
> > you can easily end-up with old bar() and new bar() being called in two 
> > consecutive iterations before the loop is even exited, right? (especially 
> > on preemptible kernel, or if something_else() goes to sleep).
> > 
> > With lazy-switching implemented in kgraft, this can never happen.
> 
> And I guess similar thing may happen with kgraft. If old function and
> new function share a non-auto variable and they modify it different way,
> the result will be unexpected by the mutual interference.

By non-auto I assume you mean globally accessible variable or data
structures.

Yes, with kGraft the new function has to be backward compatible with
pre-patch global data layout and semantics.

The parameters, return value and their semantics are free to change,
though, and kGraft guarantees consistency there.

-- 
Vojtech Pavlik
SUSE Labs
