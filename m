Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753308AbaKLRdd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Nov 2014 12:33:33 -0500
Received: from mail9.hitachi.co.jp ([133.145.228.44]:51639 "EHLO
	mail9.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751685AbaKLRdc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Nov 2014 12:33:32 -0500
Message-ID: <546399E4.6050605@hitachi.com>
Date: Thu, 13 Nov 2014 02:33:24 +0900
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Organization: Hitachi, Ltd., Japan
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:13.0) Gecko/20120614 Thunderbird/13.0.1
MIME-Version: 1.0
To: Vojtech Pavlik <vojtech@suse.cz>
Cc: Josh Poimboeuf <jpoimboe@redhat.com>,
        Christoph Hellwig <hch@infradead.org>,
        Seth Jennings <sjenning@redhat.com>, Jiri Kosina <jkosina@suse.cz>,
        Steven Rostedt <rostedt@goodmis.org>, live-patching@vger.kernel.org,
        kpatch@redhat.com, linux-kernel@vger.kernel.org
Subject: Re: Re: Re: [PATCH 0/2] Kernel Live Patching
References: <20141106184446.GA12779@infradead.org> <20141106185157.GB29272@suse.cz> <20141106185857.GA7106@infradead.org> <20141106202423.GB2266@suse.cz> <20141107074745.GC22703@infradead.org> <20141107131153.GD4071@treble.redhat.com> <20141107140458.GA21774@suse.cz> <20141107154500.GF4071@treble.redhat.com> <20141107212735.GA21409@suse.cz> <54616533.1070301@hitachi.com> <20141111102655.GB20424@suse.cz>
In-Reply-To: <20141111102655.GB20424@suse.cz>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2014/11/11 19:26), Vojtech Pavlik wrote:
> On Tue, Nov 11, 2014 at 10:24:03AM +0900, Masami Hiramatsu wrote:
> 
>> Hmm, I doubt this can cover all. what I'm thinking is a combination of
>> LEAVE_KERNEL and SWITCH_KERNEL by using my refcounting and kGraft's
>> per-thread "new universe" flagging(*). It switches all threads but not
>> change entire kernel as kexec does.
> 
> While your approach described below indeed forces all threads to leave
> kernel once, to initialize the reference counts, this can be considered
> a preparatory phase before the actual patching begins.
> 
> The actual consistency model remains unchanged from what kpatch offers
> today, which guarantees that at the time of switch, no execution thread
> is inside the set of patched functions and that the switch happens at
> once for all threads. Hence I'd still classify the consistency model
> offered as LEAVE_PATCHED_SET SWITCH_KERNEL.

Right. Consistency model is still same as kpatch. Btw, I think
we can just use the difference of consistency for classifying
the patches, since we have these classes, only limited combination
is meaningful.

>> 	LEAVE_FUNCTION
>> 	LEAVE_PATCHED_SET
>> 	LEAVE_KERNEL
>>
>> 	SWITCH_FUNCTION
>> 	SWITCH_THREAD
>> 	SWITCH_KERNEL

How about the below combination of consistent flags?

<flags>
CONSISTENT_IN_THREAD - patching is consistent in a thread.
CONSISTENT_IN_TIME - patching is atomically done.

<combination>
(none) - the 'null' mode? same as LEAVE_FUNCTION & SWITCH_FUNCTION

CONSISTENT_IN_THREAD - kGraft mode. same as LEAVE_KERNEL & SWITCH_THREAD

CONSISTENT_IN_TIME - kpatch mode. same as LEAVE_PATCHED_SET & SWITCH_KERNEL

CONSISTENT_IN_THREAD|CONSISTENT_IN_TIME - CRIU mode. same as LEAVE_KERNEL & SWITCH_KERNEL

So, each patch requires consistency constrains flag and livepatch tool
chooses the mode based on the flag.

>> So, I think the patch may be classified by following four types
>>
>> PATCH_FUNCTION - Patching per function. This ignores context, just
>>                change the function.
>>                User must ensure that the new function can co-exist
>>                with old functions on the same context (e.g. recursive
>>                call can cause inconsistency).
>>
>> PATCH_THREAD - Patching per thread. If a thread leave the kernel,
>>                changes are applied for that thread.
>>                User must ensure that the new functions can co-exist
>>                with old functions per-thread. Inter-thread shared
>>                data acquisition(locks) should not be involved.
>>
>> PATCH_KERNEL - Patching all threads. This wait for all threads leave the
>>                all target functions.
>>                User must ensure that the new functions can co-exist
>>                with old functions on a thread (note that if there is a
>>                loop, old one can be called first n times, and new one
>>                can be called afterwords).(**)
> 
> Yes, but only when the function calling it is not included in the
> patched set, which is only a problem for semantic changes accompanied by
> no change in the function prototyppe. This can be avoided by changing
> the prototype deliberately.

Hmm, but what would you think about following simple case?

----
int func(int a) {
  return a + 1;
}

...
  b = 0;
  for (i = 0; i < 10; i++)
    b = func(b);
...
----
----
int func(int a) {
  return a + 2; /* Changed */
}

...
  b = 0;
  for (i = 0; i < 10; i++)
    b = func(b);
...
----

So, after the patch, "b" will be in a range of 10 to 20, not 10 or 20.
Of course CONSISTENT_IN_THREAD can ensure it should be 10 or 20 :)

> 
>> RENEW_KERNEL - Renew entire kernel and reset internally. No patch limitation,
>>                but involving kernel resetting. This may take a time.
> 
> And involves recording the userspace-kernel interface state exactly. The
> interface is fairly large, so this can become hairy.
> 
>> (*) Instead of checking stacks, at first, wait for all threads leaving
>> the kernel once, after that, wait for refcount becomes zero and switch
>> all the patched functions.
> 
> This is a very beautiful idea.
> 
> It does away with both the stack parsing and the kernel stopping,
> achieving kGraft's goals, while preserving kpatch's consistency model.
> 
> Sadly, it combines the disadvantages of both kpatch and kGraft: From
> kpatch it takes the inability to patch functions where threads are
> sleeping often and as such never leave them at once. From kGraft it
> takes the need to annotate kernel threads and wake sleepers from
> userspace.

But how frequently the former case happens? It seems very very rare.
And if we aim to enable both kpatch mode and kGraft mode in the kernel,
anyway we'll have something for the latter cases.

> 
> So while it is beautiful, it's less practical than either kpatch or
> kGraft alone. 

Ah, sorry for confusing, I don't tend to integrate kpatch and kGraft.
Actually, it is just about modifying kpatch, since it may shorten
stack-checking time.
This means that does not change the consistency model.
We certainly need both of kGraft mode and kpatch mode.

>> (**) For the loops, if it is a simple loop or some simple lock calls,
>> we can wait for all threads leave the caller function to avoid inconsistency
>> by using refcounting.
> 
> Yes, this is what I call 'extending the patched set'. You can do that
> either by deliberately changing the prototype of the patched function
> being called, which causes the calling function to be considered
> different, or just add it to the set of functions considered manually.

I'd prefer latter one :) or just gives hints of watching targets.

>>> There would be the refcounting engine, counting entries/exits of the
>>> area of interest (nothing for LEAVE_FUNCTION, patched functions for
>>> LEAVE_PATCHED_SET - same as Masami's work now, or syscall entry/exit for
>>> LEAVE_KERNEL), and it'd do the counting either per thread, flagging a
>>> thread as 'new universe' when the count goes to zero, or flipping a
>>> 'new universe' switch for the whole kernel when the count goes down to zero.
>>
>> Ah, that's similar thing what I'd like to try next :)
> 
> Cool.
> 
>> Sorry, here is an off-topic talk.  I think a problem of kGraft's
>> LEAVE_KERNEL work is that the sleeping processes. To ensure all the
>> threads are changing to new universe, we need to wakeup all the
>> threads, or we need stack-dumping to find someone is sleeping on the
>> target functions. What would the kGraft do for this issue?
> 
> Yes, kGraft uses an userspace helper to find such sleeper and wake them
> by sending a SIGUSR1 or SIGSTOP/SIGCONT. It's one of the disadvantages
> of kGraft that sleeper threads have to be handled possibly case by case.
> Also, kernel threads are problematic for kGraft (as you may have seen in
> earlier kGraft upstream submissions) as they never leave the kernel.

Ah, I see. Perhaps, you can use stack-checking for sleeping threads and
context-switch hooking for kernel threads as kpatch does :)
Of course this will have a downside that patching can fail, but
can avoid such problems.

Thank you!


-- 
Masami HIRAMATSU
Software Platform Research Dept. Linux Technology Research Center
Hitachi, Ltd., Yokohama Research Laboratory
E-mail: masami.hiramatsu.pt@hitachi.com


