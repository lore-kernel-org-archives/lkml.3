Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751391Ab3HTVW2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Aug 2013 17:22:28 -0400
Received: from mx1.redhat.com ([209.132.183.28]:31368 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750987Ab3HTVW0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Aug 2013 17:22:26 -0400
Date: Tue, 20 Aug 2013 17:22:20 -0400 (EDT)
From: Mikulas Patocka <mpatocka@redhat.com>
X-X-Sender: mpatocka@file01.intranet.prod.int.rdu2.redhat.com
To: device-mapper development <dm-devel@redhat.com>
cc: linux-kernel@vger.kernel.org, Frank Mayhar <fmayhar@google.com>,
        Mike Snitzer <msnitzer@redhat.com>
Subject: Re: [dm-devel] [PATCH] dm: Make MIN_IOS, et al, tunable via
 sysctl.
In-Reply-To: <1376070533.26057.244.camel@bobble.lax.corp.google.com>
Message-ID: <alpine.LRH.2.02.1308201712090.8826@file01.intranet.prod.int.rdu2.redhat.com>
References: <1376070533.26057.244.camel@bobble.lax.corp.google.com>
User-Agent: Alpine 2.02 (LRH 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Fri, 16 Aug 2013, Frank Mayhar wrote:

> The device mapper and some of its modules allocate memory pools at
> various points when setting up a device.  In some cases, these pools are
> fairly large, for example the multipath module allocates a 256-entry
> pool and the dm itself allocates three of that size.  In a
> memory-constrained environment where we're creating a lot of these
> devices, the memory use can quickly become significant.  Unfortunately,
> there's currently no way to change the size of the pools other than by
> changing a constant and rebuilding the kernel.
> 
> This patch fixes that by changing the hardcoded MIN_IOS (and certain
> other) #defines in dm-crypt, dm-io, dm-mpath, dm-snap and dm itself to
> sysctl-modifiable values.  This lets us change the size of these pools
> on the fly, we can reduce the size of the pools and reduce memory
> pressure.
> 
> We tested performance of dm-mpath with smaller MIN_IOS sizes for both dm
> and dm-mpath, from a value of 32 all the way down to zero.  Bearing in
> mind that the underlying devices were network-based, we saw essentially
> no performance degradation; if there was any, it was down in the noise.
> One might wonder why these sizes are the way they are; I investigated
> and they've been unchanged since at least 2006.

I think it would be better to set the values to some low value (1 should 
be enough, there is 16 in some places that is already low enough). There 
is no need to make it user-configurable, because the user will see no 
additional benefit from bigger mempools.

Maybe multipath is the exception - but other dm targets don't really need 
big mempools so there is no need to make the size configurable.

Mikulas

> Signed-off-by: Frank Mayhar <fmayhar@google.com>
> --- 
>  drivers/md/dm-crypt.c | 63 +++++++++++++++++++++++++++++++++++++++++++++++----
>  drivers/md/dm-io.c    | 58 +++++++++++++++++++++++++++++++++++++++++++++--
>  drivers/md/dm-mpath.c | 48 ++++++++++++++++++++++++++++++++++++++-
>  drivers/md/dm-snap.c  | 45 +++++++++++++++++++++++++++++++++++-
>  drivers/md/dm.c       | 41 ++++++++++++++++++++++++++++++---
>  5 files changed, 244 insertions(+), 11 deletions(-)
> diff --git a/drivers/md/dm-crypt.c b/drivers/md/dm-crypt.c
> index 6d2d41a..d68f10a 100644
> --- a/drivers/md/dm-crypt.c
> +++ b/drivers/md/dm-crypt.c
> @@ -178,12 +178,55 @@ struct crypt_config {
>  #define MIN_IOS        16
>  #define MIN_POOL_PAGES 32
>  
> +static int sysctl_dm_crypt_min_ios = MIN_IOS;
> +static int sysctl_dm_crypt_min_pool_pages = MIN_POOL_PAGES;
> +
>  static struct kmem_cache *_crypt_io_pool;
>  
>  static void clone_init(struct dm_crypt_io *, struct bio *);
>  static void kcryptd_queue_crypt(struct dm_crypt_io *io);
>  static u8 *iv_of_dmreq(struct crypt_config *cc, struct dm_crypt_request *dmreq);
>  
> +static struct ctl_table_header *dm_crypt_table_header;
> +static ctl_table dm_crypt_ctl_table[] = {
> +	{
> +		.procname	= "min_ios",
> +		.data		= &sysctl_dm_crypt_min_ios,
> +		.maxlen		= sizeof(int),
> +		.mode		= S_IRUGO|S_IWUSR,
> +		.proc_handler	= proc_dointvec,
> +	},
> +	{
> +		.procname	= "min_pool_pages",
> +		.data		= &sysctl_dm_crypt_min_pool_pages,
> +		.maxlen		= sizeof(int),
> +		.mode		= S_IRUGO|S_IWUSR,
> +		.proc_handler	= proc_dointvec,
> +	},
> +	{ }
> +};
> +
> +static ctl_table dm_crypt_dir_table[] = {
> +	{ .procname	= "crypt",
> +	  .mode		= 0555,
> +	  .child	= dm_crypt_ctl_table },
> +	{ }
> +};
> +
> +static ctl_table dm_crypt_dm_dir_table[] = {
> +	{ .procname	= "dm",
> +	  .mode		= 0555,
> +	  .child	= dm_crypt_dir_table },
> +	{ }
> +};
> +
> +static ctl_table dm_crypt_root_table[] = {
> +	{ .procname	= "dev",
> +	  .mode		= 0555,
> +	  .child	= dm_crypt_dm_dir_table },
> +	{ }
> +};
> +
>  static struct crypt_cpu *this_crypt_config(struct crypt_config *cc)
>  {
>  	return this_cpu_ptr(cc->cpu);
> @@ -1571,7 +1614,8 @@ static int crypt_ctr(struct dm_target *ti, unsigned int argc, char **argv)
>  		goto bad;
>  
>  	ret = -ENOMEM;
> -	cc->io_pool = mempool_create_slab_pool(MIN_IOS, _crypt_io_pool);
> +	cc->io_pool = mempool_create_slab_pool(sysctl_dm_crypt_min_ios,
> +					       _crypt_io_pool);
>  	if (!cc->io_pool) {
>  		ti->error = "Cannot allocate crypt io mempool";
>  		goto bad;
> @@ -1583,20 +1627,22 @@ static int crypt_ctr(struct dm_target *ti, unsigned int argc, char **argv)
>  	cc->dmreq_start += crypto_ablkcipher_alignmask(any_tfm(cc)) &
>  			   ~(crypto_tfm_ctx_alignment() - 1);
>  
> -	cc->req_pool = mempool_create_kmalloc_pool(MIN_IOS, cc->dmreq_start +
> +	cc->req_pool = mempool_create_kmalloc_pool(sysctl_dm_crypt_min_ios,
> +			cc->dmreq_start +
>  			sizeof(struct dm_crypt_request) + cc->iv_size);
>  	if (!cc->req_pool) {
>  		ti->error = "Cannot allocate crypt request mempool";
>  		goto bad;
>  	}
>  
> -	cc->page_pool = mempool_create_page_pool(MIN_POOL_PAGES, 0);
> +	cc->page_pool = mempool_create_page_pool(sysctl_dm_crypt_min_pool_pages,
> +						 0);
>  	if (!cc->page_pool) {
>  		ti->error = "Cannot allocate page mempool";
>  		goto bad;
>  	}
>  
> -	cc->bs = bioset_create(MIN_IOS, 0);
> +	cc->bs = bioset_create(sysctl_dm_crypt_min_ios, 0);
>  	if (!cc->bs) {
>  		ti->error = "Cannot allocate crypt bioset";
>  		goto bad;
> @@ -1851,11 +1897,20 @@ static int __init dm_crypt_init(void)
>  		kmem_cache_destroy(_crypt_io_pool);
>  	}
>  
> +	dm_crypt_table_header = register_sysctl_table(dm_crypt_root_table);
> +	if (!dm_crypt_table_header) {
> +		DMERR("failed to register sysctl");
> +		dm_unregister_target(&crypt_target);
> +		kmem_cache_destroy(_crypt_io_pool);
> +		return -ENOMEM;
> +	}
> +
>  	return r;
>  }
>  
>  static void __exit dm_crypt_exit(void)
>  {
> +	unregister_sysctl_table(dm_crypt_table_header);
>  	dm_unregister_target(&crypt_target);
>  	kmem_cache_destroy(_crypt_io_pool);
>  }
> diff --git a/drivers/md/dm-io.c b/drivers/md/dm-io.c
> index ea49834..8c45c60 100644
> --- a/drivers/md/dm-io.c
> +++ b/drivers/md/dm-io.c
> @@ -22,6 +22,9 @@
>  #define MIN_IOS		16
>  #define MIN_BIOS	16
>  
> +static int sysctl_dm_io_min_ios = MIN_IOS;
> +static int sysctl_dm_io_min_bios = MIN_BIOS;
> +
>  struct dm_io_client {
>  	mempool_t *pool;
>  	struct bio_set *bios;
> @@ -44,6 +47,46 @@ struct io {
>  
>  static struct kmem_cache *_dm_io_cache;
>  
> +static struct ctl_table_header *dm_io_table_header;
> +static ctl_table dm_io_ctl_table[] = {
> +	{
> +		.procname	= "min_ios",
> +		.data		= &sysctl_dm_io_min_ios,
> +		.maxlen		= sizeof(int),
> +		.mode		= S_IRUGO|S_IWUSR,
> +		.proc_handler	= proc_dointvec,
> +	},
> +	{
> +		.procname	= "min_bios",
> +		.data		= &sysctl_dm_io_min_bios,
> +		.maxlen		= sizeof(int),
> +		.mode		= S_IRUGO|S_IWUSR,
> +		.proc_handler	= proc_dointvec,
> +	},
> +	{ }
> +};
> +
> +static ctl_table dm_io_dir_table[] = {
> +	{ .procname	= "io",
> +	  .mode		= 0555,
> +	  .child	= dm_io_ctl_table },
> +	{ }
> +};
> +
> +static ctl_table dm_io_dm_dir_table[] = {
> +	{ .procname	= "dm",
> +	  .mode		= 0555,
> +	  .child	= dm_io_dir_table },
> +	{ }
> +};
> +
> +static ctl_table dm_io_root_table[] = {
> +	{ .procname	= "dev",
> +	  .mode		= 0555,
> +	  .child	= dm_io_dm_dir_table },
> +	{ }
> +};
> +
>  /*
>   * Create a client with mempool and bioset.
>   */
> @@ -55,11 +98,12 @@ struct dm_io_client *dm_io_client_create(void)
>  	if (!client)
>  		return ERR_PTR(-ENOMEM);
>  
> -	client->pool = mempool_create_slab_pool(MIN_IOS, _dm_io_cache);
> +	client->pool = mempool_create_slab_pool(sysctl_dm_io_min_ios,
> +						_dm_io_cache);
>  	if (!client->pool)
>  		goto bad;
>  
> -	client->bios = bioset_create(MIN_BIOS, 0);
> +	client->bios = bioset_create(sysctl_dm_io_min_bios, 0);
>  	if (!client->bios)
>  		goto bad;
>  
> @@ -515,11 +559,21 @@ int __init dm_io_init(void)
>  	if (!_dm_io_cache)
>  		return -ENOMEM;
>  
> +	dm_io_table_header = register_sysctl_table(dm_io_root_table);
> +	if (!dm_io_table_header) {
> +		DMERR("failed to register sysctl");
> +		kmem_cache_destroy(_dm_io_cache);
> +		_dm_io_cache = NULL;
> +		return -ENOMEM;
> +	}
> +
> +
>  	return 0;
>  }
>  
>  void dm_io_exit(void)
>  {
> +	unregister_sysctl_table(dm_io_table_header);
>  	kmem_cache_destroy(_dm_io_cache);
>  	_dm_io_cache = NULL;
>  }
> diff --git a/drivers/md/dm-mpath.c b/drivers/md/dm-mpath.c
> index 5adede1..099af1b 100644
> --- a/drivers/md/dm-mpath.c
> +++ b/drivers/md/dm-mpath.c
> @@ -118,6 +118,8 @@ typedef int (*action_fn) (struct pgpath *pgpath);
>  
>  #define MIN_IOS 256	/* Mempool size */
>  
> +static int sysctl_dm_mpath_min_ios = MIN_IOS;
> +
>  static struct kmem_cache *_mpio_cache;
>  
>  static struct workqueue_struct *kmultipathd, *kmpath_handlerd;
> @@ -125,6 +127,38 @@ static void process_queued_ios(struct work_struct *work);
>  static void trigger_event(struct work_struct *work);
>  static void activate_path(struct work_struct *work);
>  
> +static struct ctl_table_header *dm_mpath_table_header;
> +static ctl_table dm_mpath_ctl_table[] = {
> +	{
> +		.procname	= "min_ios",
> +		.data		= &sysctl_dm_mpath_min_ios,
> +		.maxlen		= sizeof(int),
> +		.mode		= S_IRUGO|S_IWUSR,
> +		.proc_handler	= proc_dointvec,
> +	},
> +	{ }
> +};
> +
> +static ctl_table dm_mpath_dir_table[] = {
> +	{ .procname	= "mpath",
> +	  .mode		= 0555,
> +	  .child	= dm_mpath_ctl_table },
> +	{ }
> +};
> +
> +static ctl_table dm_mpath_dm_dir_table[] = {
> +	{ .procname	= "dm",
> +	  .mode		= 0555,
> +	  .child	= dm_mpath_dir_table },
> +	{ }
> +};
> +
> +static ctl_table dm_mpath_root_table[] = {
> +	{ .procname	= "dev",
> +	  .mode		= 0555,
> +	  .child	= dm_mpath_dm_dir_table },
> +	{ }
> +};
>  
>  /*-----------------------------------------------
>   * Allocation routines
> @@ -202,7 +236,8 @@ static struct multipath *alloc_multipath(struct dm_target *ti)
>  		INIT_WORK(&m->trigger_event, trigger_event);
>  		init_waitqueue_head(&m->pg_init_wait);
>  		mutex_init(&m->work_mutex);
> -		m->mpio_pool = mempool_create_slab_pool(MIN_IOS, _mpio_cache);
> +		m->mpio_pool = mempool_create_slab_pool(sysctl_dm_mpath_min_ios,
> +							_mpio_cache);
>  		if (!m->mpio_pool) {
>  			kfree(m);
>  			return NULL;
> @@ -1745,6 +1780,15 @@ static int __init dm_multipath_init(void)
>  		kmem_cache_destroy(_mpio_cache);
>  		return -ENOMEM;
>  	}
> +	dm_mpath_table_header = register_sysctl_table(dm_mpath_root_table);
> +	if (!dm_mpath_table_header) {
> +		DMERR("failed to register sysctl");
> +		destroy_workqueue(kmpath_handlerd);
> +		destroy_workqueue(kmultipathd);
> +		dm_unregister_target(&multipath_target);
> +		kmem_cache_destroy(_mpio_cache);
> +		return -ENOMEM;
> +	}
>  
>  	DMINFO("version %u.%u.%u loaded",
>  	       multipath_target.version[0], multipath_target.version[1],
> @@ -1755,6 +1799,8 @@ static int __init dm_multipath_init(void)
>  
>  static void __exit dm_multipath_exit(void)
>  {
> +	unregister_sysctl_table(dm_mpath_table_header);
> +
>  	destroy_workqueue(kmpath_handlerd);
>  	destroy_workqueue(kmultipathd);
>  
> diff --git a/drivers/md/dm-snap.c b/drivers/md/dm-snap.c
> index c434e5a..723b3c2 100644
> --- a/drivers/md/dm-snap.c
> +++ b/drivers/md/dm-snap.c
> @@ -33,11 +33,45 @@ static const char dm_snapshot_merge_target_name[] = "snapshot-merge";
>   * The size of the mempool used to track chunks in use.
>   */
>  #define MIN_IOS 256
> +static int sysctl_dm_snap_min_ios = MIN_IOS;
>  
>  #define DM_TRACKED_CHUNK_HASH_SIZE	16
>  #define DM_TRACKED_CHUNK_HASH(x)	((unsigned long)(x) & \
>  					 (DM_TRACKED_CHUNK_HASH_SIZE - 1))
>  
> +static struct ctl_table_header *dm_snap_table_header;
> +static ctl_table dm_snap_ctl_table[] = {
> +	{
> +		.procname	= "min_ios",
> +		.data		= &sysctl_dm_snap_min_ios,
> +		.maxlen		= sizeof(int),
> +		.mode		= S_IRUGO|S_IWUSR,
> +		.proc_handler	= proc_dointvec,
> +	},
> +	{ }
> +};
> +
> +static ctl_table dm_snap_dir_table[] = {
> +	{ .procname	= "snap",
> +	  .mode		= 0555,
> +	  .child	= dm_snap_ctl_table },
> +	{ }
> +};
> +
> +static ctl_table dm_snap_dm_dir_table[] = {
> +	{ .procname	= "dm",
> +	  .mode		= 0555,
> +	  .child	= dm_snap_dir_table },
> +	{ }
> +};
> +
> +static ctl_table dm_snap_root_table[] = {
> +	{ .procname	= "dev",
> +	  .mode		= 0555,
> +	  .child	= dm_snap_dm_dir_table },
> +	{ }
> +};
> +
>  struct dm_exception_table {
>  	uint32_t hash_mask;
>  	unsigned hash_shift;
> @@ -1118,7 +1152,8 @@ static int snapshot_ctr(struct dm_target *ti, unsigned int argc, char **argv)
>  		goto bad_kcopyd;
>  	}
>  
> -	s->pending_pool = mempool_create_slab_pool(MIN_IOS, pending_cache);
> +	s->pending_pool = mempool_create_slab_pool(sysctl_dm_snap_min_ios,
> +											   pending_cache);
>  	if (!s->pending_pool) {
>  		ti->error = "Could not allocate mempool for pending exceptions";
>  		r = -ENOMEM;
> @@ -2268,8 +2303,14 @@ static int __init dm_snapshot_init(void)
>  		goto bad_pending_cache;
>  	}
>  
> +	dm_snap_table_header = register_sysctl_table(dm_snap_root_table);
> +	if (!dm_snap_table_header)
> +		goto bad_sysctl_table;
> +
>  	return 0;
>  
> +bad_sysctl_table:
> +	kmem_cache_destroy(pending_cache);
>  bad_pending_cache:
>  	kmem_cache_destroy(exception_cache);
>  bad_exception_cache:
> @@ -2288,6 +2329,8 @@ bad_register_snapshot_target:
>  
>  static void __exit dm_snapshot_exit(void)
>  {
> +	unregister_sysctl_table(dm_snap_table_header);
> +
>  	dm_unregister_target(&snapshot_target);
>  	dm_unregister_target(&origin_target);
>  	dm_unregister_target(&merge_target);
> diff --git a/drivers/md/dm.c b/drivers/md/dm.c
> index 9e39d2b..fdff32f 100644
> --- a/drivers/md/dm.c
> +++ b/drivers/md/dm.c
> @@ -19,6 +19,7 @@
>  #include <linux/idr.h>
>  #include <linux/hdreg.h>
>  #include <linux/delay.h>
> +#include <linux/sysctl.h>
>  
>  #include <trace/events/block.h>
>  
> @@ -209,9 +210,36 @@ struct dm_md_mempools {
>  };
>  
>  #define MIN_IOS 256
> +static int sysctl_dm_min_ios = MIN_IOS;
>  static struct kmem_cache *_io_cache;
>  static struct kmem_cache *_rq_tio_cache;
>  
> +static struct ctl_table_header *dm_table_header;
> +static ctl_table dm_ctl_table[] = {
> +	{
> +		.procname	= "min_ios",
> +		.data		= &sysctl_dm_min_ios,
> +		.maxlen		= sizeof(int),
> +		.mode		= S_IRUGO|S_IWUSR,
> +		.proc_handler	= proc_dointvec,
> +	},
> +	{ }
> +};
> +
> +static ctl_table dm_dir_table[] = {
> +	{ .procname	= "dm",
> +	  .mode		= 0555,
> +	  .child	= dm_ctl_table },
> +	{ }
> +};
> +
> +static ctl_table dm_root_table[] = {
> +	{ .procname	= "dev",
> +	  .mode		= 0555,
> +	  .child	= dm_dir_table },
> +	{ }
> +};
> +
>  static int __init local_init(void)
>  {
>  	int r = -ENOMEM;
> @@ -229,16 +257,22 @@ static int __init local_init(void)
>  	if (r)
>  		goto out_free_rq_tio_cache;
>  
> +	dm_table_header = register_sysctl_table(dm_root_table);
> +	if (!dm_table_header)
> +		goto out_uevent_exit;
> +
>  	_major = major;
>  	r = register_blkdev(_major, _name);
>  	if (r < 0)
> -		goto out_uevent_exit;
> +		goto out_unregister_sysctl_table;
>  
>  	if (!_major)
>  		_major = r;
>  
>  	return 0;
>  
> +out_unregister_sysctl_table:
> +	unregister_sysctl_table(dm_table_header);
>  out_uevent_exit:
>  	dm_uevent_exit();
>  out_free_rq_tio_cache:
> @@ -251,6 +285,7 @@ out_free_io_cache:
>  
>  static void local_exit(void)
>  {
> +	unregister_sysctl_table(dm_table_header);
>  	kmem_cache_destroy(_rq_tio_cache);
>  	kmem_cache_destroy(_io_cache);
>  	unregister_blkdev(_major, _name);
> @@ -2806,14 +2841,14 @@ struct dm_md_mempools *dm_alloc_md_mempools(unsigned type, unsigned integrity, u
>  		front_pad = roundup(per_bio_data_size, __alignof__(struct dm_target_io)) + offsetof(struct dm_target_io, clone);
>  	} else if (type == DM_TYPE_REQUEST_BASED) {
>  		cachep = _rq_tio_cache;
> -		pool_size = MIN_IOS;
> +		pool_size = sysctl_dm_min_ios;
>  		front_pad = offsetof(struct dm_rq_clone_bio_info, clone);
>  		/* per_bio_data_size is not used. See __bind_mempools(). */
>  		WARN_ON(per_bio_data_size != 0);
>  	} else
>  		goto out;
>  
> -	pools->io_pool = mempool_create_slab_pool(MIN_IOS, cachep);
> +	pools->io_pool = mempool_create_slab_pool(sysctl_dm_min_ios, cachep);
>  	if (!pools->io_pool)
>  		goto out;
>  
> 
> -- 
> Frank Mayhar
> 310-460-4042
> 
> 
> --
> dm-devel mailing list
> dm-devel@redhat.com
> https://www.redhat.com/mailman/listinfo/dm-devel
> 
