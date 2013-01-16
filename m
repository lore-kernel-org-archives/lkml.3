Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758570Ab3APHbv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jan 2013 02:31:51 -0500
Received: from mga03.intel.com ([143.182.124.21]:32978 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752676Ab3APHbu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jan 2013 02:31:50 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,476,1355126400"; 
   d="scan'208";a="191670034"
Message-ID: <50F657A1.1080102@intel.com>
Date: Wed, 16 Jan 2013 15:32:49 +0800
From: Alex Shi <alex.shi@intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120912 Thunderbird/15.0.1
MIME-Version: 1.0
To: Morten Rasmussen <Morten.Rasmussen@arm.com>
CC: "mingo@redhat.com" <mingo@redhat.com>,
        "peterz@infradead.org" <peterz@infradead.org>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "arjan@linux.intel.com" <arjan@linux.intel.com>,
        "bp@alien8.de" <bp@alien8.de>, "pjt@google.com" <pjt@google.com>,
        "namhyung@kernel.org" <namhyung@kernel.org>,
        "efault@gmx.de" <efault@gmx.de>,
        "vincent.guittot@linaro.org" <vincent.guittot@linaro.org>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "preeti@linux.vnet.ibm.com" <preeti@linux.vnet.ibm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v3 17/22] sched: packing small tasks in wake/exec balancing
References: <1357375071-11793-1-git-send-email-alex.shi@intel.com> <1357375071-11793-18-git-send-email-alex.shi@intel.com> <20130110171728.GG2046@e103034-lin> <50EF8B37.7050404@intel.com> <20130114170048.GB8528@e103034-lin>
In-Reply-To: <20130114170048.GB8528@e103034-lin>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/15/2013 01:00 AM, Morten Rasmussen wrote:
>>> Why multiply rq->util by nr_running?
>>> > > 
>>> > > Let's take an example where rq->util = 50, nr_running = 2, and putil =
>>> > > 10. In this case the value of putil doesn't really matter as vacancy
>>> > > would be negative anyway since FULL_UTIL - rq->util * nr_running is -1.
>>> > > However, with rq->util = 50 there should be plenty of spare cpu time to
>>> > > take another task.
>> > 
>> > for this example, the util is not full maybe due to it was just wake up,
>> > it still is possible like to run full time. So, I try to give it the
>> > large guess load.
> I don't see why rq->util should be treated different depending on the
> number of tasks causing the load. rq->util = 50 means that the cpu is
> busy about 50% of the time no matter how many tasks contibute to that
> load.
> 
> If nr_running = 1 instead in my example, you would consider the cpu
> vacant if putil = 6, but if nr_running > 1 you would not. Why should the
> two scenarios be treated differently?
> 
>>> > > 
>>> > > Also, why multiply putil by 8? rq->util must be very close to 0 for
>>> > > vacancy to be positive if putil is close to 12 (12.5%).
>> > 
>> > just want to pack small util tasks, since packing is possible to hurt
>> > performance.
> I agree that packing may affect performance. But why don't you reduce
> FULL_UTIL instead of multiplying by 8? With current expression you will
> not pack a 10% task if rq->util = 20 and nr_running = 1, but you would
> pack a 6% task even if rq->util = 50 and the resulting cpu load is much
> higher.
> 

Yes, the threshold has no strong theory or experiment support. I had
tried cyclitest which Vicent used, the case's load avg is too small to
be caught. so just use half of Vicent value as 12.5%. If you has more
reasonable value, let me know.

As to nr_running engaged as multiple mode. it's base on 2 reasons.
1, load avg/util need 345ms to accumulate as 100%. so, if a tasks is
cost full cpu time, it still has 345ms with rq->util < 1.
2, if there are more tasks, like 2 tasks running on one cpu, it's
possible to has capacity to burn 200% cpu time, while the biggest
rq->util is still 100%.

Consider to figure out precise utils is complicate and cost much. I do
this simple calculation. It is not very precise, but it is efficient and
more bias toward performance.

-- 
Thanks Alex
