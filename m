Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934625AbaHZKVZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Aug 2014 06:21:25 -0400
Received: from cantor2.suse.de ([195.135.220.15]:40389 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932941AbaHZKVW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Aug 2014 06:21:22 -0400
Date: Tue, 26 Aug 2014 12:21:19 +0200
From: Jan Kara <jack@suse.cz>
To: Tejun Heo <tj@kernel.org>
Cc: linux-kernel@vger.kernel.org, cl@linux-foundation.org, x86@kernel.org,
        Jens Axboe <axboe@kernel.dk>, Jan Kara <jack@suse.cz>,
        "Theodore Ts'o" <tytso@mit.edu>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 1/3] percpu_counter: add @gfp to percpu_counter_init()
Message-ID: <20140826102119.GF1581@quack.suse.cz>
References: <1409013812-21700-1-git-send-email-tj@kernel.org>
 <1409013812-21700-2-git-send-email-tj@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1409013812-21700-2-git-send-email-tj@kernel.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon 25-08-14 20:43:30, Tejun Heo wrote:
> Percpu allocator now supports allocation mask.  Add @gfp to
> percpu_counter_init() so that !GFP_KERNEL allocation masks can be used
> with percpu_counters too.
> 
> We could have left percpu_counter_init() alone and added
> percpu_counter_init_gfp(); however, the number of users isn't that
> high and introducing _gfp variants to all percpu data structures would
> be quite ugly, so let's just do the conversion.  This is the one with
> the most users.  Other percpu data structures are a lot easier to
> convert.
> 
> This patch doesn't make any functional difference.
> 
> Signed-off-by: Tejun Heo <tj@kernel.org>
> Cc: x86@kernel.org
> Cc: Jens Axboe <axboe@kernel.dk>
> Cc: Jan Kara <jack@suse.cz>
> Cc: "Theodore Ts'o" <tytso@mit.edu>
> Cc: Alexander Viro <viro@zeniv.linux.org.uk>
> Cc: "David S. Miller" <davem@davemloft.net>
> Cc: Andrew Morton <akpm@linux-foundation.org>
  For the ext?, quota, lib, bdi parts:
Acked-by: Jan Kara <jack@suse.cz>

> ---
>  arch/x86/kvm/mmu.c             |  2 +-
>  fs/btrfs/disk-io.c             |  8 ++++----
>  fs/btrfs/extent-tree.c         |  2 +-
>  fs/ext2/super.c                |  6 +++---
>  fs/ext3/super.c                |  6 +++---
>  fs/ext4/super.c                | 14 +++++++++-----
>  fs/file_table.c                |  2 +-
>  fs/quota/dquot.c               |  2 +-
>  fs/super.c                     |  3 ++-
>  include/linux/percpu_counter.h | 10 ++++++----
>  include/net/dst_ops.h          |  2 +-
>  include/net/inet_frag.h        |  2 +-
>  lib/flex_proportions.c         |  4 ++--
>  lib/percpu_counter.c           |  4 ++--
>  lib/proportions.c              |  6 +++---
>  mm/backing-dev.c               |  2 +-
>  mm/mmap.c                      |  2 +-
>  mm/nommu.c                     |  2 +-
>  mm/shmem.c                     |  2 +-
>  net/dccp/proto.c               |  2 +-
>  net/ipv4/tcp.c                 |  4 ++--
>  net/ipv4/tcp_memcontrol.c      |  2 +-
>  net/sctp/protocol.c            |  2 +-
>  23 files changed, 49 insertions(+), 42 deletions(-)
> 
> diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
> index 9314678..5bd53f2 100644
> --- a/arch/x86/kvm/mmu.c
> +++ b/arch/x86/kvm/mmu.c
> @@ -4534,7 +4534,7 @@ int kvm_mmu_module_init(void)
>  	if (!mmu_page_header_cache)
>  		goto nomem;
>  
> -	if (percpu_counter_init(&kvm_total_used_mmu_pages, 0))
> +	if (percpu_counter_init(&kvm_total_used_mmu_pages, 0, GFP_KERNEL))
>  		goto nomem;
>  
>  	register_shrinker(&mmu_shrinker);
> diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
> index 08e65e9..61dae01 100644
> --- a/fs/btrfs/disk-io.c
> +++ b/fs/btrfs/disk-io.c
> @@ -1180,7 +1180,7 @@ static struct btrfs_subvolume_writers *btrfs_alloc_subvolume_writers(void)
>  	if (!writers)
>  		return ERR_PTR(-ENOMEM);
>  
> -	ret = percpu_counter_init(&writers->counter, 0);
> +	ret = percpu_counter_init(&writers->counter, 0, GFP_KERNEL);
>  	if (ret < 0) {
>  		kfree(writers);
>  		return ERR_PTR(ret);
> @@ -2185,7 +2185,7 @@ int open_ctree(struct super_block *sb,
>  		goto fail_srcu;
>  	}
>  
> -	ret = percpu_counter_init(&fs_info->dirty_metadata_bytes, 0);
> +	ret = percpu_counter_init(&fs_info->dirty_metadata_bytes, 0, GFP_KERNEL);
>  	if (ret) {
>  		err = ret;
>  		goto fail_bdi;
> @@ -2193,13 +2193,13 @@ int open_ctree(struct super_block *sb,
>  	fs_info->dirty_metadata_batch = PAGE_CACHE_SIZE *
>  					(1 + ilog2(nr_cpu_ids));
>  
> -	ret = percpu_counter_init(&fs_info->delalloc_bytes, 0);
> +	ret = percpu_counter_init(&fs_info->delalloc_bytes, 0, GFP_KERNEL);
>  	if (ret) {
>  		err = ret;
>  		goto fail_dirty_metadata_bytes;
>  	}
>  
> -	ret = percpu_counter_init(&fs_info->bio_counter, 0);
> +	ret = percpu_counter_init(&fs_info->bio_counter, 0, GFP_KERNEL);
>  	if (ret) {
>  		err = ret;
>  		goto fail_delalloc_bytes;
> diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
> index 813537f..94ec71e 100644
> --- a/fs/btrfs/extent-tree.c
> +++ b/fs/btrfs/extent-tree.c
> @@ -3493,7 +3493,7 @@ static int update_space_info(struct btrfs_fs_info *info, u64 flags,
>  	if (!found)
>  		return -ENOMEM;
>  
> -	ret = percpu_counter_init(&found->total_bytes_pinned, 0);
> +	ret = percpu_counter_init(&found->total_bytes_pinned, 0, GFP_KERNEL);
>  	if (ret) {
>  		kfree(found);
>  		return ret;
> diff --git a/fs/ext2/super.c b/fs/ext2/super.c
> index b88edc0..170dc41 100644
> --- a/fs/ext2/super.c
> +++ b/fs/ext2/super.c
> @@ -1067,14 +1067,14 @@ static int ext2_fill_super(struct super_block *sb, void *data, int silent)
>  	ext2_rsv_window_add(sb, &sbi->s_rsv_window_head);
>  
>  	err = percpu_counter_init(&sbi->s_freeblocks_counter,
> -				ext2_count_free_blocks(sb));
> +				ext2_count_free_blocks(sb), GFP_KERNEL);
>  	if (!err) {
>  		err = percpu_counter_init(&sbi->s_freeinodes_counter,
> -				ext2_count_free_inodes(sb));
> +				ext2_count_free_inodes(sb), GFP_KERNEL);
>  	}
>  	if (!err) {
>  		err = percpu_counter_init(&sbi->s_dirs_counter,
> -				ext2_count_dirs(sb));
> +				ext2_count_dirs(sb), GFP_KERNEL);
>  	}
>  	if (err) {
>  		ext2_msg(sb, KERN_ERR, "error: insufficient memory");
> diff --git a/fs/ext3/super.c b/fs/ext3/super.c
> index 08cdfe5..eba021b 100644
> --- a/fs/ext3/super.c
> +++ b/fs/ext3/super.c
> @@ -2039,14 +2039,14 @@ static int ext3_fill_super (struct super_block *sb, void *data, int silent)
>  		goto failed_mount2;
>  	}
>  	err = percpu_counter_init(&sbi->s_freeblocks_counter,
> -			ext3_count_free_blocks(sb));
> +			ext3_count_free_blocks(sb), GFP_KERNEL);
>  	if (!err) {
>  		err = percpu_counter_init(&sbi->s_freeinodes_counter,
> -				ext3_count_free_inodes(sb));
> +				ext3_count_free_inodes(sb), GFP_KERNEL);
>  	}
>  	if (!err) {
>  		err = percpu_counter_init(&sbi->s_dirs_counter,
> -				ext3_count_dirs(sb));
> +				ext3_count_dirs(sb), GFP_KERNEL);
>  	}
>  	if (err) {
>  		ext3_msg(sb, KERN_ERR, "error: insufficient memory");
> diff --git a/fs/ext4/super.c b/fs/ext4/super.c
> index 32b43ad..e25ca8f 100644
> --- a/fs/ext4/super.c
> +++ b/fs/ext4/super.c
> @@ -3891,7 +3891,8 @@ static int ext4_fill_super(struct super_block *sb, void *data, int silent)
>  	/* Register extent status tree shrinker */
>  	ext4_es_register_shrinker(sbi);
>  
> -	if ((err = percpu_counter_init(&sbi->s_extent_cache_cnt, 0)) != 0) {
> +	err = percpu_counter_init(&sbi->s_extent_cache_cnt, 0, GFP_KERNEL);
> +	if (err) {
>  		ext4_msg(sb, KERN_ERR, "insufficient memory");
>  		goto failed_mount3;
>  	}
> @@ -4105,17 +4106,20 @@ no_journal:
>  	block = ext4_count_free_clusters(sb);
>  	ext4_free_blocks_count_set(sbi->s_es, 
>  				   EXT4_C2B(sbi, block));
> -	err = percpu_counter_init(&sbi->s_freeclusters_counter, block);
> +	err = percpu_counter_init(&sbi->s_freeclusters_counter, block,
> +				  GFP_KERNEL);
>  	if (!err) {
>  		unsigned long freei = ext4_count_free_inodes(sb);
>  		sbi->s_es->s_free_inodes_count = cpu_to_le32(freei);
> -		err = percpu_counter_init(&sbi->s_freeinodes_counter, freei);
> +		err = percpu_counter_init(&sbi->s_freeinodes_counter, freei,
> +					  GFP_KERNEL);
>  	}
>  	if (!err)
>  		err = percpu_counter_init(&sbi->s_dirs_counter,
> -					  ext4_count_dirs(sb));
> +					  ext4_count_dirs(sb), GFP_KERNEL);
>  	if (!err)
> -		err = percpu_counter_init(&sbi->s_dirtyclusters_counter, 0);
> +		err = percpu_counter_init(&sbi->s_dirtyclusters_counter, 0,
> +					  GFP_KERNEL);
>  	if (err) {
>  		ext4_msg(sb, KERN_ERR, "insufficient memory");
>  		goto failed_mount6;
> diff --git a/fs/file_table.c b/fs/file_table.c
> index 385bfd3..0bab12b 100644
> --- a/fs/file_table.c
> +++ b/fs/file_table.c
> @@ -331,5 +331,5 @@ void __init files_init(unsigned long mempages)
>  
>  	n = (mempages * (PAGE_SIZE / 1024)) / 10;
>  	files_stat.max_files = max_t(unsigned long, n, NR_FILE);
> -	percpu_counter_init(&nr_files, 0);
> +	percpu_counter_init(&nr_files, 0, GFP_KERNEL);
>  } 
> diff --git a/fs/quota/dquot.c b/fs/quota/dquot.c
> index f2d0eee..8b663b2 100644
> --- a/fs/quota/dquot.c
> +++ b/fs/quota/dquot.c
> @@ -2725,7 +2725,7 @@ static int __init dquot_init(void)
>  		panic("Cannot create dquot hash table");
>  
>  	for (i = 0; i < _DQST_DQSTAT_LAST; i++) {
> -		ret = percpu_counter_init(&dqstats.counter[i], 0);
> +		ret = percpu_counter_init(&dqstats.counter[i], 0, GFP_KERNEL);
>  		if (ret)
>  			panic("Cannot create dquot stat counters");
>  	}
> diff --git a/fs/super.c b/fs/super.c
> index b9a214d..1b83610 100644
> --- a/fs/super.c
> +++ b/fs/super.c
> @@ -175,7 +175,8 @@ static struct super_block *alloc_super(struct file_system_type *type, int flags)
>  		goto fail;
>  
>  	for (i = 0; i < SB_FREEZE_LEVELS; i++) {
> -		if (percpu_counter_init(&s->s_writers.counter[i], 0) < 0)
> +		if (percpu_counter_init(&s->s_writers.counter[i], 0,
> +					GFP_KERNEL) < 0)
>  			goto fail;
>  		lockdep_init_map(&s->s_writers.lock_map[i], sb_writers_name[i],
>  				 &type->s_writers_key[i], 0);
> diff --git a/include/linux/percpu_counter.h b/include/linux/percpu_counter.h
> index d5dd465..50e5009 100644
> --- a/include/linux/percpu_counter.h
> +++ b/include/linux/percpu_counter.h
> @@ -12,6 +12,7 @@
>  #include <linux/threads.h>
>  #include <linux/percpu.h>
>  #include <linux/types.h>
> +#include <linux/gfp.h>
>  
>  #ifdef CONFIG_SMP
>  
> @@ -26,14 +27,14 @@ struct percpu_counter {
>  
>  extern int percpu_counter_batch;
>  
> -int __percpu_counter_init(struct percpu_counter *fbc, s64 amount,
> +int __percpu_counter_init(struct percpu_counter *fbc, s64 amount, gfp_t gfp,
>  			  struct lock_class_key *key);
>  
> -#define percpu_counter_init(fbc, value)					\
> +#define percpu_counter_init(fbc, value, gfp)				\
>  	({								\
>  		static struct lock_class_key __key;			\
>  									\
> -		__percpu_counter_init(fbc, value, &__key);		\
> +		__percpu_counter_init(fbc, value, gfp, &__key);		\
>  	})
>  
>  void percpu_counter_destroy(struct percpu_counter *fbc);
> @@ -89,7 +90,8 @@ struct percpu_counter {
>  	s64 count;
>  };
>  
> -static inline int percpu_counter_init(struct percpu_counter *fbc, s64 amount)
> +static inline int percpu_counter_init(struct percpu_counter *fbc, s64 amount,
> +				      gfp_t gfp)
>  {
>  	fbc->count = amount;
>  	return 0;
> diff --git a/include/net/dst_ops.h b/include/net/dst_ops.h
> index 2f26dfb..1f99a1d 100644
> --- a/include/net/dst_ops.h
> +++ b/include/net/dst_ops.h
> @@ -63,7 +63,7 @@ static inline void dst_entries_add(struct dst_ops *dst, int val)
>  
>  static inline int dst_entries_init(struct dst_ops *dst)
>  {
> -	return percpu_counter_init(&dst->pcpuc_entries, 0);
> +	return percpu_counter_init(&dst->pcpuc_entries, 0, GFP_KERNEL);
>  }
>  
>  static inline void dst_entries_destroy(struct dst_ops *dst)
> diff --git a/include/net/inet_frag.h b/include/net/inet_frag.h
> index 65a8855..8d17655 100644
> --- a/include/net/inet_frag.h
> +++ b/include/net/inet_frag.h
> @@ -151,7 +151,7 @@ static inline void add_frag_mem_limit(struct inet_frag_queue *q, int i)
>  
>  static inline void init_frag_mem_limit(struct netns_frags *nf)
>  {
> -	percpu_counter_init(&nf->mem, 0);
> +	percpu_counter_init(&nf->mem, 0, GFP_KERNEL);
>  }
>  
>  static inline unsigned int sum_frag_mem_limit(struct netns_frags *nf)
> diff --git a/lib/flex_proportions.c b/lib/flex_proportions.c
> index ebf3bac..b9d026b 100644
> --- a/lib/flex_proportions.c
> +++ b/lib/flex_proportions.c
> @@ -40,7 +40,7 @@ int fprop_global_init(struct fprop_global *p)
>  
>  	p->period = 0;
>  	/* Use 1 to avoid dealing with periods with 0 events... */
> -	err = percpu_counter_init(&p->events, 1);
> +	err = percpu_counter_init(&p->events, 1, GFP_KERNEL);
>  	if (err)
>  		return err;
>  	seqcount_init(&p->sequence);
> @@ -172,7 +172,7 @@ int fprop_local_init_percpu(struct fprop_local_percpu *pl)
>  {
>  	int err;
>  
> -	err = percpu_counter_init(&pl->events, 0);
> +	err = percpu_counter_init(&pl->events, 0, GFP_KERNEL);
>  	if (err)
>  		return err;
>  	pl->period = 0;
> diff --git a/lib/percpu_counter.c b/lib/percpu_counter.c
> index 7dd33577..1a28f0f 100644
> --- a/lib/percpu_counter.c
> +++ b/lib/percpu_counter.c
> @@ -112,13 +112,13 @@ s64 __percpu_counter_sum(struct percpu_counter *fbc)
>  }
>  EXPORT_SYMBOL(__percpu_counter_sum);
>  
> -int __percpu_counter_init(struct percpu_counter *fbc, s64 amount,
> +int __percpu_counter_init(struct percpu_counter *fbc, s64 amount, gfp_t gfp,
>  			  struct lock_class_key *key)
>  {
>  	raw_spin_lock_init(&fbc->lock);
>  	lockdep_set_class(&fbc->lock, key);
>  	fbc->count = amount;
> -	fbc->counters = alloc_percpu(s32);
> +	fbc->counters = alloc_percpu_gfp(s32, gfp);
>  	if (!fbc->counters)
>  		return -ENOMEM;
>  
> diff --git a/lib/proportions.c b/lib/proportions.c
> index 05df848..ca95f8d 100644
> --- a/lib/proportions.c
> +++ b/lib/proportions.c
> @@ -83,11 +83,11 @@ int prop_descriptor_init(struct prop_descriptor *pd, int shift)
>  	pd->index = 0;
>  	pd->pg[0].shift = shift;
>  	mutex_init(&pd->mutex);
> -	err = percpu_counter_init(&pd->pg[0].events, 0);
> +	err = percpu_counter_init(&pd->pg[0].events, 0, GFP_KERNEL);
>  	if (err)
>  		goto out;
>  
> -	err = percpu_counter_init(&pd->pg[1].events, 0);
> +	err = percpu_counter_init(&pd->pg[1].events, 0, GFP_KERNEL);
>  	if (err)
>  		percpu_counter_destroy(&pd->pg[0].events);
>  
> @@ -193,7 +193,7 @@ int prop_local_init_percpu(struct prop_local_percpu *pl)
>  	raw_spin_lock_init(&pl->lock);
>  	pl->shift = 0;
>  	pl->period = 0;
> -	return percpu_counter_init(&pl->events, 0);
> +	return percpu_counter_init(&pl->events, 0, GFP_KERNEL);
>  }
>  
>  void prop_local_destroy_percpu(struct prop_local_percpu *pl)
> diff --git a/mm/backing-dev.c b/mm/backing-dev.c
> index 1706cbb..f19a818 100644
> --- a/mm/backing-dev.c
> +++ b/mm/backing-dev.c
> @@ -455,7 +455,7 @@ int bdi_init(struct backing_dev_info *bdi)
>  	bdi_wb_init(&bdi->wb, bdi);
>  
>  	for (i = 0; i < NR_BDI_STAT_ITEMS; i++) {
> -		err = percpu_counter_init(&bdi->bdi_stat[i], 0);
> +		err = percpu_counter_init(&bdi->bdi_stat[i], 0, GFP_KERNEL);
>  		if (err)
>  			goto err;
>  	}
> diff --git a/mm/mmap.c b/mm/mmap.c
> index c1f2ea4..d7ec93e 100644
> --- a/mm/mmap.c
> +++ b/mm/mmap.c
> @@ -3196,7 +3196,7 @@ void __init mmap_init(void)
>  {
>  	int ret;
>  
> -	ret = percpu_counter_init(&vm_committed_as, 0);
> +	ret = percpu_counter_init(&vm_committed_as, 0, GFP_KERNEL);
>  	VM_BUG_ON(ret);
>  }
>  
> diff --git a/mm/nommu.c b/mm/nommu.c
> index a881d96..bd1808e 100644
> --- a/mm/nommu.c
> +++ b/mm/nommu.c
> @@ -539,7 +539,7 @@ void __init mmap_init(void)
>  {
>  	int ret;
>  
> -	ret = percpu_counter_init(&vm_committed_as, 0);
> +	ret = percpu_counter_init(&vm_committed_as, 0, GFP_KERNEL);
>  	VM_BUG_ON(ret);
>  	vm_region_jar = KMEM_CACHE(vm_region, SLAB_PANIC);
>  }
> diff --git a/mm/shmem.c b/mm/shmem.c
> index 0e5fb22..d4bc55d 100644
> --- a/mm/shmem.c
> +++ b/mm/shmem.c
> @@ -2993,7 +2993,7 @@ int shmem_fill_super(struct super_block *sb, void *data, int silent)
>  #endif
>  
>  	spin_lock_init(&sbinfo->stat_lock);
> -	if (percpu_counter_init(&sbinfo->used_blocks, 0))
> +	if (percpu_counter_init(&sbinfo->used_blocks, 0, GFP_KERNEL))
>  		goto failed;
>  	sbinfo->free_inodes = sbinfo->max_inodes;
>  
> diff --git a/net/dccp/proto.c b/net/dccp/proto.c
> index de2c1e7..e421edd 100644
> --- a/net/dccp/proto.c
> +++ b/net/dccp/proto.c
> @@ -1115,7 +1115,7 @@ static int __init dccp_init(void)
>  
>  	BUILD_BUG_ON(sizeof(struct dccp_skb_cb) >
>  		     FIELD_SIZEOF(struct sk_buff, cb));
> -	rc = percpu_counter_init(&dccp_orphan_count, 0);
> +	rc = percpu_counter_init(&dccp_orphan_count, 0, GFP_KERNEL);
>  	if (rc)
>  		goto out_fail;
>  	rc = -ENOBUFS;
> diff --git a/net/ipv4/tcp.c b/net/ipv4/tcp.c
> index 541f26a..d59c260 100644
> --- a/net/ipv4/tcp.c
> +++ b/net/ipv4/tcp.c
> @@ -3188,8 +3188,8 @@ void __init tcp_init(void)
>  
>  	BUILD_BUG_ON(sizeof(struct tcp_skb_cb) > sizeof(skb->cb));
>  
> -	percpu_counter_init(&tcp_sockets_allocated, 0);
> -	percpu_counter_init(&tcp_orphan_count, 0);
> +	percpu_counter_init(&tcp_sockets_allocated, 0, GFP_KERNEL);
> +	percpu_counter_init(&tcp_orphan_count, 0, GFP_KERNEL);
>  	tcp_hashinfo.bind_bucket_cachep =
>  		kmem_cache_create("tcp_bind_bucket",
>  				  sizeof(struct inet_bind_bucket), 0,
> diff --git a/net/ipv4/tcp_memcontrol.c b/net/ipv4/tcp_memcontrol.c
> index 3af5226..1d19135 100644
> --- a/net/ipv4/tcp_memcontrol.c
> +++ b/net/ipv4/tcp_memcontrol.c
> @@ -32,7 +32,7 @@ int tcp_init_cgroup(struct mem_cgroup *memcg, struct cgroup_subsys *ss)
>  		res_parent = &parent_cg->memory_allocated;
>  
>  	res_counter_init(&cg_proto->memory_allocated, res_parent);
> -	percpu_counter_init(&cg_proto->sockets_allocated, 0);
> +	percpu_counter_init(&cg_proto->sockets_allocated, 0, GFP_KERNEL);
>  
>  	return 0;
>  }
> diff --git a/net/sctp/protocol.c b/net/sctp/protocol.c
> index 6240834..f00a85a 100644
> --- a/net/sctp/protocol.c
> +++ b/net/sctp/protocol.c
> @@ -1341,7 +1341,7 @@ static __init int sctp_init(void)
>  	if (!sctp_chunk_cachep)
>  		goto err_chunk_cachep;
>  
> -	status = percpu_counter_init(&sctp_sockets_allocated, 0);
> +	status = percpu_counter_init(&sctp_sockets_allocated, 0, GFP_KERNEL);
>  	if (status)
>  		goto err_percpu_counter_init;
>  
> -- 
> 1.9.3
> 
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
