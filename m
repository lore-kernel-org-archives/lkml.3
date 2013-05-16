Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752601Ab3EPLiS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 May 2013 07:38:18 -0400
Received: from mail-wi0-f169.google.com ([209.85.212.169]:52971 "EHLO
	mail-wi0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752393Ab3EPLiR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 May 2013 07:38:17 -0400
Date: Thu, 16 May 2013 13:38:12 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Steven Rostedt <rostedt@goodmis.org>, Don Zickus <dzickus@redhat.com>,
        Ingo Molnar <mingo@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH 1/2] nohz: Disable LOCKUP_DETECTOR when NO_HZ_FULL is
 enabled
Message-ID: <20130516113811.GB2341@somewhere>
References: <1368547372-21011-1-git-send-email-fweisbec@gmail.com>
 <1368547372-21011-2-git-send-email-fweisbec@gmail.com>
 <20130515083729.GC10510@laptop.programming.kicks-ass.net>
 <20130515150652.GP23604@redhat.com>
 <1368631622.6828.69.camel@gandalf.local.home>
 <20130515165915.GE13916@laptop.home>
 <1368637441.6828.70.camel@gandalf.local.home>
 <20130516081027.GD19669@dyad.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130516081027.GD19669@dyad.programming.kicks-ass.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 16, 2013 at 10:10:27AM +0200, Peter Zijlstra wrote:
> On Wed, May 15, 2013 at 01:04:01PM -0400, Steven Rostedt wrote:
> > On Wed, 2013-05-15 at 18:59 +0200, Peter Zijlstra wrote:
> > 
> > > At which point we could run the watchdog without perf_event_task_tick().
> > 
> > At which point we can drop the disable LOCKUP_DETECTOR when NO_HZ_FULL
> > is enabled ;-)
> > 
> 
> Can we? The thing I'm worried about is RCU (of course!). ISTR we rely on RCU
> working in NMI context. AFAIR for RCU to work, we need to come out of out magic
> NO_HZ state since that would've put RCU into EQS.
> 
> Frederic, PaulMck?

But they are protected inside rcu_nmi_*() functions, that's the only thing we need.
If this interrupt userspace then we resume back to it quickly after the NMI and
re-enter EQS.

No need to restart the tick for that. A remote CPU that wants a quiescent state
from the dyntick CPU will notice soon enough the EQS.

We can certainly drop the perf tick for NMI watchdog:

1) As long as there are no flexible events competing on the CPU, no rotation
should be needed.

2) We don't want event throttling for the watchdog. There is even a hack to
handle that:

       /* Callback function for perf event subsystem */
       static void watchdog_overflow_callback(struct perf_event *event,
                                              struct perf_sample_data *data,
                                              struct pt_regs *regs)
       {
                 /* Ensure the watchdog never gets throttled */
                 event->hw.interrupts = 0;
