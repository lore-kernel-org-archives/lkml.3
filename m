Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753559AbaKLVrZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Nov 2014 16:47:25 -0500
Received: from jablonecka.jablonka.cz ([91.219.244.36]:34976 "EHLO
	jablonecka.jablonka.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753309AbaKLVrX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Nov 2014 16:47:23 -0500
Date: Wed, 12 Nov 2014 22:47:19 +0100
From: Vojtech Pavlik <vojtech@suse.cz>
To: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: Josh Poimboeuf <jpoimboe@redhat.com>,
        Christoph Hellwig <hch@infradead.org>,
        Seth Jennings <sjenning@redhat.com>, Jiri Kosina <jkosina@suse.cz>,
        Steven Rostedt <rostedt@goodmis.org>, live-patching@vger.kernel.org,
        kpatch@redhat.com, linux-kernel@vger.kernel.org
Subject: Re: Re: Re: [PATCH 0/2] Kernel Live Patching
Message-ID: <20141112214719.GA26809@suse.cz>
References: <20141106185857.GA7106@infradead.org>
 <20141106202423.GB2266@suse.cz>
 <20141107074745.GC22703@infradead.org>
 <20141107131153.GD4071@treble.redhat.com>
 <20141107140458.GA21774@suse.cz>
 <20141107154500.GF4071@treble.redhat.com>
 <20141107212735.GA21409@suse.cz>
 <54616533.1070301@hitachi.com>
 <20141111102655.GB20424@suse.cz>
 <546399E4.6050605@hitachi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <546399E4.6050605@hitachi.com>
X-Bounce-Cookie: It's a lemon tree, dear Watson!
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 13, 2014 at 02:33:24AM +0900, Masami Hiramatsu wrote:
> Right. Consistency model is still same as kpatch. Btw, I think
> we can just use the difference of consistency for classifying
> the patches, since we have these classes, only limited combination
> is meaningful.
> 
> >> 	LEAVE_FUNCTION
> >> 	LEAVE_PATCHED_SET
> >> 	LEAVE_KERNEL
> >>
> >> 	SWITCH_FUNCTION
> >> 	SWITCH_THREAD
> >> 	SWITCH_KERNEL
> 
> How about the below combination of consistent flags?
> 
> <flags>
> CONSISTENT_IN_THREAD - patching is consistent in a thread.
> CONSISTENT_IN_TIME - patching is atomically done.
> 
> <combination>
> (none) - the 'null' mode? same as LEAVE_FUNCTION & SWITCH_FUNCTION
> 
> CONSISTENT_IN_THREAD - kGraft mode. same as LEAVE_KERNEL & SWITCH_THREAD
> 
> CONSISTENT_IN_TIME - kpatch mode. same as LEAVE_PATCHED_SET & SWITCH_KERNEL
> 
> CONSISTENT_IN_THREAD|CONSISTENT_IN_TIME - CRIU mode. same as LEAVE_KERNEL & SWITCH_KERNEL

The reason I tried to parametrize the consistency model in a more
flexible and fine-grained manner than just describing the existing
solutions was for the purpose of exploring whether any of the remaining
combinations make sense.

It allowed me to look at what value we're getting from the consistency
models: Most importantly the ability to change function prototypes and
still make calls work.

For this, the minimum requirements are LEAVE_PATCHED_SET (what
kpatch does) and SWITCH_THREAD (which is what kGraft does). 

Both kpatch and kGraft do more, but:

I was able to show that LEAVE_KERNEL is unnecessary and any cases where
it is beneficial can be augmented by just increasing the patched set.

I believe at this point that SWITCH_KERNEL is unnecessary and that data or
locking changes - the major benefit of switching at once can be done by
shadowing/versioning of data structures, which is what both kpatch and
kGraft had planned to do anyway.

I haven't shown yet whether the strongest consistency (LEAVE_KERNEL +
SWITCH_KERNEL) is possible at all. CRIU is close, but not necessarily
doing quite that. It might be possible to just force processes to sleep
at syscall entry one by one until all are asleep. Also the benefits of
doing that are still unclear.

The goal is to find a consistency model that is best suited for the
goals of both kpatch and kGraft: Reliably apply simple to
mid-complexity kernel patches.

> So, each patch requires consistency constrains flag and livepatch tool
> chooses the mode based on the flag.
> 
> >> So, I think the patch may be classified by following four types
> >>
> >> PATCH_FUNCTION - Patching per function. This ignores context, just
> >>                change the function.
> >>                User must ensure that the new function can co-exist
> >>                with old functions on the same context (e.g. recursive
> >>                call can cause inconsistency).
> >>
> >> PATCH_THREAD - Patching per thread. If a thread leave the kernel,
> >>                changes are applied for that thread.
> >>                User must ensure that the new functions can co-exist
> >>                with old functions per-thread. Inter-thread shared
> >>                data acquisition(locks) should not be involved.
> >>
> >> PATCH_KERNEL - Patching all threads. This wait for all threads leave the
> >>                all target functions.
> >>                User must ensure that the new functions can co-exist
> >>                with old functions on a thread (note that if there is a
> >>                loop, old one can be called first n times, and new one
> >>                can be called afterwords).(**)
> > 
> > Yes, but only when the function calling it is not included in the
> > patched set, which is only a problem for semantic changes accompanied by
> > no change in the function prototyppe. This can be avoided by changing
> > the prototype deliberately.
> 
> Hmm, but what would you think about following simple case?
> 
> ----
> int func(int a) {
>   return a + 1;
> }
> 
> ...
>   b = 0;
>   for (i = 0; i < 10; i++)
>     b = func(b);
> ...
> ----
> ----
> int func(int a) {
>   return a + 2; /* Changed */
> }
> 
> ...
>   b = 0;
>   for (i = 0; i < 10; i++)
>     b = func(b);
> ...
> ----
> 
> So, after the patch, "b" will be in a range of 10 to 20, not 10 or 20.
> Of course CONSISTENT_IN_THREAD can ensure it should be 10 or 20 :)

If you force a prototype change, eg by changing func() to an unsigned
int, or simply add a parameter, the place where it is called from will
also be changed and will be included in the patched set. (Or you can
just include it manually in the set.)

Then, you can be sure that the place which calls func() is not on the
stack when patching. This way, in your classification, PATCH_KERNEL can
be as good as PATCH_THREAD. In my classification, I'm saying that
LEAVE_PATCHED_SET is as good as LEAVE_KERNEL.

> >> (*) Instead of checking stacks, at first, wait for all threads leaving
> >> the kernel once, after that, wait for refcount becomes zero and switch
> >> all the patched functions.
> > 
> > This is a very beautiful idea.
> > 
> > It does away with both the stack parsing and the kernel stopping,
> > achieving kGraft's goals, while preserving kpatch's consistency model.
> > 
> > Sadly, it combines the disadvantages of both kpatch and kGraft: From
> > kpatch it takes the inability to patch functions where threads are
> > sleeping often and as such never leave them at once. From kGraft it
> > takes the need to annotate kernel threads and wake sleepers from
> > userspace.
> 
> But how frequently the former case happens? It seems very very rare.
> And if we aim to enable both kpatch mode and kGraft mode in the kernel,
> anyway we'll have something for the latter cases.

The kpatch problem case isn't that rare. It just happened with a CVE in
futexes recently. It will happen if you try to patch anything that is on
the stack when a TTY or TCP read is waiting for data as another example. 

The kGraft problem case will happen when you load a 3rd party module
with a non-annotated kernel thread. Or a different problem will happen
when you have an application sleeping that will exit when receiving any
signal.

Both the cases can be handled with tricks and workarounds. But it'd be
much nicer to have a patching engine that is reliable.

> > So while it is beautiful, it's less practical than either kpatch or
> > kGraft alone. 
> 
> Ah, sorry for confusing, I don't tend to integrate kpatch and kGraft.
> Actually, it is just about modifying kpatch, since it may shorten
> stack-checking time.
> This means that does not change the consistency model.
> We certainly need both of kGraft mode and kpatch mode.

What I'm proposing is a LEAVE_PATCHED_SET + SWITCH_THREAD mode. It's
less consistency, but it is enough. And it is more reliable (likely to
succeed in finite time) than either kpatch or kGraft.

It'd be mostly based on your refcounting code, including stack
checking (when a process sleeps, counter gets set based on number of
patched functions on the stack), possibly including setting the counter
to 0 on syscall entry/exit, but it'd make the switch per-thread like
kGraft does, not for the whole system, when the respective counters
reach zero.

This handles the frequent sleeper case, it doesn't need annotated kernel
thread main loops, it will not need the user to wake up every process in
the system unless it sleeps in a patched function.

And it can handle all the patches that kpatch and kGraft can (it needs
shadowing for some).

> > Yes, this is what I call 'extending the patched set'. You can do that
> > either by deliberately changing the prototype of the patched function
> > being called, which causes the calling function to be considered
> > different, or just add it to the set of functions considered manually.
> 
> I'd prefer latter one :) or just gives hints of watching targets.

Me too.


-- 
Vojtech Pavlik
Director SUSE Labs
