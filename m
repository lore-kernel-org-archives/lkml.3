Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751454AbaKKBYN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Nov 2014 20:24:13 -0500
Received: from mail9.hitachi.co.jp ([133.145.228.44]:52441 "EHLO
	mail9.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750799AbaKKBYL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Nov 2014 20:24:11 -0500
Message-ID: <54616533.1070301@hitachi.com>
Date: Tue, 11 Nov 2014 10:24:03 +0900
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
Subject: Re: Re: [PATCH 0/2] Kernel Live Patching
References: <1415284748-14648-1-git-send-email-sjenning@redhat.com> <20141106184446.GA12779@infradead.org> <20141106185157.GB29272@suse.cz> <20141106185857.GA7106@infradead.org> <20141106202423.GB2266@suse.cz> <20141107074745.GC22703@infradead.org> <20141107131153.GD4071@treble.redhat.com> <20141107140458.GA21774@suse.cz> <20141107154500.GF4071@treble.redhat.com> <20141107212735.GA21409@suse.cz>
In-Reply-To: <20141107212735.GA21409@suse.cz>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

(2014/11/08 6:27), Vojtech Pavlik wrote:
> On Fri, Nov 07, 2014 at 09:45:00AM -0600, Josh Poimboeuf wrote:
> 
>>> 	LEAVE_FUNCTION
>>> 	LEAVE_PATCHED_SET
>>> 	LEAVE_KERNEL
>>>
>>> 	SWITCH_FUNCTION
>>> 	SWITCH_THREAD
>>> 	SWITCH_KERNEL
>>>
>>> Now with those definitions:
>>>
>>> 	livepatch (null model), as is, is LEAVE_FUNCTION and SWITCH_FUNCTION
>>>
>>> 	kpatch, masami-refcounting and Ksplice are LEAVE_PATCHED_SET and SWITCH_KERNEL
>>>
>>> 	kGraft is LEAVE_KERNEL and SWITCH_THREAD
>>>
>>> 	CRIU/kexec is LEAVE_KERNEL and SWITCH_KERNEL
>>
>> Thanks, nice analysis!

Hmm, I doubt this can cover all. what I'm thinking is a combination of
LEAVE_KERNEL and SWITCH_KERNEL by using my refcounting and kGraft's
per-thread "new universe" flagging(*). It switches all threads but not
change entire kernel as kexec does.

So, I think the patch may be classified by following four types

PATCH_FUNCTION - Patching per function. This ignores context, just
               change the function.
               User must ensure that the new function can co-exist
               with old functions on the same context (e.g. recursive
               call can cause inconsistency).

PATCH_THREAD - Patching per thread. If a thread leave the kernel,
               changes are applied for that thread.
               User must ensure that the new functions can co-exist
               with old functions per-thread. Inter-thread shared
               data acquisition(locks) should not be involved.

PATCH_KERNEL - Patching all threads. This wait for all threads leave the
               all target functions.
               User must ensure that the new functions can co-exist
               with old functions on a thread (note that if there is a
               loop, old one can be called first n times, and new one
               can be called afterwords).(**)

RENEW_KERNEL - Renew entire kernel and reset internally. No patch limitation,
               but involving kernel resetting. This may take a time.

(*) Instead of checking stacks, at first, wait for all threads leaving
the kernel once, after that, wait for refcount becomes zero and switch
all the patched functions.

(**) For the loops, if it is a simple loop or some simple lock calls,
we can wait for all threads leave the caller function to avoid inconsistency
by using refcounting.


>>> By blending kGraft and masami-refcounting, we could create a consistency
>>> engine capable of almost any combination of these properties and thus
>>> all the consistency models.
>>
>> Can you elaborate on what this would look like?
> 
> There would be the refcounting engine, counting entries/exits of the
> area of interest (nothing for LEAVE_FUNCTION, patched functions for
> LEAVE_PATCHED_SET - same as Masami's work now, or syscall entry/exit for
> LEAVE_KERNEL), and it'd do the counting either per thread, flagging a
> thread as 'new universe' when the count goes to zero, or flipping a
> 'new universe' switch for the whole kernel when the count goes down to zero.

Ah, that's similar thing what I'd like to try next :)

Sorry, here is an off-topic talk.
I think a problem of kGraft's LEAVE_KERNEL work is that the sleeping
processes. To ensure all the threads are changing to new universe,
we need to wakeup all the threads, or we need stack-dumping to find
someone is sleeping on the target functions. What would the kGraft do
for this issue?

> A patch would have flags which specify a combination of the above
> properties that are needed for successful patching of that specific
> patch.

Agreed.

Thank you,
-- 
Masami HIRAMATSU
Software Platform Research Dept. Linux Technology Center
Hitachi, Ltd., Yokohama Research Laboratory
E-mail: masami.hiramatsu.pt@hitachi.com


