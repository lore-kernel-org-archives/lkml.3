Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752525AbaIEQp4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Sep 2014 12:45:56 -0400
Received: from mail-lb0-f180.google.com ([209.85.217.180]:55126 "EHLO
	mail-lb0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751664AbaIEQpy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Sep 2014 12:45:54 -0400
MIME-Version: 1.0
In-Reply-To: <20140905163206.GA22743@infradead.org>
References: <CANP1eJGE=vQBdLnMBFPcTWrvh+dUA-UCK=ugO-tc2KN4LWLPSA@mail.gmail.com>
	<20140905110927.GI17501@suse.de>
	<20140905154829.GA22956@infradead.org>
	<CANP1eJEdH8Hk-i348N3YQ4FUoSGb-2Tp9g9ZJxnKO1zZskTKjg@mail.gmail.com>
	<20140905163206.GA22743@infradead.org>
Date: Fri, 5 Sep 2014 12:45:52 -0400
Message-ID: <CANP1eJHDQfcfrRw8JWzfBz34Q-CppN39iPXX+4BMig2k=ESRAQ@mail.gmail.com>
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

On Fri, Sep 5, 2014 at 12:32 PM, Christoph Hellwig <hch@infradead.org> wrote:
> On Fri, Sep 05, 2014 at 12:27:21PM -0400, Milosz Tanski wrote:
>> I would prefer a interface more like recv() where I can specify the
>> flag if I want blocking behavior for this read or not. Let me explain
>> why:
>>
>> In a VLDB like workload this would enable me to lower the latency of
>> common fast requests and. By fast requests I mean ones that do not
>> require much data, the data is cached, or there's a predictable read
>> pattern (read-ahead). Obviously it would be at the expense of the
>> latency of large/slow requests (they have to make 2 read calls, the
>> first one always EWOULDBLOCK) ... but in that case it doesn't matter
>> since the time to do actual IO would trump any kind of extra latency.
>
> This is another good suggestion.  I've actually heard people asking
> for allowing per-I/O flags for other uses cases.  The one I cane
> remember is applying O_DSYNC only for FUA writes on a SCSI target,
> the other one would be Samba again, as SMB allows per-I/O flags on
> the wire as well.
>
>> Essentially, it's using the kernel facilities (page cache) to help me
>> perform better (in a more predictable fashion). I would implement this
>> in our application tomorrow. It's frustrating that there is a similar
>> interface (recv* family) that I cannot use.
>>
>> I know there's been a bunch of attempts at buffered AIO and none of
>> them made it into the kernel. It would let me build a buffered AIO
>> implementation in user-space using a threadpool. And cached data would
>> not end up getting blocked behind other non-cached requests sitting in
>> the queue. I know there's other sources of blocking (locking, metadata
>> lookups) but direct AIO already suffers from these so I'm fine to
>> paper over that for now.
>
> Although I still think providing useful AIO at the kernel level would be
> better than having everyone reimplement it it still would be useful to
> allow people to sanely reimplement it.  If only to avoid the discussion
> about what API to use between the non-standard and not really that nice
> Linux io_submit and the utterly horrible Posix aio_ semantics.

Yeah, I would love for that to happen but I've been lurking and
following the non-blocking buffered AIO discussions and attempts on
lkml since about 2008 and the threads go back much further than that
about 12 years. I would take a much less ambitious syscall read/pread
syscall that gets me 90% of the way there and I can build the
remainder in user-space. It also has the nice side-effect of being
providing a not-horrible fallback for older/non-linux systems where
all IO goes into the thread pool (without the option to skip it).

-- 
Milosz Tanski
CTO
16 East 34th Street, 15th floor
New York, NY 10016

p: 646-253-9055
e: milosz@adfin.com
