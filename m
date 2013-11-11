Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754959Ab3KKST5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Nov 2013 13:19:57 -0500
Received: from fw-tnat.cambridge.arm.com ([217.140.96.21]:50307 "EHLO
	cam-smtp0.cambridge.arm.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753747Ab3KKSTs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Nov 2013 13:19:48 -0500
Date: Mon, 11 Nov 2013 18:18:05 +0000
From: Catalin Marinas <catalin.marinas@arm.com>
To: Arjan van de Ven <arjan@linux.intel.com>
Cc: Peter Zijlstra <peterz@infradead.org>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@kernel.org>, Paul Turner <pjt@google.com>,
        Morten Rasmussen <Morten.Rasmussen@arm.com>,
        Chris Metcalf <cmetcalf@tilera.com>, Tony Luck <tony.luck@intel.com>,
        "alex.shi@intel.com" <alex.shi@intel.com>,
        Preeti U Murthy <preeti@linux.vnet.ibm.com>,
        linaro-kernel <linaro-kernel@lists.linaro.org>,
        "len.brown@intel.com" <len.brown@intel.com>,
        "l.majewski@samsung.com" <l.majewski@samsung.com>,
        Jonathan Corbet <corbet@lwn.net>, "Rafael J. Wysocki" <rjw@sisk.pl>,
        Paul McKenney <paulmck@linux.vnet.ibm.com>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>
Subject: Re: [RFC][PATCH v5 00/14] sched: packing tasks
Message-ID: <20131111181805.GE29572@arm.com>
References: <1382097147-30088-1-git-send-email-vincent.guittot@linaro.org>
 <CAHkRjk69GNYtLGBSWCNcsCzkBHywKrD0qQQbNkJRpMbcdsCPyw@mail.gmail.com>
 <20131111163630.GD26898@twins.programming.kicks-ass.net>
 <52810851.4090907@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <52810851.4090907@linux.intel.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 11, 2013 at 04:39:45PM +0000, Arjan van de Ven wrote:
> > I think the scheduler simply wants to say: we expect to go idle for X
> > ns, we want a guaranteed wakeup latency of Y ns -- go do your thing.
> 
> as long as Y normally is "large" or "infinity" that is ok ;-)
> (a smaller Y will increase power consumption and decrease system performance)

Cpuidle already takes a latency into account via pm_qos. The scheduler
could pass this information down to the hardware driver or the cpuidle
driver could use pm_qos directly (as it's currently done in governors).

The scheduler may have its own requirements in terms of latency (e.g.
some real-time thread) and we could extend the pm_qos API with
per-thread information. But so far we don't have a way to pass such
per-thread requirements from user space (unless we assume that any
real-time thread has some fixed latency requirements). I suggest we
ignore this per-thread part until we find an actual need.

> > I think you also raised the point in that we do want some feedback as to
> > the cost of waking up particular cores to better make decisions on which
> > to wake. That is indeed so.
> 
> having a hardware driver give a prefered CPU ordering for wakes can indeed be useful.
> (I'm doubtful that changing the recommendation for each idle is going to pay off,
> but proof is in the pudding; there are certainly long term effects where this can help)

The ordering is based on the actual C-state, so a simple way is to wake
up the CPU in the shallowest C-state. With asymmetric configurations
(big.LITTLE) we have different costs for the same C-state, so this would
come in handy.

Even for symmetric configuration, the cost of moving a task to a CPU
includes wake-up cost plus the run-time cost which depends on the
P-state after wake-up (that's much trickier since we can't easily
estimate the cost of a P-state and it may change once you place a task
on it).

-- 
Catalin
