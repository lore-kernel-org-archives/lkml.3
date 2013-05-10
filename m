Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751280Ab3EJFrx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 May 2013 01:47:53 -0400
Received: from mail.parknet.co.jp ([210.171.160.6]:54390 "EHLO
	mail.parknet.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751145Ab3EJFrs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 May 2013 01:47:48 -0400
From: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
To: Dave Chinner <david@fromorbit.com>
Cc: Daniel Phillips <daniel.raymond.phillips@gmail.com>,
        linux-fsdevel@vger.kernel.org, tux3@tux3.org,
        linux-kernel@vger.kernel.org
Subject: Re: Tux3 Report: Faster than tmpfs, what?
References: <CAEsagEhu3pND5j410mQM=AMEQZ-1WOG0qdKys0pfFv0-jkLs8g@mail.gmail.com>
	<20130510045049.GU24635@dastard>
Date: Fri, 10 May 2013 14:47:35 +0900
In-Reply-To: <20130510045049.GU24635@dastard> (Dave Chinner's message of "Fri,
	10 May 2013 14:50:49 +1000")
Message-ID: <87fvxvz8qw.fsf@devron.myhome.or.jp>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3.50 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dave Chinner <david@fromorbit.com> writes:

>> tux3:
>>     Operation      Count    AvgLat    MaxLat
>>     ----------------------------------------
>>     NTCreateX    1477980     0.003    12.944
> ....
>>     ReadX        2316653     0.002     0.499
>>     LockX           4812     0.002     0.207
>>     UnlockX         4812     0.001     0.221
>>     Throughput 1546.81 MB/sec  1 clients  1 procs  max_latency=12.950 ms
>
> Hmmm... No "Flush" operations. Gotcha - you've removed the data
> integrity operations from the benchmark.

Right. Because tux3 is not implementing fsync() yet. So, I did

	grep -v Flush /usr/share/dbench/client.txt > client2.txt

Why is it important for comparing?

> Ah, I get it now - you've done that so the front end of tux3 won't
> encounter any blocking operations and so can offload 100% of
> operations. It also explains the sync call every 4 seconds to keep
> tux3 back end writing out to disk so that a) all the offloaded work
> is done by the sync process and not measured by the benchmark, and
> b) so the front end doesn't overrun queues and throttle or run out
> of memory.

Our backend is still using debugging mode (flush each 10 transactions
for stress/debugging). Since no interface to use normal writeback
timing yet, and I'm not tackling about it yet.

And if normal writeback can't beat crappy fixed timing (4 secs), Rather,
it means we have to improve writeback timing. I.e. sync should be rather
slower than best timing, right?

> Oh, so nicely contrived. But terribly obvious now that I've found
> it.  You've carefully crafted the benchmark to demonstrate a best
> case workload for the tux3 architecture, then carefully not
> measured the overhead of the work tux3 has offloaded, and then not
> disclosed any of this in the hope that all people will look at is
> the headline.
>
> This would make a great case study for a "BenchMarketing For
> Dummies" book.

Simply wrong. I did this to start optimization of tux3 (We know we have
many places to optimize in tux3), but the result was that post. If you
can't see at all what we did by frontend/backend design from that, I'm a
bit sad for it.

I think I can improve tmpfs/ext4 like tux3 (Unlink/Deltree) if I want to
do, from this result.

Thanks.
-- 
OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
