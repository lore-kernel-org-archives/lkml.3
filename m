Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753918AbbAON57 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jan 2015 08:57:59 -0500
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.227]:28984 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752094AbbAON55 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jan 2015 08:57:57 -0500
Date: Thu, 15 Jan 2015 08:58:17 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: Michael Ellerman <mpe@ellerman.id.au>
Cc: linux-kernel@vger.kernel.org, mingo@redhat.com, paulmck@linux.vnet.ibm.com,
        Andrew Morton <akpm@osdl.org>, tglx@linutronix.de,
        mathieu.desnoyers@efficios.com, xiakaixu@huawei.com
Subject: Re: [PATCH] tracing: Allow raw_syscall tracepoints to work from
 boot
Message-ID: <20150115085817.46708f7f@grimm.local.home>
In-Reply-To: <1421302240.11409.6.camel@ellerman.id.au>
References: <1421188517-18312-1-git-send-email-mpe@ellerman.id.au>
	<20150114130300.75c5d2ce@gandalf.local.home>
	<1421302240.11409.6.camel@ellerman.id.au>
X-Mailer: Claws Mail 3.11.1 (GTK+ 2.24.25; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.142:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 15 Jan 2015 17:10:40 +1100
Michael Ellerman <mpe@ellerman.id.au> wrote:

> > 
> > I don't like setting the swap task flag for syscall tracing, as
> > nothing will unset it.
> 
> We could unset it in the unregfunc(), I did that in my original patch
> but took it out because I wasn't sure it was necessary.

Yes we could but that shows the issue with this approach. We can not
just use for_each_process_thread(). swapper is special, and we really
shouldn't touch it for this special case (cmdline usage).

> 
> Actually I thought it was neat, basically everything else comes from
> init_task via copy_process().

Yes, but only at boot up. After that, the swapper is not part of the
game. That's why its not part of for_each_process_thread().

>  
> > Try my patch and let me know if it works for you?
> 
> Sure. It works.
> 
> I can still see the first syscalls in the trace:
> 
>     # entries-in-buffer/entries-written: 1021354/1021354   #P:8
>     #
>     #                              _-----=> irqs-off
>     #                             / _----=> need-resched
>     #                            | / _---=> hardirq/softirq
>     #                            || / _--=> preempt-depth
>     #                            ||| /     delay
>     #           TASK-PID   CPU#  ||||    TIMESTAMP  FUNCTION
>     #              | |       |   ||||       |         |
>                 init-1     [000] ....     3.706370: sys_exit: NR -1 =
> 0 init-1     [000] ....     3.706394: sys_enter: NR 45 (0, 0,
> 3fffa2e20000, 3fffcfd4eac2, 80, 3fffa2e61820) init-1
> [000] ....     3.706395: sys_exit: NR 45 = 70367490932736 init-1
> [000] ....     3.706409: sys_enter: NR 33 (3fffa2e694d0, 0,
> 3fffa2e7be20, 0, 1, ffffffffe0000000) init-1     [000] ....
> 3.713325: sys_exit: NR 33 = -2 
> 
> I like my version better, but your call.

Of course you do :-)

I thought about it a bit, and both versions are really hacks. But in
the end, I'd rather not touch the swapper task because that might give
us some unwanted side effects.

I don't really like my approach where I need to disable and re-enable
all tracepoints. I was thinking of only enabling and disabling just the
syscall ones, but I could imagine another tracepoint with a reg that
could be affected by early boot as well, so I left it touching all
events. My patch is fine for mainline, but I could make a patch for
3.20 that will only restart a tracepoint if it has its own reg/unreg
functions and does not use the default ones.

Your patch fixes syscall events. I wanted something that will fix any
event with its own special registration that might also use
for_each_process_thread() or some other call that does not work before
init is created.

Thanks,

-- Steve
