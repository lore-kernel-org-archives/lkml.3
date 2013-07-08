Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753029Ab3GHTqO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Jul 2013 15:46:14 -0400
Received: from mga14.intel.com ([143.182.124.37]:32041 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752776Ab3GHTqM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Jul 2013 15:46:12 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,1021,1363158000"; 
   d="scan'208";a="265557960"
Message-ID: <51DB16FC.7060003@linux.intel.com>
Date: Mon, 08 Jul 2013 22:46:04 +0300
From: Eliezer Tamir <eliezer.tamir@linux.intel.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:17.0) Gecko/20130620 Thunderbird/17.0.7
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: David Miller <davem@davemloft.net>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        David Woodhouse <dwmw2@infradead.org>,
        Eliezer Tamir <eliezer@tamir.org.il>
Subject: Re: [PATCH net-next] net: rename low latency sockets functions to
 busy poll
References: <20130708132034.17639.4396.stgit@ladj378.jer.intel.com> <CA+55aFxgrOtsv7vCtic97ehpvqyezCzDcyqHVD+821BiTuiRtw@mail.gmail.com> <51DAF373.4040606@linux.intel.com> <CA+55aFwWAmHhYaPWVm7rsqiD9+RhDPpgVC1yWc0oNmP38bty4Q@mail.gmail.com>
In-Reply-To: <CA+55aFwWAmHhYaPWVm7rsqiD9+RhDPpgVC1yWc0oNmP38bty4Q@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/07/2013 22:37, Linus Torvalds wrote:
> On Mon, Jul 8, 2013 at 10:14 AM, Eliezer Tamir
> <eliezer.tamir@linux.intel.com> wrote:
>>
>> I think there is no way for the compiler to know the value of
>> can_busy_loop at compile time. It depends on the replies we get
>> from polling the sockets. ll_flag was there to make sure the compiler
>> will know when things are defined out.
> 
> No, my point was that we want to handle the easily seen register test
> first, and not even have to load current().
> 
> The compiler may end up scheduling the code to load current anyway,
> but the way you wrote it it's pretty much guaranteed that it will do
> it.

I see. OK.

> In fact, I'd argue for initializing start_time to zero, and have the
> "have we timed out" logic load it only if necessary, rather than
> initializing it based on whether POLL_BUSY_WAIT was set or not.
> Because one common case - even with POLL_BUSY_WAIT - is that we go
> through the loop exactly once, and the data exists on the very first
> try. And that is in fact the case we want to optimize and not do any
> extra work for at all.
> 
> So I would actually argue that the whole timeout code might as well be
> something like
> 
>     unsigned long start_time = 0;
>     ...
>     if (want_busy_poll && !need_resched()) {
>         unsigned long now = busy_poll_sched_clock();
>         if (!start_time) {
>             start_time = now + sysctl.busypoll;
>             continue;
>         }
>         if (time_before(start_time, now))
>             continue;
>     }
> 

OK.

Thanks,
Eliezer
