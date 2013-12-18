Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753754Ab3LRFYL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Dec 2013 00:24:11 -0500
Received: from lgeamrelo02.lge.com ([156.147.1.126]:53284 "EHLO
	LGEAMRELO02.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753731Ab3LRFYJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Dec 2013 00:24:09 -0500
X-AuditID: 9c93017e-b7c17ae000003961-cf-52b13177223f
Date: Wed, 18 Dec 2013 14:24:40 +0900
From: Minchan Kim <minchan@kernel.org>
To: Chanho Min <chanho.min@lge.com>
Cc: Phillip Lougher <phillip@squashfs.org.uk>, linux-kernel@vger.kernel.org,
        =?utf-8?B?7J6E7Zqo7KSA?= <hyojun.im@lge.com>,
        =?utf-8?B?7J206rG07Zi4?= <gunho.lee@lge.com>
Subject: Re: Re : Re: [PATCH] Squashfs: add asynchronous read support
Message-ID: <20131218052440.GC19968@bbox>
References: <1387171826-20110-1-git-send-email-chanho.min@lge.com>
 <OF0A0B2022.F34682B9-ON49257C45.0018AF5F-49257C45.0018AF60@lge.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <OF0A0B2022.F34682B9-ON49257C45.0018AF5F-49257C45.0018AF60@lge.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

Please don't break thread.
You should reply to my mail instead of your original post.

On Wed, Dec 18, 2013 at 01:29:37PM +0900, Chanho Min wrote:
> 
> > I did test it on x86 with USB stick and ARM with eMMC on my Nexus 4.
> > In experiment, I couldn't see much gain like you both system and even it
> > was regressed at bs=32k test, maybe workqueue allocation/schedule of work
> > per I/O.
> > Your test is rather special or what I am missing?
> Can you specify your test result on ARM with eMMC.

Sure.
        before  after
32K     3.6M     3.4M
64K     6.3M     8.2M
128K    11.4M    11.7M
160K    13.6M    13.8M
256K    19.8M    19M
288K    21.3M    20.8M

> 
> > Before that, I'd like to know fundamental reason why your implementation
> > for asynchronous read enhance. At a first glance, I thought it's caused by
> > readahead from MM layer but when I read code, I found I was wrong.
> > MM's readahead logic works based on PageReadahead marker but squashfs
> > invalidates by grab_cache_page_nowait so it wouldn't work as we expected.
> >
> > Another possibility is block I/O merging in block layder by plugging logic,
> > which was what I tried a few month ago although implementation was really
> > bad. But it wouldn't work with your patch because do_generic_file_read
> > will unplug block layer by lock_page without merging enough I/O.
> >
> > So, what do you think real actuator for enhance your experiment?
> > Then, I could investigate why I can't get a benefit.
> Currently, squashfs adds request to the block device queue synchronously with
> wait for competion. mmc takes this request one by one and push them to host driver,
> But it allows mmc to be idle frequently. This patch allows to add block requset
> asynchrously without wait for competion, mmcqd can fetch a lot of request from block
> at a time. As a result, mmcqd get busy and use a more bandwidth of mmc.
> For test, I added two count variables in mmc_queue_thread as bellows
> and tested same dd transfer.
> 
> static int mmc_queue_thread(void *d)
> {
> ..
> 	do {
> 		if (req || mq->mqrq_prev->req) {
> 			fetch++;
> 		} else {
> 			idle++;
> 		}
> 	} while (1);
> ..
> }
> 
> without patch:
>  fetch: 920, idle: 460
> 
> with patch
>  fetch: 918, idle: 40

It's a result which isn't what I want to know.
What I wnat to know is why upper layer issues more I/O per second.

For example, you read 32K so MM layer will prepare 8 pages to read in but
at issuing at a first page, squashfs make 32 pages and fill the page cache
if we assume you use 128K compression so MM layer's already prepared 7 page
would be freed without further I/O and do_generic_file_read will wait for
completion by lock_page without further I/O queueing. It's not suprising.
One of page freed is a READA marked page so readahead couldn't work.
If readahead works, it would be just by luck. Actually, by simulation
64K dd, I found readahead logic would be triggered but it's just by luck
and it's not intended, I think.

If first issued I/O complete, squashfs decompress the I/O with 128K pages
so all 4 iteration(128K/32K) would be hit in page cache.
If all 128K hit in page cache, mm layer start to issue next I/O and
repeat above logic until you ends up reading all file size.
So my opition is that upper layer wouldn't issue more I/O logically.
If it worked, it's not what we expect but side-effect.

That's why I'd like to know what's your thought for increasing IOPS.
Please, could you say your thought why IOPS increased, not a result
on low level driver?

Anyway, in my opinion, we should take care of MM layer's readahead for
enhance sequential I/O. For it, we should use buffer pages passed by MM
instead of freeing them and allocating new pages in squashfs.
IMHO, it would be better to implement squashfs_readpages but my insight
is very weak so I guess Phillip will give more good idea/insight about
the issue.

Thanks!


> 
> Thanks
> Chanho.
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

-- 
Kind regards,
Minchan Kim
