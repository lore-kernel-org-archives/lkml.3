Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754073AbaKMQiK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Nov 2014 11:38:10 -0500
Received: from cantor2.suse.de ([195.135.220.15]:41605 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753969AbaKMQiI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Nov 2014 11:38:08 -0500
Date: Thu, 13 Nov 2014 17:38:04 +0100
From: Vojtech Pavlik <vojtech@suse.cz>
To: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: Josh Poimboeuf <jpoimboe@redhat.com>,
        Christoph Hellwig <hch@infradead.org>,
        Seth Jennings <sjenning@redhat.com>, Jiri Kosina <jkosina@suse.cz>,
        Steven Rostedt <rostedt@goodmis.org>, live-patching@vger.kernel.org,
        kpatch@redhat.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/2] Kernel Live Patching
Message-ID: <20141113163804.GA10388@suse.cz>
References: <20141107074745.GC22703@infradead.org>
 <20141107131153.GD4071@treble.redhat.com>
 <20141107140458.GA21774@suse.cz>
 <20141107154500.GF4071@treble.redhat.com>
 <20141107212735.GA21409@suse.cz>
 <54616533.1070301@hitachi.com>
 <20141111102655.GB20424@suse.cz>
 <546399E4.6050605@hitachi.com>
 <20141112214719.GA26809@suse.cz>
 <5464D4B6.5010808@hitachi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5464D4B6.5010808@hitachi.com>
X-Bounce-Cookie: It's a lemon tree, dear Watson!
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 14, 2014 at 12:56:38AM +0900, Masami Hiramatsu wrote:

> I see. I don't mind the implementation of how to check the execution path.
> I just considers that we need classify consistency requirements when
> checking the "patch" itself (maybe by manual at first).
> 
> And since your classification seemed mixing the consistency and switching
> timings, I thought we'd better split them into the consistency requirement
> flags and implementation of safeness checking :)

That makes sense. Although what classes of patches actually need what kind of
consistency is an open debate still.

> Even if you can use refcounting with per-thread patching, it still switches
> per-thread basis, inconsistent among threads.

Yes. 

> > I haven't shown yet whether the strongest consistency (LEAVE_KERNEL +
> > SWITCH_KERNEL) is possible at all. CRIU is close, but not necessarily
> > doing quite that. It might be possible to just force processes to sleep
> > at syscall entry one by one until all are asleep. Also the benefits of
> > doing that are still unclear.
> 
> Of course, that is what kernel/freezer.c does :)
> So, if you need to patch with the strongest consistency, you can freeze
> them all.

That'd be really cool. (Pun intended.)

I'd have to look deeper into freezer, but does it really stop the
threads at syscall entry? And not anywhere where they sleep? How would
it handle sleepers?

For LEAVE_KERNEL + SWITCH_KERNEL we'd have to freeze them when no kernel
function is on the stack at all.

> > The goal is to find a consistency model that is best suited for the
> > goals of both kpatch and kGraft: Reliably apply simple to
> > mid-complexity kernel patches.
> 
> Same as me. I just sorted out the possible consistency requirements.
> And I've thought that the key was "consistent in a context of each thread" or
> "consistent at the moment among all threads but not in a context" or
> "consistent in contexts of all threads". What would you think, any other
> consistency model is there?

I'm looking for the simplest solution that allows modification to
function prototypes. Because that's the most important value that both
kGraft and kpatch consistency models offer.

> > If you force a prototype change, eg by changing func() to an unsigned
> > int, or simply add a parameter, the place where it is called from will
> > also be changed and will be included in the patched set. (Or you can
> > just include it manually in the set.)
> 
> Yes.
> 
> > Then, you can be sure that the place which calls func() is not on the
> > stack when patching. This way, in your classification, PATCH_KERNEL can
> > be as good as PATCH_THREAD. In my classification, I'm saying that
> > LEAVE_PATCHED_SET is as good as LEAVE_KERNEL.
> 
> OK, but again, to be sure that, we need to dump stack for each kernel
> as I did.

Or pass through the userspace to initialize the counters as you
proposed. 

But I'd really like to avoid stack analysis or having to force every
thread through the kernel/userspace boundary.

I have one more, rather trivial idea how things could be done, I'll be
sending an email with it shortly.

> >> But how frequently the former case happens? It seems very very rare.
> >> And if we aim to enable both kpatch mode and kGraft mode in the kernel,
> >> anyway we'll have something for the latter cases.
> > 
> > The kpatch problem case isn't that rare. It just happened with a CVE in
> > futexes recently. It will happen if you try to patch anything that is on
> > the stack when a TTY or TCP read is waiting for data as another example. 
> 
> Oh, I see. this should be solved then... perhaps, we can freeze those
> tasks and thaw it again.
> 
> > The kGraft problem case will happen when you load a 3rd party module
> > with a non-annotated kernel thread. Or a different problem will happen
> > when you have an application sleeping that will exit when receiving any
> > signal.
> 
> Ah, yes. especially latter case is serious. maybe freezer can handle
> this too...

I should look into it then.

> > What I'm proposing is a LEAVE_PATCHED_SET + SWITCH_THREAD mode. It's
> > less consistency, but it is enough. And it is more reliable (likely to
> > succeed in finite time) than either kpatch or kGraft.
> 
> Yeah, that is actual merge of kpatch and kGraft, and also can avoid
> stop_machine (yes, that is important for me :)).

Good. Same here.

> > It'd be mostly based on your refcounting code, including stack
> > checking (when a process sleeps, counter gets set based on number of
> > patched functions on the stack), possibly including setting the counter
> > to 0 on syscall entry/exit, but it'd make the switch per-thread like
> > kGraft does, not for the whole system, when the respective counters
> > reach zero.
> 
> I'm not sure what happens if a process sleeps on the patched-set?

Then the patching process will be stuck until it is woken up somehow.
But it's still much better to only have to care about processes sleeping
on the patched-set than about processes sleeping anywhere (kGraft).

> If we switch the other threads, when this sleeping thread wakes up
> that will see the old functions (and old data).

Yes, until the patching process is complete, data must be kept in the
old format, even by new functions.

> So I think we need both SWITCH_THREAD and SWITCH_KERNEL options in
> that case.

With data shadowing that's not required. It still may be worth having
it.

> What I'm thinking is to merge the code (technique) of both and
> allow to choose the "switch-timing" based on the patch's consistency
> requirement.

That's what I'm thinking about, too. But I'm also thinking, "this will
be complex, is it really needed"?

> Anyway, I'd like to support for this effort from kernel side.
> At least I have to solve ftrace regs conflict by IPMODIFY flag and
> a headache kretprobe failure case by sharing per-thread retstack
> with ftrace-callgraph.

While I don't know enough about the IPMODIFY flag, I wholeheartedly
support sharing the return stacks between kprobes and ftrace graph
caller.

-- 
Vojtech Pavlik
Director SUSE Labs
