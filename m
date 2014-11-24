Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752069AbaKXEpy (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Nov 2014 23:45:54 -0500
Received: from mail-pd0-f182.google.com ([209.85.192.182]:39803 "EHLO
	mail-pd0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751414AbaKXEpx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Nov 2014 23:45:53 -0500
Date: Sun, 23 Nov 2014 20:48:06 -0800
From: Kent Overstreet <kmo@daterainc.com>
To: Gu Zheng <guz.fnst@cn.fujitsu.com>
Cc: axboe@kernel.dk, akpm@linux-foundation.org, dm-devel@redhat.com,
        linux-kernel@vger.kernel.org, linux-nvme@lists.infradead.org,
        drbd-user@lists.linbit.com
Subject: Re: [PATCH 3/6] md/bcache: use generic io stats accounting functions
 to simplify io stat accounting
Message-ID: <20141124044806.GA22025@kmo-pixel>
References: <1416798327-12817-1-git-send-email-guz.fnst@cn.fujitsu.com>
 <1416798327-12817-4-git-send-email-guz.fnst@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1416798327-12817-4-git-send-email-guz.fnst@cn.fujitsu.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 24, 2014 at 11:05:24AM +0800, Gu Zheng wrote:
> Use generic io stats accounting help functions (generic_{start,end}_io_acct)
> to simplify io stat accounting.
> 
> Signed-off-by: Gu Zheng <guz.fnst@cn.fujitsu.com>

Cool!

Acked-by: Kent Overstreet <kmo@datera.io>

> ---
>  drivers/md/bcache/request.c |   23 ++++++-----------------
>  1 files changed, 6 insertions(+), 17 deletions(-)
> 
> diff --git a/drivers/md/bcache/request.c b/drivers/md/bcache/request.c
> index 62e6e98..ab43fad 100644
> --- a/drivers/md/bcache/request.c
> +++ b/drivers/md/bcache/request.c
> @@ -601,13 +601,8 @@ static void request_endio(struct bio *bio, int error)
>  static void bio_complete(struct search *s)
>  {
>  	if (s->orig_bio) {
> -		int cpu, rw = bio_data_dir(s->orig_bio);
> -		unsigned long duration = jiffies - s->start_time;
> -
> -		cpu = part_stat_lock();
> -		part_round_stats(cpu, &s->d->disk->part0);
> -		part_stat_add(cpu, &s->d->disk->part0, ticks[rw], duration);
> -		part_stat_unlock();
> +		generic_end_io_acct(bio_data_dir(s->orig_bio),
> +				    &s->d->disk->part0, s->start_time);
>  
>  		trace_bcache_request_end(s->d, s->orig_bio);
>  		bio_endio(s->orig_bio, s->iop.error);
> @@ -959,12 +954,9 @@ static void cached_dev_make_request(struct request_queue *q, struct bio *bio)
>  	struct search *s;
>  	struct bcache_device *d = bio->bi_bdev->bd_disk->private_data;
>  	struct cached_dev *dc = container_of(d, struct cached_dev, disk);
> -	int cpu, rw = bio_data_dir(bio);
> +	int rw = bio_data_dir(bio);
>  
> -	cpu = part_stat_lock();
> -	part_stat_inc(cpu, &d->disk->part0, ios[rw]);
> -	part_stat_add(cpu, &d->disk->part0, sectors[rw], bio_sectors(bio));
> -	part_stat_unlock();
> +	generic_start_io_acct(rw, bio_sectors(bio), &d->disk->part0);
>  
>  	bio->bi_bdev = dc->bdev;
>  	bio->bi_iter.bi_sector += dc->sb.data_offset;
> @@ -1074,12 +1066,9 @@ static void flash_dev_make_request(struct request_queue *q, struct bio *bio)
>  	struct search *s;
>  	struct closure *cl;
>  	struct bcache_device *d = bio->bi_bdev->bd_disk->private_data;
> -	int cpu, rw = bio_data_dir(bio);
> +	int rw = bio_data_dir(bio);
>  
> -	cpu = part_stat_lock();
> -	part_stat_inc(cpu, &d->disk->part0, ios[rw]);
> -	part_stat_add(cpu, &d->disk->part0, sectors[rw], bio_sectors(bio));
> -	part_stat_unlock();
> +	generic_start_io_acct(rw, bio_sectors(bio), &d->disk->part0);
>  
>  	s = search_alloc(bio, d);
>  	cl = &s->cl;
> -- 
> 1.7.7
> 
