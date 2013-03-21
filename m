Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752879Ab3CUUNj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Mar 2013 16:13:39 -0400
Received: from a192-102.smtp-out.amazonses.com ([199.255.192.102]:64473 "EHLO
	a192-102.smtp-out.amazonses.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752536Ab3CUUNg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Mar 2013 16:13:36 -0400
X-Greylist: delayed 566 seconds by postgrey-1.27 at vger.kernel.org; Thu, 21 Mar 2013 16:13:36 EDT
Date: Thu, 21 Mar 2013 20:04:08 +0000
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@gentwo.org
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
cc: Steven Rostedt <rostedt@goodmis.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Rob Landley <rob@landley.net>, linux-kernel@vger.kernel.org,
        josh@joshtriplett.org, zhong@linux.vnet.ibm.com, khilman@linaro.org,
        geoff@infradead.org, tglx@linutronix.de
Subject: Re: [PATCH] nohz1: Documentation
In-Reply-To: <20130321185821.GF3637@linux.vnet.ibm.com>
Message-ID: <0000013d8e8d24fd-d2931c45-2722-46d1-8b47-2ef11e21096d-000000@email.amazonses.com>
References: <CAFTL4hybMf+9GjjyKRSEEp0x+wT7OwpKShE5sR_JqW24DGfKOw@mail.gmail.com> <1363636794.15703.32@driftwood> <CAFTL4hz=VKCchgvKcSHbctZcRyjCSmCbLu6OhLz0zEcYA20zOQ@mail.gmail.com> <20130318222548.GG3656@linux.vnet.ibm.com> <1363822338.6345.33.camel@gandalf.local.home>
 <20130320235545.GL3637@linux.vnet.ibm.com> <0000013d8db514e4-bf492080-82c9-412a-90b8-54ddc1463e4b-000000@email.amazonses.com> <20130321171518.GW3637@linux.vnet.ibm.com> <0000013d8e3f58ce-0f6ea95f-780a-49c1-a633-5aa0cf3e5040-000000@email.amazonses.com>
 <20130321185821.GF3637@linux.vnet.ibm.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-SES-Outgoing: 199.255.192.102
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 21 Mar 2013, Paul E. McKenney wrote:

> > Yeah doing that right now but I'd like to see it handled without manual
> > intervention.
>
> Given that RCU has no idea where you want them to run, some manual
> intervention would most likely be required even if RCU spawned them
> dynamically, right?

If rcuoXX is a SCHED_OTHER process/thread then the kernel will move it to
another processor from the one running the SCHED_FIFO task. There would be
no manual intervention required.

> So, again, removing scheduling-clock interrupts in more situations is
> a good future enhancement.

The point here is that the check for a single runnable process is wrong
because it accounts for tasks in all scheduling classes.

It would be better to check if there is only one runnable task in the
highest scheduling class. That would work and defer the SCHED_OTHER kernel
threads for the SCHED_FIFO thread.

I am wondering how you actually can get NOHZ to work right? There is
always a kernel thread that is scheduled in a couple of ticks.

I guess what will happens with this patchset is:

1. SCHED_FIFO thread begins to run. There is only a single runnable task
so adaptive tick mode is enabled.

2. After 2 seconds or so some or other thing needs to run (keventd thread
needs to run vm statistics f.e.). It becomes runnable. nr_running > 1.
Adaptive tick mode is disabled? Occurs on my system. Or is there some
other trick to avoid kernel threads becoming runnable?

3. Now there are 2 runnable processes. The SCHED_FIFO thread continues to
run with the tick. The kernel thread is also runnable but will not be
given cpu time since the SCHED_FIFO thread has priority?

So the SCHED_FIFO thread enjoys 2 seconds of no tick time and then ticks
occur uselessly from there on?


I have not been able to consistently get the tick switched off with
the nohz patchset. How do others use nohz? Is it only usable for short
periods of less than 2 seconds?
