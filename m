Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934459AbaHZKTe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Aug 2014 06:19:34 -0400
Received: from cantor2.suse.de ([195.135.220.15]:40361 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754236AbaHZKTd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Aug 2014 06:19:33 -0400
Date: Tue, 26 Aug 2014 12:19:29 +0200
From: Jan Kara <jack@suse.cz>
To: Tejun Heo <tj@kernel.org>
Cc: linux-kernel@vger.kernel.org, cl@linux-foundation.org,
        Jan Kara <jack@suse.cz>, Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH 2/3] proportions: add @gfp to init functions
Message-ID: <20140826101929.GE1581@quack.suse.cz>
References: <1409013812-21700-1-git-send-email-tj@kernel.org>
 <1409013812-21700-3-git-send-email-tj@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1409013812-21700-3-git-send-email-tj@kernel.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon 25-08-14 20:43:31, Tejun Heo wrote:
> Percpu allocator now supports allocation mask.  Add @gfp to
> [flex_]proportions init functions so that !GFP_KERNEL allocation masks
> can be used with them too.
> 
> This patch doesn't make any functional difference.
  Looks good to me. You can add:
Reviewed-by: Jan Kara <jack@suse.cz>

								Honza

> 
> Signed-off-by: Tejun Heo <tj@kernel.org>
> Cc: Jan Kara <jack@suse.cz>
> Cc: Peter Zijlstra <peterz@infradead.org>
> ---
>  include/linux/flex_proportions.h |  5 +++--
>  include/linux/proportions.h      |  5 +++--
>  lib/flex_proportions.c           |  8 ++++----
>  lib/proportions.c                | 10 +++++-----
>  mm/backing-dev.c                 |  2 +-
>  mm/page-writeback.c              |  2 +-
>  6 files changed, 17 insertions(+), 15 deletions(-)
> 
> diff --git a/include/linux/flex_proportions.h b/include/linux/flex_proportions.h
> index 4ebc49f..0d348e0 100644
> --- a/include/linux/flex_proportions.h
> +++ b/include/linux/flex_proportions.h
> @@ -10,6 +10,7 @@
>  #include <linux/percpu_counter.h>
>  #include <linux/spinlock.h>
>  #include <linux/seqlock.h>
> +#include <linux/gfp.h>
>  
>  /*
>   * When maximum proportion of some event type is specified, this is the
> @@ -32,7 +33,7 @@ struct fprop_global {
>  	seqcount_t sequence;
>  };
>  
> -int fprop_global_init(struct fprop_global *p);
> +int fprop_global_init(struct fprop_global *p, gfp_t gfp);
>  void fprop_global_destroy(struct fprop_global *p);
>  bool fprop_new_period(struct fprop_global *p, int periods);
>  
> @@ -79,7 +80,7 @@ struct fprop_local_percpu {
>  	raw_spinlock_t lock;	/* Protect period and numerator */
>  };
>  
> -int fprop_local_init_percpu(struct fprop_local_percpu *pl);
> +int fprop_local_init_percpu(struct fprop_local_percpu *pl, gfp_t gfp);
>  void fprop_local_destroy_percpu(struct fprop_local_percpu *pl);
>  void __fprop_inc_percpu(struct fprop_global *p, struct fprop_local_percpu *pl);
>  void __fprop_inc_percpu_max(struct fprop_global *p, struct fprop_local_percpu *pl,
> diff --git a/include/linux/proportions.h b/include/linux/proportions.h
> index 26a8a4e..00e8e8f 100644
> --- a/include/linux/proportions.h
> +++ b/include/linux/proportions.h
> @@ -12,6 +12,7 @@
>  #include <linux/percpu_counter.h>
>  #include <linux/spinlock.h>
>  #include <linux/mutex.h>
> +#include <linux/gfp.h>
>  
>  struct prop_global {
>  	/*
> @@ -40,7 +41,7 @@ struct prop_descriptor {
>  	struct mutex mutex;		/* serialize the prop_global switch */
>  };
>  
> -int prop_descriptor_init(struct prop_descriptor *pd, int shift);
> +int prop_descriptor_init(struct prop_descriptor *pd, int shift, gfp_t gfp);
>  void prop_change_shift(struct prop_descriptor *pd, int new_shift);
>  
>  /*
> @@ -61,7 +62,7 @@ struct prop_local_percpu {
>  	raw_spinlock_t lock;		/* protect the snapshot state */
>  };
>  
> -int prop_local_init_percpu(struct prop_local_percpu *pl);
> +int prop_local_init_percpu(struct prop_local_percpu *pl, gfp_t gfp);
>  void prop_local_destroy_percpu(struct prop_local_percpu *pl);
>  void __prop_inc_percpu(struct prop_descriptor *pd, struct prop_local_percpu *pl);
>  void prop_fraction_percpu(struct prop_descriptor *pd, struct prop_local_percpu *pl,
> diff --git a/lib/flex_proportions.c b/lib/flex_proportions.c
> index b9d026b..8f25652 100644
> --- a/lib/flex_proportions.c
> +++ b/lib/flex_proportions.c
> @@ -34,13 +34,13 @@
>   */
>  #include <linux/flex_proportions.h>
>  
> -int fprop_global_init(struct fprop_global *p)
> +int fprop_global_init(struct fprop_global *p, gfp_t gfp)
>  {
>  	int err;
>  
>  	p->period = 0;
>  	/* Use 1 to avoid dealing with periods with 0 events... */
> -	err = percpu_counter_init(&p->events, 1, GFP_KERNEL);
> +	err = percpu_counter_init(&p->events, 1, gfp);
>  	if (err)
>  		return err;
>  	seqcount_init(&p->sequence);
> @@ -168,11 +168,11 @@ void fprop_fraction_single(struct fprop_global *p,
>   */
>  #define PROP_BATCH (8*(1+ilog2(nr_cpu_ids)))
>  
> -int fprop_local_init_percpu(struct fprop_local_percpu *pl)
> +int fprop_local_init_percpu(struct fprop_local_percpu *pl, gfp_t gfp)
>  {
>  	int err;
>  
> -	err = percpu_counter_init(&pl->events, 0, GFP_KERNEL);
> +	err = percpu_counter_init(&pl->events, 0, gfp);
>  	if (err)
>  		return err;
>  	pl->period = 0;
> diff --git a/lib/proportions.c b/lib/proportions.c
> index ca95f8d..6f72429 100644
> --- a/lib/proportions.c
> +++ b/lib/proportions.c
> @@ -73,7 +73,7 @@
>  #include <linux/proportions.h>
>  #include <linux/rcupdate.h>
>  
> -int prop_descriptor_init(struct prop_descriptor *pd, int shift)
> +int prop_descriptor_init(struct prop_descriptor *pd, int shift, gfp_t gfp)
>  {
>  	int err;
>  
> @@ -83,11 +83,11 @@ int prop_descriptor_init(struct prop_descriptor *pd, int shift)
>  	pd->index = 0;
>  	pd->pg[0].shift = shift;
>  	mutex_init(&pd->mutex);
> -	err = percpu_counter_init(&pd->pg[0].events, 0, GFP_KERNEL);
> +	err = percpu_counter_init(&pd->pg[0].events, 0, gfp);
>  	if (err)
>  		goto out;
>  
> -	err = percpu_counter_init(&pd->pg[1].events, 0, GFP_KERNEL);
> +	err = percpu_counter_init(&pd->pg[1].events, 0, gfp);
>  	if (err)
>  		percpu_counter_destroy(&pd->pg[0].events);
>  
> @@ -188,12 +188,12 @@ prop_adjust_shift(int *pl_shift, unsigned long *pl_period, int new_shift)
>  
>  #define PROP_BATCH (8*(1+ilog2(nr_cpu_ids)))
>  
> -int prop_local_init_percpu(struct prop_local_percpu *pl)
> +int prop_local_init_percpu(struct prop_local_percpu *pl, gfp_t gfp)
>  {
>  	raw_spin_lock_init(&pl->lock);
>  	pl->shift = 0;
>  	pl->period = 0;
> -	return percpu_counter_init(&pl->events, 0, GFP_KERNEL);
> +	return percpu_counter_init(&pl->events, 0, gfp);
>  }
>  
>  void prop_local_destroy_percpu(struct prop_local_percpu *pl)
> diff --git a/mm/backing-dev.c b/mm/backing-dev.c
> index f19a818..64ec49d 100644
> --- a/mm/backing-dev.c
> +++ b/mm/backing-dev.c
> @@ -470,7 +470,7 @@ int bdi_init(struct backing_dev_info *bdi)
>  	bdi->write_bandwidth = INIT_BW;
>  	bdi->avg_write_bandwidth = INIT_BW;
>  
> -	err = fprop_local_init_percpu(&bdi->completions);
> +	err = fprop_local_init_percpu(&bdi->completions, GFP_KERNEL);
>  
>  	if (err) {
>  err:
> diff --git a/mm/page-writeback.c b/mm/page-writeback.c
> index 91d73ef..5085994 100644
> --- a/mm/page-writeback.c
> +++ b/mm/page-writeback.c
> @@ -1777,7 +1777,7 @@ void __init page_writeback_init(void)
>  	writeback_set_ratelimit();
>  	register_cpu_notifier(&ratelimit_nb);
>  
> -	fprop_global_init(&writeout_completions);
> +	fprop_global_init(&writeout_completions, GFP_KERNEL);
>  }
>  
>  /**
> -- 
> 1.9.3
> 
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
