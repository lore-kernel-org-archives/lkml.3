Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422695AbaDJWCI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Apr 2014 18:02:08 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.225]:4093 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753845AbaDJWCF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Apr 2014 18:02:05 -0400
Date: Thu, 10 Apr 2014 18:02:03 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: paulmck@linux.vnet.ibm.com
Cc: Peter Zijlstra <peterz@infradead.org>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Clark Williams <williams@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>,
        linux-rt-users <linux-rt-users@vger.kernel.org>,
        Mike Galbraith <umgwanakikbuti@gmail.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@kernel.org>
Subject: Re: [RFC PATCH RT] rwsem: The return of multi-reader PI rwsems
Message-ID: <20140410180203.79c08bfa@gandalf.local.home>
In-Reply-To: <20140410213003.GA21760@linux.vnet.ibm.com>
References: <20140409151922.5fa5d999@gandalf.local.home>
	<20140410094430.56ca9ee1@sluggy.gateway.2wire.net>
	<5346B2C8.6000207@linutronix.de>
	<20140410153617.GN10526@twins.programming.kicks-ass.net>
	<20140410151741.617f86d9@gandalf.local.home>
	<20140410213003.GA21760@linux.vnet.ibm.com>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.22; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.142:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 10 Apr 2014 14:30:03 -0700
"Paul E. McKenney" <paulmck@linux.vnet.ibm.com> wrote:

> On Thu, Apr 10, 2014 at 03:17:41PM -0400, Steven Rostedt wrote:
> > On Thu, 10 Apr 2014 17:36:17 +0200
> > Peter Zijlstra <peterz@infradead.org> wrote:
> > 
> > 
> > > It defaults to the total number of CPUs in the system, given the default
> > > setup (all CPUs in a single balance domain), this should result in all
> > > CPUs working concurrently on the boosted read sides.
> > 
> > Unfortunately, it currently defaults to the number of possible CPUs in
> > the system. I should probably move the default assignment to after SMP
> > is setup. Currently it happens in early boot before all the CPUs are
> > running. On boot up, the limit is set to NR_CPUS which should be much
> > higher than what the system has, but shouldn't matter during boot. But
> > after all the CPUs are up and running, it can lower it to online CPUs.
> 
> Another approach is to use nr_cpu_ids, which is the maximum number of
> CPUs that the particular booting system could ever have.  I use this in
> RCU to resize the data structures down from their NR_CPUS compile-time
> hugeness.
> 

OK, also, in doing our benchmarks, there's a big difference with
rt_rw_limit being num_online_cpus and 2 * num_online_cpus. It doesn't
seem to get better adding more than that. This was shown on a case with
12 cpus as well as 8 cpus. Same result.

I really like to see a real use case benefit to find the best default.
But as our mmap_sem stress test shows 2xCPUS as being the best, I'm
going to go with that until someone comes up with a better test.

-- Steve
