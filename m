Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966709Ab3DRONn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Apr 2013 10:13:43 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:58081 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S965122Ab3DRONm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Apr 2013 10:13:42 -0400
X-IronPort-AV: E=Sophos;i="4.87,502,1363104000"; 
   d="scan'208";a="7087943"
Message-ID: <516FFFAC.8040103@cn.fujitsu.com>
Date: Thu, 18 Apr 2013 22:14:04 +0800
From: Wanlong Gao <gaowanlong@cn.fujitsu.com>
Reply-To: gaowanlong@cn.fujitsu.com
Organization: Fujitsu
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130402 Thunderbird/17.0.5
MIME-Version: 1.0
To: Jens Axboe <axboe@kernel.dk>
CC: Steven Rostedt <rostedt@goodmis.org>, Tejun Heo <tj@kernel.org>,
        namhyung@gmail.com, agk@redhat.com, dm-devel@redhat.com, neilb@suse.de,
        LKML <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Wanlong Gao <gaowanlong@cn.fujitsu.com>
Subject: Re: [BUG REPORT] Kernel panic on 3.9.0-rc7-4-gbb33db7
References: <516E5EF8.9090507@cn.fujitsu.com> <1366209997.8817.12.camel@pippen.local.home> <20130418123738.GV4816@kernel.dk> <516FED09.1040008@cn.fujitsu.com> <20130418133546.GX4816@kernel.dk>
In-Reply-To: <20130418133546.GX4816@kernel.dk>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/04/18 22:12:14,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/04/18 22:12:15,
	Serialize complete at 2013/04/18 22:12:15
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/18/2013 09:35 PM, Jens Axboe wrote:
> On Thu, Apr 18 2013, Wanlong Gao wrote:
>>> A bio is always fully initialized, regardless of which internal
>>> allocator it came from. If people are doing private kmallocs, then they
>>> better be using bio_init() as well.
>>>
>>> Wanlong, would it be possible to get a full dmesg on boot see I can see
>>> what drivers and file systems are in use? Anything special about your
>>> setup.
>>
>> Sure, attached.
> 
> Does the below help?

Still got panic with this patch. :-(

Thanks,
Wanlong Gao

> 
> 
> diff --git a/kernel/trace/blktrace.c b/kernel/trace/blktrace.c
> index 9e5b8c2..f9a51a6 100644
> --- a/kernel/trace/blktrace.c
> +++ b/kernel/trace/blktrace.c
> @@ -780,15 +780,23 @@ static void blk_add_trace_bio_bounce(void *ignore,
>  	blk_add_trace_bio(q, bio, BLK_TA_BOUNCE, 0);
>  }
>  
> +static struct request_queue *blk_trace_get_queue(struct block_device *bdev)
> +{
> +	if (bdev->bd_disk == NULL)
> +		return NULL;
> +
> +	return bdev_get_queue(bdev);
> +}
> +
>  static void blk_add_trace_bio_complete(void *ignore, struct bio *bio, int error)
>  {
>  	struct request_queue *q;
>  	struct blk_trace *bt;
>  
> -	if (!bio->bi_bdev)
> +	q = blk_trace_get_queue(bio->bi_bdev);
> +	if (!q)
>  		return;
>  
> -	q = bdev_get_queue(bio->bi_bdev);
>  	bt = q->blk_trace;
>  
>  	/*
> @@ -1641,14 +1649,6 @@ static ssize_t blk_trace_mask2str(char *buf, int mask)
>  	return p - buf;
>  }
>  
> -static struct request_queue *blk_trace_get_queue(struct block_device *bdev)
> -{
> -	if (bdev->bd_disk == NULL)
> -		return NULL;
> -
> -	return bdev_get_queue(bdev);
> -}
> -
>  static ssize_t sysfs_blk_trace_attr_show(struct device *dev,
>  					 struct device_attribute *attr,
>  					 char *buf)
> 

