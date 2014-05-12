Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759329AbaELRth (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 May 2014 13:49:37 -0400
Received: from mail-ig0-f170.google.com ([209.85.213.170]:35383 "EHLO
	mail-ig0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755874AbaELRtf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 May 2014 13:49:35 -0400
Message-ID: <537109AB.8010609@linaro.org>
Date: Mon, 12 May 2014 10:49:31 -0700
From: John Stultz <john.stultz@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: George Spelvin <linux@horizon.com>
CC: linux-kernel@vger.kernel.org,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Subject: Re: [PATCH 4/4] timekeeping: Use printk_deferred when holding timekeeping
 seqlock
References: <20140506213306.17674.qmail@ns.horizon.com>
In-Reply-To: <20140506213306.17674.qmail@ns.horizon.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

First: My apologies, for some reason your mail got tagged as spam, so I
only saw it just now looking for another missing email.


On 05/06/2014 02:33 PM, George Spelvin wrote:
> One misfeature in the timekeeping seqlock code I noticed is that
> read_seqcount_begin returns "unsigned int", not "unsigned long".
>
> Casting to a larger type is harmless, but inefficient.
Thanks for pointing this out. If you want to spin up a patch for this,
I'd be fine applying it. Otherwise I'll try to clean this up sometime soon.

>> This is due to printk() triggering console sem wakeup, which can
>> cause scheduling code to trigger hrtimers which may try to read
>> the time.
> An alternative solution, which avoids the need for this entire patch
> series, is to make ktime_get completely nonblocking.
>
> To do that, use a seqlock variant wherein you mintain an array of "struct
> timekeeper" structures so that reading is always non-blocking if there
> is no writer progress.  (I.e. livelock is remotely possible, but deadlock
> is not.)
>
> In the basic version, there are two.  (You can add more to further
> reduce the chance of livelock.)  The currently stable one is indicated
> by (timekeeper_seq->sequence & 2).  Writers update the appropriate
> one ping-pong.  The low two bits indicate four phases:
>
> 0: Both timekeepers stable, [0] preferred for reading
> 1: Timekeeper[1] is being written; read timekeeper[0] only
> 2: Both timekeepers stable, [1] preferred for reading
> 3: Timekeeper[0] is being written; read timekeeper[1] only


So this has been suggested before (and I've spent some time awhile back
trying to implement it).  The problem is that should the update be
significantly delayed (by for instance, the host preempting a VM's cpu
for some extended period), and a frequency adjustment slowing the clock
was being applied to the new timekeeper, the continued use of the old
timekeeper could cause the current time to over-shoot the new
timekeeper, causing time to go backwards when we finally made the switch. :(

But I believe the sched_clock code does something like this on x86,
since it doesn't have to handle frequency changes.

I would very much like to have a non-blocking implementation! We've also
looked at variants where we keep a valid-interval range in the structure
so readers can be sure the timekeeper they're using is still active
(sort of an expiration date), so we would only block if an update was
delayed. However this is problematic, since there are a number of
timekeeping calls in the hrtimer logic required to trigger the
timekeeping update. So if the update interrupt was delayed, those reads
would block, deadlocking the box.

So maybe you can come up with a tweak to make it possible, but when
discussing this at length w/ Matheiu Desnoyers, it seemed like the main
problem was there was no way to atomically validate that we hadn't been
delayed and update the pointer to the new structure without stopping all
the cpus with some sort of serializing lock.

thanks
-john

