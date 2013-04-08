Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964946Ab3DHUuF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Apr 2013 16:50:05 -0400
Received: from mail-pd0-f174.google.com ([209.85.192.174]:57654 "EHLO
	mail-pd0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964861Ab3DHUuD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Apr 2013 16:50:03 -0400
Date: Mon, 8 Apr 2013 13:49:56 -0700
From: Kent Overstreet <koverstreet@google.com>
To: Gabriel <g2p.code@gmail.com>
Cc: linux-bcache@vger.kernel.org, linux-kernel@vger.kernel.org,
        Gabriel <g2p.code+bcache@gmail.com>
Subject: Re: [PATCH] bcache: Take data offset from the bdev superblock.
Message-ID: <20130408204956.GH15749@google.com>
References: <51629766.6030805@gmail.com>
 <1365415866-16344-1-git-send-email-g2p.code+bcache@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1365415866-16344-1-git-send-email-g2p.code+bcache@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 08, 2013 at 12:11:06PM +0200, Gabriel wrote:
> Add a new superblock version, and consolidate related defines.

So, I think BDEV_WITH_OFFSET looks ok, but what's the use case for it? I
was going to add it way back but we decided not to implement the hack we
thought we needed it for - if you or someone is going to use it I'll go
ahead and apply it.
 
As for BCACHE_SB_VERSION_CDEV_WITH_UUID, can you explain why you added
that? I suspect it's needed but I can't remember why I didn't add it
when I added the new UUID format (or perhaps I just forgot)

> 
> Signed-off-by: Gabriel de Perthuis <g2p.code+bcache@gmail.com>
> ---
>  drivers/md/bcache/bcache.h  | 23 ++++++++++++++++++-----
>  drivers/md/bcache/request.c |  2 +-
>  drivers/md/bcache/super.c   | 21 ++++++++++++++++-----
>  3 files changed, 35 insertions(+), 11 deletions(-)
> 
> diff --git a/drivers/md/bcache/bcache.h b/drivers/md/bcache/bcache.h
> index f057235..8a110e6 100644
> --- a/drivers/md/bcache/bcache.h
> +++ b/drivers/md/bcache/bcache.h
> @@ -223,11 +223,17 @@ struct bkey {
>  #define BKEY_PADDED(key)					\
>  	union { struct bkey key; uint64_t key ## _pad[BKEY_PAD]; }
>  
> -/* Version 1: Backing device
> +/* Version 0: Cache device
> + * Version 1: Backing device
>   * Version 2: Seed pointer into btree node checksum
> - * Version 3: New UUID format
> + * Version 3: Cache device with new UUID format
> + * Version 4: Backing device with data offset
>   */
> -#define BCACHE_SB_VERSION	3
> +#define BCACHE_SB_VERSION_CDEV			0
> +#define BCACHE_SB_VERSION_BDEV			1
> +#define BCACHE_SB_VERSION_CDEV_WITH_UUID	3
> +#define BCACHE_SB_VERSION_BDEV_WITH_OFFSET	4
> +#define BCACHE_SB_MAX_VERSION			4
>  
>  #define SB_SECTOR		8
>  #define SB_SIZE			4096
> @@ -236,13 +242,12 @@ struct bkey {
>  /* SB_JOURNAL_BUCKETS must be divisible by BITS_PER_LONG */
>  #define MAX_CACHES_PER_SET	8
>  
> -#define BDEV_DATA_START		16	/* sectors */
> +#define BDEV_DATA_START_DEFAULT	16	/* sectors */
>  
>  struct cache_sb {
>  	uint64_t		csum;
>  	uint64_t		offset;	/* sector where this sb was written */
>  	uint64_t		version;
> -#define CACHE_BACKING_DEV	1
>  
>  	uint8_t			magic[16];
>  
> @@ -485,6 +490,7 @@ struct cached_dev {
>  	 * where it's at.
>  	 */
>  	sector_t		last_read;
> +	sector_t		data_start_sector;
>  
>  	/* Number of writeback bios in flight */
>  	atomic_t		in_flight;
> @@ -861,6 +867,13 @@ static inline bool key_merging_disabled(struct cache_set *c)
>  #endif
>  }
>  
> +
> +static inline bool SB_IS_BDEV(const struct cache_sb *sb) {
> +	return sb->version == BCACHE_SB_VERSION_BDEV
> +		|| sb->version == BCACHE_SB_VERSION_BDEV_WITH_OFFSET;
> +}
> +
> +
>  struct bbio {
>  	unsigned		submit_time_us;
>  	union {
> diff --git a/drivers/md/bcache/request.c b/drivers/md/bcache/request.c
> index 83731dc..9f74aff 100644
> --- a/drivers/md/bcache/request.c
> +++ b/drivers/md/bcache/request.c
> @@ -1220,7 +1220,7 @@ static void cached_dev_make_request(struct request_queue *q, struct bio *bio)
>  	part_stat_unlock();
>  
>  	bio->bi_bdev = dc->bdev;
> -	bio->bi_sector += BDEV_DATA_START;
> +	bio->bi_sector += dc->data_start_sector;
>  
>  	if (cached_dev_get(dc)) {
>  		s = search_alloc(bio, d);
> diff --git a/drivers/md/bcache/super.c b/drivers/md/bcache/super.c
> index 5fa3cd2..a409bb5 100644
> --- a/drivers/md/bcache/super.c
> +++ b/drivers/md/bcache/super.c
> @@ -148,7 +148,7 @@ static const char *read_super(struct cache_sb *sb, struct block_device *bdev,
>  		goto err;
>  
>  	err = "Unsupported superblock version";
> -	if (sb->version > BCACHE_SB_VERSION)
> +	if (sb->version > BCACHE_SB_MAX_VERSION)
>  		goto err;
>  
>  	err = "Bad block/bucket size";
> @@ -168,7 +168,7 @@ static const char *read_super(struct cache_sb *sb, struct block_device *bdev,
>  	if (get_capacity(bdev->bd_disk) < sb->bucket_size * sb->nbuckets)
>  		goto err;
>  
> -	if (sb->version == CACHE_BACKING_DEV)
> +	if (SB_IS_BDEV(sb))
>  		goto out;
>  
>  	err = "Bad UUID";
> @@ -286,7 +286,7 @@ void bcache_write_super(struct cache_set *c)
>  	for_each_cache(ca, c, i) {
>  		struct bio *bio = &ca->sb_bio;
>  
> -		ca->sb.version		= BCACHE_SB_VERSION;
> +		ca->sb.version		= BCACHE_SB_VERSION_CDEV_WITH_UUID;
>  		ca->sb.seq		= c->sb.seq;
>  		ca->sb.last_mount	= c->sb.last_mount;
>  
> @@ -1047,9 +1047,20 @@ static const char *register_bdev(struct cache_sb *sb, struct page *sb_page,
>  	dc->bdev = bdev;
>  	dc->bdev->bd_holder = dc;
>  
> +	err = "bad start sector";
> +	if (sb->version == BCACHE_SB_VERSION_BDEV) {
> +		dc->data_start_sector = BDEV_DATA_START_DEFAULT;
> +	} else {
> +		if (sb->keys < 1)
> +			goto err;
> +		dc->data_start_sector = sb->d[0];
> +		if (dc->data_start_sector < BDEV_DATA_START_DEFAULT)
> +			goto err;
> +	}
> +
>  	g = dc->disk.disk;
>  
> -	set_capacity(g, dc->bdev->bd_part->nr_sects - 16);
> +	set_capacity(g, dc->bdev->bd_part->nr_sects - dc->data_start_sector);
>  
>  	bch_cached_dev_request_init(dc);
>  
> @@ -1802,7 +1813,7 @@ static ssize_t register_bcache(struct kobject *k, struct kobj_attribute *attr,
>  	if (err)
>  		goto err_close;
>  
> -	if (sb->version == CACHE_BACKING_DEV) {
> +	if (SB_IS_BDEV(sb)) {
>  		struct cached_dev *dc = kzalloc(sizeof(*dc), GFP_KERNEL);
>  
>  		err = register_bdev(sb, sb_page, bdev, dc);
> -- 
> 1.8.2.rc3.7.g35aca0e
> 
