Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751519AbaIEQ1Y (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Sep 2014 12:27:24 -0400
Received: from mail-la0-f49.google.com ([209.85.215.49]:33030 "EHLO
	mail-la0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751286AbaIEQ1X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Sep 2014 12:27:23 -0400
MIME-Version: 1.0
In-Reply-To: <20140905154829.GA22956@infradead.org>
References: <CANP1eJGE=vQBdLnMBFPcTWrvh+dUA-UCK=ugO-tc2KN4LWLPSA@mail.gmail.com>
	<20140905110927.GI17501@suse.de>
	<20140905154829.GA22956@infradead.org>
Date: Fri, 5 Sep 2014 12:27:21 -0400
Message-ID: <CANP1eJEdH8Hk-i348N3YQ4FUoSGb-2Tp9g9ZJxnKO1zZskTKjg@mail.gmail.com>
Subject: Re: read()/readv() only from page cache
From: Milosz Tanski <milosz@adfin.com>
To: Christoph Hellwig <hch@infradead.org>
Cc: Mel Gorman <mgorman@suse.de>, LKML <linux-kernel@vger.kernel.org>,
        Volker Lendecke <Volker.Lendecke@sernet.de>, Tejun Heo <tj@kernel.org>,
        linux-aio@kvack.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I would prefer a interface more like recv() where I can specify the
flag if I want blocking behavior for this read or not. Let me explain
why:

In a VLDB like workload this would enable me to lower the latency of
common fast requests and. By fast requests I mean ones that do not
require much data, the data is cached, or there's a predictable read
pattern (read-ahead). Obviously it would be at the expense of the
latency of large/slow requests (they have to make 2 read calls, the
first one always EWOULDBLOCK) ... but in that case it doesn't matter
since the time to do actual IO would trump any kind of extra latency.

Essentially, it's using the kernel facilities (page cache) to help me
perform better (in a more predictable fashion). I would implement this
in our application tomorrow. It's frustrating that there is a similar
interface (recv* family) that I cannot use.

I know there's been a bunch of attempts at buffered AIO and none of
them made it into the kernel. It would let me build a buffered AIO
implementation in user-space using a threadpool. And cached data would
not end up getting blocked behind other non-cached requests sitting in
the queue. I know there's other sources of blocking (locking, metadata
lookups) but direct AIO already suffers from these so I'm fine to
paper over that for now.


On Fri, Sep 5, 2014 at 11:48 AM, Christoph Hellwig <hch@infradead.org> wrote:
> On Fri, Sep 05, 2014 at 12:09:27PM +0100, Mel Gorman wrote:
>> I suggest you look at the recent fincore debate. It did not progress much
>> the last time because the author wanted to push a lot of functionality in
>> there where as reviewers felt it should start simple.  The simple case is
>> likely a good fit for what you want. The primary downside is that it would
>> be race-prone in memory pressure situations as the page could be reclaimed
>> between the fincore check and the read but I expect that your application
>> is already avoiding reclaim activity.
>
> I've actually experimentally hacked up O_NONBLOCK support for regular
> files so that it only returns data from the page cache, and not
> otherwise.  Volker promised to test it with Samba, but we never made
> any progress on it, and just last week a customer told me they would
> have liked to use it if it was available.
>
> Note that we might want to also avoid blocking on locks, and I have some
> vague memory that we shouldn't actually implement O_NONBLOCK on regular
> files due to compatibility options but would have to use a new flag
> instead.
>
> Note that mincor/fincore would not help for the usual use case where you
> have a non blocking event main loop and want to offload actual blocking
> I/O to helper threads, as you it returns information that can be stale
> any time.
>
> One further consideration would be to finally implement real buffered
> I/O in kernel space by something like the above and offloading to
> workqueues in kernelspace.  I think our workqueues now are way better
> than any possible user thread pool, although we'd need to find a way to
> temporarily tie the work threads to a user address space.



-- 
Milosz Tanski
CTO
16 East 34th Street, 15th floor
New York, NY 10016

p: 646-253-9055
e: milosz@adfin.com
