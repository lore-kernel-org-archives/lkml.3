Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752116AbaCCC0T (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Mar 2014 21:26:19 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:57304 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751452AbaCCC0S (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Mar 2014 21:26:18 -0500
X-IronPort-AV: E=Sophos;i="4.97,574,1389715200"; 
   d="scan'208";a="9633785"
Message-ID: <5313E644.5040409@cn.fujitsu.com>
Date: Mon, 03 Mar 2014 10:17:40 +0800
From: Gu Zheng <guz.fnst@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:7.0.1) Gecko/20110930 Thunderbird/7.0.1
MIME-Version: 1.0
To: Kent Overstreet <kmo@daterainc.com>
CC: Benjamin <bcrl@kvack.org>, Jens <axboe@kernel.dk>, linux-aio@kvack.org,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/2] aio: make aio_read_events_ring be aware of aio_complete
References: <53106486.1090300@cn.fujitsu.com> <20140228205243.GA7325@kmo-pixel>
In-Reply-To: <20140228205243.GA7325@kmo-pixel>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2014/03/03 10:23:44,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2014/03/03 10:23:44,
	Serialize complete at 2014/03/03 10:23:44
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Kent,
Sorry for late replay.
On 03/01/2014 04:52 AM, Kent Overstreet wrote:

> On Fri, Feb 28, 2014 at 06:27:18PM +0800, Gu Zheng wrote:
>> Commit 5ffac122dbda8(aio: Don't use ctx->tail unnecessarily) uses
>> ring->tail rather than the ctx->tail, but with this change, we fetch 'tail'
>> only once at the start, so that we can not be aware of adding event by aio_complete
>> when reading events. It seems a regression.
> 
> "Seems a regression" is not good enough. What breaks? 

Previously without the commit 5ffac122dbda8, we used tail from aio context to judge
whether the ring buffer has events(have not been read) each time, as following:
avail = (head <= ctx->tail ? ctx->tail : ctx->nr_events) - head;
so that we can be aware of new events that added by aio_complete when we are reading the
current ones, and we can read the new added events together.
E.g. we want to read 10 events, only 8 events now, add 2 events added while we copying
current 8 events to userspace, and we can read the 2 new events in the next circle.
But with the commit 5ffac122dbda8, we fetch tail from ring buffer only once when we start
to read events, so that we can not be aware of events that added by aio_complete while we
are reading current events(e.g. copy currents events to user space). Such as the case
mentioned above can only read 8 events, though these are 2 new events in the ring buffer.
Is not it a regression, or am I missing something?

Regards,
Gu

> 
>> So here we fetch the ring->tail in start of the loop each time to make it be
>> aware of adding event from aio_complete.
>>
>> Signed-off-by: Gu Zheng <guz.fnst@cn.fujitsu.com>
>> ---
>>  fs/aio.c |    6 +++++-
>>  1 files changed, 5 insertions(+), 1 deletions(-)
>>
>> diff --git a/fs/aio.c b/fs/aio.c
>> index 7eaa631..f5b8551 100644
>> --- a/fs/aio.c
>> +++ b/fs/aio.c
>> @@ -1029,10 +1029,14 @@ static long aio_read_events_ring(struct kioctx *ctx,
>>  		struct io_event *ev;
>>  		struct page *page;
>>  
>> -		avail = (head <= tail ?  tail : ctx->nr_events) - head;
>> +		ring = kmap_atomic(ctx->ring_pages[0]);
>> +		tail = ring->tail;
>> +		kunmap_atomic(ring);
>> +
>>  		if (head == tail)
>>  			break;
>>  
>> +		avail = (head <= tail ?  tail : ctx->nr_events) - head;
>>  		avail = min(avail, nr - ret);
>>  		avail = min_t(long, avail, AIO_EVENTS_PER_PAGE -
>>  			    ((head + AIO_EVENTS_OFFSET) % AIO_EVENTS_PER_PAGE));
>> -- 
>> 1.7.7
>>
> 


