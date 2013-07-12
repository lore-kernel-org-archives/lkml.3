Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964957Ab3GLNcR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Jul 2013 09:32:17 -0400
Received: from fw-tnat.cambridge.arm.com ([217.140.96.21]:59222 "EHLO
	cam-smtp0.cambridge.arm.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S964884Ab3GLNcQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Jul 2013 09:32:16 -0400
Date: Fri, 12 Jul 2013 14:31:16 +0100
From: Catalin Marinas <catalin.marinas@arm.com>
To: Arjan van de Ven <arjan@linux.intel.com>
Cc: Morten Rasmussen <Morten.Rasmussen@arm.com>,
        "mingo@kernel.org" <mingo@kernel.org>,
        "peterz@infradead.org" <peterz@infradead.org>,
        "vincent.guittot@linaro.org" <vincent.guittot@linaro.org>,
        "preeti@linux.vnet.ibm.com" <preeti@linux.vnet.ibm.com>,
        "alex.shi@intel.com" <alex.shi@intel.com>,
        "efault@gmx.de" <efault@gmx.de>, "pjt@google.com" <pjt@google.com>,
        "len.brown@intel.com" <len.brown@intel.com>,
        "corbet@lwn.net" <corbet@lwn.net>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "torvalds@linux-foundation.org" <torvalds@linux-foundation.org>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linaro-kernel@lists.linaro.org" <linaro-kernel@lists.linaro.org>
Subject: Re: [RFC][PATCH 0/9] sched: Power scheduler design proposal
Message-ID: <20130712133116.GE28271@arm.com>
References: <1373385338-12983-1-git-send-email-morten.rasmussen@arm.com>
 <51DC414F.5050900@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <51DC414F.5050900@linux.intel.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 09, 2013 at 05:58:55PM +0100, Arjan van de Ven wrote:
> On 7/9/2013 8:55 AM, Morten Rasmussen wrote:
> > This patch set is an initial prototype aiming at the overall power-aware
> > scheduler design proposal that I previously described
> > <http://permalink.gmane.org/gmane.linux.kernel/1508480>.
> >
> > The patch set introduces a cpu capacity managing 'power scheduler' which lives
> > by the side of the existing (process) scheduler. Its role is to monitor the
> > system load and decide which cpus that should be available to the process
> > scheduler. Long term the power scheduler is intended to replace the currently
> > distributed uncoordinated power management policies and will interface a
> > unified platform specific power driver obtain power topology information and
> > handle idle and P-states. The power driver interface should be made flexible
> > enough to support multiple platforms including Intel and ARM.
...
> I'm rather nervous about calculating how many cores you want active as
> a core scheduler feature. I understand that for your big.LITTLE
> architecture you need this due to the asymmetry, but as a general rule
> for more symmetric systems it's known to be suboptimal by quite a real
> percentage. For a normal Intel single CPU system it's sort of the
> worst case you can do in that it leads to serializing tasks that could
> have run in parallel over multiple cores/threads. So at minimum this
> kind of logic must be enabled/disabled based on architecture
> decisions.

As Morten already stated, we *think* this is beneficial for symmetric
multi-socket (multi-cluster, multi-core or whatever other name) systems
as well. The only thing that big.LITTLE requires is that we want to
favour little CPUs when the load is not too high. But even if they were
symmetric (big.big is not unlikely, though for different markets), we
still want to pack tasks on a single cluster if it has enough compute
capacity so that the other cluster can go into deeper sleep state.
Basically we don't want 5 tasks to use 5 CPUs when 4 (or less) would
suffice.

So apart from intel_pstate.c improvements (which look really nice), my
guess is that Intel also has an interest in scheduler changes for power
reasons (my guess is based on the work done by Alex Shi).

If not (IOW all you need is the intel_pstate.c driver), the proposed
power scheduler will have two policies anyway: power and performance.
The latter would only improve on the current (performance) behaviour and
will allow the load balancing to equally use all the CPUs. A modified
intel_pstate.c driver could benefit from extra hints from the power
scheduler (like CPU load) or can simply ignore them. The scheduler will
also benefit by not migrating a task unnecessarily if the pstate driver
can switch to higher P-state (I'm not convinced 10ms load tracking in
the intel_pstate.c driver is fast enough, especially since it integrates
the load over multiple such periods).

-- 
Catalin
