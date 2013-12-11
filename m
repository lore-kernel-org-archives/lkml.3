Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751519Ab3LKNWT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Dec 2013 08:22:19 -0500
Received: from mail-we0-f182.google.com ([74.125.82.182]:52774 "EHLO
	mail-we0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750945Ab3LKNWR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Dec 2013 08:22:17 -0500
Date: Wed, 11 Dec 2013 14:22:14 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Viresh Kumar <viresh.kumar@linaro.org>
Cc: Kevin Hilman <khilman@linaro.org>,
        Lists linaro-kernel <linaro-kernel@lists.linaro.org>,
        Linaro Networking <linaro-networking@linaro.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Tejun Heo <tj@kernel.org>
Subject: Re: [Query] Ticks happen in pair for NO_HZ_FULL cores ?
Message-ID: <20131211132212.GA7862@localhost.localdomain>
References: <CAKohponch=o3nBKTmakA87OiN=HbgnEwJUL23mGkjQiNoJWjWw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAKohponch=o3nBKTmakA87OiN=HbgnEwJUL23mGkjQiNoJWjWw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 03, 2013 at 01:57:37PM +0530, Viresh Kumar wrote:
> Hi Frederic/Kevin,
> 
> I was doing some work where I was required to use NO_HZ_FULL
> on core 1 on a dual core ARM machine.
> 
> I observed that I was able to isolate the second core using cpusets
> but whenever the tick occurs, it occurs twice. i.e. Timer count
> gets updated by two every time my core is disturbed.
> 
> I tried to trace it (output attached) and found this sequence (Talking
> only about core 1 here):
> - Single task was running on Core 1 (using cpusets)
> - got an arch_timer interrupt
> - started servicing vmstat stuff
> - so came out of NO_HZ_FULL domain as there is more than
> one task on Core
> - queued work again and went to the existing single task (stress)
> - again got arch_timer interrupt after 5 ms (HZ=200)

Right, looking at the details, the 2nd interrupt is caused by workqueue delayed
work bdi writeback.

> - got "tick_stop" event and went into NO_HZ_FULL domain again..
> - Got isolated again for long duration..
> 
> So the query is: why don't we check that at the end of servicing vmstat
> stuff and migrating back to "stress" ??

I fear I don't understand your question. Do you mean why don't we prevent from
that bdi writeback work to run when we are in full dynticks mode?

We can't just ignore workqueues and timers callback when they are scheduled
otherwise the kernel is going to behave randomly.

OTOH what we can do is to work on these per cpu workqueues and timers and do
what's necessary to avoid them to fire, as explained in detail there Documentation/kernel-per-CPU-kthreads.txt

There is also the problem of unbound workqueues for which we don't have a solution
yet. But the idea is that we could tweak their affinity from sysfs.

> 
> Thanks.
> 
> --
> viresh


