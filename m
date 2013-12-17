Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754655Ab3LQQ5d (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Dec 2013 11:57:33 -0500
Received: from mail-ee0-f48.google.com ([74.125.83.48]:53414 "EHLO
	mail-ee0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754002Ab3LQQ5c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Dec 2013 11:57:32 -0500
Date: Tue, 17 Dec 2013 17:57:28 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Kevin Hilman <khilman@linaro.org>
Cc: Viresh Kumar <viresh.kumar@linaro.org>,
        Lists linaro-kernel <linaro-kernel@lists.linaro.org>,
        Linaro Networking <linaro-networking@linaro.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Tejun Heo <tj@kernel.org>
Subject: Re: [Query] Ticks happen in pair for NO_HZ_FULL cores ?
Message-ID: <20131217165726.GA18689@localhost.localdomain>
References: <CAKohponch=o3nBKTmakA87OiN=HbgnEwJUL23mGkjQiNoJWjWw@mail.gmail.com>
 <20131211132212.GA7862@localhost.localdomain>
 <CAKohponKxw8F6djaXaw0MEzGRWGTSQ=peiYuTGBCOHE0VaJR5Q@mail.gmail.com>
 <87wqj34eqs.fsf@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87wqj34eqs.fsf@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 17, 2013 at 08:35:39AM -0800, Kevin Hilman wrote:
> Viresh Kumar <viresh.kumar@linaro.org> writes:
> 
> > Sorry for the delay, was on holidays..
> >
> > On 11 December 2013 18:52, Frederic Weisbecker <fweisbec@gmail.com> wrote:
> >> On Tue, Dec 03, 2013 at 01:57:37PM +0530, Viresh Kumar wrote:
> >>> - again got arch_timer interrupt after 5 ms (HZ=200)
> >>
> >> Right, looking at the details, the 2nd interrupt is caused by workqueue delayed
> >> work bdi writeback.
> >
> > I am not that great at reading traces or kernelshark output, but I
> > still feel I haven't
> > seen anything wrong. And I wasn't talking about the delayed workqueue here..
> >
> > I am looking at the trace I attached with kernelshark after filtering
> > out CPU0 events:
> > - Event 41, timestamp: 159.891973
> > - it ends at event 56, timestamp: 159.892043
> 
> For future reference, for generating email friendly trace output for
> discussion like this, you can use something like:
> 
>    trace-cmd report --cpu=1 trace.dat
> 
> > And after that the next event comes after 5 Seconds.
> >
> > And so I was talking for the Event 41.
> 
> That first event (Event 41) is an interrupt, and comes from the
> scheduler tick.  The tick is happening because the writeback workqueue
> just ran and we're not in NO_HZ mode.
> 
> However, as soon as that IRQ (and resulting softirqs) are finished, we
> enter NO_HZ mode again.  But as you mention, it only lasts for ~5 sec
> when the timer fires again.  Once again, it fires because of the
> writeback workqueue, and soon therafter it switches back to NO_HZ mode
> again.
> 
> So the solution to avoid this jitter on the NO_HZ CPU is to set the
> affinity of the writeback workqueue to CPU0:
> 
>   # pin the writeback workqueue to CPU0
>   echo 1 > /sys/bus/workqueue/devices/writeback/cpumask

Very interesting trick, I'm going to add it to my dyntick-testing suite.

Thanks!
