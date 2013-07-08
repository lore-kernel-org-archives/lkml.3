Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753013Ab3GHUKw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Jul 2013 16:10:52 -0400
Received: from mail-vb0-f46.google.com ([209.85.212.46]:54749 "EHLO
	mail-vb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752613Ab3GHUKt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Jul 2013 16:10:49 -0400
MIME-Version: 1.0
In-Reply-To: <20130708130512.1171af89@nehalam.linuxnetplumber.net>
References: <20130708132034.17639.4396.stgit@ladj378.jer.intel.com>
	<CA+55aFxgrOtsv7vCtic97ehpvqyezCzDcyqHVD+821BiTuiRtw@mail.gmail.com>
	<51DAF373.4040606@linux.intel.com>
	<CA+55aFwWAmHhYaPWVm7rsqiD9+RhDPpgVC1yWc0oNmP38bty4Q@mail.gmail.com>
	<51DB16FC.7060003@linux.intel.com>
	<20130708130512.1171af89@nehalam.linuxnetplumber.net>
Date: Mon, 8 Jul 2013 13:10:48 -0700
X-Google-Sender-Auth: kNwVrFRv7-xahLnDmKA1X0t6LjU
Message-ID: <CA+55aFwVBY4LqmAvvCDBhESVY2QwCExzvhPdET99Hgo1LnFb=g@mail.gmail.com>
Subject: Re: [PATCH net-next] net: rename low latency sockets functions to
 busy poll
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Stephen Hemminger <stephen@networkplumber.org>
Cc: Eliezer Tamir <eliezer.tamir@linux.intel.com>,
        David Miller <davem@davemloft.net>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        David Woodhouse <dwmw2@infradead.org>,
        Eliezer Tamir <eliezer@tamir.org.il>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 8, 2013 at 1:05 PM, Stephen Hemminger
<stephen@networkplumber.org> wrote:
>> >
>> >     unsigned long start_time = 0;
>> >     ...
>> >     if (want_busy_poll && !need_resched()) {
>> >         unsigned long now = busy_poll_sched_clock();
>> >         if (!start_time) {
>> >             start_time = now + sysctl.busypoll;
>> >             continue;
>> >         }
>> >         if (time_before(start_time, now))
>> >             continue;
>> >     }
>> >
>>
>
> Since this code is in hot path, and a special case, looks like a good
> candidate for static branch.

No, it's not static. It's an initializer, yes, but it's not a static
one, and it gets run on every single select()/poll(). Well, every
single one that goes through the loop more than once.

So it's very much a dynamic condition. It's just placed that way to
avoid doing the (relatively expensive) time read for the case where
data is available immediately.

And the "data is available immediately" case is actually fairly
common. Sometimes it's because the producer/network is faster than the
consumer. And sometimes it's because you get big chunks at a time, but
the reader/writer ends up always going through a select() loop without
actually reading/writing everything in a loop until it gets a
full/empty error.

And I bet that both of those cases happen even with programs/networks
that end up using the magic low-latency/busyloop polling flags. So
avoiding the timer read if at all possible is definitely a good idea.

                  Linus
