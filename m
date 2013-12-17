Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753890Ab3LQOFs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Dec 2013 09:05:48 -0500
Received: from fw-tnat.cambridge.arm.com ([217.140.96.21]:51739 "EHLO
	cam-smtp0.cambridge.arm.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752726Ab3LQOFr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Dec 2013 09:05:47 -0500
Date: Tue, 17 Dec 2013 14:04:57 +0000
From: Morten Rasmussen <morten.rasmussen@arm.com>
To: Alex Shi <alex.shi@linaro.org>
Cc: Peter Zijlstra <peterz@infradead.org>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "vincent.guittot@linaro.org" <vincent.guittot@linaro.org>,
        "daniel.lezcano@linaro.org" <daniel.lezcano@linaro.org>,
        "fweisbec@gmail.com" <fweisbec@gmail.com>,
        "linux@arm.linux.org.uk" <linux@arm.linux.org.uk>,
        "tony.luck@intel.com" <tony.luck@intel.com>,
        "fenghua.yu@intel.com" <fenghua.yu@intel.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "arjan@linux.intel.com" <arjan@linux.intel.com>,
        "pjt@google.com" <pjt@google.com>,
        "fengguang.wu@intel.com" <fengguang.wu@intel.com>,
        "james.hogan@imgtec.com" <james.hogan@imgtec.com>,
        "jason.low2@hp.com" <jason.low2@hp.com>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "hanjun.guo@linaro.org" <hanjun.guo@linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 0/4] sched: remove cpu_load decay
Message-ID: <20131217140457.GF10134@e103034-lin>
References: <1386061556-28233-1-git-send-email-alex.shi@linaro.org>
 <20131213200303.GI2480@laptop.programming.kicks-ass.net>
 <52AC5CDF.8050209@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <52AC5CDF.8050209@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Dec 14, 2013 at 01:27:59PM +0000, Alex Shi wrote:
> On 12/14/2013 04:03 AM, Peter Zijlstra wrote:
> > 
> > 
> > I had a quick peek at the actual patches.
> > 
> > afaict we're now using weighted_cpuload() aka runnable_load_avg as the
> > ->cpu_load. Whatever happened to also using the blocked_avg?

AFAICT, ->cpu_load is actually a snapshot value of weigthed_cpuload()
that gets updated occasionally. That has been the case since b92486cb.
By removing the cpu_load indexes {source,target}_load are now comparing
an old snapshot of weighted_cpuload() with the current value. I don't
think that really makes sense. weighted_cpuload() may change rapidly
when tasks are enqueued or dequeued so the old snapshot doesn't have
much meaning in my opinion. Maybe I'm missing something?

Comparing cpu_load indexes with different decay rates in {source,
target}_load() sort of make sense as it makes load-balancing decisions
more conservative.

If we can indeed remove decayed cpu_load there is more code that should
be revisited and potentially be ripped out. {source,target}_load() could
probably be reduced to weighted_cpuload(), which would change the
load-balance behaviour. However, these patches already affect
load-balancing as indicated by the fix in patch 4.

I believe we have discussed using blocked_load_avg in weighted_cpuload()
in the past. While it seems to be the right thing to include it, it
causes problems related to the priority scaling of the task loads.
If you include a blocked load in the weighted_cpuload() and have tiny
(very low cpu utilization) task running at very high priority, your
weighted_cpuload() will be quite high and force other normal priority
tasks away from the cpu and leaving the cpu idle most of the time.

> 
> When enabling the sched_avg in load balance, I didn't find any positive
> testing result for several blocked_avg trying, just few regression. :(
> 
> And since this patchset is almost clean up only, no blocked_load_avg
> trying again...

My worry here is that I don't really understand why the current code
works when the decayed cpu_load has been removed.

> > 
> > I totally hate patch 4; it seems like a random hack to make up for the
> > lack of blocked_avg.
> 
> Yes, this bias criteria seems a bit arbitrary. :)

This is why I think {source, target}_load() and their use need to be
reconsidered.

Morten
