Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751320AbaBMOUv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Feb 2014 09:20:51 -0500
Received: from mail-we0-f170.google.com ([74.125.82.170]:36312 "EHLO
	mail-we0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750809AbaBMOUu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Feb 2014 09:20:50 -0500
Date: Thu, 13 Feb 2014 15:20:47 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Viresh Kumar <viresh.kumar@linaro.org>
Cc: Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Lists linaro-kernel <linaro-kernel@lists.linaro.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Linaro Networking <linaro-networking@linaro.org>,
        Kevin Hilman <khilman@linaro.org>
Subject: Re: [QUERY]: Is using CPU hotplug right for isolating CPUs?
Message-ID: <20140213142045.GC14383@localhost.localdomain>
References: <20140115171704.GB21574@localhost.localdomain>
 <CAKohponEZydR1OmP2xziA9bc3OJPgP3bFmuWFQmrmeQFZccMVQ@mail.gmail.com>
 <alpine.DEB.2.02.1401161043350.4207@ionos.tec.linutronix.de>
 <CAKohpond3wY25H_tsJQ9xs_D2dP2_wGGU5J8fBteyfB=7wmAdA@mail.gmail.com>
 <20140120155145.GB9436@localhost.localdomain>
 <CAKohpom8av7A1wwcdOr5+LpHz--P+s9m_gR_9B+Aa4fpwkN7uQ@mail.gmail.com>
 <20140123145842.GD13345@localhost.localdomain>
 <CAKohpok5AObcFbOmLYGT-KkjhVHUiLRZ=AYqofYk59_sVneSjA@mail.gmail.com>
 <20140128132306.GB9172@localhost.localdomain>
 <CAKohpommw4=LcyYKvj8rNJgUkOT+_Gh=1kppcDQYm3BuQQe_Qg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAKohpommw4=LcyYKvj8rNJgUkOT+_Gh=1kppcDQYm3BuQQe_Qg@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 11, 2014 at 02:22:43PM +0530, Viresh Kumar wrote:
> On 28 January 2014 18:53, Frederic Weisbecker <fweisbec@gmail.com> wrote:
> > No, when a single task is running on a full dynticks CPU, the tick is supposed to run
> > every seconds. I'm actually suprised it doesn't happen in your traces, did you tweak
> > something specific?
> 
> Why do we need this 1 second tick currently? And what will happen if I
> hotunplug that
> CPU and get it back? Would the timer for tick move away from CPU in
> question? I see
> that when I have changed this 1sec stuff to 300 seconds. But what
> would be impact
> of that? Will things still work normally?

So the problem resides in the gazillions accounting maintained in scheduler_tick() and
current->sched_class->task_tick().

The scheduler correctness depends on these to be updated regularly. If you deactivate
or increase the delay with very high values, the result is unpredictable. Just expect that
at least some scheduler feature will behave randomly, like load balancing for example or
simply local fairness issues.

So we have that 1 Hz max that makes sure that things are moving forward while keeping
a rate that should be still nice for HPC workloads. But we certainly want to find a
way to remove the need for any tick altogether for extreme real time workloads which
need guarantees rather than just optimizations.

I see two potential solutions for that:

1) Rework the scheduler accounting such that it is safe against full dynticks. That
was the initial plan but it's scary. The scheduler accountings is a huge maze. And I'm not
sure it's actually worth the complication.

2) Offload the accounting. For example we could imagine that the timekeeping could handle the
task_tick() calls on behalf of the full dynticks CPUs. At a small rate like 1 Hz.
