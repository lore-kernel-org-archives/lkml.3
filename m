Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755708Ab3ANCVT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Jan 2013 21:21:19 -0500
Received: from mail-pb0-f50.google.com ([209.85.160.50]:57453 "EHLO
	mail-pb0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751897Ab3ANCVS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Jan 2013 21:21:18 -0500
Date: Mon, 14 Jan 2013 10:21:04 +0800
From: majianpeng <majianpeng@gmail.com>
To: "Vivek Goyal" <vgoyal@redhat.com>, axboe <axboe@kernel.dk>
Cc: linux-kernel <linux-kernel@vger.kernel.org>, tj <tj@kernel.org>
Reply-To: majianpeng <majianpeng@gmail.com>
Subject: Re: Re: [PATCH] blkcg: Before starting a new slice, firstly count bps/iops limit in func tg_may_dispatch.
References: <201301111711251317275@gmail.com> <50F0211D.7040209@kernel.dk>, 
	<20130111191726.GB12019@redhat.com>
X-Priority: 3
X-GUID: 1530D833-1BEF-4B33-96DC-5DF9CCE8AB25
X-Has-Attach: no
X-Mailer: Foxmail 7.0.1.90[en]
Mime-Version: 1.0
Message-ID: <201301141021000563002@gmail.com>
Content-Type: text/plain;
	charset="gb2312"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id r0E2LOo1030116

>On Fri, Jan 11, 2013 at 03:26:37PM +0100, Jens Axboe wrote:
>> On 2013-01-11 10:11, majianpeng wrote:
>> > In func tg_may_dispatch,
>> >> if (throtl_slice_used(td, tg, rw))
>> >> 		throtl_start_new_slice(td, tg, rw);
>> > ...
>> >> if (tg_with_in_bps_limit(td, tg, bio, &bps_wait)
>> >> 	    && tg_with_in_iops_limit(td, tg, bio, &iops_wait)) {
>> > 
>> > In funcs tg_with_in_(bps/iops)_limit, it used the slice_start to count.
>> > So if privious slice expired, it start a new slice.This can cause hung
>> > task.
>> > 
>> > The next steps can repeat this bug.
>> > 1:echo "8:48 10240" > blkio.throttle.write_bps_devic
>> > 2:dd if=/dev/zero of=/dev/sdd bs=1M count=1 oflag=direct
>> > 
>> > Using the blktrace, the messages about throttle:
>> > root@kernel:/mnt/programs# blktrace -d /dev/sdd -a notify -o -|blkparse -i -
>> >   8,48   1        0     0.000000000     0  m   N throtl / [W] new slice start=4294854679 end=4294854779 jiffies=4294854679
>> >   8,48   1        0     0.000000966     0  m   N throtl / [W] extend slice start=4294854679 end=4294905900 jiffies=4294854679
>> >   8,48   1        0     0.000002553     0  m   N throtl / [W] bio. bdisp=0 sz=524288 bps=10240 iodisp=0 iops=4294967295 queued=0/0
>> >   8,48   1        0     0.000004788     0  m   N throtl schedule work. delay=51200 jiffies=4294854679
>> >   8,48   1        0    51.304698681     0  m   N throtl dispatch nr_queued=1 read=0 write=1
>> >   8,48   1        0    51.304701979     0  m   N throtl / [W] new slice start=4294905984 end=4294906084 jiffies=4294905984
>> >   8,48   1        0    51.304703329     0  m   N throtl / [W] extend slice start=4294905984 end=4294957200 jiffies=4294905984
>> >   8,48   1        0    51.304705783     0  m   N throtl schedule work. delay=51200 jiffies=4294905984
>> >   8,48   1        0   102.632697082     0  m   N throtl dispatch nr_queued=1 read=0 write=1
>> >   8,48   1        0   102.632700544     0  m   N throtl / [W] new slice start=4294957312 end=4294957412 jiffies=4294957312
>> >   8,48   1        0   102.632701922     0  m   N throtl / [W] extend slice start=4294957312 end=4295008600 jiffies=4294957312
>> >   8,48   1        0   102.632704016     0  m   N throtl schedule work. delay=51200 jiffies=4294957312
>> >   8,48   1        0   153.960696503     0  m   N throtl dispatch nr_queued=1 read=0 write=1
>> >   8,48   1        0   153.960699797     0  m   N throtl / [W] new slice start=4295008640 end=4295008740 jiffies=4295008640
>> >   8,48   1        0   153.960701153     0  m   N throtl / [W] extend slice start=4295008640 end=4295059900 jiffies=4295008640
>> >   8,48   1        0   153.960703218     0  m   N throtl schedule work. delay=51200 jiffies=4295008640
>> >   8,48   1        0   205.288697067     0  m   N throtl dispatch nr_queued=1 read=0 write=1
>> >   8,48   1        0   205.288700268     0  m   N throtl / [W] new slice start=4295059968 end=4295060068 jiffies=4295059968
>> >   8,48   1        0   205.288701630     0  m   N throtl / [W] extend slice start=4295059968 end=4295111200 jiffies=4295059968
>> >   8,48   1        0   205.288703784     0  m   N throtl schedule work. delay=51200 jiffies=4295059968
>> >   8,48   1        0   256.616696184     0  m   N throtl dispatch nr_queued=1 read=0 write=1
>> >   8,48   1        0   256.616699266     0  m   N throtl / [W] new slice start=4295111296 end=4295111396 jiffies=4295111296
>> >   8,48   1        0   256.616700574     0  m   N throtl / [W] extend slice start=4295111296 end=4295162500 jiffies=4295111296
>> >   8,48   1        0   256.616702701     0  m   N throtl schedule work. delay=51200 jiffies=4295111296
>> > 
>> > Signed-off-by: Jianpeng Ma <majianpeng@gmail.com>
>> > ---
>> >  block/blk-throttle.c |   15 ++++++++++-----
>> >  1 file changed, 10 insertions(+), 5 deletions(-)
>> > 
>> > diff --git a/block/blk-throttle.c b/block/blk-throttle.c
>> > index 3114622..9258789 100644
>> > --- a/block/blk-throttle.c
>> > +++ b/block/blk-throttle.c
>> > @@ -645,6 +645,15 @@ static bool tg_may_dispatch(struct throtl_data *td, struct throtl_grp *tg,
>> >  	}
>> >  
>> >  	/*
>> > +	 * If privious slice expired,then start new slice.
>> > +	 * But counting bps and iops limit need privious slice info
>> > +	 * which ->slice_start.
>> > +	 */
>> > +	if (tg_with_in_bps_limit(td, tg, bio, &bps_wait)
>> > +	    && tg_with_in_iops_limit(td, tg, bio, &iops_wait))
>> > +		if (wait)
>> > +			*wait = 0;
>> > +	/*
>> >  	 * If previous slice expired, start a new one otherwise renew/extend
>> >  	 * existing slice to make sure it is at least throtl_slice interval
>> >  	 * long since now.
>> > @@ -656,12 +665,8 @@ static bool tg_may_dispatch(struct throtl_data *td, struct throtl_grp *tg,
>> >  			throtl_extend_slice(td, tg, rw, jiffies + throtl_slice);
>> >  	}
>> >  
>> > -	if (tg_with_in_bps_limit(td, tg, bio, &bps_wait)
>> > -	    && tg_with_in_iops_limit(td, tg, bio, &iops_wait)) {
>> > -		if (wait)
>> > -			*wait = 0;
>> > +	if (!(bps_wait || iops_wait))
>> >  		return 1;
>> > -	}
>> >  
>> >  	max_wait = max(bps_wait, iops_wait);
>> 
>> Looks pretty sane to me. Vivek?
>
>Hi Jens,
>
>This fix will introduce other side affects. And that is when an group
>has been idle for few seconds and a new IO gets queued in, we will
>not start a new slice and allow dispatch equivalent of those idle
>seconds before we throttle the group. So keeping group idle will
>become an incentive.
>
>I have attached a patch which might work better. majianpeng, can
>you please give it a try.
>
>Having said that it is strange that workqueue thread is triggering
>so late. Looking at timestamp of traces attached.
>
>We scheduled a delayed work. Following is trace.
>
>8,48   1        0    51.304705783     0  m   N throtl schedule work. delay=51200 jiffies=4294905984
>
>Now a worker should execute after 51.2 seconds (delay=51200).
>
>8,48   1        0   102.632697082     0  m   N throtl dispatch nr_queued=1 read=0 write=1
>
>But worker executed at delay of 51.328 seconds (102.632 - 51.304). That
>is a delay of around 128 jiffies (51.328 - 51.2). That kind of seems odd.
>AFAIK, workers are fairly quick to execute after expiry. And it is 
>because of this excessive delay that we think slice has expired. 
>
>May be it is something new. CCing Tejun, if he has seen anything like this
>and may be it is a known issue.
>
>Even if it is a worker thread issue, I think applying below patch makes
>sense.
>
>Thanks
>Vivek
>
>
>blk-throttle: Do not start a new slice if IO is pending
>
>It might happen that we queue an IO (because it overshot the rate)
>and then wait for certain jiffies to pass. We will set slice_end
>accordingly and wait for that time to elapse and worker thread will
>kick in, again evaluate whether group can dispatch or not. Now it
>might happen that current time is after slice_end and
>tg_may_dispatch() will start a new slice.
>
>This will result in IO not being dispatched and be put back on
>wait again. And this will repeat, resulting in hang.
>
>Do not start a new slice if an IO is pending in that group in
>the direction being queired. Instead extend the slice. New slice
>is supposed to start when a group has not been doing IO for some
>time and a new IO shows up. In that case we want do discard
>history and start a new slice.
>
>Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
>---
> block/blk-throttle.c |    8 +++++++-
> 1 file changed, 7 insertions(+), 1 deletion(-)
>
>Index: linux-2.6/block/blk-throttle.c
>===================================================================
>--- linux-2.6.orig/block/blk-throttle.c	2012-10-18 01:52:28.000000000 -0400
>+++ linux-2.6/block/blk-throttle.c	2013-01-14 03:40:41.355731375 -0500
>@@ -648,8 +648,14 @@ static bool tg_may_dispatch(struct throt
> 	 * If previous slice expired, start a new one otherwise renew/extend
> 	 * existing slice to make sure it is at least throtl_slice interval
> 	 * long since now.
>+	 *
>+	 * Start a new slice only if there is no bio queued in that direction.
>+	 * That bio is waiting to be dispatched and slice needs to be
>+	 * extended. It might happen that bio waited to be dispatched but
>+	 * workqueue execution got little late it might restart a new slice
>+	 * instead of taking all the waited time into account.
> 	 */
>-	if (throtl_slice_used(td, tg, rw))
>+	if (throtl_slice_used(td, tg, rw) && !tg->nr_queued[rw])
> 		throtl_start_new_slice(td, tg, rw);
> 	else {
> 		if (time_before(tg->slice_end[rw], jiffies + throtl_slice))
Hi vivek,
	Your patch is ok.But i had a question:
What's condition tg->nr_queued[rw] = 0, but bio is not null?

Thanks!
Jianpengÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
