Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934104Ab3FSHyc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Jun 2013 03:54:32 -0400
Received: from [205.204.113.250] ([205.204.113.250]:43489 "HELO
	us-alimail-mta2.hst.scl.en.alidc.net." rhost-flags-FAIL-FAIL-FAIL-FAIL)
	by vger.kernel.org with SMTP id S933966Ab3FSHya convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Jun 2013 03:54:30 -0400
X-Greylist: delayed 313 seconds by postgrey-1.27 at vger.kernel.org; Wed, 19 Jun 2013 03:54:30 EDT
Content-Type: text/plain; charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 6.5 \(1508\))
Subject: Re: linux-next: manual merge of the akpm tree with the ext4 tree
From: Zheng Liu <wenqing.lz@alibaba-inc.com>
In-Reply-To: <20130619172721.00e757acd76e1f9d362f59be@canb.auug.org.au>
Date: Wed, 19 Jun 2013 15:48:55 +0800
Cc: Andrew Morton <akpm@linux-foundation.org>, <linux-next@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, Zheng Liu <wenqing.lz@taobao.com>,
        "Theodore Ts'o" <tytso@mit.edu>, Dave Chinner <dchinner@redhat.com>,
        Glauber Costa <glommer@openvz.org>
Content-Transfer-Encoding: 8BIT
Message-Id: <8D4D4FB6-88E9-4407-8A16-C1C28F38592B@alibaba-inc.com>
References: <20130619172721.00e757acd76e1f9d362f59be@canb.auug.org.au>
To: Stephen Rothwell <sfr@canb.auug.org.au>
X-Mailer: Apple Mail (2.1508)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Stephen,

On Jun 19, 2013, at 3:27 PM, Stephen Rothwell <sfr@canb.auug.org.au> wrote:

> Hi Andrew,
> 
> Today's linux-next merge of the akpm tree got a conflict in
> fs/ext4/extents_status.c between commit 6480bad916be ("ext4: improve
> extent cache shrink mechanism to avoid to burn CPU time") from the ext
> tree and commit 1f42d0934b4e ("fs: convert fs shrinkers to new scan/count
> API") from the akpm tree.
> 
> I fixed it up (I am not sure if the result makes complete sense - see
> below) and can carry the fix as necessary (no action is required).

The patch looks good to me.  Thanks for fixing it.

Regards,
						- Zheng

> 
> -- 
> Cheers,
> Stephen Rothwell                    sfr@canb.auug.org.au
> 
> diff --cc fs/ext4/extents_status.c
> index 80dcc59,4bce4f0..0000000
> --- a/fs/ext4/extents_status.c
> +++ b/fs/ext4/extents_status.c
> @@@ -876,58 -878,32 +876,63 @@@ int ext4_es_zeroout(struct inode *inode
>  				     EXTENT_STATUS_WRITTEN);
>  }
> 
> +static int ext4_inode_touch_time_cmp(void *priv, struct list_head *a,
> +				     struct list_head *b)
> +{
> +	struct ext4_inode_info *eia, *eib;
> +	unsigned long diff;
> +
> +	eia = list_entry(a, struct ext4_inode_info, i_es_lru);
> +	eib = list_entry(b, struct ext4_inode_info, i_es_lru);
> +
> +	diff = eia->i_touch_when - eib->i_touch_when;
> +	if (diff < 0)
> +		return -1;
> +	if (diff > 0)
> +		return 1;
> +	return 0;
> +}
> 
> - static int ext4_es_shrink(struct shrinker *shrink, struct shrink_control *sc)
> + static long ext4_es_count(struct shrinker *shrink, struct shrink_control *sc)
> + {
> + 	long nr;
> + 	struct ext4_sb_info *sbi = container_of(shrink,
> + 					struct ext4_sb_info, s_es_shrinker);
> + 
> + 	nr = percpu_counter_read_positive(&sbi->s_extent_cache_cnt);
> + 	trace_ext4_es_shrink_enter(sbi->s_sb, sc->nr_to_scan, nr);
> + 	return nr;
> + }
> + 
> + static long ext4_es_scan(struct shrinker *shrink, struct shrink_control *sc)
>  {
>  	struct ext4_sb_info *sbi = container_of(shrink,
>  					struct ext4_sb_info, s_es_shrinker);
>  	struct ext4_inode_info *ei;
> -	struct list_head *cur, *tmp, scanned;
> +	struct list_head *cur, *tmp;
> +	LIST_HEAD(skiped);
>  	int nr_to_scan = sc->nr_to_scan;
> - 	int ret, nr_shrunk = 0;
> - 
> - 	ret = percpu_counter_read_positive(&sbi->s_extent_cache_cnt);
> - 	trace_ext4_es_shrink_enter(sbi->s_sb, nr_to_scan, ret);
> - 
> - 	if (!nr_to_scan)
> - 		return ret;
> + 	int ret = 0, nr_shrunk = 0;
> 
> -	INIT_LIST_HEAD(&scanned);
> -
>  	spin_lock(&sbi->s_es_lru_lock);
> +
> +	/*
> +	 * If the inode that is at the head of LRU list is newer than
> +	 * last_sorted time, that means that we need to sort this list.
> +	 */
> +	ei = list_first_entry(&sbi->s_es_lru, struct ext4_inode_info, i_es_lru);
> +	if (sbi->s_es_last_sorted < ei->i_touch_when) {
> +		list_sort(NULL, &sbi->s_es_lru, ext4_inode_touch_time_cmp);
> +		sbi->s_es_last_sorted = jiffies;
> +	}
> +
>  	list_for_each_safe(cur, tmp, &sbi->s_es_lru) {
> -		list_move_tail(cur, &scanned);
> +		/*
> +		 * If we have already reclaimed all extents from extent
> +		 * status tree, just stop the loop immediately.
> +		 */
> +		if (percpu_counter_read_positive(&sbi->s_extent_cache_cnt) == 0)
> +			break;
> 
>  		ei = list_entry(cur, struct ext4_inode_info, i_es_lru);
> 
> @@@ -951,22 -923,22 +956,22 @@@
>  		if (nr_to_scan == 0)
>  			break;
>  	}
> -	list_splice_tail(&scanned, &sbi->s_es_lru);
> +
> +	/* Move the newer inodes into the tail of the LRU list. */
> +	list_splice_tail(&skiped, &sbi->s_es_lru);
>  	spin_unlock(&sbi->s_es_lru_lock);
> 
> - 	ret = percpu_counter_read_positive(&sbi->s_extent_cache_cnt);
>  	trace_ext4_es_shrink_exit(sbi->s_sb, nr_shrunk, ret);
> - 	return ret;
> + 	return nr_shrunk;
>  }
> 
> -void ext4_es_register_shrinker(struct super_block *sb)
> +void ext4_es_register_shrinker(struct ext4_sb_info *sbi)
>  {
> -	struct ext4_sb_info *sbi;
> -
> -	sbi = EXT4_SB(sb);
>  	INIT_LIST_HEAD(&sbi->s_es_lru);
>  	spin_lock_init(&sbi->s_es_lru_lock);
> +	sbi->s_es_last_sorted = 0;
> - 	sbi->s_es_shrinker.shrink = ext4_es_shrink;
> + 	sbi->s_es_shrinker.scan_objects = ext4_es_scan;
> + 	sbi->s_es_shrinker.count_objects = ext4_es_count;
>  	sbi->s_es_shrinker.seeks = DEFAULT_SEEKS;
>  	register_shrinker(&sbi->s_es_shrinker);
>  }

