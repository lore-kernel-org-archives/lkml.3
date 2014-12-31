Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751693AbaLaBtm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Dec 2014 20:49:42 -0500
Received: from mail-pa0-f53.google.com ([209.85.220.53]:52298 "EHLO
	mail-pa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750743AbaLaBtl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Dec 2014 20:49:41 -0500
Message-ID: <54A35630.7030000@kernel.dk>
Date: Tue, 30 Dec 2014 18:49:36 -0700
From: Jens Axboe <axboe@kernel.dk>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: Sebastian Herbszt <herbszt@gmx.de>, linux-kernel@vger.kernel.org
Subject: Re: blk-mq: should elv_iosched_store return ENXIO/EINVAL?
References: <20141231003726.00002588@localhost>
In-Reply-To: <20141231003726.00002588@localhost>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/30/2014 04:37 PM, Sebastian Herbszt wrote:
> Hello,
>
> setting an invalid elevator without blk-mq results in an error:
>
> # cat /sys/block/sda/queue/scheduler
> noop deadline [cfq]
> # echo foo > /sys/block/sda/queue/scheduler
> -bash: echo: write error: Invalid argument
> # dmesg
> [  328.767088] elevator: type foo not found
> [  328.767097] elevator: switch to foo
>   failed
>
> With blk-mq no error is returned:
>
> # cat /sys/block/sda/queue/scheduler
> none
> # echo foo > /sys/block/sda/queue/scheduler
> # echo $?
> 0
>
>
> block/elevator.c got
>
>   988 ssize_t elv_iosched_store(struct request_queue *q, const char *name,
>   989                           size_t count)
>   990 {
>   991         int ret;
>   992
>   993         if (!q->elevator)
>   994                 return count;
>   995
>   996         ret = __elevator_change(q, name);
>
> and
>
>   952 static int __elevator_change(struct request_queue *q, const char *name)
>   953 {
>   954         char elevator_name[ELV_NAME_MAX];
>   955         struct elevator_type *e;
>   956
>   957         if (!q->elevator)
>   958                 return -ENXIO;
>   959
>   960         strlcpy(elevator_name, name, sizeof(elevator_name));
>   961         e = elevator_get(strstrip(elevator_name), true);
>   962         if (!e) {
>   963                 printk(KERN_ERR "elevator: type %s not found\n", elevator_name);
>   964                 return -EINVAL;
>   965         }
>
>
> So !q->elevator is checked in elv_iosched_store and __elevator_change.
>
> Should elv_iosched_store return ENXIO or EINVAL or should __elevator_change
> handle this?

I agree the behavior is strange, but it actually matches what would 
happen for a make_request_fn based driver in this or earlier kernels. So 
there is a worry of changing the API if we modify it in general. The 
safe change would be to have these two lines before the q->elevator check:

if (q->mq_ops)
     return -EINVAL;

since that's new enough not to be a "real" API change. If we do that, we 
could let it slide into the general !q->elevator case after a few revisions.

Or we can just leave it as-is. If you read back the value after writing 
to it, it will always return "none".

-- 
Jens Axboe

