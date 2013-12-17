Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754975Ab3LQQfq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Dec 2013 11:35:46 -0500
Received: from mail-pd0-f178.google.com ([209.85.192.178]:63951 "EHLO
	mail-pd0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754907Ab3LQQfm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Dec 2013 11:35:42 -0500
From: Kevin Hilman <khilman@linaro.org>
To: Viresh Kumar <viresh.kumar@linaro.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
        Lists linaro-kernel <linaro-kernel@lists.linaro.org>,
        Linaro Networking <linaro-networking@linaro.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Tejun Heo <tj@kernel.org>
Subject: Re: [Query] Ticks happen in pair for NO_HZ_FULL cores ?
References: <CAKohponch=o3nBKTmakA87OiN=HbgnEwJUL23mGkjQiNoJWjWw@mail.gmail.com>
	<20131211132212.GA7862@localhost.localdomain>
	<CAKohponKxw8F6djaXaw0MEzGRWGTSQ=peiYuTGBCOHE0VaJR5Q@mail.gmail.com>
Date: Tue, 17 Dec 2013 08:35:39 -0800
In-Reply-To: <CAKohponKxw8F6djaXaw0MEzGRWGTSQ=peiYuTGBCOHE0VaJR5Q@mail.gmail.com>
	(Viresh Kumar's message of "Tue, 17 Dec 2013 16:05:29 +0530")
Message-ID: <87wqj34eqs.fsf@linaro.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Viresh Kumar <viresh.kumar@linaro.org> writes:

> Sorry for the delay, was on holidays..
>
> On 11 December 2013 18:52, Frederic Weisbecker <fweisbec@gmail.com> wrote:
>> On Tue, Dec 03, 2013 at 01:57:37PM +0530, Viresh Kumar wrote:
>>> - again got arch_timer interrupt after 5 ms (HZ=200)
>>
>> Right, looking at the details, the 2nd interrupt is caused by workqueue delayed
>> work bdi writeback.
>
> I am not that great at reading traces or kernelshark output, but I
> still feel I haven't
> seen anything wrong. And I wasn't talking about the delayed workqueue here..
>
> I am looking at the trace I attached with kernelshark after filtering
> out CPU0 events:
> - Event 41, timestamp: 159.891973
> - it ends at event 56, timestamp: 159.892043

For future reference, for generating email friendly trace output for
discussion like this, you can use something like:

   trace-cmd report --cpu=1 trace.dat

> And after that the next event comes after 5 Seconds.
>
> And so I was talking for the Event 41.

That first event (Event 41) is an interrupt, and comes from the
scheduler tick.  The tick is happening because the writeback workqueue
just ran and we're not in NO_HZ mode.

However, as soon as that IRQ (and resulting softirqs) are finished, we
enter NO_HZ mode again.  But as you mention, it only lasts for ~5 sec
when the timer fires again.  Once again, it fires because of the
writeback workqueue, and soon therafter it switches back to NO_HZ mode
again.

So the solution to avoid this jitter on the NO_HZ CPU is to set the
affinity of the writeback workqueue to CPU0:

  # pin the writeback workqueue to CPU0
  echo 1 > /sys/bus/workqueue/devices/writeback/cpumask

I suspect by doing that, you will no longer see the jitter.

Kevin
