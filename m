Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935995Ab3DRP6N (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Apr 2013 11:58:13 -0400
Received: from merlin.infradead.org ([205.233.59.134]:50191 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932150Ab3DRP6M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Apr 2013 11:58:12 -0400
Date: Thu, 18 Apr 2013 08:58:03 -0700
From: Jens Axboe <axboe@kernel.dk>
To: Roger Pau =?iso-8859-1?Q?Monn=E9?= <roger.pau@citrix.com>
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        "martin.peterson@oracle.com" <martin.peterson@oracle.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "xen-devel@lists.xen.org" <xen-devel@lists.xen.org>
Subject: Re: [PATCH v1 7/7] xen-block: implement indirect descriptors
Message-ID: <20130418155803.GE4816@kernel.dk>
References: <1364382643-3711-8-git-send-email-roger.pau@citrix.com>
 <20130409184923.GA4978@phenom.dumpdata.com>
 <516C3264.3050409@citrix.com>
 <20130417142554.GG21378@phenom.dumpdata.com>
 <516ED633.3040205@citrix.com>
 <20130417172747.GA25736@phenom.dumpdata.com>
 <20130418124355.GW4816@kernel.dk>
 <5170005B.807@citrix.com>
 <20130418142642.GY4816@kernel.dk>
 <51700DD6.1020603@citrix.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <51700DD6.1020603@citrix.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 18 2013, Roger Pau Monné wrote:
> On 18/04/13 16:26, Jens Axboe wrote:
> >>>>>>> I've just set that to something that brings a performance benefit
> >>>>>>> without having to map an insane number of persistent grants in blkback.
> >>>>>>>
> >>>>>>> Yes, the values are correct, but the device request queue (rq) is only
> >>>>>>> able to provide read requests with 64 segments or write requests with
> >>>>>>> 128 segments. I haven't been able to get larger requests, even when
> >>>>>>> setting this to 512 or higer.
> >>>>>>
> >>>>>> What are you using to drive the requests? 'fio'?
> >>>>>
> >>>>> Yes, I've tried fio with several "bs=" values, but it doesn't seem to
> >>>>> change the size of the underlying requests. Have you been able to get
> >>>>> bigger requests?
> >>>>
> >>>> Martin, Jens,
> >>>> Any way to drive more than 128 segments?
> >>>
> >>> If the driver is bio based, then there's a natural size constraint on
> >>> the number of vecs in the bio. So to get truly large requests, the
> >>> driver would need to merge incoming sequential IOs (similar to how it's
> >>> done for rq based drivers).
> >>
> >> When you say rq based drivers, you mean drivers with a request queue?
> >>
> >> We are already using a request queue in blkfront, and I'm setting the
> >> maximum number of segments per request using:
> >>
> >> blk_queue_max_segments(<rq>, <segments>);
> >>
> >> But even when setting <segments> to 256 or 512, I only get read requests
> >> with 64 segments and write requests with 128 segments from the queue.
> > 
> > What kernel are you testing? The plugging is usually what will trigger a
> > run of the queue, for rq based drivers. What does your fio job look
> > like?
> > 
> 
> I'm currently testing on top of Konrad for-jens-3.9 branch, which is
> 3.8.0-rc7. This is how my fio job looks like:
> 
> [read]
> rw=read
> size=900m
> bs=4k
> directory=/root/fio
> loops=100000
> 
> I've tried several bs sizes; 4k, 16k, 128k, 1m, 10m, and as far as I can
> see requests from the queue don't have more than 64 segments.
> 
> Also tried a simple dd with several bs sizes and got the same result.

So you're running normal buffered IO. Most of the IO should be coming
out of read-ahead, you could try tweaking the size of the window.

-- 
Jens Axboe

