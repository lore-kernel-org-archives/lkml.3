Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756966Ab3JJStS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Oct 2013 14:49:18 -0400
Received: from mail-ea0-f174.google.com ([209.85.215.174]:59655 "EHLO
	mail-ea0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755739Ab3JJStQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Oct 2013 14:49:16 -0400
MIME-Version: 1.0
In-Reply-To: <20131010183409.GP13848@laptop.programming.kicks-ass.net>
References: <20131009225006.7101379c.akpm@linux-foundation.org>
	<20131010121908.GB28601@twins.programming.kicks-ass.net>
	<20131010145738.GA5167@gmail.com>
	<20131010152612.GA13375@redhat.com>
	<20131010090044.7f12ddaf.akpm@linux-foundation.org>
	<20131010123631.1be60315@gandalf.local.home>
	<20131010094355.6f75e5a2.akpm@linux-foundation.org>
	<20131010165337.GT3081@twins.programming.kicks-ass.net>
	<20131010131305.58558079@gandalf.local.home>
	<20131010104856.8f042977112d5ac2693973ae@linux-foundation.org>
	<20131010183409.GP13848@laptop.programming.kicks-ass.net>
Date: Thu, 10 Oct 2013 11:49:15 -0700
X-Google-Sender-Auth: E42-E30mbg5Uizr-Z1bYue4XWfM
Message-ID: <CA+55aFyoP5KFUg44Xenp_Jz0_5ssosn-KF6LDsa0qsmCjyJ56g@mail.gmail.com>
Subject: Re: [PATCH 0/6] Optimize the cpu hotplug locking -v2
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Steven Rostedt <rostedt@goodmis.org>, Oleg Nesterov <oleg@redhat.com>,
        Ingo Molnar <mingo@kernel.org>,
        "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
        Paul McKenney <paulmck@linux.vnet.ibm.com>,
        Mel Gorman <mgorman@suse.de>, Rik van Riel <riel@redhat.com>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 10, 2013 at 11:34 AM, Peter Zijlstra <peterz@infradead.org> wrote:
>
> But my point is that even though there aren't many of these today; with
> the growing number of cpus in 'commodity' hardware you want to move away
> from using preempt_disable() as hotplug lock.

Umm.

Wasn't this pretty much the argument for the COMPLETELY F*CKED UP
change to make the vma locking use a semaphore?

The whole "it's more convenient to use sleeping locks" argument is
PURE AND UTTER SHIT when it comes to really core code. We are *much*
better off saying "this is core, we care so deeply about performance
that you had better use your brain before you do this".

Seriously. Your argument is bad, but more importantly, it is
*dangerously* bad. It's crap that results in bad code: and the bad
code is almost impossible to fix up later, because once you encourage
people to do the easy thing, they'll do so.

Yes, preempt_disable() is harder to use than sleeping locks. You need
to do pre-allocation etc. But it is much *much* more efficient.

And in the kernel, we care. We have the resources. Plus, we can also
say "if you can't handle it, don't do it". We don't need new features
so badly that we are willing to screw up core code.

As to your kernel/events/core.c example, things like that are
generally pretty easy to fix. The good thing about preemption-disable
is:

 - it's pretty easily debuggable, because you do get big warnings of
"you screwed up exactly _here_"

 - it's so cheap that especially when it comes to things that can
sleep, it's perfectly ok to drop the preemption count, do the sleeping
thing, re-disable preemption and then check if we still needed the
data.

Oh, and I'm sure there are several users that currently depend on
being able to sleep over get_online_cpu's.  But I'm pretty sure it's
"several", not "hundreds", and I think we could fix them up.

                 Linus
