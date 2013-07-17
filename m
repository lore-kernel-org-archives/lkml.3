Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755234Ab3GQOQO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Jul 2013 10:16:14 -0400
Received: from fw-tnat.cambridge.arm.com ([217.140.96.21]:57166 "EHLO
	cam-smtp0.cambridge.arm.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754366Ab3GQOQN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Jul 2013 10:16:13 -0400
Date: Wed, 17 Jul 2013 15:14:26 +0100
From: Catalin Marinas <catalin.marinas@arm.com>
To: Arjan van de Ven <arjan@linux.intel.com>
Cc: Peter Zijlstra <peterz@infradead.org>,
        Morten Rasmussen <Morten.Rasmussen@arm.com>,
        "mingo@kernel.org" <mingo@kernel.org>,
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
Message-ID: <20130717141426.GG27948@arm.com>
References: <1373385338-12983-1-git-send-email-morten.rasmussen@arm.com>
 <20130713064909.GW25631@dyad.programming.kicks-ass.net>
 <20130713102350.GA8067@MacBook-Pro.local>
 <20130715203922.GD23818@dyad.programming.kicks-ass.net>
 <20130716124248.GB10036@arm.com>
 <51E5655C.7050304@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <51E5655C.7050304@linux.intel.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 16, 2013 at 04:23:08PM +0100, Arjan van de Ven wrote:
> On 7/16/2013 5:42 AM, Catalin Marinas wrote:
> > Morten's power scheduler tries to address the above and it will grow
> > into controlling a new model of power driver (and taking into account
> > Arjan's and others' comments regarding the API). At the same time, we
> > need some form of task packing. The power scheduler can drive this
> > (currently via cpu_power) or can simply turn a knob if there are better
> > options that will be accepted in the scheduler.
> 
> how much would you be helped if there was a simple switch
> 
> sort left   versus    sort right
> 
> (assuming the big cores are all either low or high numbers)

It helps a bit compared to the current behaviour but there is a lot of
room for improvement.

> the sorting is mostly statistical, but that's good enough in practice..
> each time a task wakes up, you get a bias towards either low or high
> numbered idle cpus

If cores within a cluster (socket) are not power-gated individually
(implementation dependent), it makes more sense to spread the tasks
among the cores to either get a lower frequency or just get to idle
quicker. For little cores, even when they are individually power-gated,
they don't consume much so we would rather spread the tasks equally.

> very quickly all tasks will be on one side, unless your system is so
> loaded that all cpus are full.

It should be more like left socket vs both sockets with the possibility
of different balancing within a socket. But then we get back to the
sched_smt/sched_mc power aware scheduling that was removed from the
kernel.

It's also important when to make this decision to sort left vs right and
we want to avoid migrating threads unnecessarily. There could be small
threads (e.g. an mp3 decoding thread) that should stay on the little
core.

Power aware scheduling should not affect the performance (call them
benchmarks) but the scheduler could take power implications into
account. The hard part is formalising this with differences between
architectures and SoCs. Maybe a low-level driver or arch hook like "get
me the most power efficient CPU that can run a task" but it's not clear
how this would work (we can't easily predict what the future load will
be).

Our proposal is to split the balancing into two problems: equal
balancing vs. CPU capacity (the latter can be improved to address arch
concerns). These two problems can be later unified once we have a better
understanding of its implications across architectures.

For big.LITTLE we could work around the scheduler (in a very hacky way)
with a combination of pstate/powerclamp driver which forces idle on the
big cores when not needed but I would rather get the scheduler to make
such decisions.

-- 
Catalin
