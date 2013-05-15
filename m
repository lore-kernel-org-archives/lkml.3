Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759448Ab3EOP1Y (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 May 2013 11:27:24 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:11503 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758912Ab3EOP1G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 May 2013 11:27:06 -0400
X-Authority-Analysis: v=2.0 cv=DKcNElxb c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=3aLxPhj7Q5gA:10 a=5SG0PmZfjMsA:10 a=IkcTkHD0fZMA:10 a=meVymXHHAAAA:8 a=e7SmI9TJ9RsA:10 a=C5Af5jJSHcdmIxPfY8gA:9 a=QEXdDO2ut3YA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-ID: <1368631622.6828.69.camel@gandalf.local.home>
Subject: Re: [PATCH 1/2] nohz: Disable LOCKUP_DETECTOR when NO_HZ_FULL is
 enabled
From: Steven Rostedt <rostedt@goodmis.org>
To: Don Zickus <dzickus@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>
Date: Wed, 15 May 2013 11:27:02 -0400
In-Reply-To: <20130515150652.GP23604@redhat.com>
References: <1368547372-21011-1-git-send-email-fweisbec@gmail.com>
	 <1368547372-21011-2-git-send-email-fweisbec@gmail.com>
	 <20130515083729.GC10510@laptop.programming.kicks-ass.net>
	 <20130515150652.GP23604@redhat.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4-3 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2013-05-15 at 11:06 -0400, Don Zickus wrote:

> > That's a bit contradictory in function, you want the NMI watchdog to
> > cover all code, so disabling whilst entering NO_HZ state is going to
> > make it not cover some code - *fail*.

Well, when NO_HZ_FULL is set, it covers no code :-)

> > 
> > Rather I would suggest disabling the NMI watchdog's runtime default; so
> > you can still enable it with something like: 
> > 
> >   echo 1 > /proc/sys/kernel/nmi_watchdog

Yeah, just disabling it via run time might work.


> 
> Coming into the middle of the thread is always hard, but why/how does perf
> disable nohz_full?  I didn't think the hardware events of perf would cause
> problems as they are no different than an irq.  Curious.

Right now perf requires a tick, not sure exactly why, but you can look
at the code in perf_event_task_tick(). Thus if NO_HZ_FULL sees that a
perf tick is pending, it won't disable ticks. Unfortunately, the
watchdogs, both NMI and soft lockup, use the perf infrastructure to
trigger NMIs or interrupts. This adds a perf element on the rotate list
and keeps NO_HZ_FULL from *ever* activating.

-- Steve


