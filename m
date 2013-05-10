Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751295Ab3EJEvK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 May 2013 00:51:10 -0400
Received: from ipmail07.adl2.internode.on.net ([150.101.137.131]:11682 "EHLO
	ipmail07.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750699Ab3EJEvI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 May 2013 00:51:08 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AhoQAFF8jFF5LFR6/2dsb2JhbABSgweDCrgXhRkEAX0XdIIfAQEEATocIwULCAMSBgklDwUlAw0UExiHbgW+AxaNaA2BHQeDVQOXK5E2gyEq
Date: Fri, 10 May 2013 14:50:49 +1000
From: Dave Chinner <david@fromorbit.com>
To: Daniel Phillips <daniel.raymond.phillips@gmail.com>
Cc: linux-kernel@vger.kernel.org, tux3@tux3.org, linux-fsdevel@vger.kernel.org
Subject: Re: Tux3 Report: Faster than tmpfs, what?
Message-ID: <20130510045049.GU24635@dastard>
References: <CAEsagEhu3pND5j410mQM=AMEQZ-1WOG0qdKys0pfFv0-jkLs8g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAEsagEhu3pND5j410mQM=AMEQZ-1WOG0qdKys0pfFv0-jkLs8g@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 07, 2013 at 04:24:05PM -0700, Daniel Phillips wrote:
> When something sounds to good to be true, it usually is. But not always. Today
> Hirofumi posted some nigh on unbelievable dbench results that show Tux3
> beating tmpfs. To put this in perspective, we normally regard tmpfs as
> unbeatable because it is just a thin shim between the standard VFS mechanisms
> that every filesystem must use, and the swap device. Our usual definition of
> successful optimization is that we end up somewhere between Ext4 and Tmpfs,
> or in other words, faster than Ext4. This time we got an excellent surprise.
> 
> The benchmark:
> 
>     dbench -t 30 -c client2.txt 1 & (while true; do sync; sleep 4; done)

I'm deeply suspicious of what is in that client2.txt file. dbench on
ext4 on a 4 SSD RAID0 array with a single process gets 130MB/s
(kernel is 3.9.0). Your workload gives you over 1GB/s on ext4.....

> tux3:
>     Operation      Count    AvgLat    MaxLat
>     ----------------------------------------
>     NTCreateX    1477980     0.003    12.944
....
>     ReadX        2316653     0.002     0.499
>     LockX           4812     0.002     0.207
>     UnlockX         4812     0.001     0.221
>     Throughput 1546.81 MB/sec  1 clients  1 procs  max_latency=12.950 ms

Hmmm... No "Flush" operations. Gotcha - you've removed the data
integrity operations from the benchmark.

Ah, I get it now - you've done that so the front end of tux3 won't
encounter any blocking operations and so can offload 100% of
operations. It also explains the sync call every 4 seconds to keep
tux3 back end writing out to disk so that a) all the offloaded work
is done by the sync process and not measured by the benchmark, and
b) so the front end doesn't overrun queues and throttle or run out
of memory.

Oh, so nicely contrived. But terribly obvious now that I've found
it.  You've carefully crafted the benchmark to demonstrate a best
case workload for the tux3 architecture, then carefully not
measured the overhead of the work tux3 has offloaded, and then not
disclosed any of this in the hope that all people will look at is
the headline.

This would make a great case study for a "BenchMarketing For
Dummies" book.

Shame for you that you sent it to a list where people see the dbench
numbers for ext4 and immediately think "that's not right" and then
look deeper.  Phoronix might swallow your sensationalist headline
grab without analysis, but I don't think I'm alone in my suspicion
that there was something stinky about your numbers.

Perhaps in future you'll disclose such information with your
results, otherwise nobody is ever going to trust anything you say
about tux3....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
