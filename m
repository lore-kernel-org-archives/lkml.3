Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964847Ab3GLNCA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Jul 2013 09:02:00 -0400
Received: from fw-tnat.cambridge.arm.com ([217.140.96.21]:50397 "EHLO
	cam-smtp0.cambridge.arm.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S964828Ab3GLNB7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Jul 2013 09:01:59 -0400
Date: Fri, 12 Jul 2013 14:00:21 +0100
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
Message-ID: <20130712130021.GC28271@arm.com>
References: <1373385338-12983-1-git-send-email-morten.rasmussen@arm.com>
 <51DC414F.5050900@linux.intel.com>
 <20130710111627.GC15989@e103687>
 <51DD5BFC.8000102@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <51DD5BFC.8000102@linux.intel.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 10, 2013 at 02:05:00PM +0100, Arjan van de Ven wrote:
> >> also, it almost looks like there is a fundamental assumption in the
> >> code that you can get the current effective P state to make
> >> scheduler decisions on; on Intel at least that is basically
> >> impossible... and getting more so with every generation (likewise
> >> for AMD afaics)
> >>
> >> (you can get what you ran at on average over some time in the past,
> >> but not what you're at now or going forward)
> >
> > As described above, it is not a strict assumption. From a scheduler
> > point of view we somehow need to know if the cpus are truly fully
> > utilized (at their highest P-state)
> 
> unfortunately we can't provide this on Intel ;-(
> we can provide you what you ran at average, we cannot provide you if
> that is the max or not
> 
> (first of all, because we outright don't know what the max would have
> been, and second, because we may be running slower than max because
> the workload was memory bound or any of the other conditions that
> makes the HW P state "governor" decide to reduce frequency for
> efficiency reasons)

I guess even if we have a constant CPU frequency (no turbo boost), we
still don't have a simple relation between the load as seen by the
scheduler and the CPU frequency (for reasons that you mentioned above
like memory-bound tasks).

But on x86 you still have a P-state hint for the CPU and the scheduler
could at least hope for more CPU performance. We can make the power
scheduler ask the power driver for an increase or decrease of
performance (as Preeti suggested) and give it the current load as
argument rather than a precise performance/frequency level. The power
driver would change the P-state accordingly and take the load into
account (or ignore it, something like intel_pstate.c can do its own
aperf/mperf tracking). But the power driver will inform the scheduler
that it can't change the P-state further and the power scheduler can
decide to spread the load out to other CPUs.

-- 
Catalin
