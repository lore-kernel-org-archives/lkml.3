Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753198AbbAEIpm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jan 2015 03:45:42 -0500
Received: from cantor2.suse.de ([195.135.220.15]:44604 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752003AbbAEIpk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jan 2015 03:45:40 -0500
Date: Mon, 5 Jan 2015 09:45:34 +0100
From: Jan Kara <jack@suse.cz>
To: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
Cc: Tejun Heo <tj@kernel.org>, Jan Kara <jack@suse.cz>,
        "David S. Miller" <davem@davemloft.net>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] lib: flex_proportions.c:  Remove some unused functions
Message-ID: <20150105084534.GA7056@quack.suse.cz>
References: <1419086431-3474-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1419086431-3474-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat 20-12-14 15:40:31, Rickard Strandqvist wrote:
> Removes some functions that are not used anywhere:
> prop_fraction_single() prop_local_destroy_single() prop_local_init_single() fprop_global_destroy()
> 
> This was partially found by using a static code analysis program called cppcheck.
  This is the same situation as with lib/proportions.c. The functions are
there for API completeness. As far as I'm looking the whole 'single'
section is unused so ifdeffing it out might make sense (and also ifdeffing
out fprop_inc_single() from include/linux/flex_proportions.h). Removing
fprop_global_destroy() is IMO pointless churn.

								Honza

> Signed-off-by: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
> ---
>  include/linux/flex_proportions.h |    6 -----
>  lib/flex_proportions.c           |   46 --------------------------------------
>  2 files changed, 52 deletions(-)
> 
> diff --git a/include/linux/flex_proportions.h b/include/linux/flex_proportions.h
> index 0d348e0..27ea6a1 100644
> --- a/include/linux/flex_proportions.h
> +++ b/include/linux/flex_proportions.h
> @@ -34,7 +34,6 @@ struct fprop_global {
>  };
>  
>  int fprop_global_init(struct fprop_global *p, gfp_t gfp);
> -void fprop_global_destroy(struct fprop_global *p);
>  bool fprop_new_period(struct fprop_global *p, int periods);
>  
>  /*
> @@ -52,12 +51,7 @@ struct fprop_local_single {
>  {	.lock = __RAW_SPIN_LOCK_UNLOCKED(name.lock),	\
>  }
>  
> -int fprop_local_init_single(struct fprop_local_single *pl);
> -void fprop_local_destroy_single(struct fprop_local_single *pl);
>  void __fprop_inc_single(struct fprop_global *p, struct fprop_local_single *pl);
> -void fprop_fraction_single(struct fprop_global *p,
> -	struct fprop_local_single *pl, unsigned long *numerator,
> -	unsigned long *denominator);
>  
>  static inline
>  void fprop_inc_single(struct fprop_global *p, struct fprop_local_single *pl)
> diff --git a/lib/flex_proportions.c b/lib/flex_proportions.c
> index 8f25652..575f9e1 100644
> --- a/lib/flex_proportions.c
> +++ b/lib/flex_proportions.c
> @@ -47,11 +47,6 @@ int fprop_global_init(struct fprop_global *p, gfp_t gfp)
>  	return 0;
>  }
>  
> -void fprop_global_destroy(struct fprop_global *p)
> -{
> -	percpu_counter_destroy(&p->events);
> -}
> -
>  /*
>   * Declare @periods new periods. It is upto the caller to make sure period
>   * transitions cannot happen in parallel.
> @@ -90,18 +85,6 @@ bool fprop_new_period(struct fprop_global *p, int periods)
>   * ---- SINGLE ----
>   */
>  
> -int fprop_local_init_single(struct fprop_local_single *pl)
> -{
> -	pl->events = 0;
> -	pl->period = 0;
> -	raw_spin_lock_init(&pl->lock);
> -	return 0;
> -}
> -
> -void fprop_local_destroy_single(struct fprop_local_single *pl)
> -{
> -}
> -
>  static void fprop_reflect_period_single(struct fprop_global *p,
>  					struct fprop_local_single *pl)
>  {
> @@ -134,35 +117,6 @@ void __fprop_inc_single(struct fprop_global *p, struct fprop_local_single *pl)
>  	percpu_counter_add(&p->events, 1);
>  }
>  
> -/* Return fraction of events of type pl */
> -void fprop_fraction_single(struct fprop_global *p,
> -			   struct fprop_local_single *pl,
> -			   unsigned long *numerator, unsigned long *denominator)
> -{
> -	unsigned int seq;
> -	s64 num, den;
> -
> -	do {
> -		seq = read_seqcount_begin(&p->sequence);
> -		fprop_reflect_period_single(p, pl);
> -		num = pl->events;
> -		den = percpu_counter_read_positive(&p->events);
> -	} while (read_seqcount_retry(&p->sequence, seq));
> -
> -	/*
> -	 * Make fraction <= 1 and denominator > 0 even in presence of percpu
> -	 * counter errors
> -	 */
> -	if (den <= num) {
> -		if (num)
> -			den = num;
> -		else
> -			den = 1;
> -	}
> -	*denominator = den;
> -	*numerator = num;
> -}
> -
>  /*
>   * ---- PERCPU ----
>   */
> -- 
> 1.7.10.4
> 
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
