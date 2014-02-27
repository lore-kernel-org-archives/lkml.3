Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753725AbaB0RXD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Feb 2014 12:23:03 -0500
Received: from mga11.intel.com ([192.55.52.93]:52528 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753224AbaB0RW6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Feb 2014 12:22:58 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,556,1389772800"; 
   d="scan'208";a="489366357"
Date: Thu, 27 Feb 2014 12:22:54 -0500
From: Matthew Wilcox <willy@linux.intel.com>
To: Kent Overstreet <kmo@daterainc.com>
Cc: axboe@kernel.dk, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, Neil Brown <neilb@suse.de>,
        Alasdair Kergon <agk@redhat.com>, dm-devel@redhat.com,
        Lars Ellenberg <drbd-dev@lists.linbit.com>, drbd-user@lists.linbit.com,
        Asai Thambi S P <asamymuthupa@micron.com>,
        Sam Bradshaw <sbradshaw@micron.com>, linux-nvme@lists.infradead.org,
        Jiri Kosina <jkosina@suse.cz>, Geoff Levand <geoff@infradead.org>,
        Jim Paris <jim@jtan.com>, Joshua Morris <josh.h.morris@us.ibm.com>,
        Philip Kelleher <pjk1939@linux.vnet.ibm.com>,
        Minchan Kim <minchan@kernel.org>, Nitin Gupta <ngupta@vflare.org>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Peng Tao <bergwolf@gmail.com>
Subject: Re: [PATCH 1/9] block: Make generic_make_request handle arbitrary
 sized bios
Message-ID: <20140227172254.GI5744@linux.intel.com>
References: <1393457997-17618-1-git-send-email-kmo@daterainc.com>
 <1393457997-17618-2-git-send-email-kmo@daterainc.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1393457997-17618-2-git-send-email-kmo@daterainc.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 26, 2014 at 03:39:49PM -0800, Kent Overstreet wrote:
> We do this by adding calls to blk_queue_split() to the various
> make_request functions that need it - a few can already handle arbitrary
> size bios. Note that we add the call _after_ any call to blk_queue_bounce();
> this means that blk_queue_split() and blk_recalc_rq_segments() don't need to
> be concerned with bouncing affecting segment merging.

> diff --git a/drivers/block/nvme-core.c b/drivers/block/nvme-core.c
> index 51824d1f23..e4376b9613 100644
> --- a/drivers/block/nvme-core.c
> +++ b/drivers/block/nvme-core.c
> @@ -737,6 +737,8 @@ static void nvme_make_request(struct request_queue *q, struct bio *bio)
>  	struct nvme_queue *nvmeq = get_nvmeq(ns->dev);
>  	int result = -EBUSY;
>  
> +	blk_queue_split(q, &bio, q->bio_split);
> +
>  	if (!nvmeq) {
>  		put_nvmeq(NULL);
>  		bio_endio(bio, -EIO);

I'd suggest that we do:

-	struct nvme_queue *nvmeq = get_nvmeq(ns->dev);
+	struct nvme_queue *nvmeq;
 	int result = -EBUSY;

+	blk_queue_split(q, &bio, q->bio_split);
+
+	nvmeq = get_nvmeq(ns->dev);
 	if (!nvmeq) {

so that we're running the blk_queue_split() code outside the get_cpu()
call.

Now, the NVMe driver has its own rules about when BIOs have to be split.
Right now, that's way down inside the nvme_map_bio() call when we're
walking the bio to compose the scatterlist.  Should we instead have an
nvme_bio_split() routine that is called instead of blk_queue_split(),
and we can simplify nvme_map_bio() since it'll know that it's working
with bios that don't have to be split.

In fact, I think it would have little NVMe-specific in it at that point,
so we could name __blk_bios_map_sg() better, export it to drivers and
call it from nvme_map_bio(), which I think would make everybody happier.

> diff --git a/drivers/block/pktcdvd.c b/drivers/block/pktcdvd.c
> index a2af73db18..a37acf722b 100644
> --- a/drivers/block/pktcdvd.c
> +++ b/drivers/block/pktcdvd.c
> @@ -2444,6 +2444,10 @@ static void pkt_make_request(struct request_queue *q, struct bio *bio)
>  	char b[BDEVNAME_SIZE];
>  	struct bio *split;
>  
> +	blk_queue_bounce(q, &bio);
> +
> +	blk_queue_split(q, &bio, q->bio_split);
> +
>  	pd = q->queuedata;
>  	if (!pd) {
>  		pr_err("%s incorrect request queue\n",
> @@ -2474,8 +2478,6 @@ static void pkt_make_request(struct request_queue *q, struct bio *bio)
>  		goto end_io;
>  	}
>  
> -	blk_queue_bounce(q, &bio);
> -
>  	do {
>  		sector_t zone = get_zone(bio->bi_iter.bi_sector, pd);
>  		sector_t last_zone = get_zone(bio_end_sector(bio) - 1, pd);
> diff --git a/drivers/block/ps3vram.c b/drivers/block/ps3vram.c
> index ef45cfb98f..a995972961 100644
> --- a/drivers/block/ps3vram.c
> +++ b/drivers/block/ps3vram.c
> @@ -603,6 +603,8 @@ static void ps3vram_make_request(struct request_queue *q, struct bio *bio)
>  	struct ps3vram_priv *priv = ps3_system_bus_get_drvdata(dev);
>  	int busy;
>  
> +	blk_queue_split(q, &bio, q->bio_split);
> +
>  	dev_dbg(&dev->core, "%s\n", __func__);
>  
>  	spin_lock_irq(&priv->lock);
> diff --git a/drivers/block/rsxx/dev.c b/drivers/block/rsxx/dev.c
> index 2839d37e5a..ff074a3cd4 100644
> --- a/drivers/block/rsxx/dev.c
> +++ b/drivers/block/rsxx/dev.c
> @@ -169,6 +169,8 @@ static void rsxx_make_request(struct request_queue *q, struct bio *bio)
>  	struct rsxx_bio_meta *bio_meta;
>  	int st = -EINVAL;
>  
> +	blk_queue_split(q, &bio, q->bio_split);
> +
>  	might_sleep();
>  
>  	if (!card)
> diff --git a/drivers/block/umem.c b/drivers/block/umem.c
> index 4cf81b5bf0..13d577cfbc 100644
> --- a/drivers/block/umem.c
> +++ b/drivers/block/umem.c
> @@ -531,6 +531,8 @@ static void mm_make_request(struct request_queue *q, struct bio *bio)
>  		 (unsigned long long)bio->bi_iter.bi_sector,
>  		 bio->bi_iter.bi_size);
>  
> +	blk_queue_split(q, &bio, q->bio_split);
> +
>  	spin_lock_irq(&card->lock);
>  	*card->biotail = bio;
>  	bio->bi_next = NULL;
> diff --git a/drivers/block/zram/zram_drv.c b/drivers/block/zram/zram_drv.c
> index 011e55d820..ecf9daa01c 100644
> --- a/drivers/block/zram/zram_drv.c
> +++ b/drivers/block/zram/zram_drv.c
> @@ -733,6 +733,8 @@ static void zram_make_request(struct request_queue *queue, struct bio *bio)
>  {
>  	struct zram *zram = queue->queuedata;
>  
> +	blk_queue_split(queue, &bio, queue->bio_split);
> +
>  	down_read(&zram->init_lock);
>  	if (unlikely(!zram->init_done))
>  		goto error;
> diff --git a/drivers/md/dm.c b/drivers/md/dm.c
> index 8c53b09b9a..97f70420f2 100644
> --- a/drivers/md/dm.c
> +++ b/drivers/md/dm.c
> @@ -1500,6 +1500,8 @@ static void dm_request(struct request_queue *q, struct bio *bio)
>  {
>  	struct mapped_device *md = q->queuedata;
>  
> +	blk_queue_split(q, &bio, q->bio_split);
> +
>  	if (dm_request_based(md))
>  		blk_queue_bio(q, bio);
>  	else
> diff --git a/drivers/md/md.c b/drivers/md/md.c
> index 4ad5cc4e63..1421bc3f7b 100644
> --- a/drivers/md/md.c
> +++ b/drivers/md/md.c
> @@ -256,6 +256,8 @@ static void md_make_request(struct request_queue *q, struct bio *bio)
>  	int cpu;
>  	unsigned int sectors;
>  
> +	blk_queue_split(q, &bio, q->bio_split);
> +
>  	if (mddev == NULL || mddev->pers == NULL
>  	    || !mddev->ready) {
>  		bio_io_error(bio);
> diff --git a/drivers/s390/block/dcssblk.c b/drivers/s390/block/dcssblk.c
> index ebf41e228e..db33cd3e4c 100644
> --- a/drivers/s390/block/dcssblk.c
> +++ b/drivers/s390/block/dcssblk.c
> @@ -815,6 +815,8 @@ dcssblk_make_request(struct request_queue *q, struct bio *bio)
>  	unsigned long source_addr;
>  	unsigned long bytes_done;
>  
> +	blk_queue_split(q, &bio, q->bio_split);
> +
>  	bytes_done = 0;
>  	dev_info = bio->bi_bdev->bd_disk->private_data;
>  	if (dev_info == NULL)
> diff --git a/drivers/s390/block/xpram.c b/drivers/s390/block/xpram.c
> index 6969d39f1e..f03c103f13 100644
> --- a/drivers/s390/block/xpram.c
> +++ b/drivers/s390/block/xpram.c
> @@ -190,6 +190,8 @@ static void xpram_make_request(struct request_queue *q, struct bio *bio)
>  	unsigned long page_addr;
>  	unsigned long bytes;
>  
> +	blk_queue_split(q, &bio, q->bio_split);
> +
>  	if ((bio->bi_iter.bi_sector & 7) != 0 ||
>  	    (bio->bi_iter.bi_size & 4095) != 0)
>  		/* Request is not page-aligned. */
> diff --git a/drivers/staging/lustre/lustre/llite/lloop.c b/drivers/staging/lustre/lustre/llite/lloop.c
> index 0718905ade..a3f6dc930b 100644
> --- a/drivers/staging/lustre/lustre/llite/lloop.c
> +++ b/drivers/staging/lustre/lustre/llite/lloop.c
> @@ -344,6 +344,8 @@ static void loop_make_request(struct request_queue *q, struct bio *old_bio)
>  	int rw = bio_rw(old_bio);
>  	int inactive;
>  
> +	blk_queue_split(q, &old_bio, q->bio_split);
> +
>  	if (!lo)
>  		goto err;
>  
> diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
> index 1e1fa3f93d..99e9955c4d 100644
> --- a/include/linux/blkdev.h
> +++ b/include/linux/blkdev.h
> @@ -470,6 +470,7 @@ struct request_queue {
>  	wait_queue_head_t	mq_freeze_wq;
>  	struct percpu_counter	mq_usage_counter;
>  	struct list_head	all_q_node;
> +	struct bio_set		*bio_split;
>  };
>  
>  #define QUEUE_FLAG_QUEUED	1	/* uses generic tag queueing */
> @@ -781,6 +782,8 @@ extern void blk_rq_unprep_clone(struct request *rq);
>  extern int blk_insert_cloned_request(struct request_queue *q,
>  				     struct request *rq);
>  extern void blk_delay_queue(struct request_queue *, unsigned long);
> +extern void blk_queue_split(struct request_queue *, struct bio **,
> +			    struct bio_set *);
>  extern void blk_recount_segments(struct request_queue *, struct bio *);
>  extern int scsi_verify_blk_ioctl(struct block_device *, unsigned int);
>  extern int scsi_cmd_blk_ioctl(struct block_device *, fmode_t,
> -- 
> 1.9.0
