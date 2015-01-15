Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751791AbbAOGKo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jan 2015 01:10:44 -0500
Received: from ozlabs.org ([103.22.144.67]:51999 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751241AbbAOGKm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jan 2015 01:10:42 -0500
Message-ID: <1421302240.11409.6.camel@ellerman.id.au>
Subject: Re: [PATCH] tracing: Allow raw_syscall tracepoints to work from boot
From: Michael Ellerman <mpe@ellerman.id.au>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, mingo@redhat.com, paulmck@linux.vnet.ibm.com,
        Andrew Morton <akpm@osdl.org>, tglx@linutronix.de,
        mathieu.desnoyers@efficios.com, xiakaixu@huawei.com
Date: Thu, 15 Jan 2015 17:10:40 +1100
In-Reply-To: <20150114130300.75c5d2ce@gandalf.local.home>
References: <1421188517-18312-1-git-send-email-mpe@ellerman.id.au>
	 <20150114130300.75c5d2ce@gandalf.local.home>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.12.7-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2015-01-14 at 13:03 -0500, Steven Rostedt wrote:
> On Wed, 14 Jan 2015 09:35:17 +1100
> Michael Ellerman <mpe@ellerman.id.au> wrote:
> 
> > In commit 5f893b2639b2 "tracing: Move enabling tracepoints to just after
> > rcu_init()", tracing was enabled earlier in boot.
> > 
> > This broke tracing of the raw_syscall tracepoints from boot using the
> > trace_event kernel parameter.
> > 
> > We can fix it by explicitly setting TIF_SYSCALL_TRACEPOINT for the
> > init_task. That way when pid 1 is cloned from init_task it will inherit
> > TIF_SYSCALL_TRACEPOINT.
> 
> I don't like setting the swap task flag for syscall tracing, as nothing
> will unset it.

We could unset it in the unregfunc(), I did that in my original patch but took
it out because I wasn't sure it was necessary.

> > It feels a bit naughty to be whacking init_task like this, but it also
> > seems like the right fix?
> 
> No, I tried the following instead.
> 
> > Should we also clear it in the unregfunc? I can't see how that would
> > ever be needed in practice?
> 
> It just seems hacky to set swapper in the first place.

Actually I thought it was neat, basically everything else comes from init_task
via copy_process().
 
> Try my patch and let me know if it works for you?

Sure. It works.

I can still see the first syscalls in the trace:

    # entries-in-buffer/entries-written: 1021354/1021354   #P:8
    #
    #                              _-----=> irqs-off
    #                             / _----=> need-resched
    #                            | / _---=> hardirq/softirq
    #                            || / _--=> preempt-depth
    #                            ||| /     delay
    #           TASK-PID   CPU#  ||||    TIMESTAMP  FUNCTION
    #              | |       |   ||||       |         |
                init-1     [000] ....     3.706370: sys_exit: NR -1 = 0
                init-1     [000] ....     3.706394: sys_enter: NR 45 (0, 0, 3fffa2e20000, 3fffcfd4eac2, 80, 3fffa2e61820)
                init-1     [000] ....     3.706395: sys_exit: NR 45 = 70367490932736
                init-1     [000] ....     3.706409: sys_enter: NR 33 (3fffa2e694d0, 0, 3fffa2e7be20, 0, 1, ffffffffe0000000)
                init-1     [000] ....     3.713325: sys_exit: NR 33 = -2
    

I like my version better, but your call.

cheers



