Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752828AbaKKK1A (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2014 05:27:00 -0500
Received: from cantor2.suse.de ([195.135.220.15]:35752 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751333AbaKKK06 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2014 05:26:58 -0500
Date: Tue, 11 Nov 2014 11:26:55 +0100
From: Vojtech Pavlik <vojtech@suse.cz>
To: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: Josh Poimboeuf <jpoimboe@redhat.com>,
        Christoph Hellwig <hch@infradead.org>,
        Seth Jennings <sjenning@redhat.com>, Jiri Kosina <jkosina@suse.cz>,
        Steven Rostedt <rostedt@goodmis.org>, live-patching@vger.kernel.org,
        kpatch@redhat.com, linux-kernel@vger.kernel.org
Subject: Re: Re: [PATCH 0/2] Kernel Live Patching
Message-ID: <20141111102655.GB20424@suse.cz>
References: <20141106184446.GA12779@infradead.org>
 <20141106185157.GB29272@suse.cz>
 <20141106185857.GA7106@infradead.org>
 <20141106202423.GB2266@suse.cz>
 <20141107074745.GC22703@infradead.org>
 <20141107131153.GD4071@treble.redhat.com>
 <20141107140458.GA21774@suse.cz>
 <20141107154500.GF4071@treble.redhat.com>
 <20141107212735.GA21409@suse.cz>
 <54616533.1070301@hitachi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <54616533.1070301@hitachi.com>
X-Bounce-Cookie: It's a lemon tree, dear Watson!
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 11, 2014 at 10:24:03AM +0900, Masami Hiramatsu wrote:

> Hmm, I doubt this can cover all. what I'm thinking is a combination of
> LEAVE_KERNEL and SWITCH_KERNEL by using my refcounting and kGraft's
> per-thread "new universe" flagging(*). It switches all threads but not
> change entire kernel as kexec does.

While your approach described below indeed forces all threads to leave
kernel once, to initialize the reference counts, this can be considered
a preparatory phase before the actual patching begins.

The actual consistency model remains unchanged from what kpatch offers
today, which guarantees that at the time of switch, no execution thread
is inside the set of patched functions and that the switch happens at
once for all threads. Hence I'd still classify the consistency model
offered as LEAVE_PATCHED_SET SWITCH_KERNEL.

> So, I think the patch may be classified by following four types
> 
> PATCH_FUNCTION - Patching per function. This ignores context, just
>                change the function.
>                User must ensure that the new function can co-exist
>                with old functions on the same context (e.g. recursive
>                call can cause inconsistency).
> 
> PATCH_THREAD - Patching per thread. If a thread leave the kernel,
>                changes are applied for that thread.
>                User must ensure that the new functions can co-exist
>                with old functions per-thread. Inter-thread shared
>                data acquisition(locks) should not be involved.
> 
> PATCH_KERNEL - Patching all threads. This wait for all threads leave the
>                all target functions.
>                User must ensure that the new functions can co-exist
>                with old functions on a thread (note that if there is a
>                loop, old one can be called first n times, and new one
>                can be called afterwords).(**)

Yes, but only when the function calling it is not included in the
patched set, which is only a problem for semantic changes accompanied by
no change in the function prototyppe. This can be avoided by changing
the prototype deliberately.

> RENEW_KERNEL - Renew entire kernel and reset internally. No patch limitation,
>                but involving kernel resetting. This may take a time.

And involves recording the userspace-kernel interface state exactly. The
interface is fairly large, so this can become hairy.

> (*) Instead of checking stacks, at first, wait for all threads leaving
> the kernel once, after that, wait for refcount becomes zero and switch
> all the patched functions.

This is a very beautiful idea.

It does away with both the stack parsing and the kernel stopping,
achieving kGraft's goals, while preserving kpatch's consistency model.

Sadly, it combines the disadvantages of both kpatch and kGraft: From
kpatch it takes the inability to patch functions where threads are
sleeping often and as such never leave them at once. From kGraft it
takes the need to annotate kernel threads and wake sleepers from
userspace.

So while it is beautiful, it's less practical than either kpatch or
kGraft alone. 

> (**) For the loops, if it is a simple loop or some simple lock calls,
> we can wait for all threads leave the caller function to avoid inconsistency
> by using refcounting.

Yes, this is what I call 'extending the patched set'. You can do that
either by deliberately changing the prototype of the patched function
being called, which causes the calling function to be considered
different, or just add it to the set of functions considered manually.

> > There would be the refcounting engine, counting entries/exits of the
> > area of interest (nothing for LEAVE_FUNCTION, patched functions for
> > LEAVE_PATCHED_SET - same as Masami's work now, or syscall entry/exit for
> > LEAVE_KERNEL), and it'd do the counting either per thread, flagging a
> > thread as 'new universe' when the count goes to zero, or flipping a
> > 'new universe' switch for the whole kernel when the count goes down to zero.
> 
> Ah, that's similar thing what I'd like to try next :)

Cool.

> Sorry, here is an off-topic talk.  I think a problem of kGraft's
> LEAVE_KERNEL work is that the sleeping processes. To ensure all the
> threads are changing to new universe, we need to wakeup all the
> threads, or we need stack-dumping to find someone is sleeping on the
> target functions. What would the kGraft do for this issue?

Yes, kGraft uses an userspace helper to find such sleeper and wake them
by sending a SIGUSR1 or SIGSTOP/SIGCONT. It's one of the disadvantages
of kGraft that sleeper threads have to be handled possibly case by case.

Also, kernel threads are problematic for kGraft (as you may have seen in
earlier kGraft upstream submissions) as they never leave the kernel.

-- 
Vojtech Pavlik
Director SUSE Labs
