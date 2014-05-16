Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756655AbaEPOYj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 May 2014 10:24:39 -0400
Received: from mail-la0-f44.google.com ([209.85.215.44]:52318 "EHLO
	mail-la0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751913AbaEPOYh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 May 2014 10:24:37 -0400
MIME-Version: 1.0
In-Reply-To: <0286550@agluck-desk.sc.intel.com>
References: <20140408153412.0648fb96@gandalf.local.home>
	<0286550@agluck-desk.sc.intel.com>
Date: Fri, 16 May 2014 22:24:35 +0800
Message-ID: <CAAhUcTTDQPZAC+Xg3u-KQvBwGX=B9HU5dnCjC7AJcUTDY2QLpw@mail.gmail.com>
Subject: Re: [PATCH] time: Provide full featured jiffies_to_nsecs() function
From: Shy Shuky <rousya@gmail.com>
To: Tony Luck <tony.luck@intel.com>
Cc: linux-kernel@vger.kernel.org, Steven Rostedt <rostedt@goodmis.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>, Mauro Chehab <m.chehab@samsung.com>,
        "xiexiuqi@huawei.com" <xiexiuqi@huawei.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2014-04-09 1:32 GMT+08:00 Tony Luck <tony.luck@intel.com>:
> The "uptime" tracer added in:
>     commit 8aacf017b065a805d27467843490c976835eb4a5
>     tracing: Add "uptime" trace clock that uses jiffies
> has wraparound problems when the system has been up more
> than 1 hour 11 minutes and 34 seconds. It converts jiffies
> to nanoseconds using:
>         (u64)jiffies_to_usecs(jiffy) * 1000ULL
> but since jiffies_to_usecs() only returns a 32-bit value, it
> truncates at 2^32 microseconds.  An additional problem on 32-bit
> systems is that the argument is "unsigned long", so fixing the
> return value only helps until 2^32 jiffies (49.7 days on a HZ=1000
> system).
>
> So we provide a full featured jiffies_to_nsec() function that
> takes a "u64" argument and provides a "u64" result.  To avoid
> cries of rage from the other user of this: scheduler_tick_max_deferment()
> we check whether the argument is small enough that we can do
> the calculations in 32-bit operations.

Hi Tony,
How about get uptime by get_monotonic_boottime() directly, which's
the same as /proc/uptime.

Then trace_clock_jiffies() would be like bellow:

u64 notrace trace_clock_jiffies(void)
        struct timespec uptime;
        get_monotonic_boottime(&uptime);

        return uptime.tv_sec * NSEC_PER_SEC + uptime.tv_nsec;
}

--
XiuQi

>
> Signed-off-by: Tony Luck <tony.luck@intel.com>
> ---
>  include/linux/jiffies.h    |  6 +-----
>  kernel/time.c              | 24 ++++++++++++++++++++++++
>  kernel/timeconst.bc        | 12 ++++++++++++
>  kernel/trace/trace_clock.c |  2 +-
>  4 files changed, 38 insertions(+), 6 deletions(-)
...
